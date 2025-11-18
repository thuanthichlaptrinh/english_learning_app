# Design Document - XGBoost Smart Vocabulary Review

## Overview

Hệ thống gợi ý ôn tập từ vựng thông minh sử dụng XGBoost (Extreme Gradient Boosting) để phân tích dữ liệu học tập của người dùng và đưa ra danh sách từ vựng được ưu tiên để ôn tập. Hệ thống được xây dựng như một microservice Python FastAPI độc lập, chạy song song với Spring Boot backend trong cùng một docker-compose environment.

### Key Features

- **Machine Learning Model**: XGBoost classifier để dự đoán từ vựng cần ôn tập
- **Feature Engineering**: Trích xuất 9 đặc trưng từ UserVocabProgress
- **Smart Caching**: Redis cache với TTL 5 phút
- **RESTful API**: FastAPI endpoints với JWT authentication
- **Async Operations**: Async database queries và Redis operations
- **Model Retraining**: Admin API để huấn luyện lại model
- **Monitoring**: Health checks, metrics, và structured logging

### Technology Stack

- **Framework**: FastAPI 0.104+
- **ML Library**: XGBoost 2.0+, scikit-learn 1.3+
- **Database**: PostgreSQL 16 (read-only via SQLAlchemy + asyncpg)
- **Cache**: Redis 7 (redis-py)
- **Data Processing**: NumPy 1.24+, Pandas 2.0+
- **Deployment**: Docker, docker-compose
- **Dependency Management**: Poetry

## Architecture

### System Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                         Client (Mobile/Web)                      │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Spring Boot Backend (Port 8080)               │
│  - Authentication & Authorization                                │
│  - Business Logic                                                │
│  - REST Client to AI Service                                     │
└────────┬────────────────────────────────────┬────────────────────┘
         │                                    │
         │ Forward Request                    │ Enrich Response
         │                                    │
         ▼                                    ▼
┌─────────────────────────────────────────────────────────────────┐
│              Python AI Service (Port 8001)                       │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  FastAPI Application                                     │   │
│  │  - JWT Validation Middleware                             │   │
│  │  - Rate Limiting                                         │   │
│  │  - CORS                                                  │   │
│  └──────────────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  ML Pipeline                                             │   │
│  │  1. Feature Extractor                                   │   │
│  │  2. XGBoost Model (loaded in memory)                    │   │
│  │  3. Prediction Engine                                   │   │
│  │  4. Result Ranker                                       │   │
│  └──────────────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  Data Layer                                              │   │
│  │  - SQLAlchemy ORM (async)                               │   │
│  │  - Redis Client (async)                                 │   │
│  └──────────────────────────────────────────────────────────┘   │
└────────┬────────────────────────────────────┬────────────────────┘
         │                                    │
         │ Read UserVocabProgress             │ Cache Results
         │                                    │
         ▼                                    ▼
