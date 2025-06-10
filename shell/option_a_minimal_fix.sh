#!/bin/bash
echo "🔧 OPTION A: Minimal Fix"
echo "Making the smallest possible change to fix login..."

# Find and fix the verification check
if [ -f "src/components/Views/LoginView.jsx" ]; then
    # Backup first
    cp src/components/Views/LoginView.jsx src/components/Views/LoginView.jsx.step_backup
    
    # Simple comment out the problematic line
    sed -i 's/if (!response\.data\.user\.email_verified/\/\/ DISABLED: if (!response.data.user.email_verified/' src/components/Views/LoginView.jsx
    
    echo "✅ Made minimal change"
    echo "🧪 Testing build..."
    
    if npm run build >/dev/null 2>&1; then
        echo "✅ Build still works!"
        echo "🚀 Test your login now!"
    else
        echo "❌ Build broken. Restoring..."
        cp src/components/Views/LoginView.jsx.step_backup src/components/Views/LoginView.jsx
    fi
fi
