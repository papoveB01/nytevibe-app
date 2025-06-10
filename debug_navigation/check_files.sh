#!/bin/bash

echo "📋 Checking File Integrity..."
echo "============================="

# Check if critical files exist and have recent modifications
FRONTEND_DIR="/var/www/nytevibe/src"

echo "🔍 Checking critical navigation files..."

# Check AppContext
if [ -f "$FRONTEND_DIR/context/AppContext.jsx" ]; then
    echo "✅ AppContext.jsx exists"
    echo "   Last modified: $(stat -c %y "$FRONTEND_DIR/context/AppContext.jsx")"
    echo "   Size: $(stat -c %s "$FRONTEND_DIR/context/AppContext.jsx") bytes"
else
    echo "❌ AppContext.jsx missing!"
fi

# Check ExistingApp
if [ -f "$FRONTEND_DIR/ExistingApp.jsx" ]; then
    echo "✅ ExistingApp.jsx exists"
    echo "   Last modified: $(stat -c %y "$FRONTEND_DIR/ExistingApp.jsx")"
else
    echo "❌ ExistingApp.jsx missing!"
fi

# Check LoginView
if [ -f "$FRONTEND_DIR/components/Views/LoginView.jsx" ]; then
    echo "✅ LoginView.jsx exists"
    echo "   Last modified: $(stat -c %y "$FRONTEND_DIR/components/Views/LoginView.jsx")"
else
    echo "❌ LoginView.jsx missing!"
fi

# Check for syntax errors in JavaScript files
echo ""
echo "🔍 Checking for syntax errors..."

if command -v node >/dev/null 2>&1; then
    find "$FRONTEND_DIR" -name "*.jsx" -o -name "*.js" | head -10 | while read file; do
        echo "Checking: $file"
        if node -c "$file" 2>/dev/null; then
            echo "  ✅ Syntax OK"
        else
            echo "  ❌ Syntax Error!"
            node -c "$file"
        fi
    done
else
    echo "⚠️ Node.js not available for syntax checking"
fi

echo ""
echo "📊 File check complete"
