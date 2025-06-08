#!/bin/bash

# Option D: Show Current Password Reset Issues
# Displays specific problems found in password reset system

echo "📊 Option D: Show Current Password Reset Issues"
echo "=============================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

echo -e "${BLUE}🔍 Current directory: $(pwd)${NC}"
echo ""

# Verify we're in the right location
if [ ! -f "package.json" ]; then
    echo -e "${RED}❌ Error: package.json not found!${NC}"
    echo -e "${YELLOW}You should run this from your React frontend directory.${NC}"
    echo -e "${BLUE}Try: cd /var/www/nytevibe (or wherever your frontend is)${NC}"
    exit 1
fi

if [ ! -d "src" ]; then
    echo -e "${RED}❌ Error: src/ directory not found!${NC}"
    echo -e "${YELLOW}You should run this from your React project root.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Confirmed: React project directory${NC}"
echo ""

echo -e "${YELLOW}📋 STEP 1: Testing build for password reset errors...${NC}"
echo "=================================================="
echo ""

# Test build and capture errors
echo -e "${BLUE}🧪 Running build to detect issues...${NC}"
BUILD_OUTPUT=$(npm run build 2>&1)
BUILD_EXIT_CODE=$?

if [ $BUILD_EXIT_CODE -eq 0 ]; then
    echo -e "${GREEN}✅ Build: SUCCESSFUL${NC}"
    echo "No build errors found in password reset components."
else
    echo -e "${RED}❌ Build: FAILED${NC}"
    echo ""
    echo -e "${YELLOW}Build errors found:${NC}"
    echo "$BUILD_OUTPUT" | tail -20
    
    # Check if errors are related to password reset
    if echo "$BUILD_OUTPUT" | grep -qi "password\|reset\|forgot"; then
        echo ""
        echo -e "${RED}🚨 Password reset related errors found:${NC}"
        echo "$BUILD_OUTPUT" | grep -i -A 3 -B 3 "password\|reset\|forgot"
    fi
fi

echo ""
echo -e "${YELLOW}📋 STEP 2: Checking missing function imports...${NC}"
echo "=============================================="
echo ""

# Check ForgotPasswordView imports
if [ -f "src/components/Views/ForgotPasswordView.jsx" ]; then
    echo -e "${BLUE}📄 ForgotPasswordView.jsx imports:${NC}"
    
    echo -e "${YELLOW}Functions being imported:${NC}"
    grep -o "import[^}]*{[^}]*}" src/components/Views/ForgotPasswordView.jsx | head -5
    
    echo ""
    echo -e "${YELLOW}Specific functions from authUtils:${NC}"
    grep "authUtils" src/components/Views/ForgotPasswordView.jsx | head -3
    
    # Check for problematic imports
    FORGOT_IMPORTS=$(grep -o "validateForgotPasswordForm\|sanitizeIdentifier\|getPasswordResetErrorMessage\|maskEmail" src/components/Views/ForgotPasswordView.jsx 2>/dev/null)
    
    if [ -n "$FORGOT_IMPORTS" ]; then
        echo ""
        echo -e "${YELLOW}Functions that ForgotPasswordView expects:${NC}"
        echo "$FORGOT_IMPORTS" | sort | uniq
        
        # Check if these functions exist in authUtils
        echo ""
        echo -e "${BLUE}Checking if these functions exist in authUtils.js...${NC}"
        if [ -f "src/utils/authUtils.js" ]; then
            for func in $FORGOT_IMPORTS; do
                if grep -q "$func" src/utils/authUtils.js; then
                    echo -e "  ✅ $func"
                else
                    echo -e "  ❌ $func (MISSING)"
                fi
            done
        else
            echo -e "${RED}❌ authUtils.js not found${NC}"
        fi
    fi
    
else
    echo -e "${RED}❌ ForgotPasswordView.jsx not found${NC}"
fi

echo ""

