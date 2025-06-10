#!/bin/bash
echo "🔄 Rolling back test changes..."

# Restore ExistingApp.jsx from backup
BACKUP_FILE=$(ls src/ExistingApp.jsx.backup.* | tail -1)
if [ -f "$BACKUP_FILE" ]; then
    cp "$BACKUP_FILE" src/ExistingApp.jsx
    echo "✅ ExistingApp.jsx restored from $BACKUP_FILE"
else
    echo "❌ No backup found"
fi

# Remove test LoginView
if [ -f "src/components/Views/LoginView.test.jsx" ]; then
    rm src/components/Views/LoginView.test.jsx
    echo "✅ Test LoginView removed"
fi

echo "🏁 Rollback complete"
