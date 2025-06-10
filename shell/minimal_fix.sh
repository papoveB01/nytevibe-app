#!/bin/bash

# MINIMAL CONSERVATIVE FIX - Only fix the specific includes() error
echo "======================================================="
echo "    MINIMAL CONSERVATIVE FIX"
echo "======================================================="

echo "This fix only targets the specific undefined.includes() error"
echo "without breaking the existing working code."
echo ""

BACKUP_DIR="./minimal_fix_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo "Creating backup in: $BACKUP_DIR"

# Backup current files
cp src/App.jsx "$BACKUP_DIR/" 2>/dev/null || echo "No App.jsx to backup"
cp src/context/AppContext.jsx "$BACKUP_DIR/" 2>/dev/null || echo "No AppContext.jsx to backup"

echo ""
echo ">>> STEP 1: ADD MINIMAL SAFETY TO APP.JSX"
echo "----------------------------------------"

# Only add defensive checks to the specific lines that use includes()
if [ -f "src/App.jsx" ]; then
    echo "Adding minimal safety to includes() calls in App.jsx..."
    
    # Create a safer version that handles undefined currentView
    sed -i.backup 's/state\.currentView/state.currentView || "login"/g' src/App.jsx
    
    # Remove backup file
    rm -f src/App.jsx.backup
    
    echo "✅ Added safety: state.currentView || 'login'"
    
    # Show what changed
    echo "Lines containing currentView:"
    grep -n "currentView" src/App.jsx || echo "No currentView references found"
else
    echo "❌ App.jsx not found"
fi

echo ""
echo ">>> STEP 2: CHECK APPCONTEXT FOR SAFE DEFAULTS"
echo "----------------------------------------"

if [ -f "src/context/AppContext.jsx" ]; then
    echo "Checking AppContext for safe initialization..."
    
    # Check if currentView is initialized
    if grep -q "currentView.*:" src/context/AppContext.jsx; then
        echo "✅ AppContext has currentView initialization"
        grep -n "currentView" src/context/AppContext.jsx
    else
        echo "⚠️ AppContext may not initialize currentView properly"
        echo "We may need to add: currentView: 'login'"
    fi
else
    echo "❌ AppContext.jsx not found"
fi

echo ""
echo ">>> STEP 3: TEST INSTRUCTIONS"
echo "----------------------------------------"

echo "1. Restart dev server:"
echo "   npm run dev"
echo ""
echo "2. Clear browser cache:"
echo "   Ctrl+Shift+R"
echo ""
echo "3. Test login:"
echo "   - Should see login page"
echo "   - Try logging in"
echo "   - Check if white screen error is resolved"
echo ""

echo "4. If still getting error, check console for:"
echo "   - What variable is undefined"
echo "   - Where the includes() call is happening"
echo ""

echo ">>> ROLLBACK THIS FIX IF NEEDED"
echo "----------------------------------------"
echo "If this breaks anything:"
echo "cp $BACKUP_DIR/App.jsx src/App.jsx"
echo "cp $BACKUP_DIR/AppContext.jsx src/context/AppContext.jsx"

echo ""
echo "======================================================="
echo "🎯 MINIMAL FIX APPLIED - TEST CAREFULLY"
echo "======================================================="
echo "This only changes undefined handling in App.jsx"
echo "If it works, great! If not, easy to rollback."
echo "======================================================="
