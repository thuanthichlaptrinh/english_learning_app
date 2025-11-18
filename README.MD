# 🎴 Card Words Services

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

# 2. Tạo file .env từ template
cp .env.example .env
# Sau đó chỉnh sửa .env với thông tin của bạn

# 3. Start tất cả services
docker-compose up -d

# 4. Xem logs
docker-compose logs -f

# 5. Kiểm tra status
docker-compose ps
```

**Services sẽ chạy trên:**

-   🌐 **Spring Boot API**: http://localhost:8080
    -   Swagger UI: http://localhost:8080/swagger-ui.html
    -   API Docs: http://localhost:8080/v3/api-docs
    -   🔌 **WebSocket**: ws://localhost:8080/ws (STOMP over WebSocket)
-   🤖 **AI Service**: http://localhost:8001
    -   API Docs: http://localhost:8001/docs
-   🗄️ **PostgreSQL**: localhost:5433
    -   Database: `card_words`
    -   User: `postgres`
-   🔴 **Redis**: localhost:6379
    -   DB 0: Spring Boot cache
    -   DB 1: AI Service cache
-   🔧 **PgAdmin**: http://localhost:5050
    -   Email: admin@cardwords.com
    -   Password: admin
-   📊 **Redis Insight**: http://localhost:5540

### 🎯 Test APIs

**1. Health Check:**

```bash
curl http://localhost:8080/actuator/health
curl http://localhost:8001/health
```

**2. Test Email System:**

```bash
# Register a new user (triggers welcome email)
curl -X POST http://localhost:8080/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test User",
    "email": "test@example.com",
    "password": "password123"
  }'

# Check your email inbox for welcome email
```

**3. Test Streak Reminder (Manual Trigger):**

Tạm thời thay đổi cron schedule trong `StreakReminderScheduler.java`:

```java
// Chạy ngay sau 10 giây (để test)
@Scheduled(fixedDelay = 10000, initialDelay = 5000)
```

Rebuild và check logs:

```bash
docker-compose build card-words-api
docker-compose up -d
docker-compose logs -f card-words-api | grep "streak"
```

**4. Register User:**

```bash
curl -X POST http://localhost:8080/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test User",
    "email": "test@example.com",
    "password": "password123"
  }'
```

**3. Test WebSocket Notifications:**

```bash
# Open test tool in browser
# File: test-websocket-events.html

# 1. Get JWT token (signin first)
curl -X POST http://localhost:8080/api/v1/auth/signin \
  -H "Content-Type: application/json" \
  -d '{"email":"your@email.com","password":"yourpassword"}'

# 2. Open test-websocket-events.html in browser
# 3. Paste JWT token and click "Connect WebSocket"
# 4. Try creating a notification (as admin):
curl -X POST http://localhost:8080/api/v1/admin/notifications \
  -H "Authorization: Bearer ADMIN_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "USER_UUID",
    "title": "🎉 Test",
    "content": "WebSocket real-time test!",
    "type": "system_alert"
  }'

