#!/bin/bash

# Frontend Login Issue Debugger
# Check if the issue is in the frontend

echo "🔍 Frontend Login Issue Debugger"
echo "================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

echo -e "${BLUE}📍 From your debug output, we know:${NC}"
echo -e "  ✅ User IS verified in database: email_verified_at: 2025-06-08 00:50:03"
echo -e "  ✅ hasVerifiedEmail() returns: true"
echo -e "  🛣️ API login route: POST api/auth/login → API\\AuthController@login"
echo -e "  🔧 We fixed: AuthController@login (wrong one!)"
echo ""

echo -e "${RED}🚨 CRITICAL REALIZATION:${NC}"
echo -e "  Your frontend is calling: ${YELLOW}API\\AuthController@login${NC}"
echo -e "  But we fixed: ${YELLOW}AuthController@login${NC}"
echo -e "  We may have fixed the WRONG controller!"
echo ""

# Check what the API controller actually contains
echo -e "${PURPLE}🔍 Step 1: Let's check what's in API\\AuthController@login...${NC}"
echo ""

if [ -f "/var/www/nytevibe-api/app/Http/Controllers/API/AuthController.php" ]; then
    echo -e "${BLUE}Checking API\\AuthController for verification logic:${NC}"
    if grep -n "verify.*email\|email.*verify\|Please.*email" /var/www/nytevibe-api/app/Http/Controllers/API/AuthController.php >/dev/null 2>&1; then
        echo -e "${RED}🚨 FOUND verification logic in API\\AuthController:${NC}"
        grep -n -A 3 -B 3 "verify.*email\|email.*verify\|Please.*email" /var/www/nytevibe-api/app/Http/Controllers/API/AuthController.php
    else
        echo -e "${GREEN}✅ No verification logic found in API\\AuthController${NC}"
        echo -e "${YELLOW}This means the issue might be in the frontend!${NC}"
    fi
else
    echo -e "${RED}❌ API\\AuthController not found${NC}"
fi

echo ""

# Check frontend login API calls
echo -e "${PURPLE}🔍 Step 2: Let's check frontend login logic...${NC}"
echo ""

# Look for frontend directory
FRONTEND_DIRS=("/var/www/nytevibe-app" "/var/www/blackaxl.com" "../nytevibe-app" "../blackaxl.com" ".")

for dir in "${FRONTEND_DIRS[@]}"; do
    if [ -d "$dir/src" ]; then
        echo -e "${GREEN}📁 Found frontend directory: $dir${NC}"
        
        echo -e "${BLUE}Looking for login API calls:${NC}"
        find "$dir" -name "*.js" -o -name "*.jsx" -o -name "*.ts" -o -name "*.tsx" | xargs grep -l "api.*login\|login.*api\|auth.*login\|/login" 2>/dev/null | head -5
        
        echo ""
        echo -e "${BLUE}Looking for 'Please verify your email' in frontend:${NC}"
        find "$dir" -name "*.js" -o -name "*.jsx" -o -name "*.ts" -o -name "*.tsx" | xargs grep -l "Please.*verify.*email\|verify.*email.*before\|check.*email.*before" 2>/dev/null
        
        echo ""
        break
    fi
done

# Create API test script
echo -e "${PURPLE}🔍 Step 3: Let's test the API directly...${NC}"
echo ""

cat > "test_api_login.sh" << 'EOF'
#!/bin/bash

echo "🧪 Testing API Login Directly"
echo "============================"
echo ""

read -p "Enter test email: " TEST_EMAIL
read -p "Enter test password: " TEST_PASSWORD

echo ""
echo -e "\033[0;34mTesting API login...\033[0m"

# Test the API directly
RESPONSE=$(curl -s -X POST "https://system.nytevibe.com/api/auth/login" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d "{
    \"email\": \"$TEST_EMAIL\",
    \"password\": \"$TEST_PASSWORD\"
  }")

echo "API Response:"
echo "$RESPONSE" | jq . 2>/dev/null || echo "$RESPONSE"

echo ""
echo "If this shows 'Please verify your email', the issue is in the backend API."
echo "If this shows successful login, the issue is in the frontend."
EOF

chmod +x test_api_login.sh

# Create frontend URL checker
cat > "check_frontend_api_calls.sh" << 'EOF'
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
EOF

chmod +x check_frontend_api_calls.sh

echo -e "${GREEN}📋 Created debugging tools:${NC}"
echo -e "  🧪 ${YELLOW}test_api_login.sh${NC} - Test backend API directly"
echo -e "  🔍 ${YELLOW}check_frontend_api_calls.sh${NC} - Check frontend API calls"
echo ""

echo -e "${RED}🎯 NEXT STEPS:${NC}"
echo ""
echo -e "${YELLOW}1. Test the backend API directly:${NC}"
echo -e "   ${BLUE}./test_api_login.sh${NC}"
echo -e "   This will tell us if the backend is actually working"
echo ""
echo -e "${YELLOW}2. Check frontend API calls:${NC}"
echo -e "   ${BLUE}./check_frontend_api_calls.sh${NC}"
echo -e "   This will show what URL your frontend is calling"
echo ""
echo -e "${YELLOW}3. Check browser network tab:${NC}"
echo -e "   - Open browser dev tools"
echo -e "   - Go to Network tab"
echo -e "   - Try to login"
echo -e "   - Check what API URL is called and what response is returned"
echo ""

echo -e "${BLUE}💡 THEORY:${NC}"
echo "Your frontend might be:"
echo "  - Calling the wrong API endpoint"
echo "  - Caching old error responses"
echo "  - Having its own hardcoded verification check"
echo "  - Not sending the request to the right backend"
echo ""

echo -e "${GREEN}🚀 Let's test the API directly first!${NC}"
echo -e "Run: ${BLUE}./test_api_login.sh${NC}"
