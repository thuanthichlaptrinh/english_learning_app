# Training Model Trực Tiếp Từ Bảng user_vocab_progress

## Phân Tích Bảng user_vocab_progress

### Cấu trúc bảng

```sql
user_vocab_progress:
- id (UUID)
- user_id (UUID) → FK to users
- vocab_id (UUID) → FK to vocabs
- status (VocabStatus: NEW, KNOWN, UNKNOWN, MASTERED)
- times_correct (Integer) → Số lần trả lời đúng
- times_wrong (Integer) → Số lần trả lời sai
- repetition (Integer) → Số lần đã ôn tập
- ef_factor (Double) → Easiness Factor từ SM-2
- interval_days (Integer) → Khoảng cách ôn tập
- last_reviewed (LocalDate) → Lần ôn tập cuối
- next_review_date (LocalDate) → Ngày ôn tập tiếp theo
- created_at, updated_at
```

### Insight Quan Trọng

**Mỗi khi user chơi game:**
- 5-10 records được tạo/update trong `user_vocab_progress`
- Mỗi record chứa đầy đủ thông tin về tiến độ học

**Ví dụ:**
- 100 users × 20 games × 10 questions = **20,000 records**
- Mỗi record = 1 training sample! 🎉

## Chiến Lược Training

### Cách 1: Dự đoán Status Tiếp Theo (RECOMMENDED)

**Target:** Dự đoán status của vocab ở lần ôn tập tiếp theo

```
Current state → Predict → Next state
KNOWN → ? → UNKNOWN (forgot) hoặc KNOWN (remembered)
```

**Logic:**
- Nếu `times_wrong` tăng → User quên (forgot = 1)
- Nếu `times_correct` tăng → User nhớ (forgot = 0)

### Cách 2: Dự đoán Accuracy Rate

**Target:** Dự đoán `accuracy_rate` = times_correct / (times_correct + times_wrong)

**Logic:**
- Nếu accuracy_rate < 0.5 → Dễ quên
- Nếu accuracy_rate >= 0.5 → Dễ nhớ

### Cách 3: Dự đoán Overdue Probability

**Target:** Xác suất vocab sẽ overdue (quá hạn ôn tập)

**Logic:**
- Dựa vào `next_review_date` và pattern học tập
- Predict xem user có ôn đúng hạn không


## Implementation: Spring Boot API

### 1. Query Training Data Từ user_vocab_progress

