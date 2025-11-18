@echo off
if "%~1"=="" (
    echo Usage: restore-database.bat backup_file.sql
    exit /b 1
)
if not exist "%~1" (
    echo File not found: %~1
    exit /b 1
)
set /p confirm="WARNING: DROP database? (yes/no): "
if /i not "%confirm%"=="yes" exit /b 0
echo Stopping app...
docker stop card-words-api 2>nul
docker exec card-words-postgres psql -U postgres -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'card_words' AND pid <> pg_backend_pid();"
echo Dropping database...
docker exec card-words-postgres psql -U postgres -c "DROP DATABASE IF EXISTS card_words;"
echo Creating database...
docker exec card-words-postgres psql -U postgres -c "CREATE DATABASE card_words;"
echo Restoring...
docker cp "%~1" card-words-postgres:/tmp/restore.sql
docker exec card-words-postgres bash -c "psql -U postgres -d card_words < /tmp/restore.sql"
docker exec card-words-postgres rm /tmp/restore.sql
docker start card-words-api 2>nul
echo Done!
