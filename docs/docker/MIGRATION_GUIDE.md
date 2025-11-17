## 📋 Tóm tắt thay đổi

### ✅ Đã hoàn thành:

1. ✅ Cập nhật `docker-compose.yml` root - sử dụng 100% environment variables
2. ✅ Cấu hình external volumes để giữ nguyên dữ liệu cũ
3. ✅ Tổ chức lại file `.env` với cấu trúc rõ ràng
4. ✅ Thêm default values cho tất cả biến môi trường

---

## 🔧 Các thay đổi chi tiết

### 1. File `docker-compose.yml` (Root)

**Trước:**

-   ❌ Hardcoded ports: `5433:5432`, `8080:8080`, `8001:8001`
-   ❌ Hardcoded values: `postgres`, `redis`, `0.0.0.0`
-   ❌ Local volumes (sẽ tạo volumes mới → mất data)

**Sau:**

-   ✅ Tất cả ports sử dụng biến môi trường
-   ✅ Tất cả values sử dụng biến môi trường với default values
-   ✅ External volumes trỏ đến volumes cũ (giữ nguyên data)

### 2. File `.env`

**Được tổ chức lại thành các sections:**

```
- Server Configuration
- Database Configuration (PostgreSQL)
- Cache Configuration (Redis)
- Mail Configuration
- JWT Configuration
- Google OAuth2 Configuration
- Firebase Storage
- PgAdmin Configuration
- Redis Insight Configuration
- AI Service Configuration
- Docker Volumes Configuration (MỚI)
```

### 3. File `card-words/docker-compose.yml`

**Quyết định:** ✅ **NÊN XÓA**

**Lý do:**

-   Đã có file docker-compose.yml chung ở root
-   Tránh nhầm lẫn khi dev chạy `docker-compose up`
-   Tuân thủ nguyên tắc monorepo (1 file cấu hình duy nhất)

---

## 📝 Hướng dẫn thực hiện

### Bước 1: Backup dữ liệu (BẮT BUỘC)

```powershell
# Di chuyển vào thư mục card-words cũ
cd "d:\Learn\HUFI\Năm 4\HK1\khoa_luan\project\server\card-words"

# Backup PostgreSQL database
docker-compose exec postgres pg_dump -U postgres card_words > ../backup_before_migration_$(Get-Date -Format 'yyyyMMdd_HHmmss').sql

# Backup Redis data (optional)
docker-compose exec redis redis-cli SAVE
```

### Bước 2: Stop containers cũ

```powershell
cd "d:\Learn\HUFI\Năm 4\HK1\khoa_luan\project\server\card-words"
docker-compose down
```

**⚠️ LƯU Ý:** Không dùng `docker-compose down -v` vì sẽ xóa volumes!

### Bước 3: Xóa file docker-compose.yml trong card-words

```powershell
# Xóa file docker-compose.yml cũ
Remove-Item "d:\Learn\HUFI\Năm 4\HK1\khoa_luan\project\server\card-words\docker-compose.yml"

# Xóa file .env local (nếu có)
if (Test-Path "d:\Learn\HUFI\Năm 4\HK1\khoa_luan\project\server\card-words\.env") {
    Remove-Item "d:\Learn\HUFI\Năm 4\HK1\khoa_luan\project\server\card-words\.env"
}
```

### Bước 4: Start services mới từ root

```powershell
cd "d:\Learn\HUFI\Năm 4\HK1\khoa_luan\project\server"
docker-compose up -d
```

### Bước 5: Verify

```powershell
# Kiểm tra tất cả containers
docker-compose ps

# Kiểm tra volumes (phải là volumes cũ)
docker volume ls | Select-String "card-words"

# Kiểm tra logs
docker-compose logs -f card-words-api
docker-compose logs -f card-words-ai

# Kiểm tra health
docker-compose ps
```

**Expected output:**

```
card-words-postgres     running (healthy)
card-words-pgadmin      running
card-words-redis        running (healthy)
card-words-redisinsight running
card-words-api          running (healthy)
card-words-ai           running (healthy)
```

### Bước 6: Test kết nối

```powershell
# Test Spring Boot API
curl http://localhost:8080/actuator/health

# Test AI Service
curl http://localhost:8001/health

# Test Database connection
docker-compose exec postgres psql -U postgres -d card_words -c "\dt"
```

---

## 🔄 Migration Git Repository

### Tạo repo mới `card_words_services` và giữ 55 commits

