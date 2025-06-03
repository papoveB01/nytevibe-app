#!/bin/bash

# EMERGENCY ROLLBACK - Restore Working State
echo "🚨 EMERGENCY ROLLBACK - RESTORING WORKING STATE"
echo "================================================="

# Find the most recent backup directory
LATEST_BACKUP=$(ls -td ./context_fix_backup_* 2>/dev/null | head -1)

if [ -z "$LATEST_BACKUP" ]; then
    echo "❌ No backup directory found! Looking for other backups..."
    
    # Try other backup directories
    for backup_dir in ./user_storage_fix_backup_* ./post_login_fix_backup_* ./login_fixes_backup_*; do
        if [ -d "$backup_dir" ]; then
            LATEST_BACKUP="$backup_dir"
            echo "Found backup: $backup_dir"
            break
        fi
    done
fi

if [ -n "$LATEST_BACKUP" ] && [ -d "$LATEST_BACKUP" ]; then
    echo "✅ Using backup directory: $LATEST_BACKUP"
    echo ""
    
    # Restore AppContext if available
    if [ -f "$LATEST_BACKUP/AppContext.jsx.broken" ]; then
        echo "Restoring AppContext.jsx..."
        cp "$LATEST_BACKUP/AppContext.jsx.broken" src/context/AppContext.jsx
        echo "✅ AppContext.jsx restored"
    elif [ -f "$LATEST_BACKUP/AppContext.jsx" ]; then
        echo "Restoring AppContext.jsx from backup..."
        cp "$LATEST_BACKUP/AppContext.jsx" src/context/AppContext.jsx
        echo "✅ AppContext.jsx restored"
    else
        echo "❌ No AppContext.jsx backup found in $LATEST_BACKUP"
    fi
    
    # Restore App.jsx if available
    if [ -f "$LATEST_BACKUP/App.jsx.current" ]; then
        echo "Restoring App.jsx..."
        cp "$LATEST_BACKUP/App.jsx.current" src/App.jsx
        echo "✅ App.jsx restored"
    elif [ -f "$LATEST_BACKUP/App.jsx.original" ]; then
        echo "Restoring App.jsx from original backup..."
        cp "$LATEST_BACKUP/App.jsx.original" src/App.jsx
        echo "✅ App.jsx restored"
    elif [ -f "$LATEST_BACKUP/App.jsx" ]; then
        echo "Restoring App.jsx from backup..."
        cp "$LATEST_BACKUP/App.jsx" src/App.jsx
        echo "✅ App.jsx restored"
    else
        echo "❌ No App.jsx backup found"
    fi
    
    # Restore LoginView if it was changed
    if [ -f "$LATEST_BACKUP/LoginView.jsx.broken" ]; then
        echo "Restoring LoginView.jsx..."
        cp "$LATEST_BACKUP/LoginView.jsx.broken" src/components/Views/LoginView.jsx
        echo "✅ LoginView.jsx restored"
    fi
    
else
    echo "❌ No backup directory found!"
    echo "We need to manually fix this..."
fi

echo ""
echo "🔧 MANUAL RECOVERY IF NEEDED"
echo "============================"

# Check if the main files exist and show their status
echo "Current file status:"
echo "-------------------"

if [ -f "src/App.jsx" ]; then
    echo "✅ src/App.jsx exists"
    echo "First few lines:"
    head -5 src/App.jsx
else
    echo "❌ src/App.jsx MISSING!"
fi

echo ""

if [ -f "src/context/AppContext.jsx" ]; then
    echo "✅ src/context/AppContext.jsx exists"
    echo "First few lines:"
    head -5 src/context/AppContext.jsx
else
    echo "❌ src/context/AppContext.jsx MISSING!"
fi

echo ""

# Remove any broken debug files
echo "Cleaning up debug files..."
rm -f src/App.debug.jsx
rm -f src/components/DebugApp.jsx
rm -f src/context/AppContext.fixed.jsx
echo "✅ Debug files cleaned up"

echo ""
echo "🚀 RESTART INSTRUCTIONS"
echo "======================="
echo "1. Restart your dev server NOW:"
echo "   Ctrl+C (stop current server)"
echo "   npm run dev"
echo ""
echo "2. Clear browser cache:"
echo "   Ctrl+Shift+R (or Cmd+Shift+R)"
echo ""
echo "3. Check browser console for errors"
echo ""

echo "💡 QUICK STATUS CHECK"
echo "===================="
echo "After restart, check:"
echo "• Does the login page load? (should see nYtevibe login form)"
echo "• Any console errors?"
echo "• Can you attempt login?"
echo ""

echo "If login page loads but you still get the original error after login:"
echo "• The rollback worked - we're back to the known state"
echo "• We can apply a more conservative fix"
echo ""

echo "If login page still doesn't load:"
echo "• Check console for specific error messages"
echo "• We may need to restore from an earlier backup"

echo ""
echo "================================================="
echo "🎯 RESTART SERVER NOW AND REPORT STATUS!"
echo "================================================="
