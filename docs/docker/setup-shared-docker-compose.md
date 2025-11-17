# Setup Shared Docker Compose - Step by Step Guide

## 🎯 Mục tiêu

Tạo **1 file docker-compose.yml chung** cho cả card-words và card-words-ai

---

## 📋 Checklist

- [ ] Tạo docker-compose.yml ở root
- [ ] Tạo docker-compose.dev.yml
- [ ] Tạo docker-compose.prod.yml
- [ ] Tạo .env
- [ ] Tạo Dockerfile cho card-words-ai
- [ ] Tạo .dockerignore files
- [ ] Test build
- [ ] Test run

---

## 🚀 Step 1: Tạo Root docker-compose.yml

### **Vị trí:** `card-words-services/docker-compose.yml`

```yaml
version: '3.8'

services:
    # ============================================
    # DATABASE SERVICES
    # ============================================
    
    postgres:
        container_name: card-words-postgres
        image: postgres:16-alpine
        environment:
            - POSTGRES_USER=${POSTGRES_USER:-postgres}
            - POSTGRES_PASSWORD=${POSTGRES_PASSWORD:-postgres}
            - POSTGRES_DB=${POSTGRES_DB:-card_words}
        ports:
            - '5433:5432'
        volumes:
            - postgres_data:/var/lib/postgresql/data
        networks:
            - card-words-network
        healthcheck:
            test: ['CMD-SHELL', 'pg_isready -U ${POSTGRES_USER:-postgres}']
            interval: 10s
            timeout: 5s
            retries: 5
        restart: unless-stopped

    pgadmin:
        container_name: card-words-pgadmin
        image: dpage/pgadmin4:latest
        environment:
            - PGADMIN_DEFAULT_EMAIL=${PGADMIN_DEFAULT_EMAIL:-admin@cardwords.com}
            - PGADMIN_DEFAULT_PASSWORD=${PGADMIN_DEFAULT_PASSWORD:-admin}
        ports:
            - '${PGADMIN_PORT:-5050}:80'
        volumes:
            - pgadmin_data:/root/.pgadmin
        depends_on:
            postgres:
                condition: service_healthy
        networks:
            - card-words-network
        restart: unless-stopped

    # ============================================
    # CACHE SERVICES
    # ============================================
    
    redis:
        image: redis:7-alpine
        container_name: card-words-redis
        ports:
            - '6379:6379'
        volumes:
            - redis_data:/data
        networks:
            - card-words-network
        healthcheck:
            test: ['CMD', 'redis-cli', 'ping']
            interval: 10s
            timeout: 3s
            retries: 5
        command: redis-server --appendonly yes
        restart: unless-stopped

    redisinsight:
        image: redis/redisinsight:latest
        container_name: card-words-redisinsight
        ports:
            - '5540:5540'
        volumes:
            - redisinsight_data:/data
        depends_on:
            - redis
        networks:
            - card-words-network
        restart: unless-stopped

    # ============================================
    # APPLICATION SERVICES
    # ============================================
    
    # Spring Boot Backend API
    card-words-api:
        build:
            context: ./card-words
            dockerfile: Dockerfile
        container_name: card-words-api
        environment:
            # Server
            - SERVER_PORT=8080
            
            # Database
            - POSTGRES_HOST=postgres
            - POSTGRES_PORT=5432
            - POSTGRES_DB=${POSTGRES_DB:-card_words}
            - POSTGRES_USER=${POSTGRES_USER:-postgres}
            - POSTGRES_PASSWORD=${POSTGRES_PASSWORD:-postgres}
            
            # Redis
            - REDIS_HOST=redis
            - REDIS_PORT=6379
            - REDIS_DB=0
            - REDIS_PASSWORD=
            - REDIS_TIMEOUT=60000
            
            # JWT
            - JWT_SECRET=${JWT_SECRET}
            - JWT_EXPIRATION_TIME=${JWT_EXPIRATION_TIME:-86400000}
            - JWT_REFRESH_TOKEN_EXPIRATION=${JWT_REFRESH_TOKEN_EXPIRATION:-604800000}
            
            # Email
            - MAIL_HOST=${MAIL_HOST:-smtp.gmail.com}
            - MAIL_PORT=${MAIL_PORT:-587}
            - MAIL_USERNAME=${MAIL_USERNAME}
            - MAIL_PASSWORD=${MAIL_PASSWORD}
            
            # Google OAuth2
            - GOOGLE_OAUTH_CLIENT_ID=${GOOGLE_OAUTH_CLIENT_ID}
            - GOOGLE_OAUTH_CLIENT_SECRET=${GOOGLE_OAUTH_CLIENT_SECRET}
            - GOOGLE_OAUTH_REDIRECT_URI=${GOOGLE_OAUTH_REDIRECT_URI:-http://localhost:8080/api/v1/auth/google/callback}
            
            # Activation
            - ACTIVATION_EXPIRED_TIME=${ACTIVATION_EXPIRED_TIME:-86400000}
            - ACTIVATION_RESEND_INTERVAL=${ACTIVATION_RESEND_INTERVAL:-300000}
            
            # Firebase
            - FIREBASE_STORAGE_BUCKET=${FIREBASE_STORAGE_BUCKET}
            - FIREBASE_SERVICE_ACCOUNT_PATH=classpath
            
            # AI Service Integration
            - AI_SERVICE_URL=http://card-words-ai:8001
            
        ports:
            - '8080:8080'
        depends_on:
            postgres:
                condition: service_healthy
            redis:
                condition: service_healthy
            card-words-ai:
                condition: service_started
        networks:
            - card-words-network
        restart: unless-stopped
        healthcheck:
            test: ['CMD', 'wget', '--no-verbose', '--tries=1', '--spider', 'http://localhost:8080/actuator/health']
            interval: 30s
            timeout: 10s
            retries: 3
            start_period: 60s

    # Python AI Service (LightGBM)
    card-words-ai:
        build:
            context: ./card-words-ai
            dockerfile: Dockerfile
        container_name: card-words-ai
        environment:
            # Database (read-only for ML)
            - DATABASE_URL=postgresql://${POSTGRES_USER:-postgres}:${POSTGRES_PASSWORD:-postgres}@postgres:5432/${POSTGRES_DB:-card_words}
            
            # Redis (separate DB for AI)
            - REDIS_URL=redis://redis:6379/1
            
            # Model Configuration
            - MODEL_PATH=/app/models/lightgbm_vocab_predictor.txt
            - FEATURE_NAMES_PATH=/app/models/feature_names.json
            
            # API Configuration
            - API_HOST=0.0.0.0
            - API_PORT=8001
            - LOG_LEVEL=${LOG_LEVEL:-INFO}
            
            # JWT (for auth with Spring Boot)
            - JWT_SECRET=${JWT_SECRET}
            
        ports:
            - '8001:8001'
        volumes:
            - ./card-words-ai/models:/app/models
        depends_on:
            postgres:
                condition: service_healthy
            redis:
                condition: service_healthy
        networks:
            - card-words-network
        restart: unless-stopped
        healthcheck:
            test: ['CMD', 'curl', '-f', 'http://localhost:8001/health']
            interval: 30s
            timeout: 10s
            retries: 3
            start_period: 40s

volumes:
    postgres_data:
        driver: local
    pgadmin_data:
        driver: local
    redis_data:
        driver: local
    redisinsight_data:
        driver: local

networks:
    card-words-network:
        driver: bridge
```

