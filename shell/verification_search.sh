#!/bin/bash

echo "🔍 COMPREHENSIVE EMAIL VERIFICATION SEARCH"
echo "========================================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}1. SEARCHING FOR THE EXACT ERROR MESSAGE${NC}"
echo "=============================================="
grep -r "Legacy verification format no longer supported" src/ 2>/dev/null || echo "Not found in src/"
grep -r "Legacy verification format no longer supported" . --exclude-dir=node_modules --exclude-dir=.git 2>/dev/null | head -10

echo ""
echo -e "${BLUE}2. SEARCHING FOR EMAIL VERIFICATION COMPONENTS${NC}"
echo "==============================================="
find src/ -name "*erif*" -o -name "*mail*" -o -name "*token*" 2>/dev/null
find src/ -name "*Verification*" -o -name "*Email*" 2>/dev/null

echo ""
echo -e "${BLUE}3. SEARCHING FOR FILES THAT IMPORT EmailVerificationView${NC}"
echo "========================================================"
grep -r "EmailVerificationView" src/ --include="*.js" --include="*.jsx" --include="*.ts" --include="*.tsx" 2>/dev/null

echo ""
echo -e "${BLUE}4. SEARCHING FOR ROUTING FILES AND VERIFICATION HANDLERS${NC}"
echo "========================================================"
grep -r "verify" src/ --include="*.js" --include="*.jsx" | grep -v ".backup" | head -20

echo ""
echo -e "${BLUE}5. SEARCHING FOR URL PARAMETER PARSING${NC}"
echo "======================================="
grep -r "URLSearchParams\|searchParams\|getParam\|query" src/ --include="*.js" --include="*.jsx" | head -15

echo ""
echo -e "${BLUE}6. CHECKING ExistingApp.jsx FOR VERIFICATION LOGIC${NC}"
echo "=================================================="
if [ -f "src/ExistingApp.jsx" ]; then
    echo "Found ExistingApp.jsx - checking verification logic:"
    grep -n -A 5 -B 5 "verify\|token\|email.*verification" src/ExistingApp.jsx
else
    echo "ExistingApp.jsx not found"
fi

echo ""
echo -e "${BLUE}7. SEARCHING FOR APP ROUTER AND ROUTING CONFIGURATION${NC}"
echo "====================================================="
find src/ -name "*Router*" -o -name "*Route*" -o -name "*router*" -o -name "*route*" 2>/dev/null
grep -r "Route\|Router" src/ --include="*.js" --include="*.jsx" | grep -v ".backup" | head -10

echo ""
echo -e "${BLUE}8. CHECKING FOR REDIRECT OR NAVIGATION LOGIC${NC}"
echo "============================================="
grep -r "redirect\|navigate\|window.location" src/ --include="*.js" --include="*.jsx" | grep -v ".backup" | head -15

echo ""
echo -e "${BLUE}9. SEARCHING FOR VERIFICATION API USAGE${NC}"
echo "========================================"
grep -r "verifyEmail\|emailVerificationAPI\|EmailVerificationAPI" src/ --include="*.js" --include="*.jsx" | head -15

echo ""
echo -e "${BLUE}10. CHECKING FOR CONTEXT OR STATE MANAGEMENT${NC}"
echo "============================================"
grep -r "verification.*context\|email.*context\|useApp" src/ --include="*.js" --include="*.jsx" | head -10

echo ""
echo -e "${BLUE}11. SEARCHING FOR CONFIGURATION FILES${NC}"
echo "====================================="
find src/ -name "*.config.*" -o -name "config.*" 2>/dev/null
grep -r "frontend_url\|FRONTEND_URL\|blackaxl" src/ 2>/dev/null | head -5

echo ""
echo -e "${BLUE}12. CHECKING FOR DUPLICATE EmailVerificationView FILES${NC}"
echo "===================================================="
find . -name "*EmailVerificationView*" -type f 2>/dev/null

echo ""
echo -e "${BLUE}13. CHECKING BUILD/COMPILED FILES${NC}"
echo "================================="
find . -name "dist" -o -name "build" -o -name ".next" 2>/dev/null | head -5
ls -la dist/ 2>/dev/null | head -5 || echo "No dist/ directory"
ls -la build/ 2>/dev/null | head -5 || echo "No build/ directory"

echo ""
echo -e "${BLUE}14. CHECKING FOR ENVIRONMENT/CONFIG OVERRIDES${NC}"
echo "=============================================="
ls -la .env* 2>/dev/null || echo "No .env files found"
find . -name "*.env*" 2>/dev/null | head -5

echo ""
echo -e "${BLUE}15. CHECKING PACKAGE.JSON FOR BUILD SCRIPTS${NC}"
echo "==========================================="
if [ -f "package.json" ]; then
    echo "Build scripts:"
    grep -A 10 '"scripts"' package.json | head -15
else
    echo "No package.json found"
fi

echo ""
echo -e "${BLUE}16. SEARCHING FOR HOT RELOAD/DEV SERVER CONFIGURATION${NC}"
echo "==================================================="
grep -r "hot.*reload\|hmr\|dev.*server" . --include="*.json" --include="*.js" --include="*.config.*" 2>/dev/null | head -5

echo ""
echo -e "${BLUE}17. CHECKING FOR SERVICE WORKER OR CACHING${NC}"
echo "=========================================="
find . -name "*worker*" -o -name "*cache*" -o -name "sw.*" 2>/dev/null | head -5

echo ""
echo -e "${BLUE}18. FINAL FILE VERIFICATION${NC}"
echo "==========================="
echo "Current EmailVerificationView.jsx size and modification time:"
ls -la src/components/Auth/EmailVerificationView.jsx 2>/dev/null || echo "File not found!"

echo ""
echo "Last few lines of EmailVerificationView.jsx:"
tail -5 src/components/Auth/EmailVerificationView.jsx 2>/dev/null || echo "Cannot read file"

echo ""
echo "Checking if direct parameter extraction exists in the file:"
grep -n "directUserId\|directToken" src/components/Auth/EmailVerificationView.jsx 2>/dev/null || echo "❌ Direct parameter extraction NOT found in file!"

echo ""
echo -e "${GREEN}SEARCH COMPLETE!${NC}"
echo "================"
echo "Look for patterns above that might explain why the old verification logic is still running."
echo "Pay attention to:"
echo "  • Multiple EmailVerificationView files"
echo "  • Routing files that might intercept /verify URLs" 
echo "  • Build/cache directories that might serve old code"
echo "  • Files that import the old verification component"
