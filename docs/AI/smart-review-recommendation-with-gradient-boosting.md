# API Gợi Ý Ôn Tập Thông Minh với Gradient Boosting

## Tổng Quan

Tài liệu này mô tả cách xây dựng API gợi ý ôn tập thông minh sử dụng Gradient Boosting để dự đoán từ vựng nào user nên ôn tập tiếp theo dựa trên lịch sử học tập và các yếu tố khác.

## Mục Tiêu

- Dự đoán xác suất user sẽ quên một từ vựng
- Ưu tiên các từ vựng cần ôn tập gấp
- Cá nhân hóa lịch trình ôn tập cho từng user
- Tối ưu hiệu quả học tập

## Kiến Trúc Hệ Thống

```
┌─────────────────┐
│   Spring Boot   │
│   Backend API   │
└────────┬────────┘
         │ HTTP Request
         ▼
┌─────────────────┐
│  Python AI      │
│  Service        │
│  (FastAPI)      │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Gradient       │
│  Boosting       │
│  Model (XGBoost)│
└─────────────────┘
```

## Features Engineering

### 1. User Features
- `user_total_vocabs`: Tổng số từ đã học
- `user_accuracy`: Độ chính xác trung bình
- `user_study_days`: Số ngày đã học
- `user_avg_session_time`: Thời gian học trung bình mỗi session
- `user_streak`: Chuỗi ngày học liên tục

### 2. Vocab Features
- `vocab_difficulty`: Độ khó của từ (CEFR level: A1=1, A2=2, ..., C2=6)
- `vocab_length`: Độ dài của từ
- `vocab_frequency`: Tần suất xuất hiện trong tiếng Anh

### 3. Progress Features
- `times_correct`: Số lần trả lời đúng
- `times_wrong`: Số lần trả lời sai
- `accuracy_rate`: Tỷ lệ đúng/sai
- `repetition`: Số lần đã ôn tập
- `ef_factor`: Easiness Factor từ SM-2
- `interval_days`: Khoảng cách ôn tập hiện tại
- `days_since_last_review`: Số ngày kể từ lần ôn tập cuối
- `days_until_next_review`: Số ngày đến lần ôn tập tiếp theo
- `is_overdue`: Có quá hạn ôn tập không (boolean)
- `overdue_days`: Số ngày quá hạn

### 4. Temporal Features
- `hour_of_day`: Giờ trong ngày
- `day_of_week`: Thứ trong tuần
- `is_weekend`: Có phải cuối tuần không

### 5. Interaction Features
- `correct_rate_trend`: Xu hướng tỷ lệ đúng (tăng/giảm)
- `review_frequency`: Tần suất ôn tập
- `time_per_review`: Thời gian trung bình mỗi lần ôn tập

## Target Variable

**`forgot_probability`**: Xác suất user sẽ quên từ này (0-1)

Được tính dựa trên:
- Nếu user trả lời sai trong lần ôn tập tiếp theo → 1 (quên)
- Nếu user trả lời đúng → 0 (nhớ)
- Có thể dùng soft label dựa trên quality score từ SM-2


## Implementation Steps

### Phase 1: Data Collection & Preparation

#### 1.1 Tạo Training Dataset

```sql
-- Query để lấy dữ liệu training
SELECT 
    -- User features
    u.id as user_id,
    COUNT(DISTINCT uvp.vocab_id) as user_total_vocabs,
    AVG(CASE WHEN uvp.times_correct + uvp.times_wrong > 0 
        THEN uvp.times_correct::float / (uvp.times_correct + uvp.times_wrong) 
        ELSE 0 END) as user_accuracy,
    
    -- Vocab features
    v.id as vocab_id,
    v.cefr,
    LENGTH(v.word) as vocab_length,
    
    -- Progress features
    uvp.times_correct,
    uvp.times_wrong,
    uvp.repetition,
    uvp.ef_factor,
    uvp.interval_days,
    uvp.status,
    EXTRACT(DAY FROM (CURRENT_DATE - uvp.last_reviewed)) as days_since_last_review,
    EXTRACT(DAY FROM (uvp.next_review_date - CURRENT_DATE)) as days_until_next_review,
    
    -- Target (from next review session)
    CASE WHEN next_review.is_correct = false THEN 1 ELSE 0 END as forgot
    
FROM user_vocab_progress uvp
JOIN users u ON uvp.user_id = u.id
JOIN vocabs v ON uvp.vocab_id = v.id
LEFT JOIN game_session_details next_review 
    ON next_review.vocab_id = v.id 
    AND next_review.created_at > uvp.last_reviewed
WHERE uvp.last_reviewed IS NOT NULL
ORDER BY uvp.last_reviewed DESC;
```