# Check ResetPasswordView imports
if [ -f "src/components/Views/ResetPasswordView.jsx" ]; then
    echo -e "${BLUE}📄 ResetPasswordView.jsx imports:${NC}"
    
    echo -e "${YELLOW}Functions being imported:${NC}"
    grep -o "import[^}]*{[^}]*}" src/components/Views/ResetPasswordView.jsx | head -5
    
    echo ""
    echo -e "${YELLOW}Specific functions from authUtils:${NC}"
    grep "authUtils" src/components/Views/ResetPasswordView.jsx | head -3
    
    # Check for problematic imports
    RESET_IMPORTS=$(grep -o "validatePasswordResetForm\|getPasswordStrength\|getPasswordResetErrorMessage" src/components/Views/ResetPasswordView.jsx 2>/dev/null)
    
    if [ -n "$RESET_IMPORTS" ]; then
        echo ""
        echo -e "${YELLOW}Functions that ResetPasswordView expects:${NC}"
        echo "$RESET_IMPORTS" | sort | uniq
        
        # Check if these functions exist in authUtils
        echo ""
        echo -e "${BLUE}Checking if these functions exist in authUtils.js...${NC}"
        if [ -f "src/utils/authUtils.js" ]; then
            for func in $RESET_IMPORTS; do
                if grep -q "$func" src/utils/authUtils.js; then
                    echo -e "  ✅ $func"
                else
                    echo -e "  ❌ $func (MISSING)"
                fi
            done
        else
            echo -e "${RED}❌ authUtils.js not found${NC}"
        fi
    fi
    
else
    echo -e "${RED}❌ ResetPasswordView.jsx not found${NC}"
fi

echo ""
echo -e "${YELLOW}📋 STEP 3: Checking authAPI functions...${NC}"
echo "========================================"
echo ""

if [ -f "src/services/authAPI.js" ]; then
    echo -e "${BLUE}📄 Password reset functions in authAPI.js:${NC}"
    
    # Check for expected functions
    PASSWORD_FUNCTIONS=("forgotPassword" "resetPassword" "verifyResetToken")
    
    for func in "${PASSWORD_FUNCTIONS[@]}"; do
        if grep -q "$func" src/services/authAPI.js; then
            echo -e "  ✅ $func"
        else
            echo -e "  ❌ $func (MISSING)"
        fi
    done
    
    echo ""
    echo -e "${YELLOW}Export methods found:${NC}"
    grep -n "async.*\(forgotPassword\|resetPassword\|verifyResetToken\)" src/services/authAPI.js
    
else
    echo -e "${RED}❌ authAPI.js not found${NC}"
fi

echo ""
echo -e "${YELLOW}📋 STEP 4: Component-specific error detection...${NC}"
echo "============================================="
echo ""

# Check for common issues in components
if [ -f "src/components/Views/ForgotPasswordView.jsx" ]; then
    echo -e "${BLUE}🔍 ForgotPasswordView.jsx potential issues:${NC}"
    
    # Check for undefined variables/functions
    if grep -q "sanitizedIdentifier\|sanitizeIdentifier" src/components/Views/ForgotPasswordView.jsx; then
        if [ -f "src/utils/authUtils.js" ] && ! grep -q "sanitizeIdentifier" src/utils/authUtils.js; then
            echo -e "  ❌ Uses sanitizeIdentifier() but function is missing from authUtils.js"
        fi
    fi
    
    # Check API calls
    echo ""
    echo -e "${YELLOW}API calls found:${NC}"
    grep -n "authAPI\." src/components/Views/ForgotPasswordView.jsx
    
    # Check error handling
    echo ""
    echo -e "${YELLOW}Error handling patterns:${NC}"
    grep -n "catch\|error\|Error" src/components/Views/ForgotPasswordView.jsx | head -3
    
fi

echo ""
echo -e "${YELLOW}📋 STEP 5: Quick runtime test simulation...${NC}"
echo "=========================================="
echo ""

echo -e "${BLUE}🧪 Simulating password reset flow issues...${NC}"

# Check if we can identify the most likely failure points
echo -e "${YELLOW}Most likely failure points:${NC}"

FAILURE_POINTS=()

