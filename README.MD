# 🎴 Card Words Services - Monorepo

> Monorepo chứa tất cả services của Card Words Platform: Backend API (Spring Boot) và AI Service (Python FastAPI)

[![Java](https://img.shields.io/badge/Java-17-orange)](https://www.oracle.com/java/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.2.5-brightgreen)](https://spring.io/projects/spring-boot)
[![Python](https://img.shields.io/badge/Python-3.11-blue)](https://www.python.org/)
[![FastAPI](https://img.shields.io/badge/FastAPI-Latest-009688)](https://fastapi.tiangolo.com/)
[![Docker](https://img.shields.io/badge/Docker-Compose-2496ED)](https://www.docker.com/)

---

## 📁 Cấu trúc Monorepo

```
card-words-services/
├── card-words/              # Spring Boot Backend API
│   ├── src/                 # Java source code
│   ├── pom.xml             # Maven dependencies
│   └── Dockerfile          # Docker build cho Spring Boot
│
├── card-words-ai/          # Python AI Service
│   ├── app/                # FastAPI application
│   ├── models/             # LightGBM models
│   ├── pyproject.toml      # Poetry dependencies
│   └── Dockerfile          # Docker build cho Python
│
├── docs/                   # Documentation
│   ├── auth/              # Authentication guides
│   ├── docker/            # Docker setup guides
│   ├── AI/                # AI/ML documentation
│   └── ...
│
├── docker-compose.yml     # ✨ SHARED Docker Compose (TẤT CẢ SERVICES)
├── .env                   # ✨ SHARED Environment Variables
├── .gitignore            # Monorepo gitignore
└── README.md             # This file
```

---

## 🚀 Quick Start

### Prerequisites

-   **Docker Desktop** (hoặc Docker Engine + Docker Compose)
-   **Java 17+** (nếu chạy local)
-   **Maven 3.9+** (nếu build local)
-   **Python 3.11+** (nếu chạy AI service local)

### 🐳 Chạy tất cả services với Docker (Recommended)

```bash
# 1. Di chuyển vào thư mục root
cd card-words-services

# 2. Start tất cả services
docker-compose up -d

# 3. Xem logs
docker-compose logs -f

# 4. Kiểm tra status
docker-compose ps
```

**Services sẽ chạy trên:**

-   🌐 **Spring Boot API**: http://localhost:8080
-   🤖 **AI Service**: http://localhost:8001
-   🗄️ **PostgreSQL**: localhost:5433
-   🔴 **Redis**: localhost:6379
-   🔧 **PgAdmin**: http://localhost:5050
-   📊 **Redis Insight**: http://localhost:5540

---

## 📦 Services

### 1️⃣ card-words (Spring Boot Backend)

**Công nghệ:**

-   Spring Boot 3.2.5
-   Java 17
-   PostgreSQL 16
-   Redis 7
-   Spring Security + JWT
-   Google OAuth2
-   Firebase Storage

**Ports:**

-   Application: `8080`
-   Database: `5433` (external)

**Documentation:**

-   API Docs: http://localhost:8080/swagger-ui.html
-   Actuator: http://localhost:8080/actuator

### 2️⃣ card-words-ai (Python AI Service)

**Công nghệ:**

-   Python 3.11
-   FastAPI
-   LightGBM (Machine Learning)
-   PostgreSQL (read-only)
-   Redis (caching)

**Ports:**

-   API: `8001`

**Features:**

-   Smart Vocabulary Review (LightGBM predictions)
-   Redis caching cho performance
-   JWT authentication với Spring Boot

---

## ⚙️ Configuration

### Environment Variables (`.env`)

```env
# Server Ports
SERVER_SPRING_PORT=8080
SERVER_FLASH_PORT=8001

# Database
POSTGRES_DB=card_words
POSTGRES_USER=postgres
POSTGRES_PASSWORD=your_password
POSTGRES_EXTERNAL_PORT=5433

# Redis
REDIS_EXTERNAL_PORT=6379
REDIS_AI_DB=1

# JWT
JWT_SECRET=your_jwt_secret

# Email
MAIL_USERNAME=your_email@gmail.com
MAIL_PASSWORD=your_app_password

# Google OAuth2
GOOGLE_OAUTH_CLIENT_ID=your_client_id
GOOGLE_OAUTH_CLIENT_SECRET=your_client_secret

# Firebase
FIREBASE_STORAGE_BUCKET=your_bucket
```

**⚠️ LƯU Ý:** File `.env` chứa thông tin nhạy cảm, không commit lên Git!

---

## 🔧 Development

### Chạy từng service riêng lẻ

#### Spring Boot (card-words)

```bash
cd card-words

# Build
mvn clean package -DskipTests

# Run
mvn spring-boot:run

# Hoặc
java -jar target/card-words-0.0.1-SNAPSHOT.jar
```

#### AI Service (card-words-ai)

```bash
cd card-words-ai

# Install dependencies
poetry install

# Run
poetry run uvicorn app.main:app --reload --port 8001
```

### Build Docker Images

```bash
# Build tất cả
docker-compose build

# Build từng service
docker-compose build card-words-api
docker-compose build card-words-ai

# Build với no cache
docker-compose build --no-cache
```

---

## 🗄️ Database

### Migrations

Database schema được quản lý bởi **Flyway**:

-   Location: `card-words/src/main/resources/db/migration/`
-   Auto-run khi start application

### Backup & Restore

```bash
cd card-words

# Backup
./backup-database.bat   # Windows
./backup-database.sh    # Linux/Mac

# Restore
./restore-database.bat  # Windows
./restore-database.sh   # Linux/Mac
```

Backups được lưu trong: `card-words/database-backups/`

---

## 🧪 Testing

### Spring Boot Tests

```bash
cd card-words
mvn test
```

### AI Service Tests

```bash
cd card-words-ai
poetry run pytest
```

---

## 📊 Monitoring & Logs

### Xem logs

```bash
# Tất cả services
docker-compose logs -f

# Service cụ thể
docker-compose logs -f card-words-api
docker-compose logs -f card-words-ai

# Chỉ xem 100 dòng cuối
docker-compose logs --tail=100 -f
```

### Health Checks

```bash
# Spring Boot
curl http://localhost:8080/actuator/health

# AI Service
curl http://localhost:8001/health

# Database
docker-compose exec postgres pg_isready -U postgres
```

---

## 🛠️ Troubleshooting

### Containers không start

```bash
# Stop tất cả
docker-compose down

# Xóa volumes (⚠️ MẤT DỮ LIỆU)
docker-compose down -v

# Rebuild và start lại
docker-compose up -d --build
```

### Port conflicts

```bash
# Kiểm tra port đang được sử dụng
netstat -ano | findstr :8080    # Windows
lsof -i :8080                   # Mac/Linux

# Thay đổi port trong .env
SERVER_SPRING_PORT=8081
```

### Database connection failed

```bash
# Kiểm tra PostgreSQL logs
docker-compose logs postgres

# Test connection
docker-compose exec postgres psql -U postgres -d card_words -c '\dt'
```

---

## 📚 Documentation

Chi tiết documentation cho từng module:

-   **Authentication**: [docs/auth/](docs/auth/)
-   **Docker Setup**: [docs/docker/](docs/docker/)
-   **AI/ML**: [docs/AI/](docs/AI/)
-   **API Guides**: [docs/](docs/)

**Migration Guide**: [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md)

---

## 🤝 Contributing

### Git Workflow

```bash
# Tạo branch mới
git checkout -b feature/your-feature-name

# Commit changes
git add .
git commit -m "feat: your feature description"

# Push
git push origin feature/your-feature-name

# Tạo Pull Request trên GitHub
```

### Commit Message Convention

```
feat: thêm tính năng mới
fix: sửa bug
docs: cập nhật documentation
refactor: refactor code
test: thêm tests
chore: maintenance tasks
```

---

## 📄 License

[Add your license here]

---

## 👥 Team

-   **Backend Developer**: [Your Name]
-   **AI/ML Engineer**: [Your Name]

---

## 📞 Support

Nếu gặp vấn đề, vui lòng:

1. Kiểm tra [Troubleshooting](#-troubleshooting)
2. Xem [Documentation](docs/)
3. Tạo [GitHub Issue](https://github.com/thuanthichlaptrinh/card_words_services/issues)

---

**Made with ❤️ by Card Words Team**
