# 🚀 Hướng Dẫn Chạy Project Card Words với Docker

## 📋 Mục Lục

1. [Yêu Cầu Hệ Thống](#-yêu-cầu-hệ-thống)
2. [Setup Lần Đầu](#-setup-lần-đầu)
3. [Khởi Động Project](#-khởi-động-project)
4. [Backup & Restore Database](#-backup--restore-database)
5. [Quản Lý Docker](#-quản-lý-docker)
6. [Troubleshooting](#-troubleshooting)

---

## ✅ Yêu Cầu Hệ Thống

### **BẮT BUỘC:**

-   ✅ **Docker Desktop** (Windows/Mac) hoặc Docker Engine (Linux)
-   ✅ **Git**

### **KHÔNG CẦN CÀI:**

-   ❌ Java/JDK
-   ❌ Maven
-   ❌ Spring Boot
-   ❌ PostgreSQL
-   ❌ Redis

> **Lưu ý:** Docker sẽ tự động build và chạy tất cả trong containers!

---

## 🎯 Setup Lần Đầu

### **Bước 1: Clone Repository**

```bash
git clone https://github.com/thuanthichlaptrinh/card_words.git
cd card_words
```

### **Bước 2: Tạo File `.env`**

Tạo file `.env` trong thư mục gốc với nội dung:

```properties
# Server Configuration
SERVER_PORT=8080
SPRING_APPLICATION_NAME=card-words

# PostgreSQL Database
POSTGRES_DB=card_words
POSTGRES_USER=postgres
POSTGRES_PASSWORD=123456
POSTGRES_HOST=postgres
POSTGRES_PORT=5432

# Redis Configuration
REDIS_DB=0
REDIS_HOST=redis
REDIS_PORT=6379
REDIS_PASSWORD=
REDIS_TIMEOUT=60000

# PgAdmin
PGADMIN_DEFAULT_EMAIL=admin@cardwords.com
PGADMIN_DEFAULT_PASSWORD=admin123
PGADMIN_PORT=5050

# JWT Configuration
JWT_SECRET=your-secret-key-here-make-it-long-and-secure-at-least-256-bits
JWT_EXPIRATION_TIME=86400000
JWT_REFRESH_TOKEN_EXPIRATION=604800000

# Email Activation
ACTIVATION_EXPIRED_TIME=86400000
ACTIVATION_RESEND_INTERVAL=60000

# Email Configuration (Gmail)
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-app-password

# Google OAuth2
GOOGLE_OAUTH_CLIENT_ID=your-google-client-id.apps.googleusercontent.com
GOOGLE_OAUTH_CLIENT_SECRET=your-google-client-secret
GOOGLE_OAUTH_REDIRECT_URI=http://localhost:8080/api/v1/auth/google/callback

# Firebase Storage
FIREBASE_STORAGE_BUCKET=your-firebase-project.appspot.com
FIREBASE_SERVICE_ACCOUNT_PATH=classpath:firebase-service-account.json
```

> **⚠️ Lưu ý:**
>
> -   File `.env` KHÔNG được commit lên GitHub (đã có trong `.gitignore`)
> -   Mỗi máy cần tạo file `.env` riêng với thông tin cấu hình phù hợp

### **Bước 3: Cấu Hình Firebase (BẮT BUỘC)**

Firebase service account file **KHÔNG có trong GitHub** (bị gitignore vì chứa thông tin bảo mật).

**📝 Cách lấy file:**

1. **Từ máy đang có project:**

    ```bash
    # Copy file từ src/main/resources/
    cp src/main/resources/firebase-service-account.json .
    ```

2. **Hoặc tải từ Firebase Console:**
    - Truy cập: https://console.firebase.google.com
    - Chọn project → **Project Settings** → **Service accounts**
    - Click **Generate new private key**
    - Lưu file JSON vào `src/main/resources/firebase-service-account.json`

**⚠️ QUAN TRỌNG:**

-   File PHẢI đặt tại: `src/main/resources/firebase-service-account.json`
-   Không commit file này lên GitHub (đã có trong .gitignore)
-   Mỗi máy cần copy file này thủ công

### **Bước 4: Build và Khởi Động**

```bash
# Windows (CMD/PowerShell)
docker-compose up -d --build

# Linux/Mac
sudo docker-compose up -d --build
```

**Giải thích:**

-   `up`: Khởi động containers
-   `-d`: Chạy ở chế độ background (detached)
-   `--build`: Build lại Docker image (bắt buộc lần đầu hoặc khi có thay đổi code)

### **Bước 5: Đợi Khởi Động (30-60 giây)**

Kiểm tra trạng thái containers:

```bash
docker-compose ps
```

Kết quả mong muốn:

```
NAME                    STATUS
card-words-app          Up (healthy)
card-words-postgres     Up (healthy)
card-words-redis        Up
card-words-pgadmin      Up
card-words-redisinsight Up
```

### **Bước 5: Kiểm Tra Logs**

Nếu có vấn đề, xem logs:

```bash
# Xem logs của app
docker-compose logs app

# Xem logs realtime
docker-compose logs -f app

# Xem logs tất cả services
docker-compose logs
```

---

## 🌐 Truy Cập Ứng Dụng

Sau khi khởi động thành công:

| Service           | URL                                         | Mô tả                 |
| ----------------- | ------------------------------------------- | --------------------- |
| **API Server**    | http://localhost:8080                       | Backend REST API      |
| **Swagger UI**    | http://localhost:8080/swagger-ui/index.html | API Documentation     |
| **PgAdmin**       | http://localhost:5050                       | PostgreSQL Management |
| **Redis Insight** | http://localhost:5540                       | Redis GUI             |

### **Đăng Nhập PgAdmin:**

-   Email: `admin@cardwords.com`
-   Password: `admin123`

**Kết nối PostgreSQL trong PgAdmin:**

1. Add New Server
2. Name: `card-words-db`
3. Connection tab:
    - Host: `postgres`
    - Port: `5432`
    - Database: `card_words`
    - Username: `postgres`
    - Password: `123456`

### **Kết Nối Redis Insight:**

1. Mở http://localhost:5540
2. Click "Add Redis Database"
3. Nhập thông tin:
    - **Host:** `redis` (hoặc `card-words-redis`)
    - **Port:** `6379`
    - **Database Alias:** `card-words-redis`
    - **Username:** [ĐỂ TRỐNG]
    - **Password:** [ĐỂ TRỐNG]
4. Click "Add Redis Database"

---

## 💾 Backup & Restore Database

### **📤 Backup Database (Máy A - Có Data)**

#### **Bước 1: Chạy Script Backup**

```bash
# Windows
./backup-database.bat

# Linux/Mac
chmod +x backup-database.sh
./backup-database.sh
```

File backup sẽ được tạo trong thư mục `database-backups/`:

```
database-backups/
  └── card_words_20251107_0204 PM.sql
```

#### **Bước 2: Chia Sẻ File Backup**

**Option 1: Google Drive (Khuyến nghị)**

-   Upload file `.sql` lên Google Drive
-   Share link với team

**Option 2: GitHub (Private Repository)**

```bash
git add database-backups/
git commit -m "Add database backup YYYYMMDD"
git push
```

**Option 3: USB/Email**

-   Copy file ra USB
-   Hoặc email (nếu file < 25MB)

> **⚠️ BẢO MẬT:**
>
> -   KHÔNG commit file backup lên GitHub public
> -   File chứa dữ liệu nhạy cảm (emails, passwords, user data)

---

### **📥 Restore Database (Máy B - Máy Mới)**

#### **Bước 1: Setup Project**

```bash
# Clone code
git clone https://github.com/thuanthichlaptrinh/card_words.git
cd card_words

# Tạo file .env (xem mục Setup Lần Đầu)

# Khởi động Docker
docker-compose up -d

# Đợi 30-60 giây
```

#### **Bước 2: Download File Backup**

-   Tải file `.sql` từ Google Drive/GitHub/USB
-   Đặt vào thư mục `database-backups/`

#### **Bước 3: Restore Database**

```bash
# Windows
./restore-database.bat database-backups/card_words_YYYYMMDD_HHMM.sql

# Linux/Mac
chmod +x restore-database.sh
./restore-database.sh database-backups/card_words_YYYYMMDD_HHMM.sql
```

#### **Bước 4: Kiểm Tra**

```bash
# Kiểm tra logs
docker-compose logs app

# Hoặc truy cập Swagger UI
# http://localhost:8080/swagger-ui/index.html
```

---

## 🎯 Quy Trình Làm Việc Hàng Ngày

### **Bắt Đầu Làm Việc:**

```bash
# Pull code mới nhất
git pull

# Khởi động Docker (nếu chưa chạy)
docker-compose up -d

# Kiểm tra status
docker-compose ps
```

### **Kết Thúc Làm Việc:**

```bash
# 1. Backup database
./backup-database.bat

# 2. Commit code changes
git add .
git commit -m "Your commit message"
git push

# 3. (Optional) Dừng Docker để tiết kiệm RAM
docker-compose down
```

> **💡 Lưu ý:** Nên backup database **SAU MỖI BUỔI LÀM VIỆC** để tránh mất dữ liệu!

---

## 🔧 Quản Lý Docker

### **Khởi Động/Dừng Services**

```bash
# Khởi động tất cả
docker-compose up -d

# Khởi động service cụ thể
docker-compose up -d app
docker-compose up -d postgres
docker-compose up -d redis

# Dừng tất cả (GIỮ data)
docker-compose down

# Dừng và XÓA volumes (MẤT HẾT data)
docker-compose down -v
```

### **Restart Services**

```bash
# Restart tất cả
docker-compose restart

# Restart service cụ thể
docker-compose restart app
docker-compose restart postgres
```

### **Rebuild Sau Khi Sửa Code**

```bash
# Rebuild và restart
docker-compose up -d --build

# Hoặc rebuild riêng app
docker-compose up -d --build app
```

### **Xem Logs**

```bash
# Logs của app
docker-compose logs app

# Logs realtime (follow)
docker-compose logs -f app

# Logs 100 dòng cuối
docker-compose logs --tail=100 app

# Logs tất cả services
docker-compose logs
```

### **Truy Cập Container Shell**

```bash
# Vào container app (bash)
docker exec -it card-words-app sh

# Vào PostgreSQL container
docker exec -it card-words-postgres bash

# Kết nối PostgreSQL CLI
docker exec -it card-words-postgres psql -U postgres -d card_words

# Kết nối Redis CLI
docker exec -it card-words-redis redis-cli
```

### **Kiểm Tra Resource Usage**

```bash
# CPU, RAM, Network usage
docker stats

# Disk usage
docker system df

# Chi tiết volumes
docker volume ls
```

### **Dọn Dẹp Docker**

```bash
# Xóa containers đã dừng
docker container prune

# Xóa images không dùng
docker image prune -a

# Xóa volumes không dùng
docker volume prune

# Xóa TẤT CẢ (cẩn thận!)
docker system prune -a --volumes
```

---

## ⚙️ Cấu Hình Nâng Cao

### **Thay Đổi Port**

Sửa file `.env`:

```properties
# Đổi port API server
SERVER_PORT=9090

# Đổi port PgAdmin
PGADMIN_PORT=5555
```

Sau đó restart:

```bash
docker-compose down
docker-compose up -d
```

### **Thay Đổi Database Password**

1. Sửa file `.env`:

```properties
POSTGRES_PASSWORD=new_password_here
```

2. Xóa volume cũ và tạo mới:

```bash
docker-compose down -v
docker-compose up -d
```

3. Restore data từ backup (nếu cần)

### **Tăng RAM/CPU cho Docker**

**Windows/Mac (Docker Desktop):**

1. Docker Desktop → Settings → Resources
2. Tăng Memory (RAM) và CPUs
3. Click "Apply & Restart"

---

## 🐛 Troubleshooting

### **Lỗi: Port đã được sử dụng**

```
Error: bind: address already in use
```

**Giải pháp:**

```bash
# Windows - Tìm process đang dùng port 8080
netstat -ano | findstr :8080

# Kill process (thay PID)
taskkill /PID <PID> /F

# Linux/Mac
lsof -i :8080
kill -9 <PID>

# Hoặc đổi port trong .env
SERVER_PORT=9090
```

### **Lỗi: Docker daemon không chạy**

```
Cannot connect to the Docker daemon
```

**Giải pháp:**

1. Mở Docker Desktop
2. Đợi Docker khởi động xong (icon Docker chuyển sang màu xanh)
3. Chạy lại `docker-compose up -d`

### **Lỗi: Out of memory**

```
Exit code 137 (Out of memory)
```

**Giải pháp:**

1. Tăng RAM cho Docker (Settings → Resources)
2. Dọn dẹp Docker:

```bash
docker system prune -a
```

### **Lỗi: Database connection failed**

**Kiểm tra:**

```bash
# Xem logs PostgreSQL
docker-compose logs postgres

# Test connection
docker exec -it card-words-postgres psql -U postgres -d card_words
```

**Nếu database chưa tồn tại:**

```bash
docker exec -it card-words-postgres psql -U postgres -c "CREATE DATABASE card_words;"
```

### **Lỗi: Redis connection refused**

**Kiểm tra:**

```bash
# Xem logs Redis
docker-compose logs redis

# Test connection
docker exec -it card-words-redis redis-cli PING
# Kết quả: PONG
```

### **Lỗi: Cannot build - Maven dependencies**

```
Failed to download dependencies
```

**Giải pháp:**

```bash
# Xóa cache và rebuild
docker-compose down
docker-compose build --no-cache app
docker-compose up -d
```

### **App chạy chậm hoặc không response**

**Kiểm tra:**

```bash
# Xem resource usage
docker stats

# Xem logs lỗi
docker-compose logs app | grep -i error

# Restart app
docker-compose restart app
```

---

## 📚 Tài Liệu Tham Khảo

-   [Docker Documentation](https://docs.docker.com/)
-   [Docker Compose Documentation](https://docs.docker.com/compose/)
-   [Spring Boot with Docker](https://spring.io/guides/gs/spring-boot-docker/)
-   [PostgreSQL Docker Hub](https://hub.docker.com/_/postgres)
-   [Redis Docker Hub](https://hub.docker.com/_/redis)

---

## 📞 Hỗ Trợ

Nếu gặp vấn đề:

1. Kiểm tra mục [Troubleshooting](#-troubleshooting)
2. Xem logs: `docker-compose logs`
3. Tạo issue trên GitHub với thông tin:
    - Hệ điều hành
    - Docker version: `docker --version`
    - Logs lỗi
    - Các bước đã thực hiện

---

## 🔄 Cập Nhật Phiên Bản

```bash
# Pull code mới nhất
git pull

# Rebuild Docker
docker-compose down
docker-compose up -d --build

# Kiểm tra logs
docker-compose logs -f app
```

---

**Cập nhật lần cuối:** 2025-11-07
