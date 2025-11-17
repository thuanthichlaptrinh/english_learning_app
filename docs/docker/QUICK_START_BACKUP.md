# 🚀 HƯỚNG DẪN BACKUP & RESTORE NHANH

## ✅ ĐÃ SETUP XONG - SẴN SÀNG SỬ DỤNG!

### 📦 CÁC FILE ĐÃ CÓ:

```
card-words/
├── backup-database.bat      ✅ Script backup (Windows)
├── backup-database.sh       ✅ Script backup (Linux/Mac)
├── restore-database.bat     ✅ Script restore (Windows)
├── restore-database.sh      ✅ Script restore (Linux/Mac)
├── auto-backup.bat          ✅ Script tự động backup (optional)
├── auto-backup.sh           ✅ Script tự động backup (optional)
└── database-backups/        ✅ Folder chứa backup files
    ├── card_words_20251106_180430.sql  ← Backup mẫu đã tạo
    └── README.md
```

---

## 📖 HƯỚNG DẪN SỬ DỤNG

### 1️⃣ BACKUP DATABASE (Trên máy có data)

**Windows:**

```bash
backup-database.bat
```

**Linux/Mac/Git Bash:**

```bash
./backup-database.sh
```

**Kết quả:**

```
🔄 Starting database backup...
✅ Backup successful: ./database-backups/card_words_20251106_180430.sql
📦 File size: 560K
```

File backup được lưu tại: `database-backups/card_words_YYYYMMDD_HHMMSS.sql`

---

### 2️⃣ SHARE BACKUP FILE

**Cách 1: Qua Git (Khuyên dùng)**

```bash
# Add backup file vào Git
git add database-backups/*.sql
git commit -m "Update database backup - $(date +%Y%m%d)"
git push origin main
```

**Cách 2: Qua Google Drive / Dropbox**

-   Copy folder `database-backups/` vào Drive
-   Share link với team

**Cách 3: Qua USB / Network**

-   Copy file `.sql` trực tiếp

---

### 3️⃣ RESTORE DATABASE (Trên máy khác)

**Bước 1: Pull code + backup file**

```bash
git pull origin main
```

**Bước 2: Đảm bảo Docker đang chạy**

```bash
docker-compose up -d
docker logs -f card-words-app
# Đợi đến khi thấy: "Started CardWordsApplication"
```

**Bước 3: Restore database**

**Windows:**

```bash
restore-database.bat database-backups\card_words_20251106_180430.sql
```

**Linux/Mac/Git Bash:**

```bash
./restore-database.sh database-backups/card_words_20251106_180430.sql
```

**Xác nhận:**

```
⚠️  WARNING: This will REPLACE all data in Docker database!
Continue? (yes/no): yes
```

**Kết quả:**

```
🔄 Starting database restore...
✅ Restore successful!
🚀 App restarted
```

---

## 🔄 QUY TRÌNH LÀM VIỆC HẰNG NGÀY

### 🖥️ Trên máy CHÍNH (Developer)

**Cuối mỗi ngày làm việc (nếu có thay đổi database):**

```bash
# 1. Backup database
./backup-database.sh

# 2. Commit vào Git
git add database-backups/*.sql
git commit -m "Database backup $(date +%Y-%m-%d)"
git push

# ✅ Done!
```

---

### 👥 Trên máy KHÁC (Team members)

**Đầu mỗi ngày (hoặc khi cần update):**

```bash
# 1. Pull code mới
git pull

# 2. Kiểm tra có backup mới không
ls -lh database-backups/

# 3. Nếu có file mới, restore
./restore-database.sh database-backups/card_words_<latest>.sql

# ✅ Done! Database đã được update
```

---

## 💡 MẸO VÀ BEST PRACTICES

### ✅ Nên làm:

1. **Backup trước khi shutdown máy**

    ```bash
    ./backup-database.sh && docker-compose down
    ```

2. **Đặt tên backup có ý nghĩa (nếu cần)**

    ```bash
    # Rename file backup
    mv database-backups/card_words_20251106_180430.sql \
       database-backups/card_words_after_phase3_complete.sql
    ```

3. **Kiểm tra backup thành công**

    ```bash
    # Xem kích thước file
    ls -lh database-backups/

    # Nếu file < 100KB → Có thể bị lỗi
    # File bình thường: 500KB - 1MB
    ```

4. **Test restore trên máy local trước**

    ```bash
    # Backup hiện tại
    ./backup-database.sh

    # Test restore
    ./restore-database.sh database-backups/card_words_test.sql

    # Nếu lỗi → Rollback
    ./restore-database.sh database-backups/card_words_<previous>.sql
    ```

---

### ❌ Tránh làm:

1. **ĐỪNG xóa tất cả backup cũ**

    - Script tự động giữ 5 file gần nhất
    - Luôn có backup dự phòng

2. **ĐỪNG commit backup có sensitive data vào public repo**

    - Add vào `.gitignore` nếu repo là public
    - Hoặc dùng private repo

