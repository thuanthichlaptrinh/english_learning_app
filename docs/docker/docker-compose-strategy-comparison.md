# Docker Compose Strategy: Shared vs Separate

## 1. So sánh 2 Approaches

### **Approach 1: Shared docker-compose.yml (RECOMMENDED)** ⭐

```
card-words-services/
├── docker-compose.yml              # ✅ CHUNG cho cả 2 projects
├── .env
│
├── card-words/
│   ├── Dockerfile
│   └── ...
│
└── card-words-ai/
    ├── Dockerfile
    └── ...
```

### **Approach 2: Separate docker-compose.yml**

```
card-words-services/
│
├── card-words/
│   ├── docker-compose.yml          # ❌ Riêng cho Spring Boot
│   ├── Dockerfile
│   └── ...
│
└── card-words-ai/
    ├── docker-compose.yml          # ❌ Riêng cho Python AI
    ├── Dockerfile
    └── ...
```

---

## 2. Chi tiết Approach 1: Shared (RECOMMENDED)

### ✅ **Ưu điểm:**

#### 1. **Quản lý tập trung**
```bash
# Một command cho tất cả
docker-compose up -d

# Thay vì
cd card-words && docker-compose up -d
cd ../card-words-ai && docker-compose up -d
```

#### 2. **Shared resources dễ dàng**
```yaml
# Dùng chung database, redis, network
services:
  postgres:      # Shared
  redis:         # Shared
  card-words-api:
  card-words-ai:
```

#### 3. **Service communication đơn giản**
```yaml
# card-words-api có thể gọi card-words-ai
environment:
  - AI_SERVICE_URL=http://card-words-ai:8001  # ✅ Cùng network
```

#### 4. **Dependency management rõ ràng**
```yaml
card-words-api:
  depends_on:
    - postgres
    - redis
    - card-words-ai  # ✅ Explicit dependency
```

#### 5. **Development workflow đơn giản**
```bash
# Start all
docker-compose up -d

# Stop all
docker-compose down

# Rebuild specific service
docker-compose up -d --build card-words-ai

# View logs
docker-compose logs -f card-words-api
```

#### 6. **Production deployment dễ dàng**
```bash
# Deploy all services cùng lúc
docker-compose -f docker-compose.prod.yml up -d

# Scale specific service
docker-compose up -d --scale card-words-api=3
```

### ❌ **Nhược điểm:**

1. **File lớn hơn** - Nhưng có thể split với `extends`
2. **Phải rebuild cả 2** nếu thay đổi base config - Nhưng có thể override
3. **Conflict nếu 2 team làm việc** - Nhưng có thể dùng override files

### 🎯 **Use Cases:**

✅ **Microservices cần communicate**  
✅ **Shared infrastructure** (DB, Redis, etc.)  
✅ **Development environment**  
✅ **Production deployment**  
✅ **CI/CD pipelines**  

---

## 3. Chi tiết Approach 2: Separate

### ✅ **Ưu điểm:**

#### 1. **Independence**
```bash
# Mỗi service độc lập
cd card-words
docker-compose up -d

cd card-words-ai
docker-compose up -d
```

#### 2. **Team autonomy**
- Team Spring Boot quản lý file riêng
- Team Python AI quản lý file riêng
- Không conflict khi commit

#### 3. **Simpler files**
```yaml
# card-words/docker-compose.yml - Chỉ Spring Boot
services:
  app:
  postgres:
  redis:

# card-words-ai/docker-compose.yml - Chỉ Python
services:
  ai-service:
  postgres:  # Duplicate!
  redis:     # Duplicate!
```

### ❌ **Nhược điểm:**

#### 1. **Resource duplication**
```yaml
# card-words/docker-compose.yml
postgres:
  ports: ['5432:5432']

# card-words-ai/docker-compose.yml
postgres:
  ports: ['5432:5432']  # ❌ PORT CONFLICT!
```

#### 2. **Network isolation**
```bash
# card-words-api không thể gọi card-words-ai
# Vì ở 2 networks khác nhau
curl http://card-words-ai:8001  # ❌ Failed!
```

#### 3. **Complex management**
```bash
# Phải start từng service
cd card-words && docker-compose up -d
cd ../card-words-ai && docker-compose up -d

# Phải stop từng service
cd card-words && docker-compose down
cd ../card-words-ai && docker-compose down
```

#### 4. **Dependency hell**
```bash
# Phải start theo thứ tự
1. Start postgres
2. Start redis
3. Start card-words-ai
4. Start card-words-api

# Nếu sai thứ tự → lỗi!
```

### 🎯 **Use Cases:**

✅ **Completely independent services**  
✅ **Different deployment schedules**  
✅ **Different teams, different repos**  
✅ **Services không cần communicate**  

---

## 4. Hybrid Approach: Best of Both Worlds

### **Structure:**

```
card-words-services/
├── docker-compose.yml              # ✅ Main (shared infrastructure)
├── docker-compose.dev.yml          # ✅ Development overrides
├── docker-compose.prod.yml         # ✅ Production overrides
│
├── card-words/
│   ├── docker-compose.override.yml # ⚠️ Optional (local dev)
│   └── Dockerfile
│
└── card-words-ai/
    ├── docker-compose.override.yml # ⚠️ Optional (local dev)
    └── Dockerfile
```

### **Main docker-compose.yml (Shared):**

```yaml
# docker-compose.yml - Base configuration
version: '3.8'

services:
  # Shared infrastructure
  postgres:
    image: postgres:16-alpine
    # ... config

  redis:
    image: redis:7-alpine
    # ... config

  # Services
  card-words-api:
    build: ./card-words
    # ... base config

  card-words-ai:
    build: ./card-words-ai
    # ... base config
```

