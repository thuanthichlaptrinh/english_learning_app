# Training Model Từ Bảng user_vocab_progress

## Flow Tổng Quan

```
┌─────────────────────────────────────────────────────────────┐
│                    Spring Boot Backend                       │
│  ┌────────────────────────────────────────────────────────┐ │
│  │  GET /api/v1/training-data/export                      │ │
│  │  - Query user_vocab_progress                           │ │
│  │  - Join với users, vocabs, game_session_details       │ │
│  │  - Return JSON với features + target                  │ │
│  └────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                            ↓ HTTP GET
┌─────────────────────────────────────────────────────────────┐
│                    Python Training Script                    │
│  ┌────────────────────────────────────────────────────────┐ │
│  │  1. Fetch data từ Spring Boot API                     │ │
│  │  2. Feature engineering                                │ │
│  │  3. Train XGBoost model                                │ │
│  │  4. Save model → models/smart_review_model.pkl        │ │
│  └────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                    FastAPI AI Service                        │
│  - Load model                                                │
│  - Serve predictions                                         │
└─────────────────────────────────────────────────────────────┘
```

## 1. Spring Boot: Export Training Data API

### 1.1 DTO Classes

```java
// TrainingDataRecord.java
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TrainingDataRecord {
    // User features
    private String userId;
    private Integer userTotalVocabs;
    private Double userAccuracy;
    private Integer userStreak;
    private Integer userTotalStudyDays;

    // Vocab features
    private String vocabId;
    private String word;
    private Integer vocabDifficulty;  // 1-6 (A1-C2)
    private Integer vocabLength;
    private String topicName;

    // Progress features
    private Integer timesCorrect;
    private Integer timesWrong;
    private Double accuracyRate;
    private Integer repetition;
    private Double efFactor;
    private Integer intervalDays;
    private Integer daysSinceLastReview;
    private Integer daysUntilNextReview;
    private Integer isOverdue;
    private Integer overdueDays;
    private String status;

    // Temporal features
    private Integer hourOfDay;
    private Integer dayOfWeek;
    private Integer isWeekend;

    // Target variable
    private Integer forgot;  // 0 = remembered, 1 = forgot

    // Metadata
    private LocalDateTime recordedAt;
}

// TrainingDataExportResponse.java
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TrainingDataExportResponse {
    private List<TrainingDataRecord> records;
    private Integer totalRecords;
    private LocalDateTime exportedAt;
    private String dataVersion;
    private DataStatistics statistics;

    @Data
    @Builder
    public static class DataStatistics {
        private Integer totalUsers;
        private Integer totalVocabs;
        private Integer forgotCount;
        private Integer rememberedCount;
        private Double forgotRate;
        private LocalDate oldestRecord;
        private LocalDate newestRecord;
    }
}
```

### 1.2 Repository Method