┌──────────────────────┐            ┌──────────────────────┐
│   PostgreSQL DB      │            │      Redis Cache     │
│   (Port 5432)        │            │      (Port 6379)     │
│   - user_vocab_      │            │   - Predictions      │
│     progress         │            │   - Model metadata   │
│   - vocabs           │            │   - TTL: 5 minutes   │
└──────────────────────┘            └──────────────────────┘
```

### Request Flow

1. **Client → Spring Boot**: User requests smart review recommendations
2. **Spring Boot → AI Service**: Forward request with JWT token and user_id
3. **AI Service**: 
   - Validate JWT token
   - Check Redis cache
   - If cache miss: Query database → Extract features → Predict with XGBoost → Cache results
   - If cache hit: Return cached results
4. **AI Service → Spring Boot**: Return vocab list with priority scores
5. **Spring Boot**: Enrich with imageUrl, audioUrl, topicName
6. **Spring Boot → Client**: Return final response

## Components and Interfaces

### 1. API Layer

#### 1.1. Endpoints

**POST /api/v1/smart-review/predict**
- **Purpose**: Get smart vocabulary review recommendations
- **Authentication**: JWT Bearer token (required)
- **Rate Limit**: 60 requests/minute per user
- **Request Body**:
```json
{
  "user_id": "uuid",
  "limit": 20
}
```
- **Response**:
```json
{
  "user_id": "uuid",
  "vocabs": [
    {
      "vocab_id": "uuid",
      "word": "abandon",
      "meaning_vi": "từ bỏ",
      "transcription": "/əˈbændən/",
      "priority_score": 0.92,
      "status": "UNKNOWN",
      "times_correct": 2,
      "times_wrong": 5,
      "last_reviewed": "2024-11-10",
      "next_review_date": "2024-11-18"
    }
  ],
  "total": 20,
  "meta": {
    "cached": false,
    "model_version": "v1.0.0",
    "inference_time_ms": 145
  }
}
```

**POST /api/v1/smart-review/retrain**
- **Purpose**: Retrain XGBoost model with latest data
- **Authentication**: Admin API key (required)
- **Request Body**:
```json
{
  "force": false
}
```
- **Response**:
```json
{
  "success": true,
  "model_version": "v1.0.1",
  "metrics": {
    "accuracy": 0.87,
    "precision": 0.85,
    "recall": 0.89,
    "f1_score": 0.87,
    "auc_roc": 0.91
  },
  "training_time_seconds": 45.2,
  "samples_trained": 15000
}
```

**POST /api/v1/smart-review/invalidate-cache**
- **Purpose**: Invalidate cache for a user (called when user submits learning result)
- **Authentication**: Internal API key
- **Request Body**:
```json
{
  "user_id": "uuid"
}
```

**GET /health**
- **Purpose**: Health check for Docker/Kubernetes
- **Authentication**: None
- **Response**:
```json
{
  "status": "healthy",
  "service": "card-words-ai",
  "model_loaded": true,
  "database_connected": true,
  "redis_connected": true,
  "timestamp": "2024-11-18T10:30:00Z"
}
```

**GET /metrics**
- **Purpose**: Prometheus-style metrics
- **Authentication**: None
- **Response**:
```json
{
  "total_requests": 1523,
  "cache_hit_rate": 0.78,
  "average_inference_time_ms": 120,
  "model_version": "v1.0.0",
  "last_training_time": "2024-11-15T08:00:00Z"
}
```

#### 1.2. Middleware

**JWT Authentication Middleware**
```python
async def verify_jwt_token(request: Request):
    """
    Verify JWT token from Authorization header
    - Extract token from "Bearer <token>"
    - Decode using shared JWT_SECRET
    - Validate expiration
    - Extract user_id from payload
    """
```

**Rate Limiting Middleware**
```python
async def rate_limit_middleware(request: Request):
    """
    Rate limit per user_id
    - Max 60 requests/minute
    - Use Redis to track request counts
    - Return 429 if exceeded
    """
```

**Error Handler Middleware**
```python
async def error_handler(request: Request, exc: Exception):
    """
    Global error handler
    - Log errors with structured logging
    - Return appropriate HTTP status codes
    - Hide internal errors from clients
    """
```

### 2. ML Pipeline Components

#### 2.1. Feature Extractor

**Class**: `VocabFeatureExtractor`

**Purpose**: Extract and normalize features from UserVocabProgress

**Features** (9 dimensions):
1. **times_correct** (int): Number of correct answers
2. **times_wrong** (int): Number of wrong answers
3. **accuracy_rate** (float): times_correct / (times_correct + times_wrong)
4. **days_since_last_review** (int): Days from last_reviewed to today
5. **days_until_next_review** (int): Days from today to next_review_date (negative if overdue)
6. **interval_days** (int): Current interval between reviews
7. **repetition** (int): Number of times reviewed
8. **ef_factor** (float): Easiness factor from SM-2 algorithm
9. **status_encoded** (int): NEW=0, UNKNOWN=1, KNOWN=2, MASTERED=3

**Methods**:
```python
class VocabFeatureExtractor:
    def __init__(self, scaler: StandardScaler):
        self.scaler = scaler
    
    def extract_features(self, progress: UserVocabProgress) -> np.ndarray:
        """Extract raw features from UserVocabProgress"""
        
    def normalize_features(self, features: np.ndarray) -> np.ndarray:
        """Normalize features using fitted scaler"""
        
    def extract_and_normalize(self, progress_list: List[UserVocabProgress]) -> np.ndarray:
        """Extract and normalize features for a batch"""
