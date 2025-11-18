# Test script for Card Words AI Service (PowerShell)

$BASE_URL = "http://localhost:8001"
$ADMIN_API_KEY = "card-words-admin-key-2024"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Testing Card Words AI Service" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Test 1: Root endpoint
Write-Host "1. Testing root endpoint..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$BASE_URL/" -Method Get
    $response | ConvertTo-Json -Depth 10
} catch {
    Write-Host "Error: $_" -ForegroundColor Red
}
Write-Host ""

# Test 2: Health check
Write-Host "2. Testing health check..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$BASE_URL/health" -Method Get
    $response | ConvertTo-Json -Depth 10
} catch {
    Write-Host "Error: $_" -ForegroundColor Red
}
Write-Host ""

# Test 3: Metrics
Write-Host "3. Testing metrics..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$BASE_URL/metrics" -Method Get
    $response | ConvertTo-Json -Depth 10
} catch {
    Write-Host "Error: $_" -ForegroundColor Red
}
Write-Host ""

# Test 4: Predict (requires JWT token)
Write-Host "4. Testing predict endpoint (will fail without valid JWT)..." -ForegroundColor Yellow
try {
    $headers = @{
        "Content-Type" = "application/json"
        "Authorization" = "Bearer invalid-token"
    }
    $body = @{
        user_id = "test-user-id"
        limit = 10
    } | ConvertTo-Json
    
    $response = Invoke-RestMethod -Uri "$BASE_URL/api/v1/smart-review/predict" -Method Post -Headers $headers -Body $body
    $response | ConvertTo-Json -Depth 10
} catch {
    Write-Host "Expected error (invalid token): $_" -ForegroundColor Yellow
}
Write-Host ""

# Test 5: Retrain (requires admin API key)
Write-Host "5. Testing retrain endpoint..." -ForegroundColor Yellow
try {
    $headers = @{
        "Content-Type" = "application/json"
        "X-API-Key" = $ADMIN_API_KEY
    }
    $body = @{
        force = $false
    } | ConvertTo-Json
    
    $response = Invoke-RestMethod -Uri "$BASE_URL/api/v1/smart-review/retrain" -Method Post -Headers $headers -Body $body
    $response | ConvertTo-Json -Depth 10
} catch {
    Write-Host "Error: $_" -ForegroundColor Red
}
Write-Host ""

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Tests completed!" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
