# Hướng dẫn Migrate sang Monorepo - Giữ nguyên Git History

## 1. Tổng quan

### 1.1. Mục tiêu

Chuyển từ:
```
card-words/          (repo hiện tại - 55 commits)
card-words-ai/       (thư mục mới)
```

Sang:
```
card-words-services/ (monorepo mới)
├── card-words/      (Spring Boot - giữ nguyên 55 commits)
└── card-words-ai/   (Python FastAPI)
```

### 1.2. Yêu cầu

✅ Giữ nguyên **55 commits** cũ của card-words  
✅ Giữ nguyên **git history**  
✅ Tổ chức thành **monorepo**  
✅ Dễ dàng **CI/CD** riêng cho từng service  

---

## 2. Phương pháp Recommended: Git Subtree

### 2.1. Tại sao dùng Git Subtree?

✅ **Giữ nguyên history** - Tất cả 55 commits được preserve  
✅ **Đơn giản** - Không cần submodules phức tạp  
✅ **Một repo duy nhất** - Dễ clone, dễ quản lý  
✅ **CI/CD friendly** - Dễ setup workflows  

---

## 3. Step-by-Step Migration

### 3.1. Backup (Quan trọng!)

```bash
# Backup repo hiện tại
cd /path/to/current/workspace
cp -r card-words card-words-backup
cp -r card-words-ai card-words-ai-backup

# Hoặc tạo branch backup
cd card-words
git checkout -b backup-before-migration
git push origin backup-before-migration
```

---

### 3.2. Tạo Monorepo Mới

```bash
# 1. Tạo thư mục monorepo mới
mkdir card-words-services
cd card-words-services

# 2. Init git repo
git init

# 3. Tạo README
cat > README.md << 'EOF'
# Card Words Services

Monorepo chứa các services của Card Words:

- **card-words**: Spring Boot backend
- **card-words-ai**: Python AI service (LightGBM)

## Structure

```
card-words-services/
├── card-words/          # Spring Boot API
├── card-words-ai/       # Python AI Service
├── docker-compose.yml   # Orchestration
└── README.md
```

## Getting Started

### card-words (Spring Boot)
```bash
cd card-words
./mvnw spring-boot:run
```

### card-words-ai (Python)
```bash
cd card-words-ai
poetry install
poetry run uvicorn app.main:app --reload
```
EOF

# 4. Commit initial
git add README.md
git commit -m "Initial commit: Create monorepo structure"
```

---

### 3.3. Import card-words với Git History

**Option A: Git Subtree (Recommended)**

```bash
# Đang ở trong card-words-services/

# 1. Add remote của repo cũ
git remote add card-words-origin /path/to/card-words
# Hoặc nếu là remote repo:
# git remote add card-words-origin https://github.com/username/card-words.git

# 2. Fetch tất cả history
git fetch card-words-origin

# 3. Merge vào subdirectory card-words/
git subtree add --prefix=card-words card-words-origin main --squash

# Nếu muốn giữ TOÀN BỘ commits (không squash):
# git subtree add --prefix=card-words card-words-origin main

# 4. Verify
git log --oneline
# Bạn sẽ thấy tất cả commits của card-words
```

**Option B: Git Filter-Repo (Advanced - Giữ 100% history)**

```bash
# Install git-filter-repo
pip install git-filter-repo

# 1. Clone repo cũ
cd /tmp
git clone /path/to/card-words card-words-temp
cd card-words-temp

# 2. Move tất cả files vào subdirectory
git filter-repo --to-subdirectory-filter card-words

# 3. Quay lại monorepo và merge
cd /path/to/card-words-services
git remote add card-words-temp /tmp/card-words-temp
git fetch card-words-temp
git merge --allow-unrelated-histories card-words-temp/main

# 4. Cleanup
git remote remove card-words-temp
rm -rf /tmp/card-words-temp
```

---

### 3.4. Add card-words-ai

```bash
# Đang ở trong card-words-services/

# 1. Copy card-words-ai vào monorepo
cp -r /path/to/card-words-ai ./card-words-ai

# 2. Add và commit
git add card-words-ai/
git commit -m "Add card-words-ai: Python AI service with LightGBM"

# 3. Verify structure
tree -L 2
# card-words-services/
# ├── card-words/
# │   ├── src/
# │   ├── pom.xml
# │   └── ...
# ├── card-words-ai/
# │   ├── app/
# │   ├── pyproject.toml
# │   └── ...
# └── README.md
```

---

### 3.5. Setup Monorepo Structure

