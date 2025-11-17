#!/bin/bash

# Complete Docker Deployment Script
# Handles environment setup, build, and deployment

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}   🐳 Card Words - Docker Deployment${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Step 1: Setup environment
echo -e "${GREEN}📋 Step 1: Setting up environment...${NC}"
if [ ! -f ".env.docker" ]; then
    echo -e "${YELLOW}⚠️  .env.docker not found, creating from .env...${NC}"
    bash setup-docker-env.sh
else
    echo -e "${GREEN}✅ .env.docker already exists${NC}"
fi
echo ""

# Step 2: Stop existing containers
echo -e "${GREEN}📋 Step 2: Stopping existing containers...${NC}"
if docker-compose ps -q 2>/dev/null | grep -q .; then
    docker-compose down
    echo -e "${GREEN}✅ Containers stopped${NC}"
else
    echo -e "${YELLOW}⚠️  No running containers found${NC}"
fi
echo ""

# Step 3: Build images
echo -e "${GREEN}📋 Step 3: Building Docker images...${NC}"
docker-compose build --no-cache
echo -e "${GREEN}✅ Build completed${NC}"
echo ""

# Step 4: Start services
echo -e "${GREEN}📋 Step 4: Starting services...${NC}"
docker-compose up -d
echo ""

# Step 5: Wait for services to be healthy
echo -e "${GREEN}📋 Step 5: Waiting for services to be ready...${NC}"
echo -e "${YELLOW}⏳ This may take a minute...${NC}"

# Wait for PostgreSQL
echo -n "Waiting for PostgreSQL..."
for i in {1..30}; do
    if docker-compose exec -T postgres pg_isready -U postgres > /dev/null 2>&1; then
        echo -e " ${GREEN}✅${NC}"
        break
    fi
    echo -n "."
    sleep 1
done

# Wait for Redis
echo -n "Waiting for Redis..."
for i in {1..30}; do
    if docker-compose exec -T redis redis-cli ping > /dev/null 2>&1; then
        echo -e " ${GREEN}✅${NC}"
        break
    fi
    echo -n "."
    sleep 1
done

# Wait for Application
echo -n "Waiting for Application..."
for i in {1..60}; do
    if curl -s http://localhost:8080/actuator/health > /dev/null 2>&1; then
        echo -e " ${GREEN}✅${NC}"
        break
    fi
    echo -n "."
    sleep 1
done
echo ""

# Step 6: Show status
echo -e "${GREEN}📋 Step 6: Service Status${NC}"
docker-compose ps
echo ""

# Show logs option
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✨ Deployment completed successfully!${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${YELLOW}📱 Application URLs:${NC}"
echo "  • API: http://localhost:8080"
echo "  • Swagger: http://localhost:8080/swagger-ui.html"
echo "  • Health: http://localhost:8080/actuator/health"
echo ""
echo -e "${YELLOW}🔍 Useful commands:${NC}"
echo "  • View logs: docker-compose logs -f app"
echo "  • Stop all: docker-compose down"
echo "  • Restart: docker-compose restart app"
echo ""

# Ask to view logs
read -p "Do you want to view application logs? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    docker-compose logs -f app
fi
