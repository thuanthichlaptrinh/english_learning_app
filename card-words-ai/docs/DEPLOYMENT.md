# Card Words AI - Deployment Guide

## Prerequisites

-   Docker và Docker Compose đã được cài đặt
-   PostgreSQL database đã có dữ liệu `user_vocab_progress`
-   Redis đang chạy
-   JWT secret được chia sẻ với Spring Boot backend

## Quick Start

### 1. Build và Start Service

Từ thư mục root của project:

```bash
# Build service
docker-compose build card-words-ai

# Start service
docker-compose up -d card-words-ai

# Xem logs
docker-compose logs -f card-words-ai
```

### 2. Verify Service is Running

```bash
# Health check
curl http://localhost:8001/health

# Expected response:
{
  "status": "healthy",
  "service": "card-words-ai",
  "model_loaded": false,  # Will be false until model is trained
  "database_connected": true,
  "redis_connected": true,
  "timestamp": "2024-11-18T10:30:00Z"
}
```

### 3. Train Initial Model

Model cần được train lần đầu tiên trước khi sử dụng:

```bash
curl -X POST http://localhost:8001/api/v1/smart-review/retrain \
  -H "X-API-Key: card-words-admin-key-2024" \
  -H "Content-Type: application/json" \
  -d '{"force": true}'
```

Response:

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
    "samples_trained": 15000
}
```

### 4. Test Prediction Endpoint

Bạn cần JWT token hợp lệ từ Spring Boot backend:

```bash
# Get JWT token from Spring Boot login
TOKEN="your-jwt-token-here"

# Test prediction
curl -X POST http://localhost:8001/api/v1/smart-review/predict \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": "your-user-uuid",
    "limit": 20
  }'
```

## Environment Variables

Các biến môi trường được cấu hình trong file `.env` ở root:

```env
# Database
DATABASE_URL=postgresql://postgres:123456@postgres:5432/card_words

# Redis
REDIS_URL=redis://redis:6379/1

# JWT (shared with Spring Boot)
JWT_SECRET=Y2FyZC13b3Jkcy1zZWNyZXQta2V5...
JWT_ALGORITHM=HS256

# Model paths
MODEL_PATH=/app/models/xgboost_model_v1.pkl
SCALER_PATH=/app/models/scaler_v1.pkl
MODEL_VERSION=v1.0.0

# API Keys
ADMIN_API_KEY=card-words-admin-key-2024
INTERNAL_API_KEY=card-words-internal-key-2024

# Performance
CACHE_TTL=300
RATE_LIMIT_PER_MINUTE=60
```

## Docker Compose Configuration

Service được định nghĩa trong `docker-compose.yml`:

```yaml
card-words-ai:
    build:
        context: ./card-words-ai
        dockerfile: Dockerfile
    container_name: card-words-ai
    ports:
        - '8001:8001'
    volumes:
        - ./card-words-ai/models:/app/models
    depends_on:
        - postgres
        - redis
    networks:
        - card-words-network
```

## Model Management

### Training Schedule

Nên retrain model định kỳ để cập nhật với dữ liệu mới:

```bash
# Retrain hàng tuần (có thể setup cron job)
curl -X POST http://localhost:8001/api/v1/smart-review/retrain \
  -H "X-API-Key: card-words-admin-key-2024" \
  -H "Content-Type: application/json" \
  -d '{"force": true}'
```

### Model Files

Models được lưu trong thư mục `card-words-ai/models/`:

```
models/
├── xgboost_model_v1.pkl      # XGBoost classifier
├── scaler_v1.pkl              # StandardScaler for features
└── xgboost_model_v1.pkl.backup # Backup của model cũ
```

### Backup Strategy

-   Model cũ tự động được backup trước khi train model mới
-   Backup file: `xgboost_model_v1.pkl.backup`
-   Để restore backup:

```bash
docker-compose exec card-words-ai bash
cd /app/models
mv xgboost_model_v1.pkl.backup xgboost_model_v1.pkl
mv scaler_v1.pkl.backup scaler_v1.pkl
exit

# Restart service
docker-compose restart card-words-ai
```

## Integration with Spring Boot

### Spring Boot Configuration

Thêm vào `application.yml`:

```yaml
ai:
    service:
        base-url: http://card-words-ai:8001
        internal-api-key: card-words-internal-key-2024
        timeout:
            connect: 5000
            read: 10000
```

### REST Client Example

```java
@Service
public class AIServiceClient {

    @Value("${ai.service.base-url}")
    private String aiServiceBaseUrl;

    @Value("${ai.service.internal-api-key}")
    private String internalApiKey;

    private final RestTemplate restTemplate;

    public SmartReviewResponse getSmartReview(String userId, int limit) {
        String url = aiServiceBaseUrl + "/api/v1/smart-review/predict";

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setBearerAuth(getCurrentUserJwtToken());

        Map<String, Object> request = Map.of(
            "user_id", userId,
            "limit", limit
        );

        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(request, headers);

        return restTemplate.postForObject(url, entity, SmartReviewResponse.class);
    }

