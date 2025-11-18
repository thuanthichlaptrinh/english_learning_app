# Train XGBoost model for Card Words AI (PowerShell)

Write-Host "🧠 Training XGBoost model..." -ForegroundColor Cyan

# Check if service is running
try {
    $health = Invoke-RestMethod -Uri "http://localhost:8001/health" -Method Get -ErrorAction Stop
} catch {
    Write-Host "❌ Card Words AI service is not running." -ForegroundColor Red
    Write-Host "Please start it with: docker-compose up -d card-words-ai" -ForegroundColor Yellow
    exit 1
}

# Train model
Write-Host "📊 Sending retrain request..." -ForegroundColor Yellow

$headers = @{
    "X-API-Key" = "card-words-admin-key-2024"
    "Content-Type" = "application/json"
}

$body = @{
    force = $true
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "http://localhost:8001/api/v1/smart-review/retrain" `
        -Method Post `
        -Headers $headers `
        -Body $body `
        -ErrorAction Stop
    
    Write-Host "✅ Model trained successfully!" -ForegroundColor Green
    $response | ConvertTo-Json -Depth 10 | Write-Host
} catch {
    Write-Host "❌ Training failed!" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}
