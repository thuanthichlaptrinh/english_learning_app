@echo off
for /f "tokens=2-4 delims=/ " %%a in ('date /t') do set mydate=%%c%%a%%b
for /f "tokens=1-3 delims=:., " %%a in ("%time%") do set mytime=%%a%%b%%c
set mytime=%mytime: =0%
set BACKUP_FILE=database-backups\card_words_%mydate%_%mytime%.sql
if not exist database-backups mkdir database-backups
echo Creating backup...
docker exec card-words-postgres pg_dump -U postgres -d card_words --encoding=UTF8 --clean --if-exists > "%BACKUP_FILE%"
if %ERRORLEVEL% EQU 0 (
    echo Success: %BACKUP_FILE%
    for %%A in ("%BACKUP_FILE%") do echo Size: %%~zA bytes
) else (
    echo Failed!
    exit /b 1
)
echo Done!
