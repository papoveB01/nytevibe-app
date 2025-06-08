#!/bin/bash

echo "🔬 Super Safe Fix - Manual Approach"
echo "=================================="

# Backup first
cp src/components/Views/LoginView.jsx src/components/Views/LoginView.jsx.super_safe_backup

echo "✅ Created backup: LoginView.jsx.super_safe_backup"
echo ""

# Instead of sed, let's use a more precise approach
# Create a temporary file with the fix

echo "🔧 Making precise changes..."

# Use Python for more precise text replacement
python3 << 'PYTHON_EOF'
import re

# Read the file
with open('src/components/Views/LoginView.jsx', 'r') as f:
    content = f.read()

# Fix 1: Comment out the email verification check
# Look for the specific pattern and replace with comments
pattern1 = r'(\s+)if\s*\(\s*!response\.data\.user\.email_verified_at\s*\)\s*\{[\s\S]*?return;\s*\}'
replacement1 = r'\1// DISABLED: Frontend email verification check\n\1/*\n\1if (!response.data.user.email_verified_at) {\n\1  setError("Please verify your email before signing in. Check your inbox for the verification link.");\n\1  setIsLoading(false);\n\1  return;\n\1}\n\1*/'

content = re.sub(pattern1, replacement1, content)

# Fix 2: Change EMAIL_NOT_VERIFIED check to false
pattern2 = r'(\s*}\s*else\s+if\s*\(\s*error\.status\s*===\s*403\s*&&\s*error\.code\s*===\s*[\'"]EMAIL_NOT_VERIFIED[\'"]\s*\)\s*\{)'
replacement2 = r'\1'.replace('error.status === 403 && error.code === \'EMAIL_NOT_VERIFIED\'', 'false) { // DISABLED: EMAIL_NOT_VERIFIED check')

content = re.sub(pattern2, replacement2, content)

# Write the fixed content
with open('src/components/Views/LoginView.jsx', 'w') as f:
    f.write(content)

print("✅ Applied precise fixes")
PYTHON_EOF

echo ""
echo "🧪 Testing build..."

if npm run build >/dev/null 2>&1; then
    echo "✅ Build successful!"
    echo ""
    echo "🎉 SUPER SAFE FIX SUCCESSFUL!"
    echo ""
    echo "🚀 Test your login now!"
else
    echo "❌ Still failing. Restoring backup..."
    cp src/components/Views/LoginView.jsx.super_safe_backup src/components/Views/LoginView.jsx
    echo ""
    echo "Error:"
    npm run build 2>&1 | tail -5
fi
