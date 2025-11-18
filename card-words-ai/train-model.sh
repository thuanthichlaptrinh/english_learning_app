#!/bin/bash

# Train XGBoost model for Card Words AI

echo "🧠 Training XGBoost model..."

# Check if service is running
if ! curl -s http://localhost:8001/health > /dev/null; then
    echo "❌ Card Words AI service is not running."
    echo "Please start it with: docker-compose up -d card-words-ai"
    exit 1
fi

# Train model
echo "📊 Sending retrain request..."
response=$(curl -s -X POST http://localhost:8001/api/v1/smart-review/retrain \
  -H "X-API-Key: card-words-admin-key-2024" \
  -H "Content-Type: application/json" \
  -d '{"force": true}')

# Check if successful
if echo "$response" | grep -q '"success":true'; then
    echo "✅ Model trained successfully!"
    echo "$response" | python3 -m json.tool 2>/dev/null || echo "$response"
else
    echo "❌ Training failed!"
    echo "$response"
    exit 1
fi
