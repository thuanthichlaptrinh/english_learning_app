# Card Words Backend - English Vocabulary Learning Platform

Backend API cho ung dung hoc tu vung tieng Anh voi game va spaced repetition.

## Tech Stack

-   **Java 17** + Spring Boot 3.2
-   **PostgreSQL** - Database
-   **Redis 7.x** - Caching
-   **JWT** - Authentication
-   **Google OAuth2** - Social login
-   **Flyway** - Database migration
-   **Docker** - Containerization

## Features

### 1. Authentication & User Management

-   JWT Authentication
-   Google OAuth2 login
-   Email verification
-   Password reset
-   User profile management

### 2. Vocabulary Learning

-   Spaced Repetition Algorithm (SM-2)
-   CEFR levels (A1-C2)
-   Flashcard review
-   Vocabulary progress tracking
-   Learning statistics

### 3. Games

-   **Quick Quiz**: 4-option multiple choice
-   **Image Matching**: Match images with words
-   **Word Definition**: Match words with definitions

### 4. Streak System

-   Daily login tracking
-   Current streak & best streak
-   Streak recovery (1-day grace period)

### 5. Leaderboard (Phase 3)

-   Global leaderboard (all-time)
-   Daily leaderboard (26h TTL)
-   Weekly leaderboard (8-day TTL)
-   Real-time rank updates
-   Redis Sorted Sets (O(log N) performance)

### 6. Redis Caching

-   **Phase 1**: User caching (email lookup, profiles, online tracking)
-   **Phase 2**: Game sessions (Quiz, Image Matching, Word Definition)
-   **Phase 3**: Leaderboards (Global, Daily, Weekly)
-   Performance: 50-200x faster than database queries

## Prerequisites

-   **Java 17+**
-   **Maven 3.8+**
-   **PostgreSQL 15+**
-   **Redis 7+** (or Docker)
-   **Docker & Docker Compose** (optional but recommended)

## Installation & Setup

### 1. Clone Repository

```bash
git clone https://github.com/thuanthichlaptrinh/card_words.git
cd card_words
```

### 2. Configure Environment

Copy file `.env.docker.example` thanh `.env` va cap nhat cac bien:

```bash
# Database
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_DB=card_words
POSTGRES_USER=postgres
POSTGRES_PASSWORD=your_password

# JWT
JWT_SECRET=your_jwt_secret_key_min_256_bits
JWT_EXPIRATION=86400000

# Google OAuth2
GOOGLE_CLIENT_ID=your_google_client_id
GOOGLE_CLIENT_SECRET=your_google_client_secret

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379

# Firebase (for file storage)
FIREBASE_BUCKET=your_firebase_bucket
```

### 3. Setup Database

**Option A: PostgreSQL local**

```bash
# Tao database
psql -U postgres
CREATE DATABASE card_words;
\q

# Flyway se tu dong chay migrations khi start app
```

**Option B: PostgreSQL Docker**

```bash
docker-compose up -d postgres
```

### 4. Setup Redis

**Option A: Redis Docker (Recommended)**

```bash
docker-compose up -d redis
```

**Option B: Redis local**

```bash
# Windows (with Chocolatey)
choco install redis

# Mac
brew install redis
brew services start redis

# Linux
sudo apt-get install redis-server
sudo systemctl start redis
```

### 5. Build & Run Application

**Option A: Maven Wrapper**

```bash
# Build
./mvnw clean install -DskipTests

# Run
./mvnw spring-boot:run
```

\*\*Option B: Maven (neu da cai)

```bash
mvn clean install -DskipTests
mvn spring-boot:run
```

**Option C: Docker Compose (Full stack)**

```bash
# Build va start TAT CA 3 services:
# 1. PostgreSQL (port 5432)
# 2. Redis (port 6379)
# 3. Spring Boot App (port 8080)
docker-compose up -d

# Xem logs cua ung dung
docker-compose logs -f app

# Xem logs tat ca services
docker-compose logs -f

# Stop tat ca services
docker-compose down

# Stop va xoa volumes (database data)
docker-compose down -v
```

### 6. Verify Application

Ung dung se chay o: **http://localhost:8080**

**Health Check**:

```bash
curl http://localhost:8080/actuator/health
```

**Swagger UI** (API Documentation):

```
http://localhost:8080/swagger-ui.html
```

---

## Docker Compose Services

Khi chay `docker-compose up -d`, cac services sau se duoc khoi dong:

### 1. PostgreSQL Database