```java
// UserVocabProgressRepository.java
public interface UserVocabProgressRepository extends JpaRepository<UserVocabProgress, UUID> {

    /**
     * Lấy training data từ user_vocab_progress
     * Kết hợp với game_session_details để có target (forgot)
     */
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
        ),
        progress_with_next_attempt AS (
            SELECT
                uvp.id,
                uvp.user_id,
                uvp.vocab_id,
                uvp.times_correct,
                uvp.times_wrong,
                uvp.repetition,
                uvp.ef_factor,
                uvp.interval_days,
                uvp.last_reviewed,
                uvp.next_review_date,
                uvp.status,
                uvp.updated_at,
                v.word,
                v.cefr,
                LENGTH(v.word) as vocab_length,
                t.name as topic_name,
                -- Tìm lần chơi game TIẾP THEO sau khi update progress
                (
                    SELECT gsd.is_correct
                    FROM game_session_details gsd
                    JOIN game_sessions gs ON gsd.session_id = gs.id
                    WHERE gsd.vocab_id = uvp.vocab_id
                        AND gs.user_id = uvp.user_id
                        AND gsd.created_at > uvp.updated_at
                        AND gs.finished_at IS NOT NULL
                    ORDER BY gsd.created_at ASC
                    LIMIT 1
                ) as next_is_correct
            FROM user_vocab_progress uvp
            JOIN vocabs v ON uvp.vocab_id = v.id
            LEFT JOIN topics t ON v.topic_id = t.id
            WHERE uvp.status IN ('KNOWN', 'UNKNOWN', 'MASTERED')
                AND uvp.updated_at >= CURRENT_DATE - INTERVAL '6 months'
        )
        SELECT
            pna.user_id,
            pna.vocab_id,
            pna.word,
            us.total_vocabs as user_total_vocabs,
            us.user_accuracy,
            us.current_streak as user_streak,
            us.total_study_days,
            CASE pna.cefr
                WHEN 'A1' THEN 1 WHEN 'A2' THEN 2
                WHEN 'B1' THEN 3 WHEN 'B2' THEN 4
                WHEN 'C1' THEN 5 WHEN 'C2' THEN 6
                ELSE 3
            END as vocab_difficulty,
            pna.vocab_length,
            pna.topic_name,
            pna.times_correct,
            pna.times_wrong,
            CASE
                WHEN pna.times_correct + pna.times_wrong > 0
                THEN pna.times_correct::numeric / (pna.times_correct + pna.times_wrong)
                ELSE 0
            END as accuracy_rate,
            pna.repetition,
            pna.ef_factor,
            pna.interval_days,
            COALESCE(EXTRACT(DAY FROM (pna.updated_at::date - pna.last_reviewed)), 999) as days_since_last_review,
            COALESCE(EXTRACT(DAY FROM (pna.next_review_date - pna.updated_at::date)), 0) as days_until_next_review,
            CASE WHEN pna.next_review_date < pna.updated_at::date THEN 1 ELSE 0 END as is_overdue,
            CASE
                WHEN pna.next_review_date < pna.updated_at::date
                THEN EXTRACT(DAY FROM (pna.updated_at::date - pna.next_review_date))
                ELSE 0
            END as overdue_days,
            pna.status,
            EXTRACT(HOUR FROM pna.updated_at) as hour_of_day,
            EXTRACT(DOW FROM pna.updated_at) as day_of_week,
            CASE WHEN EXTRACT(DOW FROM pna.updated_at) IN (0, 6) THEN 1 ELSE 0 END as is_weekend,
            CASE
                WHEN pna.next_is_correct IS NULL THEN NULL
                WHEN pna.next_is_correct = false THEN 1
                ELSE 0
            END as forgot,
            pna.updated_at as recorded_at
        FROM progress_with_next_attempt pna
        JOIN user_stats us ON pna.user_id = us.user_id
        WHERE pna.next_is_correct IS NOT NULL
        ORDER BY pna.updated_at DESC
        """, nativeQuery = true)
    List<Object[]> getTrainingData();
}
```

### 1.3 Service Layer

