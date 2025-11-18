#!/bin/bash

# Test script for Card Words AI Service

BASE_URL="http://localhost:8001"
ADMIN_API_KEY="card-words-admin-key-2024"

echo "=========================================="
echo "Testing Card Words AI Service"
echo "=========================================="
echo ""

# Test 1: Root endpoint
echo "1. Testing root endpoint..."
curl -s "$BASE_URL/" | jq .
echo ""

# Test 2: Health check
echo "2. Testing health check..."
curl -s "$BASE_URL/health" | jq .
echo ""

# Test 3: Metrics
echo "3. Testing metrics..."
curl -s "$BASE_URL/metrics" | jq .
echo ""

# Test 4: Predict (requires JWT token)
echo "4. Testing predict endpoint (will fail without valid JWT)..."
curl -s -X POST "$BASE_URL/api/v1/smart-review/predict" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer invalid-token" \
  -d '{
    "user_id": "test-user-id",
    "limit": 10
  }' | jq .
echo ""

# Test 5: Retrain (requires admin API key)
echo "5. Testing retrain endpoint..."
curl -s -X POST "$BASE_URL/api/v1/smart-review/retrain" \
  -H "Content-Type: application/json" \
  -H "X-API-Key: $ADMIN_API_KEY" \
  -d '{
    "force": false
  }' | jq .
echo ""

echo "=========================================="
echo "Tests completed!"
echo "=========================================="