-   **Container**: `card-words-postgres`
-   **Image**: `postgres:16-alpine`
-   **Port**: `5432` (mapped to host)
-   **Volume**: `postgres_data` (luu du lieu database)
-   **Health Check**: Ping PostgreSQL moi 10s
-   **Init Script**: `init-db.sql` (tu dong chay khi lan dau)

### 2. Redis Cache

-   **Container**: `card-words-redis`
-   **Image**: `redis:7-alpine`
-   **Port**: `6379` (mapped to host)
-   **Volume**: `redis_data` (luu AOF file)
-   **Health Check**: Redis PING command
-   **Persistence**: AOF (Append-Only File) enabled

### 3. Spring Boot Application

-   **Container**: `card-words-app`
-   **Build**: Tu Dockerfile trong project
-   **Port**: `8080` (mapped to host)
-   **Dependencies**: Doi PostgreSQL va Redis healthy truoc khi start
-   **Restart**: Automatic (unless-stopped)
-   **Environment**: Doc tu file `.env.docker`

### Service Dependencies

```
Spring Boot App
    ├── depends_on: PostgreSQL (healthy)
    └── depends_on: Redis (healthy)
```

**Chu y**: App chi start sau khi PostgreSQL va Redis da HEALTHY

---

## Quick Start Commands

### Development

```bash
# 1. Start Redis
docker-compose up -d redis

# 2. Start PostgreSQL (neu dung Docker)
docker-compose up -d postgres

# 3. Run Spring Boot
./mvnw spring-boot:run

# 4. Xem logs
tail -f app.log
```

### Production Build

```bash
# Build JAR
./mvnw clean package -DskipTests

# Run JAR
java -jar target/card-words-0.0.1-SNAPSHOT.jar
```

### Docker

```bash
# Build image
docker build -t card-words:latest .

# Run container
docker run -d -p 8080:8080 --name card-words card-words:latest

# Stop container
docker stop card-words
docker rm card-words
```

### Docker Compose Commands

```bash
# Start tat ca services (detached mode)
docker-compose up -d

# Start chi Redis va Postgres (khong start app)
docker-compose up -d redis postgres

# Xem status cac services
docker-compose ps

# Xem logs realtime
docker-compose logs -f

# Xem logs mot service cu the
docker-compose logs -f app
docker-compose logs -f redis
docker-compose logs -f postgres

# Restart mot service
docker-compose restart app

# Stop tat ca services
docker-compose stop

# Stop va xoa containers (GIU du lieu volumes)
docker-compose down

# Stop, xoa containers VA volumes (MAT du lieu database)
docker-compose down -v

# Rebuild image va restart
docker-compose up -d --build

# Kiem tra health status
docker-compose ps
docker inspect card-words-postgres | grep -A 5 Health
docker inspect card-words-redis | grep -A 5 Health
```

## API Endpoints

### Authentication

```
POST   /api/v1/auth/register          - Dang ky tai khoan
POST   /api/v1/auth/login             - Dang nhap
POST   /api/v1/auth/google            - Dang nhap Google OAuth2
POST   /api/v1/auth/refresh-token     - Refresh JWT token
POST   /api/v1/auth/logout            - Dang xuat
```

### Vocabulary

```
GET    /api/v1/vocabs                 - Lay danh sach tu vung
GET    /api/v1/vocabs/{id}            - Chi tiet tu vung
POST   /api/v1/vocabs                 - Them tu vung (Admin)
PUT    /api/v1/vocabs/{id}            - Cap nhat tu vung (Admin)
DELETE /api/v1/vocabs/{id}            - Xoa tu vung (Admin)
```

### Learning

```
GET    /api/v1/learn/review-vocabs    - Lay tu can on tap
POST   /api/v1/learn/review           - Danh gia ket qua on tap
GET    /api/v1/learn/flashcards       - Lay flashcards
POST   /api/v1/learn/flashcard-review - Danh gia flashcard
GET    /api/v1/learn/stats            - Thong ke hoc tap
```

### Games

```
POST   /api/v1/games/quick-quiz/start    - Bat dau Quick Quiz
POST   /api/v1/games/quick-quiz/answer   - Tra loi cau hoi
POST   /api/v1/games/quick-quiz/skip     - Bo qua cau hoi
GET    /api/v1/games/quick-quiz/results  - Ket qua game

POST   /api/v1/games/image-matching/start
POST   /api/v1/games/image-matching/answer

POST   /api/v1/games/word-definition/start
POST   /api/v1/games/word-definition/answer
```

### Leaderboard (Phase 3)

