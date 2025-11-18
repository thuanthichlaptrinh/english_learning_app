**Card Words AI uses the SHARED `.env` file from the monorepo root.**

-   Config file: `../../../.env` (already configured)
-   No need to create local `.env` file
-   See `ENV_CONFIG.md` for details

## 🚀 Start Service trong 3 bước

### Bước 1: Build và Start

```bash
# Từ thư mục root của project
docker-compose up -d card-words-ai

# Xem logs
docker-compose logs -f card-words-ai
```

### Bước 2: Train Model lần đầu

```bash
curl -X POST http://localhost:8001/api/v1/smart-review/retrain \
  -H "X-API-Key: card-words-admin-key-2024" \
  -H "Content-Type: application/json" \
  -d '{"force": true}'
```

### Bước 3: Test API

```bash
# Health check
curl http://localhost:8001/health

# Hoặc chạy test script
cd card-words-ai
./test-api.sh        # Linux/Mac
./test-api.ps1       # Windows PowerShell
```

## 📋 Common Commands

### Service Management

```bash
# Start
docker-compose up -d card-words-ai

# Stop
docker-compose stop card-words-ai

# Restart
docker-compose restart card-words-ai

# View logs
docker-compose logs -f card-words-ai

# Remove
docker-compose down card-words-ai
```

### Health Checks

```bash
# Service health
curl http://localhost:8001/health

# Database connection
docker-compose exec card-words-ai python -c "
from app.db.database_service import DatabaseService
import asyncio
asyncio.run(DatabaseService().health_check())
"

# Redis connection
docker-compose exec redis redis-cli ping
```

### Model Management

```bash
# Train model
curl -X POST http://localhost:8001/api/v1/smart-review/retrain \
  -H "X-API-Key: card-words-admin-key-2024" \
  -d '{"force": true}'

# Check model files
docker-compose exec card-words-ai ls -la /app/models/

# Backup models
tar -czf models-backup.tar.gz card-words-ai/models/
```

## 🔑 Configuration

All configs are in the root `.env` file (`../../.env`):

```env
# Database (shared with Spring Boot)
POSTGRES_USER=postgres
POSTGRES_PASSWORD=123456
POSTGRES_HOST=postgres
POSTGRES_PORT=5432
POSTGRES_DB=card_words

# Redis (different DB index from Spring Boot)
REDIS_HOST=redis
REDIS_PORT=6379
REDIS_AI_DB=1

# JWT (MUST match Spring Boot)
JWT_SECRET=Y2FyZC13b3Jkcy1zZWNyZXQta2V5...

# API Keys
ADMIN_API_KEY=card-words-admin-key-2024
INTERNAL_API_KEY=card-words-internal-key-2024
```

To update configs:

1. Edit `../../.env`
2. Restart service: `docker-compose restart card-words-ai`

## 📊 API Endpoints

### Public

-   `GET /` - Root
-   `GET /health` - Health check
-   `GET /metrics` - Metrics

### Authenticated (JWT)

-   `POST /api/v1/smart-review/predict` - Get recommendations

### Admin (API Key)

-   `POST /api/v1/smart-review/retrain` - Train model

### Internal (API Key)

-   `POST /api/v1/smart-review/invalidate-cache` - Clear cache

## 🐛 Troubleshooting

### Service không start

```bash
# Check logs
docker-compose logs card-words-ai

# Check dependencies
docker-compose ps postgres redis
```

### Model không load

```bash
# Check model files
docker-compose exec card-words-ai ls -la /app/models/

# Train model
curl -X POST http://localhost:8001/api/v1/smart-review/retrain \
  -H "X-API-Key: card-words-admin-key-2024" \
  -d '{"force": true}'
```

### Database connection failed

```bash
# Check PostgreSQL
docker-compose ps postgres

# Test connection
docker-compose exec postgres psql -U postgres -d card_words -c '\dt'
```

### Redis connection failed

```bash
# Check Redis
docker-compose ps redis

# Test connection
docker-compose exec redis redis-cli ping
```

## 📚 Documentation

-   **README.md** - Full documentation
-   **DEPLOYMENT.md** - Deployment guide
-   **IMPLEMENTATION_SUMMARY.md** - Technical details
-   **QUICK_START.md** - This file

## 🆘 Need Help?

1. Check logs: `docker-compose logs card-words-ai`
2. Check health: `curl http://localhost:8001/health`
3. Review documentation in `card-words-ai/` folder
4. Create GitHub issue with error details

## ✅ Checklist

-   [ ] Docker và Docker Compose installed
-   [ ] PostgreSQL có dữ liệu `user_vocab_progress`
-   [ ] Redis đang chạy
-   [ ] Service started: `docker-compose up -d card-words-ai`
-   [ ] Model trained: `POST /api/v1/smart-review/retrain`
-   [ ] Health check passed: `GET /health`
-   [ ] API tested: Run test scripts

**Ready to use!** 🎉
