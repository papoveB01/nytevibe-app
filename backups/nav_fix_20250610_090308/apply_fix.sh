#!/bin/bash

# Automatic AppContext Navigation Fix

APPCONTEXT_FILE="/var/www/nytevibe/src/context/AppContext.jsx"
BACKUP_FILE="/var/www/nytevibe/src/context/AppContext.jsx.backup.$(date +%H%M%S)"

echo "🔧 Applying automatic navigation fix..."

# Backup current file
cp "$APPCONTEXT_FILE" "$BACKUP_FILE"
echo "📦 Backup created: $BACKUP_FILE"

# Check if navigation actions are missing
if ! grep -q "setCurrentView:" "$APPCONTEXT_FILE"; then
    echo "🔧 Adding missing navigation actions..."
    
    # Find the actions object and add navigation functions
    sed -i '/const actions = {/a\
    // 🔥 NAVIGATION ACTIONS - CRITICAL FOR LINKS TO WORK\
    setView: useCallback((view) => {\
      console.log("🎯 AppContext: Setting view to:", view);\
      dispatch({ type: actionTypes.SET_CURRENT_VIEW, payload: view });\
    }, []),\
    \
    setCurrentView: useCallback((view) => {\
      console.log("🎯 AppContext: Setting current view to:", view);\
      dispatch({ type: actionTypes.SET_CURRENT_VIEW, payload: view });\
    }, []),\
    ' "$APPCONTEXT_FILE"
    
    echo "✅ Navigation actions added to AppContext"
else
    echo "✅ Navigation actions already present"
fi

echo "🏁 Fix applied! Restart your frontend server."
