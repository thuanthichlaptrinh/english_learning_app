# Machine Learning Integration Guide

## Tổng quan

Hướng dẫn tích hợp Machine Learning vào dự án học tiếng Anh với Spring Boot và Python để cải thiện trải nghiệm học tập và cá nhân hóa cho người dùng.

---

## 1. Các tính năng ML có thể áp dụng

### 1.1 Personalized Learning Path (Học đường cá nhân hóa)
- **Mục đích**: Tối ưu hóa trải nghiệm học tập cho từng user
- **Chức năng**:
  - Dự đoán từ vựng khó cho từng user dựa trên lịch sử học tập
  - Gợi ý từ cần ôn tập theo thuật toán Spaced Repetition
  - Xác định thời điểm tối ưu để ôn tập từ vựng

**Dữ liệu đầu vào**:
- Lịch sử học tập từ `user_vocab_progress`
- Streak và engagement từ bảng `users`
- Thời gian học và kết quả từng game

**Output**:
- Danh sách từ ưu tiên học
- Thời gian ôn tập đề xuất
- Độ khó phù hợp với user

### 1.2 Progress Prediction (Dự đoán tiến độ)
- **Mục đích**: Dự đoán khả năng thành thạo từ vựng
- **Chức năng**:
  - Dự đoán khả năng user sẽ mastered một từ
  - Phân tích streak patterns và engagement
  - Cảnh báo khi user có nguy cơ bỏ học

**Model sử dụng**:
- Random Forest hoặc Gradient Boosting
- Input: số lần học, success rate, streak, thời gian học
- Output: xác suất mastered (0-1)

### 1.3 Difficulty Classification (Phân loại độ khó)
- **Mục đích**: Tự động phân loại và điều chỉnh độ khó từ vựng
- **Chức năng**:
  - Phân tích từ nào khó/dễ dựa trên dữ liệu thực tế
  - Clustering từ vựng theo mức độ
  - Cập nhật độ khó động dựa trên feedback

**Thuật toán**:
- K-Means Clustering cho phân nhóm từ
- Logistic Regression cho classification
- Features: độ dài từ, tần suất sai, thời gian học trung bình

### 1.4 Recommendation System (Hệ thống gợi ý)
- **Mục đích**: Gợi ý nội dung phù hợp
- **Chức năng**:
  - Gợi ý từ vựng phù hợp với trình độ
  - Gợi ý game type phù hợp (quick quiz, matching, etc.)
  - Gợi ý số câu hỏi và thời gian chơi tối ưu

**Phương pháp**:
- Collaborative Filtering (dựa trên user tương tự)
- Content-based Filtering (dựa trên đặc điểm từ)
- Hybrid approach

### 1.5 Performance Analytics (Phân tích hiệu suất)
- **Mục đích**: Thống kê và insights
- **Chức năng**:
  - Phân tích xu hướng học tập theo thời gian
  - Xác định thời gian học hiệu quả nhất
  - Phát hiện patterns thành công

---

## 2. Kiến trúc tích hợp

### 2.1 Sơ đồ tổng quan

```
┌─────────────────────────────────────────────────────────────┐
│                     Frontend (React/Vue)                     │
└───────────────────────────┬─────────────────────────────────┘
                            │ HTTP
                            ↓
┌─────────────────────────────────────────────────────────────┐
│              Spring Boot Backend (Port 8080)                 │
│  ┌─────────────────┐         ┌──────────────────┐          │
│  │ REST Controllers │ ←────→  │   ML Service     │          │
│  └─────────────────┘         └──────────────────┘          │
│         │                             │                      │
│         │                             │ REST API             │
│         ↓                             ↓                      │
│  ┌─────────────────┐         ┌──────────────────┐          │
│  │   PostgreSQL    │         │  RestTemplate    │          │
│  └─────────────────┘         └──────────────────┘          │
└─────────────────────────────────────┬───────────────────────┘
                                      │ HTTP (localhost:5000)
                                      ↓
┌─────────────────────────────────────────────────────────────┐
│           Python ML Service (Port 5000)                      │
│  ┌─────────────────┐         ┌──────────────────┐          │
│  │  Flask/FastAPI  │ ←────→  │   ML Models      │          │
│  └─────────────────┘         └──────────────────┘          │
│         │                             │                      │
│         │                             ↓                      │
│         │                     ┌──────────────────┐          │
│         │                     │  Model Files     │          │
│         │                     │  (.pkl, .h5)     │          │
│         │                     └──────────────────┘          │
│         ↓                                                    │
│  ┌─────────────────┐                                        │
│  │   PostgreSQL    │ (Same database)                        │
│  └─────────────────┘                                        │
└─────────────────────────────────────────────────────────────┘
```

### 2.2 Communication Flow

1. **User Request** → Frontend
2. **API Call** → Spring Boot Controller
3. **ML Request** → Spring Boot MLService
4. **HTTP POST** → Python ML Service
5. **Prediction** ← Python returns result
6. **Response** → Spring Boot processes
7. **JSON Response** → Frontend displays

---

## 3. Phương án triển khai

### Phương án 1: REST API (⭐ Khuyến nghị)

**Ưu điểm**:
- Độc lập giữa Java và Python
- Dễ scale và maintain
- Có thể deploy riêng biệt
- Support đầy đủ Python 3 và ML libraries

**Nhược điểm**:
- Thêm network latency
- Cần quản lý 2 services

**Use case**: Phù hợp cho production

### Phương án 2: Message Queue (RabbitMQ/Kafka)

**Ưu điểm**:
- Xử lý bất đồng bộ
- Tốt cho training model nặng
- Fault tolerance tốt

**Nhược điểm**:
- Phức tạp hơn
- Cần infrastructure thêm

