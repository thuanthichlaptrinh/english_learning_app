# Card Words AI Service - Tài liệu Chi tiết

> **Microservice AI/ML** cung cấp hệ thống gợi ý ôn tập từ vựng thông minh sử dụng XGBoost cho Card Words Platform

---

## 📋 Mục lục

1. [Tổng quan](#tổng-quan)
2. [Kiến trúc hệ thống](#kiến-trúc-hệ-thống)
3. [Machine Learning Pipeline](#machine-learning-pipeline)
4. [API Documentation](#api-documentation)
5. [Cấu trúc dự án](#cấu-trúc-dự-án)
6. [Tech Stack](#tech-stack)
7. [Installation & Deployment](#installation--deployment)
8. [Workflow chi tiết](#workflow-chi-tiết)
9. [Performance & Optimization](#performance--optimization)
10. [Monitoring & Logging](#monitoring--logging)
11. [Troubleshooting](#troubleshooting)

---

## 🎯 Tổng quan

### Vấn đề cần giải quyết

Trong hệ thống học từ vựng Card Words, người dùng có thể có hàng trăm đến hàng nghìn từ vựng cần ôn tập. Việc chọn từ nào để ôn tập tiếp theo là rất quan trọng để:

-   **Tối ưu hóa thời gian học**: Tập trung vào từ thực sự cần ôn
-   **Tăng hiệu quả ghi nhớ**: Ôn đúng thời điểm tối ưu
-   **Cải thiện trải nghiệm**: Người dùng không bị overwhelm với quá nhiều từ

### Giải pháp

**Card Words AI** là một microservice Python FastAPI độc lập, sử dụng **XGBoost (Gradient Boosting Machine Learning)** để:

1. Phân tích tiến trình học tập của người dùng
2. Dự đoán từ vựng nào cần được ưu tiên ôn tập
3. Xếp hạng và trả về danh sách từ vựng theo độ ưu tiên

### Lợi ích

✅ **Thông minh**: ML-based prediction thay vì rule-based đơn giản  
✅ **Cá nhân hóa**: Dựa trên pattern học tập của từng user  
✅ **Nhanh**: Redis caching + async operations (< 100ms response)  
✅ **Scalable**: Microservice architecture, deploy độc lập  
✅ **Retrain-able**: Admin có thể cập nhật model với data mới  
✅ **Production-ready**: Health checks, monitoring, logging đầy đủ

---

## 🏗️ Kiến trúc hệ thống

### Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                    Client Applications                       │
│              (Web App, Mobile App, Admin Panel)              │
└────────────────────────┬────────────────────────────────────┘
                         │ HTTP + JWT
                         ▼
┌─────────────────────────────────────────────────────────────┐
│              Spring Boot Backend (card-words)                │
│                   Port: 8080                                 │
│  - User Authentication                                       │
│  - Vocabulary Management                                     │
│  - Learning Progress Tracking                                │
│  - Call AI Service for Smart Recommendations                │
└────────┬────────────────────────────────────────┬───────────┘
         │                                        │
         │ Internal API Call                      │ Shared Resources
         │ (Optional)                             │
         ▼                                        ▼
┌─────────────────────────┐         ┌────────────────────────┐
│   Card Words AI         │         │   PostgreSQL 16        │
│   (FastAPI Service)     │◄────────│   Port: 5433           │
│   Port: 8001            │ Read    │                        │
│                         │         │ - user_vocab_progress  │
│ ┌─────────────────────┐ │         │ - vocab                │
│ │  XGBoost Model      │ │         │ - user_topic           │
│ │  - Feature Extract  │ │         └────────────────────────┘
│ │  - Prediction       │ │                     ▲
│ │  - Ranking          │ │                     │ Shared DB
│ └─────────────────────┘ │                     │
│                         │                     │
│ ┌─────────────────────┐ │         ┌────────────────────────┐
│ │  Redis Cache        │◄┼─────────│   Redis 7              │
│ │  - 5min TTL         │ │         │   Port: 6379           │
│ │  - Cache Key:       │ │         │                        │
│ │    smart_review:uid │ │         │ - Cache Layer          │
│ └─────────────────────┘ │         │ - Session Storage      │
└─────────────────────────┘         └────────────────────────┘
```

### Service Integration

#### 1. **Shared Database (PostgreSQL)**

-   Card Words AI **chỉ đọc** dữ liệu từ PostgreSQL
-   Không modify data, đảm bảo data integrity
-   Tables sử dụng: `user_vocab_progress`, `vocab`

#### 2. **Shared Redis**

-   Sử dụng **khác DB index** với Spring Boot (index=1)
-   Cache prediction results
-   TTL: 5 phút

#### 3. **JWT Authentication**

-   Chia sẻ **JWT_SECRET** với Spring Boot
-   Verify token để authenticate requests
-   Extract `user_id` từ JWT payload

#### 4. **Communication Pattern**

```
Option 1: Direct from Client
Client → AI Service (JWT) → Response

Option 2: Via Spring Boot
Client → Spring Boot → AI Service (Internal API Key) → Response → Client
```

---

## 🧠 Machine Learning Pipeline

### 1. Feature Engineering

#### Features (9 chiều)

Card Words AI trích xuất 9 features từ bảng `user_vocab_progress`:

| #   | Feature Name             | Mô tả                                  | Loại            | Ví dụ       |
| --- | ------------------------ | -------------------------------------- | --------------- | ----------- |
| 1   | `times_correct`          | Số lần trả lời đúng                    | Số nguyên       | 15          |
| 2   | `times_wrong`            | Số lần trả lời sai                     | Số nguyên       | 3           |
| 3   | `accuracy_rate`          | Tỷ lệ chính xác (correct/total)        | Float [0-1]     | 0.83        |
| 4   | `days_since_last_review` | Số ngày từ lần ôn cuối                 | Số nguyên       | 5           |
| 5   | `days_until_next_review` | Số ngày đến lần ôn kế (âm nếu quá hạn) | Số nguyên       | -2          |
| 6   | `interval_days`          | Khoảng cách ôn tập (SM-2 algorithm)    | Số nguyên       | 7           |
| 7   | `repetition`             | Số lần đã lặp lại                      | Số nguyên       | 4           |
| 8   | `ef_factor`              | Hệ số dễ (Easiness Factor - SM-2)      | Float [1.3-2.5] | 2.1         |
| 9   | `status_encoded`         | Status mã hóa                          | Enum            | 1 (UNKNOWN) |

**Status Encoding:**

-   `NEW` = 0
-   `UNKNOWN` = 1
-   `KNOWN` = 2
-   `MASTERED` = 3

#### Feature Extraction Code

```python
# app/core/ml/feature_extractor.py
class VocabFeatureExtractor:
    def extract_features(self, progress: UserVocabProgress) -> np.ndarray:
        # 1-2. Times correct/wrong
        times_correct = progress.times_correct
        times_wrong = progress.times_wrong

        # 3. Accuracy rate
        total = times_correct + times_wrong
        accuracy_rate = times_correct / total if total > 0 else 0.0

        # 4. Days since last review
        days_since = (date.today() - progress.last_reviewed).days

        # 5. Days until next review (negative if overdue)
        days_until = (progress.next_review_date - date.today()).days

        # 6-8. SM-2 algorithm features
        interval_days = progress.interval_days
        repetition = progress.repetition
        ef_factor = progress.ef_factor

        # 9. Status encoded
        status_encoded = self.STATUS_ENCODING[progress.status.value]

        return np.array([...])
```

#### Feature Normalization

Sử dụng **StandardScaler** từ scikit-learn để normalize features:

```python
from sklearn.preprocessing import StandardScaler

# Fit scaler khi training
scaler = StandardScaler()
X_normalized = scaler.fit_transform(X_raw)

# Transform khi predict
X_normalized = scaler.transform(X_raw)
```

**Lý do normalize:**

-   Features có scale khác nhau (vd: times_correct: 0-100, ef_factor: 1.3-2.5)
-   Gradient boosting hoạt động tốt hơn với normalized features
-   Tăng độ ổn định và tốc độ training

### 2. Label Generation

#### Logic tạo label

Binary classification: **1** (cần ôn tập) hoặc **0** (không cần)

```python
def generate_labels(progress_list):
    for progress in progress_list:
        # Tính số ngày đến lần ôn kế
        days_until = (progress.next_review_date - date.today()).days

        # Tính accuracy
        total = progress.times_correct + progress.times_wrong
        accuracy = progress.times_correct / total if total > 0 else 0

        # Label = 1 nếu:
        # - Status là UNKNOWN hoặc NEW, HOẶC
        # - Status là KNOWN VÀ (quá hạn HOẶC accuracy thấp)
        need_review = (
            progress.status in ['UNKNOWN', 'NEW'] or
            (progress.status == 'KNOWN' and (days_until <= 0 or accuracy < 0.7))
        )

        label = 1 if need_review else 0
```

#### Distribution Example

Trong một dataset training thực tế:

-   **Positive samples (label=1)**: ~45% (cần ôn)
-   **Negative samples (label=0)**: ~55% (không cần)

→ Tương đối balanced, không cần sampling techniques

### 3. XGBoost Model

#### Model Configuration

```python
# app/core/ml/xgboost_model.py
DEFAULT_PARAMS = {
    'max_depth': 6,              # Độ sâu tối đa của tree
    'learning_rate': 0.1,        # Tốc độ học
    'n_estimators': 100,         # Số lượng trees
    'objective': 'binary:logistic',  # Binary classification
    'eval_metric': 'auc',        # Đánh giá bằng AUC-ROC
    'subsample': 0.8,            # Sample 80% data cho mỗi tree
    'colsample_bytree': 0.8,     # Sample 80% features cho mỗi tree
    'random_state': 42           # Reproducibility
}
```

#### Training Process

```python
def train(progress_list, test_size=0.2):
    # 1. Extract features
    X = feature_extractor.extract_and_normalize(progress_list)

    # 2. Generate labels
    y = generate_labels(progress_list)

    # 3. Train/validation split (80/20)
    X_train, X_val, y_train, y_val = train_test_split(
        X, y, test_size=0.2, stratify=y
    )

    # 4. Train XGBoost với early stopping
    model = xgb.XGBClassifier(**DEFAULT_PARAMS)
    model.fit(
        X_train, y_train,
        eval_set=[(X_val, y_val)],
        early_stopping_rounds=10,
        verbose=False
    )

    # 5. Evaluate
    y_pred = model.predict(X_val)
    y_proba = model.predict_proba(X_val)[:, 1]

    metrics = {
        'accuracy': accuracy_score(y_val, y_pred),
        'precision': precision_score(y_val, y_pred),
        'recall': recall_score(y_val, y_pred),
        'f1_score': f1_score(y_val, y_pred),
        'auc_roc': roc_auc_score(y_val, y_proba)
    }

    # 6. Save model
    joblib.dump(model, 'xgboost_model_v1.pkl')
    joblib.dump(scaler, 'scaler_v1.pkl')

    return metrics
```

#### Evaluation Metrics

Ví dụ kết quả training trên dataset thực:

```json
{
    "accuracy": 0.87, // 87% dự đoán đúng
    "precision": 0.85, // 85% dự đoán "cần ôn" là chính xác
    "recall": 0.89, // Bắt được 89% từ thực sự cần ôn
    "f1_score": 0.87, // Harmonic mean của precision & recall
    "auc_roc": 0.91 // 91% khả năng phân biệt 2 classes
}
```

**Giải thích:**

-   **Accuracy 87%**: Cao, model dự đoán tốt
-   **Recall 89%**: Quan trọng! Bắt được hầu hết từ cần ôn
-   **AUC 91%**: Rất tốt, model phân biệt rõ ràng

### 4. Prediction Process

```python
def predict(user_vocab_progress_list):
    # 1. Extract và normalize features
    X = feature_extractor.extract_and_normalize(progress_list)

    # 2. Predict probabilities
    probabilities = model.predict_proba(X)[:, 1]  # Lấy prob của class 1

    # 3. Rank theo xác suất giảm dần
    ranked_indices = np.argsort(probabilities)[::-1]

    # 4. Return top N vocabs
    return ranked_indices[:limit]
```

**Output Example:**

```python
[
    {"vocab_id": "uuid-1", "priority_score": 0.95, "word": "abandon"},
    {"vocab_id": "uuid-2", "priority_score": 0.92, "word": "eloquent"},
    {"vocab_id": "uuid-3", "priority_score": 0.88, "word": "paradigm"},
    ...
]
```

---

## 📡 API Documentation

### Base URL

-   **Local**: `http://localhost:8001`
-   **Docker**: `http://card-words-ai:8001`
-   **Production**: `https://api.cardwords.com/ai` (ví dụ)

### Authentication

#### JWT Token (User Endpoints)

```http
Authorization: Bearer <jwt_token>
```

JWT payload phải chứa:

```json
{
    "sub": "user_uuid", // User ID
    "email": "user@example.com",
    "iat": 1700000000,
    "exp": 1700086400
}
```

#### API Key (Admin Endpoints)

```http
X-API-Key: card-words-admin-key-2024
```

### Endpoints

---

#### 1. Root Endpoint

**GET** `/`

**Description:** Thông tin service

**Response 200:**

```json
{
    "service": "Card Words AI",
    "version": "0.1.0",
    "status": "running",
    "model_version": "v1.0.0",
    "timestamp": "2024-11-18T10:30:00Z"
}
```

---

#### 2. Health Check

**GET** `/health`

**Description:** Kiểm tra sức khỏe service

**Response 200:**

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

**Response 503** (Unhealthy):

```json
{
    "status": "unhealthy",
    "service": "card-words-ai",
    "model_loaded": false,
    "database_connected": true,
    "redis_connected": false,
    "timestamp": "2024-11-18T10:30:00Z"
}
```

---

#### 3. Service Metrics

**GET** `/metrics`

**Description:** Thống kê service

**Response 200:**

```json
{
    "total_requests": 15234,
    "cache_hit_rate": 0.78,
    "average_inference_time_ms": 45.2,
    "model_version": "v1.0.0",
    "last_training_time": "2024-11-18T08:00:00Z"
}
```

---

#### 4. Smart Review Prediction ⭐

**POST** `/api/v1/smart-review/predict`

**Authentication:** JWT Required

**Description:** Lấy danh sách từ vựng gợi ý ôn tập thông minh

**Request Body:**

```json
{
    "user_id": "550e8400-e29b-41d4-a716-446655440000",
    "limit": 20
}
```

**Request Headers:**

```http
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json
```

**Response 200:**

```json
{
    "user_id": "550e8400-e29b-41d4-a716-446655440000",
    "vocabs": [
        {
            "vocab_id": "uuid-1",
            "word": "abandon",
            "meaning": "từ bỏ, bỏ rơi",
            "priority_score": 0.95,
            "status": "KNOWN",
            "times_correct": 5,
            "times_wrong": 3,
            "accuracy": 0.625,
            "days_since_last_review": 8,
            "next_review_date": "2024-11-10",
            "is_overdue": true
        },
        {
            "vocab_id": "uuid-2",
            "word": "eloquent",
            "meaning": "hùng biện, có tài ăn nói",
            "priority_score": 0.92,
            "status": "UNKNOWN",
            "times_correct": 1,
            "times_wrong": 4,
            "accuracy": 0.2,
            "days_since_last_review": 3,
            "next_review_date": "2024-11-15",
            "is_overdue": true
        }
    ],
    "total": 2,
    "meta": {
        "cached": false,
        "model_version": "v1.0.0",
        "inference_time_ms": 45.2
    }
}
```

**Response 400** (Validation Error):

```json
{
    "error": "ValidationError",
    "message": "limit must be between 1 and 100",
    "timestamp": "2024-11-18T10:30:00Z"
}
```

**Response 401** (Unauthorized):

```json
{
    "error": "Unauthorized",
    "message": "Invalid or expired JWT token",
    "timestamp": "2024-11-18T10:30:00Z"
}
```

**Response 403** (Forbidden):

```json
{
    "error": "Forbidden",
    "message": "User ID mismatch",
    "timestamp": "2024-11-18T10:30:00Z"
}
```

**Response 503** (Service Unavailable):

```json
{
    "error": "ServiceUnavailable",
    "message": "Model not loaded",
    "timestamp": "2024-11-18T10:30:00Z"
}
```

---

#### 5. Model Retraining 🔧

**POST** `/api/v1/smart-review/retrain`

**Authentication:** Admin API Key Required

**Description:** Train lại model với dữ liệu mới nhất

**Request Headers:**

```http
X-API-Key: card-words-admin-key-2024
Content-Type: application/json
```

**Request Body:**

```json
{
    "force": true
}
```

**Parameters:**

-   `force` (boolean): Bắt buộc train lại ngay cả khi model đã tồn tại

**Response 200:**

```json
{
    "success": true,
    "model_version": "v1.0.0",
    "metrics": {
        "accuracy": 0.87,
        "precision": 0.85,
        "recall": 0.89,
        "f1_score": 0.87,
        "auc_roc": 0.91
    },
    "training_time_seconds": 45.2,
    "samples_trained": 15000,
    "positive_samples": 6750,
    "negative_samples": 8250,
    "timestamp": "2024-11-18T10:30:00Z"
}
```

**Response 401** (Unauthorized):

```json
{
    "error": "Unauthorized",
    "message": "Invalid API key",
    "timestamp": "2024-11-18T10:30:00Z"
}
```

**Response 500** (Training Failed):

```json
{
    "error": "TrainingError",
    "message": "Not enough data for training (minimum 10 samples required)",
    "timestamp": "2024-11-18T10:30:00Z"
}
```

---

#### 6. Invalidate Cache

**POST** `/api/v1/smart-review/invalidate-cache`

**Authentication:** Internal API Key Required

**Description:** Xóa cache của user (gọi khi user submit learning result)

**Request Headers:**

```http
X-API-Key: card-words-internal-key-2024
Content-Type: application/json
```

**Request Body:**

```json
{
    "user_id": "550e8400-e29b-41d4-a716-446655440000"
}
```

**Response 200:**

```json
{
    "success": true,
    "user_id": "550e8400-e29b-41d4-a716-446655440000",
    "cache_key": "smart_review:550e8400-e29b-41d4-a716-446655440000",
    "deleted": true
}
```

---

## 📁 Cấu trúc dự án

```
card-words-ai/
│
├── app/
│   ├── __init__.py
│   ├── main.py                      # FastAPI application & lifespan
│   ├── config.py                    # Configuration settings
│   │
│   ├── api/                         # API endpoints
│   │   ├── __init__.py
│   │   └── v1/
│   │       ├── __init__.py
│   │       └── smart_review.py      # Smart review endpoints
│   │
│   ├── core/                        # Business logic
│   │   ├── __init__.py
│   │   ├── ml/                      # Machine Learning
│   │   │   ├── __init__.py
│   │   │   ├── feature_extractor.py # Feature engineering
│   │   │   └── xgboost_model.py     # XGBoost model wrapper
│   │   │
│   │   └── services/                # Services
│   │       ├── __init__.py
│   │       ├── smart_review_service.py  # Prediction orchestrator
│   │       └── cache_service.py         # Redis cache operations
│   │
│   ├── db/                          # Database layer
│   │   ├── __init__.py
│   │   ├── database_service.py      # Async database operations
│   │   └── models/                  # SQLAlchemy models
│   │       ├── __init__.py
│   │       ├── user_vocab_progress.py
│   │       └── vocab.py
│   │
│   ├── middleware/                  # Middleware
│   │   ├── __init__.py
│   │   ├── auth.py                  # JWT & API key validation
│   │   └── error_handler.py         # Global error handling
│   │
│   └── schemas/                     # Pydantic schemas
│       ├── __init__.py
│       ├── requests.py              # Request DTOs
│       └── responses.py             # Response DTOs
│
├── models/                          # Trained ML models
│   ├── xgboost_model_v1.pkl         # XGBoost model
│   ├── scaler_v1.pkl                # StandardScaler
│   └── backups/                     # Model backups
│
├── tests/                           # Tests
│   ├── __init__.py
│   ├── test_api/
│   ├── test_ml/
│   └── test_services/
│
├── scripts/                         # Utility scripts
│   ├── train_model.py               # Manual training script
│   └── test_api.sh                  # API testing script
│
├── Dockerfile                       # Docker build
├── docker-compose.yml               # Local development
├── pyproject.toml                   # Poetry dependencies
├── .env.example                     # Environment template
├── .dockerignore
├── .gitignore
│
├── README.md                        # Quick start guide
├── DEPLOYMENT.md                    # Deployment guide
├── IMPLEMENTATION_SUMMARY.md        # Implementation summary
└── QUICK_START.md                   # Quick start guide
```

### Key Files Explained

#### `app/main.py`

FastAPI application với lifespan management:

-   Initialize database, redis, model khi startup
-   Cleanup connections khi shutdown
-   Global error handling
-   CORS middleware

#### `app/config.py`

Centralized configuration từ environment variables:

-   Database URL
-   Redis URL
-   JWT secret
-   Model paths
-   Cache TTL

#### `app/core/ml/feature_extractor.py`

Feature extraction và normalization:

-   Extract 9 features từ `UserVocabProgress`
-   StandardScaler normalization
-   Batch processing support

#### `app/core/ml/xgboost_model.py`

XGBoost model wrapper:

-   Training với hyperparameters
-   Label generation logic
-   Model save/load với joblib
-   Evaluation metrics
-   Auto backup trước khi retrain

#### `app/core/services/smart_review_service.py`

Orchestrate prediction pipeline:

1. Check Redis cache
2. Query database
3. Extract features
4. Predict với XGBoost
5. Rank vocabs
6. Cache results

#### `app/db/database_service.py`

Async database operations:

-   Connection pooling
-   Query user vocab progress
-   Query all data for training
-   Health check

#### `app/middleware/auth.py`

Authentication:

-   JWT token validation
-   API key validation
-   Extract user_id từ token

---

## 🛠️ Tech Stack

### Core Technologies

| Component           | Technology   | Version | Purpose                   |
| ------------------- | ------------ | ------- | ------------------------- |
| **Language**        | Python       | 3.11    | Core programming language |
| **Web Framework**   | FastAPI      | 0.104+  | Async web framework       |
| **ASGI Server**     | Uvicorn      | 0.24+   | Production ASGI server    |
| **ML Framework**    | XGBoost      | 2.0+    | Gradient boosting         |
| **Data Processing** | NumPy        | 1.24+   | Numerical computing       |
| **Data Processing** | Pandas       | 2.0+    | Data manipulation         |
| **ML Tools**        | scikit-learn | 1.3+    | Feature scaling, metrics  |
| **Database ORM**    | SQLAlchemy   | 2.0+    | Async ORM                 |
| **DB Driver**       | asyncpg      | 0.29+   | Async PostgreSQL driver   |
| **Cache Client**    | redis-py     | 5.0+    | Async Redis client        |
| **Validation**      | Pydantic     | 2.4+    | Data validation           |
| **Logging**         | Structlog    | 23.2+   | Structured logging        |
| **Auth**            | PyJWT        | 2.8+    | JWT validation            |

### Development Tools

| Tool               | Purpose               |
| ------------------ | --------------------- |
| **Poetry**         | Dependency management |
| **Black**          | Code formatting       |
| **Ruff**           | Linting               |
| **pytest**         | Testing framework     |
| **pytest-asyncio** | Async testing         |

### Infrastructure

| Component         | Technology     |
| ----------------- | -------------- |
| **Container**     | Docker         |
| **Orchestration** | Docker Compose |
| **Database**      | PostgreSQL 16  |
| **Cache**         | Redis 7        |

---

## 🚀 Installation & Deployment

### Prerequisites

-   **Docker Desktop** hoặc Docker Engine
-   **Python 3.11+** (nếu chạy local)
-   **Poetry** (dependency manager)
-   **PostgreSQL 16** (shared với Spring Boot)
-   **Redis 7** (shared với Spring Boot)

### Option 1: Docker Compose (Recommended)

#### Bước 1: Cấu hình Environment Variables

File `.env` ở root project:

```env
# Database (shared với Spring Boot)
DATABASE_URL=postgresql://postgres:123456@postgres:5432/card_words

# Redis (shared với Spring Boot, khác DB index)
REDIS_URL=redis://redis:6379/1

# JWT (PHẢI GIỐNG Spring Boot)
JWT_SECRET=your-super-secret-jwt-key-here-change-in-production
JWT_ALGORITHM=HS256

# Model
MODEL_PATH=/app/models/xgboost_model_v1.pkl
SCALER_PATH=/app/models/scaler_v1.pkl
MODEL_VERSION=v1.0.0

# API Keys
ADMIN_API_KEY=card-words-admin-key-2024
INTERNAL_API_KEY=card-words-internal-key-2024

# Logging
LOG_LEVEL=INFO

# Cache
CACHE_TTL=300
```

#### Bước 2: Build và Start

```bash
# Từ thư mục root project
cd card-words-services

# Build AI service
docker-compose build card-words-ai

# Start tất cả services
docker-compose up -d

# Hoặc chỉ start AI service
docker-compose up -d card-words-ai

# Xem logs
docker-compose logs -f card-words-ai
```

#### Bước 3: Verify Service

```bash
# Health check
curl http://localhost:8001/health

# Expected response
{
  "status": "healthy",
  "service": "card-words-ai",
  "model_loaded": false,
  "database_connected": true,
  "redis_connected": true
}
```

#### Bước 4: Train Initial Model

```bash
# Train model lần đầu
curl -X POST http://localhost:8001/api/v1/smart-review/retrain \
  -H "X-API-Key: card-words-admin-key-2024" \
  -H "Content-Type: application/json" \
  -d '{"force": true}'
```

### Option 2: Local Development

#### Bước 1: Install Dependencies

```bash
cd card-words-ai

# Install Poetry
pip install poetry

# Install dependencies
poetry install

# Activate virtual environment
poetry shell
```

#### Bước 2: Configure Environment

```bash
# Copy example env
cp .env.example .env

# Edit .env
nano .env
```

Sửa các giá trị:

```env
DATABASE_URL=postgresql://postgres:123456@localhost:5433/card_words
REDIS_URL=redis://localhost:6379/1
JWT_SECRET=your-jwt-secret
```

#### Bước 3: Run Service

```bash
# Development mode (auto reload)
poetry run uvicorn app.main:app --reload --port 8001

# Production mode
poetry run uvicorn app.main:app --host 0.0.0.0 --port 8001 --workers 4
```

#### Bước 4: Train Model

```bash
# Sử dụng script
poetry run python scripts/train_model.py

# Hoặc qua API
curl -X POST http://localhost:8001/api/v1/smart-review/retrain \
  -H "X-API-Key: card-words-admin-key-2024" \
  -H "Content-Type: application/json" \
  -d '{"force": true}'
```

### Option 3: Production Deployment

#### Docker Compose Production

```yaml
# docker-compose.prod.yml
version: '3.8'

services:
    card-words-ai:
        build: ./card-words-ai
        container_name: card-words-ai-prod
        restart: always
        ports:
            - '8001:8001'
        environment:
            - DATABASE_URL=${DATABASE_URL}
            - REDIS_URL=${REDIS_URL}
            - JWT_SECRET=${JWT_SECRET}
            - ADMIN_API_KEY=${ADMIN_API_KEY}
            - LOG_LEVEL=WARNING
        volumes:
            - ./models:/app/models
        networks:
            - card-words-network
        healthcheck:
            test: ['CMD', 'curl', '-f', 'http://localhost:8001/health']
            interval: 30s
            timeout: 10s
            retries: 3
        deploy:
            resources:
                limits:
                    cpus: '2'
                    memory: 2G
                reservations:
                    cpus: '1'
                    memory: 1G
```

Deploy:

```bash
docker-compose -f docker-compose.prod.yml up -d
```

---

## 🔄 Workflow chi tiết

### 1. Startup Sequence

```
┌─────────────────────────────────────────────────┐
│             Application Startup                  │
└──────────────────┬──────────────────────────────┘
                   │
                   ▼
         ┌─────────────────────┐
         │ Initialize Services │
         └──────────┬──────────┘
                    │
        ┌───────────┼───────────┐
        │           │           │
        ▼           ▼           ▼
   ┌────────┐  ┌────────┐  ┌────────┐
   │Database│  │ Redis  │  │ Model  │
   │Service │  │Service │  │ Loader │
   └────┬───┘  └───┬────┘  └───┬────┘
        │          │           │
        ▼          ▼           ▼
   ┌────────┐  ┌────────┐  ┌────────┐
   │Connect │  │Connect │  │Load or │
   │to PG   │  │to Redis│  │Warning │
   └────┬───┘  └───┬────┘  └───┬────┘
        │          │           │
        └──────────┼───────────┘
                   │
                   ▼
        ┌──────────────────────┐
        │ Initialize Smart     │
        │ Review Service       │
        └──────────┬───────────┘
                   │
                   ▼
        ┌──────────────────────┐
        │ Service Ready        │
        │ (Listening on 8001)  │
        └──────────────────────┘
```

### 2. Prediction Request Flow

```
Client
  │
  │ POST /api/v1/smart-review/predict
  │ Authorization: Bearer <jwt>
  │ {"user_id": "...", "limit": 20}
  │
  ▼
┌─────────────────────────┐
│ FastAPI Middleware      │
│ - CORS                  │
│ - Error Handler         │
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│ JWT Validation          │
│ - Verify signature      │
│ - Check expiration      │
│ - Extract user_id       │
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│ Request Validation      │
│ - Pydantic schema       │
│ - user_id match token   │
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│ Smart Review Service    │
└───────────┬─────────────┘
            │
            ▼
     ┌──────────────┐
     │ Check Cache? │
     └──────┬───────┘
            │
      ┌─────┴─────┐
      │           │
   Yes│           │No
      │           │
      ▼           ▼
 ┌────────┐  ┌──────────────────┐
 │Return  │  │Query Database    │
 │Cached  │  │- user_vocab_progress│
 │Result  │  │- JOIN vocab      │
 └────────┘  └────────┬─────────┘
                      │
                      ▼
             ┌─────────────────┐
             │Extract Features │
             │- 9 dimensions   │
             │- Normalize      │
             └────────┬────────┘
                      │
                      ▼
             ┌─────────────────┐
             │XGBoost Predict  │
             │- probabilities  │
             └────────┬────────┘
                      │
                      ▼
             ┌─────────────────┐
             │Rank by Priority │
             │- Sort descending│
             │- Top N          │
             └────────┬────────┘
                      │
                      ▼
             ┌─────────────────┐
             │Build Response   │
             │- Add vocab info │
             │- Add metadata   │
             └────────┬────────┘
                      │
                      ▼
             ┌─────────────────┐
             │Cache Result     │
             │- TTL: 5 min     │
             └────────┬────────┘
                      │
                      ▼
             ┌─────────────────┐
             │Return Response  │
             └─────────────────┘
```

### 3. Cache Invalidation Flow

```
User completes learning activity in Spring Boot
                │
                ▼
     ┌─────────────────────┐
     │ Spring Boot Backend │
     │ - User submits quiz │
     │ - Updates progress  │
     └──────────┬──────────┘
                │
                ▼
     ┌─────────────────────────┐
     │ POST /api/v1/smart-     │
     │ review/invalidate-cache │
     │ X-API-Key: internal-key │
     └──────────┬──────────────┘
                │
                ▼
     ┌─────────────────────────┐
     │ AI Service              │
     │ - Verify API key        │
     │ - Delete cache key      │
     │   smart_review:{uid}    │
     └──────────┬──────────────┘
                │
                ▼
     ┌─────────────────────────┐
     │ Next prediction will    │
     │ query fresh data        │
     └─────────────────────────┘
```

### 4. Model Retraining Flow

```
Admin triggers retrain
         │
         ▼
┌─────────────────────┐
│POST /api/v1/smart-  │
│review/retrain       │
│X-API-Key: admin-key │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────────┐
│Verify Admin API Key     │
└──────────┬──────────────┘
           │
           ▼
┌─────────────────────────┐
│Backup Current Model     │
│- models/backups/        │
│  xgboost_model_v1_      │
│  20241118_103000.pkl    │
└──────────┬──────────────┘
           │
           ▼
┌─────────────────────────┐
│Query All Vocab Progress │
│- FROM user_vocab_progress│
│- JOIN vocab             │
└──────────┬──────────────┘
           │
           ▼
┌─────────────────────────┐
│Extract Features         │
│- Batch process          │
│- 9 features per sample  │
└──────────┬──────────────┘
           │
           ▼
┌─────────────────────────┐
│Generate Labels          │
│- Binary classification  │
│- Based on status+metrics│
└──────────┬──────────────┘
           │
           ▼
┌─────────────────────────┐
│Train/Validation Split   │
│- 80/20 split            │
│- Stratified sampling    │
└──────────┬──────────────┘
           │
           ▼
┌─────────────────────────┐
│Train XGBoost            │
│- 100 estimators         │
│- Early stopping         │
└──────────┬──────────────┘
           │
           ▼
┌─────────────────────────┐
│Evaluate on Validation   │
│- Accuracy, Precision    │
│- Recall, F1, AUC        │
└──────────┬──────────────┘
           │
           ▼
┌─────────────────────────┐
│Save Model & Scaler      │
│- xgboost_model_v1.pkl   │
│- scaler_v1.pkl          │
└──────────┬──────────────┘
           │
           ▼
┌─────────────────────────┐
│Return Metrics           │
│- Training time          │
│- Samples count          │
│- Performance metrics    │
└─────────────────────────┘
```

---

## ⚡ Performance & Optimization

### 1. Response Time Targets

| Scenario                   | Target   | Actual |
| -------------------------- | -------- | ------ |
| Cache hit                  | < 50ms   | ~30ms  |
| Cache miss (< 100 vocabs)  | < 200ms  | ~150ms |
| Cache miss (< 500 vocabs)  | < 500ms  | ~400ms |
| Cache miss (> 1000 vocabs) | < 1000ms | ~800ms |

### 2. Caching Strategy

#### Redis Caching

```python
# Cache key format
cache_key = f"smart_review:{user_id}"

# TTL: 5 minutes
CACHE_TTL = 300

# Invalidation triggers
- User completes quiz/flashcard
- User learns new vocab
- Admin retrains model
```

#### Benefits

-   **~80% cache hit rate** trong production
-   Giảm database queries
-   Giảm ML inference overhead
-   Response time ổn định

### 3. Database Optimization

#### Connection Pooling

```python
# SQLAlchemy engine config
create_async_engine(
    DATABASE_URL,
    pool_size=20,          # 20 connections
    max_overflow=10,       # Thêm 10 nếu cần
    pool_timeout=30,       # Timeout 30s
    pool_recycle=3600      # Recycle sau 1h
)
```

#### Query Optimization

```python
# Eager loading để tránh N+1 queries
stmt = (
    select(UserVocabProgress)
    .options(joinedload(UserVocabProgress.vocab))
    .where(UserVocabProgress.user_id == user_id)
)
```

#### Indexes Required

```sql
-- user_vocab_progress table
CREATE INDEX idx_user_vocab_status
ON user_vocab_progress(user_id, status);

CREATE INDEX idx_next_review_date
ON user_vocab_progress(next_review_date);
```

### 4. ML Inference Optimization

#### Batch Processing

```python
# Process multiple users in parallel
async def batch_predict(user_ids: List[str]):
    tasks = [get_recommendations(uid) for uid in user_ids]
    return await asyncio.gather(*tasks)
```

#### Feature Extraction Vectorization

```python
# Sử dụng NumPy vectorized operations
features = np.array([
    [extract_features(p) for p in progress_list]
])
# Faster than Python loops
```

#### Model Loading

```python
# Load model 1 lần khi startup
# Không reload mỗi request
model.load_model()  # In lifespan startup
```

### 5. Async Operations

```python
# All I/O operations are async
async def get_recommendations(user_id: str):
    # Async cache check
    cached = await cache_service.get(cache_key)

    # Async database query
    progress_list = await db_service.get_user_vocab_progress(user_id)

    # Sync ML inference (CPU-bound)
    X = feature_extractor.extract(progress_list)
    probabilities = model.predict_proba(X)

    # Async cache write
    await cache_service.set(cache_key, result, ttl=300)
```

### 6. Resource Limits

```yaml
# Docker resource limits
deploy:
    resources:
        limits:
            cpus: '2'
            memory: 2G
        reservations:
            cpus: '1'
            memory: 1G
```

### 7. Monitoring Metrics

```python
# Track performance metrics
- Request latency (p50, p95, p99)
- Cache hit rate
- Database query time
- ML inference time
- Error rate
- Throughput (req/s)
```

---

## 📊 Monitoring & Logging

### 1. Structured Logging

#### Sử dụng Structlog

```python
import structlog

logger = structlog.get_logger()

# Log với structured data
logger.info(
    "prediction_completed",
    user_id=user_id,
    n_vocabs=len(vocabs),
    inference_time_ms=elapsed * 1000,
    cached=False
)
```

#### Log Levels

| Level    | Use Case                   | Example                           |
| -------- | -------------------------- | --------------------------------- |
| DEBUG    | Development debugging      | Feature extraction details        |
| INFO     | Normal operations          | Request completed, cache hit      |
| WARNING  | Potential issues           | Slow inference, low accuracy      |
| ERROR    | Errors that need attention | Database error, model load failed |
| CRITICAL | Service-breaking issues    | Cannot connect to DB              |

#### Log Examples

```json
// Info log
{
  "event": "prediction_completed",
  "level": "info",
  "timestamp": "2024-11-18T10:30:00Z",
  "user_id": "550e8400-...",
  "n_vocabs": 20,
  "inference_time_ms": 45.2,
  "cached": false
}

// Warning log
{
  "event": "slow_inference",
  "level": "warning",
  "timestamp": "2024-11-18T10:30:05Z",
  "user_id": "550e8400-...",
  "inference_time_ms": 2500,
  "threshold_ms": 2000
}

// Error log
{
  "event": "database_error",
  "level": "error",
  "timestamp": "2024-11-18T10:30:10Z",
  "error": "connection timeout",
  "query": "SELECT * FROM user_vocab_progress WHERE..."
}
```

### 2. Health Checks

#### Endpoint: GET /health

Kiểm tra:

-   ✅ Database connection
-   ✅ Redis connection
-   ✅ Model loaded status

```python
async def health_check():
    db_healthy = await db_service.health_check()
    redis_healthy = await cache_service.health_check()
    model_loaded = model.is_loaded

    status = "healthy" if all([
        db_healthy, redis_healthy, model_loaded
    ]) else "unhealthy"

    return {"status": status, ...}
```

#### Docker Health Check

```yaml
healthcheck:
    test: ['CMD', 'curl', '-f', 'http://localhost:8001/health']
    interval: 30s
    timeout: 10s
    retries: 3
    start_period: 40s
```

### 3. Metrics Collection

```python
# Service metrics
{
  "total_requests": 15234,
  "cache_hit_rate": 0.78,
  "average_inference_time_ms": 45.2,
  "model_version": "v1.0.0",
  "last_training_time": "2024-11-18T08:00:00Z"
}
```

### 4. Alerting Rules

#### Critical Alerts

-   🔴 Service down (health check fails)
-   🔴 Database connection lost
-   🔴 Redis connection lost
-   🔴 Model not loaded

#### Warning Alerts

-   🟡 High error rate (> 5%)
-   🟡 Slow response time (p95 > 1s)
-   🟡 Low cache hit rate (< 50%)
-   🟡 High memory usage (> 80%)

### 5. Log Aggregation

Recommend sử dụng:

-   **ELK Stack** (Elasticsearch, Logstash, Kibana)
-   **Grafana + Loki**
-   **CloudWatch** (AWS)
-   **Google Cloud Logging** (GCP)

---

## 🔧 Troubleshooting

### Common Issues

#### 1. Model Not Loaded

**Symptom:**

```json
{
    "error": "ServiceUnavailable",
    "message": "Model not loaded"
}
```

**Solutions:**

```bash
# Check if model file exists
ls -la models/xgboost_model_v1.pkl

# Train initial model
curl -X POST http://localhost:8001/api/v1/smart-review/retrain \
  -H "X-API-Key: card-words-admin-key-2024" \
  -d '{"force": true}'

# Check logs
docker-compose logs card-words-ai | grep model
```

---

#### 2. Database Connection Failed

**Symptom:**

```json
{
    "status": "unhealthy",
    "database_connected": false
}
```

**Solutions:**

```bash
# Check database is running
docker-compose ps postgres

# Check DATABASE_URL
echo $DATABASE_URL

# Test connection
docker exec -it postgres psql -U postgres -d card_words

# Check network
docker network inspect card-words-network
```

---

#### 3. Redis Connection Failed

**Symptom:**

```json
{
    "status": "unhealthy",
    "redis_connected": false
}
```

**Solutions:**

```bash
# Check Redis is running
docker-compose ps redis

# Test connection
docker exec -it redis redis-cli ping

# Check REDIS_URL
echo $REDIS_URL

# Test from AI service
docker exec -it card-words-ai python -c "import redis; r=redis.from_url('redis://redis:6379/1'); print(r.ping())"
```

---

#### 4. JWT Validation Failed

**Symptom:**

```json
{
    "error": "Unauthorized",
    "message": "Invalid JWT token"
}
```

**Solutions:**

```bash
# Kiểm tra JWT_SECRET giống với Spring Boot
# File .env
JWT_SECRET=same-secret-as-spring-boot

# Test token decode
python -c "
import jwt
token = 'your-jwt-token'
secret = 'your-secret'
decoded = jwt.decode(token, secret, algorithms=['HS256'])
print(decoded)
"
```

---

#### 5. Slow Inference Time

**Symptom:**

```json
{
    "event": "slow_inference",
    "inference_time_ms": 2500
}
```

**Solutions:**

1. **Check số lượng vocabs**:

    ```sql
    SELECT user_id, COUNT(*)
    FROM user_vocab_progress
    GROUP BY user_id
    ORDER BY COUNT(*) DESC;
    ```

2. **Optimize cache**:

    - Increase CACHE_TTL
    - Pre-warm cache for active users

3. **Add database indexes**:

    ```sql
    CREATE INDEX IF NOT EXISTS idx_user_vocab_status
    ON user_vocab_progress(user_id, status);
    ```

4. **Increase resources**:
    ```yaml
    deploy:
        resources:
            limits:
                cpus: '4'
                memory: 4G
    ```

---

#### 6. Training Failed

**Symptom:**

```json
{
    "error": "TrainingError",
    "message": "Not enough data for training"
}
```

**Solutions:**

```bash
# Check data count
docker exec -it postgres psql -U postgres -d card_words -c \
  "SELECT COUNT(*) FROM user_vocab_progress;"

# Minimum 10 samples required
# Insert test data if needed
```

---

#### 7. Cache Not Working

**Symptom:**

-   Low cache hit rate
-   Always querying database

**Solutions:**

```bash
# Check Redis keys
docker exec -it redis redis-cli KEYS "smart_review:*"

# Check TTL
docker exec -it redis redis-cli TTL "smart_review:user-id-here"

# Manual test
docker exec -it redis redis-cli
> GET "smart_review:550e8400-e29b-41d4-a716-446655440000"

# Check cache service logs
docker-compose logs card-words-ai | grep cache
```

---

## 📚 Best Practices

### 1. Security

✅ **JWT Secret Management**

-   Sử dụng strong secret (>= 32 characters)
-   Rotate secret định kỳ
-   Không commit secret vào Git
-   Sử dụng environment variables

✅ **API Key Protection**

-   Admin API key khác Internal API key
-   Rotate keys định kỳ
-   Log API key usage
-   Rate limiting

✅ **Database Security**

-   Read-only user cho AI service
-   Không expose database port ra ngoài
-   Sử dụng connection pooling
-   Encrypt connection (SSL)

### 2. Code Quality

✅ **Type Hints**

```python
def predict(user_id: str, limit: int = 20) -> Dict[str, Any]:
    ...
```

✅ **Pydantic Validation**

```python
class PredictRequest(BaseModel):
    user_id: str = Field(..., regex="^[a-f0-9-]{36}$")
    limit: int = Field(20, ge=1, le=100)
```

✅ **Error Handling**

```python
try:
    result = await service.predict(user_id)
except DatabaseError as e:
    logger.error("database_error", error=str(e))
    raise HTTPException(status_code=503, detail="Database unavailable")
```

### 3. Testing

```bash
# Unit tests
pytest tests/test_ml/

# Integration tests
pytest tests/test_api/

# Load testing
locust -f tests/load_test.py
```

### 4. Deployment

✅ **Health Checks**

-   Implement liveness probe
-   Implement readiness probe
-   Monitor continuously

✅ **Graceful Shutdown**

```python
@asynccontextmanager
async def lifespan(app):
    # Startup
    await initialize()
    yield
    # Shutdown - cleanup connections
    await cleanup()
```

✅ **Rolling Updates**

-   Deploy new version gradually
-   Monitor errors
-   Rollback if issues

### 5. Monitoring

✅ **Key Metrics**

-   Request rate (req/s)
-   Error rate (%)
-   Response time (p50, p95, p99)
-   Cache hit rate (%)
-   Database query time (ms)
-   ML inference time (ms)

✅ **Alerting**

-   Set up alerts for critical metrics
-   Send notifications (email, Slack)
-   Define escalation paths

---

## 🔮 Future Enhancements

### Planned Features

1. **A/B Testing Framework**

    - Compare different models
    - Track user engagement metrics
    - Auto-select best model

2. **Online Learning**

    - Incremental model updates
    - Real-time feedback loop
    - Personalized models per user

3. **Advanced Features**

    - User learning style classification
    - Contextual factors (time of day, device)
    - Topic difficulty estimation
    - Forgetting curve prediction

4. **Multi-Model Ensemble**

    - Combine XGBoost + LightGBM + Neural Network
    - Voting or stacking
    - Improve accuracy

5. **Explainability**

    - SHAP values for predictions
    - Why this vocab is recommended
    - User-facing explanations

6. **Performance Optimization**
    - Model quantization
    - ONNX Runtime
    - GPU acceleration (if needed)

---

## 📞 Support & Contact

### Documentation

-   **Main README**: `card-words-ai/README.md`
-   **Deployment Guide**: `card-words-ai/DEPLOYMENT.md`
-   **Implementation Summary**: `card-words-ai/IMPLEMENTATION_SUMMARY.md`

### Logs

```bash
# Docker logs
docker-compose logs -f card-words-ai

# Check health
curl http://localhost:8001/health

# Check metrics
curl http://localhost:8001/metrics
```

### Debug Mode

```env
# .env
LOG_LEVEL=DEBUG
```

---

## 📝 Changelog

### Version 1.0.0 (2024-11-18)

-   ✅ Initial release
-   ✅ XGBoost-based smart recommendations
-   ✅ Redis caching layer
-   ✅ JWT authentication
-   ✅ Admin retrain API
-   ✅ Docker deployment
-   ✅ Health checks & monitoring
-   ✅ Structured logging

---

## 📄 License

This project is part of Card Words Platform.

---

**Tài liệu được tạo bởi:** Card Words Team  
**Ngày cập nhật:** 18/11/2024  
**Phiên bản:** 1.0.0
