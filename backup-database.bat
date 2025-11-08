@echo off
REM Script to backup Docker PostgreSQL database (Windows)

setlocal enabledelayedexpansion

REM Get date in YYYYMMDD format
for /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c%%a%%b)

REM Get time in 24-hour format HHMMSS (without AM/PM)
for /f "tokens=1-4 delims=:.," %%a in ("%time%") do (
    set hour=%%a
    set minute=%%b
    set second=%%c
)
REM Remove leading space from hour
set hour=%hour: =0%
set mytime=%hour%%minute%%second%

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
