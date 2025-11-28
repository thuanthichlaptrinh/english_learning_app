# 🔐 Hướng dẫn Fix Bảo mật & Email

## Vấn đề đã phát hiện

1. **Email không gửi được**: Railway block port 465 (SSL)
2. **Secrets bị lộ**: File `.env.production` chứa credentials đã push lên GitHub

---

## 🚨 QUAN TRỌNG: Xóa Secrets khỏi Git History

### Bước 1: Revoke tất cả credentials đã bị lộ

**NGAY LẬP TỨC** thay đổi/revoke các credentials sau:

1. **Gmail App Password**: Tạo App Password mới tại https://myaccount.google.com/apppasswords
2. **Google OAuth**: Tạo credentials mới tại https://console.cloud.google.com/
3. **Gemini API Key**: Tạo key mới tại https://aistudio.google.com/apikey
4. **JWT Secret**: Generate mới: `openssl rand -base64 64`
5. **Database Password**: Đổi password PostgreSQL
6. **Redis Password**: Đổi password Redis (nếu có)
7. **Admin/Internal API Keys**: Tạo keys mới

### Bước 2: Xóa file khỏi Git history (BFG Repo-Cleaner)

```bash
# Cài đặt BFG (nếu chưa có)
# Windows: choco install bfg-repo-cleaner
# Mac: brew install bfg

# Clone repo dạng mirror
git clone --mirror https://github.com/YOUR_USERNAME/YOUR_REPO.git

# Xóa file .env.production khỏi history
bfg --delete-files .env.production YOUR_REPO.git

# Hoặc xóa theo pattern
bfg --delete-files ".env*" YOUR_REPO.git

# Clean up
cd YOUR_REPO.git
git reflog expire --expire=now --all && git gc --prune=now --aggressive

# Force push
git push --force
```

### Bước 3: Cách khác - git filter-branch (nếu không có BFG)

```bash
# Xóa file khỏi tất cả commits
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch .env.production" \
  --prune-empty --tag-name-filter cat -- --all

# Force push tất cả branches
git push origin --force --all
git push origin --force --tags
```

---

## 📧 Fix Lỗi Email trên Railway

### Nguyên nhân
Railway block outbound connections trên port 465 (SSL). Cần dùng port 587 (TLS/STARTTLS).

### Giải pháp

Cấu hình trong Railway Variables:

```
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-16-char-app-password
MAIL_STARTTLS_ENABLE=true
MAIL_SSL_ENABLE=false
```

### Tạo Gmail App Password

1. Vào https://myaccount.google.com/security
2. Bật **2-Step Verification** (nếu chưa bật)
3. Vào https://myaccount.google.com/apppasswords
4. Chọn "Mail" và "Other (Custom name)"
5. Đặt tên "Card Words Railway"
6. Copy 16-character password (không có spaces)

---

## 🚀 Cấu hình Railway Variables

Vào Railway Dashboard → Project → Variables, thêm các biến sau:

### Database (Railway PostgreSQL)
```
POSTGRES_HOST=<railway-postgres-host>
POSTGRES_PORT=5432
POSTGRES_DB=railway
POSTGRES_USER=postgres
POSTGRES_PASSWORD=<railway-generated-password>
```

### Redis (Railway Redis)
```
REDIS_HOST=<railway-redis-host>
REDIS_PORT=6379
REDIS_PASSWORD=<railway-generated-password>
REDIS_DB=0
REDIS_TIMEOUT=60000
```

### Email (Gmail SMTP)
```
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-new-app-password
MAIL_STARTTLS_ENABLE=true
MAIL_SSL_ENABLE=false
```

### JWT & Security
```
JWT_SECRET=<new-generated-secret>
JWT_EXPIRATION_TIME=86400000
JWT_REFRESH_TOKEN_EXPIRATION=604800000
ADMIN_API_KEY=<new-admin-key>
INTERNAL_API_KEY=<new-internal-key>
```

### Google OAuth
```
GOOGLE_OAUTH_CLIENT_ID=<new-client-id>
GOOGLE_OAUTH_CLIENT_SECRET=<new-client-secret>
GOOGLE_OAUTH_REDIRECT_URI=https://your-railway-domain.up.railway.app/api/v1/auth/google/callback
```

### Firebase
```
FIREBASE_STORAGE_BUCKET=your-bucket.firebasestorage.app
FIREBASE_SERVICE_ACCOUNT_PATH=/app/firebase-service-account.json
```

### Gemini AI
```
GEMINI_API_KEY=<new-gemini-api-key>
```

### Other
```
SERVER_PORT=8080
ACTIVATION_EXPIRED_TIME=86400000
ACTIVATION_RESEND_INTERVAL=60000
```

---

## ✅ Checklist sau khi fix

- [ ] Revoke tất cả credentials cũ
- [ ] Tạo credentials mới
- [ ] Xóa `.env.production` khỏi Git history
- [ ] Cập nhật Railway Variables với credentials mới
- [ ] Test gửi email (đăng ký tài khoản mới)
- [ ] Test Google OAuth login
- [ ] Test các API endpoints

---

## 📝 Lưu ý

1. **KHÔNG BAO GIỜ** commit file `.env` hoặc `.env.production` chứa credentials thật
2. Sử dụng `.env.example` làm template (đã có sẵn)
3. Trên Railway, sử dụng Variables thay vì file `.env`
4. Định kỳ rotate credentials (3-6 tháng/lần)