```java
// UserVocabProgressRepository.java
@Query(value = """
    WITH user_stats AS (
        SELECT 
            u.id as user_id,
            COUNT(DISTINCT uvp.vocab_id) as total_vocabs,
            AVG(CASE 
                WHEN uvp.times_correct + uvp.times_wrong > 0 
                THEN uvp.times_correct::numeric / (uvp.times_correct + uvp.times_wrong)
                ELSE 0 
            END) as user_accuracy,
            u.current_streak,
            u.total_study_days
        FROM users u
        LEFT JOIN user_vocab_progress uvp ON u.id = uvp.user_id
        GROUP BY u.id
    )
    SELECT 
        uvp.id,
        uvp.user_id,
        uvp.vocab_id,
        v.word,
        
        -- User features
        us.total_vocabs as user_total_vocabs,
        us.user_accuracy,
        us.current_streak as user_streak,
        us.total_study_days,
        
        -- Vocab features
        CASE v.cefr 
            WHEN 'A1' THEN 1 WHEN 'A2' THEN 2 
            WHEN 'B1' THEN 3 WHEN 'B2' THEN 4 
            WHEN 'C1' THEN 5 WHEN 'C2' THEN 6 
            ELSE 3 
        END as vocab_difficulty,
        LENGTH(v.word) as vocab_length,
        COALESCE(t.name, 'Unknown') as topic_name,
        
        -- Progress features (CURRENT STATE)
        uvp.times_correct,
        uvp.times_wrong,
        CASE 
            WHEN uvp.times_correct + uvp.times_wrong > 0 
            THEN uvp.times_correct::numeric / (uvp.times_correct + uvp.times_wrong)
            ELSE 0 
        END as accuracy_rate,
        uvp.repetition,
        uvp.ef_factor,
        uvp.interval_days,
        uvp.status,
        
        -- Time features
        COALESCE(EXTRACT(DAY FROM (CURRENT_DATE - uvp.last_reviewed)), 999) as days_since_last_review,
        COALESCE(EXTRACT(DAY FROM (uvp.next_review_date - CURRENT_DATE)), 0) as days_until_next_review,
        CASE WHEN uvp.next_review_date < CURRENT_DATE THEN 1 ELSE 0 END as is_overdue,
        CASE 
            WHEN uvp.next_review_date < CURRENT_DATE 
            THEN EXTRACT(DAY FROM (CURRENT_DATE - uvp.next_review_date))
            ELSE 0 
        END as overdue_days,
        
        -- Temporal features
        EXTRACT(HOUR FROM uvp.updated_at) as hour_of_day,
        EXTRACT(DOW FROM uvp.updated_at) as day_of_week,
        CASE WHEN EXTRACT(DOW FROM uvp.updated_at) IN (0, 6) THEN 1 ELSE 0 END as is_weekend,
        
        -- TARGET: Dự đoán dựa trên accuracy_rate
        -- Nếu accuracy < 0.5 → Dễ quên (forgot = 1)
        -- Nếu accuracy >= 0.5 → Dễ nhớ (forgot = 0)
        CASE 
            WHEN uvp.times_correct + uvp.times_wrong = 0 THEN NULL
            WHEN uvp.times_correct::numeric / (uvp.times_correct + uvp.times_wrong) < 0.5 THEN 1
            ELSE 0
        END as forgot,
        
        -- Alternative target: Status-based
        CASE 
            WHEN uvp.status = 'UNKNOWN' THEN 1
            WHEN uvp.status IN ('KNOWN', 'MASTERED') THEN 0
            ELSE NULL
        END as forgot_by_status,
        
        uvp.created_at,
        uvp.updated_at
        
    FROM user_vocab_progress uvp
    JOIN vocabs v ON uvp.vocab_id = v.id
    LEFT JOIN topics t ON v.topic_id = t.id
    JOIN user_stats us ON uvp.user_id = us.user_id
    WHERE uvp.times_correct + uvp.times_wrong > 0  -- Chỉ lấy vocab đã có attempt
        AND uvp.status IN ('KNOWN', 'UNKNOWN', 'MASTERED')  -- Bỏ qua NEW
        AND uvp.updated_at >= CURRENT_DATE - INTERVAL '6 months'
    ORDER BY uvp.updated_at DESC
    """, nativeQuery = true)
List<Object[]> getTrainingDataFromProgress();
```

**Giải thích Target:**

1. **`forgot` (accuracy-based)**: 
   - Nếu accuracy_rate < 0.5 → forgot = 1 (dễ quên)
   - Nếu accuracy_rate >= 0.5 → forgot = 0 (dễ nhớ)

2. **`forgot_by_status` (status-based)**:
   - UNKNOWN → forgot = 1
   - KNOWN/MASTERED → forgot = 0

**Ưu điểm:**
- ✅ Không cần `game_session_details`
- ✅ Dữ liệu sẵn có trong `user_vocab_progress`
- ✅ Mỗi record = 1 training sample
- ✅ Target rõ ràng dựa trên accuracy hoặc status


### 2. Service & Controller (Giống như trước)