---

## 🔧 Step 2: Tạo docker-compose.dev.yml

### **Vị trí:** `card-words-services/docker-compose.dev.yml`

```yaml
version: '3.8'

# Development overrides
services:
    card-words-api:
        environment:
            - SPRING_PROFILES_ACTIVE=dev
            - DEBUG=true
        # Hot reload (optional)
        # volumes:
        #   - ./card-words/src:/app/src

    card-words-ai:
        environment:
            - LOG_LEVEL=DEBUG
            - ENVIRONMENT=development
        # Hot reload
        command: uvicorn app.main:app --reload --host 0.0.0.0 --port 8001
        volumes:
            - ./card-words-ai/app:/app/app
            - ./card-words-ai/models:/app/models
```

---

## 🚀 Step 3: Tạo docker-compose.prod.yml

### **Vị trí:** `card-words-services/docker-compose.prod.yml`

```yaml
version: '3.8'

# Production overrides
services:
    postgres:
        # Don't expose port in production
        ports: []
        volumes:
            - /var/lib/postgresql/data:/var/lib/postgresql/data

    pgadmin:
        # Disable in production
        profiles:
            - debug

    redisinsight:
        # Disable in production
        profiles:
            - debug

    card-words-api:
        environment:
            - SPRING_PROFILES_ACTIVE=prod
        restart: always
        deploy:
            replicas: 2
            resources:
                limits:
                    cpus: '2'
                    memory: 2G
                reservations:
                    cpus: '1'
                    memory: 1G
        logging:
            driver: "json-file"
            options:
                max-size: "10m"
                max-file: "3"

    card-words-ai:
        environment:
            - LOG_LEVEL=INFO
            - ENVIRONMENT=production
        restart: always
        deploy:
            replicas: 2
            resources:
                limits:
                    cpus: '1'
                    memory: 1G
                reservations:
                    cpus: '0.5'
                    memory: 512M
        logging:
            driver: "json-file"
            options:
                max-size: "10m"
                max-file: "3"
```

