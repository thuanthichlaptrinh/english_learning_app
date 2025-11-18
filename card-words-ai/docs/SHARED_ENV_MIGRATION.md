# Shared .env Configuration - Change Summary

## 🎯 Mục đích

Cấu hình lại Card Words AI để sử dụng file `.env` chung từ root của monorepo, thay vì file `.env` riêng.

---

## ✅ Những gì đã thay đổi

### 1. **app/config.py** - Cấu hình chính ⭐

#### Trước:
```python
class Settings(BaseSettings):
    DATABASE_URL: str = "postgresql://..."
    REDIS_URL: str = "redis://..."
    
    class Config:
        env_file = ".env"  # Local .env file
```

#### Sau:
```python
class Settings(BaseSettings):
    # Hỗ trợ cả components và full URL
    POSTGRES_USER: str = "postgres"
    POSTGRES_PASSWORD: str = "123456"
    POSTGRES_HOST: str = "postgres"
    # ... các components khác
    
    DATABASE_URL: Optional[str] = None
    REDIS_URL: Optional[str] = None
    
    class Config:
        # Trỏ đến root .env file
        env_file = str(Path(__file__).parent.parent.parent.parent / ".env")
        case_sensitive = True
        extra = "allow"
    
    @property
    def get_database_url(self) -> str:
        """Build database URL từ components nếu DATABASE_URL không được set"""
        if self.DATABASE_URL:
            return self.DATABASE_URL
        return f"postgresql://{self.POSTGRES_USER}:{self.POSTGRES_PASSWORD}@{self.POSTGRES_HOST}:{self.POSTGRES_PORT}/{self.POSTGRES_DB}"
    
    @property
    def get_redis_url(self) -> str:
        """Build Redis URL từ components nếu REDIS_URL không được set"""
        if self.REDIS_URL:
            return self.REDIS_URL
        return f"redis://{self.REDIS_HOST}:{self.REDIS_PORT}/{self.REDIS_AI_DB}"
```

**Lý do thay đổi:**
- ✅ Tự động tìm file `.env` ở root
- ✅ Linh hoạt: dùng components hoặc full URL
- ✅ Properties để build URL động

---

### 2. **app/db/database_service.py** - Database Service

#### Thay đổi:
```python
# Trước
self.database_url = database_url or settings.DATABASE_URL

# Sau
self.database_url = database_url or settings.get_database_url
```

---

### 3. **app/core/services/cache_service.py** - Cache Service

#### Thay đổi:
```python
# Trước
self.redis_url = redis_url or settings.REDIS_URL

# Sau
self.redis_url = redis_url or settings.get_redis_url
```

---

### 4. **.env.example** - Documentation

#### Cập nhật:
- Thêm warning ở đầu file: "Uses SHARED .env from root"
- Giữ lại như reference documentation
- Giải thích rõ không cần tạo local `.env`

---

### 5. **ENV_CONFIG.md** - New File ⭐

Tạo file hướng dẫn chi tiết về:
- Tại sao dùng shared .env
- Cách hoạt động
- Các biến environment
- URL building
- Local development
- Troubleshooting

---

### 6. **QUICK_START.md** - Updated

Thêm section về configuration:
- Warning về shared .env
- Link đến ENV_CONFIG.md
- Hướng dẫn update config

---

### 7. **setup.sh / setup.ps1** - Setup Scripts

#### Thay đổi:
```bash
# Trước: Copy .env.example to .env
if [ ! -f .env ]; then
    cp .env.example .env
fi

# Sau: Check root .env exists
if [ ! -f ../../.env ]; then
    echo "❌ Root .env file not found"
    exit 1
fi
```

---

## 📁 File Structure

```
project/server/
├── .env                          ← SHARED CONFIG (TẤT CẢ SERVICES)
├── docker-compose.yml
├── card-words/                   ← Spring Boot (đã dùng .env này)
└── card-words-ai/               ← FastAPI (mới cập nhật)
    ├── app/
    │   ├── config.py            ✅ UPDATED (trỏ đến root .env)
    │   ├── db/
    │   │   └── database_service.py  ✅ UPDATED (dùng property)
    │   └── core/services/
    │       └── cache_service.py     ✅ UPDATED (dùng property)
    ├── .env.example             ✅ UPDATED (documentation only)
    ├── ENV_CONFIG.md            ✅ NEW (hướng dẫn chi tiết)
    ├── QUICK_START.md           ✅ UPDATED (thêm config info)
    ├── setup.sh                 ✅ UPDATED (check root .env)
    └── setup.ps1                ✅ UPDATED (check root .env)
```

