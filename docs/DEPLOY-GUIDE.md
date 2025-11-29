# Hướng dẫn Deploy lên VPS

## Tổng quan

Tài liệu này hướng dẫn cách deploy và redeploy ứng dụng Card Words lên VPS Vinahost.

## Lần đầu tiên Setup VPS

### 1. SSH vào VPS
```bash
ssh root@103.9.77.220
```

### 2. Cài đặt Docker và Docker Compose
```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Cài Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Cài Docker Compose
sudo apt install docker-compose -y

# Kiểm tra
docker --version
docker-compose --version
```

### 3. Clone project
```bash
# Tạo thư mục
sudo mkdir -p /opt
cd /opt

# Clone repository
git clone https://github.com/yourusername/card-words-services.git
cd card-words-services
```

### 4. Tạo file .env.production
```bash
# Copy từ example
cp .env.production.example .env.production

# Chỉnh sửa với thông tin thật
nano .env.production
```

**Lưu ý:** Điền đầy đủ các thông tin:
- Database passwords
- JWT secrets
- API keys
- Firebase credentials
- Email credentials

### 5. Deploy lần đầu
```bash
# Build và start containers
docker compose -f docker-compose.prod.yml up -d --build

# Hoặc nếu dùng docker-compose.yml
docker compose up -d --build

# Kiểm tra
docker compose ps
```

### 6. Kiểm tra logs
```bash
# Xem tất cả logs
docker compose logs

# Xem logs của API
docker compose logs -f card-words-api

# Xem logs của AI service
docker compose logs -f card-words-ai
```

## Redeploy sau khi sửa code

### Cách 1: Deploy tự động (Khuyến nghị)

**Trên máy local:**
```bash
# 1. Sửa code
# 2. Commit và push
git add .
git commit -m "fix: your changes"
git push origin main
```

**Trên VPS:**
```bash
# SSH vào VPS
ssh root@103.9.77.220

# Chạy script deploy
cd /opt/card-words-services
bash scripts/deploy-vps.sh
```

Script sẽ tự động:
- ✅ Backup .env.production
- ✅ Pull code mới
- ✅ Rebuild Docker images
- ✅ Restart containers
- ✅ Kiểm tra health

### Cách 2: Quick Deploy (Không rebuild image)

Dùng khi chỉ thay đổi code nhỏ, không thay đổi dependencies:

```bash
ssh root@103.9.77.220
cd /opt/card-words-services
bash scripts/quick-deploy.sh
```

### Cách 3: Deploy thủ công

```bash
# SSH vào VPS
ssh root@103.9.77.220
cd /opt/card-words-services

# Backup .env
cp .env.production .env.production.backup

# Pull code mới
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

## Các lệnh thường dùng

### Xem trạng thái containers
```bash
docker compose ps
```

### Xem logs
```bash
# Tất cả services
docker compose logs

# Chỉ API
docker compose logs -f card-words-api

# Chỉ AI service
docker compose logs -f card-words-ai

# 100 dòng cuối
docker compose logs --tail=100 card-words-api
```

### Restart services
```bash
# Restart tất cả
docker compose restart

# Restart chỉ API
docker compose restart card-words-api

# Restart chỉ AI
docker compose restart card-words-ai
```

### Stop/Start containers
```bash
# Stop tất cả
docker compose down

# Start tất cả
docker compose up -d

# Stop một service
docker compose stop card-words-api

# Start một service
docker compose start card-words-api
```

### Rebuild images
```bash
# Rebuild tất cả
docker compose build --no-cache

# Rebuild chỉ API
docker compose build --no-cache card-words-api

# Rebuild và restart
docker compose up -d --build
```

### Xem resource usage
```bash
# CPU, Memory usage
docker stats

# Disk usage
docker system df
```

### Dọn dẹp
```bash
# Xóa containers cũ
docker compose down --remove-orphans

# Xóa images không dùng
docker image prune -a

# Xóa volumes không dùng (CẢNH BÁO: Mất data!)
docker volume prune