```
GET    /api/v1/leaderboard/quiz/global       - Bang xep hang toan cau
GET    /api/v1/leaderboard/quiz/daily        - Bang xep hang theo ngay
GET    /api/v1/leaderboard/quiz/my-rank      - Xep hang cua toi
GET    /api/v1/leaderboard/streak/current    - Bang xep hang streak
GET    /api/v1/leaderboard/streak/best       - Bang xep hang streak tot nhat
GET    /api/v1/leaderboard/image-matching    - Image Matching leaderboard
GET    /api/v1/leaderboard/word-definition   - Word Definition leaderboard
```

### Streak

```
GET    /api/v1/streak                 - Lay thong tin streak
POST   /api/v1/streak/check-in        - Check-in hang ngay
```

### User Stats

```
GET    /api/v1/users/stats            - Thong ke nguoi dung
GET    /api/v1/users/profile          - Thong tin ca nhan
PUT    /api/v1/users/profile          - Cap nhat thong tin
```

## Testing

### Run Tests

```bash
# Run tat ca tests
./mvnw test

# Run mot test class
./mvnw test -Dtest=QuickQuizServiceTest

# Skip tests khi build
./mvnw clean install -DskipTests
```

### Test Coverage

```bash
./mvnw jacoco:report
```

## Redis Utilities

### Check Redis Connection

```bash
# Linux/Mac
./check-redis-keys.sh

# Windows
check-redis-keys.bat
```

### Redis CLI Commands

```bash
# Connect to Redis
docker exec -it card-words-redis redis-cli

# List all keys
KEYS cardwords:*

# Check leaderboard
ZREVRANGE cardwords:leaderboard:quickquiz:global 0 9 WITHSCORES

# Get user rank
ZRANK cardwords:leaderboard:quickquiz:global "user-uuid"

# Check cache TTL
TTL cardwords:user:email:test@example.com
```

## Performance Optimization

### Redis Caching Benefits

| Operation                   | Without Redis | With Redis | Improvement    |
| --------------------------- | ------------- | ---------- | -------------- |
| User Login                  | 100ms         | 5ms        | 95% faster     |
| Leaderboard Query (Top 100) | 500-1000ms    | 5-10ms     | 50-200x faster |
| Game Session Load           | 50ms          | 2ms        | 96% faster     |
| User Profile Lookup         | 30ms          | 1ms        | 97% faster     |

### Cache Strategies

-   **User Cache**: 30 minutes TTL
-   **Game Sessions**: 30 minutes TTL
-   **Leaderboard Global**: No expiration
-   **Leaderboard Daily**: 26 hours TTL
-   **Leaderboard Weekly**: 8 days TTL

## Troubleshooting

### Redis Connection Error

```bash
# Check if Redis is running
docker ps | grep redis

# Restart Redis
docker-compose restart redis

# Check logs
docker-compose logs redis
```

### Database Connection Error

```bash
# Check PostgreSQL
docker ps | grep postgres

# Test connection
psql -h localhost -U postgres -d card_words

# Check logs
docker-compose logs postgres
```

### Application Won't Start

```bash
# Check logs
tail -f app.log

# Verify environment variables
cat .env

# Clean rebuild
./mvnw clean install -DskipTests
```

## Project Structure

```
card-words/
├── src/main/java/com/thuanthichlaptrinh/card_words/
│   ├── common/                 # Constants, enums, exceptions, utils
│   ├── configuration/          # Spring configs (Security, JWT, Redis, Swagger)
│   ├── core/
│   │   ├── domain/            # JPA entities
│   │   ├── mapper/            # Entity <-> DTO mappers
│   │   ├── service/redis/     # Redis cache services
│   │   └── usecase/           # Business logic services
│   ├── dataprovider/
│   │   └── repository/        # JPA repositories
│   └── entrypoint/
│       ├── dto/               # Request/Response DTOs
│       └── rest/              # REST Controllers
├── src/main/resources/
│   ├── db/migration/          # Flyway SQL scripts
│   ├── data/                  # Initial vocabulary data
│   └── application.yml        # Application config
├── docs/                      # Documentation
├── docker-compose.yml         # Docker services
└── Dockerfile                 # App container image
```

## Documentation

Chi tiet trong folder `docs/`:

-   `REDIS_IMPLEMENTATION_PLAN.md` - Ke hoach Redis caching
-   `PHASE_3_LEADERBOARD_COMPLETE.md` - Tai lieu Phase 3
-   `STREAK_FEATURE_COMPLETED.md` - Tai lieu Streak System

---

