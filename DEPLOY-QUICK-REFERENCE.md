# 🚀 Deploy Quick Reference

## Redeploy sau khi sửa code

### Bước 1: Push code (Trên máy local)
```bash
git add .
git commit -m "fix: your changes"
git push origin main
```

### Bước 2: Deploy trên VPS
```bash
# SSH vào VPS
ssh root@103.9.77.220

# Chạy script deploy
cd /opt/card-words-services
bash scripts/deploy-vps.sh
```

**Xong!** ✅

---

## Các lệnh thường dùng

```bash
# Xem trạng thái
docker compose ps

# Xem logs
docker compose logs -f card-words-api

# Restart
docker compose restart

# Stop
docker compose down

# Start
docker compose up -d
```

---

## Nếu script lỗi - Deploy thủ công

```bash
ssh root@103.9.77.220
cd /opt/card-words-services

# Backup .env
cp .env.production .env.production.backup

# Pull code
git pull origin main

# Restore .env
mv .env.production.backup .env.production

# Rebuild và restart
docker compose down
docker compose up -d --build

# Kiểm tra
docker compose ps
docker compose logs -f card-words-api
```

---

## Troubleshooting

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

### Hết disk?
```bash
df -h
docker system prune -a
```

---

📖 **Chi tiết:** Xem `docs/DEPLOY-GUIDE.md`
