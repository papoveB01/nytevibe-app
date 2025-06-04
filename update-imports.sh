#!/bin/bash

# Helper script to add necessary imports to existing files
# Run this after the main setup to ensure all imports are correct

echo "🔄 Updating imports in existing files..."

# Update App.jsx if it exists
if [ -f "src/App.jsx" ]; then
    echo "📝 Updating App.jsx imports..."
    if ! grep -q "password-reset.css" "src/App.jsx"; then
        sed -i '1i import "./styles/password-reset.css";' "src/App.jsx"
        echo "✅ Added password-reset.css import to App.jsx"
    fi
fi

# Update main.jsx if it exists
if [ -f "src/main.jsx" ]; then
    echo "📝 Checking main.jsx..."
    if ! grep -q "password-reset.css" "src/main.jsx"; then
        sed -i '1i import "./styles/password-reset.css";' "src/main.jsx"
        echo "✅ Added password-reset.css import to main.jsx"
    fi
fi

echo "✅ Import updates complete!"
