#!/bin/bash
# ==============================================
# CARD WORDS - VPS DEPLOYMENT SCRIPT
# Optimized for 2GB RAM VPS (Demo purpose)
# ==============================================

set -e

echo "🚀 Card Words - VPS Deployment Script"
echo "======================================"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Step 1: Update system
echo -e "${YELLOW}[1/7] Updating system...${NC}"
apt update && apt upgrade -y

# Step 2: Install Docker
echo -e "${YELLOW}[2/7] Installing Docker...${NC}"
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com | sh
    systemctl enable docker
    systemctl start docker
    echo -e "${GREEN}✅ Docker installed${NC}"
else
    echo -e "${GREEN}✅ Docker already installed${NC}"
fi

# Step 3: Install Docker Compose
echo -e "${YELLOW}[3/7] Installing Docker Compose...${NC}"
if ! command -v docker-compose &> /dev/null; then
    apt install docker-compose-plugin -y
    echo -e "${GREEN}✅ Docker Compose installed${NC}"
else
    echo -e "${GREEN}✅ Docker Compose already installed${NC}"
fi

# Step 4: Create swap (IMPORTANT for 2GB RAM)
echo -e "${YELLOW}[4/7] Creating 2GB swap file...${NC}"
if [ ! -f /swapfile ]; then
    fallocate -l 2G /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    echo '/swapfile none swap sw 0 0' >> /etc/fstab
    # Optimize swap settings
    sysctl vm.swappiness=10
    echo 'vm.swappiness=10' >> /etc/sysctl.conf
    echo -e "${GREEN}✅ 2GB Swap created${NC}"
else
    echo -e "${GREEN}✅ Swap already exists${NC}"
fi

# Step 5: Configure firewall
echo -e "${YELLOW}[5/7] Configuring firewall...${NC}"
ufw allow 22/tcp    # SSH
ufw allow 80/tcp    # HTTP
ufw allow 443/tcp   # HTTPS
ufw allow 8080/tcp  # Spring Boot API
ufw allow 8001/tcp  # AI Service
ufw --force enable
echo -e "${GREEN}✅ Firewall configured${NC}"

# Step 6: Check .env file
echo -e "${YELLOW}[6/7] Checking configuration...${NC}"
if [ ! -f .env ]; then
    echo -e "${RED}❌ ERROR: .env file not found!${NC}"
    echo "Please create .env file with your configuration."
    echo "Copy from .env.example and update the values."
    exit 1
fi
echo -e "${GREEN}✅ .env file found${NC}"

# Step 7: Deploy
echo -e "${YELLOW}[7/7] Deploying services...${NC}"
docker compose -f docker-compose.prod.yml down 2>/dev/null || true
docker compose -f docker-compose.prod.yml up -d --build

# Wait for services
echo -e "${YELLOW}Waiting for services to start...${NC}"
sleep 30

# Check status
echo ""
echo "======================================"
echo -e "${GREEN}🎉 DEPLOYMENT COMPLETE!${NC}"
echo "======================================"
docker compose -f docker-compose.prod.yml ps

echo ""
echo "📊 Memory Usage:"
free -h

echo ""
echo "🌐 Access URLs:"
echo "   - API:        http://$(curl -s ifconfig.me):8080"
echo "   - AI Service: http://$(curl -s ifconfig.me):8001"
echo "   - Swagger:    http://$(curl -s ifconfig.me):8080/swagger-ui.html"
echo "   - Health:     http://$(curl -s ifconfig.me):8080/actuator/health"

echo ""
echo "📝 Useful commands:"
echo "   - View logs:    docker compose -f docker-compose.prod.yml logs -f"
echo "   - Stop:         docker compose -f docker-compose.prod.yml down"
echo "   - Restart:      docker compose -f docker-compose.prod.yml restart"
