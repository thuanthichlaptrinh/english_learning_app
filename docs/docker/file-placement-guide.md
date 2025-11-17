# File Placement Guide - Sau khi Migrate sang Monorepo

## 📍 Vị trí Files sau Migration

### **TRƯỚC Migration (Hiện tại):**

```
workspace/
├── card-words/                    # Repo hiện tại
│   ├── src/
│   ├── pom.xml
│   ├── Dockerfile                 ✅ Đã có
│   ├── docker-compose.yml         ✅ Đã có
│   └── .env.docker.example        ✅ Đã có
│
└── card-words-ai/                 # Thư mục mới
    └── docs/
        ├── docker-compose-monorepo.yml        📄 Template
        ├── .env.monorepo.example              📄 Template
        └── docker-monorepo-setup-guide.md     📖 Guide
```

### **SAU Migration (Monorepo):**

```
card-words-services/               # Monorepo mới
├── card-words/                    # Spring Boot
│   ├── src/
│   ├── pom.xml
│   ├── Dockerfile                 ✅ Copy từ card-words cũ
│   └── .dockerignore              ⚠️ Tạo mới
│
├── card-words-ai/                 # Python AI
│   ├── app/
│   ├── models/
│   ├── pyproject.toml
│   ├── Dockerfile                 ⚠️ Tạo mới
│   └── .dockerignore              ⚠️ Tạo mới
│
├── docker-compose.yml             ⚠️ Copy từ template
├── .env                           ⚠️ Copy từ template
├── .env.example                   ⚠️ Copy từ template
├── .gitignore                     ⚠️ Tạo mới
└── README.md                      ⚠️ Tạo mới
```

---

## 🔄 Migration Steps với File Placement

### **Step 1: Tạo Monorepo Structure**

```bash
# Tạo thư mục monorepo
mkdir card-words-services
cd card-words-services
git init
```

### **Step 2: Import card-words (với history)**

```bash
# Import card-words với Git Subtree
git remote add card-words-origin ../card-words
git fetch card-words-origin
git subtree add --prefix=card-words card-words-origin main
```

### **Step 3: Add card-words-ai**

```bash
# Copy card-words-ai
cp -r ../card-words-ai ./card-words-ai

# Remove docs templates (không cần trong monorepo)
rm -rf card-words-ai/docs/docker-compose-monorepo.yml
rm -rf card-words-ai/docs/.env.monorepo.example
rm -rf card-words-ai/docs/docker-monorepo-setup-guide.md
```

### **Step 4: Setup Docker Files**

#### **4.1. Copy docker-compose.yml to ROOT**

```bash
# Copy template từ docs
cp card-words-ai/docs/docker-compose-monorepo.yml ./docker-compose.yml

# Hoặc tạo mới
cat > docker-compose.yml << 'EOF'
# Paste nội dung từ docker-compose-monorepo.yml
EOF
```

#### **4.2. Copy .env to ROOT**

```bash
# Copy template
cp card-words-ai/docs/.env.monorepo.example ./.env.example

# Create actual .env
cp .env.example .env

# Edit với values thực tế
nano .env
```

#### **4.3. Create Dockerfile for card-words-ai**

```bash
# Tạo Dockerfile trong card-words-ai/
cat > card-words-ai/Dockerfile << 'EOF'
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

# Expose port
EXPOSE 8001

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:8001/health || exit 1

# Run application
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8001"]
EOF
```

#### **4.4. Create .dockerignore files**

```bash
# card-words/.dockerignore
cat > card-words/.dockerignore << 'EOF'
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
EOF

# card-words-ai/.dockerignore
cat > card-words-ai/.dockerignore << 'EOF'
__pycache__/
*.pyc
.venv/
venv/
.pytest_cache/
.git/
.gitignore
*.md
.env*
.vscode/
.idea/
notebooks/
tests/
docs/
EOF
```

---

## 📋 Checklist: Files cần tạo/copy

### ✅ ROOT Level (card-words-services/)

- [ ] `docker-compose.yml` - Copy từ `card-words-ai/docs/docker-compose-monorepo.yml`
- [ ] `.env` - Copy từ `card-words-ai/docs/.env.monorepo.example` và edit
- [ ] `.env.example` - Copy từ `card-words-ai/docs/.env.monorepo.example`
- [ ] `.gitignore` - Tạo mới cho monorepo
- [ ] `README.md` - Tạo mới