```

**Feature Engineering Logic**:
```python
def extract_features(self, progress: UserVocabProgress) -> np.ndarray:
    # Calculate accuracy rate
    total_attempts = progress.times_correct + progress.times_wrong
    accuracy_rate = progress.times_correct / total_attempts if total_attempts > 0 else 0.0
    
    # Calculate days since last review
    if progress.last_reviewed:
        days_since = (date.today() - progress.last_reviewed).days
    else:
        days_since = 999  # Never reviewed
    
    # Calculate days until next review (negative if overdue)
    if progress.next_review_date:
        days_until = (progress.next_review_date - date.today()).days
    else:
        days_until = 0
    
    # Encode status
    status_map = {"NEW": 0, "UNKNOWN": 1, "KNOWN": 2, "MASTERED": 3}
    status_encoded = status_map.get(progress.status, 0)
    
    return np.array([
        progress.times_correct,
        progress.times_wrong,
        accuracy_rate,
        days_since,
        days_until,
        progress.interval_days,
        progress.repetition,
        progress.ef_factor,
        status_encoded
    ])
```

#### 2.2. XGBoost Model

**Class**: `XGBoostVocabModel`

**Purpose**: Train and predict using XGBoost classifier

**Hyperparameters**:
```python
xgb_params = {
    'max_depth': 6,
    'learning_rate': 0.1,
    'n_estimators': 100,
    'objective': 'binary:logistic',
    'eval_metric': 'auc',
    'subsample': 0.8,
    'colsample_bytree': 0.8,
    'random_state': 42
}
```

**Methods**:
```python
class XGBoostVocabModel:
    def __init__(self, model_path: str):
        self.model = None
        self.model_path = model_path
        self.scaler = StandardScaler()
        
    def train(self, X_train: np.ndarray, y_train: np.ndarray, 
              X_val: np.ndarray, y_val: np.ndarray) -> Dict:
        """Train XGBoost model and return metrics"""
        
    def predict_proba(self, X: np.ndarray) -> np.ndarray:
        """Predict probability scores for vocabs"""
        
    def save_model(self, version: str):
        """Save model and scaler to disk"""
        
    def load_model(self):
        """Load model and scaler from disk"""
        
    def evaluate(self, X_test: np.ndarray, y_test: np.ndarray) -> Dict:
        """Evaluate model and return metrics"""
```

**Training Logic**:
```python
def train(self, X_train, y_train, X_val, y_val):
    # Fit scaler on training data
    X_train_scaled = self.scaler.fit_transform(X_train)
    X_val_scaled = self.scaler.transform(X_val)
    
    # Train XGBoost
    self.model = xgb.XGBClassifier(**xgb_params)
    self.model.fit(
        X_train_scaled, y_train,
        eval_set=[(X_val_scaled, y_val)],
        early_stopping_rounds=10,
        verbose=False
    )
    
    # Evaluate
    y_pred = self.model.predict(X_val_scaled)
    y_pred_proba = self.model.predict_proba(X_val_scaled)[:, 1]
    
    metrics = {
        'accuracy': accuracy_score(y_val, y_pred),
        'precision': precision_score(y_val, y_pred),
        'recall': recall_score(y_val, y_pred),
        'f1_score': f1_score(y_val, y_pred),
        'auc_roc': roc_auc_score(y_val, y_pred_proba)
    }
    
    return metrics
```

**Label Generation Logic**:
```python
def generate_labels(progress_list: List[UserVocabProgress]) -> np.ndarray:
    """
    Generate binary labels for training:
    - Label = 1 (need review) if:
      - status is UNKNOWN or NEW, OR
      - status is KNOWN AND (overdue OR low accuracy)
    - Label = 0 (no need review) otherwise
    """
    labels = []
    for progress in progress_list:
        days_until = (progress.next_review_date - date.today()).days if progress.next_review_date else 0
        total = progress.times_correct + progress.times_wrong
        accuracy = progress.times_correct / total if total > 0 else 0
        
        need_review = (
            progress.status in ['UNKNOWN', 'NEW'] or
            (progress.status == 'KNOWN' and (days_until <= 0 or accuracy < 0.7))
        )
        
        labels.append(1 if need_review else 0)
    
    return np.array(labels)
```

#### 2.3. Prediction Service

**Class**: `SmartReviewService`

**Purpose**: Orchestrate the prediction pipeline

**Methods**:
```python
class SmartReviewService:
    def __init__(self, model: XGBoostVocabModel, 
                 feature_extractor: VocabFeatureExtractor,
                 cache_service: CacheService,
                 db_service: DatabaseService):
        self.model = model
        self.feature_extractor = feature_extractor
        self.cache = cache_service
        self.db = db_service
    
    async def get_recommendations(self, user_id: str, limit: int) -> Dict:
        """Get smart review recommendations for user"""
        
    async def invalidate_user_cache(self, user_id: str):
        """Invalidate cache when user submits learning result"""
