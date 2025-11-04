@echo off
REM Script kiểm tra Redis keys cho Card Words application
REM Sử dụng: check-redis-keys.bat

echo.
echo 🔍 Checking Redis Integration for Card Words
echo ==============================================

REM Check if redis-cli is available
where redis-cli >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ❌ redis-cli not found!
    echo Please install Redis CLI or add it to PATH
    exit /b 1
)

REM Check Redis connection
echo.
echo 1️⃣ Checking Redis connection...
redis-cli ping > temp_ping.txt 2>&1
set /p PING_RESULT=<temp_ping.txt
del temp_ping.txt

if not "%PING_RESULT%"=="PONG" (
    echo ❌ Redis server is not running!
    echo Please start Redis server
    exit /b 1
)
echo ✅ Redis is running!

REM Get database size
echo.
echo 2️⃣ Database statistics...
redis-cli DBSIZE

REM Check card-words keys
echo.
echo 3️⃣ Searching for card-words keys...
echo.

redis-cli KEYS "card-words:*" > temp_keys.txt
set /a KEY_COUNT=0
for /f %%i in (temp_keys.txt) do set /a KEY_COUNT+=1

if %KEY_COUNT% EQU 0 (
    echo ⚠️  No card-words keys found!
    echo.
    echo 💡 To create Redis keys:
    echo    1. Start Spring Boot app: mvn spring-boot:run
    echo    2. Login and get JWT token
    echo    3. Call game APIs:
    echo       - POST /api/quick-quiz/start
    echo       - POST /api/image-word-matching/start
    echo       - POST /api/word-def-matching/start
    del temp_keys.txt
    exit /b 0
)

echo 📝 Found %KEY_COUNT% keys
echo.
echo 4️⃣ Key details:
echo.

for /f "delims=" %%k in (temp_keys.txt) do (
    echo 🔑 %%k
    redis-cli TTL "%%k" > temp_ttl.txt
    set /p TTL=<temp_ttl.txt
    echo    TTL: !TTL!s
    redis-cli TYPE "%%k"
    echo.
)

del temp_keys.txt
del temp_ttl.txt 2>nul

echo ==============================================
echo 🛠️  Useful commands:
echo.
echo # View all keys
echo redis-cli KEYS "card-words:*"
echo.
echo # Get value of a key
echo redis-cli GET "card-words:game:quiz:session:123:questions"
echo.
echo # Check TTL
echo redis-cli TTL "card-words:game:quiz:session:123:questions"
echo.
echo # Delete all card-words keys (⚠️ careful!)
echo redis-cli DEL "card-words:*"
echo.
echo # Flush entire database (⚠️ very careful!)
echo redis-cli FLUSHDB
echo.
echo ==============================================
echo 💡 Open Redis Insight to view data visually!
echo    Connect to: localhost:6379, Database: 0
echo.

pause
