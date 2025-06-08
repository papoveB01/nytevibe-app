#!/bin/bash
echo "🔍 Option B: Complete System Check"
echo "Checking all password reset components..."

echo "1. Checking authAPI.js functions..."
if [ -f "src/services/authAPI.js" ]; then
    echo "Functions related to password reset:"
    grep -n "export.*function\|export.*=" src/services/authAPI.js | grep -i "password\|reset\|forgot"
else
    echo "❌ authAPI.js not found"
fi

echo ""
echo "2. Checking authUtils.js functions..."
if [ -f "src/utils/authUtils.js" ]; then
    echo "Utility functions for password reset:"
    grep -n "export.*=" src/utils/authUtils.js | grep -i "password\|reset\|forgot\|validate"
else
    echo "❌ authUtils.js not found"
fi

echo ""
echo "3. Checking component imports..."
if [ -f "src/components/Views/ForgotPasswordView.jsx" ]; then
    echo "ForgotPasswordView imports:"
    grep "import.*{" src/components/Views/ForgotPasswordView.jsx
else
    echo "❌ ForgotPasswordView.jsx not found"
fi
