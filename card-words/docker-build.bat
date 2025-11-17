@echo off
REM Card Words - Docker Build & Push Script for Windows
REM Usage: docker-build.bat [version]

setlocal enabledelayedexpansion

REM Configuration
set DOCKER_USERNAME=thuanthichlaptrinh
set IMAGE_NAME=card-words
set VERSION=%1
if "%VERSION%"=="" set VERSION=latest

echo.
echo ===================================
echo   Docker Build ^& Push Script
echo ===================================
echo.

REM Check if Docker is installed
docker --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Docker is not installed!
    exit /b 1
)

echo [INFO] Building Docker image...
echo Image: %DOCKER_USERNAME%/%IMAGE_NAME%:%VERSION%
echo.

REM Build the image
docker build -t %DOCKER_USERNAME%/%IMAGE_NAME%:%VERSION% .
if errorlevel 1 (
    echo [ERROR] Build failed!
    exit /b 1
)

REM Tag as latest if version is not latest
if not "%VERSION%"=="latest" (
    docker tag %DOCKER_USERNAME%/%IMAGE_NAME%:%VERSION% %DOCKER_USERNAME%/%IMAGE_NAME%:latest
    echo [INFO] Tagged as latest
)

echo.
echo [SUCCESS] Build completed successfully!
echo.

REM Ask to push
set /p PUSH="Do you want to push to Docker Hub? (y/n): "
if /i "%PUSH%"=="y" (
    echo.
    echo [INFO] Pushing to Docker Hub...
    
    docker push %DOCKER_USERNAME%/%IMAGE_NAME%:%VERSION%
    if errorlevel 1 (
        echo [ERROR] Push failed!
        exit /b 1
    )
    
    if not "%VERSION%"=="latest" (
        docker push %DOCKER_USERNAME%/%IMAGE_NAME%:latest
    )
    
    echo.
    echo [SUCCESS] Push completed successfully!
    echo [INFO] Image available at: https://hub.docker.com/r/%DOCKER_USERNAME%/%IMAGE_NAME%
) else (
    echo [INFO] Skipping push
)

echo.
echo [INFO] Image information:
docker images | findstr "%DOCKER_USERNAME%/%IMAGE_NAME%"
echo.
echo [SUCCESS] Done!

endlocal
