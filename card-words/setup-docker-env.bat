@echo off
REM Setup Docker Environment Script for Windows
REM Converts .env to .env.docker with Docker-specific values

setlocal enabledelayedexpansion

echo.
echo ===================================
echo   Setup Docker Environment
echo ===================================
echo.

REM Check if .env exists
if not exist ".env" (
    echo [ERROR] .env file not found!
    echo Please create .env file first.
    exit /b 1
)

REM Backup existing .env.docker if exists
if exist ".env.docker" (
    echo [WARNING] .env.docker already exists
    set /p OVERWRITE="Do you want to overwrite it? (y/n): "
    if /i not "!OVERWRITE!"=="y" (
        echo [INFO] Skipping...
        exit /b 0
    )
    move /y .env.docker .env.docker.backup >nul
    echo [INFO] Backed up to .env.docker.backup
)

REM Copy .env to .env.docker
copy /y .env .env.docker >nul
echo [SUCCESS] Copied .env to .env.docker

REM Replace localhost with Docker service names
echo [INFO] Converting localhost to Docker service names...

REM Create temporary file for processing
set "temp_file=%temp%\env_temp_%random%.txt"

REM Process each line
(for /f "usebackq delims=" %%a in (".env.docker") do (
    set "line=%%a"
    
    REM Replace POSTGRES_HOST
    set "line=!line:POSTGRES_HOST=localhost=POSTGRES_HOST=postgres!"
    
    REM Replace REDIS_HOST
    set "line=!line:REDIS_HOST=localhost=REDIS_HOST=redis!"
    
    echo !line!
)) > "%temp_file%"

REM Replace original file
move /y "%temp_file%" .env.docker >nul

echo [SUCCESS] Updated POSTGRES_HOST to 'postgres'
echo [SUCCESS] Updated REDIS_HOST to 'redis'

echo.
echo ========================================
echo   Setup completed successfully!
echo ========================================
echo.
echo [INFO] Next steps:
echo 1. Review .env.docker file
echo 2. Run: docker-compose up -d
echo 3. Check logs: docker-compose logs -f app
echo.
echo [SUCCESS] Happy Dockerizing!

endlocal
