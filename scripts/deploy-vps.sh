#!/bin/bash

# ============================================
# Script Deploy/Redeploy cho VPS
# Chạy script này trên VPS sau khi push code mới
# ============================================

set -e  # Dừng nếu có lỗi

echo "=========================================="
echo "Card Words - Deploy Script"
echo "=========================================="
echo ""

# Đường dẫn project trên VPS
PROJECT_DIR="/opt/card-words-services"

# Kiểm tra thư mục project
if [ ! -d "$PROJECT_DIR" ]; then
    echo "❌ Không tìm thấy thư mục project: $PROJECT_DIR"
    echo "📝 Vui lòng clone project trước:"
    echo "   cd /opt"
    echo "   git clone https://github.com/thuanthichlaptrinh/card-words-services.git"
    exit 1
fi

cd "$PROJECT_DIR"

echo "📂 Thư mục hiện tại: $(pwd)"
echo ""

# Backup file .env.production (quan trọng!)
echo "💾 Đang backup .env.production..."
if [ -f .env.production ]; then
    cp .env.production .env.production.backup
    echo "✅ Đã backup .env.production"
else
    echo "⚠️  Không tìm thấy .env.production"
fi
echo ""

# Pull code mới từ GitHub
echo "📥 Đang pull code mới từ GitHub..."
git fetch origin
git pull origin main
echo "✅ Đã pull code mới"
echo ""

# Restore file .env.production
echo "♻️  Đang restore .env.production..."
if [ -f .env.production.backup ]; then
    mv .env.production.backup .env.production
    echo "✅ Đã restore .env.production"
fi
echo ""

# Rebuild và restart Docker containers
echo "🐳 Đang rebuild Docker images..."
docker compose build --no-cache
echo "✅ Đã build xong"
echo ""

echo "🔄 Đang restart containers..."
docker compose down
docker compose up -d
echo "✅ Containers đã được restart"
echo ""

# Đợi containers khởi động
echo "⏳ Đang đợi containers khởi động (30 giây)..."
sleep 30

# Kiểm tra trạng thái containers
echo ""
echo "🔍 Kiểm tra trạng thái containers:"
docker compose ps
echo ""

# Kiểm tra health của API
echo "🏥 Kiểm tra health của API..."
if curl -s http://localhost:8080/actuator/health > /dev/null; then
    echo "✅ API đang hoạt động bình thường"
    curl -s http://localhost:8080/actuator/health | jq '.' || curl -s http://localhost:8080/actuator/health
else
    echo "⚠️  API chưa sẵn sàng, kiểm tra logs:"
    echo "   docker compose logs card-words-api"
fi
echo ""

# Xem logs gần nhất
echo "📋 Logs gần nhất của API:"
docker compose logs --tail=20 card-words-api
echo ""

echo "=========================================="
echo "✅ DEPLOY HOÀN TẤT!"
echo "=========================================="
echo ""
echo "📝 Các lệnh hữu ích:"
echo "   - Xem logs: docker compose logs -f card-words-api"
echo "   - Restart: docker compose restart card-words-api"
echo "   - Stop: docker compose down"
echo "   - Xem status: docker compose ps"
echo ""
