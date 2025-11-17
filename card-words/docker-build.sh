#!/bin/bash

# Card Words - Docker Build & Push Script
# Usage: ./docker-build.sh [version]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
DOCKER_USERNAME="thuanthichlaptrinh"
IMAGE_NAME="card-words"
VERSION=${1:-"latest"}

echo -e "${GREEN}🐳 Docker Build & Push Script${NC}"
echo "=================================="

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker is not installed!${NC}"
    exit 1
fi

# Check if user is logged in to Docker Hub
if ! docker info | grep -q "Username"; then
    echo -e "${YELLOW}⚠️  Not logged in to Docker Hub${NC}"
    echo "Please run: docker login"
    exit 1
fi

echo -e "${GREEN}📦 Building Docker image...${NC}"
echo "Image: ${DOCKER_USERNAME}/${IMAGE_NAME}:${VERSION}"

# Build the image
docker build -t ${DOCKER_USERNAME}/${IMAGE_NAME}:${VERSION} .

# Also tag as latest if version is not latest
if [ "$VERSION" != "latest" ]; then
    docker tag ${DOCKER_USERNAME}/${IMAGE_NAME}:${VERSION} ${DOCKER_USERNAME}/${IMAGE_NAME}:latest
    echo -e "${GREEN}✅ Tagged as latest${NC}"
fi

echo -e "${GREEN}✅ Build completed successfully!${NC}"
echo ""

# Ask to push
read -p "Do you want to push to Docker Hub? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${GREEN}📤 Pushing to Docker Hub...${NC}"
    
    docker push ${DOCKER_USERNAME}/${IMAGE_NAME}:${VERSION}
    
    if [ "$VERSION" != "latest" ]; then
        docker push ${DOCKER_USERNAME}/${IMAGE_NAME}:latest
    fi
    
    echo -e "${GREEN}✅ Push completed successfully!${NC}"
    echo -e "${GREEN}🎉 Image available at: https://hub.docker.com/r/${DOCKER_USERNAME}/${IMAGE_NAME}${NC}"
else
    echo -e "${YELLOW}⏭️  Skipping push${NC}"
fi

echo ""
echo -e "${GREEN}📋 Image information:${NC}"
docker images | grep "${DOCKER_USERNAME}/${IMAGE_NAME}"
echo ""
echo -e "${GREEN}✨ Done!${NC}"
