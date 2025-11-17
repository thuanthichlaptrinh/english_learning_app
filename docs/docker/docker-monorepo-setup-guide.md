# Docker Setup Guide for Card Words Services Monorepo

## 1. Tổng quan

### 1.1. Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Docker Network                            │
│                  (card-words-network)                        │
│                                                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │ card-words   │  │ card-words   │  │  PostgreSQL  │     │
│  │     API      │◄─┤      AI      │◄─┤   Database   │     │
│  │ (Spring Boot)│  │   (FastAPI)  │  │              │     │
│  │   :8080      │  │    :8001     │  │    :5432     │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
│         │                  │                  │             │
│         └──────────────────┴──────────────────┘             │
│                            │                                │
│                    ┌───────▼────────┐                       │
│                    │     Redis      │                       │
│                    │     Cache      │                       │
│                    │     :6379      │                       │
│                    └────────────────┘                       │
└─────────────────────────────────────────────────────────────┘
```

### 1.2. Services

| Service | Port | Description |
|---------|------|-------------|
| **card-words-api** | 8080 | Spring Boot REST API |
| **card-words-ai** | 8001 | Python FastAPI ML Service |
| **postgres** | 5433→5432 | PostgreSQL Database |
| **redis** | 6379 | Redis Cache |
| **pgadmin** | 5050 | PostgreSQL GUI |
| **redisinsight** | 5540 | Redis GUI |

---

## 2. Prerequisites

### 2.1. Install Docker

```bash
# Windows
# Download Docker Desktop: https://www.docker.com/products/docker-desktop

# macOS
brew install --cask docker

# Linux (Ubuntu)
sudo apt-get update
sudo apt-get install docker.io docker-compose
sudo systemctl start docker
sudo systemctl enable docker
```

### 2.2. Verify Installation

```bash
docker --version
# Docker version 24.0.0+

docker-compose --version
# Docker Compose version v2.20.0+
```

---

## 3. Project Structure

```
card-words-services/
├── card-words/                    # Spring Boot Backend
│   ├── src/
│   ├── pom.xml
│   ├── Dockerfile                 # ✅ Existing
│   └── .env.docker.example
│
├── card-words-ai/                 # Python AI Service
│   ├── app/
│   ├── models/
│   ├── pyproject.toml
│   └── Dockerfile                 # ⚠️ Need to create
│
├── docker-compose.yml             # ✅ Main orchestration
├── .env                           # ⚠️ Copy from .env.example
├── .env.example                   # ✅ Template
└── README.md
```

---

## 4. Setup Steps

### 4.1. Create Dockerfile for card-words-ai

```dockerfile
# card-words-ai/Dockerfile
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

### 4.2. Create .env file

```bash
# Copy example file
cp .env.monorepo.example .env

# Edit with your values
nano .env  # or use your favorite editor
```

**Important variables to change:**
```bash
# Database
POSTGRES_PASSWORD=your_strong_password

# JWT
JWT_SECRET=generate_with_openssl_rand_base64_32

# Email (if using)
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-app-password

# Google OAuth (if using)
GOOGLE_OAUTH_CLIENT_ID=your-client-id
GOOGLE_OAUTH_CLIENT_SECRET=your-secret
```

### 4.3. Create .dockerignore files

**card-words/.dockerignore:**
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
```

**card-words-ai/.dockerignore:**
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
```

---

## 5. Build and Run

### 5.1. Build Images

```bash
# Build all services
docker-compose build

# Build specific service
docker-compose build card-words-api
docker-compose build card-words-ai

# Build with no cache (if needed)
docker-compose build --no-cache
```

### 5.2. Start Services

```bash
# Start all services
docker-compose up -d

# Start specific services
docker-compose up -d postgres redis
docker-compose up -d card-words-api
docker-compose up -d card-words-ai

# Start with logs
docker-compose up
```

### 5.3. Check Status

```bash
# List running containers
docker-compose ps

# Expected output:
# NAME                  STATUS              PORTS
# card-words-api        Up 2 minutes        0.0.0.0:8080->8080/tcp
# card-words-ai         Up 2 minutes        0.0.0.0:8001->8001/tcp
# card-words-postgres   Up 2 minutes        0.0.0.0:5433->5432/tcp
# card-words-redis      Up 2 minutes        0.0.0.0:6379->6379/tcp
# card-words-pgadmin    Up 2 minutes        0.0.0.0:5050->80/tcp
# card-words-redisinsight Up 2 minutes      0.0.0.0:5540->5540/tcp
```

### 5.4. View Logs

```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f card-words-api
docker-compose logs -f card-words-ai

# Last 100 lines
docker-compose logs --tail=100 card-words-api
```

---

## 6. Testing

### 6.1. Health Checks

```bash
# Spring Boot API
curl http://localhost:8080/actuator/health
# Expected: {"status":"UP"}

# Python AI Service
curl http://localhost:8001/health
# Expected: {"status":"healthy"}

# PostgreSQL
docker-compose exec postgres pg_isready -U postgres
# Expected: postgres:5432 - accepting connections

# Redis
docker-compose exec redis redis-cli ping
# Expected: PONG
```

### 6.2. API Testing

```bash
# Test Spring Boot API
curl http://localhost:8080/api/v1/health

# Test AI Service
curl "http://localhost:8001/api/v1/review/smart?user_id=test&limit=10"

# Test integration (Spring Boot → AI Service)
curl http://localhost:8080/api/v1/review/smart-ml?userId=test&limit=10
```

### 6.3. Database Connection

```bash
# Connect to PostgreSQL
docker-compose exec postgres psql -U postgres -d card_words

# Run SQL query
docker-compose exec postgres psql -U postgres -d card_words -c "SELECT COUNT(*) FROM users;"

# Or use PgAdmin
# Open: http://localhost:5050
# Login: admin@cardwords.com / admin
```