```java
// TrainingDataService.java
@Service
@RequiredArgsConstructor
@Slf4j
public class TrainingDataService {

    private final UserVocabProgressRepository userVocabProgressRepository;
    private final UserRepository userRepository;

    @Transactional(readOnly = true)
    public TrainingDataExportResponse exportTrainingData() {
        log.info("Starting training data export...");

        // Get raw data from repository
        List<Object[]> rawData = userVocabProgressRepository.getTrainingData();

        log.info("Retrieved {} raw records", rawData.size());

        // Convert to DTOs
        List<TrainingDataRecord> records = rawData.stream()
            .map(this::mapToTrainingDataRecord)
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
        return TrainingDataRecord.builder()
            .userId(row[i++].toString())
            .vocabId(row[i++].toString())
            .word((String) row[i++])
            .userTotalVocabs(((Number) row[i++]).intValue())
            .userAccuracy(((Number) row[i++]).doubleValue())
            .userStreak(row[i++] != null ? ((Number) row[i++]).intValue() : 0)
            .userTotalStudyDays(row[i++] != null ? ((Number) row[i++]).intValue() : 0)
            .vocabDifficulty(((Number) row[i++]).intValue())
            .vocabLength(((Number) row[i++]).intValue())
            .topicName((String) row[i++])
            .timesCorrect(((Number) row[i++]).intValue())
            .timesWrong(((Number) row[i++]).intValue())
            .accuracyRate(((Number) row[i++]).doubleValue())
            .repetition(((Number) row[i++]).intValue())
            .efFactor(((Number) row[i++]).doubleValue())
            .intervalDays(((Number) row[i++]).intValue())
            .daysSinceLastReview(((Number) row[i++]).intValue())
            .daysUntilNextReview(((Number) row[i++]).intValue())
            .isOverdue(((Number) row[i++]).intValue())
            .overdueDays(((Number) row[i++]).intValue())
            .status((String) row[i++])
            .hourOfDay(((Number) row[i++]).intValue())
            .dayOfWeek(((Number) row[i++]).intValue())
            .isWeekend(((Number) row[i++]).intValue())
            .forgot(((Number) row[i++]).intValue())
            .recordedAt(((java.sql.Timestamp) row[i++]).toLocalDateTime())
            .build();
    }

    private DataStatistics calculateStatistics(List<TrainingDataRecord> records) {
        Set<String> uniqueUsers = records.stream()
            .map(TrainingDataRecord::getUserId)
            .collect(Collectors.toSet());

        Set<String> uniqueVocabs = records.stream()
            .map(TrainingDataRecord::getVocabId)
            .collect(Collectors.toSet());

        long forgotCount = records.stream()
            .filter(r -> r.getForgot() == 1)
            .count();

        long rememberedCount = records.size() - forgotCount;

        double forgotRate = records.isEmpty() ? 0.0 : (double) forgotCount / records.size();

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

### 1.4 Controller

```java
// TrainingDataController.java
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
    @PreAuthorize("hasRole('ADMIN')")  // Chỉ admin mới export được
    public ResponseEntity<ApiResponse<TrainingDataExportResponse>> exportTrainingData() {

        TrainingDataExportResponse response = trainingDataService.exportTrainingData();

        return ResponseEntity.ok(ApiResponse.success(
            String.format("Exported %d training records", response.getTotalRecords()),
            response
        ));
    }

    @GetMapping("/export/csv")
    @Operation(
        summary = "Export training data as CSV",
        description = "Download dữ liệu training dạng CSV file",
        security = @SecurityRequirement(name = "Bearer Authentication")
    )
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Resource> exportTrainingDataCsv() throws IOException {

        TrainingDataExportResponse data = trainingDataService.exportTrainingData();

        // Convert to CSV
        StringBuilder csv = new StringBuilder();

        // Header
        csv.append("user_id,vocab_id,word,user_total_vocabs,user_accuracy,user_streak,")
           .append("user_total_study_days,vocab_difficulty,vocab_length,topic_name,")
           .append("times_correct,times_wrong,accuracy_rate,repetition,ef_factor,")
           .append("interval_days,days_since_last_review,days_until_next_review,")
           .append("is_overdue,overdue_days,status,hour_of_day,day_of_week,")
           .append("is_weekend,forgot,recorded_at\n");

        // Data rows
        for (TrainingDataRecord record : data.getRecords()) {
            csv.append(String.format("%s,%s,%s,%d,%.4f,%d,%d,%d,%d,%s,%d,%d,%.4f,%d,%.2f,%d,%d,%d,%d,%d,%s,%d,%d,%d,%d,%s\n",
                record.getUserId(),
                record.getVocabId(),
                record.getWord(),
                record.getUserTotalVocabs(),
                record.getUserAccuracy(),
                record.getUserStreak(),
                record.getUserTotalStudyDays(),
                record.getVocabDifficulty(),
                record.getVocabLength(),
                record.getTopicName() != null ? record.getTopicName() : "",
                record.getTimesCorrect(),
                record.getTimesWrong(),
                record.getAccuracyRate(),
                record.getRepetition(),
                record.getEfFactor(),
                record.getIntervalDays(),
                record.getDaysSinceLastReview(),
                record.getDaysUntilNextReview(),
                record.getIsOverdue(),
                record.getOverdueDays(),
                record.getStatus(),
                record.getHourOfDay(),
                record.getDayOfWeek(),
                record.getIsWeekend(),
                record.getForgot(),
                record.getRecordedAt()
            ));
        }

        // Create resource
        ByteArrayResource resource = new ByteArrayResource(csv.toString().getBytes());

        String filename = String.format("training_data_%s.csv",
            LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss")));

        return ResponseEntity.ok()
            .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + filename + "\"")
            .contentType(MediaType.parseMediaType("text/csv"))
            .body(resource);
    }

    @GetMapping("/stats")
    @Operation(
        summary = "Get training data statistics",
        description = "Xem thống kê về dữ liệu training",
        security = @SecurityRequirement(name = "Bearer Authentication")
    )
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<DataStatistics>> getStatistics() {

        TrainingDataExportResponse data = trainingDataService.exportTrainingData();

        return ResponseEntity.ok(ApiResponse.success(
            "Training data statistics",
            data.getStatistics()
        ));
    }
}
```

## 2. Python: Fetch Data & Train Model

### 2.1 Fetch Data Script

```python
# fetch_training_data.py
import requests
import pandas as pd
from datetime import datetime
import json

