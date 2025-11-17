# Dockerfile Placement Guide

## 🎯 Quick Answer

**Dockerfile PHẢI ở trong TỪNG service folder riêng biệt!**

```
card-words-services/
├── docker-compose.yml          # ✅ Chung
├── .env                        # ✅ Chung
│
├── card-words/
│   └── Dockerfile              # ✅ RIÊNG cho Spring Boot
│
└── card-words-ai/
    └── Dockerfile              # ✅ RIÊNG cho Python AI
```

---

## 1. Tại sao Dockerfile PHẢI riêng?

### **Lý do 1: Khác ngôn ngữ, khác base image**

```dockerfile
# card-words/Dockerfile - Java Spring Boot
FROM maven:3.9.6-eclipse-temurin-17 AS build
# ... Java specific

# card-words-ai/Dockerfile - Python
FROM python:3.11-slim
# ... Python specific
```

### **Lý do 2: Khác dependencies**

```dockerfile
# card-words/Dockerfile
COPY pom.xml .
RUN mvn dependency:go-offline

# card-words-ai/Dockerfile
COPY pyproject.toml poetry.lock ./
RUN poetry install
```

### **Lý do 3: Khác build process**

```dockerfile
# card-words/Dockerfile - Multi-stage build
FROM maven:3.9.6 AS build
RUN mvn clean package
FROM eclipse-temurin:17-jre-alpine
COPY --from=build /app/target/*.jar app.jar

# card-words-ai/Dockerfile - Single stage
FROM python:3.11-slim
COPY app/ ./app/
```

### **Lý do 4: Docker build context**

```yaml
# docker-compose.yml
services:
  card-words-api:
    build:
      context: ./card-words      # ✅ Build context = card-words/
      dockerfile: Dockerfile      # ✅ Tìm Dockerfile trong card-words/

  card-words-ai:
    build:
      context: ./card-words-ai   # ✅ Build context = card-words-ai/
      dockerfile: Dockerfile      # ✅ Tìm Dockerfile trong card-words-ai/
```

---

## 2. So sánh với docker-compose.yml và .env

| File | Vị trí | Lý do |
|------|--------|-------|
| **docker-compose.yml** | ✅ Root (chung) | Orchestration cho tất cả services |
| **.env** | ✅ Root (chung) | Shared environment variables |
| **Dockerfile** | ❌ Mỗi service (riêng) | Mỗi service có tech stack khác nhau |

---

## 3. Correct Structure

```
card-words-services/
│
├── docker-compose.yml              # ✅ CHUNG - Orchestration
├── .env                            # ✅ CHUNG - Environment variables
├── .gitignore
├── README.md
│
├── card-words/                     # Spring Boot Service
│   ├── src/
│   ├── pom.xml
│   ├── Dockerfile                  # ✅ RIÊNG - Java build
│   └── .dockerignore               # ✅ RIÊNG - Java ignores
│
└── card-words-ai/                  # Python AI Service
    ├── app/
    ├── models/
    ├── pyproject.toml
    ├── Dockerfile                  # ✅ RIÊNG - Python build
    └── .dockerignore               # ✅ RIÊNG - Python ignores
```

---

## 4. Dockerfile Examples

### **card-words/Dockerfile (Spring Boot):**

```dockerfile
# Multi-stage build for Spring Boot
FROM maven:3.9.6-eclipse-temurin-17 AS build

WORKDIR /app

# Copy pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source and build
COPY src ./src
RUN mvn clean package -DskipTests

# Runtime stage
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Create non-root user
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

# Copy jar from build stage
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:8080/actuator/health || exit 1

ENTRYPOINT ["java", "-jar", "-Dspring.profiles.active=prod", "app.jar"]
```

### **card-words-ai/Dockerfile (Python):**

```dockerfile
# Single stage for Python
FROM python:3.11-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc g++ libgomp1 curl \
    && rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN pip install poetry==1.7.0

# Copy dependency files
COPY pyproject.toml poetry.lock* ./

# Install dependencies
RUN poetry config virtualenvs.create false \
    && poetry install --no-dev --no-interaction --no-ansi

# Copy application
COPY app/ ./app/
COPY models/ ./models/

# Create non-root user
RUN useradd -m -u 1000 appuser && chown -R appuser:appuser /app
USER appuser

EXPOSE 8001

HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:8001/health || exit 1

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8001"]
```

---

## 5. docker-compose.yml References

```yaml
version: '3.8'

services:
  # Spring Boot Service
  card-words-api:
    build:
      context: ./card-words           # ✅ Path to service folder
      dockerfile: Dockerfile          # ✅ Dockerfile in that folder
    container_name: card-words-api
    # ... rest of config

  # Python AI Service
  card-words-ai:
    build:
      context: ./card-words-ai        # ✅ Path to service folder
      dockerfile: Dockerfile          # ✅ Dockerfile in that folder
    container_name: card-words-ai
    # ... rest of config
```

---

## 6. Build Process

### **Build từng service:**

```bash
# Build Spring Boot
docker-compose build card-words-api

# Build Python AI
docker-compose build card-words-ai

# Build all
docker-compose build
```