### ✅ card-words/ (Đã có từ repo cũ)

- [x] `Dockerfile` - Giữ nguyên từ repo cũ
- [ ] `.dockerignore` - Tạo mới

### ✅ card-words-ai/

- [ ] `Dockerfile` - Tạo mới
- [ ] `.dockerignore` - Tạo mới

---

## 🎯 Final Structure

```
card-words-services/                    # ROOT của monorepo
│
├── docker-compose.yml                  # ⬅️ Copy từ template
├── .env                                # ⬅️ Copy và edit
├── .env.example                        # ⬅️ Copy từ template
├── .gitignore                          # ⬅️ Tạo mới
├── README.md                           # ⬅️ Tạo mới
│
├── card-words/                         # Spring Boot
│   ├── src/
│   ├── pom.xml
│   ├── Dockerfile                      # ✅ Từ repo cũ
│   ├── .dockerignore                   # ⬅️ Tạo mới
│   └── ...
│
└── card-words-ai/                      # Python AI
    ├── app/
    ├── models/
    ├── pyproject.toml
    ├── Dockerfile                      # ⬅️ Tạo mới
    ├── .dockerignore                   # ⬅️ Tạo mới
    └── docs/                           # Docs (optional, có thể xóa)
        ├── AI/
        └── ...
```

---

## 🚀 Quick Commands

### **Tạo tất cả files cần thiết:**

```bash
#!/bin/bash
# setup-monorepo-docker.sh

# Đang ở trong card-words-services/

echo "Setting up Docker files for monorepo..."

# 1. Copy docker-compose.yml
echo "Creating docker-compose.yml..."
cp card-words-ai/docs/docker-compose-monorepo.yml ./docker-compose.yml

# 2. Copy .env files
echo "Creating .env files..."
cp card-words-ai/docs/.env.monorepo.example ./.env.example
cp .env.example .env

# 3. Create Dockerfile for card-words-ai
echo "Creating Dockerfile for card-words-ai..."
cat > card-words-ai/Dockerfile << 'EOF'
FROM python:3.11-slim
WORKDIR /app
RUN apt-get update && apt-get install -y gcc g++ libgomp1 curl && rm -rf /var/lib/apt/lists/*
RUN pip install poetry==1.7.0
COPY pyproject.toml poetry.lock* ./
RUN poetry config virtualenvs.create false && poetry install --no-dev --no-interaction --no-ansi
COPY app/ ./app/
COPY models/ ./models/
RUN useradd -m -u 1000 appuser && chown -R appuser:appuser /app
USER appuser
EXPOSE 8001
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 CMD curl -f http://localhost:8001/health || exit 1
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8001"]
EOF

# 4. Create .dockerignore files
echo "Creating .dockerignore files..."
cat > card-words/.dockerignore << 'EOF'
target/
.mvn/
mvnw
mvnw.cmd
.git/
*.md
.env*
.idea/
*.iml
EOF

cat > card-words-ai/.dockerignore << 'EOF'
__pycache__/
*.pyc
.venv/
.pytest_cache/
.git/
*.md
.env*
.vscode/
notebooks/
tests/
docs/
EOF

echo "✅ Docker setup complete!"
echo ""
echo "Next steps:"
echo "1. Edit .env with your actual values"
echo "2. Run: docker-compose build"
echo "3. Run: docker-compose up -d"
```

### **Chạy script:**

```bash
chmod +x setup-monorepo-docker.sh
./setup-monorepo-docker.sh
```

---

## 💡 Tóm tắt

### **Files trong `card-words-ai/docs/` là TEMPLATES:**
- ❌ **KHÔNG** dùng trực tiếp
- ✅ **COPY** sang root của monorepo
- ✅ **EDIT** với values thực tế

### **Sau khi migrate:**
- ✅ `docker-compose.yml` ở **ROOT** của monorepo
- ✅ `.env` ở **ROOT** của monorepo
- ✅ `Dockerfile` trong **mỗi service folder**

### **Để build và run:**
```bash
cd card-words-services/  # ROOT của monorepo
docker-compose build
docker-compose up -d
```

---

Bạn có muốn tôi tạo script tự động để setup tất cả files này không? 🚀
