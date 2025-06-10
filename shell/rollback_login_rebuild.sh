#!/bin/bash

# Rollback Login Rebuild Script
echo "🔄 Rolling back login system changes..."
echo "====================================="
echo ""

# Restore all backed up files
BACKUP_DIR="login_rebuild_backup_20250607_210934"

if [ ! -d "$BACKUP_DIR" ]; then
    echo "❌ Backup directory $BACKUP_DIR not found!"
    exit 1
fi

echo "📦 Restoring files from: $BACKUP_DIR"
echo ""

# Restore each file
for backup_file in "$BACKUP_DIR"/*.backup; do
    if [ -f "$backup_file" ]; then
        filename=$(basename "$backup_file" .backup)
        original_path=$(find src -name "$filename" -type f | head -1)
        
        if [ -n "$original_path" ]; then
            cp "$backup_file" "$original_path"
            echo "✅ Restored: $original_path"
        else
            echo "⚠️ Could not find original location for: $filename"
        fi
    fi
done

echo ""
echo "✅ Rollback completed!"
echo "🚀 Run 'npm run build' to test"
