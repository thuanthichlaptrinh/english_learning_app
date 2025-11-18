# Card Words AI Service

AI-powered vocabulary review system using XGBoost for smart recommendations.

## Overview

This microservice provides intelligent vocabulary review recommendations using machine learning. It analyzes user learning patterns from the `user_vocab_progress` table and predicts which vocabularies need review using an XGBoost classifier.

## Features

-   **Smart Recommendations**: XGBoost-based predictions for vocabulary review priority
-   **Feature Engineering**: Extracts 9 features from learning data (accuracy, recency, difficulty, etc.)
-   **Redis Caching**: Fast responses with 5-minute TTL cache
-   **JWT Authentication**: Secure integration with Spring Boot backend
-   **Async Operations**: High-performance async database and cache operations
-   **Model Retraining**: Admin API to retrain model with latest data
-   **Health Monitoring**: Health checks and metrics endpoints

## Tech Stack

-   **Python 3.11**
-   **FastAPI** - Modern async web framework
-   **XGBoost** - Gradient boosting machine learning
-   **SQLAlchemy** - Async ORM for PostgreSQL
-   **Redis** - Caching layer
-   **Structlog** - Structured logging
-   **Docker** - Containerization

## Project Structure

```
card-words-ai/
├── app/
│   ├── main.py                    # FastAPI application
│   ├── config.py                  # Configuration settings
│   ├── api/                       # API endpoints
│   ├── core/
│   │   ├── ml/                    # ML components
│   │   │   ├── feature_extractor.py
│   │   │   └── xgboost_model.py
│   │   └── services/              # Business services
│   │       ├── smart_review_service.py
│   │       └── cache_service.py
│   ├── db/                        # Database layer
│   │   ├── models/                # SQLAlchemy models
│   │   └── database_service.py
│   ├── middleware/                # Auth & error handling
│   └── schemas/                   # Pydantic schemas
├── models/                        # Trained ML models
├── tests/                         # Unit & integration tests
├── Dockerfile
├── pyproject.toml                 # Poetry dependencies
└── README.md
```

## Installation

### Using Docker (Recommended)

The service is already configured in the root `docker-compose.yml`:

```bash
# From project root
docker-compose up -d card-words-ai
```

### Local Development

```bash
cd card-words-ai

# Install Poetry
pip install poetry

# Install dependencies
poetry install

# Copy environment file
cp .env.example .env

# Edit .env with your configuration
nano .env

# Run service
poetry run uvicorn app.main:app --reload --port 8001
```

## Configuration

Environment variables (see `.env.example`):

```env
# Database
DATABASE_URL=postgresql://user:pass@postgres:5432/card_words

# Redis
REDIS_URL=redis://redis:6379/1

# JWT (shared with Spring Boot)
JWT_SECRET=your-secret-key

# Model paths
MODEL_PATH=/app/models/xgboost_model_v1.pkl
SCALER_PATH=/app/models/scaler_v1.pkl

# API Keys
ADMIN_API_KEY=your-admin-key
INTERNAL_API_KEY=your-internal-key
```

## API Endpoints

### Public Endpoints

