#!/bin/bash

# ============================================
# Deploy từ máy local (không cần SSH thủ công)
# Chạy script này sau khi push code
# ============================================

set -e

VPS_HOST="103.9.77.220"
VPS_USER="root"
PROJECT_DIR="/opt/card-words-services"

echo "=========================================="
echo "Deploy to VPS from Local"
echo "=========================================="
echo ""

# Kiểm tra đã push code chưa
echo "⚠️  Đảm bảo bạn đã push code lên GitHub:"
echo "   git push origin main"
echo ""
read -p "Đã push code? (y/n): " confirm

if [ "$confirm" != "y" ]; then
    echo "Vui lòng push code trước khi deploy!"
    exit 0
fi

echo ""
echo "🚀 Đang deploy lên VPS..."
echo ""

# SSH và chạy deploy script
ssh ${VPS_USER}@${VPS_HOST} "cd ${PROJECT_DIR} && bash scripts/deploy-vps.sh"

echo ""
echo "=========================================="
echo "✅ Deploy hoàn tất!"
echo "=========================================="
echo ""
echo "🌐 Kiểm tra API:"
echo "   curl http://103.9.77.220:8080/actuator/health"
echo ""