---

## 📝 Step 4: Tạo .env

### **Vị trí:** `card-words-services/.env`

```bash
# ============================================
# DATABASE CONFIGURATION
# ============================================
POSTGRES_DB=card_words
POSTGRES_USER=postgres
POSTGRES_PASSWORD=your_strong_password_here

# ============================================
# REDIS CONFIGURATION
# ============================================
REDIS_HOST=redis
REDIS_PORT=6379
REDIS_DB=0
REDIS_PASSWORD=
REDIS_TIMEOUT=60000

# ============================================
# JWT CONFIGURATION
# ============================================
JWT_SECRET=your-super-secret-jwt-key-at-least-256-bits-long-change-this
JWT_EXPIRATION_TIME=86400000
JWT_REFRESH_TOKEN_EXPIRATION=604800000

# ============================================
# EMAIL CONFIGURATION
# ============================================
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-gmail-app-password

# ============================================
# GOOGLE OAUTH2
# ============================================
GOOGLE_OAUTH_CLIENT_ID=your-client-id.apps.googleusercontent.com
GOOGLE_OAUTH_CLIENT_SECRET=your-client-secret
GOOGLE_OAUTH_REDIRECT_URI=http://localhost:8080/api/v1/auth/google/callback

# ============================================
# ACTIVATION
# ============================================
ACTIVATION_EXPIRED_TIME=86400000
ACTIVATION_RESEND_INTERVAL=300000

# ============================================
# FIREBASE
# ============================================
FIREBASE_STORAGE_BUCKET=your-firebase-bucket.appspot.com

# ============================================
# PGADMIN
# ============================================
PGADMIN_DEFAULT_EMAIL=admin@cardwords.com
PGADMIN_DEFAULT_PASSWORD=admin
PGADMIN_PORT=5050

# ============================================
# AI SERVICE
# ============================================
LOG_LEVEL=INFO
```

---

## 🐳 Step 5: Tạo Dockerfile cho card-words-ai

### **Vị trí:** `card-words-services/card-words-ai/Dockerfile`

```dockerfile
FROM python:3.11-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    libgomp1 \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN pip install poetry==1.7.0

# Copy dependency files
COPY pyproject.toml poetry.lock* ./

# Install dependencies
RUN poetry config virtualenvs.create false \
    && poetry install --no-dev --no-interaction --no-ansi

# Copy application code
COPY app/ ./app/
COPY models/ ./models/

# Create non-root user
RUN useradd -m -u 1000 appuser && chown -R appuser:appuser /app
USER appuser

# Expose port
EXPOSE 8001

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:8001/health || exit 1

# Run application
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8001"]
```

---

## 📄 Step 6: Tạo .dockerignore files

### **card-words/.dockerignore:**

```
target/
.mvn/
mvnw
mvnw.cmd
.git/
.gitignore
*.md
.env*
.idea/
*.iml
.vscode/
*.log
```

### **card-words-ai/.dockerignore:**

```
__pycache__/
*.pyc
*.pyo
*.pyd
.Python
.venv/
venv/
.pytest_cache/
.coverage
htmlcov/
.git/
.gitignore
*.md
.env*
.vscode/
.idea/
notebooks/
tests/
docs/
*.log
```

---

## ✅ Step 7: Build và Test

### **7.1. Build all services:**

```bash
cd card-words-services

# Build all
docker-compose build

# Or build specific service
docker-compose build card-words-api
docker-compose build card-words-ai
```

### **7.2. Start services:**

