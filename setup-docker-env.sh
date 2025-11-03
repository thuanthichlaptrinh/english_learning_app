#!/bin/bash

# Setup Docker Environment Script
# Converts .env to .env.docker with Docker-specific values

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}🔧 Setting up Docker environment...${NC}"
echo ""

# Check if .env exists
if [ ! -f ".env" ]; then
    echo -e "${RED}❌ Error: .env file not found!${NC}"
    echo "Please create .env file first."
    exit 1
fi

# Backup existing .env.docker if exists
if [ -f ".env.docker" ]; then
    echo -e "${YELLOW}⚠️  .env.docker already exists${NC}"
    read -p "Do you want to overwrite it? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}⏭️  Skipping...${NC}"
        exit 0
    fi
    mv .env.docker .env.docker.backup
    echo -e "${GREEN}✅ Backed up to .env.docker.backup${NC}"
fi

# Copy .env to .env.docker
cp .env .env.docker

echo -e "${GREEN}✅ Copied .env to .env.docker${NC}"

# Replace localhost with Docker service names
echo -e "${YELLOW}🔄 Converting localhost to Docker service names...${NC}"

# For macOS (BSD sed) and Linux (GNU sed) compatibility
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    sed -i '' 's/POSTGRES_HOST=localhost/POSTGRES_HOST=postgres/g' .env.docker
    sed -i '' 's/REDIS_HOST=localhost/REDIS_HOST=redis/g' .env.docker
else
    # Linux
    sed -i 's/POSTGRES_HOST=localhost/POSTGRES_HOST=postgres/g' .env.docker
    sed -i 's/REDIS_HOST=localhost/REDIS_HOST=redis/g' .env.docker
fi

echo -e "${GREEN}✅ Updated POSTGRES_HOST to 'postgres'${NC}"
echo -e "${GREEN}✅ Updated REDIS_HOST to 'redis'${NC}"

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✨ Setup completed successfully!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${YELLOW}📝 Next steps:${NC}"
echo "1. Review .env.docker file"
echo "2. Run: docker-compose up -d"
echo "3. Check logs: docker-compose logs -f app"
echo ""
echo -e "${GREEN}🎉 Happy Dockerizing!${NC}"
