# .env File Strategy: Shared vs Separate

## 1. So sánh 2 Approaches

### **Approach 1: Shared .env (RECOMMENDED)** ⭐

```
card-words-services/
├── .env                    # ✅ CHUNG cho cả 2 projects
├── .env.example
├── docker-compose.yml
│
├── card-words/
└── card-words-ai/
```

### **Approach 2: Separate .env**

```
card-words-services/
├── docker-compose.yml
│
├── card-words/
│   └── .env               # ❌ Riêng cho Spring Boot
│
└── card-words-ai/
    └── .env               # ❌ Riêng cho Python AI
```

---

## 2. Chi tiết Approach 1: Shared .env (RECOMMENDED)

### ✅ **Ưu điểm:**

#### 1. **Shared secrets dễ quản lý**
```bash
# .env (root)
JWT_SECRET=same-secret-for-both-services  # ✅ Chỉ define 1 lần
POSTGRES_PASSWORD=shared-password         # ✅ Chỉ define 1 lần
```

#### 2. **Consistency**
```bash
# Cả 2 services dùng cùng database credentials
POSTGRES_USER=postgres
POSTGRES_PASSWORD=secret
POSTGRES_DB=card_words

# Không lo conflict hoặc mismatch
```

#### 3. **Đơn giản hơn**
```bash
# Chỉ cần edit 1 file
nano .env

# Thay vì
nano card-words/.env
nano card-words-ai/.env
```

#### 4. **Docker Compose tự động load**
```yaml
# docker-compose.yml
services:
  card-words-api:
    env_file:
      - .env  # ✅ Auto load từ root
    environment:
      - POSTGRES_HOST=postgres
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}  # ✅ Từ .env
```

#### 5. **Dễ dàng override cho từng service**
```yaml
# docker-compose.yml
services:
  card-words-api:
    env_file: .env
    environment:
      - SERVICE_NAME=card-words-api  # ✅ Override riêng

  card-words-ai:
    env_file: .env
    environment:
      - SERVICE_NAME=card-words-ai   # ✅ Override riêng
      - LOG_LEVEL=DEBUG              # ✅ Riêng cho AI
```

### ❌ **Nhược điểm:**

1. **File lớn hơn** - Chứa variables cho cả 2 services
2. **Có thể confusing** - Cần comments rõ ràng
3. **Security risk nhỏ** - Nếu 1 service bị hack, có thể thấy secrets của service khác

### 🎯 **Use Cases:**

✅ **Monorepo structure**  
✅ **Shared infrastructure** (DB, Redis, JWT)  
✅ **Development environment**  
✅ **Small to medium teams**  
✅ **Services cần share secrets**  

---

## 3. Chi tiết Approach 2: Separate .env

### ✅ **Ưu điểm:**

#### 1. **Separation of concerns**
```bash
# card-words/.env - Chỉ Spring Boot variables
POSTGRES_HOST=postgres
MAIL_USERNAME=spring@example.com

# card-words-ai/.env - Chỉ Python AI variables
MODEL_PATH=/app/models/lightgbm.txt
LOG_LEVEL=DEBUG
```

#### 2. **Security isolation**
```bash
# card-words/.env
GOOGLE_OAUTH_CLIENT_SECRET=secret1  # Chỉ Spring Boot biết

# card-words-ai/.env
ML_API_KEY=secret2                  # Chỉ Python AI biết
```

#### 3. **Team autonomy**
- Team Spring Boot quản lý file riêng
- Team Python AI quản lý file riêng
- Không conflict khi commit

### ❌ **Nhược điểm:**

#### 1. **Duplicate shared variables**
```bash
# card-words/.env
POSTGRES_PASSWORD=secret123
JWT_SECRET=shared-secret

# card-words-ai/.env
POSTGRES_PASSWORD=secret123  # ❌ DUPLICATE!
JWT_SECRET=shared-secret      # ❌ DUPLICATE!
```

#### 2. **Sync issues**
```bash
# Nếu đổi password trong card-words/.env
POSTGRES_PASSWORD=new-password

# Phải nhớ đổi trong card-words-ai/.env
POSTGRES_PASSWORD=new-password  # ❌ Dễ quên!
```

#### 3. **Docker Compose phức tạp hơn**
```yaml
# docker-compose.yml
services:
  card-words-api:
    env_file:
      - ./card-words/.env  # ❌ Phải specify path

  card-words-ai:
    env_file:
      - ./card-words-ai/.env  # ❌ Phải specify path
```

### 🎯 **Use Cases:**

✅ **Microservices hoàn toàn độc lập**  
✅ **Different teams, different repos**  
✅ **High security requirements**  
✅ **Services không share secrets**  

