#!/bin/bash

# Auto-generated rollback script for nYtevibe Beautiful Verification Page deployment

BACKUP_DIR="./backup_beautiful_verification_20250607_175233"
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
NC='\033[0m'

echo -e "${PURPLE}========================================${NC}"
echo -e "${PURPLE}  nYtevibe Beautiful Verification${NC}"
echo -e "${PURPLE}        Rollback Script${NC}"
echo -e "${PURPLE}========================================${NC}"

if [ ! -d "$BACKUP_DIR" ]; then
    echo -e "${RED}ERROR: Backup directory not found: $BACKUP_DIR${NC}"
    exit 1
fi

echo -e "${YELLOW}Rolling back files from: $BACKUP_DIR${NC}"

# Restore backed up files
find "$BACKUP_DIR" -type f \( -name "*.jsx" -o -name "*.js" \) | while read backup_file; do
    # Calculate relative path
    relative_path=${backup_file#$BACKUP_DIR/}
    
    if [ "$relative_path" != "backup_manifest.txt" ]; then
        echo "Restoring: $relative_path"
        mkdir -p "$(dirname "$relative_path")"
        cp "$backup_file" "$relative_path"
    fi
done

echo -e "${GREEN}✅ Rollback completed successfully!${NC}"
echo -e "${YELLOW}Please restart your development server if running.${NC}"
