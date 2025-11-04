#!/bin/bash

# Script kiểm tra Redis keys cho Card Words application
# Sử dụng: ./check-redis-keys.sh

echo "🔍 Checking Redis Integration for Card Words"
echo "=============================================="

# Check if redis-cli is available
if ! command -v redis-cli &> /dev/null; then
    echo "❌ redis-cli not found!"
    echo "Please install Redis CLI first."
    exit 1
fi

# Check Redis connection
echo ""
echo "1️⃣ Checking Redis connection..."
PING_RESULT=$(redis-cli ping 2>&1)
if [ "$PING_RESULT" != "PONG" ]; then
    echo "❌ Redis server is not running!"
    echo "Please start Redis server: redis-server"
    exit 1
fi
echo "✅ Redis is running!"

# Get database size
echo ""
echo "2️⃣ Database statistics..."
DB_SIZE=$(redis-cli DBSIZE | grep -o '[0-9]*')
echo "📊 Total keys in DB: $DB_SIZE"

# Check card-words keys
echo ""
echo "3️⃣ Searching for card-words keys..."
KEYS=$(redis-cli KEYS "card-words:*")

if [ -z "$KEYS" ]; then
    echo "⚠️  No card-words keys found!"
    echo ""
    echo "💡 To create Redis keys:"
    echo "   1. Start Spring Boot app: mvn spring-boot:run"
    echo "   2. Login and get JWT token"
    echo "   3. Call game APIs:"
    echo "      - POST /api/quick-quiz/start"
    echo "      - POST /api/image-word-matching/start"
    echo "      - POST /api/word-def-matching/start"
    exit 0
fi

# Count keys by category
GAME_KEYS=$(echo "$KEYS" | grep "card-words:game:" | wc -l)
RATE_LIMIT_KEYS=$(echo "$KEYS" | grep "card-words:rate-limit:" | wc -l)
LEADERBOARD_KEYS=$(echo "$KEYS" | grep "card-words:leaderboard:" | wc -l)

echo "📝 Found keys:"
echo "   - Game sessions: $GAME_KEYS"
echo "   - Rate limiting: $RATE_LIMIT_KEYS"
echo "   - Leaderboards: $LEADERBOARD_KEYS"

# Show all keys with TTL
echo ""
echo "4️⃣ Key details:"
echo ""

IFS=$'\n'
for key in $KEYS; do
    # Get TTL
    TTL=$(redis-cli TTL "$key")
    
    # Get key type
    TYPE=$(redis-cli TYPE "$key")
    
    # Format TTL display
    if [ "$TTL" -eq -1 ]; then
        TTL_DISPLAY="∞ (no expiration)"
    elif [ "$TTL" -eq -2 ]; then
        TTL_DISPLAY="expired"
    else
        MINUTES=$((TTL / 60))
        SECONDS=$((TTL % 60))
        TTL_DISPLAY="${MINUTES}m ${SECONDS}s"
    fi
    
    echo "🔑 $key"
    echo "   Type: $TYPE | TTL: $TTL_DISPLAY"
    
    # Show value for small keys
    if [ "$TYPE" = "string" ]; then
        VALUE=$(redis-cli GET "$key" | head -c 100)
        if [ ${#VALUE} -gt 0 ]; then
            echo "   Value: ${VALUE}..."
        fi
    fi
    echo ""
done

# Show commands for manual inspection
echo "=============================================="
echo "🛠️  Useful commands:"
echo ""
echo "# View all keys"
echo "redis-cli KEYS 'card-words:*'"
echo ""
echo "# Get value of a key"
echo "redis-cli GET 'card-words:game:quiz:session:123:questions'"
echo ""
echo "# Check TTL"
echo "redis-cli TTL 'card-words:game:quiz:session:123:questions'"
echo ""
echo "# Delete all card-words keys (⚠️ careful!)"
echo "redis-cli KEYS 'card-words:*' | xargs redis-cli DEL"
echo ""
echo "# Flush entire database (⚠️ very careful!)"
echo "redis-cli FLUSHDB"
echo ""
echo "=============================================="
echo "💡 Open Redis Insight to view data visually!"
echo "   Connect to: localhost:6379, Database: 0"
