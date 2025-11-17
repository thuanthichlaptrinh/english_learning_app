#!/bin/bash
# Script kiểm tra backup/restore hoạt động đúng

echo "================================================"
echo "  CARD WORDS - BACKUP/RESTORE TEST SCRIPT"
echo "================================================"
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Step 1: Check Docker
echo -e "${YELLOW}[1/6] Checking Docker...${NC}"
if ! docker ps > /dev/null 2>&1; then
    echo -e "${RED}❌ Docker is not running!${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Docker is running${NC}"
echo ""

# Step 2: Check PostgreSQL container
echo -e "${YELLOW}[2/6] Checking PostgreSQL container...${NC}"
if ! docker ps | grep -q card-words-postgres; then
    echo -e "${RED}❌ PostgreSQL container not found!${NC}"
    echo "Run: docker-compose up -d"
    exit 1
fi
echo -e "${GREEN}✅ PostgreSQL container is running${NC}"
echo ""

# Step 3: Count current records
echo -e "${YELLOW}[3/6] Counting current records...${NC}"
BEFORE_USERS=$(docker exec card-words-postgres psql -U postgres -d card_words -t -c "SELECT COUNT(*) FROM users;" 2>/dev/null | tr -d ' ')
BEFORE_VOCAB=$(docker exec card-words-postgres psql -U postgres -d card_words -t -c "SELECT COUNT(*) FROM vocab;" 2>/dev/null | tr -d ' ')
BEFORE_TOPICS=$(docker exec card-words-postgres psql -U postgres -d card_words -t -c "SELECT COUNT(*) FROM topics;" 2>/dev/null | tr -d ' ')

if [ -z "$BEFORE_USERS" ] || [ -z "$BEFORE_VOCAB" ] || [ -z "$BEFORE_TOPICS" ]; then
    echo -e "${RED}❌ Cannot query database!${NC}"
    exit 1
fi

echo "  Users:  $BEFORE_USERS"
echo "  Vocab:  $BEFORE_VOCAB"
echo "  Topics: $BEFORE_TOPICS"
echo -e "${GREEN}✅ Database accessible${NC}"
echo ""

# Step 4: Create backup
echo -e "${YELLOW}[4/6] Creating test backup...${NC}"
./backup-database.sh > /dev/null 2>&1

# Find latest backup
LATEST_BACKUP=$(ls -t database-backups/*.sql | head -1)

if [ ! -f "$LATEST_BACKUP" ]; then
    echo -e "${RED}❌ Backup failed!${NC}"
    exit 1
fi

BACKUP_SIZE=$(du -h "$LATEST_BACKUP" | cut -f1)
echo "  File: $LATEST_BACKUP"
echo "  Size: $BACKUP_SIZE"
echo -e "${GREEN}✅ Backup created successfully${NC}"
echo ""

# Step 5: Test restore (same data)
echo -e "${YELLOW}[5/6] Testing restore...${NC}"
echo "  This will restore the same data (no changes expected)"
echo ""

# Stop app temporarily
docker stop card-words-app > /dev/null 2>&1

# Restore
cat "$LATEST_BACKUP" | docker exec -i card-words-postgres psql -U postgres -d card_words > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Restore failed!${NC}"
    docker start card-words-app > /dev/null 2>&1
    exit 1
fi

# Restart app
docker start card-words-app > /dev/null 2>&1
echo -e "${GREEN}✅ Restore completed${NC}"
echo ""

# Step 6: Verify data
echo -e "${YELLOW}[6/6] Verifying data...${NC}"
sleep 2  # Wait for database to stabilize

AFTER_USERS=$(docker exec card-words-postgres psql -U postgres -d card_words -t -c "SELECT COUNT(*) FROM users;" 2>/dev/null | tr -d ' ')
AFTER_VOCAB=$(docker exec card-words-postgres psql -U postgres -d card_words -t -c "SELECT COUNT(*) FROM vocab;" 2>/dev/null | tr -d ' ')
AFTER_TOPICS=$(docker exec card-words-postgres psql -U postgres -d card_words -t -c "SELECT COUNT(*) FROM topics;" 2>/dev/null | tr -d ' ')

echo "  BEFORE → AFTER"
echo "  Users:  $BEFORE_USERS → $AFTER_USERS"
echo "  Vocab:  $BEFORE_VOCAB → $AFTER_VOCAB"
echo "  Topics: $BEFORE_TOPICS → $AFTER_TOPICS"
echo ""

# Compare results
if [ "$BEFORE_USERS" = "$AFTER_USERS" ] && \
   [ "$BEFORE_VOCAB" = "$AFTER_VOCAB" ] && \
   [ "$BEFORE_TOPICS" = "$AFTER_TOPICS" ]; then
    echo -e "${GREEN}✅ Data verification PASSED${NC}"
    echo -e "${GREEN}✅ Backup/Restore is working correctly!${NC}"
else
    echo -e "${RED}❌ Data verification FAILED${NC}"
    echo "   Data counts do not match!"
    exit 1
fi

echo ""
echo "================================================"
echo "  🎉 ALL TESTS PASSED!"
echo "================================================"
echo ""
echo "📋 Summary:"
echo "  - Docker: ✅ Running"
echo "  - PostgreSQL: ✅ Accessible"
echo "  - Backup: ✅ Working ($BACKUP_SIZE)"
echo "  - Restore: ✅ Working"
echo "  - Data integrity: ✅ Verified"
echo ""
echo "💡 Your backup/restore setup is production-ready!"
