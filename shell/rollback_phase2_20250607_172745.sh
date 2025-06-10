#!/bin/bash

# Auto-generated rollback script for nYtevibe Phase 2 deployment

BACKUP_DIR="./backup_phase2_20250607_172745"
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}========================================${NC}"
echo -e "${YELLOW}  nYtevibe Phase 2 Rollback Script${NC}"
echo -e "${YELLOW}========================================${NC}"

if [ ! -d "$BACKUP_DIR" ]; then
    echo -e "${RED}ERROR: Backup directory not found: $BACKUP_DIR${NC}"
    exit 1
fi

echo -e "${YELLOW}Rolling back files from: $BACKUP_DIR${NC}"

# Restore backed up files
find "$BACKUP_DIR" -type f \( -name "*.jsx" -o -name "*.js" -o -name "*.json" \) | while read backup_file; do
    # Calculate relative path
    relative_path=${backup_file#$BACKUP_DIR/}
    
    if [ "$relative_path" != "backup_manifest.txt" ]; then
        echo "Restoring: $relative_path"
        mkdir -p "$(dirname "$relative_path")"
        cp "$backup_file" "$relative_path"
    fi
done

# Remove new files that were created (if any)
NEW_FILES=(
    "src/services/emailVerificationAPI.js"
    "src/components/Auth/EmailVerificationRoute.jsx"
)

for file in "${NEW_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "Removing new file: $file"
        rm "$file"
    fi
done

echo -e "${GREEN}✅ Rollback completed successfully!${NC}"
echo -e "${YELLOW}Please restart your development server if running.${NC}"