```bash
# Tạo docker-compose.yml cho cả 2 services
cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  # Spring Boot Backend
  card-words-api:
    build:
      context: ./card-words
      dockerfile: Dockerfile
    container_name: card-words-api
    ports:
      - "8080:8080"
    environment:
      - SPRING_PROFILES_ACTIVE=prod
      - DATABASE_URL=postgresql://postgres:5432/cardwords
      - AI_SERVICE_URL=http://card-words-ai:8001
    depends_on:
      - postgres
      - card-words-ai
    networks:
      - card-words-network

  # Python AI Service
  card-words-ai:
    build:
      context: ./card-words-ai
      dockerfile: Dockerfile
    container_name: card-words-ai
    ports:
      - "8001:8001"
    environment:
      - DATABASE_URL=postgresql://postgres:5432/cardwords
      - MODEL_PATH=/app/models/lightgbm_vocab_predictor.txt
    volumes:
      - ./card-words-ai/models:/app/models
    depends_on:
      - postgres
    networks:
      - card-words-network

  # PostgreSQL Database
  postgres:
    image: postgres:15-alpine
    container_name: card-words-postgres
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
      - POSTGRES_DB=cardwords
    ports:
      - "5432:5432"
    volumes:
      - postgres-data:/var/lib/postgresql/data
    networks:
      - card-words-network

  # Redis Cache
  redis:
    image: redis:7-alpine
    container_name: card-words-redis
    ports:
      - "6379:6379"
    networks:
      - card-words-network

networks:
  card-words-network:
    driver: bridge

volumes:
  postgres-data:
EOF

git add docker-compose.yml
git commit -m "Add docker-compose for monorepo orchestration"
```

---

### 3.6. Setup .gitignore

```bash
cat > .gitignore << 'EOF'
# IDE
.idea/
.vscode/
*.iml

# OS
.DS_Store
Thumbs.db

# Logs
*.log

# Environment
.env
.env.local

# card-words (Spring Boot)
card-words/target/
card-words/.mvn/
card-words/mvnw
card-words/mvnw.cmd

# card-words-ai (Python)
card-words-ai/__pycache__/
card-words-ai/.pytest_cache/
card-words-ai/.venv/
card-words-ai/venv/
card-words-ai/*.egg-info/
card-words-ai/models/*.txt
card-words-ai/models/*.pkl

# Docker
docker-compose.override.yml
EOF

git add .gitignore
git commit -m "Add monorepo .gitignore"
```

---

### 3.7. Push to Remote

```bash
# 1. Tạo repo mới trên GitHub/GitLab
# Tên: card-words-services

# 2. Add remote
git remote add origin https://github.com/username/card-words-services.git

# 3. Push
git push -u origin main

# 4. Verify trên GitHub
# - Kiểm tra có đủ 55+ commits không
# - Kiểm tra cấu trúc thư mục
```

---

## 4. Verify Migration

### 4.1. Check Git History

```bash
# Kiểm tra tổng số commits
git log --oneline | wc -l
# Phải có ít nhất 55+ commits

# Xem history của card-words
git log --oneline -- card-words/
# Phải thấy 55 commits cũ

# Xem chi tiết một commit cũ
git show <commit-hash>
```

### 4.2. Check File Structure

```bash
# Verify structure
tree -L 2 -I 'target|node_modules|__pycache__'

# Expected output:
# card-words-services/
# ├── card-words/
# │   ├── src/
# │   ├── pom.xml
# │   └── README.md
# ├── card-words-ai/
# │   ├── app/
# │   ├── pyproject.toml
# │   └── README.md
# ├── docker-compose.yml
# ├── .gitignore
# └── README.md
```

### 4.3. Test Build

```bash
# Test Spring Boot
cd card-words
./mvnw clean package
cd ..

# Test Python AI
cd card-words-ai
poetry install
poetry run pytest
cd ..

# Test Docker
docker-compose build
docker-compose up -d
docker-compose ps
docker-compose down
```

---

## 5. CI/CD Setup

### 5.1. GitHub Actions

```yaml
# .github/workflows/ci.yml
name: CI/CD Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  # Job 1: Build Spring Boot
  build-card-words:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Set up JDK 17
        uses: actions/setup-java@v3
        with:
          java-version: '17'
          distribution: 'temurin'
      
      - name: Build with Maven
        working-directory: ./card-words
        run: ./mvnw clean package -DskipTests
      
      - name: Run tests
        working-directory: ./card-words
        run: ./mvnw test

  # Job 2: Build Python AI
  build-card-words-ai:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'
      
      - name: Install Poetry
        run: |
          curl -sSL https://install.python-poetry.org | python3 -
          echo "$HOME/.local/bin" >> $GITHUB_PATH
      
      - name: Install dependencies
        working-directory: ./card-words-ai
        run: poetry install
      
      - name: Run tests
        working-directory: ./card-words-ai
        run: poetry run pytest

  # Job 3: Docker Build
  docker-build:
    needs: [build-card-words, build-card-words-ai]
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Build Docker images
        run: docker-compose build
      
      - name: Test Docker Compose
        run: |
          docker-compose up -d
          sleep 30
          docker-compose ps
          docker-compose down
```

---

## 6. Development Workflow

### 6.1. Clone Monorepo

