#!/bin/bash

# Setup script for Card Words AI Service

echo "🚀 Setting up Card Words AI Service..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker and try again."
    exit 1
fi

# Check if root .env file exists
if [ ! -f ../../.env ]; then
    echo "❌ Root .env file not found at ../../.env"
    echo "Please ensure you have the .env file in the project root directory."
    exit 1
fi

echo "✅ Found root .env file at ../../.env"

# Create models directory
echo "📁 Creating models directory..."
mkdir -p models
mkdir -p models/backups

echo "✅ Setup completed!"
echo ""
echo "📌 IMPORTANT: This service uses the SHARED .env file from the root directory"
echo "   Location: ../../.env"
echo "   See ENV_CONFIG.md for details"
echo ""
echo "Next steps:"
echo "1. Check root .env file: ../../.env"
echo "2. Run: cd ../.. && docker-compose up -d card-words-ai"
echo "3. Train initial model: ./train-model.sh"
