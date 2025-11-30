# 🚀 Hướng Dẫn Deploy Nhanh

## Bạn vừa sửa code và muốn deploy lên VPS?

### Bước 1: Push code lên GitHub
```bash
git add .
git commit -m "fix: mô tả thay đổi của bạn"
git push origin main
```

### Bước 2: Deploy lên VPS

#### Trên Windows (PowerShell):
```powershell
.\scripts\deploy-from-local.ps1
```

#### Trên Linux/Mac:
```bash
bash scripts/deploy-from-local.sh
```

#### Hoặc SSH thủ công:
```bash
ssh root@103.9.77.220
cd /opt/card-words-services
bash scripts/deploy-vps.sh
```

**Xong!** ✅

---

## Các lệnh hữu ích trên VPS

```bash
# Xem trạng thái containers
docker compose ps

# Xem logs
docker compose logs -f card-words-api

# Restart service
docker compose restart card-words-api

# Rebuild và restart
docker compose up -d --build

# Stop tất cả
docker compose down
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

### Cần rebuild hoàn toàn?
```bash
docker compose down
docker compose up -d --build --force-recreate
```

---

## Thông tin VPS

- **IP**: 103.9.77.220
- **User**: root
- **Project Path**: /opt/card-words-services
- **API Port**: 8080
- **AI Port**: 8001

---

## Tài liệu chi tiết

- `DEPLOY-QUICK-REFERENCE.md` - Tham khảo nhanh
- `docs/DEPLOY-GUIDE.md` - Hướng dẫn đầy đủ
- `docs/HTTPS-SETUP-GUIDE.md` - Cài đặt SSL
- `README.md` - Tài liệu tổng quan

---

## ⚠️ Lưu ý quan trọng

1. **Luôn backup .env.production** trước khi deploy
2. **Kiểm tra logs** sau mỗi lần deploy
3. **Test API** sau khi deploy xong
4. **Không commit .env.production** lên Git

---

**Chúc bạn deploy thành công! 🎉**
