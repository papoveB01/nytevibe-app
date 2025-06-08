#!/bin/bash

# Surgical Fix - Even More Careful
# Let's see what broke and make the tiniest possible change

echo "🔬 Surgical Fix - Even More Careful"
echo "==================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${YELLOW}The minimal fix broke the build. Let's investigate...${NC}"
echo ""

echo -e "${BLUE}🔍 Step 1: What's the current build error?${NC}"
echo ""

BUILD_ERROR=$(npm run build 2>&1)
echo -e "${RED}Current build error:${NC}"
echo "$BUILD_ERROR" | tail -10

echo ""
echo -e "${BLUE}🔍 Step 2: Let's look at the problematic code more carefully${NC}"
echo ""

if [ -f "src/components/Views/LoginView.jsx" ]; then
    echo -e "${YELLOW}Lines around the verification check:${NC}"
    grep -n -A 5 -B 5 "email_verified" src/components/Views/LoginView.jsx
    
    echo ""
    echo -e "${YELLOW}Lines around EMAIL_NOT_VERIFIED:${NC}"
    grep -n -A 5 -B 5 "EMAIL_NOT_VERIFIED" src/components/Views/LoginView.jsx
fi

echo ""
echo -e "${BLUE}🔬 Step 3: Manual edit approach${NC}"
echo ""

echo -e "${YELLOW}Instead of automated changes, let's manually edit the file.${NC}"
echo -e "${GREEN}Here's exactly what to change:${NC}"
echo ""

# Find the exact line numbers
if [ -f "src/components/Views/LoginView.jsx" ]; then
    VERIFICATION_LINE=$(grep -n "if (!response\.data\.user\.email_verified" src/components/Views/LoginView.jsx | cut -d: -f1)
    ERROR_HANDLING_LINE=$(grep -n "EMAIL_NOT_VERIFIED" src/components/Views/LoginView.jsx | cut -d: -f1)
    
    echo -e "${BLUE}📄 LoginView.jsx changes needed:${NC}"
    echo ""
    
    if [ -n "$VERIFICATION_LINE" ]; then
        echo -e "${RED}Problem 1 - Line $VERIFICATION_LINE:${NC}"
        sed -n "${VERIFICATION_LINE},$((VERIFICATION_LINE+3))p" src/components/Views/LoginView.jsx
        echo ""
        echo -e "${GREEN}Change to:${NC}"
        echo "        // DISABLED: Frontend email verification check"
        echo "        /*"
        echo "        if (!response.data.user.email_verified_at) {"
        echo "          setError('Please verify your email before signing in. Check your inbox for the verification link.');"
        echo "          setIsLoading(false);"
        echo "          return;"
        echo "        }"
        echo "        */"
    fi
    
    echo ""
    
    if [ -n "$ERROR_HANDLING_LINE" ]; then
        echo -e "${RED}Problem 2 - Line $ERROR_HANDLING_LINE:${NC}"
        sed -n "${ERROR_HANDLING_LINE},$((ERROR_HANDLING_LINE+2))p" src/components/Views/LoginView.jsx
        echo ""
        echo -e "${GREEN}Change to:${NC}"
        echo "        } else if (false) { // DISABLED: EMAIL_NOT_VERIFIED check"
        echo "          setError('Please verify your email before signing in. Check your inbox for the verification link.');"
    fi
fi

echo ""
echo -e "${BLUE}🔧 Step 4: Create super-safe manual edit script${NC}"
echo ""

# Create a script that makes the most minimal possible change
cat > "super_safe_fix.sh" << 'EOF'
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
EOF

chmod +x super_safe_fix.sh

echo ""
echo -e "${GREEN}💡 Next options:${NC}"
echo ""
echo -e "${YELLOW}Option 1 - Try the super safe automated fix:${NC}"
echo -e "  ./super_safe_fix.sh"
echo ""
echo -e "${YELLOW}Option 2 - Manual edit (safest):${NC}"
echo -e "  1. Open: nano src/components/Views/LoginView.jsx"
echo -e "  2. Find the lines shown above"
echo -e "  3. Comment them out as shown"
echo -e "  4. Save and test: npm run build"
echo ""
echo -e "${YELLOW}Option 3 - Show me the exact file content first:${NC}"
echo -e "  cat src/components/Views/LoginView.jsx | head -100"
echo ""

echo -e "${BLUE}Which approach do you want to try?${NC}"
