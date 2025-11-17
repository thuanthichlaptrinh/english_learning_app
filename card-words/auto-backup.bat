@echo off
REM Auto-backup script với lịch trình định kỳ (Windows)
REM Sử dụng Windows Task Scheduler để chạy script này mỗi ngày

echo ================================================
echo   CARD WORDS - AUTO BACKUP SCRIPT
echo ================================================
echo.

REM 1. Backup database
echo [%date% %time%] Starting automatic backup...
call backup-database.bat

REM 2. Kiểm tra kết quả
if %ERRORLEVEL% EQU 0 (
    echo [%date% %time%] ✅ Backup successful!
    
    REM 3. Optional: Upload to cloud storage
    REM Uncomment và config các dòng dưới đây để tự động upload
    
    REM === Google Drive (dùng rclone) ===
    REM rclone copy database-backups/ gdrive:card-words-backups/
    
    REM === Dropbox ===
    REM rclone copy database-backups/ dropbox:card-words-backups/
    
    REM === AWS S3 ===
    REM aws s3 sync database-backups/ s3://your-bucket/card-words-backups/
    
    REM === Git Repository (nếu không sensitive) ===
    REM cd database-backups
    REM git add *.sql
    REM git commit -m "Auto backup %date% %time%"
    REM git push origin main
    
    echo [%date% %time%] 📤 Backup uploaded to cloud (if configured)
) else (
    echo [%date% %time%] ❌ Backup failed!
    
    REM Optional: Send notification
    REM curl -X POST "https://your-webhook-url" -d "Backup failed on %COMPUTERNAME%"
)

echo.
echo ================================================
echo   Backup job completed
echo ================================================

REM Log to file
echo [%date% %time%] Backup job completed with exit code %ERRORLEVEL% >> backup-log.txt
