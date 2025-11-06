#!/bin/bash
# Auto-backup script with scheduled backups (Linux/Mac)
# Use cron to run this script periodically

echo "================================================"
echo "  CARD WORDS - AUTO BACKUP SCRIPT"
echo "================================================"
echo ""

# 1. Backup database
echo "[$(date)] Starting automatic backup..."
./backup-database.sh

# 2. Check result
if [ $? -eq 0 ]; then
    echo "[$(date)] ✅ Backup successful!"
    
    # 3. Optional: Upload to cloud storage
    # Uncomment and configure the lines below to auto-upload
    
    # === Google Drive (using rclone) ===
    # rclone copy database-backups/ gdrive:card-words-backups/
    
    # === Dropbox ===
    # rclone copy database-backups/ dropbox:card-words-backups/
    
    # === AWS S3 ===
    # aws s3 sync database-backups/ s3://your-bucket/card-words-backups/
    
    # === Git Repository (if not sensitive) ===
    # cd database-backups
    # git add *.sql
    # git commit -m "Auto backup $(date)"
    # git push origin main
    
    echo "[$(date)] 📤 Backup uploaded to cloud (if configured)"
else
    echo "[$(date)] ❌ Backup failed!"
    
    # Optional: Send notification
    # curl -X POST "https://your-webhook-url" -d "Backup failed on $HOSTNAME"
fi

echo ""
echo "================================================"
echo "  Backup job completed"
echo "================================================"

# Log to file
echo "[$(date)] Backup job completed with exit code $?" >> backup-log.txt
