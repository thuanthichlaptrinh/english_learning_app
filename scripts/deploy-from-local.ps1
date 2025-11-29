# ============================================
# Deploy từ máy Windows (PowerShell)
# Chạy script này sau khi push code
# ============================================

$VPS_HOST = "103.9.77.220"
$VPS_USER = "root"
$PROJECT_DIR = "/opt/card-words-services"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Deploy to VPS from Windows" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Kiểm tra đã push code chưa
Write-Host "⚠️  Đảm bảo bạn đã push code lên GitHub:" -ForegroundColor Yellow
Write-Host "   git push origin main" -ForegroundColor Yellow
Write-Host ""

$confirm = Read-Host "Đã push code? (y/n)"

if ($confirm -ne "y") {
    Write-Host "Vui lòng push code trước khi deploy!" -ForegroundColor Red
    exit
}

Write-Host ""
Write-Host "🚀 Đang deploy lên VPS..." -ForegroundColor Green
Write-Host ""

# SSH và chạy deploy script
ssh "${VPS_USER}@${VPS_HOST}" "cd ${PROJECT_DIR} && bash scripts/deploy-vps.sh"

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "✅ Deploy hoàn tất!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "🌐 Kiểm tra API:" -ForegroundColor Yellow
Write-Host "   curl http://103.9.77.220:8080/actuator/health" -ForegroundColor Yellow
Write-Host ""
