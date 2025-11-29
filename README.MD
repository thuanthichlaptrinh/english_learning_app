# 🎴 Nền Tảng Card Words

> Nền tảng học từ vựng cấp doanh nghiệp với công nghệ lặp lại ngắt quãng (Spaced Repetition) hỗ trợ bởi AI, thông báo thời gian thực và các tính năng gamification.

[![Java](https://img.shields.io/badge/Java-17-orange)](https://www.oracle.com/java/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.2.5-brightgreen)](https://spring.io/projects/spring-boot)
[![Python](https://img.shields.io/badge/Python-3.11-blue)](https://www.python.org/)
[![FastAPI](https://img.shields.io/badge/FastAPI-Latest-009688)](https://fastapi.tiangolo.com/)
[![Docker](https://img.shields.io/badge/Docker-Compose-2496ED)](https://www.docker.com/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-336791)](https://www.postgresql.org/)
[![Redis](https://img.shields.io/badge/Redis-7-DC382D)](https://redis.io/)
[![Firebase](https://img.shields.io/badge/Firebase-Storage-FFCA28)](https://firebase.google.com/)

---

## 📖 Mục Lục

-   [Tổng Quan](#-tổng-quan)
-   [Kiến Trúc](#-kiến-trúc)
-   [Bắt Đầu Nhanh](#-bắt-đầu-nhanh)
-   [Dịch Vụ](#-dịch-vụ)
-   [Tính Năng Chính](#-tính-năng-chính)
-   [Cấu Hình](#️-cấu-hình)
-   [Phát Triển](#-phát-triển)
-   [Cơ Sở Dữ Liệu](#️-cơ-sở-dữ-liệu)
-   [Tài Liệu API](#-tài-liệu-api)
-   [Khắc Phục Sự Cố](#️-khắc-phục-sự-cố)
-   [Đóng Góp](#-đóng-góp)

---

## 🌟 Tổng Quan

**Card Words Platform** là một hệ thống học từ vựng toàn diện kết hợp:

-   **Spring Boot Backend**: RESTful API với thông báo thời gian thực qua WebSocket.
-   **AI Service**: Dự đoán ôn tập thông minh sử dụng LightGBM.
-   **PostgreSQL**: Cơ sở dữ liệu quan hệ mạnh mẽ với Flyway migrations.
-   **Redis**: Caching hiệu năng cao và quản lý session.
-   **Firebase Storage**: Lưu trữ hình ảnh từ vựng và avatar người dùng.
-   **Docker**: Triển khai container hóa cho tất cả các dịch vụ.

### Khả Năng Cốt Lõi

✅ **Xác thực & Phân quyền** - JWT + OAuth2 (Google)  
✅ **Quản lý Từ vựng** - CRUD với metadata phong phú và hình ảnh (Firebase)  
✅ **Lặp lại Ngắt quãng** - Thuật toán SM-2 tối ưu hóa việc học  
✅ **Thông báo Thời gian thực** - Giao thức WebSocket + STOMP  
✅ **Gamification** - Nhiều chế độ chơi với bảng xếp hạng  
✅ **Ôn tập Hỗ trợ bởi AI** - Dự đoán Machine Learning  
✅ **Nhắc nhở Tự động** - Email chuỗi hàng ngày qua scheduler  
✅ **Admin Dashboard** - Giám sát người dùng và phân tích  
✅ **Đồng bộ Offline** - Đồng bộ dữ liệu thân thiện với thiết bị di động

---

## 🏗 Kiến Trúc

### Cấu Trúc Dự Án

```
card-words-platform/
├── 📁 card-words/              # Spring Boot Backend API
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/            # Mã nguồn ứng dụng
│   │   │   └── resources/       # Cấu hình & migrations
│   │   └── test/                # Unit & integration tests
│   ├── pom.xml                  # Maven dependencies
│   ├── Dockerfile               # Multi-stage build
│   └── docker-compose.yml       # Service-specific compose
│
├── 📁 card-words-ai/           # Python AI Service
│   ├── app/
│   │   ├── api/                 # FastAPI endpoints
│   │   ├── core/                # Business logic
│   │   ├── db/                  # Kết nối Database
│   │   └── middleware/          # Authentication & logging
│   ├── models/                  # LightGBM trained models
│   ├── pyproject.toml           # Poetry dependencies
│   └── Dockerfile               # Python container build
│
├── 📁 docs/                    # Tài liệu chi tiết
│   ├── admin/                   # Tính năng Admin
│   ├── AI/                      # Tài liệu mô hình ML
│   ├── auth/                    # Hướng dẫn xác thực
│   ├── docker/                  # Hướng dẫn triển khai
│   └── ...                      # Tài liệu tính năng cụ thể
│
├── docker-compose.yml           # 🔥 Root orchestration (tất cả services)
├── .env                         # 🔐 Biến môi trường (gitignored)
├── .gitignore                   # Git exclusions
└── README.MD                    # File này
```

### Technology Stack

| Thành phần        | Công nghệ    | Phiên bản | Mục đích                       |
| ----------------- | ------------ | --------- | ------------------------------ |
| **Backend API**   | Spring Boot  | 3.2.5     | RESTful API & WebSocket server |
| **Ngôn ngữ**      | Java         | 17        | Ngôn ngữ lập trình chính       |
| **AI Service**    | FastAPI      | Mới nhất  | ML prediction endpoints        |
| **ML Engine**     | LightGBM     | Mới nhất  | Dự đoán ôn tập thông minh      |
| **Database**      | PostgreSQL   | 16        | Lưu trữ dữ liệu chính          |
| **Cache**         | Redis        | 7         | Session & performance caching  |
| **Storage**       | Firebase     | -         | Lưu trữ hình ảnh (Cloud)       |
| **Message Queue** | STOMP        | -         | Nhắn tin WebSocket             |
| **Build Tool**    | Maven        | 3.9+      | Quản lý phụ thuộc Java         |
| **Migration**     | Flyway       | -         | Quản lý phiên bản Schema DB    |
| **Container**     | Docker       | Mới nhất  | Điều phối dịch vụ              |
| **Auth**          | JWT + OAuth2 | -         | Xác thực & phân quyền          |

---

## 🚀 Bắt Đầu Nhanh

### Yêu Cầu Tiên Quyết

Đảm bảo bạn đã cài đặt:

-   **Docker Desktop** 20.10+ (hoặc Docker Engine + Docker Compose)
-   **Git** để quản lý mã nguồn

**Tùy chọn (cho phát triển local):**

-   Java 17+ (Khuyên dùng Eclipse Temurin)
-   Maven 3.9+
-   Python 3.11+ với Poetry
-   Node.js 18+ (để tích hợp frontend)

### Cài Đặt

#### 1. Clone Repository

```bash
git clone https://github.com/yourusername/card-words-platform.git
cd card-words-platform
```

#### 2. Cấu Hình Môi Trường

```bash
# Copy template
cp .env.example .env

# Chỉnh sửa với thông tin của bạn
# Bắt buộc: Database password, JWT secret, email credentials, Firebase config
nano .env  # hoặc dùng editor ưa thích
```

#### 3. Khởi Chạy Tất Cả Dịch Vụ

```bash
# Build và start tất cả containers
docker-compose up -d --build

# Xem logs
docker-compose logs -f

# Kiểm tra sức khỏe dịch vụ
docker-compose ps
```

#### 4. Kiểm Tra Triển Khai

```bash
# Backend API health
curl http://localhost:8080/actuator/health

# AI Service health
curl http://localhost:8001/health

# Database connection
docker-compose exec postgres pg_isready -U postgres
```

### Truy Cập Dịch Vụ

| Dịch vụ             | URL                                   | Thông tin đăng nhập         |
| ------------------- | ------------------------------------- | --------------------------- |
| **Spring Boot API** | http://localhost:8080                 | Yêu cầu JWT token           |
| Swagger UI          | http://localhost:8080/swagger-ui.html | -                           |
| API Documentation   | http://localhost:8080/v3/api-docs     | -                           |
| Actuator            | http://localhost:8080/actuator        | -                           |
| **WebSocket**       | ws://localhost:8080/ws                | JWT trong handshake         |
| **AI Service**      | http://localhost:8001                 | Shared JWT auth             |
| AI Documentation    | http://localhost:8001/docs            | -                           |
| **PostgreSQL**      | localhost:5433                        | `postgres` / xem `.env`     |
| **Redis**           | localhost:6379                        | Không mật khẩu              |
| **PgAdmin**         | http://localhost:5050                 | admin@cardwords.com / admin |
| **Redis Insight**   | http://localhost:5540                 | -                           |

#### Ma Trận URL WebSocket

| Ngữ cảnh                  | URL                           | Ghi chú                                                                                       |
| ------------------------- | ----------------------------- | --------------------------------------------------------------------------------------------- |
| Phát triển Local          | `ws://localhost:8080/ws`      | Mặc định khi chạy Spring Boot qua Maven hoặc Docker port mapping                              |
| Docker Compose networking | `ws://card-words-api:8080/ws` | Sử dụng tên service này khi container khác (frontend, AI, etc.) cần subscribe trong cùng mạng |
| Production (HTTPS)        | `wss://<your-domain>/ws`      | Thay thế bằng domain public sau load balancer / reverse proxy; yêu cầu TLS termination        |

> 🔐 Luôn gửi `Authorization: Bearer <JWT>` trong header STOMP CONNECT bất kể môi trường nào.

### Test API Nhanh

#### 1. Đăng Ký User

```bash
curl -X POST http://localhost:8080/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Doe",
    "email": "john@example.com",
    "password": "SecurePass123!"
  }'
```

#### 2. Đăng Nhập

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

#### 3. Test Endpoint Có Xác Thực

```bash
curl -X GET http://localhost:8080/api/v1/vocabs \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

#### 4. Test Kết Nối WebSocket

Mở `test-websocket-events.html` trong trình duyệt:

1. Dán JWT token của bạn
2. Nhấn "Connect WebSocket"
3. Subscribe các kênh thông báo
4. Trigger một thông báo (ví dụ: hoàn thành game)
5. Xem cập nhật thời gian thực! ⚡

---

## 📦 Dịch Vụ

### Spring Boot Backend (card-words)

**Công Nghệ Cốt Lõi:**

-   Spring Boot 3.2.5 (Java 17)
-   Spring Security + JWT Authentication
-   Spring WebSocket + STOMP Messaging
-   Spring Data JPA + Hibernate
-   Spring Scheduler (Tác vụ tự động)
-   PostgreSQL 16 (Database chính)
-   Redis 7 (Lớp Caching)
-   Flyway (Database migrations)
-   **Firebase Storage** (Lưu trữ hình ảnh)
-   Google OAuth2 (Đăng nhập xã hội)
-   JavaMailSender (Dịch vụ Email)

**Tính Năng Chính:**

🔐 **Xác thực & Phân quyền**

-   Xác thực dựa trên JWT với refresh tokens
-   Tích hợp Google OAuth2
-   Kiểm soát truy cập dựa trên vai trò (ADMIN, USER)
-   Mã hóa mật khẩu an toàn với BCrypt

📚 **Quản lý Từ vựng**

-   CRUD cho từ vựng và chủ đề
-   Metadata phong phú (định nghĩa, ví dụ, hình ảnh từ Firebase)
-   Tìm kiếm và lọc nâng cao
-   Hỗ trợ đa ngôn ngữ

🎮 **Trò chơi Tương tác**

-   Quick Quiz (Đúng/Sai với bonus chuỗi)
-   Image-Word Matching (Game lật thẻ nhớ)
-   Word Definition Matching
-   Bảng xếp hạng thời gian thực
-   Tính điểm với bonus thời gian

📊 **Tiến Trình Học Tập**

-   Thuật toán lặp lại ngắt quãng SM-2
-   Theo dõi mức độ thành thạo từ vựng
-   Phân tích và thống kê tiến độ
-   Lên lịch ôn tập cá nhân hóa

🔥 **Hệ Thống Streak**

-   Theo dõi tính kiên trì học tập hàng ngày
-   Cập nhật streak tự động
-   Thành tựu cột mốc (7, 30, 100 ngày)
-   Lịch hoạt động trực quan
-   Kỷ lục cá nhân tốt nhất

🔔 **Thông Báo Thời Gian Thực (WebSocket)**

-   Giao thức WebSocket + STOMP
-   5 kênh thông báo chuyên dụng
-   Đồng bộ tức thì trên nhiều thiết bị
-   Thành tựu tự động kích hoạt
-   Khả năng broadcast của Admin

📧 **Tự Động Hóa Email**

-   Email chào mừng cho người dùng mới
-   Liên kết kích hoạt tài khoản
-   Đặt lại mật khẩu với token an toàn
-   Nhắc nhở streak hàng ngày (9:00 AM)
-   Template HTML đẹp mắt

📝 **Admin Dashboard**

-   Giám sát hoạt động người dùng
-   Nhật ký hành động (Action logs) chi tiết
-   Thống kê và phân tích hệ thống
-   Quản lý thông báo
-   Công cụ quản lý người dùng

💾 **Hỗ Trợ Đồng Bộ Offline**

-   Endpoint tải xuống dữ liệu hàng loạt
-   Chiến lược giải quyết xung đột
-   Đồng bộ Delta (chỉ thay đổi)
-   Phản hồi tối ưu cho mobile

**API Endpoints:** `http://localhost:8080/api/v1/`

**Tài liệu:**

-   Swagger UI: `/swagger-ui.html`
-   OpenAPI Spec: `/v3/api-docs`
-   WebSocket Guide: `docs/WEBSOCKET_EVENTS.md`
-   Notification playbook: `docs/websocket/WEBSOCKET_NOTIFICATION_PLAYBOOK.md`
-   Notification API: `docs/NOTIFICATION_API_COMPLETE.md`

---

### AI Service (card-words-ai)

**Công Nghệ Cốt Lõi:**

-   Python 3.11
-   FastAPI (Framework API hiệu năng cao)
-   LightGBM (Thư viện ML Gradient boosting)
-   PostgreSQL (Truy cập database chỉ đọc)
-   Redis (Caching dự đoán)
-   SQLAlchemy (Database ORM)
-   Pydantic (Data validation)
-   Poetry (Quản lý phụ thuộc)

**Tính Năng Chính:**

🤖 **Dự Đoán Ôn Tập Thông Minh**

-   Mô hình máy học LightGBM
-   Dự đoán thời điểm ôn tập tối ưu
-   Xem xét các mẫu hiệu suất của người dùng
-   Thích ứng với đường cong học tập cá nhân

⚡ **Tối Ưu Hóa Hiệu Năng**

-   Redis caching cho các dự đoán
-   Truy vấn database bất đồng bộ
-   Connection pooling
-   Thời gian phản hồi < 100ms

🔐 **Bảo Mật**

-   Xác thực JWT (chia sẻ với Spring Boot)
-   Truy cập database chỉ đọc
-   Giới hạn tốc độ request (Rate limiting)
-   Validate đầu vào với Pydantic

📊 **Đặc Trưng Mô Hình (Features)**

-   Lịch sử độ chính xác của người dùng
-   Thời gian kể từ lần ôn tập cuối
-   Độ khó của từ vựng
-   Chỉ số hiệu suất người dùng
-   Tính nhất quán của Streak

**API Endpoints:** `http://localhost:8001/api/`

**Tài liệu:**

-   Interactive Docs: `/docs`
-   ReDoc: `/redoc`
-   Chi tiết mô hình: `docs/AI/`

---

## 🎯 Tính Năng Chính

### 1. Thông Báo Thời Gian Thực với WebSocket

**Hệ thống push notification hoàn chỉnh không có độ trễ polling.**

#### Kiến Trúc

-   **Giao thức**: STOMP over WebSocket với SockJS fallback
-   **Xác thực**: JWT token trong handshake header
-   **Độ trễ**: < 100ms end-to-end
-   **Khả năng mở rộng**: Hỗ trợ hàng ngàn kết nối đồng thời

#### Các Kênh Thông Báo

| Kênh                                      | Mục đích        | Trigger                             |
| ----------------------------------------- | --------------- | ----------------------------------- |
| `/user/queue/notifications`               | Thông báo mới   | Thành tựu, nhắc nhở, tin nhắn admin |
| `/user/queue/notifications/read`          | Đánh dấu đã đọc | User đánh dấu 1 thông báo đã đọc    |
| `/user/queue/notifications/read-all`      | Đánh dấu tất cả | User đánh dấu tất cả thông báo      |
| `/user/queue/notifications/deleted`       | Xóa đơn lẻ      | User xóa thông báo                  |
| `/user/queue/notifications/batch-deleted` | Xóa hàng loạt   | User xóa nhiều thông báo            |
| `/topic/admin/user-registrations`         | Admin broadcast | Bất kỳ đăng ký user thành công nào  |

#### Thông Báo Tự Động Kích Hoạt

✨ **Thành Tựu Game** (Gửi tức thì)

-   **Quick Quiz**: Điểm cao, Độ chính xác tuyệt đối, Hiệu suất xuất sắc
-   **Word Definition**: Điểm cao, Độ chính xác tuyệt đối, Hiệu suất xuất sắc
-   Thưởng hoàn thành tốc độ

🔥 **Cột Mốc Streak** (Cập nhật thời gian thực)

-   Kiên trì 7 ngày
-   Cống hiến 30 ngày
-   Thành thạo 100 ngày
-   Kỷ lục cá nhân mới

🏆 **Bảng Xếp Hạng & Mục Tiêu**

-   **Thăng Hạng**: Top 1, Top 3, Top 10 bảng xếp hạng
-   **Mục Tiêu Ngày**: Ôn tập 10, 20, 50 từ mỗi ngày
-   **Chào Mừng**: Lời chào ngay khi đăng ký

📧 **Nhắc Nhở Hàng Ngày** (Gửi kép)

-   Lên lịch 2 lần/ngày: 07:00 & 19:00 (kèm cảnh báo gãy chuỗi lúc 07:00)
-   Email + WebSocket notification
-   Nhắm mục tiêu thông minh (users với streak hiện tại ≥ 3 ngày)

📢 **Admin Broadcasts** (Push tới tất cả users)

-   Thông báo hệ thống
-   Cập nhật nền tảng
-   Thông báo bảo trì
-   Feed đăng ký realtime qua `/topic/admin/user-registrations` giúp dashboard cập nhật tổng user

#### Lợi Ích Hiệu Năng

| Chỉ số              | Polling | WebSocket | Cải thiện           |
| ------------------- | ------- | --------- | ------------------- |
| Độ trễ              | 10-30s  | < 100ms   | **Nhanh hơn 99.7%** |
| Server Requests     | 360/giờ | 1/session | **Giảm 99.9%**      |
| Tác động Pin        | Cao     | Tối thiểu | **Tiết kiệm ~90%**  |
| Đồng bộ Đa thiết bị | Trễ     | Tức thì   | **Thời gian thực**  |

**Công Cụ Test:**

-   Test tương tác: `test-websocket-events.html`
-   Ví dụ Client: React, Flutter, JavaScript
-   Xem: `docs/WEBSOCKET_EVENTS.md`

---

### 2. Hệ Thống Email Tự Động

**Gửi email hoàn toàn tự động với template HTML đẹp mắt.**

#### Các Loại Email

📧 **Email Chào Mừng**

-   Gửi khi đăng ký người dùng
-   Bao gồm mật khẩu tạm thời
-   Giới thiệu nền tảng

🔑 **Kích Hoạt Tài Khoản**

-   Liên kết kích hoạt an toàn
-   Hết hạn sau 24 giờ
-   Xác minh email

🔒 **Đặt Lại Mật Khẩu**

-   Token đặt lại an toàn
-   Liên kết sử dụng một lần
-   Hết hạn sau 1 giờ

⏰ **Nhắc Nhở Streak Hàng Ngày**

-   Lịch tự động: 9:00 AM hàng ngày
-   Tiêu chí nhắm mục tiêu thông minh:
    -   ✅ Đã học hôm qua
    -   ❌ Chưa học hôm nay
    -   🔥 Streak ≥ 3 ngày (đáng để bảo vệ)
-   Gửi kép: Email + WebSocket
-   Template HTML đẹp mắt
-   Không cần can thiệp thủ công

#### Cấu Hình

```properties
# Gmail SMTP (khuyên dùng)
spring.mail.host=smtp.gmail.com
spring.mail.port=587
spring.mail.username=your-email@gmail.com
spring.mail.password=your-app-password  # Dùng App Password, không phải mật khẩu tài khoản
```

**Hướng dẫn cài đặt:** Tạo Gmail App Password tại https://myaccount.google.com/apppasswords

---

### 3. Lặp Lại Ngắt Quãng Hỗ Trợ Bởi AI

**Mô hình máy học LightGBM để lên lịch ôn tập cá nhân hóa.**

#### Thuật Toán: SM-2 Nâng Cấp với ML

**Tham Số SM-2 Truyền Thống:**

-   `EF` (Easiness Factor): 1.3 - 2.5
-   `Interval`: Số ngày cho đến lần ôn tiếp theo
-   `Repetition`: Số lần ôn tập thành công

**Cải Tiến ML:**

-   Mẫu hiệu suất người dùng
-   Hiệu quả theo thời gian trong ngày
-   Độ khó của từ vựng
-   Xu hướng độ chính xác lịch sử

#### Quy Trình Dự Đoán

```
User Request → Model Features → LightGBM Prediction → Redis Cache → Response
                ↓
        [correctness_rate, time_since_last, vocab_difficulty, user_streak]
```

#### Hiệu Năng

-   **Thời gian dự đoán**: < 50ms (cached: < 5ms)
-   **Độ chính xác mô hình**: ~85% (F1 score)
-   **Tỷ lệ Cache Hit**: > 90%
-   **Features**: 15 đặc trưng được kỹ thuật hóa

**Huấn luyện mô hình:** `card-words-ai/train-model.sh`

---

### 4. Admin Dashboard

**Công cụ giám sát và quản lý toàn diện.**

#### Tính Năng

📊 **Phân Tích (Analytics)**

-   Tổng người dùng và tăng trưởng
-   Phiên hoạt động (Active sessions)
-   Tỷ lệ hoàn thành game
-   Chỉ số tiến trình học tập

📝 **Nhật Ký Hành Động (Action Logs)**

-   Theo dõi hoạt động người dùng
-   Sự kiện đăng nhập/đăng xuất
-   Hoàn thành game
-   Tương tác từ vựng
-   Lọc nâng cao theo ngày, user, loại hành động

🔔 **Quản Lý Thông Báo**

-   Tạo thông báo hệ thống
-   Broadcast tới tất cả users
-   Thông báo nhắm mục tiêu user cụ thể
-   Xem lịch sử thông báo

👥 **Quản Lý Người Dùng**

-   Xem hồ sơ người dùng
-   Giám sát hoạt động
-   Gán vai trò (Role assignment)
-   Quản lý trạng thái tài khoản

**Tài liệu:** `docs/admin/ADMIN_DASHBOARD_API.md`

---

### 5. Hệ Thống Gamification

**Nhiều chế độ chơi với tính điểm thông minh và bảng xếp hạng.**

#### Chế Độ Chơi

🎯 **Quick Quiz**

-   Định dạng Đúng/Sai
-   10 câu hỏi mỗi phiên
-   Bonus thời gian: +10 điểm nếu < 5 giây
-   Bonus streak: +5 điểm mỗi câu trả lời đúng liên tiếp
-   Thành tựu điểm tuyệt đối: 100% độ chính xác

🖼️ **Image-Word Matching**

-   Game lật thẻ nhớ (Memory-style)
-   Ghép từ với hình ảnh
-   Tính điểm dựa trên thời gian
-   Các cấp độ khó

📖 **Word Definition Matching**

-   Ghép từ với định nghĩa
-   Định dạng trắc nghiệm
-   Độ khó thích ứng

#### Thuật Toán Tính Điểm

```
Điểm Cơ Bản = Câu Trả Lời Đúng × 100
Bonus Thời Gian = Trả Lời Nhanh × 10
Bonus Streak = Đúng Liên Tiếp × 5
Tổng Điểm = Cơ Bản + Bonus Thời Gian + Bonus Streak
```

#### Bảng Xếp Hạng (Leaderboards)

-   **Toàn Cầu**: Top điểm mọi thời đại
-   **Theo Game**: Xếp hạng từng game cụ thể
-   **Theo Thời Gian**: Ngày, tuần, tháng
-   **Cá Nhân**: Theo dõi tiến bộ cá nhân

**Tài liệu:** `docs/game/GAME_ALGORITHMS_DESIGN.md`

---

## ⚙️ Cấu Hình

### Biến Môi Trường

Tạo file `.env` trong thư mục gốc dự án:

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
MAIL_PASSWORD=your_gmail_app_password  # KHÔNG PHẢI mật khẩu Gmail của bạn!

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

**⚠️ Lưu ý Bảo Mật:** Không bao giờ commit `.env` lên version control. Sử dụng `.env.example` làm mẫu.

---

## 🔧 Phát Triển

### Phát Triển Local (Không dùng Docker)

#### 1. Spring Boot Backend

```bash
cd card-words

# Cài đặt dependencies
mvn clean install

# Chạy với hot reload
mvn spring-boot:run

# Hoặc chạy JAR
mvn clean package -DskipTests
java -jar target/card-words-0.0.1-SNAPSHOT.jar
```

**Truy cập:** http://localhost:8080

#### 2. AI Service

```bash
cd card-words-ai

# Cài đặt Poetry (nếu chưa có)
curl -sSL https://install.python-poetry.org | python3 -

# Cài đặt dependencies
poetry install

# Kích hoạt môi trường ảo
poetry shell

# Chạy với hot reload
poetry run uvicorn app.main:app --reload --port 8001
```

**Truy cập:** http://localhost:8001

#### 3. Thiết Lập Database

```bash
# Chỉ khởi chạy PostgreSQL và Redis
docker-compose up -d postgres redis

# Kiểm tra kết nối
psql -h localhost -p 5433 -U postgres -d card_words
```

### Phát Triển Docker

#### Build Services

```bash
# Build tất cả services
docker-compose build

# Build service cụ thể
docker-compose build card-words-api
docker-compose build card-words-ai

# Build không cache (clean build)
docker-compose build --no-cache card-words-api
```

#### Run Services

```bash
# Start tất cả services
docker-compose up -d

# Start service cụ thể
docker-compose up -d postgres redis card-words-api

# Xem logs
docker-compose logs -f card-words-api

# Theo dõi logs từ tất cả services
docker-compose logs -f
```

#### Stop Services

```bash
# Stop tất cả services
docker-compose stop

# Stop service cụ thể
docker-compose stop card-words-api

# Stop và remove containers
docker-compose down

# Remove containers và volumes (⚠️ XÓA DỮ LIỆU)
docker-compose down -v
```

### Testing

#### Spring Boot Tests

```bash
cd card-words

# Chạy tất cả tests
mvn test

# Chạy test class cụ thể
mvn test -Dtest=VocabServiceTest

# Chạy với coverage report
mvn clean test jacoco:report
```

#### AI Service Tests

```bash
cd card-words-ai

# Chạy tất cả tests
poetry run pytest

# Chạy với coverage
poetry run pytest --cov=app

# Chạy test cụ thể
poetry run pytest tests/test_predictions.py
```

---

## 🗄️ Cơ Sở Dữ Liệu

### Quản Lý Schema

**Flyway migrations** quản lý tất cả thay đổi schema:

-   **Vị trí:** `card-words/src/main/resources/db/migration/`
-   **Tự động chạy:** Khi khởi động ứng dụng
-   **Đặt tên:** `V{version}__{description}.sql`
-   **Phiên bản:** Tuần tự (V1, V2, V3, ...)

#### Lịch Sử Migration

| Phiên bản | Mô tả             | Bảng được thêm                                   |
| --------- | ----------------- | ------------------------------------------------ |
| V1        | Initial schema    | `users`, `roles`, `topics`, `vocabs`             |
| V2        | Games system      | `games`, `game_sessions`, `game_session_details` |
| V3        | Learning progress | `user_vocab_progress` (SM-2 algorithm)           |
| V4        | Streak tracking   | `streak_records`                                 |
| V5        | Leaderboards      | `leaderboards`, `game_leaderboards`              |
| V6        | Notifications     | `notifications`                                  |
| V7        | Admin tools       | `action_logs` + missing columns                  |

#### Tạo Migration Mới

```bash
cd card-words/src/main/resources/db/migration

# Tạo file mới
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

### Sao Lưu & Khôi Phục

#### Sao Lưu Tự Động

```bash
cd card-words

# Windows
./backup-database.bat

# Linux/Mac
chmod +x backup-database.sh
./backup-database.sh
```

**Vị trí backup:** `card-words/database-backups/card_words_YYYYMMDD_HHMMSS.sql`

#### Sao Lưu Hàng Ngày Tự Động

```bash
# Windows Task Scheduler
./auto-backup.bat

# Linux Cron
chmod +x auto-backup.sh
crontab -e
# Thêm: 0 2 * * * /path/to/auto-backup.sh  # Hàng ngày lúc 2 AM
```

#### Khôi Phục từ Backup

```bash
cd card-words

# Windows
./restore-database.bat database-backups/card_words_20251119_090000.sql

# Linux/Mac
./restore-database.sh database-backups/card_words_20251119_090000.sql
```

### Database Schema

#### Các Bảng Cốt Lõi

**users** - Tài khoản người dùng

```sql
- id (UUID, PK)
- email (VARCHAR, UNIQUE)
- password (VARCHAR, hashed)
- name (VARCHAR)
- avatar_url (VARCHAR)
- created_at (TIMESTAMP)
- updated_at (TIMESTAMP)
```

**vocabs** - Từ vựng

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

**user_vocab_progress** - Lặp lại ngắt quãng SM-2

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

**notifications** - Thông báo người dùng

```sql
- id (UUID, PK)
- user_id (UUID, FK → users)
- title (VARCHAR)
- content (TEXT)
- type (VARCHAR)
- is_read (BOOLEAN)
- created_at (TIMESTAMP)
```

**Full schema:** Xem migrations trong `card-words/src/main/resources/db/migration/`

---

## 📚 Tài Liệu API

### Swagger UI

Tài liệu API tương tác với chức năng try-it-out:

**URL:** http://localhost:8080/swagger-ui.html

**Tính năng:**

-   Danh sách endpoint đầy đủ
-   Schemas request/response
-   Test xác thực
-   Gọi API trực tiếp

### OpenAPI Specification

**URL:** http://localhost:8080/v3/api-docs

**Định dạng:** JSON (OpenAPI 3.0)

### Postman Collection

Import collection từ: `docs/postman/Card-Words-API.postman_collection.json`

### Danh Mục API Endpoint

#### 🔐 Authentication (`/api/v1/auth`)

| Method | Endpoint | Mô tả |
|--------|----------|-------|
| `POST` | `/signup` | Đăng ký tài khoản mới |
| `POST` | `/signin` | Đăng nhập bằng email/password |
| `POST` | `/signout` | Đăng xuất |
| `POST` | `/google` | Đăng nhập bằng Google OAuth2 |
| `POST` | `/refresh-token` | Làm mới access token |
| `POST` | `/forgot-password` | Yêu cầu đặt lại mật khẩu |

#### 👤 User (`/api/v1/users`)

| Method | Endpoint | Mô tả |
|--------|----------|-------|
| `GET` | `/` | Lấy thông tin profile |
| `PUT` | `/` | Cập nhật thông tin profile |
| `PUT` | `/avatar` | Upload avatar |
| `POST` | `/change-password` | Đổi mật khẩu |
| `GET` | `/games/history` | Lịch sử chơi game |
| `GET` | `/games/stats` | Thống kê game tổng quan |

#### 🔥 User Streak (`/api/v1/user/streak`)

| Method | Endpoint | Mô tả |
|--------|----------|-------|
| `GET` | `/` | Lấy thông tin streak hiện tại |
| `POST` | `/record` | Ghi nhận hoạt động học |

#### 📚 Vocabulary (`/api/v1/vocabs`)

| Method | Endpoint | Mô tả |
|--------|----------|-------|
| `GET` | `/` | Danh sách từ vựng (phân trang) |
| `GET` | `/{id}` | Lấy từ vựng theo ID |
| `GET` | `/word/{word}` | Lấy từ vựng theo từ |
| `GET` | `/search` | Tìm kiếm từ vựng |
| `GET` | `/cefr/{cefr}` | Lấy từ vựng theo CEFR level |
| `GET` | `/{id}/media` | Lấy URL hình ảnh/âm thanh |
| `GET` | `/word/{word}/media` | Lấy media theo từ |

#### 📂 Topics (`/api/v1/topics`)

| Method | Endpoint | Mô tả |
|--------|----------|-------|
| `GET` | `/` | Danh sách chủ đề |
| `GET` | `/{id}` | Chi tiết chủ đề |

#### 🔔 Notifications (`/api/v1/notifications`)

| Method | Endpoint | Mô tả |
|--------|----------|-------|
| `GET` | `/` | Danh sách thông báo |
| `GET` | `/summary` | Tổng quan thông báo |
| `PUT` | `/{id}/read` | Đánh dấu đã đọc |
| `PUT` | `/read-all` | Đánh dấu tất cả đã đọc |
| `DELETE` | `/{id}` | Xóa thông báo |
| `DELETE` | `/selected` | Xóa nhiều thông báo |

#### 🎮 Quick Quiz (`/api/v1/games/quick-quiz`)

| Method | Endpoint | Mô tả |
|--------|----------|-------|
| `POST` | `/start` | Bắt đầu game |
| `POST` | `/start-auto` | Bắt đầu game tự động |
| `POST` | `/answer` | Trả lời câu hỏi |
| `POST` | `/skip` | Bỏ qua câu hỏi |
| `GET` | `/session/{sessionId}` | Xem kết quả game |
| `GET` | `/instructions` | Hướng dẫn chơi |
| `GET` | `/leaderboard` | Bảng xếp hạng |

#### 🖼️ Image-Word Matching (`/api/v1/games/image-word-matching`)

| Method | Endpoint | Mô tả |
|--------|----------|-------|
| `POST` | `/start` | Bắt đầu game |
| `POST` | `/start-auto` | Bắt đầu game tự động |
| `POST` | `/answer` | Trả lời câu hỏi |
| `GET` | `/session/{sessionId}` | Xem kết quả game |
| `GET` | `/instructions` | Hướng dẫn chơi |
| `GET` | `/leaderboard` | Bảng xếp hạng |

#### 📖 Word-Definition Matching (`/api/v1/games/word-definition-matching`)

| Method | Endpoint | Mô tả |
|--------|----------|-------|
| `POST` | `/start` | Bắt đầu game |
| `POST` | `/start-auto` | Bắt đầu game tự động |
| `POST` | `/answer` | Trả lời câu hỏi |
| `GET` | `/session/{sessionId}` | Xem kết quả game |
| `GET` | `/instructions` | Hướng dẫn chơi |
| `GET` | `/leaderboard` | Bảng xếp hạng |

#### 🏆 Leaderboard (`/api/v1/leaderboard`)

| Method | Endpoint | Mô tả |
|--------|----------|-------|
| `GET` | `/` | Bảng xếp hạng tổng |
| `GET` | `/game/{gameId}` | Bảng xếp hạng theo game |

#### 📊 User Stats (`/api/v1/user-stats`)

| Method | Endpoint | Mô tả |
|--------|----------|-------|
| `GET` | `/` | Thống kê học tập |

#### 📝 Flashcard Review (`/api/v1/flashcard-review`)

| Method | Endpoint | Mô tả |
|--------|----------|-------|
| `GET` | `/due` | Lấy từ cần ôn tập |
| `POST` | `/review` | Ghi nhận kết quả ôn tập |

#### 📈 User Vocab Progress (`/api/v1/user-vocab-progress`)

| Method | Endpoint | Mô tả |
|--------|----------|-------|
| `GET` | `/` | Tiến độ học từ vựng |
| `GET` | `/topic/{topicId}` | Tiến độ theo chủ đề |

#### 🤖 Chatbot (`/api/v1/chatbot`)

| Method | Endpoint | Mô tả |
|--------|----------|-------|
| `POST` | `/chat` | Chat với AI |

#### ⚙️ Game Settings (`/api/v1/game-settings`)

| Method | Endpoint | Mô tả |
|--------|----------|-------|
| `GET` | `/` | Lấy cài đặt game |
| `PUT` | `/` | Cập nhật cài đặt game |

#### 📱 Offline Sync (`/api/v1/offline-sync`)

| Method | Endpoint | Mô tả |
|--------|----------|-------|
| `GET` | `/download` | Tải dữ liệu offline |
| `POST` | `/upload` | Đồng bộ dữ liệu |

---

### 🔧 Admin API Endpoints

#### 👥 User Admin (`/api/v1/admin/users`)

| Method | Endpoint | Mô tả |
|--------|----------|-------|
| `GET` | `/` | Danh sách người dùng |
| `GET` | `/{id}` | Chi tiết người dùng |
| `GET` | `/email/{email}` | Tìm theo email |
| `GET` | `/search` | Tìm kiếm người dùng |
| `GET` | `/statistics` | Thống kê người dùng |
| `GET` | `/registration-chart` | Biểu đồ đăng ký |
| `GET` | `/system-overview` | Tổng quan hệ thống |
| `GET` | `/game-stats` | Thống kê game |
| `PUT` | `/{id}/ban` | Khóa/mở khóa tài khoản |
| `PUT` | `/{id}/activate` | Kích hoạt tài khoản |
| `PUT` | `/{id}/roles` | Cập nhật role |
| `POST` | `/{id}/reset-password` | Reset mật khẩu |
| `DELETE` | `/{id}` | Xóa người dùng |

#### 📚 Vocab Admin (`/api/v1/admin/vocabs`)

| Method | Endpoint | Mô tả |
|--------|----------|-------|
| `GET` | `/` | Danh sách từ vựng |
| `GET` | `/{id}` | Chi tiết từ vựng |
| `GET` | `/word/{word}` | Tìm theo từ |
| `GET` | `/search` | Tìm kiếm từ vựng |
| `GET` | `/cefr/{cefr}` | Lọc theo CEFR |
| `POST` | `/` | Thêm từ vựng |
| `POST` | `/bulk-import` | Import hàng loạt |
| `PUT` | `/{id}` | Cập nhật từ vựng |
| `PUT` | `/word/{word}` | Cập nhật theo từ |
| `DELETE` | `/{id}` | Xóa từ vựng |
| `GET` | `/export/excel` | Xuất Excel |

#### 📂 Topic Admin (`/api/v1/admin/topics`)

| Method | Endpoint | Mô tả |
|--------|----------|-------|
| `GET` | `/` | Danh sách chủ đề |
| `POST` | `/` | Thêm chủ đề |
| `PUT` | `/{id}` | Cập nhật chủ đề |
| `DELETE` | `/{id}` | Xóa chủ đề |

#### 🏷️ Type Admin (`/api/v1/admin/types`)

| Method | Endpoint | Mô tả |
|--------|----------|-------|
| `GET` | `/` | Danh sách loại từ |
| `POST` | `/` | Thêm loại từ |
| `PUT` | `/{id}` | Cập nhật loại từ |
| `DELETE` | `/{id}` | Xóa loại từ |

#### 🎮 Game Admin (`/api/v1/admin/games`)

| Method | Endpoint | Mô tả |
|--------|----------|-------|
| `GET` | `/` | Danh sách game |
| `GET` | `/stats` | Thống kê game |

#### 🔔 Notification Admin (`/api/v1/admin/notifications`)

| Method | Endpoint | Mô tả |
|--------|----------|-------|
| `POST` | `/` | Tạo thông báo |
| `POST` | `/broadcast` | Broadcast tới tất cả |

#### 📝 Action Logs (`/api/v1/admin/action-logs`)

| Method | Endpoint | Mô tả |
|--------|----------|-------|
| `GET` | `/` | Danh sách action logs |
| `GET` | `/statistics` | Thống kê logs |
| `GET` | `/export` | Export logs |
| `DELETE` | `/cleanup` | Xóa logs cũ |

#### 📈 Vocab Progress Admin (`/api/v1/admin/vocab-progress`)

| Method | Endpoint | Mô tả |
|--------|----------|-------|
| `GET` | `/` | Tiến độ học của users |
| `GET` | `/user/{userId}` | Tiến độ theo user |

#### 🗄️ Firebase Storage (`/api/v1/admin/storage`)

| Method | Endpoint | Mô tả |
|--------|----------|-------|
| `POST` | `/upload` | Upload file |
| `DELETE` | `/delete` | Xóa file |

### WebSocket Endpoints

**Kết nối:** `ws://localhost:8080/ws`

**Subscriptions:**

```javascript
// Thông báo mới
stompClient.subscribe('/user/queue/notifications', callback);

// Sự kiện đánh dấu đã đọc
stompClient.subscribe('/user/queue/notifications/read', callback);

// Sự kiện đánh dấu tất cả đã đọc
stompClient.subscribe('/user/queue/notifications/read-all', callback);

// Sự kiện xóa
stompClient.subscribe('/user/queue/notifications/deleted', callback);

// Sự kiện xóa hàng loạt
stompClient.subscribe('/user/queue/notifications/batch-deleted', callback);
```

**Tài liệu:**

-   Hướng dẫn đầy đủ: `docs/WEBSOCKET_EVENTS.md`
-   Ví dụ Client: `docs/WEBSOCKET_CLIENT_GUIDE.md`
-   Notification playbook: `docs/websocket/WEBSOCKET_NOTIFICATION_PLAYBOOK.md`
-   Test nhanh: `test-websocket-events.html`

---

## 🛠️ Khắc Phục Sự Cố

### Các Vấn Đề Thường Gặp

#### 1. Containers Không Khởi Động

```bash
# Kiểm tra trạng thái container
docker-compose ps

# Xem logs lỗi
docker-compose logs --tail=50

# Stop tất cả services
docker-compose down

# Xóa volumes (⚠️ XÓA DỮ LIỆU)
docker-compose down -v

# Rebuild và restart
docker-compose up -d --build
```

#### 2. Port Đã Được Sử Dụng

```bash
# Windows: Tìm process đang dùng port
netstat -ano | findstr :8080
# Kill process bằng PID
taskkill /PID <process_id> /F

# Linux/Mac: Tìm và kill process
lsof -ti:8080 | xargs kill -9

# Hoặc đổi port trong .env
SERVER_SPRING_PORT=8081
```

#### 3. Kết Nối Database Thất Bại

```bash
# Kiểm tra logs PostgreSQL
docker-compose logs postgres

# Xác minh PostgreSQL đang chạy
docker-compose ps postgres

# Test kết nối
docker-compose exec postgres psql -U postgres -d card_words -c 'SELECT 1;'

# Kiểm tra mạng
docker network inspect server_default
```

#### 4. Lỗi Migration

```bash
# Xem trạng thái Flyway
docker-compose logs card-words-api | grep Flyway

# Sửa chữa Flyway schema
docker-compose exec card-words-api \
  mvn flyway:repair -Dflyway.url=jdbc:postgresql://postgres:5432/card_words

# Reset database (⚠️ XÓA TẤT CẢ DỮ LIỆU)
docker-compose down -v
docker-compose up -d
```

#### 5. Email Không Gửi Được

```bash
# Kiểm tra cấu hình email
docker-compose logs card-words-api | grep "mail"

# Xác minh Gmail App Password
# 1. Bật Xác minh 2 bước trên Tài khoản Google
# 2. Tạo App Password: https://myaccount.google.com/apppasswords
# 3. Cập nhật MAIL_PASSWORD trong .env
# 4. Restart service: docker-compose restart card-words-api
```

#### 6. Kết Nối WebSocket Thất Bại

```bash
# Kiểm tra WebSocket endpoint
curl -i -N -H "Connection: Upgrade" \
  -H "Upgrade: websocket" \
  -H "Sec-WebSocket-Version: 13" \
  -H "Sec-WebSocket-Key: test" \
  http://localhost:8080/ws

# Bật debug logging
# Thêm vào application.properties:
logging.level.org.springframework.web.socket=DEBUG

# Restart và kiểm tra logs
docker-compose restart card-words-api
docker-compose logs -f card-words-api | grep WebSocket
```

#### 7. AI Service Dự Đoán Thất Bại

```bash
# Kiểm tra logs AI service
docker-compose logs card-words-ai

# Xác minh file model tồn tại
docker-compose exec card-words-ai ls -la /app/models/

# Test prediction endpoint
curl http://localhost:8001/api/predict \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"user_id": "uuid", "vocab_id": "uuid"}'

# Huấn luyện lại model nếu cần
cd card-words-ai
./train-model.sh
```

### Kiểm Tra Sức Khỏe (Health Checks)

```bash
# Spring Boot actuator
curl http://localhost:8080/actuator/health | jq

# AI Service health
curl http://localhost:8001/health | jq

# PostgreSQL
docker-compose exec postgres pg_isready -U postgres

# Redis
docker-compose exec redis redis-cli ping

# Tất cả services
docker-compose ps
```

### Giám Sát Hiệu Năng

```bash
# Spring Boot metrics
curl http://localhost:8080/actuator/metrics | jq

# Hiệu năng Database
docker-compose exec postgres psql -U postgres -d card_words -c '\
  SELECT pid, usename, application_name, state, query \
  FROM pg_stat_activity WHERE state = '\''active'\'';'

# Redis stats
docker-compose exec redis redis-cli INFO stats

# Sử dụng tài nguyên Docker
docker stats
```

---

## 🤝 Đóng Góp

### Quy Trình Phát Triển

#### 1. Tạo Feature Branch

```bash
# Cập nhật nhánh main
git checkout main
git pull origin main

# Tạo feature branch
git checkout -b feature/ten-tinh-nang-cua-ban

# Cho sửa lỗi
git checkout -b fix/mo-ta-loi

# Cho tài liệu
git checkout -b docs/chu-de-tai-lieu
```

#### 2. Thực Hiện Thay Đổi

```bash
# Viết code
# Thêm tests
# Cập nhật tài liệu

# Kiểm tra code style
mvn checkstyle:check  # Java
poetry run black app/  # Python
poetry run flake8 app/  # Python linting
```

#### 3. Commit Thay Đổi

```bash
# Stage files
git add .

# Commit với conventional message
git commit -m "feat: add smart review predictions"

# Push lên remote
git push origin feature/ten-tinh-nang-cua-ban
```

#### 4. Tạo Pull Request

1. Truy cập GitHub repository
2. Nhấn "New Pull Request"
3. Chọn feature branch của bạn
4. Điền vào PR template:
    - Mô tả thay đổi
    - Các issue liên quan
    - Testing đã thực hiện
    - Screenshots (nếu có thay đổi UI)
5. Yêu cầu review từ thành viên team
6. Giải quyết các comment review
7. Merge khi được approve

### Quy Ước Commit Message

Tuân theo [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <subject>

<body>

<footer>
```

#### Các Loại (Types)

-   `feat`: Tính năng mới
-   `fix`: Sửa lỗi
-   `docs`: Thay đổi tài liệu
-   `refactor`: Tái cấu trúc code (không thay đổi chức năng)
-   `test`: Thêm hoặc cập nhật tests
-   `chore`: Tác vụ bảo trì (dependencies, configs)
-   `perf`: Cải thiện hiệu năng
-   `style`: Định dạng code (không thay đổi logic)
-   `ci`: Thay đổi CI/CD pipeline
-   `build`: Thay đổi hệ thống build

#### Ví Dụ

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

# Nhiều đoạn văn
git commit -m "feat(games): add new word matching game

- Implement game logic with scoring
- Add leaderboard integration
- Create admin configuration panel

Closes #123"
```

### Hướng Dẫn Code Style

#### Java (Spring Boot)

-   Tuân theo [Google Java Style Guide](https://google.github.io/styleguide/javaguide.html)
-   Sử dụng tên biến có ý nghĩa
-   Thêm JavaDoc cho các public methods
-   Giữ methods dưới 50 dòng
-   Viết unit tests (mục tiêu: > 80% coverage)

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

-   Tuân theo [PEP 8](https://peps.python.org/pep-0008/)
-   Sử dụng type hints
-   Thêm docstrings cho functions
-   Format với Black
-   Lint với Flake8

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

### Yêu Cầu Testing

-   Tất cả tính năng mới phải bao gồm tests
-   Sửa lỗi phải bao gồm regression tests
-   Mục tiêu > 80% code coverage
-   Chạy tests trước khi commit

```bash
# Java tests
mvn clean test

# Python tests
poetry run pytest --cov=app tests/

# Integration tests
docker-compose -f docker-compose.test.yml up --abort-on-container-exit
```

---

## 🚀 Deploy lên Production

### Deploy lên VPS

Sau khi sửa code và push lên GitHub, deploy lên VPS rất đơn giản:

#### Cách 1: Deploy từ máy local (Windows)
```powershell
# Push code
git push origin main

# Deploy tự động
.\scripts\deploy-from-local.ps1
```

#### Cách 2: Deploy từ máy local (Linux/Mac)
```bash
# Push code
git push origin main

# Deploy tự động
bash scripts/deploy-from-local.sh
```

#### Cách 3: SSH thủ công
```bash
# Push code (trên máy local)
git push origin main

# SSH vào VPS
ssh root@103.9.77.220

# Deploy
cd /opt/card-words-services
bash scripts/deploy-vps.sh
```

### Tài liệu Deploy chi tiết

- **Quick Reference**: `DEPLOY-QUICK-REFERENCE.md` - Các lệnh thường dùng
- **Full Guide**: `docs/DEPLOY-GUIDE.md` - Hướng dẫn đầy đủ
- **HTTPS Setup**: `docs/HTTPS-SETUP-GUIDE.md` - Cài đặt SSL/HTTPS

### Scripts Deploy có sẵn

| Script | Mô tả | Chạy ở đâu |
|--------|-------|------------|
| `deploy-vps.sh` | Deploy đầy đủ (rebuild images) | VPS |
| `quick-deploy.sh` | Deploy nhanh (không rebuild) | VPS |
| `deploy-from-local.sh` | Deploy từ máy Linux/Mac | Local |
| `deploy-from-local.ps1` | Deploy từ máy Windows | Local |
| `setup-https.sh` | Cài đặt HTTPS/SSL | VPS |

---

## 📄 Giấy Phép

Dự án này được cấp phép theo Giấy phép MIT - xem file [LICENSE](LICENSE) để biết chi tiết.

---

## 👥 Nhóm Thực Hiện

**Sinh viên:** Ngô Minh Thuận  
**Trường:** Trường Đại học Công Thương TP. Hồ Chí Minh (HUIT)
**Đồ án:** Khóa luận tốt nghiệp

---

## 📞 Hỗ Trợ

### Tài Liệu

-   **Tài liệu chính**: `docs/`
-   **Tham khảo API**: http://localhost:8080/swagger-ui.html
-   **Hướng dẫn WebSocket**: `docs/WEBSOCKET_EVENTS.md`
-   **Triển khai**: `docs/docker/`

### Báo Cáo Lỗi

Tìm thấy lỗi? Vui lòng tạo issue trên GitHub với:

-   Mô tả vấn đề
-   Các bước tái hiện
-   Hành vi mong đợi vs thực tế
-   Screenshots (nếu có)
-   Chi tiết môi trường (OS, Docker version, etc.)

### Liên Hệ

-   Email: thuanthichlaptrinh@gmail.com
-   GitHub: [@thuanthichlaptrinh](https://github.com/thuanthichlaptrinh)

---

**Được thực hiện với ❤️ bởi Card Words Team**