**Use case**: Khi cần xử lý batch hoặc training định kỳ

### Phương án 3: Embedded (Jython)

**Ưu điểm**:
- Không cần service riêng
- Latency thấp

**Nhược điểm**:
- Chỉ support Python 2.7
- Thiếu nhiều ML libraries
- Không khuyến nghị

**Use case**: Không phù hợp cho ML

---

## 4. Triển khai chi tiết - REST API Approach

### 4.1 Spring Boot Side

#### a. Thêm dependencies vào pom.xml

```xml
<!-- RestTemplate for HTTP calls -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>

<!-- For JSON processing -->
<dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-databind</artifactId>
</dependency>

<!-- Optional: Circuit breaker for resilience -->
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-circuitbreaker-resilience4j</artifactId>
</dependency>
```

#### b. Configuration (application.yml)

```yaml
ml-service:
  base-url: http://localhost:5000
  timeout: 30000  # 30 seconds
  enabled: true
  
spring:
  http:
    client:
      connection-timeout: 5000
      read-timeout: 30000
```

#### c. ML Service Configuration

```java
package com.thuanthichlaptrinh.card_words.configuration;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;
import org.springframework.boot.web.client.RestTemplateBuilder;
import java.time.Duration;

@Configuration
public class MLServiceConfiguration {
    
    @Value("${ml-service.base-url}")
    private String mlServiceBaseUrl;
    
    @Value("${ml-service.timeout}")
    private long timeout;
    
    @Bean
    public RestTemplate mlRestTemplate(RestTemplateBuilder builder) {
        return builder
                .setConnectTimeout(Duration.ofMillis(5000))
                .setReadTimeout(Duration.ofMillis(timeout))
                .build();
    }
    
    @Bean
    public String mlServiceBaseUrl() {
        return mlServiceBaseUrl;
    }
}
```

#### d. DTOs for ML Communication

```java
package com.thuanthichlaptrinh.card_words.core.domain.ml;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

// Request to ML service
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MLPredictionRequest {
    private Long userId;
    private Long vocabId;
    private String word;
    private Integer currentDifficulty;
    private Integer attemptCount;
    private Double successRate;
    private Integer currentStreak;
}

// Response from ML service
@Data
@NoArgsConstructor
@AllArgsConstructor
public class MLPredictionResponse {
    private Double predictedDifficulty;
    private Double masteryProbability;
    private Integer recommendedReviewDays;
    private String confidence;  // HIGH, MEDIUM, LOW
}

// Recommendation request
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MLRecommendationRequest {
    private Long userId;
    private Integer currentLevel;
    private Integer currentStreak;
    private String preferredGameType;
    private Integer limit;
}

// Recommendation response
@Data
@NoArgsConstructor
@AllArgsConstructor
public class MLRecommendationResponse {
    private List<RecommendedVocab> recommendations;
    private String gameTypeSuggestion;
    private Integer suggestedQuestionCount;
    private Integer suggestedTimeLimit;
}

@Data
@NoArgsConstructor
@AllArgsConstructor
public class RecommendedVocab {
    private Long vocabId;
    private String word;
    private Double priority;
    private String reason;
}
```

#### e. ML Service Implementation

```java
package com.thuanthichlaptrinh.card_words.core.service;

import com.thuanthichlaptrinh.card_words.core.domain.ml.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.client.RestClientException;

@Slf4j
@Service
@RequiredArgsConstructor
public class MLService {
    
    private final RestTemplate mlRestTemplate;
    
    @Value("${ml-service.base-url}")
    private String mlServiceBaseUrl;
    
    @Value("${ml-service.enabled}")
    private boolean mlServiceEnabled;
    
    /**
     * Predict difficulty and mastery probability for a vocabulary
     */
    public MLPredictionResponse predictVocabDifficulty(MLPredictionRequest request) {
        if (!mlServiceEnabled) {
            log.warn("ML Service is disabled, returning default values");
            return getDefaultPrediction();
        }
        
        try {
            String url = mlServiceBaseUrl + "/api/predict/difficulty";
            log.info("Calling ML service: {}", url);
            
            MLPredictionResponse response = mlRestTemplate.postForObject(
                url, 
                request, 
                MLPredictionResponse.class
            );
            
            log.info("ML prediction received: {}", response);
            return response;
            
        } catch (RestClientException e) {
            log.error("Error calling ML service for prediction", e);
            return getDefaultPrediction();
        }
    }
    
    /**
     * Get personalized vocabulary recommendations
     */
    public MLRecommendationResponse getRecommendations(MLRecommendationRequest request) {
        if (!mlServiceEnabled) {
            log.warn("ML Service is disabled, returning empty recommendations");
            return new MLRecommendationResponse(List.of(), null, 10, 60);
        }
        
        try {
            String url = mlServiceBaseUrl + "/api/recommend/vocabulary";
            log.info("Calling ML service for recommendations: {}", url);
            
            MLRecommendationResponse response = mlRestTemplate.postForObject(
                url,
                request,
                MLRecommendationResponse.class
            );
            
            log.info("ML recommendations received: {} items", 
                     response.getRecommendations().size());
            return response;
            
        } catch (RestClientException e) {
            log.error("Error calling ML service for recommendations", e);
            return new MLRecommendationResponse(List.of(), null, 10, 60);
        }
    }
    
    /**
     * Trigger model retraining (async)
     */
    public void triggerModelRetraining() {
        if (!mlServiceEnabled) {
            return;
        }
        
        try {
            String url = mlServiceBaseUrl + "/api/train/trigger";
            mlRestTemplate.postForObject(url, null, Void.class);
            log.info("Model retraining triggered successfully");
        } catch (RestClientException e) {
            log.error("Error triggering model retraining", e);
        }
    }
    
    /**
     * Check ML service health
     */
    public boolean isMLServiceHealthy() {
        if (!mlServiceEnabled) {
            return false;
        }
        
        try {
            String url = mlServiceBaseUrl + "/health";
            String response = mlRestTemplate.getForObject(url, String.class);
            return "OK".equals(response);
        } catch (RestClientException e) {
            log.error("ML service health check failed", e);
            return false;
        }
    }
    
    private MLPredictionResponse getDefaultPrediction() {
        return new MLPredictionResponse(5.0, 0.5, 7, "LOW");
    }
}
```

