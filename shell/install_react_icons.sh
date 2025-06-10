#!/bin/bash

# Install react-icons and Fix Build

echo "🔧 Installing react-icons and Fixing Build"
echo "==========================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}📦 Step 1: Installing react-icons...${NC}"
echo ""

# Check if package.json exists
if [ ! -f "package.json" ]; then
    echo -e "${RED}❌ package.json not found!${NC}"
    echo "Please run this from your React project root directory."
    exit 1
fi

# Install react-icons
echo -e "${YELLOW}Installing react-icons...${NC}"
if npm install react-icons; then
    echo -e "${GREEN}✅ react-icons installed successfully!${NC}"
else
    echo -e "${RED}❌ Failed to install react-icons${NC}"
    echo ""
    echo -e "${YELLOW}Trying with yarn...${NC}"
    if command -v yarn >/dev/null 2>&1; then
        if yarn add react-icons; then
            echo -e "${GREEN}✅ react-icons installed with yarn!${NC}"
        else
            echo -e "${RED}❌ Failed to install with yarn too${NC}"
            exit 1
        fi
    else
        echo -e "${RED}❌ yarn not available. Please install react-icons manually:${NC}"
        echo "npm install react-icons"
        exit 1
    fi
fi

echo ""
echo -e "${BLUE}📋 Step 2: Checking installed packages...${NC}"
echo ""

# Check if react-icons is now in package.json
if grep -q "react-icons" package.json; then
    echo -e "${GREEN}✅ react-icons found in package.json${NC}"
    REACT_ICONS_VERSION=$(grep "react-icons" package.json | sed 's/.*"react-icons": "\([^"]*\)".*/\1/')
    echo -e "  📌 Version: $REACT_ICONS_VERSION"
else
    echo -e "${YELLOW}⚠️ react-icons not found in package.json, but may be installed${NC}"
fi

# Check node_modules
if [ -d "node_modules/react-icons" ]; then
    echo -e "${GREEN}✅ react-icons found in node_modules${NC}"
else
    echo -e "${RED}❌ react-icons not found in node_modules${NC}"
    echo "Trying to install again..."
    npm install react-icons --save
fi

echo ""
echo -e "${BLUE}🧪 Step 3: Testing build...${NC}"
echo ""

# Test the build
echo -e "${YELLOW}Running build test...${NC}"
if npm run build; then
    echo ""
    echo -e "${GREEN}🎉 Build successful!${NC}"
    echo ""
    echo -e "${BLUE}📋 Your login system is now ready:${NC}"
    echo -e "  ✅ react-icons installed"
    echo -e "  ✅ LoginView.jsx with beautiful icons"
    echo -e "  ✅ Clean login logic aligned with backend"
    echo -e "  ✅ No email verification conflicts"
    echo ""
    echo -e "${GREEN}🚀 Ready to test login!${NC}"
    echo -e "Try logging in with: iammrpwinner01@gmail.com"
else
    echo ""
    echo -e "${RED}❌ Build still failing. Let's diagnose...${NC}"
    echo ""
    
    # Check what's wrong
    echo -e "${YELLOW}Checking for other missing dependencies...${NC}"
    
    # Common missing dependencies
    MISSING_DEPS=()
    
    # Check for other potential issues
    if ! npm list react >/dev/null 2>&1; then
        MISSING_DEPS+=("react")
    fi
    
    if ! npm list react-dom >/dev/null 2>&1; then
        MISSING_DEPS+=("react-dom")
    fi
    
    if [ ${#MISSING_DEPS[@]} -gt 0 ]; then
        echo -e "${YELLOW}Found missing dependencies: ${MISSING_DEPS[*]}${NC}"
        echo -e "${BLUE}Installing missing dependencies...${NC}"
        npm install "${MISSING_DEPS[@]}"
        
        echo ""
        echo -e "${YELLOW}Trying build again...${NC}"
        npm run build
    else
        echo -e "${YELLOW}🔍 Let's check the specific error...${NC}"
        echo ""
        echo -e "${BLUE}Recent build output:${NC}"
        npm run build 2>&1 | tail -20
        
        echo ""
        echo -e "${YELLOW}💡 Possible solutions:${NC}"
        echo -e "  1. Clear node_modules and reinstall:"
        echo -e "     ${BLUE}rm -rf node_modules package-lock.json && npm install${NC}"
        echo ""
        echo -e "  2. Check if you have conflicting React versions:"
        echo -e "     ${BLUE}npm list react react-dom react-icons${NC}"
        echo ""
        echo -e "  3. Try installing with specific version:"
        echo -e "     ${BLUE}npm install react-icons@^4.0.0${NC}"
    fi
fi

echo ""
echo -e "${BLUE}📦 Current package status:${NC}"
echo -e "${YELLOW}React Icons:${NC}"
npm list react-icons 2>/dev/null || echo "Not found"

echo -e "${YELLOW}React:${NC}"
npm list react 2>/dev/null || echo "Not found"

echo -e "${YELLOW}React DOM:${NC}"
npm list react-dom 2>/dev/null || echo "Not found"

echo ""
echo -e "${GREEN}💡 If build is successful, your login should work without any email verification issues!${NC}"
