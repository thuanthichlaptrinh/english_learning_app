# Hướng dẫn Fix Lỗi Migration V7

## Vấn đề
Migration V7 đang gặp lỗi khi cố gắng thêm các cột vào bảng `action_logs`.

## Nguyên nhân
- Bảng `action_logs` có thể đã được tạo bởi Hibernate với đầy đủ các cột
- Migration V7 cố gắng thêm các cột đã tồn tại
- Flyway có thể đã đánh dấu migration V7 là failed hoặc checksum không khớp

## Giải pháp

### Bước 1: Kiểm tra trạng thái migration
Kết nối vào PostgreSQL database và chạy:
```sql
SELECT version, description, type, script, checksum, installed_on, execution_time, success
FROM flyway_schema_history
WHERE version = '7';
```

### Bước 2: Xác định tình huống

#### Tình huống A: Migration V7 chưa chạy
Nếu không có bản ghi version = '7' trong `flyway_schema_history`:
- Chỉ cần restart ứng dụng, Flyway sẽ tự động chạy migration V7 đã được sửa

#### Tình huống B: Migration V7 đã chạy nhưng FAILED (success = false)
Chạy lệnh sau để xóa bản ghi failed:
```sql
DELETE FROM flyway_schema_history WHERE version = '7' AND success = false;
```
Sau đó restart ứng dụng.

#### Tình huống C: Migration V7 đã chạy thành công nhưng checksum thay đổi
Chạy lệnh sau để xóa bản ghi cũ:
```sql
DELETE FROM flyway_schema_history WHERE version = '7';
```
Sau đó restart ứng dụng.

#### Tình huống D: Muốn fix thủ công không dùng Flyway
Chạy script `fix_flyway_v7.sql` hoặc chạy trực tiếp:
```sql
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'action_logs' AND column_name = 'user_email'
    ) THEN
        ALTER TABLE action_logs ADD COLUMN user_email VARCHAR(100);
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'action_logs' AND column_name = 'user_name'
    ) THEN
        ALTER TABLE action_logs ADD COLUMN user_name VARCHAR(100);
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'action_logs' AND column_name = 'action_category'
    ) THEN
        ALTER TABLE action_logs ADD COLUMN action_category VARCHAR(50);
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'action_logs' AND column_name = 'metadata'
    ) THEN
        ALTER TABLE action_logs ADD COLUMN metadata TEXT;
    END IF;
END $$;
```

### Bước 3: Verify kết quả
Kiểm tra cấu trúc bảng `action_logs`:
```sql
SELECT column_name, data_type, character_maximum_length, is_nullable
FROM information_schema.columns
WHERE table_name = 'action_logs'
ORDER BY ordinal_position;
```

Đảm bảo các cột sau tồn tại:
- `user_email` (VARCHAR 100)
- `user_name` (VARCHAR 100)
- `action_category` (VARCHAR 50)
- `metadata` (TEXT)

## Lưu ý quan trọng

### Nếu dùng Docker/Docker Compose
```bash
# Stop container
docker-compose down

# Xóa volume nếu muốn reset database hoàn toàn (CẨN THẬN: Mất hết data)
docker-compose down -v

# Start lại
docker-compose up -d
```

### Nếu chạy local
```bash
# Restart Spring Boot application
mvn spring-boot:run
```

## Các file đã được sửa
- `V7__add_action_logs_table.sql` - Migration đã được sửa để tương thích với PostgreSQL
- `fix_flyway_v7.sql` - Script để fix thủ công
- `MIGRATION_FIX_GUIDE.md` - Hướng dẫn này

## Cách kết nối PostgreSQL

### Dùng psql command line
```bash
psql -h localhost -p 5432 -U your_username -d your_database
```

### Dùng pgAdmin hoặc DBeaver
Kết nối với thông tin từ file `.env` hoặc `application.yml`

## Kiểm tra logs
Xem logs của Spring Boot để biết lỗi cụ thể:
```bash
# Nếu dùng Docker
docker-compose logs -f app

# Nếu chạy local, xem console output
```

## Liên hệ
Nếu vẫn gặp vấn đề, cung cấp:
1. Log lỗi đầy đủ từ Spring Boot
2. Kết quả query `SELECT * FROM flyway_schema_history WHERE version = '7'`
3. Kết quả query kiểm tra cấu trúc bảng `action_logs`