# Xóa tất cả (CẢNH BÁO!)
docker system prune -a --volumes
```

## Troubleshooting

### Container không start
```bash
# Xem logs chi tiết
docker compose logs card-words-api

# Xem logs từ đầu
docker compose logs --tail=all card-words-api

# Kiểm tra port có bị chiếm không
sudo netstat -tulpn | grep 8080
```

### API không response
```bash
# Kiểm tra container có chạy không
docker compose ps

# Kiểm tra health
curl http://localhost:8080/actuator/health

# Vào trong container để debug
docker compose exec card-words-api bash

# Xem logs real-time
docker compose logs -f card-words-api
```

### Database connection error
```bash
# Kiểm tra PostgreSQL container
docker compose ps postgres

# Xem logs PostgreSQL
docker compose logs postgres

# Restart PostgreSQL
docker compose restart postgres

# Kiểm tra kết nối
docker compose exec postgres psql -U postgres -d card_words -c "SELECT 1;"
```

### Out of memory
```bash
# Xem memory usage
docker stats

# Restart containers
docker compose restart

# Tăng memory limit trong docker-compose.yml
# deploy:
#   resources:
#     limits:
#       memory: 2G
```

### Disk full
```bash
# Kiểm tra disk usage
df -h

# Xóa logs cũ
sudo journalctl --vacuum-time=7d

# Xóa Docker images cũ
docker image prune -a

# Xóa build cache
docker builder prune -a
```

## Backup và Restore

### Backup Database
```bash
# Backup PostgreSQL
docker compose exec postgres pg_dump -U postgres card_words > backup_$(date +%Y%m%d).sql

# Hoặc dùng script có sẵn
bash scripts/backup-database.sh
```

### Restore Database
```bash
# Restore từ file backup
cat backup_20241129.sql | docker compose exec -T postgres psql -U postgres card_words
```

### Backup .env và configs
```bash
# Backup toàn bộ configs
tar -czf config-backup-$(date +%Y%m%d).tar.gz .env.production docker-compose.prod.yml

# Download về máy local
scp root@103.9.77.220:/opt/card-words-services/config-backup-*.tar.gz ./
```

## Monitoring

### Kiểm tra health định kỳ
```bash
# Tạo cron job kiểm tra health
crontab -e

# Thêm dòng này (check mỗi 5 phút)
*/5 * * * * curl -s http://localhost:8080/actuator/health || echo "API DOWN" | mail -s "Alert: API Down" your@email.com
```

### Xem logs real-time
```bash
# Terminal 1: API logs
docker compose logs -f card-words-api

# Terminal 2: AI logs
docker compose logs -f card-words-ai

# Terminal 3: Database logs
docker compose logs -f postgres
```

## CI/CD (Tùy chọn)

### Setup GitHub Actions để auto-deploy

Tạo file `.github/workflows/deploy.yml`:

```yaml
name: Deploy to VPS

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to VPS
        uses: appleboy/ssh-action@master
        with:
          host: ${{ secrets.VPS_HOST }}
          username: ${{ secrets.VPS_USER }}
          key: ${{ secrets.VPS_SSH_KEY }}
          script: |
            cd /opt/card-words-services
            bash scripts/deploy-vps.sh
```

Thêm secrets trong GitHub:
- `VPS_HOST`: 103.9.77.220
- `VPS_USER`: root
- `VPS_SSH_KEY`: Private SSH key

## Best Practices

1. **Luôn backup .env.production** trước khi pull code
2. **Kiểm tra logs** sau mỗi lần deploy
3. **Test health endpoint** sau khi deploy
4. **Backup database** định kỳ
5. **Monitor resource usage** (CPU, Memory, Disk)
6. **Không commit .env.production** lên Git
7. **Dùng script deploy** thay vì làm thủ công
8. **Giữ logs** để debug khi có lỗi

## Liên hệ

Nếu gặp vấn đề, kiểm tra:
1. Logs: `docker compose logs -f`
2. Container status: `docker compose ps`
3. Resource usage: `docker stats`
4. Disk space: `df -h`