```

**Prediction Flow**:
```python
async def get_recommendations(self, user_id: str, limit: int):
    # 1. Check cache
    cache_key = f"smart_review:{user_id}"
    cached = await self.cache.get(cache_key)
    if cached:
        return cached
    
    # 2. Query database for user's vocab progress
    progress_list = await self.db.get_user_vocab_progress(
        user_id=user_id,
        statuses=['NEW', 'UNKNOWN', 'KNOWN']
    )
    
    if not progress_list:
        return {"vocabs": [], "total": 0}
    
    # 3. Extract features
    X = self.feature_extractor.extract_and_normalize(progress_list)
    
    # 4. Predict with XGBoost
    probabilities = self.model.predict_proba(X)
    
    # 5. Rank vocabs by probability
    ranked_indices = np.argsort(probabilities)[::-1]  # Descending
    
    # 6. Build response
    recommendations = []
    for idx in ranked_indices[:limit]:
        progress = progress_list[idx]
        recommendations.append({
            "vocab_id": str(progress.vocab.id),
            "word": progress.vocab.word,
            "meaning_vi": progress.vocab.meaning_vi,
            "transcription": progress.vocab.transcription,
            "priority_score": float(probabilities[idx]),
            "status": progress.status,
            "times_correct": progress.times_correct,
            "times_wrong": progress.times_wrong,
            "last_reviewed": progress.last_reviewed.isoformat() if progress.last_reviewed else None,
            "next_review_date": progress.next_review_date.isoformat() if progress.next_review_date else None
        })
    
    result = {
        "user_id": user_id,
        "vocabs": recommendations,
        "total": len(recommendations),
        "meta": {
            "cached": False,
            "model_version": self.model.version,
            "inference_time_ms": 0  # Will be calculated
        }
    }
    
    # 7. Cache result
    await self.cache.set(cache_key, result, ttl=300)
    
    return result
```

### 3. Data Layer

#### 3.1. Database Models (SQLAlchemy)

**UserVocabProgress Model**:
```python
from sqlalchemy import Column, String, Integer, Float, Date, ForeignKey, Enum
from sqlalchemy.orm import relationship
from sqlalchemy.dialects.postgresql import UUID
import uuid

class UserVocabProgress(Base):
    __tablename__ = 'user_vocab_progress'
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey('users.id'), nullable=False)
    vocab_id = Column(UUID(as_uuid=True), ForeignKey('vocabs.id'), nullable=False)
    
    status = Column(Enum('NEW', 'UNKNOWN', 'KNOWN', 'MASTERED', name='vocab_status'))
    last_reviewed = Column(Date)
    times_correct = Column(Integer, default=0)
    times_wrong = Column(Integer, default=0)
    ef_factor = Column(Float, default=2.5)
    interval_days = Column(Integer, default=1)
    repetition = Column(Integer, default=0)
    next_review_date = Column(Date)
    
    # Relationships
    vocab = relationship("Vocab", lazy="joined")
```

**Vocab Model**:
```python
class Vocab(Base):
    __tablename__ = 'vocabs'
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    word = Column(String(255), nullable=False)
    meaning_vi = Column(String(500))
    transcription = Column(String(255))
    cefr = Column(String(10))
    img = Column(String(500))
    audio = Column(String(500))
```

#### 3.2. Database Service

**Class**: `DatabaseService`

**Purpose**: Async database operations

**Methods**:
```python
class DatabaseService:
    def __init__(self, database_url: str):
        self.engine = create_async_engine(database_url, pool_size=20, max_overflow=10)
        self.async_session = sessionmaker(self.engine, class_=AsyncSession, expire_on_commit=False)
    
    async def get_user_vocab_progress(self, user_id: str, statuses: List[str]) -> List[UserVocabProgress]:
        """Get user's vocab progress filtered by statuses"""
        async with self.async_session() as session:
            result = await session.execute(
                select(UserVocabProgress)
                .options(joinedload(UserVocabProgress.vocab))
                .filter(UserVocabProgress.user_id == user_id)
                .filter(UserVocabProgress.status.in_(statuses))
            )
            return result.scalars().all()
    
    async def get_all_vocab_progress(self) -> List[UserVocabProgress]:
        """Get all vocab progress for training"""
        async with self.async_session() as session:
            result = await session.execute(
                select(UserVocabProgress)
                .options(joinedload(UserVocabProgress.vocab))
            )
            return result.scalars().all()
    
    async def health_check(self) -> bool:
        """Check database connection"""
        try:
            async with self.async_session() as session:
                await session.execute(text("SELECT 1"))
            return True
        except Exception:
            return False
