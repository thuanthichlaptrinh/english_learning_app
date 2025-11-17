# Implementation Guide - Smart Review API

## Bước 1: Thêm Method Vào UserVocabProgressRepository

Thêm method này vào cuối file `UserVocabProgressRepository.java` (trước dấu `}`):

```java
    // === TRAINING DATA EXPORT FOR ML MODEL ===
    /**
     * Lấy training data từ user_vocab_progress để train ML model
     * Target: forgot = 1 nếu accuracy_rate < 0.5, ngược lại forgot = 0
     */
    @Query(value = """
        WITH user_stats AS (
            SELECT 
                u.id as user_id,
                COUNT(DISTINCT uvp.vocab_id) as total_vocabs,
                COALESCE(AVG(CASE 
                    WHEN uvp.times_correct + uvp.times_wrong > 0 
                    THEN uvp.times_correct::numeric / (uvp.times_correct + uvp.times_wrong)
                    ELSE 0 
                END), 0) as user_accuracy,
                COALESCE(u.current_streak, 0) as current_streak,
                COALESCE(u.total_study_days, 0) as total_study_days
            FROM users u
            LEFT JOIN user_vocab_progress uvp ON u.id = uvp.user_id
            GROUP BY u.id, u.current_streak, u.total_study_days
        )
        SELECT 
            uvp.user_id::text,
            uvp.vocab_id::text,
            v.word,
            us.total_vocabs::integer as user_total_vocabs,
            us.user_accuracy::double precision,
            us.current_streak::integer as user_streak,
            us.total_study_days::integer,
            CASE v.cefr 
                WHEN 'A1' THEN 1 WHEN 'A2' THEN 2 
                WHEN 'B1' THEN 3 WHEN 'B2' THEN 4 
                WHEN 'C1' THEN 5 WHEN 'C2' THEN 6 
                ELSE 3 
            END::integer as vocab_difficulty,
            LENGTH(v.word)::integer as vocab_length,
            COALESCE(t.name, 'Unknown') as topic_name,
            uvp.times_correct::integer,
            uvp.times_wrong::integer,
            CASE 
                WHEN uvp.times_correct + uvp.times_wrong > 0 
                THEN (uvp.times_correct::numeric / (uvp.times_correct + uvp.times_wrong))::double precision
                ELSE 0::double precision
            END as accuracy_rate,
            uvp.repetition::integer,
            uvp.ef_factor::double precision,
            uvp.interval_days::integer,
            uvp.status::text,
            COALESCE(EXTRACT(DAY FROM (CURRENT_DATE - uvp.last_reviewed))::integer, 999) as days_since_last_review,
            COALESCE(EXTRACT(DAY FROM (uvp.next_review_date - CURRENT_DATE))::integer, 0) as days_until_next_review,
            CASE WHEN uvp.next_review_date < CURRENT_DATE THEN 1 ELSE 0 END::integer as is_overdue,
            CASE 
                WHEN uvp.next_review_date < CURRENT_DATE 
                THEN EXTRACT(DAY FROM (CURRENT_DATE - uvp.next_review_date))::integer
                ELSE 0 
            END::integer as overdue_days,
            EXTRACT(HOUR FROM uvp.updated_at)::integer as hour_of_day,
            EXTRACT(DOW FROM uvp.updated_at)::integer as day_of_week,
            CASE WHEN EXTRACT(DOW FROM uvp.updated_at) IN (0, 6) THEN 1 ELSE 0 END::integer as is_weekend,
            CASE 
                WHEN uvp.times_correct + uvp.times_wrong = 0 THEN NULL
                WHEN (uvp.times_correct::numeric / (uvp.times_correct + uvp.times_wrong)) < 0.5 THEN 1
                ELSE 0
            END::integer as forgot,
            uvp.updated_at
        FROM user_vocab_progress uvp
        JOIN vocabs v ON uvp.vocab_id = v.id
        LEFT JOIN topics t ON v.topic_id = t.id
        JOIN user_stats us ON uvp.user_id = us.user_id
        WHERE (uvp.times_correct + uvp.times_wrong) > 0
            AND uvp.status IN ('KNOWN', 'UNKNOWN', 'MASTERED')
            AND uvp.updated_at >= CURRENT_DATE - INTERVAL '6 months'
        ORDER BY uvp.updated_at DESC
        """, nativeQuery = true)
    List<Object[]> getTrainingDataFromProgress();
```

## Bước 2: Tạo TrainingDataService

Tạo file mới: `card-words/src/main/java/com/thuanthichlaptrinh/card_words/core/usecase/user/TrainingDataService.java`