```bash
# Development
docker-compose up -d

# Or with dev overrides
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d

# View logs
docker-compose logs -f
```

### **7.3. Check status:**

```bash
# List containers
docker-compose ps

# Expected output:
# NAME                  STATUS              PORTS
# card-words-api        Up 2 minutes        0.0.0.0:8080->8080/tcp
# card-words-ai         Up 2 minutes        0.0.0.0:8001->8001/tcp
# card-words-postgres   Up 2 minutes        0.0.0.0:5433->5432/tcp
# card-words-redis      Up 2 minutes        0.0.0.0:6379->6379/tcp
```

### **7.4. Test health checks:**

```bash
# Spring Boot
curl http://localhost:8080/actuator/health
# Expected: {"status":"UP"}

# Python AI
curl http://localhost:8001/health
# Expected: {"status":"healthy"}

# PostgreSQL
docker-compose exec postgres pg_isready -U postgres
# Expected: postgres:5432 - accepting connections

# Redis
docker-compose exec redis redis-cli ping
# Expected: PONG
```

### **7.5. Test service communication:**

```bash
# Test AI service directly
curl "http://localhost:8001/api/v1/review/smart?user_id=test&limit=10"

# Test Spring Boot calling AI service
curl "http://localhost:8080/api/v1/review/smart-ml?userId=test&limit=10"
```

---

## 🔧 Step 8: Common Commands

```bash
# Start all services
docker-compose up -d

# Start with dev config
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d

# Stop all services
docker-compose down

# Rebuild and restart specific service
docker-compose up -d --build card-words-ai

# View logs
docker-compose logs -f
docker-compose logs -f card-words-api
docker-compose logs -f card-words-ai

# Execute command in container
docker-compose exec card-words-api bash
docker-compose exec postgres psql -U postgres -d card_words

# Scale service
docker-compose up -d --scale card-words-api=3

# Remove everything (including volumes)
docker-compose down -v
```

---

## 🎯 Final Structure

```
card-words-services/
├── docker-compose.yml              ✅ Main config
├── docker-compose.dev.yml          ✅ Dev overrides
├── docker-compose.prod.yml         ✅ Prod overrides
├── .env                            ✅ Environment variables
├── .env.example                    ✅ Template
├── .gitignore
├── README.md
│
├── card-words/
│   ├── src/
│   ├── pom.xml
│   ├── Dockerfile                  ✅ Existing
│   └── .dockerignore               ✅ New
│
└── card-words-ai/
    ├── app/
    ├── models/
    ├── pyproject.toml
    ├── Dockerfile                  ✅ New
    └── .dockerignore               ✅ New
```

---

## 🚀 Quick Setup Script

```bash
#!/bin/bash
# setup-docker.sh

echo "🚀 Setting up shared Docker Compose..."

# Create docker-compose.yml
echo "📝 Creating docker-compose.yml..."
# (Copy content from Step 1)

# Create docker-compose.dev.yml
echo "📝 Creating docker-compose.dev.yml..."
# (Copy content from Step 2)

# Create docker-compose.prod.yml
echo "📝 Creating docker-compose.prod.yml..."
# (Copy content from Step 3)

# Create .env
echo "📝 Creating .env..."
# (Copy content from Step 4)

# Create Dockerfile for card-words-ai
echo "📝 Creating Dockerfile for card-words-ai..."
# (Copy content from Step 5)

# Create .dockerignore files
echo "📝 Creating .dockerignore files..."
# (Copy content from Step 6)

echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Edit .env with your actual values"
echo "2. Run: docker-compose build"
echo "3. Run: docker-compose up -d"
echo "4. Test: curl http://localhost:8080/actuator/health"
```

---

## ✅ Checklist Hoàn thành

- [ ] ✅ docker-compose.yml created
- [ ] ✅ docker-compose.dev.yml created
- [ ] ✅ docker-compose.prod.yml created
- [ ] ✅ .env created and configured
- [ ] ✅ Dockerfile for card-words-ai created
- [ ] ✅ .dockerignore files created
- [ ] ✅ Build successful
- [ ] ✅ All services running
- [ ] ✅ Health checks passing
- [ ] ✅ Service communication working

---

**Tác giả:** AI Assistant  
**Ngày tạo:** 2024-11-16  
**Status:** Ready to implement! 🚀