class TrainingDataFetcher:
    def __init__(self, api_url, admin_token):
        """
        api_url: URL của Spring Boot API (e.g., http://localhost:8080)
        admin_token: JWT token của admin user
        """
        self.api_url = api_url
        self.headers = {
            'Authorization': f'Bearer {admin_token}',
            'Content-Type': 'application/json'
        }

    def fetch_training_data(self):
        """
        Fetch training data từ Spring Boot API
        """
        print("🔄 Fetching training data from API...")

        url = f"{self.api_url}/api/v1/training-data/export"

        try:
            response = requests.get(url, headers=self.headers, timeout=60)
            response.raise_for_status()

            data = response.json()

            if not data['success']:
                raise Exception(f"API error: {data.get('message', 'Unknown error')}")

            # Extract records
            records = data['data']['records']
            stats = data['data']['statistics']

            print(f"✅ Fetched {len(records)} records")
            print(f"📊 Statistics:")
            print(f"   - Total users: {stats['totalUsers']}")
            print(f"   - Total vocabs: {stats['totalVocabs']}")
            print(f"   - Forgot count: {stats['forgotCount']}")
            print(f"   - Remembered count: {stats['rememberedCount']}")
            print(f"   - Forgot rate: {stats['forgotRate']:.2%}")
            print(f"   - Date range: {stats['oldestRecord']} to {stats['newestRecord']}")

            # Convert to DataFrame
            df = pd.DataFrame(records)

            return df, stats

        except requests.exceptions.RequestException as e:
            print(f"❌ Error fetching data: {e}")
            raise

    def save_to_csv(self, df, filename=None):
        """
        Save DataFrame to CSV
        """
        if filename is None:
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            filename = f"training_data_{timestamp}.csv"

        df.to_csv(filename, index=False)
        print(f"💾 Saved to {filename}")

        return filename

# Usage
if __name__ == "__main__":
    # Configuration
    API_URL = "http://localhost:8080"
    ADMIN_TOKEN = "your_admin_jwt_token_here"

    # Fetch data
    fetcher = TrainingDataFetcher(API_URL, ADMIN_TOKEN)
    df, stats = fetcher.fetch_training_data()

    # Save to CSV
    filename = fetcher.save_to_csv(df)

    print(f"\n✅ Training data ready: {filename}")
    print(f"📈 Shape: {df.shape}")
    print(f"\n🔍 Sample data:")
    print(df.head())
```

### 2.2 Training Script

```python
# train_model.py
import pandas as pd
import numpy as np
import xgboost as xgb
from sklearn.model_selection import train_test_split
from sklearn.metrics import roc_auc_score, classification_report, confusion_matrix
import joblib
import matplotlib.pyplot as plt
from fetch_training_data import TrainingDataFetcher