```java
// TrainingDataService.java
@Service
@RequiredArgsConstructor
@Slf4j
public class TrainingDataService {
    
    private final UserVocabProgressRepository userVocabProgressRepository;
    
    @Transactional(readOnly = true)
    public TrainingDataExportResponse exportTrainingData() {
        log.info("Exporting training data from user_vocab_progress...");
        
        List<Object[]> rawData = userVocabProgressRepository.getTrainingDataFromProgress();
        
        log.info("Retrieved {} records from user_vocab_progress", rawData.size());
        
        List<TrainingDataRecord> records = rawData.stream()
            .map(this::mapToTrainingDataRecord)
            .filter(r -> r.getForgot() != null)  // Chỉ lấy records có target
            .collect(Collectors.toList());
        
        DataStatistics stats = calculateStatistics(records);
        
        return TrainingDataExportResponse.builder()
            .records(records)
            .totalRecords(records.size())
            .exportedAt(LocalDateTime.now())
            .dataVersion("1.0.0")
            .statistics(stats)
            .build();
    }
    
    private TrainingDataRecord mapToTrainingDataRecord(Object[] row) {
        int i = 0;
        return TrainingDataRecord.builder()
            .userId(row[i++].toString())
            .vocabId(row[i++].toString())
            .word((String) row[i++])
            .userTotalVocabs(((Number) row[i++]).intValue())
            .userAccuracy(((Number) row[i++]).doubleValue())
            .userStreak(row[i] != null ? ((Number) row[i]).intValue() : 0); i++;
            .userTotalStudyDays(row[i] != null ? ((Number) row[i]).intValue() : 0); i++;
            .vocabDifficulty(((Number) row[i++]).intValue())
            .vocabLength(((Number) row[i++]).intValue())
            .topicName((String) row[i++])
            .timesCorrect(((Number) row[i++]).intValue())
            .timesWrong(((Number) row[i++]).intValue())
            .accuracyRate(((Number) row[i++]).doubleValue())
            .repetition(((Number) row[i++]).intValue())
            .efFactor(((Number) row[i++]).doubleValue())
            .intervalDays(((Number) row[i++]).intValue())
            .status((String) row[i++])
            .daysSinceLastReview(((Number) row[i++]).intValue())
            .daysUntilNextReview(((Number) row[i++]).intValue())
            .isOverdue(((Number) row[i++]).intValue())
            .overdueDays(((Number) row[i++]).intValue())
            .hourOfDay(((Number) row[i++]).intValue())
            .dayOfWeek(((Number) row[i++]).intValue())
            .isWeekend(((Number) row[i++]).intValue())
            .forgot(row[i] != null ? ((Number) row[i]).intValue() : null); i++;
            .recordedAt(((java.sql.Timestamp) row[i++]).toLocalDateTime())
            .build();
    }
}
```


## Python Training Script (Simplified)

