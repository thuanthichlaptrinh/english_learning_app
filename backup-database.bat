@echo off
REM Script to backup Docker PostgreSQL database (Windows)

setlocal enabledelayedexpansion

for /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c%%a%%b)
for /f "tokens=1-2 delims=/:" %%a in ('time /t') do (set mytime=%%a%%b)
set TIMESTAMP=%mydate%_%mytime%

set BACKUP_DIR=database-backups
set BACKUP_FILE=%BACKUP_DIR%\card_words_%TIMESTAMP%.sql

REM Create backup directory
if not exist %BACKUP_DIR% mkdir %BACKUP_DIR%

echo 🔄 Starting database backup...

REM Backup database
docker exec card-words-postgres pg_dump -U postgres -d card_words > "%BACKUP_FILE%"

if %ERRORLEVEL% EQU 0 (
    echo ✅ Backup successful: %BACKUP_FILE%
    for %%A in ("%BACKUP_FILE%") do echo 📦 File size: %%~zA bytes
) else (
    echo ❌ Backup failed!
    exit /b 1
)

echo ✅ Done!
pause