class SmartReviewModelTrainer:
    def __init__(self):
        self.model = None
        self.feature_columns = [
            'user_total_vocabs', 'user_accuracy', 'user_streak', 'user_total_study_days',
            'vocab_difficulty', 'vocab_length',
            'times_correct', 'times_wrong', 'accuracy_rate',
            'repetition', 'ef_factor', 'interval_days',
            'days_since_last_review', 'days_until_next_review',
            'is_overdue', 'overdue_days',
            'hour_of_day', 'day_of_week', 'is_weekend'
        ]

    def prepare_data(self, df):
        """
        Prepare features and target
        """
        print("\n📊 Preparing data...")

        # Check for missing values
        print(f"Missing values:\n{df[self.feature_columns + ['forgot']].isnull().sum()}")

        # Fill missing values if any
        df = df.fillna({
            'user_streak': 0,
            'user_total_study_days': 0,
            'topic_name': 'Unknown'
        })

        # Features and target
        X = df[self.feature_columns]
        y = df['forgot']

        print(f"✅ Features shape: {X.shape}")
        print(f"✅ Target distribution:")
        print(y.value_counts())
        print(f"   Forgot rate: {y.mean():.2%}")

        return X, y

    def train(self, X, y):
        """
        Train XGBoost model
        """
        print("\n🤖 Training XGBoost model...")

        # Split data
        X_train, X_test, y_train, y_test = train_test_split(
            X, y, test_size=0.2, random_state=42, stratify=y
        )

        print(f"Train set: {X_train.shape[0]} samples")
        print(f"Test set: {X_test.shape[0]} samples")

        # Calculate scale_pos_weight for imbalanced data
        neg_count = (y_train == 0).sum()
        pos_count = (y_train == 1).sum()
        scale_pos_weight = neg_count / pos_count

        print(f"Scale pos weight: {scale_pos_weight:.2f}")

        # Train model
        self.model = xgb.XGBClassifier(
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

        self.model.fit(
            X_train, y_train,
            eval_set=[(X_test, y_test)],
            early_stopping_rounds=20,
            verbose=10
        )

        # Evaluate
        y_pred_proba = self.model.predict_proba(X_test)[:, 1]
        y_pred = (y_pred_proba > 0.5).astype(int)

        auc_score = roc_auc_score(y_test, y_pred_proba)

        print(f"\n✅ Training completed!")
        print(f"🎯 AUC-ROC: {auc_score:.4f}")
        print(f"\n📊 Classification Report:")
        print(classification_report(y_test, y_pred,
                                   target_names=['Remembered', 'Forgot']))
        print(f"\n📊 Confusion Matrix:")
        print(confusion_matrix(y_test, y_pred))

        return self.model, auc_score

    def plot_feature_importance(self, top_n=15):
        """
        Plot feature importance
        """
        if self.model is None:
            print("❌ Model not trained yet!")
            return

        importance = self.model.feature_importances_
        feature_importance_df = pd.DataFrame({
            'feature': self.feature_columns,
            'importance': importance
        }).sort_values('importance', ascending=False)

        plt.figure(figsize=(10, 8))
        plt.barh(feature_importance_df['feature'][:top_n],
                 feature_importance_df['importance'][:top_n])
        plt.xlabel('Importance')
        plt.title(f'Top {top_n} Most Important Features')
        plt.tight_layout()
        plt.savefig('feature_importance.png')
        print(f"💾 Saved feature importance plot to feature_importance.png")

        print(f"\n📊 Top {top_n} Features:")
        print(feature_importance_df.head(top_n))

    def save_model(self, filename='models/smart_review_model.pkl'):
        """
        Save trained model
        """
        if self.model is None:
            print("❌ Model not trained yet!")
            return

        import os
        os.makedirs(os.path.dirname(filename), exist_ok=True)

        joblib.dump(self.model, filename)
        joblib.dump(self.feature_columns, 'models/feature_columns.pkl')

        print(f"💾 Model saved to {filename}")
        print(f"💾 Feature columns saved to models/feature_columns.pkl")

# Main training pipeline
if __name__ == "__main__":
    print("=" * 60)
    print("🚀 Smart Review Model Training Pipeline")
    print("=" * 60)

    # Step 1: Fetch data from API
    API_URL = "http://localhost:8080"
    ADMIN_TOKEN = "your_admin_jwt_token_here"

    fetcher = TrainingDataFetcher(API_URL, ADMIN_TOKEN)
    df, stats = fetcher.fetch_training_data()

    # Check if we have enough data
    MIN_SAMPLES = 1000
    if len(df) < MIN_SAMPLES:
        print(f"\n⚠️  Warning: Only {len(df)} samples available.")
        print(f"   Recommended minimum: {MIN_SAMPLES} samples")
        print(f"   Model may not perform well with limited data.")

        response = input("\nContinue training anyway? (y/n): ")
        if response.lower() != 'y':
            print("❌ Training cancelled.")
            exit()

    # Step 2: Train model
    trainer = SmartReviewModelTrainer()
    X, y = trainer.prepare_data(df)
    model, auc_score = trainer.train(X, y)

    # Step 3: Plot feature importance
    trainer.plot_feature_importance()

    # Step 4: Save model
    trainer.save_model()

    print("\n" + "=" * 60)
    print("✅ Training pipeline completed!")
    print(f"🎯 Final AUC-ROC: {auc_score:.4f}")
    print("=" * 60)
```

### 2.3 Requirements

```txt
# requirements.txt
pandas==2.1.3
numpy==1.26.2
xgboost==2.0.3
scikit-learn==1.3.2
requests==2.31.0
joblib==1.3.2
matplotlib==3.8.2
```

## 3. Usage Guide

### 3.1 Lấy Admin Token

```bash
# Login as admin
curl -X POST "http://localhost:8080/api/v1/auth/login" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@example.com",
    "password": "admin_password"
  }'

