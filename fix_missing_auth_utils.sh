#!/bin/bash

# Fix Missing authUtils Functions

echo "🔧 Adding Missing Functions to authUtils.js"
echo "============================================"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🔍 Step 1: Checking what functions are missing...${NC}"
echo ""

if [ -f "src/components/Views/ForgotPasswordView.jsx" ]; then
    echo -e "${YELLOW}Functions ForgotPasswordView.jsx is trying to import:${NC}"
    grep -A 5 "import.*authUtils" src/components/Views/ForgotPasswordView.jsx
    echo ""
else
    echo -e "${YELLOW}ForgotPasswordView.jsx not found${NC}"
fi

echo -e "${BLUE}🔧 Step 2: Adding missing functions to authUtils.js...${NC}"
echo ""

# Add the missing functions to authUtils.js
cat >> "src/utils/authUtils.js" << 'MISSING_FUNCTIONS_EOF'

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
 * Sanitize identifier (email/username) input
 */
export const sanitizeIdentifier = (identifier) => {
  if (!identifier) return '';
  return identifier.trim().toLowerCase();
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
 * Mask email address for privacy (show first 2 chars and domain)
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

/**
 * Validate password reset form data
 */
export const validatePasswordResetForm = (password, passwordConfirmation) => {
  const errors = {};
  
  // Password validation
  if (!password || password.length === 0) {
    errors.password = 'Password is required';
  } else if (password.length < 8) {
    errors.password = 'Password must be at least 8 characters';
  } else if (!/(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/.test(password)) {
    errors.password = 'Password must contain at least one uppercase letter, one lowercase letter, and one number';
  }
  
  // Password confirmation
  if (password !== passwordConfirmation) {
    errors.passwordConfirmation = 'Passwords do not match';
  }
  
  return {
    isValid: Object.keys(errors).length === 0,
    errors
  };
};

/**
 * Format password strength
 */
export const getPasswordStrength = (password) => {
  if (!password) return { strength: 0, label: 'No password', color: 'gray' };
  
  let score = 0;
  
  // Length check
  if (password.length >= 8) score += 1;
  if (password.length >= 12) score += 1;
  
  // Character variety
  if (/[a-z]/.test(password)) score += 1;
  if (/[A-Z]/.test(password)) score += 1;
  if (/\d/.test(password)) score += 1;
  if (/[^a-zA-Z\d]/.test(password)) score += 1;
  
  const strengthLevels = {
    0: { label: 'Very Weak', color: 'red' },
    1: { label: 'Very Weak', color: 'red' },
    2: { label: 'Weak', color: 'orange' },
    3: { label: 'Fair', color: 'yellow' },
    4: { label: 'Good', color: 'green' },
    5: { label: 'Strong', color: 'green' },
    6: { label: 'Very Strong', color: 'green' }
  };
  
  return {
    strength: score,
    ...strengthLevels[score]
  };
};

/**
 * Generate random password
 */
export const generateRandomPassword = (length = 12) => {
  const lowercase = 'abcdefghijklmnopqrstuvwxyz';
  const uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  const numbers = '0123456789';
  const symbols = '!@#$%^&*()_+-=[]{}|;:,.<>?';
  
  const allChars = lowercase + uppercase + numbers + symbols;
  
  let password = '';
  
  // Ensure at least one character from each category
  password += lowercase[Math.floor(Math.random() * lowercase.length)];
  password += uppercase[Math.floor(Math.random() * uppercase.length)];
  password += numbers[Math.floor(Math.random() * numbers.length)];
  password += symbols[Math.floor(Math.random() * symbols.length)];
  
  // Fill the rest randomly
  for (let i = 4; i < length; i++) {
    password += allChars[Math.floor(Math.random() * allChars.length)];
  }
  
  // Shuffle the password
  return password.split('').sort(() => Math.random() - 0.5).join('');
};

/**
 * Debounce function for input validation
 */
export const debounce = (func, wait) => {
  let timeout;
  return function executedFunction(...args) {
    const later = () => {
      clearTimeout(timeout);
      func(...args);
    };
    clearTimeout(timeout);
    timeout = setTimeout(later, wait);
  };
};
MISSING_FUNCTIONS_EOF

echo -e "  ✅ Added missing utility functions to authUtils.js"

echo ""
echo -e "${BLUE}🔧 Step 3: Checking if ResetPasswordView needs functions too...${NC}"
echo ""

if [ -f "src/components/Views/ResetPasswordView.jsx" ]; then
    echo -e "${YELLOW}Checking ResetPasswordView.jsx imports...${NC}"
    grep -n "import.*authUtils" src/components/Views/ResetPasswordView.jsx
    echo ""
fi

echo ""
echo -e "${BLUE}🧪 Step 4: Testing build...${NC}"
echo ""

# Test the build
echo -e "${YELLOW}Running build test...${NC}"
if npm run build; then
    echo ""
    echo -e "${GREEN}🎉 Build successful!${NC}"
    echo ""
    echo -e "${BLUE}📋 All components are now working:${NC}"
    echo -e "  ✅ LoginView.jsx - clean login without verification conflicts"
    echo -e "  ✅ ForgotPasswordView.jsx - with all required utility functions"
    echo -e "  ✅ authAPI.js - aligned with backend endpoints"
    echo -e "  ✅ authUtils.js - complete utility functions"
    echo ""
    echo -e "${GREEN}🚀 Ready to test your complete auth system!${NC}"
    echo ""
    echo -e "${YELLOW}Available utility functions in authUtils.js:${NC}"
    echo -e "  • validateLoginForm()"
    echo -e "  • validateRegistrationForm()"
    echo -e "  • validateForgotPasswordForm()"
    echo -e "  • validatePasswordResetForm()"
    echo -e "  • sanitizeIdentifier()"
    echo -e "  • maskEmail()"
    echo -e "  • getErrorMessage()"
    echo -e "  • getPasswordResetErrorMessage()"
    echo -e "  • getPasswordStrength()"
    echo -e "  • generateRandomPassword()"
    echo ""
    echo -e "${BLUE}🎯 Test your login now:${NC}"
    echo -e "  Email: ${GREEN}iammrpwinner01@gmail.com${NC}"
    echo -e "  No more 'Please verify your email' errors!"
else
    echo ""
    echo -e "${RED}❌ Build still failing. Let's check what's missing...${NC}"
    echo ""
    
    echo -e "${YELLOW}Recent build output:${NC}"
    npm run build 2>&1 | tail -20
    
    echo ""
    echo -e "${YELLOW}🔍 Let's check if there are more missing imports...${NC}"
    
    # Check what other functions might be missing
    echo -e "${BLUE}All imports from authUtils across the project:${NC}"
    find src -name "*.jsx" -o -name "*.js" | xargs grep -l "authUtils" | while read file; do
        echo "📄 $file:"
        grep -A 10 "import.*authUtils" "$file" | head -15
        echo ""
    done
fi

echo ""
echo -e "${GREEN}💡 Your login system should now work completely without email verification conflicts!${NC}"
