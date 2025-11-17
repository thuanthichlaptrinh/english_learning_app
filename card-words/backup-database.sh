#!/bin/bash
# Script to backup Docker PostgreSQL database

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="./database-backups"
BACKUP_FILE="$BACKUP_DIR/card_words_$TIMESTAMP.sql"

# Create backup directory if not exists
mkdir -p $BACKUP_DIR

echo "🔄 Starting database backup..."

# Backup database
docker exec card-words-postgres pg_dump -U postgres -d card_words > $BACKUP_FILE

if [ $? -eq 0 ]; then
    echo "✅ Backup successful: $BACKUP_FILE"
    echo "📦 File size: $(du -h $BACKUP_FILE | cut -f1)"
else
    echo "❌ Backup failed!"
    exit 1
fi

# Keep only last 5 backups
cd $BACKUP_DIR
ls -t card_words_*.sql | tail -n +6 | xargs -r rm
echo "🗑️  Cleaned old backups (keeping last 5)"
