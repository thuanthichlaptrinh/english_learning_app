# Train Random Forest model - PowerShell script

$API_KEY = if ($env:ADMIN_API_KEY) { $env:ADMIN_API_KEY } else { "card-words-admin-key-2024" }
$API_URL = if ($env:API_URL) { $env:API_URL } else { "http://localhost:8001" }

Write-Host "🌲 Training Random Forest Model..." -ForegroundColor Green
Write-Host "API URL: $API_URL"
Write-Host ""

$body = @{
    force = $true
    model_type = "random_forest"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$API_URL/api/v1/smart-review/retrain" `
        -Method Post `
        -Headers @{
            "X-API-Key" = $API_KEY
            "Content-Type" = "application/json"
        } `
        -Body $body
    
    Write-Host ""
    Write-Host "✅ Random Forest training completed!" -ForegroundColor Green
    Write-Host ""
    
    $response | ConvertTo-Json -Depth 10 | Write-Host
    
} catch {
    Write-Host ""
    Write-Host "❌ Training failed!" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}