---

## 7. Development Workflow

### 7.1. Hot Reload (Development)

**For Spring Boot:**
```bash
# Stop container
docker-compose stop card-words-api

# Run locally with hot reload
cd card-words
./mvnw spring-boot:run
```

**For Python AI:**
```bash
# Stop container
docker-compose stop card-words-ai

# Run locally with hot reload
cd card-words-ai
poetry run uvicorn app.main:app --reload --port 8001
```

### 7.2. Rebuild After Code Changes

```bash
# Rebuild and restart specific service
docker-compose up -d --build card-words-api
docker-compose up -d --build card-words-ai

# Or rebuild all
docker-compose up -d --build
```

### 7.3. Update Dependencies

**Spring Boot:**
```bash
# Update pom.xml
# Rebuild image
docker-compose build card-words-api
docker-compose up -d card-words-api
```

**Python AI:**
```bash
# Update pyproject.toml
# Rebuild image
docker-compose build card-words-ai
docker-compose up -d card-words-ai
```

---

## 8. Database Management

### 8.1. Backup Database

```bash
# Backup to file
docker-compose exec postgres pg_dump -U postgres card_words > backup.sql

# Backup with timestamp
docker-compose exec postgres pg_dump -U postgres card_words > backup_$(date +%Y%m%d_%H%M%S).sql
```

### 8.2. Restore Database

```bash
# Restore from file
docker-compose exec -T postgres psql -U postgres card_words < backup.sql
```

### 8.3. Reset Database

```bash
# Drop and recreate
docker-compose exec postgres psql -U postgres -c "DROP DATABASE IF EXISTS card_words;"
docker-compose exec postgres psql -U postgres -c "CREATE DATABASE card_words;"

# Restart Spring Boot to run Flyway migrations
docker-compose restart card-words-api
```

---

## 9. Troubleshooting

### 9.1. Port Already in Use

```bash
# Check what's using the port
# Windows
netstat -ano | findstr :8080

# Linux/Mac
lsof -i :8080

# Kill the process or change port in docker-compose.yml
ports:
  - '8081:8080'  # Use different external port
```

### 9.2. Container Won't Start

```bash
# Check logs
docker-compose logs card-words-api

# Check container status
docker-compose ps

# Restart container
docker-compose restart card-words-api

# Remove and recreate
docker-compose rm -f card-words-api
docker-compose up -d card-words-api
```

### 9.3. Database Connection Failed

```bash
# Check if postgres is healthy
docker-compose ps postgres

# Check postgres logs
docker-compose logs postgres

# Test connection
docker-compose exec postgres psql -U postgres -c "SELECT 1;"

# Verify environment variables
docker-compose exec card-words-api env | grep POSTGRES
```

### 9.4. Out of Memory

```bash
# Check Docker resources
docker stats

# Increase Docker memory limit
# Docker Desktop → Settings → Resources → Memory

# Or add to docker-compose.yml
services:
  card-words-api:
    mem_limit: 2g
    mem_reservation: 1g
```

---

## 10. Production Deployment

### 10.1. Environment-Specific Configs

```bash
# Create production env file
cp .env.example .env.prod

# Edit production values
nano .env.prod

# Use production config
docker-compose --env-file .env.prod up -d
```

### 10.2. Security Best Practices

```yaml
# docker-compose.prod.yml
services:
  card-words-api:
    environment:
      - SPRING_PROFILES_ACTIVE=prod
    restart: always
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
  
  postgres:
    # Don't expose port in production
    # ports:
    #   - '5433:5432'
    volumes:
      - /var/lib/postgresql/data:/var/lib/postgresql/data
```

### 10.3. SSL/TLS Configuration

```yaml
# Add nginx reverse proxy
services:
  nginx:
    image: nginx:alpine
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
      - ./ssl:/etc/nginx/ssl
    depends_on:
      - card-words-api
      - card-words-ai
```

---

## 11. Cleanup

### 11.1. Stop Services

```bash
# Stop all services
docker-compose down

# Stop and remove volumes (⚠️ deletes data)
docker-compose down -v

# Stop specific service
docker-compose stop card-words-api
```

### 11.2. Remove Images

```bash
# Remove all images
docker-compose down --rmi all

# Remove specific image
docker rmi card-words-services_card-words-api
docker rmi card-words-services_card-words-ai
```

### 11.3. Clean Up System

```bash
# Remove unused containers, networks, images
docker system prune

# Remove everything (⚠️ including volumes)
docker system prune -a --volumes
```

---

## 12. Useful Commands Cheat Sheet

```bash
# Build
docker-compose build                    # Build all
docker-compose build --no-cache         # Build without cache

# Start/Stop
docker-compose up -d                    # Start all (detached)
docker-compose down                     # Stop all
docker-compose restart                  # Restart all

# Logs
docker-compose logs -f                  # Follow all logs
docker-compose logs -f card-words-api   # Follow specific service

# Execute commands
docker-compose exec card-words-api bash # Enter container
docker-compose exec postgres psql -U postgres # PostgreSQL CLI

# Status
docker-compose ps                       # List containers
docker-compose top                      # Show running processes

# Scale
docker-compose up -d --scale card-words-api=3 # Run 3 instances
```

---

## 13. Next Steps

1. ✅ Setup Docker environment
2. ✅ Build and run services
3. ✅ Test health checks
4. ✅ Test API endpoints
5. ⏭️ Setup CI/CD pipeline
6. ⏭️ Configure monitoring
7. ⏭️ Deploy to production

---

**Tác giả:** AI Assistant  
**Ngày tạo:** 2024-11-16  
**Phiên bản:** 1.0  
**Status:** Complete Docker Setup Guide