```

#### 3.3. Cache Service

**Class**: `CacheService`

**Purpose**: Redis caching operations

**Methods**:
```python
import redis.asyncio as redis
import json

class CacheService:
    def __init__(self, redis_url: str):
        self.redis = redis.from_url(redis_url, decode_responses=True)
    
    async def get(self, key: str) -> Optional[Dict]:
        """Get cached value"""
        data = await self.redis.get(key)
        return json.loads(data) if data else None
    
    async def set(self, key: str, value: Dict, ttl: int = 300):
        """Set cache with TTL"""
        await self.redis.setex(key, ttl, json.dumps(value))
    
    async def delete(self, key: str):
        """Delete cache key"""
        await self.redis.delete(key)
    
    async def health_check(self) -> bool:
        """Check Redis connection"""
        try:
            await self.redis.ping()
            return True
        except Exception:
            return False
```

## Data Models

### Request/Response Schemas (Pydantic)

**PredictRequest**:
```python
from pydantic import BaseModel, Field

class PredictRequest(BaseModel):
    user_id: str = Field(..., description="User UUID")
    limit: int = Field(20, ge=1, le=100, description="Number of vocabs to return")
```

**VocabRecommendation**:
```python
class VocabRecommendation(BaseModel):
    vocab_id: str
    word: str
    meaning_vi: str
    transcription: Optional[str]
    priority_score: float = Field(..., ge=0.0, le=1.0)
    status: str
    times_correct: int
    times_wrong: int
    last_reviewed: Optional[str]
    next_review_date: Optional[str]
```

**PredictResponse**:
```python
class PredictResponse(BaseModel):
    user_id: str
    vocabs: List[VocabRecommendation]
    total: int
    meta: Dict[str, Any]
```

**RetrainRequest**:
```python
class RetrainRequest(BaseModel):
    force: bool = Field(False, description="Force retrain even if recent")
```

**RetrainResponse**:
```python
class RetrainResponse(BaseModel):
    success: bool
    model_version: str
    metrics: Dict[str, float]
    training_time_seconds: float
    samples_trained: int
```

## Error Handling

### Error Response Format

```python
class ErrorResponse(BaseModel):
    error: str
    message: str
    details: Optional[Dict] = None
    timestamp: str
```

### Error Types

1. **Authentication Errors** (401):
   - Invalid JWT token
   - Expired token
   - Missing Authorization header

2. **Authorization Errors** (403):
   - Invalid API key for admin endpoints
   - Insufficient permissions

3. **Validation Errors** (422):
   - Invalid request body
   - Invalid query parameters

4. **Rate Limit Errors** (429):
   - Too many requests

5. **Service Errors** (503):
   - Database unavailable
   - Redis unavailable
   - Model not loaded

6. **Internal Errors** (500):
   - Unexpected exceptions
   - Model prediction failures

### Error Handling Strategy

```python
@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception):
    logger.error("Unhandled exception", exc_info=exc, extra={
        "path": request.url.path,
        "method": request.method
    })
    
    return JSONResponse(
        status_code=500,
        content={
            "error": "InternalServerError",
            "message": "An unexpected error occurred",
            "timestamp": datetime.now().isoformat()
        }
    )
```

## Testing Strategy

### Unit Tests

1. **Feature Extractor Tests**:
   - Test feature extraction logic
   - Test normalization
   - Test edge cases (no reviews, zero attempts)

2. **Model Tests**:
   - Test model training
   - Test prediction
   - Test model save/load

3. **Service Tests**:
   - Test recommendation logic
   - Test cache hit/miss
   - Test error handling

### Integration Tests

1. **API Tests**:
   - Test all endpoints
   - Test authentication
   - Test rate limiting

2. **Database Tests**:
   - Test queries
   - Test connection pooling

3. **Cache Tests**:
   - Test Redis operations
   - Test TTL expiration

### Test Data

- Create synthetic UserVocabProgress data
- Cover all status types (NEW, UNKNOWN, KNOWN, MASTERED)
- Cover edge cases (overdue, never reviewed, high accuracy)

## Deployment

### Docker Configuration

**Dockerfile**:
```dockerfile
FROM python:3.11-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    postgresql-client \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN pip install poetry==1.7.0

# Copy dependency files
COPY pyproject.toml poetry.lock ./