```bash
# Clone
git clone https://github.com/username/card-words-services.git
cd card-words-services

# Setup card-words
cd card-words
./mvnw clean install
cd ..

# Setup card-words-ai
cd card-words-ai
poetry install
cd ..

# Start all services
docker-compose up -d
```

### 6.2. Working on Specific Service

```bash
# Work on Spring Boot
cd card-words
git checkout -b feature/new-api
# ... make changes ...
git add .
git commit -m "feat(card-words): Add new API endpoint"
git push origin feature/new-api

# Work on Python AI
cd card-words-ai
git checkout -b feature/improve-model
# ... make changes ...
git add .
git commit -m "feat(card-words-ai): Improve LightGBM model accuracy"
git push origin feature/improve-model
```

### 6.3. Commit Convention

```bash
# Format: <type>(<scope>): <subject>

# Examples:
git commit -m "feat(card-words): Add smart review API"
git commit -m "fix(card-words-ai): Fix feature extraction bug"
git commit -m "docs(monorepo): Update README"
git commit -m "chore(docker): Update docker-compose config"

# Types:
# - feat: New feature
# - fix: Bug fix
# - docs: Documentation
# - style: Code style
# - refactor: Refactoring
# - test: Tests
# - chore: Maintenance
```

---

## 7. Alternative: Keep Separate Repos

Nếu bạn muốn giữ 2 repos riêng biệt nhưng vẫn quản lý chung:

### 7.1. Git Submodules

```bash
# Tạo monorepo
mkdir card-words-services
cd card-words-services
git init

# Add submodules
git submodule add https://github.com/username/card-words.git card-words
git submodule add https://github.com/username/card-words-ai.git card-words-ai

# Commit
git add .
git commit -m "Add submodules"
git push origin main

# Clone với submodules
git clone --recursive https://github.com/username/card-words-services.git

# Update submodules
git submodule update --remote
```

**Pros:**
- Mỗi service có repo riêng
- Dễ quản lý permissions

**Cons:**
- Phức tạp hơn
- Cần `--recursive` khi clone
- CI/CD phức tạp hơn

---

## 8. Recommended Structure

```
card-words-services/
├── .github/
│   └── workflows/
│       ├── ci-card-words.yml
│       └── ci-card-words-ai.yml
│
├── card-words/                    # Spring Boot Backend
│   ├── src/
│   ├── pom.xml
│   ├── Dockerfile
│   └── README.md
│
├── card-words-ai/                 # Python AI Service
│   ├── app/
│   ├── training/
│   ├── models/
│   ├── pyproject.toml
│   ├── Dockerfile
│   └── README.md
│
├── docs/                          # Shared documentation
│   ├── architecture.md
│   ├── api-integration.md
│   └── deployment.md
│
├── scripts/                       # Shared scripts
│   ├── setup.sh
│   ├── deploy.sh
│   └── backup.sh
│
├── docker-compose.yml             # Orchestration
├── docker-compose.dev.yml         # Development
├── docker-compose.prod.yml        # Production
├── .gitignore
├── .env.example
└── README.md
```

---

## 9. Troubleshooting

### 9.1. Mất Git History

```bash
# Kiểm tra
git log --oneline -- card-words/ | wc -l

# Nếu mất, restore từ backup
cd /path/to/backup
git log --oneline > commits.txt
# So sánh với monorepo
```

### 9.2. Conflict khi Merge

```bash
# Nếu có conflict
git status
git diff

# Resolve conflicts
# Edit files
git add .
git commit -m "Resolve merge conflicts"
```

### 9.3. Subtree Issues

```bash
# Nếu subtree add fail
git subtree split --prefix=card-words -b card-words-branch
git checkout -b temp
git merge card-words-branch
```

---

## 10. Summary

### ✅ Recommended Approach: Git Subtree

**Steps:**
1. Backup repos hiện tại
2. Tạo monorepo mới
3. Import card-words với `git subtree add` (giữ history)
4. Copy card-words-ai vào
5. Setup docker-compose
6. Push to remote

**Result:**
- ✅ Giữ nguyên 55 commits
- ✅ Một repo duy nhất
- ✅ Dễ CI/CD
- ✅ Dễ quản lý

### 📝 Commands Summary

```bash
# 1. Create monorepo
mkdir card-words-services && cd card-words-services
git init

# 2. Import card-words with history
git remote add card-words-origin /path/to/card-words
git fetch card-words-origin
git subtree add --prefix=card-words card-words-origin main

# 3. Add card-words-ai
cp -r /path/to/card-words-ai ./
git add card-words-ai/
git commit -m "Add card-words-ai"

# 4. Push
git remote add origin https://github.com/username/card-words-services.git
git push -u origin main
```

---

**Tác giả:** AI Assistant  
**Ngày tạo:** 2024-11-16  
**Phiên bản:** 1.0  
**Status:** Complete Migration Guide