# Check for missing utility functions
if [ -f "src/components/Views/ForgotPasswordView.jsx" ] && grep -q "sanitizeIdentifier" src/components/Views/ForgotPasswordView.jsx; then
    if [ ! -f "src/utils/authUtils.js" ] || ! grep -q "sanitizeIdentifier" src/utils/authUtils.js; then
        FAILURE_POINTS+=("Missing sanitizeIdentifier function in authUtils.js")
    fi
fi

if [ -f "src/components/Views/ForgotPasswordView.jsx" ] && grep -q "validateForgotPasswordForm" src/components/Views/ForgotPasswordView.jsx; then
    if [ ! -f "src/utils/authUtils.js" ] || ! grep -q "validateForgotPasswordForm" src/utils/authUtils.js; then
        FAILURE_POINTS+=("Missing validateForgotPasswordForm function in authUtils.js")
    fi
fi

if [ -f "src/components/Views/ResetPasswordView.jsx" ] && grep -q "validatePasswordResetForm" src/components/Views/ResetPasswordView.jsx; then
    if [ ! -f "src/utils/authUtils.js" ] || ! grep -q "validatePasswordResetForm" src/utils/authUtils.js; then
        FAILURE_POINTS+=("Missing validatePasswordResetForm function in authUtils.js")
    fi
fi