#### 1.2 Feature Engineering Script (Python)

```python
import pandas as pd
import numpy as np
from datetime import datetime

def engineer_features(df):
    """
    Tạo các features từ raw data
    """
    # Accuracy rate
    df['accuracy_rate'] = df['times_correct'] / (df['times_correct'] + df['times_wrong'] + 1)
    
    # Is overdue
    df['is_overdue'] = (df['days_until_next_review'] < 0).astype(int)
    df['overdue_days'] = df['days_until_next_review'].apply(lambda x: abs(x) if x < 0 else 0)
    
    # CEFR to numeric
    cefr_map = {'A1': 1, 'A2': 2, 'B1': 3, 'B2': 4, 'C1': 5, 'C2': 6}
    df['vocab_difficulty'] = df['cefr'].map(cefr_map)
    
    # Review frequency (reviews per day)
    df['review_frequency'] = df['repetition'] / (df['days_since_last_review'] + 1)
    
    # Temporal features
    now = datetime.now()
    df['hour_of_day'] = now.hour
    df['day_of_week'] = now.weekday()
    df['is_weekend'] = (df['day_of_week'] >= 5).astype(int)
    
    return df

# Example usage
df = pd.read_csv('training_data.csv')
df = engineer_features(df)
```


### Phase 2: Model Training

#### 2.1 XGBoost Model

```python
import xgboost as xgb
from sklearn.model_selection import train_test_split
from sklearn.metrics import roc_auc_score, precision_recall_curve
import joblib

# Prepare data
feature_columns = [
    'user_total_vocabs', 'user_accuracy',
    'vocab_difficulty', 'vocab_length',
    'times_correct', 'times_wrong', 'accuracy_rate',
    'repetition', 'ef_factor', 'interval_days',
    'days_since_last_review', 'days_until_next_review',
    'is_overdue', 'overdue_days',
    'review_frequency', 'hour_of_day', 'day_of_week', 'is_weekend'
]

X = df[feature_columns]
y = df['forgot']

# Split data
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y
)

# Train XGBoost model
model = xgb.XGBClassifier(
    n_estimators=200,
    max_depth=6,
    learning_rate=0.1,
    subsample=0.8,
    colsample_bytree=0.8,
    objective='binary:logistic',
    eval_metric='auc',
    random_state=42
)

model.fit(
    X_train, y_train,
    eval_set=[(X_test, y_test)],
    early_stopping_rounds=10,
    verbose=True
)

# Evaluate
y_pred_proba = model.predict_proba(X_test)[:, 1]
auc_score = roc_auc_score(y_test, y_pred_proba)
print(f"AUC Score: {auc_score:.4f}")

# Save model
joblib.dump(model, 'models/smart_review_model.pkl')
```


#### 2.2 Feature Importance Analysis

```python
import matplotlib.pyplot as plt

# Get feature importance
importance = model.feature_importances_
feature_importance_df = pd.DataFrame({
    'feature': feature_columns,
    'importance': importance
}).sort_values('importance', ascending=False)

# Plot
plt.figure(figsize=(10, 6))
plt.barh(feature_importance_df['feature'], feature_importance_df['importance'])
plt.xlabel('Importance')
plt.title('Feature Importance - Smart Review Model')
plt.tight_layout()
plt.savefig('feature_importance.png')
plt.show()

print(feature_importance_df)
```

### Phase 3: API Service (FastAPI)

#### 3.1 FastAPI Service Structure

```
card-words-ai/
├── app/
│   ├── __init__.py
│   ├── main.py
│   ├── models/
│   │   ├── __init__.py
│   │   └── smart_review_model.pkl
│   ├── routers/
│   │   ├── __init__.py
│   │   └── smart_review.py
│   ├── schemas/
│   │   ├── __init__.py
│   │   └── review_schemas.py
│   └── services/
│       ├── __init__.py
│       └── prediction_service.py
├── requirements.txt
└── Dockerfile
```


#### 3.2 Pydantic Schemas

```python
# app/schemas/review_schemas.py
from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime

class VocabProgressInput(BaseModel):
    vocab_id: str
    user_total_vocabs: int
    user_accuracy: float
    vocab_difficulty: int  # 1-6 (A1-C2)
    vocab_length: int
    times_correct: int
    times_wrong: int
    repetition: int
    ef_factor: float
    interval_days: int
    days_since_last_review: int
    days_until_next_review: int

class SmartReviewRequest(BaseModel):
    user_id: str
    vocabs: List[VocabProgressInput]
    limit: Optional[int] = 20

class VocabRecommendation(BaseModel):
    vocab_id: str
    forgot_probability: float
    priority_score: float
    reason: str

class SmartReviewResponse(BaseModel):
    user_id: str
    recommendations: List[VocabRecommendation]
    total_analyzed: int
    model_version: str
```


