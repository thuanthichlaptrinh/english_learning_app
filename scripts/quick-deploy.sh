#!/bin/bash

# ============================================
# Quick Deploy - Không rebuild image
# Dùng khi chỉ thay đổi code nhỏ
# ============================================

set -e

echo "=========================================="
echo "Card Words - Quick Deploy"
echo "=========================================="
echo ""

PROJECT_DIR="/opt/card-words-services"
cd "$PROJECT_DIR"

# Backup .env
if [ -f .env.production ]; then
    cp .env.production .env.production.backup
fi

# Pull code
echo "📥 Pulling code..."
git pull origin main

# Restore .env
if [ -f .env.production.backup ]; then
    mv .env.production.backup .env.production
fi

# Restart containers (không rebuild)
echo "🔄 Restarting containers..."
docker compose restart

echo ""
echo "✅ Quick deploy hoàn tất!"
docker compose ps