#### f. Use Case Integration

```java
package com.thuanthichlaptrinh.card_words.core.usecase.vocab;

import com.thuanthichlaptrinh.card_words.core.domain.ml.*;
import com.thuanthichlaptrinh.card_words.core.service.MLService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class GetPersonalizedVocabUseCase {
    
    private final MLService mlService;
    private final VocabularyService vocabularyService;
    
    public List<VocabRecommendation> execute(Long userId, Integer limit) {
        // Get user stats
        UserStats stats = vocabularyService.getUserStats(userId);
        
        // Build ML request
        MLRecommendationRequest mlRequest = MLRecommendationRequest.builder()
                .userId(userId)
                .currentLevel(stats.getLevel())
                .currentStreak(stats.getStreak())
                .preferredGameType(stats.getPreferredGameType())
                .limit(limit)
                .build();
        
        // Get ML recommendations
        MLRecommendationResponse mlResponse = mlService.getRecommendations(mlRequest);
        
        // Convert to domain objects
        return mlResponse.getRecommendations().stream()
                .map(rec -> new VocabRecommendation(
                    vocabularyService.findById(rec.getVocabId()),
                    rec.getPriority(),
                    rec.getReason()
                ))
                .collect(Collectors.toList());
    }
}
```

#### g. REST Controller

```java
package com.thuanthichlaptrinh.card_words.entrypoint.rest.controller;

import com.thuanthichlaptrinh.card_words.core.usecase.vocab.GetPersonalizedVocabUseCase;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/ml")
@RequiredArgsConstructor
public class MLController {
    
    private final GetPersonalizedVocabUseCase getPersonalizedVocabUseCase;
    private final MLService mlService;
    
    @GetMapping("/recommendations/{userId}")
    public ResponseEntity<?> getRecommendations(
            @PathVariable Long userId,
            @RequestParam(defaultValue = "10") Integer limit) {
        
        var recommendations = getPersonalizedVocabUseCase.execute(userId, limit);
        return ResponseEntity.ok(recommendations);
    }
    
    @GetMapping("/health")
    public ResponseEntity<?> checkMLServiceHealth() {
        boolean healthy = mlService.isMLServiceHealthy();
        return ResponseEntity.ok(Map.of("healthy", healthy));
    }
    
    @PostMapping("/retrain")
    public ResponseEntity<?> triggerRetraining() {
        mlService.triggerModelRetraining();
        return ResponseEntity.ok(Map.of("message", "Retraining triggered"));
    }
}
```

---

### 4.2 Python ML Service Side

#### a. Project Structure

```
ml-service/
├── app.py                    # Main Flask application
├── requirements.txt          # Python dependencies
├── config.py                # Configuration
├── models/                  # Trained models
│   ├── difficulty_model.pkl
│   ├── mastery_model.pkl
│   └── recommendation_model.pkl
├── src/
│   ├── __init__.py
│   ├── data_collector.py   # Collect data from DB
│   ├── feature_engineering.py
│   ├── model_trainer.py    # Training scripts
│   ├── predictor.py        # Prediction logic
│   └── recommender.py      # Recommendation logic
├── notebooks/               # Jupyter notebooks for experiments
│   └── analysis.ipynb
└── tests/
    └── test_api.py
```

#### b. requirements.txt

```txt
# Web framework
flask==3.0.0
flask-cors==4.0.0

# ML Libraries
scikit-learn==1.3.2
numpy==1.24.3
pandas==2.1.3
joblib==1.3.2

# Optional: Deep Learning
# tensorflow==2.15.0
# torch==2.1.0

# Database
psycopg2-binary==2.9.9
sqlalchemy==2.0.23

# Utilities
python-dotenv==1.0.0
pydantic==2.5.0

# Monitoring
prometheus-client==0.19.0
```

#### c. config.py

```python
import os
from dotenv import load_dotenv

load_dotenv()

class Config:
    # Flask
    DEBUG = os.getenv('DEBUG', 'False') == 'True'
    HOST = os.getenv('HOST', '0.0.0.0')
    PORT = int(os.getenv('PORT', 5000))
    
    # Database
    DB_HOST = os.getenv('DB_HOST', 'localhost')
    DB_PORT = int(os.getenv('DB_PORT', 5432))
    DB_NAME = os.getenv('DB_NAME', 'card_words')
    DB_USER = os.getenv('DB_USER', 'postgres')
    DB_PASSWORD = os.getenv('DB_PASSWORD', 'password')
    
    DATABASE_URL = f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
    
    # ML Models
    MODEL_DIR = os.path.join(os.path.dirname(__file__), 'models')
    DIFFICULTY_MODEL_PATH = os.path.join(MODEL_DIR, 'difficulty_model.pkl')
    MASTERY_MODEL_PATH = os.path.join(MODEL_DIR, 'mastery_model.pkl')
    
    # Training
    MIN_SAMPLES_FOR_TRAINING = 100
    RETRAIN_SCHEDULE = '0 2 * * *'  # Daily at 2 AM
```

#### d. app.py (Flask Application)