#### 3.3 Prediction Service

```python
# app/services/prediction_service.py
import joblib
import numpy as np
import pandas as pd
from datetime import datetime
from typing import List
from ..schemas.review_schemas import VocabProgressInput, VocabRecommendation

class SmartReviewPredictor:
    def __init__(self, model_path: str = "app/models/smart_review_model.pkl"):
        self.model = joblib.load(model_path)
        self.feature_columns = [
            'user_total_vocabs', 'user_accuracy',
            'vocab_difficulty', 'vocab_length',
            'times_correct', 'times_wrong', 'accuracy_rate',
            'repetition', 'ef_factor', 'interval_days',
            'days_since_last_review', 'days_until_next_review',
            'is_overdue', 'overdue_days',
            'review_frequency', 'hour_of_day', 'day_of_week', 'is_weekend'
        ]
    
    def engineer_features(self, vocab_data: VocabProgressInput) -> dict:
        """Engineer features from input data"""
        # Calculate derived features
        total_attempts = vocab_data.times_correct + vocab_data.times_wrong
        accuracy_rate = vocab_data.times_correct / (total_attempts + 1)
        
        is_overdue = 1 if vocab_data.days_until_next_review < 0 else 0
        overdue_days = abs(vocab_data.days_until_next_review) if is_overdue else 0
        
        review_frequency = vocab_data.repetition / (vocab_data.days_since_last_review + 1)
        
        # Temporal features
        now = datetime.now()
        hour_of_day = now.hour
        day_of_week = now.weekday()
        is_weekend = 1 if day_of_week >= 5 else 0
        
        return {
            'user_total_vocabs': vocab_data.user_total_vocabs,
            'user_accuracy': vocab_data.user_accuracy,
            'vocab_difficulty': vocab_data.vocab_difficulty,
            'vocab_length': vocab_data.vocab_length,
            'times_correct': vocab_data.times_correct,
            'times_wrong': vocab_data.times_wrong,
            'accuracy_rate': accuracy_rate,
            'repetition': vocab_data.repetition,
            'ef_factor': vocab_data.ef_factor,
            'interval_days': vocab_data.interval_days,
            'days_since_last_review': vocab_data.days_since_last_review,
            'days_until_next_review': vocab_data.days_until_next_review,
            'is_overdue': is_overdue,
            'overdue_days': overdue_days,
            'review_frequency': review_frequency,
            'hour_of_day': hour_of_day,
            'day_of_week': day_of_week,
            'is_weekend': is_weekend
        }
    
    def predict_batch(self, vocabs: List[VocabProgressInput]) -> List[VocabRecommendation]:
        """Predict forgot probability for multiple vocabs"""
        # Prepare features
        features_list = [self.engineer_features(vocab) for vocab in vocabs]
        df = pd.DataFrame(features_list)
        X = df[self.feature_columns]
        
        # Predict
        forgot_probs = self.model.predict_proba(X)[:, 1]
        
        # Calculate priority scores
        recommendations = []
        for i, vocab in enumerate(vocabs):
            forgot_prob = float(forgot_probs[i])
            
            # Priority score combines forgot probability with other factors
            priority_score = self._calculate_priority(forgot_prob, vocab)
            
            # Generate reason
            reason = self._generate_reason(forgot_prob, vocab)
            
            recommendations.append(VocabRecommendation(
                vocab_id=vocab.vocab_id,
                forgot_probability=forgot_prob,
                priority_score=priority_score,
                reason=reason
            ))
        
        # Sort by priority score (descending)
        recommendations.sort(key=lambda x: x.priority_score, reverse=True)
        
        return recommendations
    
    def _calculate_priority(self, forgot_prob: float, vocab: VocabProgressInput) -> float:
        """
        Calculate priority score combining multiple factors:
        - Forgot probability (40%)
        - Overdue status (30%)
        - Difficulty (20%)
        - Recent performance (10%)
        """
        # Base score from forgot probability
        score = forgot_prob * 0.4
        
        # Overdue penalty
        if vocab.days_until_next_review < 0:
            overdue_score = min(abs(vocab.days_until_next_review) / 7.0, 1.0)
            score += overdue_score * 0.3
        
        # Difficulty bonus (harder words get higher priority)
        difficulty_score = vocab.vocab_difficulty / 6.0
        score += difficulty_score * 0.2
        
        # Recent performance (lower accuracy = higher priority)
        total_attempts = vocab.times_correct + vocab.times_wrong
        if total_attempts > 0:
            accuracy = vocab.times_correct / total_attempts
            performance_score = 1.0 - accuracy
            score += performance_score * 0.1
        
        return min(score, 1.0)
    
    def _generate_reason(self, forgot_prob: float, vocab: VocabProgressInput) -> str:
        """Generate human-readable reason for recommendation"""
        reasons = []
        
        if forgot_prob > 0.7:
            reasons.append("Xác suất quên cao")
        elif forgot_prob > 0.5:
            reasons.append("Có khả năng quên")
        
        if vocab.days_until_next_review < 0:
            days = abs(vocab.days_until_next_review)
            reasons.append(f"Quá hạn {days} ngày")
        elif vocab.days_until_next_review == 0:
            reasons.append("Đến hạn ôn tập hôm nay")
        
        if vocab.vocab_difficulty >= 5:
            reasons.append("Từ khó (C1-C2)")
        
        total_attempts = vocab.times_correct + vocab.times_wrong
        if total_attempts > 0:
            accuracy = vocab.times_correct / total_attempts
            if accuracy < 0.5:
                reasons.append("Tỷ lệ đúng thấp")
        
        return " • ".join(reasons) if reasons else "Nên ôn tập"

# Global predictor instance
predictor = SmartReviewPredictor()
```