```python
# train_from_progress.py
import requests
import pandas as pd
import numpy as np
import xgboost as xgb
from sklearn.model_selection import train_test_split
from sklearn.metrics import roc_auc_score, classification_report
import joblib

class ProgressBasedTrainer:
    def __init__(self, api_url, admin_token):
        self.api_url = api_url
        self.admin_token = admin_token
        self.feature_columns = [
            'user_total_vocabs', 'user_accuracy', 'user_streak', 'user_total_study_days',
            'vocab_difficulty', 'vocab_length',
            'times_correct', 'times_wrong', 'accuracy_rate',
            'repetition', 'ef_factor', 'interval_days',
            'days_since_last_review', 'days_until_next_review',
            'is_overdue', 'overdue_days',
            'hour_of_day', 'day_of_week', 'is_weekend'
        ]
    
    def fetch_data(self):
        """
        Fetch training data từ Spring Boot API
        """
        print("🔄 Fetching data from user_vocab_progress...")
        
        url = f"{self.api_url}/api/v1/training-data/export"
        headers = {'Authorization': f'Bearer {self.admin_token}'}
        
        response = requests.get(url, headers=headers, timeout=60)
        response.raise_for_status()
        
        data = response.json()
        records = data['data']['records']
        stats = data['data']['statistics']
        
        print(f"✅ Fetched {len(records)} records")
        print(f"📊 Forgot rate: {stats['forgotRate']:.2%}")
        
        df = pd.DataFrame(records)
        return df
    
    def train(self, df):
        """
        Train XGBoost model
        """
        print("\n🤖 Training model...")
        
        # Prepare data
        X = df[self.feature_columns]
        y = df['forgot']
        
        # Remove rows with null target
        mask = y.notna()
        X = X[mask]
        y = y[mask]
        
        print(f"Training samples: {len(X)}")
        print(f"Target distribution:\n{y.value_counts()}")
        
        # Split
        X_train, X_test, y_train, y_test = train_test_split(
            X, y, test_size=0.2, random_state=42, stratify=y
        )
        
        # Calculate scale_pos_weight
        scale_pos_weight = (y_train == 0).sum() / (y_train == 1).sum()
        print(f"Scale pos weight: {scale_pos_weight:.2f}")
        
        # Train
        model = xgb.XGBClassifier(
            n_estimators=200,
            max_depth=6,
            learning_rate=0.1,
            subsample=0.8,
            colsample_bytree=0.8,
            min_child_weight=3,
            gamma=0.1,
            reg_alpha=0.1,
            reg_lambda=1.0,
            scale_pos_weight=scale_pos_weight,
            objective='binary:logistic',
            eval_metric='auc',
            random_state=42,
            n_jobs=-1
        )
        
        model.fit(
            X_train, y_train,
            eval_set=[(X_test, y_test)],
            early_stopping_rounds=20,
            verbose=10
        )
        
        # Evaluate
        y_pred_proba = model.predict_proba(X_test)[:, 1]
        y_pred = (y_pred_proba > 0.5).astype(int)
        
        auc = roc_auc_score(y_test, y_pred_proba)
        
        print(f"\n✅ Training completed!")
        print(f"🎯 AUC-ROC: {auc:.4f}")
        print(f"\n📊 Classification Report:")
        print(classification_report(y_test, y_pred, 
                                   target_names=['Remembered', 'Forgot']))
        
        return model, auc
    
    def save_model(self, model):
        """
        Save model
        """
        import os
        os.makedirs('models', exist_ok=True)
        
        joblib.dump(model, 'models/smart_review_model.pkl')
        joblib.dump(self.feature_columns, 'models/feature_columns.pkl')
        
        print(f"💾 Model saved to models/smart_review_model.pkl")

# Main
if __name__ == "__main__":
    print("=" * 60)
    print("🚀 Training from user_vocab_progress")
    print("=" * 60)
    
    # Config
    API_URL = "http://localhost:8080"
    ADMIN_TOKEN = "your_admin_jwt_token"
    
    # Train
    trainer = ProgressBasedTrainer(API_URL, ADMIN_TOKEN)
    df = trainer.fetch_data()
    
    # Check minimum samples
    if len(df) < 100:
        print(f"\n⚠️  Only {len(df)} samples!")
        print("Need at least 100 samples to train.")
        exit(1)
    
    model, auc = trainer.train(df)
    trainer.save_model(model)
    
    print("\n" + "=" * 60)
    print(f"✅ Training completed! AUC: {auc:.4f}")
    print("=" * 60)
```


## Ví Dụ Dữ Liệu Training

### Sample Record từ user_vocab_progress

```json
{
  "userId": "user-123",
  "vocabId": "vocab-456",
  "word": "abandon",
  
  "userTotalVocabs": 50,
  "userAccuracy": 0.75,
  "userStreak": 5,
  "userTotalStudyDays": 20,
  
  "vocabDifficulty": 4,
  "vocabLength": 7,
  "topicName": "Daily Life",
  
  "timesCorrect": 3,
  "timesWrong": 7,
  "accuracyRate": 0.3,
  "repetition": 5,
  "efFactor": 1.8,
  "intervalDays": 2,
  "status": "UNKNOWN",
  
  "daysSinceLastReview": 3,
  "daysUntilNextReview": -1,
  "isOverdue": 1,
  "overdueDays": 1,
  
  "hourOfDay": 14,
  "dayOfWeek": 3,
  "isWeekend": 0,
  
  "forgot": 1,
  "recordedAt": "2024-11-15T14:30:00"
}
```

**Giải thích:**
- User đã trả lời đúng 3 lần, sai 7 lần → accuracy = 0.3 → **forgot = 1** (dễ quên)
- Status = UNKNOWN → Xác nhận user chưa thuộc từ này
- Overdue 1 ngày → Cần ôn tập gấp

### Ước Tính Số Lượng Data

**Scenario thực tế:**
- 100 users
- Mỗi user chơi 20 games
- Mỗi game có 10 questions
- → 100 × 20 × 10 = **20,000 vocab interactions**
- → Mỗi vocab được chơi trung bình 2-3 lần
- → **~10,000 unique user_vocab_progress records** ✅

**Đủ để train model tốt!**


