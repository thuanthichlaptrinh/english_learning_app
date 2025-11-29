# Hướng dẫn cài đặt HTTPS cho Card Words API

## Tổng quan

Tài liệu này hướng dẫn cài đặt HTTPS cho backend API đang chạy trên VPS Vinahost sử dụng:
- **Nginx** làm reverse proxy
- **Let's Encrypt** (Certbot) cho SSL certificate miễn phí
- **Docker Compose** cho các services

## Yêu cầu

- ✅ VPS đang chạy (IP: 103.9.77.220)
- ✅ Docker containers đang hoạt động (Spring Boot API port 8080)
- ⚠️ **Domain đã trỏ về VPS** (bắt buộc cho SSL)
- ✅ Quyền root/sudo trên VPS

## Bước 1: Chuẩn bị Domain

### Option A: Đã có domain
1. Đăng nhập vào nhà cung cấp domain (GoDaddy, Namecheap, etc.)
2. Thêm DNS A record:
   ```
   Type: A
   Name: @ (hoặc api)
   Value: 103.9.77.220
   TTL: 3600
   ```
3. Thêm A record cho www (optional):
   ```
   Type: A
   Name: www
   Value: 103.9.77.220
   TTL: 3600
   ```
4. Đợi 5-30 phút để DNS propagate

### Option B: Chưa có domain
Mua domain giá rẻ:
- **Tên miền .xyz**: ~30k-50k/năm (Namecheap, Porkbun)
- **Tên miền .com**: ~200k-300k/năm
- **Tên miền .online**: ~30k/năm

Sau khi mua, làm theo Option A.

### Kiểm tra DNS
```bash
# Trên máy local
nslookup yourdomain.com
# hoặc
ping yourdomain.com

# Phải trả về IP: 103.9.77.220
```

## Bước 2: Chạy script tự động (Khuyến nghị)

### 2.1. Upload script lên VPS

**Cách 1: Dùng Git**
```bash
# Trên VPS
cd /opt
git clone https://github.com/yourusername/card-words-services.git
cd card-words-services/scripts
chmod +x setup-https.sh
```

**Cách 2: Copy trực tiếp**
```bash
# Trên máy local
scp scripts/setup-https.sh root@103.9.77.220:/root/

# Trên VPS
chmod +x /root/setup-https.sh
```

### 2.2. Chạy script
```bash
# SSH vào VPS
ssh root@103.9.77.220

# Chạy script
sudo bash setup-https.sh
```

Script sẽ tự động:
- ✅ Cài đặt Nginx
- ✅ Cài đặt Certbot
- ✅ Tạo cấu hình Nginx
- ✅ Cài đặt SSL certificate
- ✅ Cấu hình auto-renewal

### 2.3. Nhập thông tin khi được hỏi
```
📝 Nhập domain của bạn: api.cardwords.com
```

## Bước 3: Cài đặt thủ công (Nếu script lỗi)

### 3.1. Cài đặt Nginx và Certbot
```bash
# SSH vào VPS
ssh root@103.9.77.220

# Update system
sudo apt update

# Cài Nginx
sudo apt install nginx -y

# Cài Certbot
sudo apt install certbot python3-certbot-nginx -y
```

### 3.2. Tạo cấu hình Nginx
```bash
# Tạo file cấu hình
sudo nano /etc/nginx/sites-available/card-words
```

Paste nội dung sau (thay `yourdomain.com`):
```nginx
server {
    listen 80;
    server_name yourdomain.com www.yourdomain.com;

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Host $host;
        proxy_set_header X-Forwarded-Port $server_port;
        
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }

    location /ws {
        proxy_pass http://localhost:8080;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        proxy_read_timeout 86400;
    }

    location /actuator/health {
        proxy_pass http://localhost:8080/actuator/health;
        access_log off;
    }
}
```

### 3.3. Kích hoạt cấu hình
```bash
# Tạo symbolic link
sudo ln -s /etc/nginx/sites-available/card-words /etc/nginx/sites-enabled/

# Xóa default config
sudo rm /etc/nginx/sites-enabled/default

# Test cấu hình
sudo nginx -t

# Restart Nginx
sudo systemctl restart nginx
sudo systemctl enable nginx
```

### 3.4. Cài SSL certificate
```bash
# Chạy certbot (thay yourdomain.com)
sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com

# Làm theo hướng dẫn:
# 1. Nhập email
# 2. Đồng ý Terms of Service (Y)
# 3. Chọn redirect HTTP -> HTTPS (2)
```

### 3.5. Test auto-renewal
```bash
sudo certbot renew --dry-run
```

## Bước 4: Cập nhật Flutter App

### 4.1. Tìm và thay đổi base URL

Tìm file cấu hình API trong Flutter project (thường là `lib/config/api_config.dart` hoặc tương tự):