---

## 4. Hybrid Approach: Best of Both Worlds

### **Structure:**

```
card-words-services/
├── .env                        # ✅ Shared variables
├── .env.card-words             # ⚠️ Spring Boot specific
├── .env.card-words-ai          # ⚠️ Python AI specific
├── docker-compose.yml
│
├── card-words/
└── card-words-ai/
```

### **Shared .env (root):**

```bash
# .env - Shared variables only

# ============================================
# SHARED INFRASTRUCTURE
# ============================================

# Database (shared)
POSTGRES_USER=postgres
POSTGRES_PASSWORD=shared_secret_password
POSTGRES_DB=card_words

# Redis (shared)
REDIS_HOST=redis
REDIS_PORT=6379

# JWT (shared - MUST be same)
JWT_SECRET=shared-jwt-secret-key-for-both-services

# ============================================
# SHARED CONFIGURATION
# ============================================

# Environment
ENVIRONMENT=development

# PgAdmin
PGADMIN_DEFAULT_EMAIL=admin@cardwords.com
PGADMIN_DEFAULT_PASSWORD=admin
PGADMIN_PORT=5050
```

### **Service-specific .env files:**

```bash
# .env.card-words - Spring Boot specific
SERVER_PORT=8080

# Email (only Spring Boot uses)
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=spring@example.com
MAIL_PASSWORD=spring-mail-password

# Google OAuth (only Spring Boot uses)
GOOGLE_OAUTH_CLIENT_ID=spring-client-id
GOOGLE_OAUTH_CLIENT_SECRET=spring-client-secret
GOOGLE_OAUTH_REDIRECT_URI=http://localhost:8080/callback

# Firebase (only Spring Boot uses)
FIREBASE_STORAGE_BUCKET=spring-bucket.appspot.com

# Activation
ACTIVATION_EXPIRED_TIME=86400000
ACTIVATION_RESEND_INTERVAL=300000
```

```bash
# .env.card-words-ai - Python AI specific
API_PORT=8001

# Model paths (only AI uses)
MODEL_PATH=/app/models/lightgbm_vocab_predictor.txt
FEATURE_NAMES_PATH=/app/models/feature_names.json

# ML Configuration (only AI uses)
KMEANS_N_CLUSTERS=4
KMEANS_RANDOM_STATE=42

# Logging (only AI uses)
LOG_LEVEL=DEBUG
```

### **Docker Compose:**

```yaml
# docker-compose.yml
version: '3.8'

services:
  card-words-api:
    env_file:
      - .env                    # ✅ Load shared first
      - .env.card-words         # ✅ Then load specific
    environment:
      - POSTGRES_HOST=postgres  # ✅ Override if needed

  card-words-ai:
    env_file:
      - .env                    # ✅ Load shared first
      - .env.card-words-ai      # ✅ Then load specific
    environment:
      - POSTGRES_HOST=postgres  # ✅ Override if needed
```

### **Ưu điểm Hybrid:**

✅ **Shared variables** ở 1 chỗ (không duplicate)  
✅ **Service-specific variables** tách biệt  
✅ **Easy to manage** shared secrets  
✅ **Clear separation** of concerns  
✅ **Override flexibility**  

### **Nhược điểm Hybrid:**

❌ **3 files** thay vì 1  
❌ **Phức tạp hơn** một chút  
❌ **Phải nhớ** load order  

---

## 5. Recommendation Matrix

| Scenario | Approach | Reason |
|----------|----------|--------|
| **Monorepo, shared secrets** | ✅ Shared | Simplicity |
| **Development environment** | ✅ Shared | Easy setup |
| **Small team** | ✅ Shared | Less overhead |
| **Shared DB/Redis/JWT** | ✅ Shared | No duplication |
| **2 teams, 2 repos** | ⚠️ Separate | Team autonomy |
| **High security needs** | ⚠️ Separate | Isolation |
| **Mix of shared + specific** | ⚠️ Hybrid | Best of both |

---

## 6. Recommendation cho Bạn

### 🏆 **RECOMMENDED: Shared .env**

**Lý do:**

1. ✅ **Monorepo structure** - Bạn đang dùng monorepo
2. ✅ **Shared secrets** - JWT_SECRET, POSTGRES_PASSWORD phải giống nhau
3. ✅ **Shared infrastructure** - Cùng DB, Redis
4. ✅ **Development simplicity** - Chỉ edit 1 file
5. ✅ **Small team** - Không cần phức tạp hóa

### 📁 **Structure:**

```
card-words-services/
├── .env                    # ✅ CHUNG
├── .env.example            # ✅ Template
├── docker-compose.yml
│
├── card-words/
│   └── Dockerfile
│
└── card-words-ai/
    └── Dockerfile
```