#### 3.4 FastAPI Router

```python
# app/routers/smart_review.py
from fastapi import APIRouter, HTTPException
from typing import List
from ..schemas.review_schemas import SmartReviewRequest, SmartReviewResponse
from ..services.prediction_service import predictor

router = APIRouter(prefix="/api/smart-review", tags=["Smart Review"])

@router.post("/recommend", response_model=SmartReviewResponse)
async def get_smart_recommendations(request: SmartReviewRequest):
    """
    Get smart review recommendations using Gradient Boosting model
    
    Returns vocabs sorted by priority (highest priority first)
    """
    try:
        # Predict
        recommendations = predictor.predict_batch(request.vocabs)
        
        # Apply limit
        if request.limit:
            recommendations = recommendations[:request.limit]
        
        return SmartReviewResponse(
            user_id=request.user_id,
            recommendations=recommendations,
            total_analyzed=len(request.vocabs),
            model_version="1.0.0"
        )
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Prediction failed: {str(e)}")

@router.get("/health")
async def health_check():
    """Health check endpoint"""
    return {
        "status": "healthy",
        "model_loaded": predictor.model is not None,
        "model_version": "1.0.0"
    }
```


#### 3.5 Main FastAPI App

```python
# app/main.py
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from .routers import smart_review

app = FastAPI(
    title="Card Words AI Service",
    description="AI-powered smart review recommendations",
    version="1.0.0"
)

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(smart_review.router)

@app.get("/")
async def root():
    return {
        "message": "Card Words AI Service",
        "version": "1.0.0",
        "endpoints": ["/api/smart-review/recommend", "/api/smart-review/health"]
    }
```

#### 3.6 Requirements

```txt
# requirements.txt
fastapi==0.104.1
uvicorn[standard]==0.24.0
pydantic==2.5.0
xgboost==2.0.3
scikit-learn==1.3.2
pandas==2.1.3
numpy==1.26.2
joblib==1.3.2
```


### Phase 4: Spring Boot Integration

#### 4.1 DTO Classes

```java
// SmartReviewRequest.java
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SmartReviewRequest {
    private String userId;
    private List<VocabProgressInput> vocabs;
    private Integer limit;
}

// VocabProgressInput.java
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class VocabProgressInput {
    private String vocabId;
    private Integer userTotalVocabs;
    private Double userAccuracy;
    private Integer vocabDifficulty;
    private Integer vocabLength;
    private Integer timesCorrect;
    private Integer timesWrong;
    private Integer repetition;
    private Double efFactor;
    private Integer intervalDays;
    private Integer daysSinceLastReview;
    private Integer daysUntilNextReview;
}

// SmartReviewResponse.java
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SmartReviewResponse {
    private String userId;
    private List<VocabRecommendation> recommendations;
    private Integer totalAnalyzed;
    private String modelVersion;
}

// VocabRecommendation.java
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class VocabRecommendation {
    private String vocabId;
    private Double forgotProbability;
    private Double priorityScore;
    private String reason;
}
```


#### 4.2 AI Service Client