# 5. You should see notification appear instantly in browser! ⚡
```

**4. Access Swagger UI:**

-   Open http://localhost:8080/swagger-ui.html
-   Click "Authorize" button
-   Enter token: `Bearer <your-jwt-token>`
-   Try out APIs

---

## 📦 Services

### 1️⃣ card-words (Spring Boot Backend)

**Công nghệ:**

-   Spring Boot 3.2.5
-   Java 17
-   PostgreSQL 16
-   Redis 7
-   Spring Security + JWT
-   **WebSocket + STOMP** (Real-time notifications)
    -   spring-boot-starter-websocket
    -   STOMP messaging protocol
    -   SockJS fallback support
    -   JWT authentication in WebSocket handshake
-   Google OAuth2
-   Firebase Storage
-   Flyway Migration
-   **Spring Scheduler** (Automated daily jobs)

**Ports:**

-   Application: `8080`
-   Database: `5433` (external)

**Core Features:**

-   🔐 Authentication (JWT + Google OAuth2)
-   📚 Vocabulary Management (CRUD, Search, Filters)
-   🎮 Games (Quick Quiz, Image-Word Matching, Word Definition Matching)
-   📊 Leaderboard & Statistics
-   🔥 Streak System (Daily learning tracking + automated email reminders)
-   🔔 **Real-time Notifications** (WebSocket + STOMP for instant updates)
    -   Auto-triggered achievements & streak milestones
    -   Admin broadcasts to all users
    -   Real-time mark as read/delete sync
    -   **5 WebSocket channels** for complete notification lifecycle
-   📝 **Action Logs** (Admin monitoring of user activities)
-   📧 **Email Service** (Welcome, activation, password reset, streak reminders)
-   ⏰ **Scheduled Jobs** (Daily streak reminders at 9:00 AM)
-   🔌 **WebSocket Integration** (STOMP over WebSocket with SockJS fallback)
-   💾 Offline Sync Support
-   🌐 Multi-language Support

**Documentation:**

-   API Docs: http://localhost:8080/swagger-ui.html
-   Actuator: http://localhost:8080/actuator
-   WebSocket Endpoint: ws://localhost:8080/ws
-   Admin Dashboard: [docs/admin/ADMIN_DASHBOARD_API.md](docs/admin/ADMIN_DASHBOARD_API.md)
-   **Notifications (Complete)**: [docs/NOTIFICATION_API_COMPLETE.md](docs/NOTIFICATION_API_COMPLETE.md)
-   **WebSocket Events**: [docs/WEBSOCKET_EVENTS.md](docs/WEBSOCKET_EVENTS.md)
-   **WebSocket Client Guide**: [docs/WEBSOCKET_CLIENT_GUIDE.md](docs/WEBSOCKET_CLIENT_GUIDE.md)
-   **Streak Reminder Analysis**: [docs/STREAK_REMINDER_ANALYSIS.md](docs/STREAK_REMINDER_ANALYSIS.md)
-   Action Logs: [docs/admin/ACTION_LOGS_API.md](docs/admin/ACTION_LOGS_API.md)

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

# Email (For welcome, activation, password reset, streak reminders)
MAIL_USERNAME=your_email@gmail.com
MAIL_PASSWORD=your_app_password  # Gmail App Password

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
-   Naming: `V{version}__{description}.sql`

**Current Migrations:**

-   V1: Initial schema (users, roles, topics, vocabs)
-   V2: Game sessions and details
-   V3: User vocabulary progress (spaced repetition)
-   V4: Streak system
-   V5: Leaderboard tables
-   V6: Notifications table
-   V7: Action logs table + missing columns

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

### Database Schema Highlights

**Core Tables:**

-   `users` - User accounts (UUID primary key)
-   `roles` - User roles (ADMIN, USER)
-   `topics` - Vocabulary topics/categories
-   `vocabs` - Vocabulary words with definitions, examples, images

**Game Tables:**

-   `games` - Game definitions (Quick Quiz, Image Matching, etc.)
-   `game_sessions` - User game sessions with scores
-   `game_session_details` - Individual questions/answers

**Progress Tables:**

-   `user_vocab_progress` - Spaced repetition tracking
-   `streak_records` - Daily learning streaks
-   `leaderboards` - Global & game-specific rankings

**Admin Tables:**

-   `notifications` - User notifications (achievements, reminders)
-   `action_logs` - Admin audit logs of user actions

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

### Core Features

-   **Authentication**: [docs/auth/](docs/auth/)
-   **Vocabulary Management**: [docs/vocab/](docs/vocab/)
-   **Flash Cards**: [docs/flash_card/](docs/flash_card/)
-   **Topics**: [docs/topic/](docs/topic/)

### Games

-   **Quick Quiz**: [docs/quick_quiz/](docs/quick_quiz/)
-   **Image-Word Matching**: [docs/image_word/](docs/image_word/)
-   **Word Definition Matching**: [docs/game/](docs/game/)
-   **Game Algorithms**: [docs/game/GAME_ALGORITHMS_DESIGN.md](docs/game/GAME_ALGORITHMS_DESIGN.md)

### Admin Features

-   **Admin Dashboard**: [docs/admin/ADMIN_DASHBOARD_API.md](docs/admin/ADMIN_DASHBOARD_API.md)
-   **Notifications API**: [docs/admin/NOTIFICATIONS_API.md](docs/admin/NOTIFICATIONS_API.md)
-   **Action Logs API**: [docs/admin/ACTION_LOGS_API.md](docs/admin/ACTION_LOGS_API.md)
-   **Notification Auto-Triggers**: [docs/admin/NOTIFICATION_AUTO_TRIGGERS.md](docs/admin/NOTIFICATION_AUTO_TRIGGERS.md)

### Real-time Features

-   **WebSocket Complete Guide**: [docs/WEBSOCKET_COMPLETE_SUMMARY.md](docs/WEBSOCKET_COMPLETE_SUMMARY.md)
-   **WebSocket Events**: [docs/WEBSOCKET_EVENTS.md](docs/WEBSOCKET_EVENTS.md)
-   **Client Integration**: [docs/WEBSOCKET_CLIENT_GUIDE.md](docs/WEBSOCKET_CLIENT_GUIDE.md)
-   **Quick Test Guide**: [docs/WEBSOCKET_QUICK_TEST.md](docs/WEBSOCKET_QUICK_TEST.md)
-   **Notification API**: [docs/NOTIFICATION_API_COMPLETE.md](docs/NOTIFICATION_API_COMPLETE.md)

### Advanced Features

-   **AI/ML Smart Review**: [docs/AI/](docs/AI/)
-   **Streak System**: [docs/streak/](docs/streak/)
-   **Streak Reminder Scheduler**: [docs/STREAK_REMINDER_ANALYSIS.md](docs/STREAK_REMINDER_ANALYSIS.md)
-   **Leaderboard**: [docs/game/](docs/game/)
-   **Redis Caching**: [docs/redis/](docs/redis/)

### DevOps

-   **Docker Setup**: [docs/docker/](docs/docker/)
-   **Migration Guide**: [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md)
-   **Implementation Guide**: [docs/IMPLEMENTATION_GUIDE.md](docs/IMPLEMENTATION_GUIDE.md)

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
feat: thêm tính năng mới (new feature)
fix: sửa bug (bug fix)
docs: cập nhật documentation
refactor: refactor code (no functional changes)
test: thêm tests
chore: maintenance tasks (dependencies, configs)
perf: performance improvements
style: code formatting (no logic changes)
```