```python
from flask import Flask, request, jsonify
from flask_cors import CORS
import logging
from datetime import datetime

from config import Config
from src.predictor import DifficultyPredictor, MasteryPredictor
from src.recommender import VocabRecommender

# Setup logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# Initialize Flask app
app = Flask(__name__)
CORS(app)

# Load ML models
try:
    difficulty_predictor = DifficultyPredictor(Config.DIFFICULTY_MODEL_PATH)
    mastery_predictor = MasteryPredictor(Config.MASTERY_MODEL_PATH)
    recommender = VocabRecommender(Config.DATABASE_URL)
    logger.info("ML models loaded successfully")
except Exception as e:
    logger.error(f"Error loading ML models: {e}")
    difficulty_predictor = None
    mastery_predictor = None
    recommender = None

# Health check
@app.route('/health', methods=['GET'])
def health_check():
    return "OK", 200

@app.route('/api/status', methods=['GET'])
def status():
    return jsonify({
        'status': 'running',
        'timestamp': datetime.now().isoformat(),
        'models_loaded': {
            'difficulty': difficulty_predictor is not None,
            'mastery': mastery_predictor is not None,
            'recommender': recommender is not None
        }
    })

# Predict difficulty and mastery
@app.route('/api/predict/difficulty', methods=['POST'])
def predict_difficulty():
    try:
        data = request.json
        logger.info(f"Received prediction request: {data}")
        
        # Validate input
        required_fields = ['userId', 'vocabId', 'word']
        if not all(field in data for field in required_fields):
            return jsonify({'error': 'Missing required fields'}), 400
        
        # Extract features
        features = {
            'user_id': data['userId'],
            'vocab_id': data['vocabId'],
            'word': data['word'],
            'current_difficulty': data.get('currentDifficulty', 5),
            'attempt_count': data.get('attemptCount', 0),
            'success_rate': data.get('successRate', 0.0),
            'current_streak': data.get('currentStreak', 0)
        }
        
        # Make predictions
        difficulty = difficulty_predictor.predict(features)
        mastery_prob = mastery_predictor.predict(features)
        
        # Calculate recommended review days (spaced repetition)
        review_days = calculate_review_interval(mastery_prob, features['success_rate'])
        
        # Determine confidence
        confidence = determine_confidence(features['attempt_count'])
        
        response = {
            'predictedDifficulty': float(difficulty),
            'masteryProbability': float(mastery_prob),
            'recommendedReviewDays': int(review_days),
            'confidence': confidence
        }
        
        logger.info(f"Prediction result: {response}")
        return jsonify(response)
        
    except Exception as e:
        logger.error(f"Error in predict_difficulty: {e}", exc_info=True)
        return jsonify({'error': str(e)}), 500

# Get personalized recommendations
@app.route('/api/recommend/vocabulary', methods=['POST'])
def recommend_vocabulary():
    try:
        data = request.json
        logger.info(f"Received recommendation request: {data}")
        
        if 'userId' not in data:
            return jsonify({'error': 'userId is required'}), 400
        
        user_id = data['userId']
        limit = data.get('limit', 10)
        current_level = data.get('currentLevel', 1)
        current_streak = data.get('currentStreak', 0)
        
        # Get recommendations
        recommendations = recommender.get_personalized_recommendations(
            user_id=user_id,
            limit=limit,
            current_level=current_level,
            current_streak=current_streak
        )
        
        # Suggest optimal game settings
        game_suggestion = recommender.suggest_game_settings(
            user_id=user_id,
            current_streak=current_streak
        )
        
        response = {
            'recommendations': recommendations,
            'gameTypeSuggestion': game_suggestion['game_type'],
            'suggestedQuestionCount': game_suggestion['question_count'],
            'suggestedTimeLimit': game_suggestion['time_limit']
        }
        
        logger.info(f"Recommendation result: {len(recommendations)} items")
        return jsonify(response)
        
    except Exception as e:
        logger.error(f"Error in recommend_vocabulary: {e}", exc_info=True)
        return jsonify({'error': str(e)}), 500

# Trigger model retraining
@app.route('/api/train/trigger', methods=['POST'])
def trigger_training():
    try:
        logger.info("Model retraining triggered")
        # This would typically be handled by a background job
        # For now, just acknowledge the request
        return jsonify({'message': 'Training scheduled'}), 202
    except Exception as e:
        logger.error(f"Error triggering training: {e}")
        return jsonify({'error': str(e)}), 500

# Helper functions
def calculate_review_interval(mastery_prob, success_rate):
    """Calculate optimal review interval using spaced repetition"""
    if mastery_prob > 0.8:
        return 30  # Review in a month
    elif mastery_prob > 0.6:
        return 14  # Review in 2 weeks
    elif mastery_prob > 0.4:
        return 7   # Review in a week
    elif success_rate > 0.5:
        return 3   # Review in 3 days
    else:
        return 1   # Review tomorrow

def determine_confidence(attempt_count):
    """Determine prediction confidence based on data availability"""
    if attempt_count >= 10:
        return 'HIGH'
    elif attempt_count >= 5:
        return 'MEDIUM'
    else:
        return 'LOW'

if __name__ == '__main__':
    app.run(
        host=Config.HOST,
        port=Config.PORT,
        debug=Config.DEBUG
    )
```

#### e. src/data_collector.py