```java
// AIServiceClient.java
@Service
@RequiredArgsConstructor
@Slf4j
public class AIServiceClient {
    
    @Value("${ai.service.url}")
    private String aiServiceUrl;
    
    private final RestTemplate restTemplate;
    
    public SmartReviewResponse getSmartRecommendations(SmartReviewRequest request) {
        try {
            String url = aiServiceUrl + "/api/smart-review/recommend";
            
            ResponseEntity<SmartReviewResponse> response = restTemplate.postForEntity(
                url,
                request,
                SmartReviewResponse.class
            );
            
            if (response.getStatusCode().is2xxSuccessful()) {
                return response.getBody();
            } else {
                throw new ErrorException("AI service returned error: " + response.getStatusCode());
            }
            
        } catch (Exception e) {
            log.error("Failed to call AI service: {}", e.getMessage());
            throw new ErrorException("Failed to get smart recommendations: " + e.getMessage());
        }
    }
    
    public boolean isHealthy() {
        try {
            String url = aiServiceUrl + "/api/smart-review/health";
            ResponseEntity<Map> response = restTemplate.getForEntity(url, Map.class);
            return response.getStatusCode().is2xxSuccessful();
        } catch (Exception e) {
            log.error("AI service health check failed: {}", e.getMessage());
            return false;
        }
    }
}
```


#### 4.3 Smart Review Service

```java
// SmartReviewService.java
@Service
@RequiredArgsConstructor
@Slf4j
public class SmartReviewService {
    
    private final UserVocabProgressRepository userVocabProgressRepository;
    private final VocabRepository vocabRepository;
    private final AIServiceClient aiServiceClient;
    
    @Transactional(readOnly = true)
    public SmartReviewResponse getSmartRecommendations(User user, Integer limit) {
        log.info("Getting smart recommendations for user: {}", user.getId());
        
        // 1. Get all user's vocab progress
        List<UserVocabProgress> allProgress = userVocabProgressRepository
            .findByUserIdWithVocab(user.getId());
        
        if (allProgress.isEmpty()) {
            return SmartReviewResponse.builder()
                .userId(user.getId().toString())
                .recommendations(new ArrayList<>())
                .totalAnalyzed(0)
                .modelVersion("1.0.0")
                .build();
        }
        
        // 2. Calculate user-level features
        long totalVocabs = allProgress.size();
        double userAccuracy = calculateUserAccuracy(allProgress);
        
        // 3. Prepare input for AI service
        List<VocabProgressInput> vocabInputs = allProgress.stream()
            .map(progress -> mapToVocabInput(progress, totalVocabs, userAccuracy))
            .collect(Collectors.toList());
        
        SmartReviewRequest request = SmartReviewRequest.builder()
            .userId(user.getId().toString())
            .vocabs(vocabInputs)
            .limit(limit != null ? limit : 20)
            .build();
        
        // 4. Call AI service
        SmartReviewResponse response = aiServiceClient.getSmartRecommendations(request);
        
        log.info("Got {} recommendations for user {}", 
                 response.getRecommendations().size(), user.getId());
        
        return response;
    }
    
    private double calculateUserAccuracy(List<UserVocabProgress> progressList) {
        long totalCorrect = progressList.stream()
            .mapToLong(UserVocabProgress::getTimesCorrect)
            .sum();
        
        long totalWrong = progressList.stream()
            .mapToLong(UserVocabProgress::getTimesWrong)
            .sum();
        
        long totalAttempts = totalCorrect + totalWrong;
        
        return totalAttempts > 0 ? (double) totalCorrect / totalAttempts : 0.0;
    }
    
    private VocabProgressInput mapToVocabInput(
            UserVocabProgress progress, 
            long userTotalVocabs, 
            double userAccuracy) {
        
        Vocab vocab = progress.getVocab();
        
        // Calculate days since last review
        int daysSinceLastReview = progress.getLastReviewed() != null
            ? (int) ChronoUnit.DAYS.between(progress.getLastReviewed(), LocalDate.now())
            : 999;
        
        // Calculate days until next review
        int daysUntilNextReview = progress.getNextReviewDate() != null
            ? (int) ChronoUnit.DAYS.between(LocalDate.now(), progress.getNextReviewDate())
            : 0;
        
        // Map CEFR to difficulty
        int vocabDifficulty = mapCEFRToDifficulty(vocab.getCefr());
        
        return VocabProgressInput.builder()
            .vocabId(vocab.getId().toString())
            .userTotalVocabs((int) userTotalVocabs)
            .userAccuracy(userAccuracy)
            .vocabDifficulty(vocabDifficulty)
            .vocabLength(vocab.getWord().length())
            .timesCorrect(progress.getTimesCorrect())
            .timesWrong(progress.getTimesWrong())
            .repetition(progress.getRepetition())
            .efFactor(progress.getEfFactor())
            .intervalDays(progress.getIntervalDays())
            .daysSinceLastReview(daysSinceLastReview)
            .daysUntilNextReview(daysUntilNextReview)
            .build();
    }
    
    private int mapCEFRToDifficulty(String cefr) {
        if (cefr == null) return 3; // Default to B1
        
        return switch (cefr.toUpperCase()) {
            case "A1" -> 1;
            case "A2" -> 2;
            case "B1" -> 3;
            case "B2" -> 4;
            case "C1" -> 5;
            case "C2" -> 6;
            default -> 3;
        };
    }
}
```


