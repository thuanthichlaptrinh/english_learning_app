# 📦 Database Backups

Folder này chứa các file backup của database PostgreSQL từ Docker.

## 📁 Files

-   `card_words_YYYYMMDD_HHMMSS.sql` - Database backup files (timestamped)
-   `README.md` - Hướng dẫn sử dụng

---

## 🚀 Cách Sử Dụng

### 📦 Backup Database

Chạy từ **thư mục gốc** (card-words/):

**Linux/Mac/Git Bash:**

```bash
./backup-database.sh
```

**Windows CMD:**

```cmd
./backup-database.bat
```

**Kết quả:**

```
✅ Backup successful: ./database-backups/card_words_20251106_181617.sql
📦 File size:
```

---

### 📥 Restore Database

Chạy từ **thư mục gốc** (card-words/):

**Linux/Mac/Git Bash:**

```bash
./restore-database.sh database-backups/card_words_20251106_181617.sql
```

**Windows CMD:**
Đầu tiên dùng lệnh: git pull để lấy file backup mới nhất từ github, sau đó:

```cmd
./restore-database.bat database-backups\card_words_latest.sql
```

**Xác nhận:**

```
⚠️  WARNING: This will REPLACE all data in Docker database!
Continue? (yes/no): yes
```

**Kết quả:**

```
✅ Restore successful!
🚀 App restarted
```

---

## 📋 Chính Sách Lưu Trữ

-   ✅ Script tự động giữ **5 backup gần nhất**
-   ✅ Các backup cũ hơn sẽ tự động xóa
-   ✅ Format tên file: `card_words_YYYYMMDD_HHMMSS.sql`

---

### 💡 Khuyến nghị:

## 📖 Tài Liệu Chi Tiết

| File                                                                  | Mô tả                                |
| --------------------------------------------------------------------- | ------------------------------------ |
| [QUICK_START_BACKUP.md](../docs/docker/QUICK_START_BACKUP.md)         | Hướng dẫn đầy đủ backup/restore      |
| [DATABASE_SYNC_GUIDE.md](../docs/docker/DATABASE_SYNC_GUIDE.md)       | So sánh 3 phương án đồng bộ database |
| [OPTION1_SETUP_COMPLETE.md](../docs/docker/OPTION1_SETUP_COMPLETE.md) | Tổng kết setup Option 1              |

---

## 🔧 Troubleshooting

### ❌ "docker: command not found"

```bash
# Kiểm tra Docker
docker ps

# Start containers
cd .. && docker-compose up -d
```

### ❌ "ERROR: duplicate key"

```bash
# Drop database trước
docker exec -it card-words-postgres psql -U postgres -c "DROP DATABASE card_words; CREATE DATABASE card_words;"

# Restore lại
./restore-database.sh database-backups/card_words_*.sql
```

### ❌ File backup quá lớn (>10MB)

```bash
# Compress file
gzip database-backups/card_words_*.sql
# → card_words_20251106_181617.sql.gz
```

---