```python
import pandas as pd
from sqlalchemy import create_engine, text
import logging

logger = logging.getLogger(__name__)

class DataCollector:
    def __init__(self, database_url):
        self.engine = create_engine(database_url)
    
    def collect_training_data(self):
        """Collect data for training ML models"""
        query = """
        SELECT 
            v.id as vocab_id,
            v.word,
            v.translation,
            v.difficulty as current_difficulty,
            LENGTH(v.word) as word_length,
            u.id as user_id,
            u.current_streak,
            u.longest_streak,
            uvp.status,
            uvp.created_at,
            uvp.updated_at,
            COUNT(uvp.id) OVER (PARTITION BY v.id, u.id) as attempt_count,
            SUM(CASE WHEN uvp.status = 'known' THEN 1 ELSE 0 END) 
                OVER (PARTITION BY v.id, u.id) as known_count,
            SUM(CASE WHEN uvp.status = 'mastered' THEN 1 ELSE 0 END) 
                OVER (PARTITION BY v.id, u.id) as mastered_count,
            EXTRACT(EPOCH FROM (uvp.updated_at - uvp.created_at)) as learning_time_seconds
        FROM vocabulary v
        CROSS JOIN users u
        LEFT JOIN user_vocab_progress uvp 
            ON v.id = uvp.vocab_id AND u.id = uvp.user_id
        WHERE uvp.id IS NOT NULL
        ORDER BY u.id, v.id, uvp.created_at
        """
        
        try:
            df = pd.read_sql(query, self.engine)
            logger.info(f"Collected {len(df)} training samples")
            return df
        except Exception as e:
            logger.error(f"Error collecting training data: {e}")
            return pd.DataFrame()
    
    def get_user_learning_history(self, user_id):
        """Get learning history for a specific user"""
        query = text("""
        SELECT 
            v.id as vocab_id,
            v.word,
            v.difficulty,
            uvp.status,
            uvp.created_at,
            uvp.updated_at
        FROM vocabulary v
        JOIN user_vocab_progress uvp ON v.id = uvp.vocab_id
        WHERE uvp.user_id = :user_id
        ORDER BY uvp.created_at DESC
        """)
        
        with self.engine.connect() as conn:
            df = pd.read_sql(query, conn, params={'user_id': user_id})
        
        return df
    
    def get_vocab_statistics(self):
        """Get statistics for all vocabulary"""
        query = """
        SELECT 
            v.id as vocab_id,
            v.word,
            v.difficulty,
            COUNT(DISTINCT uvp.user_id) as user_count,
            COUNT(uvp.id) as total_attempts,
            AVG(CASE WHEN uvp.status = 'known' THEN 1.0 ELSE 0.0 END) as avg_success_rate,
            AVG(CASE WHEN uvp.status = 'mastered' THEN 1.0 ELSE 0.0 END) as mastery_rate
        FROM vocabulary v
        LEFT JOIN user_vocab_progress uvp ON v.id = uvp.vocab_id
        GROUP BY v.id, v.word, v.difficulty
        HAVING COUNT(uvp.id) > 0
        """
        
        df = pd.read_sql(query, self.engine)
        return df
```

#### f. src/feature_engineering.py

```python
import numpy as np
import pandas as pd
from datetime import datetime, timedelta

class FeatureEngineering:
    @staticmethod
    def extract_features(data_dict):
        """Extract features from raw data for prediction"""
        features = {}
        
        # Basic features
        features['word_length'] = len(data_dict.get('word', ''))
        features['current_difficulty'] = data_dict.get('current_difficulty', 5)
        features['attempt_count'] = data_dict.get('attempt_count', 0)
        features['success_rate'] = data_dict.get('success_rate', 0.0)
        features['current_streak'] = data_dict.get('current_streak', 0)
        
        # Derived features
        features['has_experience'] = 1 if features['attempt_count'] > 0 else 0
        features['is_difficult'] = 1 if features['current_difficulty'] >= 7 else 0
        features['is_performing_well'] = 1 if features['success_rate'] > 0.7 else 0
        
        # Interaction features
        features['difficulty_x_attempts'] = features['current_difficulty'] * features['attempt_count']
        features['streak_x_success'] = features['current_streak'] * features['success_rate']
        
        return features
    
    @staticmethod
    def engineer_features_dataframe(df):
        """Engineer features for training dataset"""
        df = df.copy()
        
        # Calculate success rate
        df['success_rate'] = df['known_count'] / df['attempt_count'].replace(0, 1)
        
        # Days since first attempt
        df['days_learning'] = (df['updated_at'] - df['created_at']).dt.days
        
        # Word complexity
        df['word_length'] = df['word'].str.len()
        df['has_space'] = df['word'].str.contains(' ').astype(int)
        
        # User engagement
        df['is_active_learner'] = (df['current_streak'] > 0).astype(int)
        
        # Target variable
        df['is_mastered'] = (df['status'] == 'mastered').astype(int)
        
        return df
```

#### g. src/predictor.py