### **Development Override:**

```yaml
# docker-compose.dev.yml
version: '3.8'

services:
  card-words-api:
    volumes:
      - ./card-words/src:/app/src  # Hot reload
    environment:
      - SPRING_PROFILES_ACTIVE=dev
      - DEBUG=true

  card-words-ai:
    volumes:
      - ./card-words-ai/app:/app/app  # Hot reload
    command: uvicorn app.main:app --reload
    environment:
      - LOG_LEVEL=DEBUG
```

### **Production Override:**

```yaml
# docker-compose.prod.yml
version: '3.8'

services:
  card-words-api:
    restart: always
    environment:
      - SPRING_PROFILES_ACTIVE=prod
    deploy:
      replicas: 3
      resources:
        limits:
          cpus: '2'
          memory: 2G

  card-words-ai:
    restart: always
    deploy:
      replicas: 2
      resources:
        limits:
          cpus: '1'
          memory: 1G

  postgres:
    # Don't expose port in production
    ports: []
```

### **Usage:**

```bash
# Development
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d

# Production
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d

# Or use COMPOSE_FILE env
export COMPOSE_FILE=docker-compose.yml:docker-compose.dev.yml
docker-compose up -d
```

---

## 5. Recommendation Matrix

| Scenario | Approach | Reason |
|----------|----------|--------|
| **Microservices cần communicate** | ✅ Shared | Easy service discovery |
| **Shared database/redis** | ✅ Shared | Avoid duplication |
| **Development environment** | ✅ Shared + Dev override | Easy to start all |
| **Production deployment** | ✅ Shared + Prod override | Orchestration |
| **CI/CD pipeline** | ✅ Shared | Single command |
| **2 teams, 2 repos** | ⚠️ Separate | Team autonomy |
| **Services hoàn toàn độc lập** | ⚠️ Separate | No dependencies |
| **Different deployment times** | ⚠️ Separate | Independent releases |

---

## 6. Recommendation cho Bạn

### 🏆 **RECOMMENDED: Shared docker-compose.yml**

**Lý do:**

1. ✅ **card-words-api CẦN gọi card-words-ai**
   ```java
   // Spring Boot cần call AI service
   String aiUrl = "http://card-words-ai:8001/api/v1/review/smart";
   ```

2. ✅ **Shared database & redis**
   - Cả 2 services đều dùng PostgreSQL
   - Cả 2 services đều dùng Redis

3. ✅ **Development workflow đơn giản**
   ```bash
   docker-compose up -d  # Start all
   ```

4. ✅ **Production deployment dễ dàng**
   ```bash
   docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
   ```

5. ✅ **Monorepo structure**
   - Bạn đang dùng monorepo
   - Shared docker-compose phù hợp với monorepo

### 📁 **Recommended Structure:**

```
card-words-services/
├── docker-compose.yml              # ✅ Main (all services)
├── docker-compose.dev.yml          # ✅ Development overrides
├── docker-compose.prod.yml         # ✅ Production overrides
├── .env
├── .env.example
│
├── card-words/
│   ├── Dockerfile
│   └── ...
│
└── card-words-ai/
    ├── Dockerfile
    └── ...
```

### 🚀 **Usage:**

```bash
# Development
docker-compose up -d
# or
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d

# Production
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d

# Rebuild specific service
docker-compose up -d --build card-words-ai

# View logs
docker-compose logs -f card-words-api

# Stop all
docker-compose down
```

---

## 7. Migration Path

### **From Current (Separate) → Shared:**

```bash
# 1. Backup current files
cp card-words/docker-compose.yml card-words/docker-compose.yml.backup

# 2. Create shared docker-compose.yml at root
cat > docker-compose.yml << 'EOF'
# Merge both docker-compose files
version: '3.8'
services:
  postgres:    # From card-words
  redis:       # From card-words
  card-words-api:
  card-words-ai:
EOF

# 3. Remove old docker-compose files (optional)
# rm card-words/docker-compose.yml
# Keep them for reference if needed

# 4. Test
docker-compose up -d
docker-compose ps
docker-compose logs -f
```

---

## 8. Khi nào dùng Separate?

### ⚠️ **Chỉ dùng Separate khi:**

1. **2 services hoàn toàn độc lập**
   - Không cần communicate
   - Không share resources
   - Deploy riêng biệt

2. **2 teams, 2 repos riêng biệt**
   - card-words: repo A
   - card-words-ai: repo B
   - Không phải monorepo

3. **Different infrastructure**
   - card-words: AWS
   - card-words-ai: GCP
   - Khác cloud provider

### ❌ **KHÔNG dùng Separate nếu:**

- ✅ Monorepo structure
- ✅ Services cần communicate
- ✅ Shared database/redis
- ✅ Same deployment environment

---

## 9. Final Answer

### 🎯 **Cho dự án của bạn:**

**✅ SỬ DỤNG SHARED docker-compose.yml**

**Lý do:**
1. Monorepo structure
2. Services cần communicate (Spring Boot → Python AI)
3. Shared PostgreSQL & Redis
4. Development workflow đơn giản
5. Production deployment dễ dàng

**Structure:**
```
card-words-services/
├── docker-compose.yml              # ✅ CHUNG
├── docker-compose.dev.yml          # ✅ Dev overrides
├── docker-compose.prod.yml         # ✅ Prod overrides
├── .env
│
├── card-words/
│   └── Dockerfile
│
└── card-words-ai/
    └── Dockerfile
```

**Commands:**
```bash
# Development
docker-compose up -d

# Production
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

---

**Tác giả:** AI Assistant  
**Ngày tạo:** 2024-11-16  
**Phiên bản:** 1.0  
**Recommendation:** ✅ Shared docker-compose.yml
