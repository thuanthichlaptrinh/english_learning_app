# 📦 Hướng dẫn Deploy Card Words

## 🚀 Cách deploy nhanh nhất

### Trên Windows (PowerShell):
```powershell
# 1. Push code
git add .
git commit -m "fix: your changes"
git push origin main

# 2. Deploy
.\scripts\deploy-from-local.ps1
```

### Trên Linux/Mac:
```bash
# 1. Push code
git add .
git commit -m "fix: your changes"
git push origin main

# 2. Deploy
bash scripts/deploy-from-local.sh
```

### Hoặc SSH thủ công:
```bash
# 1. Push code (trên máy local)
git push origin main

# 2. SSH vào VPS
ssh root@103.9.77.220

# 3. Deploy
cd /opt/card-words-services
bash scripts/deploy-vps.sh
```

---

## 📚 Tài liệu chi tiết

- **Quick Reference:** `DEPLOY-QUICK-REFERENCE.md` - Các lệnh thường dùng
- **Full Guide:** `docs/DEPLOY-GUIDE.md` - Hướng dẫn đầy đủ
- **HTTPS Setup:** `docs/HTTPS-SETUP-GUIDE.md` - Cài đặt SSL

---

## 🔧 Scripts có sẵn

| Script | Mô tả | Chạy ở đâu |
|--------|-------|------------|
| `deploy-vps.sh` | Deploy đầy đủ (rebuild images) | VPS |
| `quick-deploy.sh` | Deploy nhanh (không rebuild) | VPS |
| `deploy-from-local.sh` | Deploy từ máy Linux/Mac | Local |
| `deploy-from-local.ps1` | Deploy từ máy Windows | Local |
| `setup-https.sh` | Cài đặt HTTPS/SSL | VPS |
| `generate-new-secrets.sh` | Tạo secrets mới | Anywhere |

---

## ⚡ Các lệnh thường dùng

```bash
# Xem trạng thái containers
docker compose ps

# Xem logs
docker compose logs -f card-words-api

# Restart
docker compose restart

# Rebuild và restart
docker compose up -d --build

# Stop tất cả
docker compose down

# Xem resource usage
docker stats
```

---

## 🆘 Troubleshooting

### API không chạy?
```bash
docker compose logs card-words-api
docker compose restart card-words-api
```

### Database lỗi?
```bash
docker compose logs postgres
docker compose restart postgres
```

### Cần rebuild từ đầu?
```bash
docker compose down
docker compose up -d --build --force-recreate
```

---

## 📞 Thông tin VPS

- **IP:** 103.9.77.220
- **User:** root
- **Project Path:** /opt/card-words-services
- **API Port:** 8080
- **AI Port:** 8001
- **Database Port:** 5432
- **Redis Port:** 6379

---

## ✅ Checklist sau mỗi lần deploy

- [ ] Code đã push lên GitHub
- [ ] Deploy script chạy thành công
- [ ] Containers đang chạy: `docker compose ps`
- [ ] API health OK: `curl http://localhost:8080/actuator/health`
- [ ] Logs không có lỗi: `docker compose logs --tail=50`
- [ ] Test API từ Flutter app

---

## 🔐 Bảo mật

**QUAN TRỌNG:** Không bao giờ commit các file sau:
- `.env.production`
- `firebase-service-account.json`
- Bất kỳ file chứa passwords, API keys, secrets

Các file này đã được thêm vào `.gitignore`.

---

## 📖 Đọc thêm

- [Deploy Guide](docs/DEPLOY-GUIDE.md) - Hướng dẫn chi tiết
- [HTTPS Setup](docs/HTTPS-SETUP-GUIDE.md) - Cài đặt SSL
- [Quick Reference](DEPLOY-QUICK-REFERENCE.md) - Tham khảo nhanh