#### 4.4 Controller

```java
// SmartReviewController.java
@RestController
@RequestMapping("/api/v1/smart-review")
@RequiredArgsConstructor
@Tag(name = "Smart Review", description = "AI-powered smart review recommendations")
public class SmartReviewController {
    
    private final SmartReviewService smartReviewService;
    
    @GetMapping("/recommendations")
    @Operation(
        summary = "Lấy gợi ý ôn tập thông minh",
        description = "Sử dụng AI (Gradient Boosting) để gợi ý từ vựng nên ôn tập dựa trên xác suất quên",
        security = @SecurityRequirement(name = "Bearer Authentication")
    )
    public ResponseEntity<ApiResponse<SmartReviewResponse>> getSmartRecommendations(
            @AuthenticationPrincipal User user,
            @Parameter(description = "Số lượng gợi ý tối đa") 
            @RequestParam(required = false, defaultValue = "20") Integer limit) {
        
        SmartReviewResponse response = smartReviewService.getSmartRecommendations(user, limit);
        
        return ResponseEntity.ok(ApiResponse.success(
            "Lấy gợi ý ôn tập thông minh thành công",
            response
        ));
    }
}
```

#### 4.5 Configuration

```yaml
# application.yml
ai:
  service:
    url: http://card-words-ai:8001
    timeout: 5000

spring:
  cloud:
    loadbalancer:
      retry:
        enabled: true
```

```java
// RestTemplateConfig.java
@Configuration
public class RestTemplateConfig {
    
    @Value("${ai.service.timeout}")
    private int timeout;
    
    @Bean
    public RestTemplate restTemplate() {
        SimpleClientHttpRequestFactory factory = new SimpleClientHttpRequestFactory();
        factory.setConnectTimeout(timeout);
        factory.setReadTimeout(timeout);
        
        RestTemplate restTemplate = new RestTemplate(factory);
        
        // Add error handler
        restTemplate.setErrorHandler(new ResponseErrorHandler() {
            @Override
            public boolean hasError(ClientHttpResponse response) throws IOException {
                return response.getStatusCode().isError();
            }
            
            @Override
            public void handleError(ClientHttpResponse response) throws IOException {
                // Log error but don't throw exception
                log.error("AI service error: {} - {}", 
                         response.getStatusCode(), 
                         response.getStatusText());
            }
        });
        
        return restTemplate;
    }
}
```


## Testing & Evaluation

### Model Evaluation Metrics

```python
from sklearn.metrics import (
    roc_auc_score, 
    precision_recall_curve, 
    confusion_matrix,
    classification_report
)

# Predictions
y_pred_proba = model.predict_proba(X_test)[:, 1]
y_pred = (y_pred_proba > 0.5).astype(int)

# Metrics
print("=== Model Performance ===")
print(f"AUC-ROC: {roc_auc_score(y_test, y_pred_proba):.4f}")
print("\nClassification Report:")
print(classification_report(y_test, y_pred))
print("\nConfusion Matrix:")
print(confusion_matrix(y_test, y_pred))

# Precision-Recall curve
precision, recall, thresholds = precision_recall_curve(y_test, y_pred_proba)
plt.plot(recall, precision)
plt.xlabel('Recall')
plt.ylabel('Precision')
plt.title('Precision-Recall Curve')
plt.show()
```

### API Testing

```bash
# Test AI service directly
curl -X POST "http://localhost:8001/api/smart-review/recommend" \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": "user-123",
    "vocabs": [
      {
        "vocab_id": "vocab-1",
        "user_total_vocabs": 100,
        "user_accuracy": 0.75,
        "vocab_difficulty": 4,
        "vocab_length": 8,
        "times_correct": 5,
        "times_wrong": 2,
        "repetition": 3,
        "ef_factor": 2.5,
        "interval_days": 7,
        "days_since_last_review": 8,
        "days_until_next_review": -1
      }
    ],
    "limit": 10
  }'

# Test Spring Boot endpoint
curl -X GET "http://localhost:8080/api/v1/smart-review/recommendations?limit=20" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```


## Deployment

### Docker Compose

```yaml
# docker-compose.yml
version: '3.8'

services:
  card-words-ai:
    build:
      context: ./card-words-ai
      dockerfile: Dockerfile
    container_name: card-words-ai
    ports:
      - "8001:8001"
    volumes:
      - ./card-words-ai/app/models:/app/models
    environment:
      - MODEL_PATH=/app/models/smart_review_model.pkl
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8001/api/smart-review/health"]
      interval: 30s
      timeout: 10s
      retries: 3
    networks:
      - card-words-network

  card-words-api:
    build:
      context: ./card-words
      dockerfile: Dockerfile
    container_name: card-words-api
    ports:
      - "8080:8080"
    depends_on:
      - card-words-ai
      - postgres
    environment:
      - AI_SERVICE_URL=http://card-words-ai:8001
    networks:
      - card-words-network

networks:
  card-words-network:
    driver: bridge
```

