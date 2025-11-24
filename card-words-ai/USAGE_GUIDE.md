# Card Words AI - Hướng dẫn sử dụng

## 📋 Mục lục

1. [Giới thiệu](#giới-thiệu)
2. [Yêu cầu hệ thống](#yêu-cầu-hệ-thống)
3. [Cài đặt và khởi động](#cài-đặt-và-khởi-động)
4. [Huấn luyện Model](#huấn-luyện-model)
5. [Sử dụng API](#sử-dụng-api)
6. [Troubleshooting](#troubleshooting)
7. [Nâng cao](#nâng-cao)

---

## Giới thiệu

**Card Words AI** là microservice AI cung cấp gợi ý thông minh cho việc ôn tập từ vựng, sử dụng:

-   **XGBoost** - Gradient boosting mạnh mẽ, inference nhanh
-   **Random Forest** - Robust, tránh overfitting tốt

### Kiến trúc

```
┌─────────────┐      JWT       ┌──────────────────┐
│ Spring Boot │ ────────────▶  │  Card Words AI   │
│   Backend   │                │   (FastAPI)      │
└─────────────┘                └──────────────────┘
                                        │
                        ┌───────────────┼───────────────┐
                        ▼               ▼               ▼
                 ┌──────────┐    ┌──────────┐   ┌──────────┐
                 │PostgreSQL│    │  Redis   │   │  Models  │
                 │          │    │  Cache   │   │ XGB + RF │
                 └──────────┘    └──────────┘   └──────────┘
```

---

## Yêu cầu hệ thống

### Phần mềm

-   **Docker** ≥ 20.10
-   **Docker Compose** ≥ 2.0
-   **Python** 3.11+ (nếu chạy local)

### Tài nguyên

-   **RAM**: Tối thiểu 2GB cho service
-   **CPU**: 2 cores (khuyến nghị 4+ cores cho training nhanh)
-   **Disk**: 500MB cho models và dependencies

---

## Cài đặt và khởi động

### Bước 1: Clone repository

```bash
git clone https://github.com/thuanthichlaptrinh/card_words.git
cd card_words/server
```

### Bước 2: Cấu hình môi trường

File `.env` đã được chia sẻ từ root monorepo. Kiểm tra các biến quan trọng:

```env
# Database
POSTGRES_USER=postgres
POSTGRES_PASSWORD=123456
POSTGRES_HOST=postgres
POSTGRES_PORT=5432
POSTGRES_DB=card_words

# Redis
REDIS_HOST=redis
REDIS_PORT=6379
REDIS_AI_DB=1

# JWT (shared với Spring Boot)
JWT_SECRET=your-secret-key-change-in-production

# Admin keys
ADMIN_API_KEY=card-words-admin-key-2024
INTERNAL_API_KEY=card-words-internal-key-2024

# Active model
ACTIVE_MODEL_TYPE=xgboost  # hoặc "random_forest"
```

### Bước 3: Khởi động service

```bash
# Build và start
docker-compose up -d card-words-ai

# Xem logs
docker-compose logs -f card-words-ai

# Kiểm tra status
docker-compose ps card-words-ai
```

### Bước 4: Verify health

```bash
curl http://localhost:8001/health
```

**Response mong đợi:**

```json
{
    "status": "healthy",
    "service": "card-words-ai",
    "model_loaded": false,
    "active_model_type": "xgboost",
    "xgboost_loaded": false,
    "rf_loaded": false,
    "database_connected": true,
    "redis_connected": true,
    "timestamp": "2025-11-24T10:00:00"
}
```

⚠️ **Lưu ý**: `model_loaded: false` là bình thường lần đầu - cần train model trước.

---

## Huấn luyện Model

### Điều kiện tiên quyết

✅ **Cần có dữ liệu trong database:**

-   Bảng `user_vocab_progress` phải có ít nhất **10 records**
-   Dữ liệu cần đa dạng: có cả status NEW, KNOWN, UNKNOWN
-   Khuyến nghị: ≥100 records để model chính xác

### Kiểm tra dữ liệu

```bash
# Connect vào database
docker-compose exec postgres psql -U postgres -d card_words

# Đếm số records
SELECT COUNT(*) FROM user_vocab_progress;

# Xem phân bố status
SELECT status, COUNT(*) FROM user_vocab_progress GROUP BY status;

# Exit
\q
```

### Train XGBoost Model

**Linux/Mac:**

```bash
cd card-words-ai
./train-model.sh
```

**Windows PowerShell:**

```powershell
cd card-words-ai
.\train-model.ps1
```

**Hoặc dùng curl:**

```bash
curl -X POST http://localhost:8001/api/v1/smart-review/retrain \
  -H "X-API-Key: card-words-admin-key-2024" \
  -H "Content-Type: application/json" \
  -d '{"force": true, "model_type": "xgboost"}'
```

**Response thành công:**

```json
{
    "success": true,
    "model_type": "xgboost",
    "model_version": "v1.0.0",
    "metrics": {
        "accuracy": 0.85,
        "precision": 0.82,
        "recall": 0.88,
        "f1_score": 0.85,
        "auc_roc": 0.91
    },
    "training_time_seconds": 2.45,
    "samples_trained": 850
}
```

### Train Random Forest Model

```bash
# Linux/Mac
./train-rf-model.sh

# Windows
.\train-rf-model.ps1

# Hoặc curl
curl -X POST http://localhost:8001/api/v1/smart-review/retrain \
  -H "X-API-Key: card-words-admin-key-2024" \
  -H "Content-Type: application/json" \
  -d '{"force": true, "model_type": "random_forest"}'
```

### Chuyển đổi Active Model

**Cách 1: Sửa .env**

```env
ACTIVE_MODEL_TYPE=random_forest
```

Sau đó restart:

```bash
docker-compose restart card-words-ai
```

**Cách 2: Rebuild**

```bash
docker-compose up -d --build card-words-ai
```

---

## Sử dụng API

### 1. Health Check (Public)

```bash
curl http://localhost:8001/health
```

### 2. Get Smart Recommendations (Authenticated)

**Yêu cầu:** JWT token từ Spring Boot backend

```bash
curl -X POST http://localhost:8001/api/v1/smart-review/predict \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": "123e4567-e89b-12d3-a456-426614174000",
    "limit": 20
  }'
```

**Response:**

```json
{
    "user_id": "123e4567-e89b-12d3-a456-426614174000",
    "vocabs": [
        {
            "vocab_id": "456e7890-e89b-12d3-a456-426614174111",
            "word": "abandon",
            "meaning_vi": "từ bỏ",
            "transcription": "/əˈbændən/",
            "priority_score": 0.92,
            "status": "UNKNOWN",
            "times_correct": 2,
            "times_wrong": 5,
            "last_reviewed": "2025-11-10",
            "next_review_date": "2025-11-18"
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

### 3. Invalidate Cache (Internal)

```bash
curl -X POST http://localhost:8001/api/v1/smart-review/invalidate-cache \
  -H "X-API-Key: card-words-internal-key-2024" \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": "123e4567-e89b-12d3-a456-426614174000"
  }'
```

### 4. Metrics

```bash
curl http://localhost:8001/metrics
```

---

## Troubleshooting

### ❌ Lỗi: "500 Internal Server Error" khi train

**Nguyên nhân:** Dữ liệu không đủ hoặc thiếu class diversity

**Giải pháp:**

1. **Kiểm tra số lượng dữ liệu:**

    ```sql
    SELECT COUNT(*) FROM user_vocab_progress;
    ```

    Cần ít nhất 10 records.

2. **Kiểm tra class balance:**

    ```sql
    SELECT
      CASE
        WHEN status IN ('NEW', 'UNKNOWN') THEN 'need_review'
        WHEN status = 'KNOWN' AND next_review_date < CURRENT_DATE THEN 'need_review'
        ELSE 'no_need'
      END as label,
      COUNT(*)
    FROM user_vocab_progress
    GROUP BY label;
    ```

    Cần có cả 2 class (need_review và no_need).

3. **Thêm dữ liệu đa dạng:**
    - Tạo vocab progress với status khác nhau
    - Đảm bảo có cả từ mới và từ đang học

### ❌ Lỗi: "ValueError: Out of range float values are not JSON compliant"

**Đã fix** trong version mới - metrics chứa NaN/Inf sẽ được convert sang `null`.

**Nếu vẫn gặp, rebuild:**

```bash
docker-compose up -d --build card-words-ai
```

### ❌ Lỗi: "Model not loaded"

**Nguyên nhân:** Chưa train model hoặc file model bị thiếu

**Giải pháp:**

1. **Check file models:**

    ```bash
    docker-compose exec card-words-ai ls -lah /app/models/
    ```

2. **Train lại:**
    ```bash
    curl -X POST http://localhost:8001/api/v1/smart-review/retrain \
      -H "X-API-Key: card-words-admin-key-2024" \
      -d '{"force": true, "model_type": "xgboost"}'
    ```

### ❌ Lỗi: "Database connection failed"

```bash
# Check PostgreSQL
docker-compose ps postgres

# Restart nếu cần
docker-compose restart postgres

# Test connection
docker-compose exec postgres psql -U postgres -d card_words -c '\dt'
```

### ❌ Lỗi: "Redis connection failed"

```bash
# Check Redis
docker-compose ps redis

# Test connection
docker-compose exec redis redis-cli ping
# Expected: PONG

# Restart
docker-compose restart redis
```

### ❌ Lỗi: "JWT verification failed"

**Nguyên nhân:** JWT_SECRET không khớp giữa Spring Boot và AI service

**Giải pháp:**

1. Kiểm tra `.env`:

    ```env
    JWT_SECRET=your-secret-key-must-match-spring-boot
    ```

2. Restart cả 2 services:
    ```bash
    docker-compose restart card-words-api card-words-ai
    ```

---

## Nâng cao

### So sánh Models

| Model             | Accuracy | Training Time | Inference Time | Best For                  |
| ----------------- | -------- | ------------- | -------------- | ------------------------- |
| **XGBoost**       | 85-90%   | ~2s           | < 100ms        | Production, large dataset |
| **Random Forest** | 82-88%   | ~5s           | ~150ms         | Small dataset, stability  |

### Tuning Hyperparameters

**XGBoost** (`app/core/ml/xgboost_model.py`):

```python
DEFAULT_PARAMS = {
    'max_depth': 6,           # ↑ để tăng accuracy
    'learning_rate': 0.1,     # ↓ để tránh overfit
    'n_estimators': 100,      # ↑ để tăng accuracy
    'subsample': 0.8,
    'colsample_bytree': 0.8
}
```

**Random Forest** (`app/core/ml/random_forest_model.py`):

```python
DEFAULT_PARAMS = {
    'n_estimators': 100,      # ↑ để tăng accuracy
    'max_depth': 10,          # ↓ để tránh overfit
    'min_samples_split': 5,
    'min_samples_leaf': 2,
    'max_features': 'sqrt'
}
```

### Monitoring

**View logs:**

```bash
# Real-time
docker-compose logs -f card-words-ai

# Last 100 lines
docker-compose logs --tail=100 card-words-ai

# Search for errors
docker-compose logs card-words-ai | grep -i error
```

**Structured logs format:**

```json
{
    "event": "retrain_completed",
    "model_type": "xgboost",
    "metrics": { "accuracy": 0.85 },
    "timestamp": "2025-11-24T10:00:00Z",
    "level": "info"
}
```

### Performance Tips

1. **Tăng tốc inference:**

    - Enable Redis caching (đã mặc định)
    - Giảm `limit` trong predict request
    - Dùng XGBoost thay vì Random Forest

2. **Tăng accuracy:**

    - Thu thập thêm dữ liệu (>1000 samples)
    - Retrain model thường xuyên (weekly)
    - Tune hyperparameters

3. **Giảm memory:**
    - Giảm `n_estimators`
    - Giảm `max_depth`
    - Clear Redis cache thường xuyên

### Backup & Restore

**Backup models:**

```bash
docker-compose exec card-words-ai tar czf /tmp/models-backup.tar.gz /app/models/
docker cp $(docker-compose ps -q card-words-ai):/tmp/models-backup.tar.gz ./
```

**Restore models:**

```bash
docker cp models-backup.tar.gz $(docker-compose ps -q card-words-ai):/tmp/
docker-compose exec card-words-ai tar xzf /tmp/models-backup.tar.gz -C /
docker-compose restart card-words-ai
```

### Development Workflow

```bash
# 1. Code changes
cd card-words-ai/app

# 2. Rebuild
cd ../..
docker-compose up -d --build card-words-ai

# 3. Test
curl http://localhost:8001/health

# 4. View logs
docker-compose logs -f card-words-ai
```

---

## 📚 Tài liệu tham khảo

-   [README.md](README.md) - Overview và API documentation
-   [RANDOM_FOREST.md](RANDOM_FOREST.md) - Chi tiết Random Forest model
-   [QUICK_START.md](QUICK_START.md) - Quick start guide
-   [docs/](docs/) - Advanced documentation

## 🆘 Hỗ trợ

Nếu gặp vấn đề:

1. Check [Troubleshooting](#troubleshooting) section
2. Xem logs: `docker-compose logs card-words-ai`
3. Create issue trên GitHub repository

---

**Version:** 0.1.0  
**Last Updated:** 2025-11-24
