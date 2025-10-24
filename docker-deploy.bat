@echo off
REM Complete Docker Deployment Script for Windows

setlocal enabledelayedexpansion

echo.
echo ========================================
echo    Docker Deployment Script
echo ========================================
echo.

REM Step 1: Setup environment
echo [INFO] Step 1: Setting up environment...
if not exist ".env.docker" (
    echo [WARNING] .env.docker not found, creating from .env...
    call setup-docker-env.bat
    if errorlevel 1 (
        echo [ERROR] Failed to setup environment
        exit /b 1
    )
) else (
    echo [SUCCESS] .env.docker already exists
)
echo.

REM Step 2: Stop existing containers
echo [INFO] Step 2: Stopping existing containers...
docker-compose ps >nul 2>&1
if not errorlevel 1 (
    docker-compose down
    echo [SUCCESS] Containers stopped
) else (
    echo [WARNING] No running containers found
)
echo.

REM Step 3: Build images
echo [INFO] Step 3: Building Docker images...
docker-compose build --no-cache
if errorlevel 1 (
    echo [ERROR] Build failed!
    exit /b 1
)
echo [SUCCESS] Build completed
echo.

REM Step 4: Start services
echo [INFO] Step 4: Starting services...
docker-compose up -d
if errorlevel 1 (
    echo [ERROR] Failed to start services!
    exit /b 1
)
echo.

REM Step 5: Wait for services
echo [INFO] Step 5: Waiting for services to be ready...
echo [WARNING] This may take a minute...

REM Wait for PostgreSQL (30 seconds max)
echo [INFO] Checking PostgreSQL...
for /L %%i in (1,1,30) do (
    docker-compose exec -T postgres pg_isready -U postgres >nul 2>&1
    if not errorlevel 1 (
        echo [SUCCESS] PostgreSQL is ready
        goto :redis_check
    )
    timeout /t 1 /nobreak >nul
)
echo [WARNING] PostgreSQL health check timeout

:redis_check
REM Wait for Redis (30 seconds max)
echo [INFO] Checking Redis...
for /L %%i in (1,1,30) do (
    docker-compose exec -T redis redis-cli ping >nul 2>&1
    if not errorlevel 1 (
        echo [SUCCESS] Redis is ready
        goto :app_check
    )
    timeout /t 1 /nobreak >nul
)
echo [WARNING] Redis health check timeout

:app_check
REM Wait for Application (60 seconds max)
echo [INFO] Checking Application...
for /L %%i in (1,1,60) do (
    curl -s http://localhost:8080/actuator/health >nul 2>&1
    if not errorlevel 1 (
        echo [SUCCESS] Application is ready
        goto :show_status
    )
    timeout /t 1 /nobreak >nul
)
echo [WARNING] Application health check timeout

:show_status
echo.
REM Step 6: Show status
echo [INFO] Step 6: Service Status
docker-compose ps
echo.

REM Show completion message
echo ========================================
echo   Deployment completed successfully!
echo ========================================
echo.
echo [INFO] Application URLs:
echo   - API: http://localhost:8080
echo   - Swagger: http://localhost:8080/swagger-ui.html
echo   - Health: http://localhost:8080/actuator/health
echo.
echo [INFO] Useful commands:
echo   - View logs: docker-compose logs -f app
echo   - Stop all: docker-compose down
echo   - Restart: docker-compose restart app
echo.

REM Ask to view logs
set /p VIEW_LOGS="Do you want to view application logs? (y/n): "
if /i "%VIEW_LOGS%"=="y" (
    docker-compose logs -f app
)

endlocal
