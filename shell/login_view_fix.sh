#!/bin/bash

# Fix LoginView.jsx Syntax Error

echo "🔧 Fixing LoginView.jsx Syntax Error"
echo "===================================="
echo ""

# First, let's restore from the backup and fix it properly
echo "📦 Restoring from backup..."

# Find the most recent backup
BACKUP_FILE=$(ls -t src/components/Views/LoginView.jsx.backup.* | head -1)

if [ -n "$BACKUP_FILE" ]; then
    echo "✅ Found backup: $BACKUP_FILE"
    cp "$BACKUP_FILE" src/components/Views/LoginView.jsx
    echo "✅ Restored from backup"
else
    echo "❌ No backup found"
    exit 1
fi

echo ""
echo "🔍 Let's check the current structure around the problematic area..."

# Show the area around line 91
echo "📄 Lines 85-95 before fix:"
sed -n '85,95p' src/components/Views/LoginView.jsx

echo ""
echo "🔧 Now applying the fix more carefully..."

# Create a temporary file with the corrected code
cat > fix_login_verification.js << 'EOF'
// This script will carefully remove only the email verification logic

const fs = require('fs');

// Read the file
let content = fs.readFileSync('src/components/Views/LoginView.jsx', 'utf8');

// Fix 1: Comment out the email verification check after successful login
// Look for the pattern and replace it carefully
content = content.replace(
  /(\s+)if\s*\(\s*!response\.data\.user\.email_verified_at\s*\)\s*\{[^}]*setError\([^)]*'Please verify your email[^}]*\}/gm,
  '$1// DISABLED: Frontend email verification check - using custom verification system\n$1// if (!response.data.user.email_verified_at) {\n$1//   setError("Please verify your email before signing in. Check your inbox for the verification link.");\n$1//   setIsLoading(false);\n$1//   return;\n$1// }'
);

// Fix 2: Comment out EMAIL_NOT_VERIFIED error handling
content = content.replace(
  /(\s+)}\s*else\s+if\s*\(\s*error\.status\s*===\s*403\s*&&\s*error\.code\s*===\s*'EMAIL_NOT_VERIFIED'\s*\)\s*\{([^}]+)\}/gm,
  '$1} else if (false) { // DISABLED: EMAIL_NOT_VERIFIED check$2}'
);

// Write the fixed content
fs.writeFileSync('src/components/Views/LoginView.jsx', content);

console.log('✅ LoginView.jsx has been fixed!');
EOF

# Run the fix if Node.js is available
if command -v node >/dev/null 2>&1; then
    echo "🚀 Running JavaScript-based fix..."
    node fix_login_verification.js
    rm fix_login_verification.js
else
    echo "⚠️ Node.js not available, doing manual fix..."
    
    # Manual fix approach - more careful sed commands
    
    # First, let's find and comment out the email verification check
    echo "📝 Manually commenting out email verification check..."
    
    # Create a Python script for more precise replacement
    cat > fix_login.py << 'PYTHONEOF'
import re

# Read the file
with open('src/components/Views/LoginView.jsx', 'r') as f:
    content = f.read()

# Fix 1: Comment out email verification check after login success
# Look for the if (!response.data.user.email_verified_at) block
email_check_pattern = r'(\s+)if\s*\(\s*!response\.data\.user\.email_verified_at\s*\)\s*\{[\s\S]*?return;\s*\}'
replacement1 = r'\1// DISABLED: Frontend email verification check - using custom verification system\n\1// if (!response.data.user.email_verified_at) {\n\1//   setError("Please verify your email before signing in. Check your inbox for the verification link.");\n\1//   setIsLoading(false);\n\1//   return;\n\1// }'

content = re.sub(email_check_pattern, replacement1, content)

# Fix 2: Comment out EMAIL_NOT_VERIFIED error handling
error_handling_pattern = r'(\s*)} else if \(error\.status === 403 && error\.code === \'EMAIL_NOT_VERIFIED\'\) \{([\s\S]*?)\}'
replacement2 = r'\1} else if (false) { // DISABLED: EMAIL_NOT_VERIFIED check\2}'

content = re.sub(error_handling_pattern, replacement2, content)

# Write the fixed content
with open('src/components/Views/LoginView.jsx', 'w') as f:
    f.write(content)

print("✅ LoginView.jsx has been fixed!")
PYTHONEOF

    if command -v python3 >/dev/null 2>&1; then
        echo "🐍 Using Python to fix the file..."
        python3 fix_login.py
        rm fix_login.py
    else
        echo "⚠️ Neither Node.js nor Python available. Manual edit needed."
        echo ""
        echo "🔧 MANUAL FIX NEEDED:"
        echo "Edit src/components/Views/LoginView.jsx and:"
        echo ""
        echo "1. Find this block and comment it out:"
        echo "   if (!response.data.user.email_verified_at) {"
        echo "     setError('Please verify your email before signing in...');"
        echo "     setIsLoading(false);"
        echo "     return;"
        echo "   }"
        echo ""
        echo "2. Find this block and comment it out:"
        echo "   } else if (error.status === 403 && error.code === 'EMAIL_NOT_VERIFIED') {"
        echo "     setError('Please verify your email before signing in...');"
        echo "   }"
        echo ""
        exit 1
    fi
fi

echo ""
echo "🔍 Checking syntax..."

# Try to parse with node if available
if command -v node >/dev/null 2>&1; then
    if node -c src/components/Views/LoginView.jsx 2>/dev/null; then
        echo "✅ JavaScript syntax is valid!"
    else
        echo "❌ Syntax error still present"
        echo "🔍 Showing problematic area:"
        sed -n '85,95p' src/components/Views/LoginView.jsx
    fi
fi

echo ""
echo "🚀 Try building again:"
echo "   npm run build"
echo ""
echo "If you still get errors, we may need to manually edit the file."