### 📝 **Shared .env Content:**

```bash
# ============================================
# SHARED INFRASTRUCTURE
# ============================================

# Database
POSTGRES_USER=postgres
POSTGRES_PASSWORD=your_password
POSTGRES_DB=card_words

# Redis
REDIS_HOST=redis
REDIS_PORT=6379

# JWT (MUST be same for both services)
JWT_SECRET=your-jwt-secret-key

# ============================================
# SPRING BOOT SPECIFIC
# ============================================

# Email
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-app-password

# Google OAuth
GOOGLE_OAUTH_CLIENT_ID=your-client-id
GOOGLE_OAUTH_CLIENT_SECRET=your-secret

# Firebase
FIREBASE_STORAGE_BUCKET=your-bucket.appspot.com

# ============================================
# PYTHON AI SPECIFIC
# ============================================

# Model paths
MODEL_PATH=/app/models/lightgbm_vocab_predictor.txt

# Logging
LOG_LEVEL=INFO
```

### 🎯 **Docker Compose:**

```yaml
# docker-compose.yml
version: '3.8'

services:
  card-words-api:
    env_file: .env  # ✅ Load từ root
    environment:
      - POSTGRES_HOST=postgres
      - REDIS_HOST=redis

  card-words-ai:
    env_file: .env  # ✅ Load từ root
    environment:
      - POSTGRES_HOST=postgres
      - REDIS_HOST=redis
```

---

## 7. Khi nào dùng Separate?

### ⚠️ **Chỉ dùng Separate khi:**

1. **2 repos riêng biệt**
   - card-words: repo A
   - card-words-ai: repo B

2. **Different teams**
   - Team A quản lý Spring Boot
   - Team B quản lý Python AI
   - Không muốn share secrets

3. **High security**
   - Secrets phải isolated
   - Compliance requirements

4. **No shared variables**
   - Không có JWT_SECRET chung
   - Không có DB password chung

### ❌ **KHÔNG dùng Separate nếu:**

- ✅ Monorepo
- ✅ Same team
- ✅ Shared secrets (JWT, DB password)
- ✅ Development environment

---

## 8. Implementation Guide

### **Option 1: Shared .env (Recommended)**

```bash
# 1. Create .env at root
cat > .env << 'EOF'
# Shared variables
POSTGRES_PASSWORD=secret
JWT_SECRET=shared-jwt-key
# ... more variables
EOF

# 2. Docker Compose auto-loads
docker-compose up -d
```

### **Option 2: Hybrid (Advanced)**

```bash
# 1. Create shared .env
cat > .env << 'EOF'
POSTGRES_PASSWORD=secret
JWT_SECRET=shared-jwt-key
EOF

# 2. Create service-specific
cat > .env.card-words << 'EOF'
MAIL_USERNAME=spring@example.com
EOF

cat > .env.card-words-ai << 'EOF'
MODEL_PATH=/app/models/model.txt
EOF

# 3. Update docker-compose.yml
services:
  card-words-api:
    env_file:
      - .env
      - .env.card-words
```

---

## 9. Best Practices

### ✅ **DO:**

1. **Use .env.example** as template
```bash
cp .env.example .env
```

2. **Add .env to .gitignore**
```bash
echo ".env" >> .gitignore
```

3. **Document variables**
```bash
# .env
# JWT Secret (MUST be same for both services)
JWT_SECRET=your-secret
```

4. **Use strong secrets**
```bash
# Generate JWT secret
openssl rand -base64 32
```

5. **Validate required variables**
```bash
# In docker-compose.yml
environment:
  - POSTGRES_PASSWORD=${POSTGRES_PASSWORD:?POSTGRES_PASSWORD is required}
```

### ❌ **DON'T:**

1. **Commit .env to git**
2. **Use weak secrets**
3. **Hardcode secrets in docker-compose.yml**
4. **Forget to update .env.example**

---

## 10. Final Answer

### 🎯 **Cho dự án của bạn:**

**✅ SỬ DỤNG SHARED .env**

**Lý do:**
1. Monorepo structure
2. Shared secrets (JWT, DB password)
3. Same team
4. Development simplicity
5. No security isolation needed

**Structure:**
```
card-words-services/
├── .env                    # ✅ CHUNG
├── .env.example
├── docker-compose.yml
```

**Usage:**
```bash
# Edit .env
nano .env

# Start all
docker-compose up -d
```

---

**Tác giả:** AI Assistant  
**Ngày tạo:** 2024-11-16  
**Recommendation:** ✅ Shared .env at root