3. **ĐỪNG restore khi app đang xử lý request**
    - Stop app trước: `docker stop card-words-app`
    - Restore
    - Start lại: `docker start card-words-app`

---

## 🔧 TROUBLESHOOTING

### ❌ Lỗi: "docker: command not found"

**Nguyên nhân:** Docker chưa chạy

**Giải pháp:**

```bash
# Kiểm tra Docker
docker ps

# Nếu không chạy → Start Docker Desktop
# Hoặc start services:
docker-compose up -d
```

---

### ❌ Lỗi: "ERROR: duplicate key value violates unique constraint"

**Nguyên nhân:** Database chưa được clear trước khi restore

**Giải pháp:**

```bash
# Drop và recreate database
docker exec -it card-words-postgres psql -U postgres -c "DROP DATABASE card_words;"
docker exec -it card-words-postgres psql -U postgres -c "CREATE DATABASE card_words;"

# Restore lại
./restore-database.sh database-backups/card_words_<file>.sql
```

---

### ❌ Lỗi: "FATAL: database 'card_words' does not exist"

**Nguyên nhân:** Database chưa được tạo

**Giải pháp:**

```bash
# Tạo database
docker exec -it card-words-postgres psql -U postgres -c "CREATE DATABASE card_words;"

# Restore
./restore-database.sh database-backups/card_words_<file>.sql
```

---

### ❌ File backup quá lớn (>10MB)

**Giải pháp 1: Compress**

```bash
# Compress file
gzip database-backups/card_words_*.sql

# Kết quả: card_words_20251106_180430.sql.gz

# Decompress khi cần
gunzip database-backups/card_words_20251106_180430.sql.gz
```

**Giải pháp 2: Git LFS**

```bash
# Install Git LFS
git lfs install

# Track large files
git lfs track "database-backups/*.sql"

# Commit
git add .gitattributes database-backups/
git commit -m "Add database backup with LFS"
git push
```

---

## 📊 KIỂM TRA BACKUP ĐÃ HOẠT ĐỘNG

### Test 1: Backup có data không?

```bash
# Xem nội dung file backup
head -n 50 database-backups/card_words_20251106_180430.sql
```

**Kết quả mong đợi:** Thấy các câu lệnh SQL:

```sql
CREATE TABLE users (...);
CREATE TABLE vocab (...);
INSERT INTO users VALUES (...);
INSERT INTO vocab VALUES (...);
```

---

### Test 2: Restore có thành công không?

```bash
# Backup hiện tại
./backup-database.sh

# Count records TRƯỚC restore
docker exec -it card-words-postgres psql -U postgres -d card_words -c "SELECT COUNT(*) FROM vocab;"

# Restore
./restore-database.sh database-backups/card_words_<file>.sql

# Count records SAU restore
docker exec -it card-words-postgres psql -U postgres -d card_words -c "SELECT COUNT(*) FROM vocab;"

# So sánh 2 số → Phải giống nhau
```

---

### Test 3: App có chạy được không?

```bash
# Sau khi restore
docker logs -f card-words-app

# Kiểm tra API
curl http://localhost:8080/api/v1/health
# Hoặc mở browser: http://localhost:8080/swagger-ui.html
```

---

## 📞 HỖ TRỢ

### Kiểm tra logs backup/restore:

**Windows:**

```bash
type backup-log.txt
```

**Linux/Mac:**

```bash
cat backup-log.txt
```

---

### Liên hệ:

-   📧 Email: thuanthichlaptrinh@gmail.com
-   📁 Repository: https://github.com/thuanthichlaptrinh/card_words
-   📖 Docs: `docs/DATABASE_SYNC_GUIDE.md`

---

## 🎯 TÓM TẮT

| Hành động        | Command (Windows)             | Command (Linux/Mac)            |
| ---------------- | ----------------------------- | ------------------------------ |
| **Backup**       | `backup-database.bat`         | `./backup-database.sh`         |
| **Restore**      | `restore-database.bat <file>` | `./restore-database.sh <file>` |
| **List backups** | `dir database-backups`        | `ls -lh database-backups/`     |
| **Check Docker** | `docker ps`                   | `docker ps`                    |
| **View logs**    | `docker logs card-words-app`  | `docker logs card-words-app`   |

---

## ✅ CHECKLIST SETUP (ĐÃ HOÀN THÀNH)

-   [x] Script backup-database.bat / .sh
-   [x] Script restore-database.sh / .bat
-   [x] Folder database-backups/
-   [x] Test backup thành công (560KB file)
-   [x] README hướng dẫn sử dụng
-   [x] Troubleshooting guide
-   [x] Best practices

**🎉 BẠN ĐÃ SẴN SÀNG SỬ DỤNG!**

---

**Ngày tạo:** 2025-11-06  
**Version:** 1.0  
**Status:** ✅ Production Ready