**GET /** - Root endpoint

```bash
curl http://localhost:8001/
```

**GET /health** - Health check

```bash
curl http://localhost:8001/health
```

**GET /metrics** - Service metrics

```bash
curl http://localhost:8001/metrics
```

### Authenticated Endpoints

**POST /api/v1/smart-review/predict** - Get smart recommendations

Requires: JWT Bearer token

```bash
curl -X POST http://localhost:8001/api/v1/smart-review/predict \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": "user-uuid",
    "limit": 20
  }'
```

Response:

```json
{
    "user_id": "user-uuid",
    "vocabs": [
        {
            "vocab_id": "vocab-uuid",
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

### Admin Endpoints

**POST /api/v1/smart-review/retrain** - Retrain model

Requires: Admin API key in `X-API-Key` header

```bash
curl -X POST http://localhost:8001/api/v1/smart-review/retrain \
  -H "X-API-Key: YOUR_ADMIN_KEY" \
  -H "Content-Type: application/json" \
  -d '{"force": false}'
```

### Internal Endpoints

**POST /api/v1/smart-review/invalidate-cache** - Invalidate user cache

Requires: Internal API key in `X-API-Key` header

```bash
curl -X POST http://localhost:8001/api/v1/smart-review/invalidate-cache \
  -H "X-API-Key: YOUR_INTERNAL_KEY" \
  -H "Content-Type: application/json" \
  -d '{"user_id": "user-uuid"}'
```

## Machine Learning

### Features (9 dimensions)

1. **times_correct**: Number of correct answers
2. **times_wrong**: Number of wrong answers
3. **accuracy_rate**: Correct / (Correct + Wrong)
4. **days_since_last_review**: Days from last review
5. **days_until_next_review**: Days to next review (negative if overdue)
6. **interval_days**: Current review interval
7. **repetition**: Number of repetitions
8. **ef_factor**: Easiness factor (SM-2 algorithm)
9. **status_encoded**: NEW=0, UNKNOWN=1, KNOWN=2, MASTERED=3

### Model Training

Labels are generated based on:

-   **Label = 1** (need review): UNKNOWN, NEW, or KNOWN with (overdue OR accuracy < 70%)
-   **Label = 0** (no need review): Otherwise

XGBoost hyperparameters:

```python
{
    'max_depth': 6,
    'learning_rate': 0.1,
    'n_estimators': 100,
    'objective': 'binary:logistic',
    'eval_metric': 'auc'
}
```

### Retraining

To retrain the model with latest data:

```bash
curl -X POST http://localhost:8001/api/v1/smart-review/retrain \
  -H "X-API-Key: YOUR_ADMIN_KEY" \
  -H "Content-Type: application/json" \
  -d '{"force": true}'
```

The old model is automatically backed up before training.

## Caching Strategy

-   **Cache Key**: `smart_review:{user_id}`
-   **TTL**: 300 seconds (5 minutes)
-   **Invalidation**: Automatic when user submits learning results

## Performance

-   **Inference Time**: < 200ms for 100 vocabs
-   **Cache Hit Rate**: ~80% in production
-   **Concurrent Requests**: Up to 50 simultaneous requests

## Monitoring

### Health Check

```bash
curl http://localhost:8001/health
```

Returns:

-   Database connection status
-   Redis connection status
-   Model loaded status

### Logs

Structured JSON logs with:

-   Timestamp
-   Log level
-   Event type
-   Context data

View logs:

```bash
docker-compose logs -f card-words-ai
```

## Development

### Running Tests

```bash
poetry run pytest
```

### Code Formatting

```bash
poetry run black app/
poetry run ruff check app/
```

### Adding Dependencies

```bash
poetry add package-name
poetry add --group dev package-name  # Dev dependencies
```

## Deployment

The service is deployed as part of the main docker-compose stack:

```yaml
card-words-ai:
    build: ./card-words-ai
    ports:
        - '8001:8001'
    environment:
        - DATABASE_URL=postgresql://...
        - REDIS_URL=redis://...
        - JWT_SECRET=${JWT_SECRET}
    volumes:
        - ./card-words-ai/models:/app/models
    networks:
        - card-words-network
```

## Troubleshooting

### Model not loaded

Check if model files exist:

```bash
ls -la card-words-ai/models/
```

Train initial model:

```bash
curl -X POST http://localhost:8001/api/v1/smart-review/retrain \
  -H "X-API-Key: YOUR_ADMIN_KEY" \
  -d '{"force": true}'
```

### Database connection failed

Check PostgreSQL is running:

```bash
docker-compose ps postgres
```

Test connection:

```bash
docker-compose exec postgres psql -U postgres -d card_words -c '\dt'
```

### Redis connection failed

Check Redis is running:

```bash
docker-compose ps redis
```

Test connection:

```bash
docker-compose exec redis redis-cli ping
```

## License

[Your License]

## Support

For issues and questions, please create an issue in the GitHub repository.
