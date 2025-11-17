# Hướng Dẫn Đồng Bộ Database Giữa Các Máy

## ⚠️ VẤN ĐỀ

Docker volumes **KHÔNG TỰ ĐỘNG đồng bộ** giữa các máy. Mỗi máy có 1 volume độc lập.

```
Máy A: postgres_data (806 vocab)  ❌  Máy B: postgres_data (rỗng)
       KHÔNG ĐỒNG BỘ
```

---

## 💡 GIẢI PHÁP

### Option 1: Manual Backup/Restore (Đơn giản nhất)

**Khi nào cần:**
- Team nhỏ (2-5 người)
- Update data không thường xuyên
- Cần kiểm soát version

**Cách dùng:**

```bash
# Máy A (có data mới):
./backup-database.bat
# → Tạo file: database-backups/card_words_20250116_120000.sql

# Share file qua Git/Drive/Email

# Máy B (cần update):
./restore-database.bat database-backups/card_words_20250116_120000.sql
```

**Ưu điểm:**
- ✅ Đơn giản, dễ hiểu
- ✅ Có version history
- ✅ Không cần infrastructure

**Nhược điểm:**
- ❌ Thủ công
- ❌ Có thể quên
- ❌ Không real-time

---

### Option 2: Shared Database Server (Production-grade)

**Khi nào cần:**
- Team lớn (5+ người)
- Cần real-time sync
- Production environment

**Cách setup:**

1. **Thuê Database Server** (chọn 1):
   - AWS RDS PostgreSQL
   - Google Cloud SQL
   - Azure Database
   - DigitalOcean Managed Database
   - Hoặc VPS + PostgreSQL

2. **Cấu hình:**

   ```bash
   # Copy file mẫu
   cp .env.shared-db-example .env
   
   # Sửa thông tin database server
   POSTGRES_HOST=your-database-server.com
   POSTGRES_PORT=5432
   POSTGRES_USER=cardwords
   POSTGRES_PASSWORD=YourStrongPassword
   ```

3. **Chạy app:**

   ```bash
   # Dùng config shared database
   docker-compose -f docker-compose.shared-db.yml up -d
   ```

4. **Import data lần đầu:**

   ```bash
   # Restore data vào shared database
   psql -h your-database-server.com -U cardwords -d card_words < backup.sql
   ```

**Ưu điểm:**
- ✅ Real-time sync
- ✅ Không cần backup/restore
- ✅ Tất cả máy luôn cùng data

**Nhược điểm:**
- ❌ Tốn chi phí (database server)
- ❌ Cần internet
- ❌ Phức tạp hơn

**Chi phí ước tính:**
- AWS RDS db.t3.micro: ~$15/tháng
- DigitalOcean Managed DB: ~$15/tháng
- VPS + PostgreSQL: ~$5-10/tháng

---

### Option 3: Automated Backup + Cloud Sync

**Khi nào cần:**
- Muốn tự động hóa
- Team size trung bình
- Budget hạn chế

**Cách setup:**

1. **Install rclone** (tool sync cloud storage):
   ```bash
   # Windows (Chocolatey)
   choco install rclone
   
   # Linux
   sudo apt install rclone
   
   # Mac
   brew install rclone
   ```

2. **Config cloud storage:**
   ```bash
   rclone config
   # Chọn: Google Drive / Dropbox / OneDrive
   ```

3. **Edit auto-backup script:**
   ```bash
   # Mở file: auto-backup.bat (Windows) hoặc auto-backup.sh (Linux)
   # Uncomment dòng upload cloud (line 20-30)
   
   # Ví dụ: Google Drive
   rclone copy database-backups/ gdrive:card-words-backups/
   ```

4. **Setup scheduled task:**

   **Windows (Task Scheduler):**
   ```
   1. Mở Task Scheduler
   2. Create Basic Task
   3. Name: "Card Words Auto Backup"
   4. Trigger: Daily 2:00 AM
   5. Action: Start a program
   6. Program: D:\path\to\auto-backup.bat
   7. Save
   ```

   **Linux/Mac (cron):**
   ```bash
   crontab -e
   
   # Thêm dòng (backup mỗi ngày 2:00 AM):
   0 2 * * * /path/to/card-words/auto-backup.sh
   ```