# Install dependencies
RUN poetry config virtualenvs.create false \
    && poetry install --no-dev --no-interaction --no-ansi

# Copy application
COPY ./app ./app
COPY ./models ./models

# Expose port
EXPOSE 8001

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:8001/health || exit 1

# Run application
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8001"]
```

### Environment Variables

```bash
# Database
DATABASE_URL=postgresql://user:pass@postgres:5432/card_words

# Redis
REDIS_URL=redis://redis:6379/1

# JWT
JWT_SECRET=shared_secret_with_spring_boot

# Model
MODEL_PATH=/app/models/xgboost_model_v1.pkl
SCALER_PATH=/app/models/scaler_v1.pkl

# API
API_HOST=0.0.0.0
API_PORT=8001
LOG_LEVEL=INFO

# Admin
ADMIN_API_KEY=your_admin_api_key
```

### Docker Compose Integration

Service đã được thêm vào `docker-compose.yml` ở root:

```yaml
card-words-ai:
  build:
    context: ./card-words-ai
    dockerfile: Dockerfile
  container_name: card-words-ai
  environment:
    - DATABASE_URL=postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@postgres:5432/${POSTGRES_DB}
    - REDIS_URL=redis://redis:6379/${REDIS_AI_DB}
    - JWT_SECRET=${JWT_SECRET}
    - MODEL_PATH=/app/models/xgboost_model_v1.pkl
  ports:
    - "${SERVER_FLASH_PORT}:8001"
  volumes:
    - ./card-words-ai/models:/app/models
  depends_on:
    - postgres
    - redis
  networks:
    - card-words-network
  restart: unless-stopped
```

## Monitoring and Logging

### Structured Logging

```python
import structlog

logger = structlog.get_logger()

# Usage
logger.info("prediction_completed",
    user_id=user_id,
    vocab_count=len(vocabs),
    inference_time_ms=inference_time,
    cached=False
)
```

### Metrics

Track the following metrics:
- Total requests
- Cache hit rate
- Average inference time
- Model version
- Last training time
- Error rate by type

### Health Checks

```python
@app.get("/health")
async def health_check():
    db_healthy = await db_service.health_check()
    redis_healthy = await cache_service.health_check()
    model_loaded = model_service.is_loaded()
    
    status = "healthy" if all([db_healthy, redis_healthy, model_loaded]) else "unhealthy"
    
    return {
        "status": status,
        "checks": {
            "database": db_healthy,
            "redis": redis_healthy,
            "model": model_loaded
        },
        "timestamp": datetime.now().isoformat()
    }
```

## Performance Optimization

### 1. Model Loading
- Load model into memory at startup
- Keep model in memory for fast inference
- Use joblib for efficient serialization

### 2. Database Queries
- Use async queries with asyncpg
- Use connection pooling (min=5, max=20)
- Use eager loading for relationships (joinedload)
- Index on user_id, status, next_review_date

### 3. Caching Strategy
- Cache predictions for 5 minutes
- Invalidate cache on user learning activity
- Use Redis pipelining for batch operations

### 4. Batch Processing
- Process multiple vocabs in single prediction call
- Use NumPy vectorization for feature extraction

### 5. Rate Limiting
- Limit to 60 requests/minute per user
- Use Redis for distributed rate limiting

## Security Considerations

### 1. Authentication
- Validate JWT token on every request
- Use shared secret with Spring Boot
- Check token expiration

### 2. Authorization
- Verify user_id in token matches request
- Admin endpoints require API key

### 3. Input Validation
- Validate all request parameters
- Sanitize user inputs
- Limit request sizes

### 4. Data Protection
- Read-only database access
- No sensitive data in logs
- Secure environment variables

### 5. Rate Limiting
- Prevent abuse with rate limits
- Track by user_id and IP

## Future Enhancements

### Phase 2 Features

1. **Adaptive Learning**:
   - Personalized model per user
   - Online learning with user feedback

2. **Advanced Features**:
   - Time of day preferences
   - Learning streak impact
   - Topic difficulty weighting

3. **Model Improvements**:
   - Hyperparameter tuning with Optuna
   - Ensemble models (XGBoost + LightGBM)
   - Deep learning models (LSTM for sequences)

4. **Analytics**:
   - User learning patterns dashboard
   - Model performance monitoring
   - A/B testing framework

5. **Scalability**:
   - Model serving with TensorFlow Serving
   - Distributed training with Dask
   - GPU acceleration for large datasets
