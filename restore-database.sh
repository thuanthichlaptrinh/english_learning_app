#!/bin/bash
# Script to restore Docker PostgreSQL database

if [ -z "$1" ]; then
    echo "❌ Usage: ./restore-database.sh <backup_file.sql>"
    echo "📂 Available backups:"
    ls -lh ./database-backups/*.sql 2>/dev/null || echo "No backups found"
    exit 1
fi

BACKUP_FILE=$1

if [ ! -f "$BACKUP_FILE" ]; then
    echo "❌ Backup file not found: $BACKUP_FILE"
    exit 1
fi

echo "⚠️  WARNING: This will REPLACE all data in Docker database!"
read -p "Continue? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "❌ Restore cancelled"
    exit 0
fi

echo "🔄 Starting database restore..."

# Stop app to avoid conflicts
docker stop card-words-app

# Restore database
cat $BACKUP_FILE | docker exec -i card-words-postgres psql -U postgres -d card_words

if [ $? -eq 0 ]; then
    echo "✅ Restore successful!"
    
    # Restart app
    docker start card-words-app
    echo "🚀 App restarted"
else
    echo "❌ Restore failed!"
    docker start card-words-app
    exit 1
fi