```powershell
# Bước 1: Khởi tạo git ở thư mục root
cd "d:\Learn\HUFI\Năm 4\HK1\khoa_luan\project\server"
git init

# Bước 2: Import lịch sử từ card-words
git remote add card-words-origin ./card-words
git fetch card-words-origin
git merge --allow-unrelated-histories card-words-origin/main -m "Import card-words with 55 commits history"

# Bước 3: Remove remote cũ để tránh conflict
git remote remove card-words-origin

# Bước 4: Add card-words-ai
git add card-words-ai/
git commit -m "Add card-words-ai service"

# Bước 5: Add các files chung
git add docker-compose.yml .env README.MD docs/ MIGRATION_GUIDE.md
git commit -m "Add monorepo configuration and documentation"

# Bước 6: Tạo repo mới trên GitHub
# Truy cập: https://github.com/new
# Repository name: card_words_services
# Description: Monorepo for Card Words Services (Spring Boot + FastAPI AI)

# Bước 7: Connect và push
git remote add origin https://github.com/thuanthichlaptrinh/card_words_services.git
git branch -M main
git push -u origin main

# Bước 8: Verify
git log --oneline
# Phải thấy 55+ commits
```

---

## 📊 So sánh Before/After

### Volumes (Không mất dữ liệu)

**Before:**

```yaml
volumes:
    postgres_data:
        driver: local # Tạo volume mới: server_postgres_data
```

**After:**

```yaml
volumes:
    postgres_data:
        external: true
        name: card-words_postgres_data # Dùng volume cũ
```

### Environment Variables

**Before:**

```yaml
environment:
    - POSTGRES_HOST=postgres # Hardcoded
    - REDIS_HOST=redis # Hardcoded
```

**After:**

```yaml
environment:
    - POSTGRES_HOST=${POSTGRES_HOST:-postgres} # From .env with default
    - REDIS_HOST=${REDIS_HOST:-redis} # From .env with default
```

---

## ⚠️ Lưu ý quan trọng

### 1. Volumes và Data Safety

✅ **KHÔNG MẤT DỮ LIỆU** vì:

-   Sử dụng `external: true` + `name: card-words_postgres_data`
-   Volumes cũ vẫn tồn tại: `docker volume ls`
-   Docker sẽ mount đúng volumes cũ

### 2. Port Configuration

| Service       | Internal Port | External Port | Environment Variable     |
| ------------- | ------------- | ------------- | ------------------------ |
| PostgreSQL    | 5432          | 5433          | `POSTGRES_EXTERNAL_PORT` |
| Redis         | 6379          | 6379          | `REDIS_EXTERNAL_PORT`    |
| Spring Boot   | 8080          | 8080          | `SERVER_SPRING_PORT`     |
| AI Service    | 8001          | 8001          | `SERVER_FLASH_PORT`      |
| PgAdmin       | 80            | 5050          | `PGADMIN_PORT`           |
| Redis Insight | 5540          | 5540          | `REDISINSIGHT_PORT`      |

### 3. Network Communication

**Trong Docker network:**

-   Spring Boot → PostgreSQL: `postgres:5432`
-   Spring Boot → Redis: `redis:6379`
-   Spring Boot → AI: `http://card-words-ai:8001`
-   AI → PostgreSQL: `postgres:5432`
-   AI → Redis: `redis:6379`

**Từ host machine:**

-   PostgreSQL: `localhost:5433`
-   Redis: `localhost:6379`
-   Spring Boot: `localhost:8080`
-   AI Service: `localhost:8001`

---

## 🧪 Troubleshooting

### Lỗi: Cannot find volume

```powershell
# Kiểm tra volumes tồn tại
docker volume ls | Select-String "card-words"

# Nếu không có, tạo volumes
docker volume create card-words_postgres_data
docker volume create card-words_redis_data
docker volume create card-words_pgadmin_data
docker volume create card-words_redisinsight_data
```

### Lỗi: Port already in use

```powershell
# Kiểm tra port đang được sử dụng
netstat -ano | findstr :8080

# Stop process hoặc thay đổi port trong .env
# Ví dụ: SERVER_SPRING_PORT=8081
```

### Lỗi: Database connection failed

```powershell
# Kiểm tra PostgreSQL logs
docker-compose logs postgres

# Kiểm tra network
docker network inspect card-words-network

# Test connection
docker-compose exec card-words-api sh -c "apk add postgresql-client && psql -h postgres -U postgres -d card_words -c '\dt'"
```

---

## ✅ Checklist

-   [ ] Backup database thành công
-   [ ] Stop containers cũ
-   [ ] Xóa `card-words/docker-compose.yml`
-   [ ] Xóa `card-words/.env` (nếu có)
-   [ ] Start services mới từ root
-   [ ] Verify tất cả containers healthy
-   [ ] Test API endpoints
-   [ ] Verify data không bị mất
-   [ ] Migration git repository
-   [ ] Push lên GitHub mới
-   [ ] Update README.md với hướng dẫn mới
-   [ ] Thông báo team về thay đổi

---

## 📞 Support

Nếu gặp vấn đề, kiểm tra:

1. Logs: `docker-compose logs -f [service-name]`
2. Container status: `docker-compose ps`
3. Network: `docker network inspect card-words-network`
4. Volumes: `docker volume ls`

---

**Generated:** 2025-11-17  
**Version:** 1.0.0