## So Sánh 2 Cách Định Nghĩa Target

### Cách 1: Accuracy-Based (RECOMMENDED)

```sql
CASE 
    WHEN times_correct + times_wrong = 0 THEN NULL
    WHEN times_correct::numeric / (times_correct + times_wrong) < 0.5 THEN 1
    ELSE 0
END as forgot
```

**Ưu điểm:**
- ✅ Dựa trên performance thực tế
- ✅ Continuous metric (accuracy rate)
- ✅ Phản ánh đúng khả năng nhớ/quên

**Nhược điểm:**
- ❌ Threshold 0.5 có thể không optimal cho mọi user

### Cách 2: Status-Based

```sql
CASE 
    WHEN status = 'UNKNOWN' THEN 1
    WHEN status IN ('KNOWN', 'MASTERED') THEN 0
    ELSE NULL
END as forgot_by_status
```

**Ưu điểm:**
- ✅ Đơn giản, rõ ràng
- ✅ Align với business logic

**Nhược điểm:**
- ❌ Status có thể không chính xác 100%
- ❌ Không phản ánh gradient (KNOWN vs MASTERED)

### Khuyến Nghị

**Dùng Accuracy-Based** vì:
1. Phản ánh chính xác performance
2. Có thể tune threshold (0.4, 0.5, 0.6)
3. Model học được pattern tốt hơn

**Code:**
```python
# Có thể thử nhiều threshold
thresholds = [0.4, 0.5, 0.6]

for threshold in thresholds:
    df['forgot'] = (df['accuracy_rate'] < threshold).astype(int)
    # Train and evaluate
    # ...
```


## Quick Start Guide

### Bước 1: Setup Spring Boot API

```bash
# 1. Add repository method vào UserVocabProgressRepository
# 2. Add TrainingDataService
# 3. Add TrainingDataController
# 4. Restart Spring Boot

./mvnw spring-boot:run
```

### Bước 2: Test API

```bash
# Login as admin
curl -X POST "http://localhost:8080/api/v1/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@example.com","password":"admin123"}'

# Get token from response
export ADMIN_TOKEN="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."

# Test export
curl -X GET "http://localhost:8080/api/v1/training-data/export" \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  | jq '.data.statistics'

# Expected output:
{
  "totalUsers": 50,
  "totalVocabs": 500,
  "forgotCount": 1200,
  "rememberedCount": 2800,
  "forgotRate": 0.3,
  ...
}
```

### Bước 3: Train Model

```bash
# Install dependencies
pip install pandas numpy xgboost scikit-learn requests joblib

# Update token in script
# Edit train_from_progress.py:
# ADMIN_TOKEN = "your_actual_token_here"

# Run training
python train_from_progress.py

# Expected output:
# 🔄 Fetching data from user_vocab_progress...
# ✅ Fetched 4000 records
# 📊 Forgot rate: 30.00%
# 🤖 Training model...
# Training samples: 4000
# ...
# ✅ Training completed!
# 🎯 AUC-ROC: 0.8234
# 💾 Model saved to models/smart_review_model.pkl
```

### Bước 4: Verify Model

```bash
# Check model file
ls -lh models/

# Expected:
# smart_review_model.pkl (20-30 MB)
# feature_columns.pkl (< 1 KB)
```

## Kết Luận

**Ưu điểm của cách này:**
- ✅ **Đơn giản**: Chỉ cần query `user_vocab_progress`
- ✅ **Đủ data**: Mỗi record = 1 training sample
- ✅ **Target rõ ràng**: Dựa trên accuracy_rate hoặc status
- ✅ **Không phụ thuộc**: Không cần `game_session_details`
- ✅ **Scalable**: Dễ dàng thêm features mới

**Workflow hoàn chỉnh:**
```
user_vocab_progress (DB)
    ↓ Spring Boot API
Training Data (JSON)
    ↓ Python Script
XGBoost Model (PKL)
    ↓ FastAPI Service
Smart Recommendations
```

**Next Steps:**
1. ✅ Implement Spring Boot API
2. ✅ Test với data thật
3. ✅ Train model
4. ✅ Deploy FastAPI service
5. ✅ Integrate vào Smart Review API