```java
package com.thuanthichlaptrinh.card_words.core.usecase.user;

import com.thuanthichlaptrinh.card_words.dataprovider.repository.UserVocabProgressRepository;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.TrainingDataExportResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.TrainingDataExportResponse.DataStatistics;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.TrainingDataRecord;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class TrainingDataService {
    
    private final UserVocabProgressRepository userVocabProgressRepository;
    
    @Transactional(readOnly = true)
    public TrainingDataExportResponse exportTrainingData() {
        log.info("Starting training data export from user_vocab_progress...");
        
        // Get raw data from repository
        List<Object[]> rawData = userVocabProgressRepository.getTrainingDataFromProgress();
        
        log.info("Retrieved {} raw records", rawData.size());
        
        // Convert to DTOs
        List<TrainingDataRecord> records = rawData.stream()
            .map(this::mapToTrainingDataRecord)
            .filter(r -> r.getForgot() != null)  // Only records with target
            .collect(Collectors.toList());
        
        // Calculate statistics
        DataStatistics stats = calculateStatistics(records);
        
        log.info("Export completed: {} records, {} users, {} vocabs", 
                 records.size(), stats.getTotalUsers(), stats.getTotalVocabs());
        
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
        try {
            return TrainingDataRecord.builder()
                .userId((String) row[i++])
                .vocabId((String) row[i++])
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
                .recordedAt(((Timestamp) row[i++]).toLocalDateTime())
                .build();
        } catch (Exception e) {
            log.error("Error mapping row to TrainingDataRecord: {}", e.getMessage());
            return null;
        }
    }
    
    private DataStatistics calculateStatistics(List<TrainingDataRecord> records) {
        Set<String> uniqueUsers = records.stream()
            .map(TrainingDataRecord::getUserId)
            .collect(Collectors.toSet());
        
        Set<String> uniqueVocabs = records.stream()
            .map(TrainingDataRecord::getVocabId)
            .collect(Collectors.toSet());
        
        long forgotCount = records.stream()
            .filter(r -> r.getForgot() != null && r.getForgot() == 1)
            .count();
        
        long rememberedCount = records.stream()
            .filter(r -> r.getForgot() != null && r.getForgot() == 0)
            .count();
        
        double forgotRate = (forgotCount + rememberedCount) > 0 
            ? (double) forgotCount / (forgotCount + rememberedCount) 
            : 0.0;
        
        LocalDate oldestRecord = records.stream()
            .map(r -> r.getRecordedAt().toLocalDate())
            .min(LocalDate::compareTo)
            .orElse(LocalDate.now());
        
        LocalDate newestRecord = records.stream()
            .map(r -> r.getRecordedAt().toLocalDate())
            .max(LocalDate::compareTo)
            .orElse(LocalDate.now());
        
        return DataStatistics.builder()
            .totalUsers(uniqueUsers.size())
            .totalVocabs(uniqueVocabs.size())
            .forgotCount((int) forgotCount)
            .rememberedCount((int) rememberedCount)
            .forgotRate(forgotRate)
            .oldestRecord(oldestRecord)
            .newestRecord(newestRecord)
            .build();
    }
}
```

Tiếp tục với Controller...

## Bước 3: Tạo TrainingDataController

Tạo file mới: `card-words/src/main/java/com/thuanthichlaptrinh/card_words/entrypoint/rest/v1/admin/TrainingDataController.java`

```java
package com.thuanthichlaptrinh.card_words.entrypoint.rest.v1.admin;

import com.thuanthichlaptrinh.card_words.core.usecase.user.TrainingDataService;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ApiResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.TrainingDataExportResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/training-data")
@RequiredArgsConstructor
@Tag(name = "Training Data", description = "API export dữ liệu training cho ML model")
public class TrainingDataController {
    
    private final TrainingDataService trainingDataService;
    
    @GetMapping("/export")
    @Operation(
        summary = "Export training data",
        description = "Lấy dữ liệu từ user_vocab_progress để train ML model",
        security = @SecurityRequirement(name = "Bearer Authentication")
    )
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<TrainingDataExportResponse>> exportTrainingData() {
        
        TrainingDataExportResponse response = trainingDataService.exportTrainingData();
        
        return ResponseEntity.ok(ApiResponse.success(
            String.format("Exported %d training records", response.getTotalRecords()),
            response
        ));
    }
    
    @GetMapping("/stats")
    @Operation(
        summary = "Get training data statistics",
        description = "Xem thống kê về dữ liệu training",
        security = @SecurityRequirement(name = "Bearer Authentication")
    )
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<TrainingDataExportResponse.DataStatistics>> getStatistics() {
        
        TrainingDataExportResponse data = trainingDataService.exportTrainingData();
        
        return ResponseEntity.ok(ApiResponse.success(
            "Training data statistics",
            data.getStatistics()
        ));
    }
}
```

## Bước 4: Test API

### 4.1 Restart Spring Boot

```bash
cd card-words
./mvnw spring-boot:run
```

### 4.2 Login as Admin

```bash
curl -X POST "http://localhost:8080/api/v1/auth/login" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@example.com",
    "password": "your_admin_password"
  }'
```

Lưu token từ response.

### 4.3 Test Export API

```bash
export ADMIN_TOKEN="your_jwt_token_here"

curl -X GET "http://localhost:8080/api/v1/training-data/export" \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  | jq '.'
```

### 4.4 Test Stats API