```python
import joblib
import numpy as np
from sklearn.ensemble import RandomForestClassifier, RandomForestRegressor
from sklearn.preprocessing import StandardScaler
import logging

from .feature_engineering import FeatureEngineering

logger = logging.getLogger(__name__)

class DifficultyPredictor:
    def __init__(self, model_path):
        try:
            self.model = joblib.load(model_path)
            self.scaler = joblib.load(model_path.replace('.pkl', '_scaler.pkl'))
            logger.info(f"Difficulty model loaded from {model_path}")
        except FileNotFoundError:
            logger.warning(f"Model not found at {model_path}, using default model")
            self.model = None
            self.scaler = StandardScaler()
    
    def predict(self, data_dict):
        """Predict difficulty level for a vocabulary"""
        if self.model is None:
            return data_dict.get('current_difficulty', 5)
        
        features = FeatureEngineering.extract_features(data_dict)
        feature_vector = self._dict_to_vector(features)
        scaled_features = self.scaler.transform([feature_vector])
        
        prediction = self.model.predict(scaled_features)[0]
        return np.clip(prediction, 1, 10)
    
    def _dict_to_vector(self, features):
        """Convert feature dict to vector"""
        feature_order = [
            'word_length', 'current_difficulty', 'attempt_count',
            'success_rate', 'current_streak', 'has_experience',
            'is_difficult', 'is_performing_well', 'difficulty_x_attempts',
            'streak_x_success'
        ]
        return [features.get(f, 0) for f in feature_order]

class MasteryPredictor:
    def __init__(self, model_path):
        try:
            self.model = joblib.load(model_path)
            self.scaler = joblib.load(model_path.replace('.pkl', '_scaler.pkl'))
            logger.info(f"Mastery model loaded from {model_path}")
        except FileNotFoundError:
            logger.warning(f"Model not found at {model_path}, using default model")
            self.model = None
            self.scaler = StandardScaler()
    
    def predict(self, data_dict):
        """Predict probability of mastering a vocabulary"""
        if self.model is None:
            # Default heuristic
            success_rate = data_dict.get('success_rate', 0.0)
            attempt_count = data_dict.get('attempt_count', 0)
            return min(success_rate * (attempt_count / 10), 1.0)
        
        features = FeatureEngineering.extract_features(data_dict)
        feature_vector = self._dict_to_vector(features)
        scaled_features = self.scaler.transform([feature_vector])
        
        # Get probability for positive class (mastered)
        if hasattr(self.model, 'predict_proba'):
            prediction = self.model.predict_proba(scaled_features)[0][1]
        else:
            prediction = self.model.predict(scaled_features)[0]
        
        return np.clip(prediction, 0, 1)
    
    def _dict_to_vector(self, features):
        feature_order = [
            'word_length', 'current_difficulty', 'attempt_count',
            'success_rate', 'current_streak', 'has_experience',
            'is_difficult', 'is_performing_well', 'difficulty_x_attempts',
            'streak_x_success'
        ]
        return [features.get(f, 0) for f in feature_order]
```

#### h. src/recommender.py

```python
import pandas as pd
from sqlalchemy import create_engine, text
import logging

logger = logging.getLogger(__name__)

class VocabRecommender:
    def __init__(self, database_url):
        self.engine = create_engine(database_url)
    
    def get_personalized_recommendations(self, user_id, limit=10, 
                                        current_level=1, current_streak=0):
        """Get personalized vocabulary recommendations"""
        
        # Query for vocabulary recommendations
        query = text("""
        WITH user_stats AS (
            SELECT 
                vocab_id,
                COUNT(*) as attempt_count,
                MAX(updated_at) as last_attempt,
                AVG(CASE WHEN status = 'known' THEN 1.0 ELSE 0.0 END) as success_rate
            FROM user_vocab_progress
            WHERE user_id = :user_id
            GROUP BY vocab_id
        ),
        vocab_pool AS (
            SELECT 
                v.id,
                v.word,
                v.difficulty,
                COALESCE(us.attempt_count, 0) as attempt_count,
                COALESCE(us.success_rate, 0) as success_rate,
                COALESCE(us.last_attempt, '2000-01-01'::timestamp) as last_attempt
            FROM vocabulary v
            LEFT JOIN user_stats us ON v.id = us.vocab_id
            WHERE v.difficulty <= :max_difficulty
        )
        SELECT 
            id as vocab_id,
            word,
            difficulty,
            attempt_count,
            success_rate,
            -- Priority score calculation
            (
                -- New words get high priority
                CASE WHEN attempt_count = 0 THEN 10.0
                -- Words with low success rate need practice
                WHEN success_rate < 0.5 THEN 8.0
                -- Words not attempted recently
                WHEN EXTRACT(EPOCH FROM (NOW() - last_attempt)) > 604800 THEN 7.0
                -- Default priority
                ELSE 5.0 END
                -- Adjust by difficulty match
                + (10.0 - ABS(difficulty - :target_difficulty))
            ) as priority,
            CASE 
                WHEN attempt_count = 0 THEN 'New vocabulary'
                WHEN success_rate < 0.5 THEN 'Needs more practice'
                WHEN EXTRACT(EPOCH FROM (NOW() - last_attempt)) > 604800 THEN 'Review recommended'
                ELSE 'Continue learning'
            END as reason
        FROM vocab_pool
        ORDER BY priority DESC, RANDOM()
        LIMIT :limit
        """)
        
        # Calculate target difficulty based on user level and streak
        target_difficulty = min(current_level + (current_streak // 10), 10)
        max_difficulty = min(target_difficulty + 2, 10)
        
        with self.engine.connect() as conn:
            result = conn.execute(query, {
                'user_id': user_id,
                'max_difficulty': max_difficulty,
                'target_difficulty': target_difficulty,
                'limit': limit
            })
            
            recommendations = []
            for row in result:
                recommendations.append({
                    'vocabId': row.vocab_id,
                    'word': row.word,
                    'priority': float(row.priority),
                    'reason': row.reason
                })
        
        return recommendations
    
    def suggest_game_settings(self, user_id, current_streak=0):
        """Suggest optimal game settings based on user performance"""
        
        # Query user's game history
        query = text("""
        SELECT 
            AVG(CASE WHEN status = 'known' THEN 1.0 ELSE 0.0 END) as avg_success_rate,
            COUNT(DISTINCT DATE(created_at)) as active_days
        FROM user_vocab_progress
        WHERE user_id = :user_id
            AND created_at >= NOW() - INTERVAL '30 days'
        """)
        
        with self.engine.connect() as conn:
            result = conn.execute(query, {'user_id': user_id}).fetchone()
        
        if result and result.avg_success_rate is not None:
            success_rate = result.avg_success_rate
            active_days = result.active_days
        else:
            success_rate = 0.5
            active_days = 0
        
        # Suggest game type
        if current_streak >= 7 and success_rate > 0.7:
            game_type = 'quick_quiz'  # More challenging
            question_count = 15
            time_limit = 90
        elif success_rate > 0.6:
            game_type = 'word_definition_matching'
            question_count = 10
            time_limit = 60
        else:
            game_type = 'word_image_matching'  # Easier, visual
            question_count = 8
            time_limit = 120
        
        # Adjust based on engagement
        if active_days > 20:
            question_count += 5
        
        return {
            'game_type': game_type,
            'question_count': question_count,
            'time_limit': time_limit
        }
```