**Trước:**
```dart
static const String baseUrl = 'http://103.9.77.220:8080';
```

**Sau:**
```dart
static const String baseUrl = 'https://yourdomain.com';
```

### 4.2. Rebuild và deploy
```bash
# Build Flutter web
flutter build web --release

# Deploy lên Firebase Hosting
firebase deploy --only hosting
```

## Bước 5: Cập nhật Google OAuth (Nếu dùng)

1. Truy cập [Google Cloud Console](https://console.cloud.google.com/)
2. Chọn project của bạn
3. Vào **APIs & Services** → **Credentials**
4. Chỉnh sửa OAuth 2.0 Client ID
5. Thêm **Authorized redirect URIs**:
   ```
   https://yourdomain.com/api/v1/auth/google/callback
   ```
6. Cập nhật `.env.production` trên VPS:
   ```bash
   GOOGLE_OAUTH_REDIRECT_URI=https://yourdomain.com/api/v1/auth/google/callback
   ```
7. Restart Docker containers:
   ```bash
   cd /opt/card-words-services
   docker compose down
   docker compose up -d
   ```

## Kiểm tra

### Test HTTPS
```bash
# Test từ máy local
curl https://yourdomain.com/actuator/health

# Kết quả mong đợi:
{"status":"UP"}
```

### Test từ trình duyệt
1. Mở: `https://yourdomain.com/actuator/health`
2. Kiểm tra icon khóa (🔒) trên thanh địa chỉ
3. Không có cảnh báo "Not Secure"

### Test Flutter app
1. Mở Flutter web app: `https://card-b1260.web.app`
2. Thử đăng nhập
3. Kiểm tra Console (F12) - không còn lỗi Mixed Content

## Troubleshooting

### Lỗi: DNS không resolve
```bash
# Kiểm tra DNS
nslookup yourdomain.com

# Nếu không trả về IP đúng, đợi thêm hoặc kiểm tra lại DNS settings
```

### Lỗi: Certbot không tạo được certificate
```bash
# Kiểm tra domain có trỏ đúng không
curl http://yourdomain.com

# Nếu không kết nối được, kiểm tra:
# 1. DNS đã propagate chưa
# 2. Firewall có mở port 80, 443 không
sudo ufw allow 80
sudo ufw allow 443
```

### Lỗi: Nginx không start
```bash
# Xem log lỗi
sudo tail -f /var/log/nginx/error.log

# Kiểm tra cấu hình
sudo nginx -t

# Kiểm tra port 80 có bị chiếm không
sudo netstat -tulpn | grep :80
```

### Lỗi: Spring Boot không kết nối được
```bash
# Kiểm tra Docker containers
docker compose ps

# Kiểm tra Spring Boot có chạy không
curl http://localhost:8080/actuator/health

# Nếu không chạy, restart
cd /opt/card-words-services
docker compose restart card-words-api
```

### Lỗi: Mixed Content vẫn còn
- Đảm bảo đã rebuild Flutter app với base URL mới
- Clear cache trình duyệt (Ctrl + Shift + Delete)
- Kiểm tra lại base URL trong code

## Bảo trì

### Gia hạn SSL certificate
Certificate tự động gia hạn mỗi 60 ngày. Kiểm tra:
```bash
# Test renewal
sudo certbot renew --dry-run

# Xem thời hạn certificate
sudo certbot certificates
```

### Xem log Nginx
```bash
# Access log
sudo tail -f /var/log/nginx/access.log

# Error log
sudo tail -f /var/log/nginx/error.log
```

### Restart services
```bash
# Restart Nginx
sudo systemctl restart nginx

# Restart Docker containers
cd /opt/card-words-services
docker compose restart
```

## Bảo mật bổ sung (Optional)

### Tăng cường SSL security
```bash
# Tạo strong DH parameters
sudo openssl dhparam -out /etc/nginx/dhparam.pem 4096

# Thêm vào Nginx config
ssl_dhparam /etc/nginx/dhparam.pem;
ssl_protocols TLSv1.2 TLSv1.3;
ssl_ciphers HIGH:!aNULL:!MD5;
```

### Cấu hình firewall
```bash
# Chỉ mở các port cần thiết
sudo ufw allow 22    # SSH
sudo ufw allow 80    # HTTP
sudo ufw allow 443   # HTTPS
sudo ufw enable
```

## Tài liệu tham khảo

- [Let's Encrypt Documentation](https://letsencrypt.org/docs/)
- [Nginx Reverse Proxy Guide](https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/)
- [Certbot Documentation](https://certbot.eff.org/instructions)

## Hỗ trợ

Nếu gặp vấn đề, kiểm tra:
1. Log Nginx: `/var/log/nginx/error.log`
2. Log Docker: `docker compose logs card-words-api`
3. DNS propagation: https://dnschecker.org/