```bash
curl -X GET "http://localhost:8080/api/v1/training-data/stats" \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  | jq '.data'
```

Expected output:
```json
{
  "totalUsers": 50,
  "totalVocabs": 500,
  "forgotCount": 1200,
  "rememberedCount": 2800,
  "forgotRate": 0.3,
  "oldestRecord": "2024-05-01",
  "newestRecord": "2024-11-17"
}
```

## Bước 5: Python Training Script

Tạo file: `train_model.py`

```python
import requests
import pandas as pd
import numpy as np
import xgboost as xgb
from sklearn.model_selection import train_test_split
from sklearn.metrics import roc_auc_score, classification_report
import joblib
import os

# Configuration
API_URL = "http://localhost:8080"
ADMIN_TOKEN = "your_admin_jwt_token_here"  # Update this!

# Feature columns
FEATURE_COLUMNS = [
    'user_total_vocabs', 'user_accuracy', 'user_streak', 'user_total_study_days',
    'vocab_difficulty', 'vocab_length',
    'times_correct', 'times_wrong', 'accuracy_rate',
    'repetition', 'ef_factor', 'interval_days',
    'days_since_last_review', 'days_until_next_review',
    'is_overdue', 'overdue_days',
    'hour_of_day', 'day_of_week', 'is_weekend'
]

def fetch_training_data():
    """Fetch training data from Spring Boot API"""
    print("🔄 Fetching training data from API...")
    
    url = f"{API_URL}/api/v1/training-data/export"
    headers = {'Authorization': f'Bearer {ADMIN_TOKEN}'}
    
    response = requests.get(url, headers=headers, timeout=60)
    response.raise_for_status()
    
    data = response.json()
    
    if not data['success']:
        raise Exception(f"API error: {data.get('message', 'Unknown error')}")
    
    records = data['data']['records']
    stats = data['data']['statistics']
    
    print(f"✅ Fetched {len(records)} records")
    print(f"📊 Statistics:")
    print(f"   - Total users: {stats['totalUsers']}")
    print(f"   - Total vocabs: {stats['totalVocabs']}")
    print(f"   - Forgot count: {stats['forgotCount']}")
    print(f"   - Remembered count: {stats['rememberedCount']}")
    print(f"   - Forgot rate: {stats['forgotRate']:.2%}")
    
    df = pd.DataFrame(records)
    return df, stats

def train_model(df):
    """Train XGBoost model"""
    print("\n🤖 Training XGBoost model...")
    
    # Prepare data
    X = df[FEATURE_COLUMNS]
    y = df['forgot']
    
    # Remove null targets
    mask = y.notna()
    X = X[mask]
    y = y[mask]
    
    print(f"Training samples: {len(X)}")
    print(f"Target distribution:\n{y.value_counts()}")
    
    if len(X) < 100:
        print(f"\n⚠️  Warning: Only {len(X)} samples!")
        print("Recommended minimum: 1000 samples")
        return None, 0
    
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
    print(classification_report(y_test, y_pred, target_names=['Remembered', 'Forgot']))
    
    return model, auc

def save_model(model):
    """Save trained model"""
    os.makedirs('models', exist_ok=True)
    
    joblib.dump(model, 'models/smart_review_model.pkl')
    joblib.dump(FEATURE_COLUMNS, 'models/feature_columns.pkl')
    
    print(f"💾 Model saved to models/smart_review_model.pkl")
    print(f"💾 Feature columns saved to models/feature_columns.pkl")

if __name__ == "__main__":
    print("=" * 60)
    print("🚀 Smart Review Model Training")
    print("=" * 60)
    
    # Fetch data
    df, stats = fetch_training_data()
    
    # Train
    model, auc = train_model(df)
    
    if model is not None:
        # Save
        save_model(model)
        
        print("\n" + "=" * 60)
        print(f"✅ Training completed! AUC: {auc:.4f}")
        print("=" * 60)
    else:
        print("\n❌ Training failed - not enough data")
```

## Bước 6: Run Training

```bash
# Install dependencies
pip install pandas numpy xgboost scikit-learn requests joblib

# Update ADMIN_TOKEN in train_model.py

# Run training
python train_model.py
```

## Troubleshooting

### Lỗi: "Method not found"
- Kiểm tra đã thêm method `getTrainingDataFromProgress()` vào repository chưa
- Restart Spring Boot

### Lỗi: "Unauthorized"
- Kiểm tra ADMIN_TOKEN có đúng không
- Kiểm tra user có role ADMIN không

### Lỗi: "Not enough data"
- Cần ít nhất 100 samples để train
- Chơi thêm games để tạo data trong `user_vocab_progress`

### Lỗi SQL
- Kiểm tra database là PostgreSQL
- Kiểm tra các bảng `users`, `user_vocab_progress`, `vocabs`, `topics` tồn tại

## Next Steps

Sau khi train xong model:
1. Deploy FastAPI service để serve model
2. Integrate vào Smart Review API
3. A/B testing với rule-based approach
4. Monitor performance và retrain định kỳ
