#!/bin/bash
# Rollback script generated at: Wed 04 Jun 2025 07:43:55 AM UTC
# Migration ID: 20250604_074353

echo "Rolling back nYtevibe migration..."

# Remove any created files
rm -f src/ExistingApp.jsx
rm -f src/ExistingApp.jsx.bak
rm -rf src/router

# Restore original files
if [ -f src/App.jsx.backup ]; then
    cp src/App.jsx.backup src/App.jsx
    rm -f src/App.jsx.backup
fi

if [ -f src/context/AppContext.jsx.backup ]; then
    cp src/context/AppContext.jsx.backup src/context/AppContext.jsx
    rm -f src/context/AppContext.jsx.backup
fi

# Full rollback to working state if needed
# rm -rf src
# cp -r "../complete_project_backup_20250604_074353/src" .
# cp "../complete_project_backup_20250604_074353/package.json" .

# Restore node_modules if needed
if [ ! -d node_modules ]; then
    npm install
fi

echo "Rollback completed. Testing application..."
npm run build

