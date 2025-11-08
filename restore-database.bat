@echo off
REM Script to restore Docker PostgreSQL database (Windows)

if "%~1"=="" (
    echo ❌ Usage: restore-database.bat ^<backup_file.sql^>
    echo 📂 Available backups:
    dir /b database-backups\*.sql 2>nul
    exit /b 1
)

set BACKUP_FILE=%~1

if not exist "%BACKUP_FILE%" (
    echo ❌ Backup file not found: %BACKUP_FILE%
    exit /b 1
)

echo ⚠️  WARNING: This will REPLACE all data in Docker database!
set /p confirm="Continue? (yes/no): "

if /i not "%confirm%"=="yes" (
    echo ❌ Restore cancelled
    exit /b 0
)

echo 🔄 Starting database restore...

REM Stop app
docker stop card-words-app

REM Drop and recreate database to avoid conflicts
echo 🗑️  Dropping existing database...
docker exec -i card-words-postgres psql -U postgres -c "DROP DATABASE IF EXISTS card_words;"
docker exec -i card-words-postgres psql -U postgres -c "CREATE DATABASE card_words;"

REM Restore database
echo 📥 Restoring from backup...
type "%BACKUP_FILE%" | docker exec -i card-words-postgres psql -U postgres -d card_words

if %ERRORLEVEL% EQU 0 (
    echo ✅ Restore successful!
    docker start card-words-app
    echo 🚀 App restarted
) else (
    echo ❌ Restore failed!
    docker start card-words-app
    exit /b 1
)

pause