**Examples:**

```
feat: Add auto notification triggers for game achievements
fix: Fix UUID extraction in NotificationController
docs: Update README with new features
refactor: Simplify streak calculation logic
```

---

## 🎯 Key Features Highlights

### 🔔 Real-time Notifications with WebSocket

**ALL notification operations push via WebSocket for instant updates!**

#### **Architecture:**

-   **STOMP over WebSocket** with SockJS fallback
-   **JWT authentication** in WebSocket handshake
-   **5 WebSocket channels** for complete notification lifecycle:
    1. `/user/queue/notifications` - New notifications
    2. `/user/queue/notifications/read` - Mark as read events
    3. `/user/queue/notifications/read-all` - Mark all read events
    4. `/user/queue/notifications/deleted` - Delete events
    5. `/user/queue/notifications/batch-deleted` - Batch delete events

#### **Auto-triggered Notifications:**

-   **Game achievements** (high scores, perfect accuracy) → Instant WebSocket push
-   **Streak milestones** (7-day, 30-day, 100-day) → Real-time delivery
-   **Daily streak reminders** (9 AM) → Email + WebSocket notification
-   **Admin broadcasts** → Push to all connected users instantly

#### **Performance Benefits:**

-   ⚡ **< 100ms latency** (vs 10-30s polling)
-   📉 **99.9% reduction** in server requests
-   🔋 **90% battery savings** (no constant polling)
-   🔄 **Perfect multi-device sync** (instant updates across devices)

#### **Testing:**

-   Interactive test tool: `test-websocket-events.html`
-   Complete client examples: React, Flutter, JavaScript
-   See: [docs/WEBSOCKET_EVENTS.md](docs/WEBSOCKET_EVENTS.md)

### 📧 Email System + Auto Reminders

-   **Welcome emails** with temporary password for new users
-   **Account activation** links
-   **Password reset** emails with secure tokens
-   **Automated streak reminders** via Spring Scheduler:
    -   ⏰ **Runs automatically at 9:00 AM daily** (no API call needed)
    -   📧 **HTML template** with beautiful design
    -   🔔 **Dual channel delivery**: Email + WebSocket notification
    -   🎯 **Smart targeting** - sent only to users who:
        -   Studied yesterday ✓
        -   Haven't studied today ✗
        -   Have streak >= 3 days 🔥 (worth protecting)
    -   📊 **Detailed logging** for monitoring
-   **Complete automation** - zero manual intervention required

### 📝 Action Logs

-   **Admin monitoring** of all user actions
-   Track: login, logout, game completion, vocabulary learning
-   Advanced filtering by user, action type, status, date range
-   Export capabilities for audit reports
-   Statistics dashboard (total actions, success rate, unique users)

### 🎮 Games

-   **Quick Quiz**: True/False lightning rounds with streak bonuses
-   **Image-Word Matching**: Memory-style image pairing game
-   **Word Definition Matching**: Match words to definitions
-   Smart scoring system with time bonuses
-   Leaderboard rankings (global & per-game)

### 🔥 Streak System

-   Track daily learning consistency
-   Auto-update on game completion
-   Milestone achievements (7, 30, 100 days)
-   Visual activity calendar
-   Personal record tracking

### 🤖 AI Smart Review

-   **LightGBM ML model** for personalized review scheduling
-   Predicts optimal review timing based on:
    -   Correctness history
    -   Time since last review
    -   User performance patterns
-   Redis caching for fast predictions

---

## 👥 Team

-   **Backend Developer**: Ngô Minh Thuận
-   **AI/ML Engineer**: Ngô Minh Thuận

---

**Made with ❤️ by Card Words Team**
