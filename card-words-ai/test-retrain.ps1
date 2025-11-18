# Test retrain API
$headers = @{
    "X-API-Key" = "card-words-admin-key-2024"
    "Content-Type" = "application/json"
}

$body = @{
    force = $true
} | ConvertTo-Json

Write-Host "Testing /api/v1/smart-review/retrain endpoint..." -ForegroundColor Cyan
Write-Host "URL: http://localhost:8001/api/v1/smart-review/retrain" -ForegroundColor Yellow
Write-Host "Headers: X-API-Key = card-words-admin-key-2024" -ForegroundColor Yellow
Write-Host "Body: $body" -ForegroundColor Yellow
Write-Host ""

try {
    $response = Invoke-RestMethod -Uri "http://localhost:8001/api/v1/smart-review/retrain" `
        -Method POST `
        -Headers $headers `
        -Body $body `
        -ContentType "application/json"
    
    Write-Host "✅ SUCCESS!" -ForegroundColor Green
    Write-Host "Response:" -ForegroundColor Green
    $response | ConvertTo-Json -Depth 10
} catch {
    Write-Host "❌ FAILED!" -ForegroundColor Red
    Write-Host "Status Code: $($_.Exception.Response.StatusCode.value__)" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    
    # Try to get response body
    try {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $responseBody = $reader.ReadToEnd()
        Write-Host "Response Body: $responseBody" -ForegroundColor Red
    } catch {
        Write-Host "Could not read response body" -ForegroundColor Red
    }
}
