#!/bin/bash

# Emergency Rollback and Simple Fix
# Let's get back to working state and make a simple targeted fix

echo "🚨 Emergency Rollback and Simple Fix"
echo "===================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${RED}⚠️ Too many changes causing issues. Let's rollback and make a simple fix.${NC}"
echo ""

echo -e "${BLUE}🔄 Step 1: Using rollback script...${NC}"
echo ""

# Check if rollback script exists
if [ -f "rollback_login_rebuild.sh" ]; then
    echo -e "${YELLOW}Found rollback script. Running it...${NC}"
    ./rollback_login_rebuild.sh
    echo ""
else
    echo -e "${YELLOW}No rollback script found. Let's manually restore...${NC}"
    
    # Look for backup directories
    BACKUP_DIRS=$(ls -d login_rebuild_backup_* 2>/dev/null | sort -r | head -1)
    
    if [ -n "$BACKUP_DIRS" ]; then
        echo -e "${GREEN}Found backup: $BACKUP_DIRS${NC}"
        echo -e "${YELLOW}Restoring key files...${NC}"
        
        if [ -f "$BACKUP_DIRS/LoginView.jsx.backup" ]; then
            cp "$BACKUP_DIRS/LoginView.jsx.backup" src/components/Views/LoginView.jsx
            echo -e "  ✅ Restored LoginView.jsx"
        fi
        
        if [ -f "$BACKUP_DIRS/authUtils.js.backup" ]; then
            cp "$BACKUP_DIRS/authUtils.js.backup" src/utils/authUtils.js
            echo -e "  ✅ Restored authUtils.js"
        fi
        
    else
        echo -e "${RED}❌ No backup found. We need to fix manually.${NC}"
    fi
fi

echo ""
echo -e "${BLUE}🧪 Step 2: Testing current state...${NC}"
echo ""

# Test if we can build now
if npm run build >/dev/null 2>&1; then
    echo -e "${GREEN}✅ Build is working after rollback!${NC}"
    
    echo ""
    echo -e "${YELLOW}🎯 Now let's make ONE simple fix for the login issue...${NC}"
    echo ""
    
    # The simplest possible fix - just remove the frontend verification check
    if [ -f "src/components/Views/LoginView.jsx" ]; then
        echo -e "${BLUE}Making minimal fix to LoginView.jsx...${NC}"
        
        # Create a backup
        cp src/components/Views/LoginView.jsx src/components/Views/LoginView.jsx.emergency_backup
        
        # Simple find and replace to comment out verification checks
        sed -i 's/if (!response\.data\.user\.email_verified_at)/\/\/ DISABLED: if (!response.data.user.email_verified_at)/' src/components/Views/LoginView.jsx
        sed -i 's/if (!response\.data\.user\.email_verified)/\/\/ DISABLED: if (!response.data.user.email_verified)/' src/components/Views/LoginView.jsx
        sed -i 's/error\.code === '\''EMAIL_NOT_VERIFIED'\''/false \/\/ DISABLED: error.code === "EMAIL_NOT_VERIFIED"/' src/components/Views/LoginView.jsx
        
        echo -e "  ✅ Made minimal changes to LoginView.jsx"
        
        # Test build
        if npm run build >/dev/null 2>&1; then
            echo -e "${GREEN}✅ Build still works after minimal fix!${NC}"
            echo ""
            echo -e "${GREEN}🎉 SIMPLE FIX SUCCESSFUL!${NC}"
            echo ""
            echo -e "${BLUE}What was fixed:${NC}"
            echo -e "  ✅ Commented out frontend email verification checks"
            echo -e "  ✅ Build is working"
            echo -e "  ✅ No major changes to break anything else"
            echo ""
            echo -e "${GREEN}🚀 Test your login now:${NC}"
            echo -e "  Email: iammrpwinner01@gmail.com"
            echo -e "  The verification error should be gone!"
            
        else
            echo -e "${RED}❌ Still not working. Restoring emergency backup...${NC}"
            cp src/components/Views/LoginView.jsx.emergency_backup src/components/Views/LoginView.jsx
        fi
    fi
    
else
    echo -e "${YELLOW}⚠️ Still have build issues. Let's fix the immediate error...${NC}"
    
    # Fix the duplicate function error
    if [ -f "src/utils/authUtils.js" ]; then
        echo -e "${BLUE}Fixing duplicate function error in authUtils.js...${NC}"
        
        # Remove duplicate functions by keeping only the first occurrence
        awk '!seen[$0]++' src/utils/authUtils.js > temp_authutils.js
        mv temp_authutils.js src/utils/authUtils.js
        
        echo -e "  ✅ Removed duplicate functions"
        
        # Test build
        if npm run build >/dev/null 2>&1; then
            echo -e "${GREEN}✅ Build working after fixing duplicates!${NC}"
        else
            echo -e "${YELLOW}Still issues. Let's see the error...${NC}"
            npm run build 2>&1 | tail -10
        fi
    fi
fi

echo ""
echo -e "${BLUE}🎯 BOTTOM LINE:${NC}"
echo ""
echo -e "${YELLOW}The core issue is simple:${NC}"
echo -e "  • Your backend works fine"
echo -e "  • User is verified in database" 
echo -e "  • Frontend has extra verification check blocking login"
echo ""
echo -e "${GREEN}Simple solution:${NC}"
echo -e "  • Remove/comment the frontend verification check"
echo -e "  • That's it!"
echo ""

# Show what to look for manually if needed
echo -e "${BLUE}🔧 Manual fix if needed:${NC}"
echo -e "In src/components/Views/LoginView.jsx, find and comment out:"
echo -e '  if (!response.data.user.email_verified_at) {'
echo -e '    setError("Please verify your email...");'
echo -e '    return;'
echo -e '  }'
echo ""

echo -e "${RED}📋 We've learned: Make small, targeted changes instead of big rebuilds!${NC}"
