# 📖 Docker & Database Documentation Index

Tài liệu về Docker setup và quản lý database.

---

## 📦 Backup & Restore

### [📘 QUICK_START_BACKUP.md](./docker/QUICK_START_BACKUP.md)

**Hướng dẫn nhanh backup và restore database**

-   ✅ Hướng dẫn sử dụng chi tiết
-   ✅ Troubleshooting guide
-   ✅ Best practices
-   ✅ Test scripts
-   ✅ Quy trình làm việc hằng ngày

**Khi nào dùng:** Khi cần backup/restore database ngay

---

### [📗 DATABASE_SYNC_GUIDE.md](./docker/DATABASE_SYNC_GUIDE.md)

**So sánh 3 phương án đồng bộ database giữa các máy**

**Option 1: Manual Backup/Restore**

-   Đơn giản, không tốn tiền
-   Phù hợp team nhỏ (2-5 người)
-   Không real-time

**Option 2: Shared Database Server**

-   Real-time sync
-   Phù hợp team lớn, production
-   Chi phí: ~$10-15/tháng

**Option 3: Auto Backup + Cloud Sync**

-   Tự động backup định kỳ
-   Upload Google Drive/Dropbox
-   Chi phí: $0

**Khi nào dùng:** Khi cần quyết định phương án đồng bộ

---

### [📙 OPTION1_SETUP_COMPLETE.md](./OPTION1_SETUP_COMPLETE.md)

**Tổng kết setup Option 1 (Manual Backup/Restore)**

-   ✅ Các file đã tạo
-   ✅ Kết quả test
-   ✅ Hướng dẫn sử dụng
-   ✅ Checklist hoàn thành

**Khi nào dùng:** Sau khi setup xong, để kiểm tra lại

---

## 🚀 Quick Commands

### Backup Database

```bash
# Từ thư mục gốc (card-words/)
./backup-database.sh          # Linux/Mac/Git Bash
backup-database.bat           # Windows CMD
```

### Restore Database

```bash
# Từ thư mục gốc (card-words/)
./restore-database.sh database-backups/card_words_*.sql   # Linux/Mac
restore-database.bat database-backups\card_words_*.sql    # Windows
```

### Test Backup/Restore

```bash
# Từ thư mục gốc (card-words/)
./test-backup.sh              # Chạy test tự động
```

---

## 📂 Cấu Trúc Files

```
card-words/
├── backup-database.sh                ✅ Script backup (Linux/Mac)
├── backup-database.bat               ✅ Script backup (Windows)
├── restore-database.sh               ✅ Script restore (Linux/Mac)
├── restore-database.bat              ✅ Script restore (Windows)
├── test-backup.sh                    ✅ Script test
├── auto-backup.sh                    ✅ Auto backup (optional)
├── auto-backup.bat                   ✅ Auto backup (optional)
│
├── database-backups/                 📦 Folder chứa backup files
│   ├── card_words_*.sql              # Backup files
│   ├── README.md                     # Hướng dẫn folder
│   └── .gitignore-guide.md           # Hướng dẫn bảo mật
│
└── docs/
    ├── docker/
    │   ├── QUICK_START_BACKUP.md     📘 Hướng dẫn chi tiết backup/restore
    │   └── DATABASE_SYNC_GUIDE.md    📗 So sánh 3 options đồng bộ
    │
    ├── OPTION1_SETUP_COMPLETE.md     📙 Tổng kết setup
    └── DOCKER_DATABASE_INDEX.md      📖 File này
```

---

## 🎯 Workflow Hằng Ngày

### 👨‍💻 Developer (Máy chính)

**Cuối ngày (nếu có thay đổi database):**

```bash
./backup-database.sh
git add database-backups/*.sql
git commit -m "Database backup $(date +%Y-%m-%d)"
git push
```

---

### 👥 Team Members (Máy khác)

**Đầu ngày (hoặc khi cần sync):**

```bash
git pull
./restore-database.sh database-backups/card_words_<latest>.sql
```

---

## 📞 Hỗ Trợ

**Gặp vấn đề?**

1. **Xem Quick Start:** [QUICK_START_BACKUP.md](./docker/QUICK_START_BACKUP.md)
2. **Chạy test:** `./test-backup.sh`
3. **Check logs:** `cat backup-log.txt`
4. **Troubleshooting:** Xem section "🔧 TROUBLESHOOTING" trong Quick Start

---

## 🔗 Links Nhanh

| Link                                              | Mô tả              |
| ------------------------------------------------- | ------------------ |
| [📘 Quick Start](./docker/QUICK_START_BACKUP.md)  | Hướng dẫn chi tiết |
| [📗 Sync Guide](./docker/DATABASE_SYNC_GUIDE.md)  | So sánh options    |
| [📙 Setup Complete](./OPTION1_SETUP_COMPLETE.md)  | Tổng kết           |
| [📦 Backup Folder](../database-backups/README.md) | Hướng dẫn folder   |

---

**📅 Last updated:** 2025-11-06  
**✅ Status:** Production Ready  
**👨‍💻 Setup:** Option 1 - Manual Backup/Restore