# Response sẽ có token
{
  "success": true,
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": {...}
  }
}
```

### 3.2 Test API Export

```bash
# Test export API
curl -X GET "http://localhost:8080/api/v1/training-data/export" \
  -H "Authorization: Bearer YOUR_ADMIN_TOKEN" \
  | jq '.data.statistics'

# Expected output:
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

### 3.3 Download CSV

```bash
# Download training data as CSV
curl -X GET "http://localhost:8080/api/v1/training-data/export/csv" \
  -H "Authorization: Bearer YOUR_ADMIN_TOKEN" \
  -o training_data.csv

# Check file
head -5 training_data.csv
wc -l training_data.csv
```

### 3.4 Run Training

```bash
# Install dependencies
pip install -r requirements.txt

# Run training script
python train_model.py

# Expected output:
# 🔄 Fetching training data from API...
# ✅ Fetched 4000 records
# 📊 Statistics:
#    - Total users: 50
#    - Total vocabs: 500
#    ...
# 🤖 Training XGBoost model...
# ...
# ✅ Training completed!
# 🎯 AUC-ROC: 0.8456
# 💾 Model saved to models/smart_review_model.pkl
```

## 4. Automated Training Pipeline

### 4.1 Shell Script

```bash
#!/bin/bash
# train_pipeline.sh

echo "=========================================="
echo "Smart Review Model Training Pipeline"
echo "=========================================="

# Configuration
API_URL="http://localhost:8080"
ADMIN_EMAIL="admin@example.com"
ADMIN_PASSWORD="admin_password"
MODEL_DIR="models"
BACKUP_DIR="models/backup"

# Step 1: Login and get token
echo "🔐 Logging in as admin..."
LOGIN_RESPONSE=$(curl -s -X POST "${API_URL}/api/v1/auth/login" \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"${ADMIN_EMAIL}\",\"password\":\"${ADMIN_PASSWORD}\"}")

ADMIN_TOKEN=$(echo $LOGIN_RESPONSE | jq -r '.data.token')

if [ "$ADMIN_TOKEN" == "null" ] || [ -z "$ADMIN_TOKEN" ]; then
    echo "❌ Login failed!"
    exit 1
fi

echo "✅ Login successful"

# Step 2: Check data availability
echo ""
echo "📊 Checking training data..."
STATS=$(curl -s -X GET "${API_URL}/api/v1/training-data/stats" \
  -H "Authorization: Bearer ${ADMIN_TOKEN}")

TOTAL_RECORDS=$(echo $STATS | jq -r '.data.forgotCount + .data.rememberedCount')

echo "Total records available: ${TOTAL_RECORDS}"

if [ "$TOTAL_RECORDS" -lt 1000 ]; then
    echo "⚠️  Warning: Only ${TOTAL_RECORDS} records available"
    echo "   Recommended minimum: 1000 records"
    read -p "Continue anyway? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Training cancelled"
        exit 1
    fi
fi

# Step 3: Backup old model
echo ""
echo "💾 Backing up old model..."
mkdir -p $BACKUP_DIR
if [ -f "${MODEL_DIR}/smart_review_model.pkl" ]; then
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    cp "${MODEL_DIR}/smart_review_model.pkl" "${BACKUP_DIR}/smart_review_model_${TIMESTAMP}.pkl"
    echo "✅ Old model backed up"
else
    echo "ℹ️  No existing model to backup"
fi

# Step 4: Run training
echo ""
echo "🤖 Starting training..."
export API_URL
export ADMIN_TOKEN

python3 train_model.py

if [ $? -eq 0 ]; then
    echo ""
    echo "=========================================="
    echo "✅ Training pipeline completed successfully!"
    echo "=========================================="
else
    echo ""
    echo "=========================================="
    echo "❌ Training pipeline failed!"
    echo "=========================================="
    exit 1
fi
```

