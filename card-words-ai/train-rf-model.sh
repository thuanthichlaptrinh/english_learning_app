#!/bin/bash

# Train Random Forest model

API_KEY="${ADMIN_API_KEY:-card-words-admin-key-2024}"
API_URL="${API_URL:-http://localhost:8001}"

echo "🌲 Training Random Forest Model..."
echo "API URL: $API_URL"
echo ""

curl -X POST "$API_URL/api/v1/smart-review/retrain" \
  -H "X-API-Key: $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "force": true,
    "model_type": "random_forest"
  }' | jq '.'

echo ""
echo "✅ Random Forest training completed!"