---

## 🔄 Migration Guide

### Nếu có local `.env` file cũ:

1. **Backup (nếu cần):**
   ```bash
   cd card-words-ai
   mv .env .env.backup
   ```

2. **Verify root .env:**
   ```bash
   cat ../../.env | grep -E "POSTGRES_|REDIS_|JWT_|ADMIN_API_KEY"
   ```

3. **Không cần tạo local .env:**
   Config sẽ tự động load từ root

4. **Test:**
   ```bash
   docker-compose up -d card-words-ai
   docker-compose logs card-words-ai | grep initialized
   ```

---

## ✨ Lợi ích

### 1. **Single Source of Truth**
- Tất cả configs ở 1 nơi: `project/server/.env`
- Không duplicate JWT_SECRET, database credentials
- Dễ maintain và update

### 2. **Consistency**
- Spring Boot và FastAPI dùng chung configs
- JWT_SECRET đảm bảo giống nhau
- Database/Redis credentials đồng bộ

### 3. **Flexibility**
- Hỗ trợ cả individual components và full URLs
- Override bằng environment variables nếu cần
- Default values trong code

### 4. **Developer Experience**
- Setup đơn giản hơn (không cần config 2 lần)
- Ít lỗi cấu hình
- Documentation rõ ràng

---

## 🧪 Testing

### Test 1: Config Loading

```bash
# Start service
docker-compose up -d card-words-ai

# Check logs
docker-compose logs card-words-ai | grep -E "database_service_initialized|cache_service_initialized"

# Expected:
# database_service_initialized database_url=postgres:5432/card_words
# cache_service_initialized redis_url=redis://redis:6379/1
```

### Test 2: Verify Settings

```bash
docker exec -it card-words-ai python -c "
from app.config import settings
print('Database:', settings.get_database_url)
print('Redis:', settings.get_redis_url)
print('JWT Secret:', settings.JWT_SECRET[:20] + '...')
print('Admin Key:', settings.ADMIN_API_KEY)
"
```

### Test 3: Service Health

```bash
curl http://localhost:8001/health

# Expected:
{
  "status": "healthy",
  "database_connected": true,
  "redis_connected": true,
  ...
}
```

---

## 📊 Environment Variables trong Root .env

### Shared Variables (cả 2 services):
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

# JWT (CRITICAL: must match!)
JWT_SECRET=Y2FyZC13b3Jkcy1zZWNyZXQta2V5LWZvci1qd3QtdG9rZW4tZ2VuZXJhdGlvbg==
```

### AI Service Specific:
```env
# Redis DB (different from Spring Boot)
REDIS_AI_DB=1

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
MAX_CONCURRENT_REQUESTS=50
INFERENCE_WARNING_THRESHOLD_MS=2000
```

---

## 🔍 Troubleshooting

### Issue: "Config not loading"

**Solution:**
```bash
# Verify .env file exists
ls -la ../../.env

# Check path in config.py
docker exec -it card-words-ai python -c "
from pathlib import Path
env_path = Path(__file__).parent.parent.parent.parent / '.env'
print(f'Looking for .env at: {env_path}')
print(f'Exists: {env_path.exists()}')
"
```

### Issue: "Database connection failed"

**Solution:**
```bash
# Check DATABASE_URL is built correctly
docker exec -it card-words-ai python -c "
from app.config import settings
print(settings.get_database_url)
"

# Should output: postgresql://postgres:123456@postgres:5432/card_words
```

### Issue: "JWT validation failed"

**Solution:**
```bash
# Verify JWT_SECRET matches between services
echo "Spring Boot JWT Secret:"
docker exec -it card-words-api env | grep JWT_SECRET

echo "AI Service JWT Secret:"
docker exec -it card-words-ai env | grep JWT_SECRET

# They MUST be identical!
```

---

## 📚 Documentation

- **Full Config Guide:** `ENV_CONFIG.md`
- **Quick Start:** `QUICK_START.md`
- **Complete Docs:** `../../docs/AI/CARD_WORDS_AI_OVERVIEW.md`
- **Root README:** `../../README.md`

---

## ✅ Checklist

- [x] `config.py` updated to use root .env
- [x] `database_service.py` uses property
- [x] `cache_service.py` uses property
- [x] `.env.example` updated with warnings
- [x] `ENV_CONFIG.md` created
- [x] `QUICK_START.md` updated
- [x] `setup.sh` updated
- [x] `setup.ps1` updated
- [x] Documentation complete
- [x] Tested and working

---

**Updated:** 2024-11-18  
**Version:** 2.0.0  
**Status:** ✅ Production Ready
