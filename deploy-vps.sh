#!/bin/bash
# Script tự động deploy lên VPS

set -e

echo "=== CARD WORDS - VPS DEPLOYMENT SCRIPT ==="

# Bước 1: Tạo file .env
echo "📝 Tạo file .env..."
cat > .env << 'EOF'
# ==============================================
# CARD WORDS - PRODUCTION ENVIRONMENT
# ==============================================

# ============================================
# DATABASE (PostgreSQL)
# ============================================
POSTGRES_USER=cardwords_user
POSTGRES_PASSWORD=CHANGE_THIS_PASSWORD_123
POSTGRES_DB=card_words
POSTGRES_HOST=postgres
POSTGRES_PORT=5432
POSTGRES_EXTERNAL_PORT=5432

# ============================================
# CACHE (Redis)
# ============================================
REDIS_HOST=redis
REDIS_PORT=6379
REDIS_EXTERNAL_PORT=6379
REDIS_DB=0
REDIS_AI_DB=1
REDIS_PASSWORD=
REDIS_TIMEOUT=60000

# ============================================
# JWT AUTHENTICATION
# ============================================
JWT_SECRET=CHANGE_THIS_TO_RANDOM_STRING_AT_LEAST_64_CHARS_LONG_USE_OPENSSL_RAND
JWT_EXPIRATION_TIME=86400000
JWT_REFRESH_TOKEN_EXPIRATION=604800000

# ============================================
# SPRING BOOT API
# ============================================
SERVER_SPRING_PORT=8080

# ============================================
# AI SERVICE (FastAPI)
# ============================================
SERVER_FLASH_PORT=8001
API_HOST=0.0.0.0
LOG_LEVEL=WARNING
ACTIVE_MODEL_TYPE=xgboost
AI_SERVICE_URL=http://card-words-ai:8001

# ============================================
# EMAIL (Gmail SMTP)
# ============================================
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-gmail-app-password
MAIL_STARTTLS_ENABLE=true
MAIL_SSL_ENABLE=false

# ============================================
# GOOGLE OAUTH2
# ============================================
GOOGLE_OAUTH_CLIENT_ID=your-client-id.apps.googleusercontent.com
GOOGLE_OAUTH_CLIENT_SECRET=your-client-secret
GOOGLE_OAUTH_REDIRECT_URI=http://103.9.77.220:8080/api/v1/auth/google/callback

# ============================================
# FIREBASE STORAGE
# ============================================
FIREBASE_STORAGE_BUCKET=your-bucket.firebasestorage.app
FIREBASE_SERVICE_ACCOUNT_PATH=/app/firebase-service-account.json

# ============================================
# GEMINI AI
# ============================================
GEMINI_API_KEY=your-gemini-api-key

# ============================================
# ACTIVATION
# ============================================
ACTIVATION_EXPIRED_TIME=86400000
ACTIVATION_RESEND_INTERVAL=60000

# ============================================
# API KEYS
# ============================================
ADMIN_API_KEY=admin-secret-key-change-this
INTERNAL_API_KEY=internal-secret-key-change-this
EOF

echo "✅ File .env đã được tạo"
echo ""
echo "⚠️  QUAN TRỌNG: Hãy chỉnh sửa file .env và thay đổi các giá trị sau:"
echo "   - POSTGRES_PASSWORD"
echo "   - JWT_SECRET (dùng: openssl rand -base64 64)"
echo "   - MAIL_USERNAME và MAIL_PASSWORD"
echo "   - GOOGLE_OAUTH_CLIENT_ID và GOOGLE_OAUTH_CLIENT_SECRET"
echo "   - GEMINI_API_KEY"
echo "   - FIREBASE_STORAGE_BUCKET"
echo ""
read -p "Nhấn Enter sau khi đã chỉnh sửa file .env..."

# Bước 2: Build và chạy containers
echo ""
echo "🐳 Build và chạy Docker containers..."
docker compose -f docker-compose.prod.yml up -d --build

# Bước 3: Kiểm tra status
echo ""
echo "📊 Kiểm tra trạng thái containers..."
sleep 5
docker ps

echo ""
echo "✅ Deploy hoàn tất!"
echo ""
echo "📝 Các lệnh hữu ích:"
echo "   - Xem logs: docker compose -f docker-compose.prod.yml logs -f"
echo "   - Xem logs 1 service: docker logs card-words-api -f"
echo "   - Restart: docker compose -f docker-compose.prod.yml restart"
echo "   - Stop: docker compose -f docker-compose.prod.yml down"
echo ""
echo "🌐 Truy cập ứng dụng:"
echo "   - API: http://103.9.77.220:8080"
echo "   - AI Service: http://103.9.77.220:8001"
echo "   - Swagger: http://103.9.77.220:8080/swagger-ui.html"