### **Build context:**

```bash
# Khi build card-words-api
# Docker sẽ:
# 1. cd card-words/
# 2. Tìm Dockerfile trong card-words/
# 3. COPY pom.xml . → Copy từ card-words/pom.xml
# 4. COPY src ./src → Copy từ card-words/src/

# Khi build card-words-ai
# Docker sẽ:
# 1. cd card-words-ai/
# 2. Tìm Dockerfile trong card-words-ai/
# 3. COPY pyproject.toml . → Copy từ card-words-ai/pyproject.toml
# 4. COPY app/ ./app/ → Copy từ card-words-ai/app/
```

---

## 7. .dockerignore Files (Cũng phải riêng)

### **card-words/.dockerignore:**

```
# Java/Maven specific
target/
.mvn/
mvnw
mvnw.cmd

# IDE
.idea/
*.iml
.vscode/

# Git
.git/
.gitignore

# Docs
*.md
README.md

# Env files
.env*

# Logs
*.log
```

### **card-words-ai/.dockerignore:**

```
# Python specific
__pycache__/
*.pyc
*.pyo
*.pyd
.Python

# Virtual environments
.venv/
venv/
env/

# Testing
.pytest_cache/
.coverage
htmlcov/

# IDE
.vscode/
.idea/

# Git
.git/
.gitignore

# Docs
*.md
README.md
docs/
notebooks/

# Env files
.env*

# Logs
*.log
```

---

## 8. Common Mistakes ❌

### **Mistake 1: Đặt Dockerfile ở root**

```
card-words-services/
├── Dockerfile              # ❌ WRONG! Dockerfile cho service nào?
├── docker-compose.yml
├── card-words/
└── card-words-ai/
```

### **Mistake 2: Dùng chung 1 Dockerfile**

```dockerfile
# Dockerfile (root) - ❌ WRONG!
FROM maven:3.9.6 AS build-java
# ... build Spring Boot

FROM python:3.11 AS build-python
# ... build Python

# ❌ Không thể build 2 services khác nhau trong 1 Dockerfile!
```

### **Mistake 3: Sai build context**

```yaml
# docker-compose.yml - ❌ WRONG!
services:
  card-words-api:
    build:
      context: .                    # ❌ Root context
      dockerfile: card-words/Dockerfile  # ❌ Sai path
```

**Đúng:**

```yaml
services:
  card-words-api:
    build:
      context: ./card-words         # ✅ Service context
      dockerfile: Dockerfile        # ✅ Dockerfile trong context
```

---

## 9. Advanced: Shared Base Images (Optional)

Nếu muốn share common layers, có thể tạo base images:

```
card-words-services/
├── docker/
│   ├── base-java.Dockerfile      # ⚠️ Optional: Base Java image
│   └── base-python.Dockerfile    # ⚠️ Optional: Base Python image
│
├── card-words/
│   └── Dockerfile                # Extends base-java
│
└── card-words-ai/
    └── Dockerfile                # Extends base-python
```

**Nhưng thường KHÔNG CẦN thiết cho monorepo!**

---

## 10. Summary

### ✅ **Dockerfile Placement Rules:**

1. **Mỗi service MỘT Dockerfile riêng**
2. **Dockerfile ở trong service folder**
3. **Build context = service folder**
4. **Mỗi service MỘT .dockerignore riêng**

### 📁 **Correct Structure:**

```
card-words-services/
├── docker-compose.yml          # ✅ Chung
├── .env                        # ✅ Chung
│
├── card-words/
│   ├── Dockerfile              # ✅ Riêng
│   └── .dockerignore           # ✅ Riêng
│
└── card-words-ai/
    ├── Dockerfile              # ✅ Riêng
    └── .dockerignore           # ✅ Riêng
```

### 🚀 **Build Commands:**

```bash
# Build all
docker-compose build

# Build specific
docker-compose build card-words-api
docker-compose build card-words-ai

# Rebuild without cache
docker-compose build --no-cache
```

---

## 11. Quick Reference

| File | Vị trí | Số lượng | Lý do |
|------|--------|----------|-------|
| **docker-compose.yml** | Root | 1 | Orchestration |
| **.env** | Root | 1 | Shared variables |
| **Dockerfile** | Mỗi service | N (số services) | Khác tech stack |
| **.dockerignore** | Mỗi service | N (số services) | Khác file types |
| **.gitignore** | Root | 1 | Git ignores |
| **README.md** | Root | 1 | Documentation |

---

## 12. Final Answer

### 🎯 **Dockerfile:**

**❌ KHÔNG dùng chung**  
**✅ MỖI service MỘT Dockerfile riêng**

**Lý do:**
- Khác ngôn ngữ (Java vs Python)
- Khác dependencies (Maven vs Poetry)
- Khác build process
- Khác base images

**Structure:**
```
card-words-services/
├── card-words/
│   └── Dockerfile              ✅ RIÊNG
│
└── card-words-ai/
    └── Dockerfile              ✅ RIÊNG
```

---

**Tác giả:** AI Assistant  
**Ngày tạo:** 2024-11-16  
**Rule:** Dockerfile PHẢI riêng cho từng service!