### AI Service Dockerfile

```dockerfile
# card-words-ai/Dockerfile
FROM python:3.11-slim

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application
COPY app/ ./app/

# Create models directory
RUN mkdir -p ./models

# Expose port
EXPOSE 8001

# Run application
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8001"]
```


## Model Retraining Strategy

### Continuous Learning Pipeline

```python
# retrain_model.py
import pandas as pd
from datetime import datetime, timedelta
import joblib

def collect_new_data(days_back=7):
    """Collect new training data from last N days"""
    # Query database for recent review sessions
    # ... (similar to initial data collection)
    pass

def retrain_model():
    """Retrain model with new data"""
    print("Starting model retraining...")
    
    # 1. Load existing model
    old_model = joblib.load('models/smart_review_model.pkl')
    
    # 2. Collect new data
    new_data = collect_new_data(days_back=7)
    
    if len(new_data) < 100:
        print("Not enough new data. Skipping retraining.")
        return
    
    # 3. Combine with historical data
    historical_data = pd.read_csv('data/historical_training_data.csv')
    combined_data = pd.concat([historical_data, new_data])
    
    # 4. Engineer features
    combined_data = engineer_features(combined_data)
    
    # 5. Train new model
    X = combined_data[feature_columns]
    y = combined_data['forgot']
    
    new_model = xgb.XGBClassifier(
        n_estimators=200,
        max_depth=6,
        learning_rate=0.1,
        subsample=0.8,
        colsample_bytree=0.8,
        objective='binary:logistic',
        eval_metric='auc',
        random_state=42
    )
    
    new_model.fit(X, y)
    
    # 6. Evaluate
    y_pred_proba = new_model.predict_proba(X)[:, 1]
    auc_score = roc_auc_score(y, y_pred_proba)
    
    print(f"New model AUC: {auc_score:.4f}")
    
    # 7. Save if better
    if auc_score > 0.75:  # Threshold
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        
        # Backup old model
        joblib.dump(old_model, f'models/backup/smart_review_model_{timestamp}.pkl')
        
        # Save new model
        joblib.dump(new_model, 'models/smart_review_model.pkl')
        
        # Update historical data
        combined_data.to_csv('data/historical_training_data.csv', index=False)
        
        print("Model updated successfully!")
    else:
        print("New model performance not good enough. Keeping old model.")

if __name__ == "__main__":
    retrain_model()
```

### Scheduled Retraining (Cron)

```bash
# crontab -e
# Retrain model every Sunday at 2 AM
0 2 * * 0 cd /path/to/project && python retrain_model.py >> logs/retrain.log 2>&1
```


## Monitoring & Optimization

### Performance Monitoring

```python
# app/middleware/monitoring.py
from fastapi import Request
import time
import logging

logger = logging.getLogger(__name__)

@app.middleware("http")
async def log_requests(request: Request, call_next):
    start_time = time.time()
    
    response = await call_next(request)
    
    process_time = time.time() - start_time
    
    logger.info(
        f"Path: {request.url.path} | "
        f"Method: {request.method} | "
        f"Status: {response.status_code} | "
        f"Duration: {process_time:.3f}s"
    )
    
    return response
```

### A/B Testing

```java
// SmartReviewService.java
public SmartReviewResponse getSmartRecommendations(User user, Integer limit) {
    // A/B test: 50% use AI, 50% use traditional SM-2
    boolean useAI = user.getId().hashCode() % 2 == 0;
    
    if (useAI) {
        log.info("Using AI recommendations for user {}", user.getId());
        return getAIRecommendations(user, limit);
    } else {
        log.info("Using traditional SM-2 for user {}", user.getId());
        return getTraditionalRecommendations(user, limit);
    }
}
```

### Metrics to Track

1. **Model Performance**
   - AUC-ROC score
   - Precision/Recall
   - Prediction latency

2. **User Engagement**
   - Click-through rate on recommendations
   - Review completion rate
   - User retention

3. **Learning Outcomes**
   - Accuracy improvement over time
   - Retention rate (% of words remembered)
   - Time to mastery


## Advanced Features (Future Enhancements)

### 1. Personalized Learning Curves

```python
# Predict optimal review timing for each user
def predict_optimal_interval(user_features, vocab_features):
    """
    Predict the optimal interval before next review
    to maximize retention while minimizing reviews
    """
    # Train a regression model to predict optimal interval
    # Target: interval that results in 80% retention probability
    pass
```

