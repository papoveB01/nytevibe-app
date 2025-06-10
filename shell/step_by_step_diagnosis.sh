#!/bin/bash

# Step-by-Step Login Issue Diagnosis
# Let's go slow and careful

echo "🔍 Step-by-Step Login Issue Diagnosis"
echo "====================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}We're going to take this step by step and NOT break anything.${NC}"
echo ""

echo -e "${YELLOW}📋 STEP 1: Check current build status${NC}"
echo "=====================================\n"

echo -e "${BLUE}Let's see if we can build right now:${NC}"
if npm run build >/dev/null 2>&1; then
    echo -e "${GREEN}✅ Current build: SUCCESS${NC}"
    echo "Good! We have a working base."
    BUILD_STATUS="WORKING"
else
    echo -e "${RED}❌ Current build: FAILED${NC}"
    echo "We need to fix build issues first."
    BUILD_STATUS="BROKEN"
    
    echo ""
    echo -e "${YELLOW}Build error:${NC}"
    npm run build 2>&1 | tail -5
fi

echo ""
echo -e "${YELLOW}📋 STEP 2: Understand what we know${NC}"
echo "===================================\n"

echo -e "${BLUE}From our previous debugging, we know:${NC}"
echo -e "  ✅ Backend API works (system.nytevibe.com)"
echo -e "  ✅ User is verified in database (email_verified_at: 2025-06-08 00:50:03)"
echo -e "  ✅ User passes hasVerifiedEmail() check"
echo -e "  🛣️ Frontend calls: POST /api/auth/login"
echo -e "  ❌ User still gets: 'Please verify your email before signing in'"
echo ""
echo -e "${PURPLE}🎯 Conclusion: The error is coming from FRONTEND logic${NC}"

echo ""
echo -e "${YELLOW}📋 STEP 3: Find the exact error location${NC}"
echo "========================================\n"

echo -e "${BLUE}Let's find where 'Please verify your email' comes from:${NC}"
echo ""

# Search for the error message in frontend files
echo -e "${YELLOW}Searching frontend files for the error message...${NC}"
FOUND_FILES=()

if find src -name "*.js" -o -name "*.jsx" | xargs grep -l "Please verify your email" 2>/dev/null; then
    echo ""
    echo -e "${RED}🎯 Found files containing the error message!${NC}"
    
    find src -name "*.js" -o -name "*.jsx" | xargs grep -l "Please verify your email" 2>/dev/null | while read file; do
        echo ""
        echo -e "${BLUE}📄 File: $file${NC}"
        echo -e "${YELLOW}Context:${NC}"
        grep -n -B 2 -A 2 "Please verify your email" "$file"
    done
else
    echo -e "${YELLOW}No files found with that exact message.${NC}"
    echo -e "${BLUE}Let's search for variations...${NC}"
    
    find src -name "*.js" -o -name "*.jsx" | xargs grep -l "verify.*email\|email.*verify" 2>/dev/null | head -3 | while read file; do
        echo ""
        echo -e "${BLUE}📄 File: $file${NC}"
        grep -n -B 1 -A 1 "verify.*email\|email.*verify" "$file" | head -10
    done
fi

echo ""
echo -e "${YELLOW}📋 STEP 4: Pause and get your input${NC}"
echo "===================================\n"

echo -e "${GREEN}Before we make ANY changes, let's confirm what we found:${NC}"
echo ""
echo -e "${BLUE}Current status:${NC}"
echo -e "  📊 Build status: $BUILD_STATUS"
echo -e "  🎯 Error source: Frontend verification logic"
echo -e "  🔍 Files to check: Listed above"
echo ""

echo -e "${YELLOW}🤔 NEXT STEPS (waiting for your approval):${NC}"
echo ""
echo -e "A) If build is WORKING:"
echo -e "   → Make minimal change to remove frontend verification check"
echo -e "   → Test immediately"
echo ""
echo -e "B) If build is BROKEN:"
echo -e "   → Fix build error first"
echo -e "   → Then do option A"
echo ""

echo -e "${GREEN}💬 What do you want to do?${NC}"
echo ""
echo -e "Reply with:"
echo -e "  'A' - Proceed with minimal fix (if build works)"
echo -e "  'B' - Fix build issues first" 
echo -e "  'SHOW' - Show me the specific file content first"
echo -e "  'STOP' - Let me review what we found"
echo ""

# Create follow-up scripts for each option
cat > "option_a_minimal_fix.sh" << 'EOF'
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
EOF

cat > "option_b_fix_build.sh" << 'EOF'
#!/bin/bash
echo "🔧 OPTION B: Fix Build Issues"
echo "Let's fix the build error first..."

echo "Current build error:"
npm run build 2>&1 | tail -10
EOF

cat > "show_file_content.sh" << 'EOF'
#!/bin/bash
echo "📄 SHOW: File Content"
echo "Showing the files that contain verification logic..."

find src -name "*.jsx" | xargs grep -l "Please verify your email\|email.*verify" | head -2 | while read file; do
    echo ""
    echo "=== $file ==="
    cat "$file"
    echo ""
done
EOF

chmod +x option_a_minimal_fix.sh
chmod +x option_b_fix_build.sh  
chmod +x show_file_content.sh

echo -e "${BLUE}📁 Ready for your choice:${NC}"
echo -e "  ./option_a_minimal_fix.sh"
echo -e "  ./option_b_fix_build.sh"
echo -e "  ./show_file_content.sh"