# Display failure points
if [ ${#FAILURE_POINTS[@]} -gt 0 ]; then
    echo -e "${RED}🚨 Issues that will cause runtime failures:${NC}"
    for issue in "${FAILURE_POINTS[@]}"; do
        echo -e "  ❌ $issue"
    done
else
    echo -e "${GREEN}✅ No obvious runtime failure points detected${NC}"
fi

echo ""
echo -e "${YELLOW}📋 STEP 6: Summary and recommendations...${NC}"
echo "========================================"
echo ""

echo -e "${BLUE}📊 Issue Summary:${NC}"
echo -e "  🧪 Build Status: $([ $BUILD_EXIT_CODE -eq 0 ] && echo "WORKING ✅" || echo "BROKEN ❌")"
echo -e "  🔍 Missing Functions: ${#FAILURE_POINTS[@]}"
echo -e "  📄 Components Found: $([ -f "src/components/Views/ForgotPasswordView.jsx" ] && echo "ForgotPassword ✅" || echo "ForgotPassword ❌") $([ -f "src/components/Views/ResetPasswordView.jsx" ] && echo "ResetPassword ✅" || echo "ResetPassword ❌")"
echo -e "  🔗 API Functions: $([ -f "src/services/authAPI.js" ] && grep -q "forgotPassword" src/services/authAPI.js && echo "Available ✅" || echo "Missing ❌")"

echo ""
echo -e "${GREEN}🎯 Recommended next steps:${NC}"

if [ $BUILD_EXIT_CODE -ne 0 ]; then
    echo -e "  1. 🔧 ${YELLOW}Fix build errors first${NC}"
    echo -e "     The build is broken - this needs to be fixed before testing"
    echo ""
elif [ ${#FAILURE_POINTS[@]} -gt 0 ]; then
    echo -e "  1. 🔧 ${YELLOW}Add missing utility functions to authUtils.js${NC}"
    echo -e "     Functions like sanitizeIdentifier, validateForgotPasswordForm, etc."
    echo ""
    echo -e "  2. 🧪 ${YELLOW}Test build after adding functions${NC}"
    echo -e "     npm run build"
    echo ""
    echo -e "  3. 🚀 ${YELLOW}Test password reset flow${NC}"
    echo -e "     Try the actual forgot password feature"
else
    echo -e "  1. 🧪 ${YELLOW}Test the password reset flow directly${NC}"
    echo -e "     Components and functions seem to be in place"
    echo ""
    echo -e "  2. 🔗 ${YELLOW}Test backend API endpoints${NC}"
    echo -e "     ./test_forgot_password.sh"
fi

echo ""
echo -e "${BLUE}💡 Based on your successful login fix, this should be much easier!${NC}"

# Create fix script if issues are found
if [ ${#FAILURE_POINTS[@]} -gt 0 ]; then
    echo ""
    echo -e "${YELLOW}🔧 Creating fix script for identified issues...${NC}"
    
    cat > "fix_password_reset_issues.sh" << 'EOF'
#!/bin/bash

echo "🔧 Fixing Password Reset Issues"
echo "==============================="

# Add missing functions to authUtils.js
echo "📝 Adding missing functions to authUtils.js..."

# Check if we need to add functions
if ! grep -q "sanitizeIdentifier\|validateForgotPasswordForm" src/utils/authUtils.js; then
    
    cat >> src/utils/authUtils.js << 'FUNCTIONS_EOF'

/**
 * Sanitize identifier (email/username) input
 */
export const sanitizeIdentifier = (identifier) => {
  if (!identifier) return '';
  return identifier.trim().toLowerCase();
};

/**
 * Validate forgot password form data
 */
export const validateForgotPasswordForm = (email) => {
  const errors = {};
  
  if (!email || email.trim().length === 0) {
    errors.email = 'Email is required';
  } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
    errors.email = 'Please enter a valid email address';
  } else if (email.length > 255) {
    errors.email = 'Email is too long';
  }
  
  return {
    isValid: Object.keys(errors).length === 0,
    errors
  };
};

/**
 * Validate password reset form data
 */
export const validatePasswordResetForm = (password, passwordConfirmation) => {
  const errors = {};
  
  if (!password || password.length === 0) {
    errors.password = 'Password is required';
  } else if (password.length < 8) {
    errors.password = 'Password must be at least 8 characters';
  }
  
  if (password !== passwordConfirmation) {
    errors.passwordConfirmation = 'Passwords do not match';
  }
  
  return {
    isValid: Object.keys(errors).length === 0,
    errors
  };
};

/**
 * Get user-friendly error message for password reset
 */
export const getPasswordResetErrorMessage = (code) => {
  switch (code) {
    case 'USER_NOT_FOUND':
      return 'No account found with that email address.';
    case 'EMAIL_SENDING_FAILED':
      return 'Failed to send reset email. Please try again.';
    case 'RATE_LIMIT_EXCEEDED':
      return 'Too many reset requests. Please wait before trying again.';
    case 'INVALID_EMAIL':
      return 'Please enter a valid email address.';
    case 'RESET_TOKEN_EXPIRED':
      return 'Password reset link has expired. Please request a new one.';
    case 'RESET_TOKEN_INVALID':
      return 'Invalid password reset link. Please request a new one.';
    case 'PASSWORD_RESET_FAILED':
      return 'Failed to reset password. Please try again.';
    case 'WEAK_PASSWORD':
      return 'Password is too weak. Please choose a stronger password.';
    default:
      return 'An error occurred. Please try again.';
  }
};

/**
 * Mask email address for privacy
 */
export const maskEmail = (email) => {
  if (!email || typeof email !== 'string') return '';
  
  const parts = email.split('@');
  if (parts.length !== 2) return email;
  
  const [username, domain] = parts;
  
  if (username.length <= 2) {
    return `${username}***@${domain}`;
  }
  
  const maskedUsername = username.substring(0, 2) + '*'.repeat(username.length - 2);
  return `${maskedUsername}@${domain}`;
};
FUNCTIONS_EOF

    echo "✅ Added missing functions to authUtils.js"
    
    echo ""
    echo "🧪 Testing build..."
    if npm run build >/dev/null 2>&1; then
        echo "✅ Build successful after adding functions!"
        echo ""
        echo "🚀 Password reset should now work. Try testing it!"
    else
        echo "❌ Build still failing. Manual review needed."
    fi
else
    echo "✅ All required functions already exist in authUtils.js"
fi
EOF

    chmod +x fix_password_reset_issues.sh
    echo -e "${GREEN}📄 Created: fix_password_reset_issues.sh${NC}"
    echo -e "${BLUE}Run: ./fix_password_reset_issues.sh${NC}"
fi