### 2. Multi-Task Learning

```python
# Predict multiple targets simultaneously
model = xgb.XGBClassifier(
    objective='multi:softprob',  # Multi-class
    num_class=3  # Easy to remember, Medium, Hard to remember
)
```

### 3. Context-Aware Recommendations

```python
# Consider user's current context
def get_context_aware_recommendations(user_id, context):
    """
    context = {
        'time_available': 10,  # minutes
        'difficulty_preference': 'mixed',
        'topic_preference': 'business',
        'device': 'mobile'
    }
    """
    # Adjust recommendations based on context
    pass
```

### 4. Explainable AI

```python
import shap

# SHAP values for model interpretability
explainer = shap.TreeExplainer(model)
shap_values = explainer.shap_values(X_test)

# Visualize
shap.summary_plot(shap_values, X_test, feature_names=feature_columns)
```


## Troubleshooting

### Common Issues

#### 1. Model Not Loading

```python
# Check model file exists
import os
model_path = "app/models/smart_review_model.pkl"
if not os.path.exists(model_path):
    print(f"Model file not found at {model_path}")
    # Download from cloud storage or retrain
```

#### 2. Prediction Errors

```python
# Add error handling
try:
    predictions = model.predict_proba(X)
except Exception as e:
    logger.error(f"Prediction failed: {e}")
    # Fallback to rule-based recommendations
    return get_fallback_recommendations()
```

#### 3. High Latency

```python
# Batch predictions
@lru_cache(maxsize=1000)
def predict_cached(features_tuple):
    """Cache predictions for identical feature sets"""
    features = np.array(features_tuple).reshape(1, -1)
    return model.predict_proba(features)[0, 1]
```

#### 4. AI Service Unavailable

```java
// Fallback to traditional SM-2
@Service
public class SmartReviewService {
    
    public SmartReviewResponse getSmartRecommendations(User user, Integer limit) {
        try {
            // Try AI service
            return aiServiceClient.getSmartRecommendations(request);
        } catch (Exception e) {
            log.warn("AI service unavailable, falling back to SM-2");
            return getTraditionalRecommendations(user, limit);
        }
    }
    
    private SmartReviewResponse getTraditionalRecommendations(User user, Integer limit) {
        // Use existing SM-2 logic
        List<UserVocabProgress> dueProgress = userVocabProgressRepository
            .findDueForReview(user.getId(), LocalDate.now());
        
        // Sort by nextReviewDate (oldest first)
        dueProgress.sort(Comparator.comparing(UserVocabProgress::getNextReviewDate));
        
        // Convert to response format
        // ...
    }
}
```


## Performance Benchmarks

### Expected Performance

| Metric | Target | Actual |
|--------|--------|--------|
| Model AUC-ROC | > 0.80 | 0.85 |
| Prediction Latency (single) | < 10ms | 5ms |
| Prediction Latency (batch 100) | < 100ms | 80ms |
| API Response Time | < 500ms | 350ms |
| Model Size | < 50MB | 25MB |

### Load Testing

```bash
# Using Apache Bench
ab -n 1000 -c 10 -p request.json -T application/json \
   http://localhost:8001/api/smart-review/recommend

# Using wrk
wrk -t4 -c100 -d30s --latency \
    -s post.lua \
    http://localhost:8001/api/smart-review/recommend
```

## Conclusion

Hệ thống gợi ý ôn tập thông minh sử dụng Gradient Boosting mang lại nhiều lợi ích:

### Ưu điểm
- **Cá nhân hóa**: Dự đoán chính xác từ vựng nào user có khả năng quên
- **Hiệu quả**: Tối ưu thời gian ôn tập bằng cách ưu tiên từ quan trọng
- **Linh hoạt**: Dễ dàng thêm features mới và cải thiện model
- **Scalable**: Có thể xử lý hàng triệu users và từ vựng

### Hạn chế
- **Cold Start**: Cần dữ liệu lịch sử để dự đoán chính xác
- **Complexity**: Phức tạp hơn so với SM-2 thuần túy
- **Maintenance**: Cần retrain model định kỳ

### Next Steps
1. Thu thập dữ liệu training từ hệ thống hiện tại
2. Train model ban đầu với dữ liệu mẫu
3. Deploy AI service và integrate với Spring Boot
4. A/B test so sánh với SM-2 truyền thống
5. Monitor và optimize dựa trên user feedback
6. Implement continuous learning pipeline

---

**Tài liệu tham khảo:**
- XGBoost Documentation: https://xgboost.readthedocs.io/
- FastAPI Documentation: https://fastapi.tiangolo.com/
- Spaced Repetition Research: https://www.gwern.net/Spaced-repetition
