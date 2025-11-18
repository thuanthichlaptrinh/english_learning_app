# Setup script for Card Words AI Service (PowerShell)

Write-Host "🚀 Setting up Card Words AI Service..." -ForegroundColor Cyan

# Check if Docker is running
try {
    docker info | Out-Null
} catch {
    Write-Host "❌ Docker is not running. Please start Docker and try again." -ForegroundColor Red
    exit 1
}

# Check if root .env file exists
if (-not (Test-Path ..\..\..\.env)) {
    Write-Host "❌ Root .env file not found at ..\..\..\.env" -ForegroundColor Red
    Write-Host "Please ensure you have the .env file in the project root directory." -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Found root .env file at ..\..\..\.env" -ForegroundColor Green

# Create models directory
Write-Host "📁 Creating models directory..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path models | Out-Null
New-Item -ItemType Directory -Force -Path models/backups | Out-Null

Write-Host "✅ Setup completed!" -ForegroundColor Green
Write-Host ""
Write-Host "📌 IMPORTANT: This service uses the SHARED .env file from the root directory" -ForegroundColor Cyan
Write-Host "   Location: ..\..\..\.env"
Write-Host "   See ENV_CONFIG.md for details"
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Check root .env file: ..\..\..\.env"
Write-Host "2. Run: cd ..\.. && docker-compose up -d card-words-ai"
Write-Host "3. Train initial model: .\train-model.ps1"