5. **Auto-download trên máy khác:**
   ```bash
   # Download backup mới nhất từ cloud
   rclone sync gdrive:card-words-backups/ database-backups/
   
   # Restore
   ./restore-database.sh database-backups/card_words_latest.sql
   ```

**Ưu điểm:**
- ✅ Tự động backup
- ✅ Cloud storage (an toàn)
- ✅ Có version history
- ✅ Chi phí thấp (Google Drive free 15GB)

**Nhược điểm:**
- ❌ Vẫn cần restore thủ công
- ❌ Có delay (không real-time)

---

## 📊 SO SÁNH CÁC OPTION

| Tiêu chí | Option 1: Manual | Option 2: Shared DB | Option 3: Auto Sync |
|----------|------------------|---------------------|---------------------|
| **Độ phức tạp** | 🟢 Đơn giản | 🔴 Phức tạp | 🟡 Trung bình |
| **Chi phí** | 🟢 $0 | 🔴 $10-15/tháng | 🟢 $0 (free cloud) |
| **Real-time** | 🔴 Không | 🟢 Có | 🔴 Không |
| **Tự động** | 🔴 Thủ công | 🟢 Hoàn toàn | 🟡 Backup auto, restore manual |
| **Team size** | 🟢 2-5 người | 🟢 5+ người | 🟡 3-8 người |
| **Internet** | 🟢 Không cần | 🔴 Bắt buộc | 🟡 Cần khi sync |
| **Version control** | 🟢 Có | 🔴 Không | 🟢 Có |

---

## 🎯 KHUYẾN NGHỊ

**Nếu bạn là team nhỏ (1-3 người), đang học tập:**
→ Dùng **Option 1: Manual Backup/Restore**
- Đơn giản, không tốn tiền
- Đủ cho development

**Nếu bạn cần deploy production:**
→ Dùng **Option 2: Shared Database Server**
- Real-time sync
- Chuyên nghiệp
- Cần thiết cho production

**Nếu bạn muốn tự động nhưng không có budget:**
→ Dùng **Option 3: Auto Backup + Cloud**
- Tự động backup
- Free cloud storage
- Balance giữa manual và shared DB

---

## 📝 CHECKLIST SETUP

### Option 1: Manual (✅ Đã có sẵn)
- [x] backup-database.sh / .bat
- [x] restore-database.sh / .bat
- [x] database-backups/ folder
- [ ] Share backup files qua Git/Drive

### Option 2: Shared DB
- [ ] Thuê database server (AWS RDS / DigitalOcean / VPS)
- [ ] Config .env với thông tin server
- [ ] Import data lần đầu
- [ ] Test connection từ tất cả máy

### Option 3: Auto Sync
- [ ] Install rclone
- [ ] Config cloud storage (Google Drive / Dropbox)
- [ ] Edit auto-backup script (uncomment upload)
- [ ] Setup scheduled task (Task Scheduler / cron)
- [ ] Test auto backup

---

## 🆘 TROUBLESHOOTING

**Q: Backup file quá lớn (>100MB), không share được?**
- A: Compress file: `gzip database-backups/*.sql`
- A: Hoặc dùng Git LFS
- A: Hoặc upload lên Google Drive

**Q: Quên backup trước khi shutdown máy?**
- A: Setup auto-backup chạy trước khi shutdown
- A: Hoặc dùng shared database (không cần backup)

**Q: Database conflict khi 2 người cùng thay đổi?**
- A: Dùng shared database (real-time)
- A: Hoặc quy định: 1 người "database owner" chịu trách nhiệm backup

**Q: Restore bị lỗi "duplicate key"?**
- A: Drop database trước: `docker exec -it card-words-postgres psql -U postgres -c "DROP DATABASE card_words; CREATE DATABASE card_words;"`
- A: Rồi restore lại

---

## 📚 TÀI LIỆU THAM KHẢO

- [Docker Volumes Documentation](https://docs.docker.com/storage/volumes/)
- [PostgreSQL Backup & Restore](https://www.postgresql.org/docs/current/backup.html)
- [Rclone Setup Guide](https://rclone.org/docs/)
- [AWS RDS PostgreSQL](https://aws.amazon.com/rds/postgresql/)