## 📦 Backup & Restore Database

### ⚠️ QUAN TRỌNG: Data Portability

Khi mang code sang máy khác, Docker volumes sẽ **KHÔNG** được transfer tự động. Database sẽ chỉ có:

-   ✅ **Schema** (tables, constraints) - từ Flyway migrations
-   ✅ **2 roles** (ROLE_ADMIN, ROLE_USER) - từ DataInitializer
-   ✅ **2 admin accounts** (admin1@cardwords.com, admin2@cardwords.com) với password `Admin@123` - từ DataInitializer
-   ❌ **KHÔNG CÓ** user data, vocab, topics, game_sessions

### 🔄 Backup Database (Máy hiện tại)

**Trên máy có data:**

```bash
# Linux/Mac
./backup-database.sh

# Windows
backup-database.bat
```

-   File backup được lưu tại: `database-backups/card_words_YYYYMMDD_HHMMSS.sql`
-   Script tự động giữ 5 bản backup gần nhất

### 📥 Restore Database (Máy mới)

**Trên máy mới hoặc máy chưa có data:**

```bash
# 1. Start Docker containers
docker-compose up -d

# 2. Đợi app khởi động xong (check logs)
docker logs -f card-words-app
# Chờ đến khi thấy: "Started CardWordsApplication"

# 3. Restore database
# Linux/Mac:
./restore-database.sh database-backups/card_words_20250116_120000.sql

# Windows:
restore-database.bat database-backups\card_words_20250116_120000.sql
```

### 💡 Lưu ý khi di chuyển sang máy khác

1. **Copy các file cần thiết:**

    ```
    📁 card-words/
    ├── database-backups/         ← QUAN TRỌNG: Copy folder này
    │   └── card_words_*.sql
    ├── backup-database.sh        ← Script backup
    ├── restore-database.sh       ← Script restore
    ├── .env                      ← Environment variables
    └── docker-compose.yml
    ```

2. **Quy trình setup trên máy mới:**

    ```bash
    # Bước 1: Clone code
    git clone <your-repo>
    cd card-words

    # Bước 2: Copy file backup từ máy cũ (hoặc pull từ Git nếu đã commit)
    # database-backups/card_words_*.sql

    # Bước 3: Start Docker
    docker-compose up -d

    # Bước 4: Đợi app start xong
    docker logs -f card-words-app

    # Bước 5: Restore database
    ./restore-database.sh database-backups/card_words_*.sql

    # ✅ Done! Database đã có đầy đủ data
    ```

3. **Nếu không có file backup:**

    - Database sẽ rỗng (chỉ có schema và 2 admin accounts)
    - Cần import lại data từ PgAdmin hoặc SQL dump
    - Hoặc populate data mới qua API

### 🔒 Bảo mật file backup

**KHÔNG commit file backup vào Git nếu chứa:**

-   User passwords (ngay cả đã hash)
-   Sensitive user data (email, phone numbers)
-   Production data

**Khuyến nghị:**

-   Add vào `.gitignore`:
    ```gitignore
    database-backups/
    *.sql
    ```
-   Sử dụng secure storage (AWS S3, Google Drive, BitBucket Artifacts)
-   Encrypt backup files trước khi share

### 📊 Docker Volume Management (Nâng cao)

**Backup toàn bộ PostgreSQL volume:**

```bash
# Export volume
docker run --rm \
  -v card-words_postgres_data:/data \
  -v $(pwd):/backup \
  alpine tar czf /backup/postgres_volume.tar.gz -C /data .
```

**Restore volume:**

```bash
# Import volume
docker volume create card-words_postgres_data
docker run --rm \
  -v card-words_postgres_data:/data \
  -v $(pwd):/backup \
  alpine tar xzf /backup/postgres_volume.tar.gz -C /data
```

---

-   `GAME_ALGORITHMS_DESIGN.md` - Thuat toan game
-   `FLYWAY_MIGRATION_GUIDE.md` - Huong dan migration DB

## Contributing

1. Fork project
2. Tao branch moi: `git checkout -b feature/amazing-feature`
3. Commit changes: `git commit -m 'feat: Add amazing feature'`
4. Push len branch: `git push origin feature/amazing-feature`
5. Tao Pull Request

## License

MIT License - xem file LICENSE de biet them chi tiet

## Contact

-   **Author**: Ngo Minh Thuan (thuanthichlaptrinh)
-   **Email**: thuanthichlaptrinh@gmail.com
-   **GitHub**: https://github.com/thuanthichlaptrinh/card_words
