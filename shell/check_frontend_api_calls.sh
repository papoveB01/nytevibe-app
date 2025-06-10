#!/bin/bash

echo "🔍 Frontend API Call Checker"
echo "==========================="
echo ""

# Look for API base URL configuration
echo "Looking for API base URL in frontend..."

FRONTEND_DIRS=("/var/www/nytevibe-app" "/var/www/blackaxl.com" "../nytevibe-app" "../blackaxl.com")

for dir in "${FRONTEND_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        echo "Checking $dir for API configuration..."
        
        # Look for API base URL
        find "$dir" -name "*.js" -o -name "*.jsx" -o -name "*.ts" -o -name "*.tsx" -o -name "*.json" | xargs grep -l "system.nytevibe.com\|api.*base\|baseURL\|API_URL" 2>/dev/null | head -3
        
        # Look for login API calls
        echo ""
        echo "Login API calls found:"
        find "$dir" -name "*.js" -o -name "*.jsx" | xargs grep -n -A 3 -B 3 "login.*api\|api.*login\|auth.*login" 2>/dev/null | head -10
        
        break
    fi
done
