#!/bin/bash
# Rollback script generated at: Wed 04 Jun 2025 07:40:54 AM UTC
# Migration ID: 20250604_074052

echo "Rolling back nYtevibe migration..."

# Quick rollback to working state
rm -rf src
cp -r "../complete_project_backup_20250604_074052/src" .
cp "../complete_project_backup_20250604_074052/package.json" .

# Restore node_modules if needed
if [ ! -d node_modules ]; then
    npm install
fi

echo "Rollback completed. Testing application..."
npm run dev