#### i. src/model_trainer.py

```python
import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier, RandomForestRegressor
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import accuracy_score, mean_squared_error, classification_report
import joblib
import logging

from .data_collector import DataCollector
from .feature_engineering import FeatureEngineering

logger = logging.getLogger(__name__)

class ModelTrainer:
    def __init__(self, database_url, model_dir):
        self.data_collector = DataCollector(database_url)
        self.model_dir = model_dir
    
    def train_difficulty_model(self):
        """Train model to predict vocabulary difficulty"""
        logger.info("Starting difficulty model training...")
        
        # Collect data
        df = self.data_collector.collect_training_data()
        if len(df) < 100:
            logger.warning(f"Insufficient data for training: {len(df)} samples")
            return False
        
        # Feature engineering
        df = FeatureEngineering.engineer_features_dataframe(df)
        
        # Prepare features and target
        feature_cols = [
            'word_length', 'attempt_count', 'success_rate',
            'current_streak', 'days_learning'
        ]
        X = df[feature_cols].fillna(0)
        y = df['current_difficulty']
        
        # Split data
        X_train, X_test, y_train, y_test = train_test_split(
            X, y, test_size=0.2, random_state=42
        )
        
        # Scale features
        scaler = StandardScaler()
        X_train_scaled = scaler.fit_transform(X_train)
        X_test_scaled = scaler.transform(X_test)
        
        # Train model
        model = RandomForestRegressor(
            n_estimators=100,
            max_depth=10,
            random_state=42
        )
        model.fit(X_train_scaled, y_train)
        
        # Evaluate
        y_pred = model.predict(X_test_scaled)
        mse = mean_squared_error(y_test, y_pred)
        logger.info(f"Difficulty model MSE: {mse:.4f}")
        
        # Save model
        model_path = f"{self.model_dir}/difficulty_model.pkl"
        scaler_path = f"{self.model_dir}/difficulty_model_scaler.pkl"
        joblib.dump(model, model_path)
        joblib.dump(scaler, scaler_path)
        logger.info(f"Difficulty model saved to {model_path}")
        
        return True
    
    def train_mastery_model(self):
        """Train model to predict mastery probability"""
        logger.info("Starting mastery model training...")
        
        # Collect data
        df = self.data_collector.collect_training_data()
        if len(df) < 100:
            logger.warning(f"Insufficient data for training: {len(df)} samples")
            return False
        
        # Feature engineering
        df = FeatureEngineering.engineer_features_dataframe(df)
        
        # Prepare features and target
        feature_cols = [
            'word_length', 'current_difficulty', 'attempt_count',
            'success_rate', 'current_streak', 'days_learning'
        ]
        X = df[feature_cols].fillna(0)
        y = df['is_mastered']
        
        # Split data
        X_train, X_test, y_train, y_test = train_test_split(
            X, y, test_size=0.2, random_state=42, stratify=y
        )
        
        # Scale features
        scaler = StandardScaler()
        X_train_scaled = scaler.fit_transform(X_train)
        X_test_scaled = scaler.transform(X_test)
        
        # Train model
        model = RandomForestClassifier(
            n_estimators=100,
            max_depth=10,
            class_weight='balanced',
            random_state=42
        )
        model.fit(X_train_scaled, y_train)
        
        # Evaluate
        y_pred = model.predict(X_test_scaled)
        accuracy = accuracy_score(y_test, y_pred)
        logger.info(f"Mastery model accuracy: {accuracy:.4f}")
        logger.info("\n" + classification_report(y_test, y_pred))
        
        # Save model
        model_path = f"{self.model_dir}/mastery_model.pkl"
        scaler_path = f"{self.model_dir}/mastery_model_scaler.pkl"
        joblib.dump(model, model_path)
        joblib.dump(scaler, scaler_path)
        logger.info(f"Mastery model saved to {model_path}")
        
        return True
    
    def train_all_models(self):
        """Train all ML models"""
        logger.info("Starting training for all models...")
        
        difficulty_success = self.train_difficulty_model()
        mastery_success = self.train_mastery_model()
        
        if difficulty_success and mastery_success:
            logger.info("All models trained successfully!")
            return True
        else:
            logger.error("Some models failed to train")
            return False
```

---

## 5. Deployment với Docker

### 5.1 Dockerfile cho Python ML Service

```dockerfile
# Dockerfile (ml-service/Dockerfile)
FROM python:3.11-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Create models directory
RUN mkdir -p models

# Expose port
EXPOSE 5000

# Run application
CMD ["python", "app.py"]
```

### 5.2 Update docker-compose.yml