### 4.2 Cron Job (Tự động train hàng tuần)

```bash
# Edit crontab
crontab -e

# Add this line to train every Sunday at 2 AM
0 2 * * 0 cd /path/to/project && ./train_pipeline.sh >> logs/training.log 2>&1
```

## 5. Monitoring & Validation

### 5.1 Model Validation Script

```python
# validate_model.py
import joblib
import pandas as pd
import numpy as np
from sklearn.metrics import roc_auc_score, precision_recall_curve
import matplotlib.pyplot as plt

def validate_model(model_path='models/smart_review_model.pkl'):
    """
    Validate trained model
    """
    print("🔍 Validating model...")

    # Load model
    model = joblib.load(model_path)
    feature_columns = joblib.load('models/feature_columns.pkl')

    print(f"✅ Model loaded: {model_path}")
    print(f"📊 Features: {len(feature_columns)}")

    # Load test data
    df = pd.read_csv('training_data_latest.csv')
    X = df[feature_columns]
    y = df['forgot']

    # Predict
    y_pred_proba = model.predict_proba(X)[:, 1]

    # Calculate metrics
    auc = roc_auc_score(y, y_pred_proba)

    print(f"\n🎯 Validation Results:")
    print(f"   AUC-ROC: {auc:.4f}")

    # Precision-Recall curve
    precision, recall, thresholds = precision_recall_curve(y, y_pred_proba)

    plt.figure(figsize=(10, 6))
    plt.plot(recall, precision)
    plt.xlabel('Recall')
    plt.ylabel('Precision')
    plt.title('Precision-Recall Curve')
    plt.grid(True)
    plt.savefig('precision_recall_curve.png')
    print(f"💾 Saved precision-recall curve to precision_recall_curve.png")

    # Find optimal threshold
    f1_scores = 2 * (precision * recall) / (precision + recall + 1e-10)
    optimal_idx = np.argmax(f1_scores)
    optimal_threshold = thresholds[optimal_idx]

    print(f"\n🎯 Optimal threshold: {optimal_threshold:.4f}")
    print(f"   Precision: {precision[optimal_idx]:.4f}")
    print(f"   Recall: {recall[optimal_idx]:.4f}")
    print(f"   F1-Score: {f1_scores[optimal_idx]:.4f}")

    return auc, optimal_threshold

if __name__ == "__main__":
    validate_model()
```

### 5.2 Model Comparison

```python
# compare_models.py
import joblib
import pandas as pd
from sklearn.metrics import roc_auc_score
import glob

def compare_models():
    """
    So sánh các version model
    """
    print("📊 Comparing model versions...")

    # Find all model files
    model_files = glob.glob('models/backup/smart_review_model_*.pkl')
    model_files.append('models/smart_review_model.pkl')

    # Load test data
    df = pd.read_csv('training_data_latest.csv')
    feature_columns = joblib.load('models/feature_columns.pkl')
    X = df[feature_columns]
    y = df['forgot']

    results = []

    for model_path in model_files:
        try:
            model = joblib.load(model_path)
            y_pred_proba = model.predict_proba(X)[:, 1]
            auc = roc_auc_score(y, y_pred_proba)

            results.append({
                'model': model_path,
                'auc': auc
            })

            print(f"✅ {model_path}: AUC = {auc:.4f}")

        except Exception as e:
            print(f"❌ {model_path}: Error - {e}")

    # Sort by AUC
    results.sort(key=lambda x: x['auc'], reverse=True)

    print(f"\n🏆 Best model: {results[0]['model']}")
    print(f"   AUC: {results[0]['auc']:.4f}")

    return results

if __name__ == "__main__":
    compare_models()
```
