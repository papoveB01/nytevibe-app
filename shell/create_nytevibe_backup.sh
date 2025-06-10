#!/bin/bash

# nYtevibe Database Backup Script
# Automated daily backup with rotation

# Configuration
DB_HOST="localhost"
DB_PORT="3306"
DB_NAME="nytevibe"
DB_USER="your_username"
BACKUP_DIR="/var/backups/mysql/nytevibe"
RETENTION_DAYS=30

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Generate backup filename with timestamp
BACKUP_DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/nytevibe_backup_$BACKUP_DATE.sql"
COMPRESSED_FILE="$BACKUP_DIR/nytevibe_backup_$BACKUP_DATE.sql.gz"

echo "🗄️ Starting nYtevibe database backup..."
echo "📅 Date: $(date)"
echo "📁 Backup file: $COMPRESSED_FILE"

# Create the backup
mysqldump \
  --host="$DB_HOST" \
  --port="$DB_PORT" \
  --user="$DB_USER" \
  --password \
  --single-transaction \
  --routines \
  --triggers \
  --events \
  --hex-blob \
  --add-drop-database \
  --databases "$DB_NAME" \
  --result-file="$BACKUP_FILE"

# Check if backup was successful
if [ $? -eq 0 ]; then
    echo "✅ Database backup completed successfully"
    
    # Compress the backup
    gzip "$BACKUP_FILE"
    echo "✅ Backup compressed: $COMPRESSED_FILE"
    
    # Get file size
    BACKUP_SIZE=$(du -h "$COMPRESSED_FILE" | cut -f1)
    echo "📊 Backup size: $BACKUP_SIZE"
    
    # Remove old backups (older than retention period)
    echo "🧹 Cleaning up old backups (older than $RETENTION_DAYS days)..."
    find "$BACKUP_DIR" -name "nytevibe_backup_*.sql.gz" -type f -mtime +$RETENTION_DAYS -delete
    
    echo "✅ Backup process completed successfully!"
    
else
    echo "❌ Backup failed!"
    exit 1
fi