```yaml
version: '3.8'

services:
  # Existing PostgreSQL service
  postgres:
    image: postgres:15
    environment:
      POSTGRES_DB: card_words
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
  
  # Spring Boot application
  app:
    build: .
    ports:
      - "8080:8080"
    environment:
      SPRING_DATASOURCE_URL: jdbc:postgresql://postgres:5432/card_words
      ML_SERVICE_BASE_URL: http://ml-service:5000
    depends_on:
      - postgres
      - ml-service
  
  # Python ML service
  ml-service:
    build:
      context: ./ml-service
      dockerfile: Dockerfile
    ports:
      - "5000:5000"
    environment:
      DB_HOST: postgres
      DB_PORT: 5432
      DB_NAME: card_words
      DB_USER: postgres
      DB_PASSWORD: password
      FLASK_ENV: production
    depends_on:
      - postgres
    volumes:
      - ml_models:/app/models

volumes:
  postgres_data:
  ml_models:
```

---

## 6. Testing và Monitoring

### 6.1 Test API endpoints

```bash
# Test ML service health
curl http://localhost:5000/health

# Test prediction
curl -X POST http://localhost:5000/api/predict/difficulty \
  -H "Content-Type: application/json" \
  -d '{
    "userId": 1,
    "vocabId": 10,
    "word": "hello",
    "currentDifficulty": 5,
    "attemptCount": 3,
    "successRate": 0.67,
    "currentStreak": 5
  }'

# Test recommendations
curl -X POST http://localhost:5000/api/recommend/vocabulary \
  -H "Content-Type: application/json" \
  -d '{
    "userId": 1,
    "limit": 10,
    "currentLevel": 3,
    "currentStreak": 7
  }'
```

### 6.2 Monitoring

```python
# Add to app.py for basic monitoring
from prometheus_client import Counter, Histogram, generate_latest

# Metrics
prediction_counter = Counter('ml_predictions_total', 'Total predictions made')
prediction_duration = Histogram('ml_prediction_duration_seconds', 'Prediction duration')

@app.route('/metrics')
def metrics():
    return generate_latest()
```

---

## 7. Training và Maintenance

### 7.1 Initial Training Script

```python
# train_initial_models.py
from src.model_trainer import ModelTrainer
from config import Config
import os

def main():
    # Create model directory if not exists
    os.makedirs(Config.MODEL_DIR, exist_ok=True)
    
    # Initialize trainer
    trainer = ModelTrainer(Config.DATABASE_URL, Config.MODEL_DIR)
    
    # Train all models
    success = trainer.train_all_models()
    
    if success:
        print("✓ All models trained successfully!")
    else:
        print("✗ Model training failed")
        exit(1)

if __name__ == '__main__':
    main()
```

### 7.2 Scheduled Retraining

```python
# scheduled_training.py
from apscheduler.schedulers.blocking import BlockingScheduler
from src.model_trainer import ModelTrainer
from config import Config
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

scheduler = BlockingScheduler()

@scheduler.scheduled_job('cron', hour=2, minute=0)
def retrain_models():
    logger.info("Starting scheduled model retraining...")
    trainer = ModelTrainer(Config.DATABASE_URL, Config.MODEL_DIR)
    trainer.train_all_models()
    logger.info("Scheduled retraining completed")

if __name__ == '__main__':
    logger.info("Starting scheduled training service...")
    scheduler.start()
```

---

## 8. Best Practices và Tips

### 8.1 Performance Optimization

1. **Caching**: Cache predictions cho requests giống nhau
2. **Batch Processing**: Gom nhiều predictions thành 1 request
3. **Async Processing**: Sử dụng async cho non-critical predictions
4. **Model versioning**: Lưu nhiều versions của model

### 8.2 Error Handling

1. **Fallback values**: Luôn có giá trị mặc định khi ML service fail
2. **Circuit breaker**: Ngừng gọi ML service khi fail liên tục
3. **Timeout**: Set timeout hợp lý cho ML requests
4. **Logging**: Log đầy đủ để debug

### 8.3 Data Quality

1. **Data validation**: Validate input trước khi training
2. **Outlier detection**: Phát hiện và xử lý outliers
3. **Regular retraining**: Retrain model định kỳ với data mới
4. **A/B testing**: Test model mới trước khi deploy

---

## 9. Roadmap và Next Steps

### Phase 1: Foundation (Week 1-2)
- [ ] Setup Python ML service
- [ ] Implement basic prediction API
- [ ] Integrate with Spring Boot
- [ ] Deploy with Docker

### Phase 2: Basic ML (Week 3-4)
- [ ] Train difficulty prediction model
- [ ] Train mastery prediction model
- [ ] Implement recommendation system
- [ ] Add monitoring

### Phase 3: Advanced Features (Week 5-6)
- [ ] Spaced repetition algorithm
- [ ] Personalized learning paths
- [ ] Game settings optimization
- [ ] Performance analytics

### Phase 4: Optimization (Week 7-8)
- [ ] Model optimization
- [ ] Performance tuning
- [ ] A/B testing
- [ ] Documentation

---

## 10. Tài liệu tham khảo

### Machine Learning
- Scikit-learn documentation: https://scikit-learn.org/
- Spaced Repetition: https://en.wikipedia.org/wiki/Spaced_repetition
- Recommendation Systems: https://developers.google.com/machine-learning/recommendation

### Integration
- Flask documentation: https://flask.palletsprojects.com/
- Spring RestTemplate: https://spring.io/guides/gs/consuming-rest/
- Docker Compose: https://docs.docker.com/compose/

### Best Practices
- ML in Production: https://ml-ops.org/
- API Design: https://restfulapi.net/
- Microservices: https://microservices.io/

---

## Kết luận

Việc tích hợp Machine Learning vào dự án học tiếng Anh sẽ mang lại:

1. **Trải nghiệm cá nhân hóa** cho từng user
2. **Tối ưu hóa hiệu quả học tập** thông qua recommendations
3. **Insights về học tập** từ data analytics
4. **Competitive advantage** so với các app khác

Bắt đầu với approach đơn giản (REST API) và mở rộng dần khi có nhiều data và users hơn.