    public void invalidateUserCache(String userId) {
        String url = aiServiceBaseUrl + "/api/v1/smart-review/invalidate-cache";

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.set("X-API-Key", internalApiKey);

        Map<String, String> request = Map.of("user_id", userId);
        HttpEntity<Map<String, String>> entity = new HttpEntity<>(request, headers);

        restTemplate.postForObject(url, entity, Void.class);
    }
}
```

### Cache Invalidation

Khi user submit kết quả học tập, invalidate cache:

```java
@PostMapping("/api/v1/learn-vocabs/submit")
public ResponseEntity<?> submitLearningResult(@RequestBody SubmitRequest request) {
    // Save learning result
    learningService.submitResult(request);

    // Invalidate AI service cache
    aiServiceClient.invalidateUserCache(request.getUserId());

    return ResponseEntity.ok().build();
}
```

## Monitoring

### Health Check

```bash
# Check service health
curl http://localhost:8001/health

# Check from Docker
docker-compose exec card-words-ai curl http://localhost:8001/health
```

### Logs

```bash
# View logs
docker-compose logs -f card-words-ai

# View last 100 lines
docker-compose logs --tail=100 card-words-ai

# Search logs
docker-compose logs card-words-ai | grep "error"
```

### Metrics

```bash
# Get service metrics
curl http://localhost:8001/metrics
```

## Troubleshooting

### Service won't start

```bash
# Check logs
docker-compose logs card-words-ai

# Common issues:
# 1. Database not ready
docker-compose ps postgres

# 2. Redis not ready
docker-compose ps redis

# 3. Port conflict
netstat -ano | findstr :8001  # Windows
lsof -i :8001                 # Mac/Linux
```

### Model not loading

```bash
# Check if model files exist
docker-compose exec card-words-ai ls -la /app/models/

# If missing, train model
curl -X POST http://localhost:8001/api/v1/smart-review/retrain \
  -H "X-API-Key: card-words-admin-key-2024" \
  -d '{"force": true}'
```

### Database connection failed

```bash
# Test database connection
docker-compose exec card-words-ai python -c "
from app.db.database_service import DatabaseService
import asyncio

async def test():
    db = DatabaseService()
    result = await db.health_check()
    print(f'Database healthy: {result}')

asyncio.run(test())
"
```

### Redis connection failed

```bash
# Test Redis connection
docker-compose exec redis redis-cli ping

# Check Redis from AI service
docker-compose exec card-words-ai python -c "
from app.core.services.cache_service import CacheService
import asyncio

async def test():
    cache = CacheService()
    result = await cache.health_check()
    print(f'Redis healthy: {result}')

asyncio.run(test())
"
```

### Slow predictions

```bash
# Check inference time in logs
docker-compose logs card-words-ai | grep "inference_time_ms"

# If slow:
# 1. Check database query performance
# 2. Verify Redis is working (cache should speed up)
# 3. Consider reducing number of vocabs to analyze
```

## Performance Tuning

### Database Connection Pool

Adjust in `app/db/database_service.py`:

```python
self.engine = create_async_engine(
    self.database_url,
    pool_size=20,      # Increase for more concurrent requests
    max_overflow=10,   # Additional connections when pool is full
    pool_pre_ping=True
)
```

### Cache TTL

Adjust in `.env`:

```env
CACHE_TTL=300  # Increase for longer cache (less DB queries)
```

### Rate Limiting

Adjust in `.env`:

```env
RATE_LIMIT_PER_MINUTE=60  # Increase for higher throughput
```

## Security

### API Keys

Change default API keys in `.env`:

```env
ADMIN_API_KEY=your-secure-admin-key-here
INTERNAL_API_KEY=your-secure-internal-key-here
```

### JWT Secret

Ensure JWT secret matches Spring Boot:

```env
JWT_SECRET=same-secret-as-spring-boot
```

### Network Security

Service chỉ accessible trong Docker network:

```yaml
networks:
    - card-words-network # Internal network only
```

Để expose ra ngoài, cần configure reverse proxy (nginx, traefik).

## Scaling

### Horizontal Scaling

Để scale service:

```yaml
card-words-ai:
    deploy:
        replicas: 3 # Run 3 instances
```

Cần thêm load balancer (nginx, traefik) để distribute requests.

### Vertical Scaling

Tăng resources cho container:

```yaml
card-words-ai:
    deploy:
        resources:
            limits:
                cpus: '2'
                memory: 2G
            reservations:
                cpus: '1'
                memory: 1G
```

## Backup & Recovery

### Backup Models

```bash
# Backup models directory
tar -czf models-backup-$(date +%Y%m%d).tar.gz card-words-ai/models/

# Copy to safe location
cp models-backup-*.tar.gz /path/to/backup/
```

### Restore Models

```bash
# Extract backup
tar -xzf models-backup-20241118.tar.gz

# Restart service
docker-compose restart card-words-ai
```

## Production Checklist

-   [ ] Change default API keys
-   [ ] Configure proper JWT secret
-   [ ] Train initial model
-   [ ] Setup monitoring (Prometheus, Grafana)
-   [ ] Configure log aggregation (ELK, Loki)
-   [ ] Setup automated backups
-   [ ] Configure reverse proxy (nginx)
-   [ ] Enable HTTPS
-   [ ] Setup CI/CD pipeline
-   [ ] Configure health check alerts
-   [ ] Document runbook for incidents

## Support

For issues and questions:

-   Check logs: `docker-compose logs card-words-ai`
-   Review health: `curl http://localhost:8001/health`
-   Create GitHub issue with logs and error details
