# 🎴 Card Words Platform

> Enterprise-grade vocabulary learning platform with AI-powered spaced repetition, real-time notifications, and gamification features.

[![Java](https://img.shields.io/badge/Java-17-orange)](https://www.oracle.com/java/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.2.5-brightgreen)](https://spring.io/projects/spring-boot)
[![Python](https://img.shields.io/badge/Python-3.11-blue)](https://www.python.org/)
[![FastAPI](https://img.shields.io/badge/FastAPI-Latest-009688)](https://fastapi.tiangolo.com/)
[![Docker](https://img.shields.io/badge/Docker-Compose-2496ED)](https://www.docker.com/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-336791)](https://www.postgresql.org/)
[![Redis](https://img.shields.io/badge/Redis-7-DC382D)](https://redis.io/)

---

## 📖 Table of Contents

-   [Overview](#-overview)
-   [Architecture](#-architecture)
-   [Quick Start](#-quick-start)
-   [Services](#-services)
-   [Key Features](#-key-features)
-   [Configuration](#️-configuration)
-   [Development](#-development)
-   [Database](#️-database)
-   [API Documentation](#-api-documentation)
-   [Troubleshooting](#️-troubleshooting)
-   [Contributing](#-contributing)

---

## 🌟 Overview

**Card Words Platform** is a comprehensive vocabulary learning system that combines:

-   **Spring Boot Backend**: RESTful API with real-time WebSocket notifications
-   **AI Service**: LightGBM-powered smart review predictions
-   **PostgreSQL**: Robust relational database with Flyway migrations
-   **Redis**: High-performance caching and session management
-   **Docker**: Containerized deployment for all services

### Core Capabilities

✅ **Authentication & Authorization** - JWT + OAuth2 (Google)  
✅ **Vocabulary Management** - CRUD operations with rich metadata  
✅ **Spaced Repetition** - SM-2 algorithm for optimal learning  
✅ **Real-time Notifications** - WebSocket + STOMP protocol  
✅ **Gamification** - Multiple game modes with leaderboards  
✅ **AI-Powered Reviews** - Machine learning predictions  
✅ **Automated Reminders** - Daily streak emails via scheduler  
✅ **Admin Dashboard** - User monitoring and analytics  
✅ **Offline Sync** - Mobile-friendly data synchronization

---

## 🏗 Architecture

### Project Structure

```
card-words-platform/
├── 📁 card-words/              # Spring Boot Backend API
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/            # Application code
│   │   │   └── resources/       # Configurations & migrations
│   │   └── test/                # Unit & integration tests
│   ├── pom.xml                  # Maven dependencies
│   ├── Dockerfile               # Multi-stage build
│   └── docker-compose.yml       # Service-specific compose
│
├── 📁 card-words-ai/           # Python AI Service
│   ├── app/
│   │   ├── api/                 # FastAPI endpoints
│   │   ├── core/                # Business logic
│   │   ├── db/                  # Database connections
│   │   └── middleware/          # Authentication & logging
│   ├── models/                  # LightGBM trained models
│   ├── pyproject.toml           # Poetry dependencies
│   └── Dockerfile               # Python container build
│
├── 📁 docs/                    # Comprehensive documentation
│   ├── admin/                   # Admin features
│   ├── AI/                      # ML model documentation
│   ├── auth/                    # Authentication guides
│   ├── docker/                  # Deployment guides
│   └── ...                      # Feature-specific docs
│
├── docker-compose.yml           # 🔥 Root orchestration (all services)
├── .env                         # 🔐 Environment variables (gitignored)
├── .gitignore                   # Git exclusions
└── README.MD                    # This file
```

### Technology Stack

| Component         | Technology   | Version | Purpose                        |
| ----------------- | ------------ | ------- | ------------------------------ |
| **Backend API**   | Spring Boot  | 3.2.5   | RESTful API & WebSocket server |
| **Language**      | Java         | 17      | Primary programming language   |
| **AI Service**    | FastAPI      | Latest  | ML prediction endpoints        |
| **ML Engine**     | LightGBM     | Latest  | Smart review predictions       |
| **Database**      | PostgreSQL   | 16      | Primary data store             |
| **Cache**         | Redis        | 7       | Session & performance caching  |
| **Message Queue** | STOMP        | -       | WebSocket messaging            |
| **Build Tool**    | Maven        | 3.9+    | Java dependency management     |
| **Migration**     | Flyway       | -       | Database schema versioning     |
| **Container**     | Docker       | Latest  | Service orchestration          |
| **Auth**          | JWT + OAuth2 | -       | Authentication & authorization |

---

## 🚀 Quick Start

### Prerequisites

Ensure you have the following installed:

-   **Docker Desktop** 20.10+ (or Docker Engine + Docker Compose)
-   **Git** for version control

**Optional (for local development):**

-   Java 17+ (Eclipse Temurin recommended)
-   Maven 3.9+
-   Python 3.11+ with Poetry
-   Node.js 18+ (for frontend integration)

### Installation

#### 1. Clone Repository

```bash
git clone https://github.com/yourusername/card-words-platform.git
cd card-words-platform
```

#### 2. Configure Environment

```bash
# Copy template
cp .env.example .env

# Edit with your credentials
# Required: Database password, JWT secret, email credentials
nano .env  # or use your preferred editor
```

#### 3. Start All Services

```bash
# Build and start all containers
docker-compose up -d --build

# View logs
docker-compose logs -f

# Check service health
docker-compose ps
```

#### 4. Verify Deployment

```bash
# Backend API health
curl http://localhost:8080/actuator/health

# AI Service health
curl http://localhost:8001/health

# Database connection
docker-compose exec postgres pg_isready -U postgres
```

### Access Services

| Service             | URL                                   | Credentials                 |
| ------------------- | ------------------------------------- | --------------------------- |
| **Spring Boot API** | http://localhost:8080                 | JWT token required          |
| Swagger UI          | http://localhost:8080/swagger-ui.html | -                           |
| API Documentation   | http://localhost:8080/v3/api-docs     | -                           |
| Actuator            | http://localhost:8080/actuator        | -                           |
| **WebSocket**       | ws://localhost:8080/ws                | JWT in handshake            |
| **AI Service**      | http://localhost:8001                 | Shared JWT auth             |
| AI Documentation    | http://localhost:8001/docs            | -                           |
| **PostgreSQL**      | localhost:5433                        | `postgres` / see `.env`     |
| **Redis**           | localhost:6379                        | No password                 |
| **PgAdmin**         | http://localhost:5050                 | admin@cardwords.com / admin |
| **Redis Insight**   | http://localhost:5540                 | -                           |

### Quick API Test

#### 1. Register User

```bash
curl -X POST http://localhost:8080/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Doe",
    "email": "john@example.com",
    "password": "SecurePass123!"
  }'
```

#### 2. Sign In

```bash
curl -X POST http://localhost:8080/api/v1/auth/signin \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john@example.com",
    "password": "SecurePass123!"
  }'
```

**Response:**

```json
{
    "token": "eyJhbGciOiJIUzI1NiIs...",
    "type": "Bearer",
    "email": "john@example.com",
    "name": "John Doe"
}
```

#### 3. Test Authenticated Endpoint

```bash
curl -X GET http://localhost:8080/api/v1/vocabs \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

#### 4. Test WebSocket Connection

Open `test-websocket-events.html` in your browser:

1. Paste your JWT token
2. Click "Connect WebSocket"
3. Subscribe to notification channels
4. Trigger a notification (e.g., complete a game)
5. See real-time updates! ⚡

---

## 📦 Services

### Spring Boot Backend (card-words)

**Core Technologies:**

-   Spring Boot 3.2.5 (Java 17)
-   Spring Security + JWT Authentication
-   Spring WebSocket + STOMP Messaging
-   Spring Data JPA + Hibernate
-   Spring Scheduler (Automated tasks)
-   PostgreSQL 16 (Primary database)
-   Redis 7 (Caching layer)
-   Flyway (Database migrations)
-   Firebase Storage (Image uploads)
-   Google OAuth2 (Social login)
-   JavaMailSender (Email service)

**Key Features:**

🔐 **Authentication & Authorization**

-   JWT-based authentication with refresh tokens
-   Google OAuth2 integration
-   Role-based access control (ADMIN, USER)
-   Secure password hashing with BCrypt

📚 **Vocabulary Management**

-   CRUD operations for words and topics
-   Rich metadata (definitions, examples, images)
-   Advanced search and filtering
-   Multi-language support

🎮 **Interactive Games**

-   Quick Quiz (True/False with streak bonuses)
-   Image-Word Matching (Memory game)
-   Word Definition Matching
-   Real-time leaderboards
-   Score calculation with time bonuses

📊 **Learning Progress**

-   SM-2 spaced repetition algorithm
-   Vocabulary mastery tracking
-   Progress analytics and statistics
-   Personalized review scheduling

🔥 **Streak System**

-   Daily learning consistency tracking
-   Automatic streak updates
-   Milestone achievements (7, 30, 100 days)
-   Visual activity calendar
-   Personal best records

🔔 **Real-time Notifications**

-   WebSocket + STOMP protocol
-   5 dedicated notification channels
-   Instant multi-device synchronization
-   Auto-triggered achievements
-   Admin broadcast capabilities

📧 **Email Automation**

-   Welcome emails for new users
-   Account activation links
-   Password reset with secure tokens
-   Daily streak reminders (9:00 AM)
-   Beautiful HTML templates

📝 **Admin Dashboard**

-   User activity monitoring
-   Action logs with detailed tracking
-   System statistics and analytics
-   Notification management
-   User management tools

💾 **Offline Sync Support**

-   Batch data download endpoints
-   Conflict resolution strategies
-   Delta synchronization
-   Mobile-optimized responses

**API Endpoints:** `http://localhost:8080/api/v1/`

**Documentation:**

-   Swagger UI: `/swagger-ui.html`
-   OpenAPI Spec: `/v3/api-docs`
-   WebSocket Guide: `docs/WEBSOCKET_EVENTS.md`
-   Notification API: `docs/NOTIFICATION_API_COMPLETE.md`

---

### AI Service (card-words-ai)

**Core Technologies:**

-   Python 3.11
-   FastAPI (High-performance API framework)
-   LightGBM (Gradient boosting ML library)
-   PostgreSQL (Read-only database access)
-   Redis (Prediction caching)
-   SQLAlchemy (Database ORM)
-   Pydantic (Data validation)
-   Poetry (Dependency management)

**Key Features:**

🤖 **Smart Review Predictions**

-   LightGBM machine learning model
-   Predicts optimal review timing
-   Considers user performance patterns
-   Adapts to individual learning curves

⚡ **Performance Optimization**

-   Redis caching for predictions
-   Asynchronous database queries
-   Connection pooling
-   Response time < 100ms

🔐 **Security**

-   JWT authentication (shared with Spring Boot)
-   Read-only database access
-   Request rate limiting
-   Input validation with Pydantic

📊 **Model Features**

-   User correctness history
-   Time since last review
-   Vocabulary difficulty
-   User performance metrics
-   Streak consistency

**API Endpoints:** `http://localhost:8001/api/`

**Documentation:**

-   Interactive Docs: `/docs`
-   ReDoc: `/redoc`
-   Model Details: `docs/AI/`

---

## 🎯 Key Features

### 1. Real-time Notifications with WebSocket

**Complete push notification system with zero polling overhead.**

#### Architecture

-   **Protocol**: STOMP over WebSocket with SockJS fallback
-   **Authentication**: JWT token in handshake header
-   **Latency**: < 100ms end-to-end
-   **Scalability**: Supports thousands of concurrent connections

#### Notification Channels

| Channel                                   | Purpose           | Trigger                              |
| ----------------------------------------- | ----------------- | ------------------------------------ |
| `/user/queue/notifications`               | New notifications | Achievement, reminder, admin message |
| `/user/queue/notifications/read`          | Mark as read      | User marks single notification read  |
| `/user/queue/notifications/read-all`      | Mark all read     | User marks all notifications read    |
| `/user/queue/notifications/deleted`       | Single delete     | User deletes notification            |
| `/user/queue/notifications/batch-deleted` | Batch delete      | User deletes multiple notifications  |

#### Auto-triggered Notifications

✨ **Game Achievements** (Instant delivery)

-   Perfect accuracy (100%)
-   High score milestones
-   Speed completion bonuses

🔥 **Streak Milestones** (Real-time updates)

-   7-day consistency
-   30-day dedication
-   100-day mastery

📧 **Daily Reminders** (Dual delivery)

-   Scheduled at 9:00 AM
-   Email + WebSocket notification
-   Smart targeting (users with streaks ≥ 3 days)

📢 **Admin Broadcasts** (Push to all users)

-   System announcements
-   Platform updates
-   Maintenance notices

#### Performance Benefits

| Metric            | Polling  | WebSocket | Improvement         |
| ----------------- | -------- | --------- | ------------------- |
| Latency           | 10-30s   | < 100ms   | **99.7% faster**    |
| Server Requests   | 360/hour | 1/session | **99.9% reduction** |
| Battery Impact    | High     | Minimal   | **~90% savings**    |
| Multi-device Sync | Delayed  | Instant   | **Real-time**       |

**Testing Tools:**

-   Interactive test: `test-websocket-events.html`
-   Client examples: React, Flutter, JavaScript
-   See: `docs/WEBSOCKET_EVENTS.md`

---

### 2. Automated Email System

**Fully automated email delivery with beautiful HTML templates.**

#### Email Types

📧 **Welcome Email**

-   Sent on user registration
-   Includes temporary password
-   Platform introduction

🔑 **Account Activation**

-   Secure activation link
-   24-hour expiration
-   Email verification

🔒 **Password Reset**

-   Secure reset token
-   One-time use link
-   1-hour expiration

⏰ **Daily Streak Reminders**

-   Automated schedule: 9:00 AM daily
-   Smart targeting criteria:
    -   ✅ Studied yesterday
    -   ❌ Haven't studied today
    -   🔥 Streak ≥ 3 days (worth protecting)
-   Dual delivery: Email + WebSocket
-   Beautiful HTML template
-   Zero manual intervention

#### Configuration

```properties
# Gmail SMTP (recommended)
spring.mail.host=smtp.gmail.com
spring.mail.port=587
spring.mail.username=your-email@gmail.com
spring.mail.password=your-app-password  # Use App Password, not account password
```

**Setup Guide:** Generate Gmail App Password at https://myaccount.google.com/apppasswords

---

### 3. AI-Powered Spaced Repetition

**LightGBM machine learning model for personalized review scheduling.**

#### Algorithm: SM-2 Enhanced with ML

**Traditional SM-2 Parameters:**

-   `EF` (Easiness Factor): 1.3 - 2.5
-   `Interval`: Days until next review
-   `Repetition`: Number of successful reviews

**ML Enhancements:**

-   User performance patterns
-   Time-of-day effectiveness
-   Vocabulary difficulty
-   Historical accuracy trends

#### Prediction Process

```
User Request → Model Features → LightGBM Prediction → Redis Cache → Response
                ↓
        [correctness_rate, time_since_last, vocab_difficulty, user_streak]
```

#### Performance

-   **Prediction Time**: < 50ms (cached: < 5ms)
-   **Model Accuracy**: ~85% (F1 score)
-   **Cache Hit Rate**: > 90%
-   **Features**: 15 engineered features

**Model Training:** `card-words-ai/train-model.sh`

---

### 4. Admin Dashboard

**Comprehensive monitoring and management tools.**

#### Features

📊 **Analytics**

-   Total users and growth
-   Active sessions
-   Game completion rates
-   Learning progress metrics

📝 **Action Logs**

-   User activity tracking
-   Login/logout events
-   Game completions
-   Vocabulary interactions
-   Advanced filtering by date, user, action type

🔔 **Notification Management**

-   Create system notifications
-   Broadcast to all users
-   Targeted user notifications
-   View notification history

👥 **User Management**

-   View user profiles
-   Activity monitoring
-   Role assignment
-   Account status management

**Documentation:** `docs/admin/ADMIN_DASHBOARD_API.md`

---

### 5. Gamification System

**Multiple game modes with intelligent scoring and leaderboards.**

#### Game Modes

🎯 **Quick Quiz**

-   True/False format
-   10 questions per session
-   Time bonus: +10 points if < 5 seconds
-   Streak bonus: +5 points per consecutive correct answer
-   Perfect score achievement: 100% accuracy

🖼️ **Image-Word Matching**

-   Memory-style card game
-   Match words to images
-   Time-based scoring
-   Difficulty levels

📖 **Word Definition Matching**

-   Match words to definitions
-   Multiple choice format
-   Adaptive difficulty

#### Scoring Algorithm

```
Base Score = Correct Answers × 100
Time Bonus = Fast Answers × 10
Streak Bonus = Consecutive Correct × 5
Final Score = Base + Time Bonus + Streak Bonus
```

#### Leaderboards

-   **Global**: All-time top scores
-   **Game-specific**: Per-game rankings
-   **Time-based**: Daily, weekly, monthly
-   **Personal**: Individual progress tracking

**Documentation:** `docs/game/GAME_ALGORITHMS_DESIGN.md`

---

## ⚙️ Configuration

### Environment Variables

Create `.env` file in project root:

```env
#─────────────────────────────────────
# Application Ports
#─────────────────────────────────────
SERVER_SPRING_PORT=8080
SERVER_FLASH_PORT=8001

#─────────────────────────────────────
# Database Configuration
#─────────────────────────────────────
POSTGRES_DB=card_words
POSTGRES_USER=postgres
POSTGRES_PASSWORD=your_secure_password_here
POSTGRES_EXTERNAL_PORT=5433

#─────────────────────────────────────
# Redis Configuration
#─────────────────────────────────────
REDIS_EXTERNAL_PORT=6379
REDIS_AI_DB=1  # AI service uses DB 1, Spring Boot uses DB 0

#─────────────────────────────────────
# JWT Authentication
#─────────────────────────────────────
JWT_SECRET=your_jwt_secret_key_min_256_bits
JWT_EXPIRATION=86400000  # 24 hours in milliseconds

#─────────────────────────────────────
# Email Configuration (Gmail)
#─────────────────────────────────────
MAIL_USERNAME=your_email@gmail.com
MAIL_PASSWORD=your_gmail_app_password  # NOT your Gmail password!

#─────────────────────────────────────
# Google OAuth2
#─────────────────────────────────────
GOOGLE_OAUTH_CLIENT_ID=your_client_id.apps.googleusercontent.com
GOOGLE_OAUTH_CLIENT_SECRET=your_client_secret
GOOGLE_OAUTH_REDIRECT_URI=http://localhost:8080/api/v1/auth/google/callback

#─────────────────────────────────────
# Firebase Storage
#─────────────────────────────────────
FIREBASE_STORAGE_BUCKET=your_project.appspot.com
FIREBASE_SERVICE_ACCOUNT_PATH=/path/to/service-account.json

#─────────────────────────────────────
# Admin Tools
#─────────────────────────────────────
PGADMIN_DEFAULT_EMAIL=admin@cardwords.com
PGADMIN_DEFAULT_PASSWORD=admin
```

**⚠️ Security Notice:** Never commit `.env` to version control. Use `.env.example` as template.

---

## 🔧 Development

### Local Development (Without Docker)

#### 1. Spring Boot Backend

```bash
cd card-words

# Install dependencies
mvn clean install

# Run with hot reload
mvn spring-boot:run

# Or run JAR
mvn clean package -DskipTests
java -jar target/card-words-0.0.1-SNAPSHOT.jar
```

**Access:** http://localhost:8080

#### 2. AI Service

```bash
cd card-words-ai

# Install Poetry (if not installed)
curl -sSL https://install.python-poetry.org | python3 -

# Install dependencies
poetry install

# Activate virtual environment
poetry shell

# Run with hot reload
poetry run uvicorn app.main:app --reload --port 8001
```

**Access:** http://localhost:8001

#### 3. Database Setup

```bash
# Start only PostgreSQL and Redis
docker-compose up -d postgres redis

# Verify connection
psql -h localhost -p 5433 -U postgres -d card_words
```

### Docker Development

#### Build Services

```bash
# Build all services
docker-compose build

# Build specific service
docker-compose build card-words-api
docker-compose build card-words-ai

# Build with no cache (clean build)
docker-compose build --no-cache card-words-api
```

#### Run Services

```bash
# Start all services
docker-compose up -d

# Start specific services
docker-compose up -d postgres redis card-words-api

# View logs
docker-compose logs -f card-words-api

# Follow logs from all services
docker-compose logs -f
```

#### Stop Services

```bash
# Stop all services
docker-compose stop

# Stop specific service
docker-compose stop card-words-api

# Stop and remove containers
docker-compose down

# Remove containers and volumes (⚠️ DELETES DATA)
docker-compose down -v
```

### Testing

#### Spring Boot Tests

```bash
cd card-words

# Run all tests
mvn test

# Run specific test class
mvn test -Dtest=VocabServiceTest

# Run with coverage
mvn clean test jacoco:report
```

#### AI Service Tests

```bash
cd card-words-ai

# Run all tests
poetry run pytest

# Run with coverage
poetry run pytest --cov=app

# Run specific test
poetry run pytest tests/test_predictions.py
```

---

## 🗄️ Database

### Schema Management

**Flyway migrations** manage all schema changes:

-   **Location:** `card-words/src/main/resources/db/migration/`
-   **Auto-run:** On application startup
-   **Naming:** `V{version}__{description}.sql`
-   **Versioning:** Sequential (V1, V2, V3, ...)

#### Migration History

| Version | Description       | Tables Added                                     |
| ------- | ----------------- | ------------------------------------------------ |
| V1      | Initial schema    | `users`, `roles`, `topics`, `vocabs`             |
| V2      | Games system      | `games`, `game_sessions`, `game_session_details` |
| V3      | Learning progress | `user_vocab_progress` (SM-2 algorithm)           |
| V4      | Streak tracking   | `streak_records`                                 |
| V5      | Leaderboards      | `leaderboards`, `game_leaderboards`              |
| V6      | Notifications     | `notifications`                                  |
| V7      | Admin tools       | `action_logs` + missing columns                  |

#### Create New Migration

```bash
cd card-words/src/main/resources/db/migration

# Create new file
touch V8__add_user_preferences.sql
```

```sql
-- V8__add_user_preferences.sql
CREATE TABLE user_preferences (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    theme VARCHAR(20) DEFAULT 'light',
    language VARCHAR(10) DEFAULT 'en',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_user_preferences_user_id ON user_preferences(user_id);
```

### Backup & Restore

#### Automated Backups

```bash
cd card-words

# Windows
./backup-database.bat

# Linux/Mac
chmod +x backup-database.sh
./backup-database.sh
```

**Backup location:** `card-words/database-backups/card_words_YYYYMMDD_HHMMSS.sql`

#### Automated Daily Backups

```bash
# Windows Task Scheduler
./auto-backup.bat

# Linux Cron
chmod +x auto-backup.sh
crontab -e
# Add: 0 2 * * * /path/to/auto-backup.sh  # Daily at 2 AM
```

#### Restore from Backup

```bash
cd card-words

# Windows
./restore-database.bat database-backups/card_words_20251119_090000.sql

# Linux/Mac
./restore-database.sh database-backups/card_words_20251119_090000.sql
```

### Database Schema

#### Core Tables

**users** - User accounts

```sql
- id (UUID, PK)
- email (VARCHAR, UNIQUE)
- password (VARCHAR, hashed)
- name (VARCHAR)
- avatar_url (VARCHAR)
- created_at (TIMESTAMP)
- updated_at (TIMESTAMP)
```

**vocabs** - Vocabulary words

```sql
- id (UUID, PK)
- word (VARCHAR)
- meaning (TEXT)
- example (TEXT)
- image_url (VARCHAR)
- topic_id (UUID, FK → topics)
- difficulty (VARCHAR)
- created_at (TIMESTAMP)
```

**user_vocab_progress** - SM-2 spaced repetition

```sql
- id (UUID, PK)
- user_id (UUID, FK → users)
- vocab_id (UUID, FK → vocabs)
- status (VARCHAR: KNOWN, UNKNOWN, MASTERED)
- last_reviewed (DATE)
- times_correct (INTEGER)
- times_wrong (INTEGER)
- ef_factor (DECIMAL)  # Easiness Factor
- interval_days (INTEGER)
- repetition (INTEGER)
- next_review_date (DATE)
- created_at (TIMESTAMP)
- updated_at (TIMESTAMP)
```

**notifications** - User notifications

```sql
- id (UUID, PK)
- user_id (UUID, FK → users)
- title (VARCHAR)
- content (TEXT)
- type (VARCHAR)
- is_read (BOOLEAN)
- created_at (TIMESTAMP)
```

**Full schema:** See migrations in `card-words/src/main/resources/db/migration/`

---

## 📚 API Documentation

### Swagger UI

Interactive API documentation with try-it-out functionality:

**URL:** http://localhost:8080/swagger-ui.html

**Features:**

-   Complete endpoint listing
-   Request/response schemas
-   Authentication testing
-   Live API calls

### OpenAPI Specification

**URL:** http://localhost:8080/v3/api-docs

**Format:** JSON (OpenAPI 3.0)

### Postman Collection

Import collection from: `docs/postman/Card-Words-API.postman_collection.json`

### API Endpoint Categories

#### Authentication (`/api/v1/auth`)

-   `POST /register` - User registration
-   `POST /signin` - JWT authentication
-   `POST /google` - OAuth2 login
-   `POST /refresh` - Refresh token
-   `POST /forgot-password` - Request password reset
-   `POST /reset-password` - Reset password with token

#### Vocabularies (`/api/v1/vocabs`)

-   `GET /` - List vocabularies (paginated, filterable)
-   `GET /{id}` - Get vocabulary details
-   `POST /` - Create vocabulary (ADMIN)
-   `PUT /{id}` - Update vocabulary (ADMIN)
-   `DELETE /{id}` - Delete vocabulary (ADMIN)
-   `GET /search` - Search vocabularies

#### Games (`/api/v1/games`)

-   `GET /` - List available games
-   `POST /sessions` - Start game session
-   `POST /sessions/{id}/answers` - Submit answer
-   `POST /sessions/{id}/complete` - Complete session
-   `GET /sessions/{id}` - Get session results
-   `GET /leaderboard` - Global leaderboard
-   `GET /{gameId}/leaderboard` - Game-specific leaderboard

#### Notifications (`/api/v1/notifications`)

-   `GET /` - List user notifications
-   `GET /unread-count` - Get unread count
-   `PATCH /{id}/read` - Mark as read
-   `PATCH /read-all` - Mark all as read
-   `DELETE /{id}` - Delete notification
-   `DELETE /batch` - Batch delete

#### Admin (`/api/v1/admin`)

-   `GET /users` - List all users
-   `GET /dashboard/stats` - Dashboard statistics
-   `GET /action-logs` - User activity logs
-   `POST /notifications` - Create notification
-   `POST /notifications/broadcast` - Broadcast to all users

#### Offline Sync (`/api/v1/offline`)

-   `GET /user-vocab-progress` - Download all progress
-   `GET /user-vocab-progress/topic/{id}` - Download by topic
-   `GET /user-vocab-progress/due-review` - Download due reviews

### WebSocket Endpoints

**Connection:** `ws://localhost:8080/ws`

**Subscriptions:**

```javascript
// New notifications
stompClient.subscribe('/user/queue/notifications', callback);

// Mark as read events
stompClient.subscribe('/user/queue/notifications/read', callback);

// Mark all read events
stompClient.subscribe('/user/queue/notifications/read-all', callback);

// Delete events
stompClient.subscribe('/user/queue/notifications/deleted', callback);

// Batch delete events
stompClient.subscribe('/user/queue/notifications/batch-deleted', callback);
```

**Documentation:**

-   Complete guide: `docs/WEBSOCKET_EVENTS.md`
-   Client examples: `docs/WEBSOCKET_CLIENT_GUIDE.md`
-   Quick test: `test-websocket-events.html`

---

## 🛠️ Troubleshooting

### Common Issues

#### 1. Containers Won't Start

```bash
# Check container status
docker-compose ps

# View error logs
docker-compose logs --tail=50

# Stop all services
docker-compose down

# Remove volumes (⚠️ DELETES DATA)
docker-compose down -v

# Rebuild and restart
docker-compose up -d --build
```

#### 2. Port Already in Use

```bash
# Windows: Find process using port
netstat -ano | findstr :8080
# Kill process by PID
taskkill /PID <process_id> /F

# Linux/Mac: Find and kill process
lsof -ti:8080 | xargs kill -9

# Or change port in .env
SERVER_SPRING_PORT=8081
```

#### 3. Database Connection Failed

```bash
# Check PostgreSQL logs
docker-compose logs postgres

# Verify PostgreSQL is running
docker-compose ps postgres

# Test connection
docker-compose exec postgres psql -U postgres -d card_words -c 'SELECT 1;'

# Check network
docker network inspect server_default
```

#### 4. Migration Errors

```bash
# View Flyway status
docker-compose logs card-words-api | grep Flyway

# Repair Flyway schema
docker-compose exec card-words-api \
  mvn flyway:repair -Dflyway.url=jdbc:postgresql://postgres:5432/card_words

# Reset database (⚠️ DELETES ALL DATA)
docker-compose down -v
docker-compose up -d
```

#### 5. Email Not Sending

```bash
# Check email configuration
docker-compose logs card-words-api | grep "mail"

# Verify Gmail App Password
# 1. Enable 2-Step Verification on Google Account
# 2. Generate App Password: https://myaccount.google.com/apppasswords
# 3. Update MAIL_PASSWORD in .env
# 4. Restart service: docker-compose restart card-words-api
```

#### 6. WebSocket Connection Failed

```bash
# Check WebSocket endpoint
curl -i -N -H "Connection: Upgrade" \
  -H "Upgrade: websocket" \
  -H "Sec-WebSocket-Version: 13" \
  -H "Sec-WebSocket-Key: test" \
  http://localhost:8080/ws

# Enable debug logging
# Add to application.properties:
logging.level.org.springframework.web.socket=DEBUG

# Restart and check logs
docker-compose restart card-words-api
docker-compose logs -f card-words-api | grep WebSocket
```

#### 7. AI Service Predictions Failing

```bash
# Check AI service logs
docker-compose logs card-words-ai

# Verify model files exist
docker-compose exec card-words-ai ls -la /app/models/

# Test prediction endpoint
curl http://localhost:8001/api/predict \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"user_id": "uuid", "vocab_id": "uuid"}'

# Retrain model if necessary
cd card-words-ai
./train-model.sh
```

### Health Checks

```bash
# Spring Boot actuator
curl http://localhost:8080/actuator/health | jq

# AI Service health
curl http://localhost:8001/health | jq

# PostgreSQL
docker-compose exec postgres pg_isready -U postgres

# Redis
docker-compose exec redis redis-cli ping

# All services
docker-compose ps
```

### Performance Monitoring

```bash
# Spring Boot metrics
curl http://localhost:8080/actuator/metrics | jq

# Database performance
docker-compose exec postgres psql -U postgres -d card_words -c '\
  SELECT pid, usename, application_name, state, query \
  FROM pg_stat_activity WHERE state = '\''active'\'';'

# Redis stats
docker-compose exec redis redis-cli INFO stats

# Docker resource usage
docker stats
```

---

## 🤝 Contributing

### Development Workflow

#### 1. Create Feature Branch

```bash
# Update main branch
git checkout main
git pull origin main

# Create feature branch
git checkout -b feature/your-feature-name

# For bug fixes
git checkout -b fix/bug-description

# For documentation
git checkout -b docs/documentation-topic
```

#### 2. Make Changes

```bash
# Write code
# Add tests
# Update documentation

# Check code style
mvn checkstyle:check  # Java
poetry run black app/  # Python
poetry run flake8 app/  # Python linting
```

#### 3. Commit Changes

```bash
# Stage files
git add .

# Commit with conventional message
git commit -m "feat: add smart review predictions"

# Push to remote
git push origin feature/your-feature-name
```

#### 4. Create Pull Request

1. Go to GitHub repository
2. Click "New Pull Request"
3. Select your feature branch
4. Fill in PR template:
    - Description of changes
    - Related issues
    - Testing performed
    - Screenshots (if UI changes)
5. Request review from team members
6. Address review comments
7. Merge when approved

### Commit Message Convention

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <subject>

<body>

<footer>
```

#### Types

-   `feat`: New feature
-   `fix`: Bug fix
-   `docs`: Documentation changes
-   `refactor`: Code refactoring (no functional changes)
-   `test`: Adding or updating tests
-   `chore`: Maintenance tasks (dependencies, configs)
-   `perf`: Performance improvements
-   `style`: Code formatting (no logic changes)
-   `ci`: CI/CD pipeline changes
-   `build`: Build system changes

#### Examples

```bash
# Feature
git commit -m "feat(notifications): add WebSocket real-time delivery"

# Bug fix
git commit -m "fix(auth): resolve JWT token expiration issue"

# Documentation
git commit -m "docs(readme): update installation instructions"

# Refactoring
git commit -m "refactor(service): simplify streak calculation logic"

# Performance
git commit -m "perf(api): add Redis caching for vocab queries"

# Multiple paragraphs
git commit -m "feat(games): add new word matching game

- Implement game logic with scoring
- Add leaderboard integration
- Create admin configuration panel

Closes #123"
```

### Code Style Guidelines

#### Java (Spring Boot)

-   Follow [Google Java Style Guide](https://google.github.io/styleguide/javaguide.html)
-   Use meaningful variable names
-   Add JavaDoc for public methods
-   Keep methods under 50 lines
-   Write unit tests (target: > 80% coverage)

```java
/**
 * Calculates the next review date using SM-2 algorithm.
 *
 * @param progress Current vocabulary progress
 * @param quality User's recall quality (0-5)
 * @return Updated progress with new review date
 */
public UserVocabProgress calculateNextReview(UserVocabProgress progress, int quality) {
    // Implementation
}
```

#### Python (AI Service)

-   Follow [PEP 8](https://peps.python.org/pep-0008/)
-   Use type hints
-   Add docstrings for functions
-   Format with Black
-   Lint with Flake8

```python
from typing import Dict, List

def predict_review_success(
    user_id: str,
    vocab_id: str,
    features: Dict[str, float]
) -> float:
    """
    Predicts probability of successful vocabulary recall.

    Args:
        user_id: User's UUID
        vocab_id: Vocabulary UUID
        features: Engineered features for prediction

    Returns:
        Probability score between 0.0 and 1.0
    """
    # Implementation
```

### Testing Requirements

-   All new features must include tests
-   Bug fixes must include regression tests
-   Aim for > 80% code coverage
-   Run tests before committing

```bash
# Java tests
mvn clean test

# Python tests
poetry run pytest --cov=app tests/

# Integration tests
docker-compose -f docker-compose.test.yml up --abort-on-container-exit
```

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👥 Team

**Developer:** Ngô Minh Thuận  
**Institution:** Đại học Kỹ thuật - Công nghệ TP.HCM (HUTECH)  
**Project:** Khóa luận tốt nghiệp - Năm 4 HK1

---

## 📞 Support

### Documentation

-   **Main Docs**: `docs/`
-   **API Reference**: http://localhost:8080/swagger-ui.html
-   **WebSocket Guide**: `docs/WEBSOCKET_EVENTS.md`
-   **Deployment**: `docs/docker/`

### Issue Reporting

Found a bug? Please create an issue on GitHub with:

-   Description of the problem
-   Steps to reproduce
-   Expected vs actual behavior
-   Screenshots (if applicable)
-   Environment details (OS, Docker version, etc.)

### Contact

-   Email: ngominhthuan@example.com
-   GitHub: [@thuanthichlaptrinh](https://github.com/thuanthichlaptrinh)

---

**Made with ❤️ by Card Words Team**
