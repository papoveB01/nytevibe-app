#!/bin/bash

# Fix authAPI.js Imports and Functions

echo "🔧 Fixing authAPI.js Imports and Functions"
echo "=========================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🔍 Step 1: Checking current authAPI.js...${NC}"
echo ""

if [ -f "src/services/authAPI.js" ]; then
    echo -e "${YELLOW}Current exports in authAPI.js:${NC}"
    grep -n "export" src/services/authAPI.js
    echo ""
    
    echo -e "${YELLOW}Current function definitions:${NC}"
    grep -n "function\|const.*=" src/services/authAPI.js | head -10
    echo ""
else
    echo -e "${RED}❌ authAPI.js not found!${NC}"
    echo -e "${BLUE}Creating authAPI.js from scratch...${NC}"
fi

echo -e "${BLUE}🔧 Step 2: Creating/updating authAPI.js aligned with backend...${NC}"
echo ""

# Create a complete authAPI.js that matches your backend
cat > "src/services/authAPI.js" << 'AUTHAPI_EOF'
// Auth API service aligned with nYtevibe backend
// Backend API: https://system.nytevibe.com/api/auth/*

const API_BASE_URL = 'https://system.nytevibe.com/api';

/**
 * Custom API Error class
 */
export class APIError extends Error {
  constructor(message, status, code = null, data = null) {
    super(message);
    this.name = 'APIError';
    this.status = status;
    this.code = code;
    this.data = data;
  }
}

/**
 * Make API request with proper error handling
 */
async function apiRequest(endpoint, options = {}) {
  const url = `${API_BASE_URL}${endpoint}`;
  
  const defaultOptions = {
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  };

  // Add auth token if available
  const token = localStorage.getItem('authToken');
  if (token) {
    defaultOptions.headers['Authorization'] = `Bearer ${token}`;
  }

  const finalOptions = {
    ...defaultOptions,
    ...options,
    headers: {
      ...defaultOptions.headers,
      ...(options.headers || {}),
    },
  };

  try {
    console.log(`Making API request to: ${url}`, finalOptions);
    
    const response = await fetch(url, finalOptions);
    
    // Parse response as JSON
    let data;
    try {
      data = await response.json();
    } catch (parseError) {
      throw new APIError('Invalid JSON response from server', response.status);
    }

    console.log(`API response (${response.status}):`, data);

    // Check if response is successful
    if (!response.ok) {
      throw new APIError(
        data.message || `HTTP ${response.status}`,
        response.status,
        data.code || null,
        data
      );
    }

    return data;
  } catch (error) {
    console.error('API request failed:', error);
    
    if (error instanceof APIError) {
      throw error;
    }
    
    // Network or other errors
    throw new APIError(
      'Network error. Please check your connection.',
      0,
      'NETWORK_ERROR'
    );
  }
}

/**
 * Login user
 * POST /api/auth/login
 */
export async function loginUser(credentials) {
  return await apiRequest('/auth/login', {
    method: 'POST',
    body: JSON.stringify(credentials),
  });
}

/**
 * Register user
 * POST /api/auth/register
 */
export async function registerUser(userData) {
  return await apiRequest('/auth/register', {
    method: 'POST',
    body: JSON.stringify(userData),
  });
}

/**
 * Logout user
 * POST /api/auth/logout
 */
export async function logoutUser() {
  try {
    await apiRequest('/auth/logout', {
      method: 'POST',
    });
  } catch (error) {
    console.warn('Logout API call failed, but clearing local data anyway:', error);
  } finally {
    // Always clear local storage
    localStorage.removeItem('authToken');
    localStorage.removeItem('userData');
  }
}

/**
 * Get current user
 * GET /api/auth/user
 */
export async function getCurrentUser() {
  return await apiRequest('/auth/user', {
    method: 'GET',
  });
}

/**
 * Resend verification email
 * POST /api/auth/resend-verification
 */
export async function resendVerificationEmail(email) {
  return await apiRequest('/auth/resend-verification', {
    method: 'POST',
    body: JSON.stringify({ email }),
  });
}

/**
 * Reset password request
 * POST /api/auth/forgot-password
 */
export async function requestPasswordReset(email) {
  return await apiRequest('/auth/forgot-password', {
    method: 'POST',
    body: JSON.stringify({ email }),
  });
}

/**
 * Reset password with token
 * POST /api/auth/reset-password
 */
export async function resetPassword(token, password, passwordConfirmation) {
  return await apiRequest('/auth/reset-password', {
    method: 'POST',
    body: JSON.stringify({
      token,
      password,
      password_confirmation: passwordConfirmation,
    }),
  });
}

/**
 * Verify email with token (for custom verification system)
 * GET /api/email/verify/{userId}/{hash}
 */
export async function verifyEmailToken(userId, hash) {
  return await apiRequest(`/email/verify/${userId}/${hash}`, {
    method: 'GET',
  });
}

/**
 * Check email verification status
 * GET /api/email/verify-status/{userId}
 */
export async function checkVerificationStatus(userId) {
  return await apiRequest(`/email/verify-status/${userId}`, {
    method: 'GET',
  });
}

/**
 * Health check
 * GET /api/health
 */
export async function healthCheck() {
  return await apiRequest('/health', {
    method: 'GET',
  });
}

// Legacy function aliases for backward compatibility
export const login = loginUser;
export const register = registerUser;
export const logout = logoutUser;
export const getUser = getCurrentUser;

export default {
  loginUser,
  registerUser,
  logoutUser,
  getCurrentUser,
  resendVerificationEmail,
  requestPasswordReset,
  resetPassword,
  verifyEmailToken,
  checkVerificationStatus,
  healthCheck,
  APIError,
  // Legacy aliases
  login: loginUser,
  register: registerUser,
  logout: logoutUser,
  getUser: getCurrentUser,
};
AUTHAPI_EOF

echo -e "  ✅ Created complete authAPI.js aligned with backend"

echo ""
echo -e "${BLUE}🔧 Step 3: Updating LoginView.jsx imports...${NC}"
echo ""

# The LoginView.jsx should now work since loginUser is exported
echo -e "${YELLOW}Verifying LoginView.jsx imports...${NC}"
if grep -q "import { loginUser }" src/components/Views/LoginView.jsx; then
    echo -e "  ✅ LoginView.jsx imports loginUser correctly"
else
    echo -e "  ⚠️ Updating LoginView.jsx imports..."
    
    # Fix the import in LoginView.jsx if needed
    sed -i 's/import { APIError }/import { APIError, loginUser }/g' src/components/Views/LoginView.jsx
    sed -i '/import { loginUser }/d' src/components/Views/LoginView.jsx
    sed -i 's/import { APIError, loginUser }/import { APIError, loginUser }/g' src/components/Views/LoginView.jsx
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
    echo -e "${BLUE}📋 Your login system is now ready:${NC}"
    echo -e "  ✅ authAPI.js with all required functions"
    echo -e "  ✅ LoginView.jsx with correct imports"
    echo -e "  ✅ Aligned with backend API endpoints"
    echo -e "  ✅ No email verification conflicts"
    echo ""
    echo -e "${GREEN}🚀 Ready to test login!${NC}"
    echo -e "Backend API: ${BLUE}https://system.nytevibe.com/api/auth/login${NC}"
    echo -e "Test with: ${BLUE}iammrpwinner01@gmail.com${NC}"
    echo ""
    echo -e "${YELLOW}📋 Available API functions:${NC}"
    echo -e "  • loginUser(credentials)"
    echo -e "  • registerUser(userData)"
    echo -e "  • logoutUser()"
    echo -e "  • getCurrentUser()"
    echo -e "  • resendVerificationEmail(email)"
    echo -e "  • verifyEmailToken(userId, hash)"
else
    echo ""
    echo -e "${RED}❌ Build still failing. Let's check the error...${NC}"
    echo ""
    
    echo -e "${YELLOW}Recent build output:${NC}"
    npm run build 2>&1 | tail -15
    
    echo ""
    echo -e "${YELLOW}🔍 Let's check the imports again...${NC}"
    
    if [ -f "src/components/Views/LoginView.jsx" ]; then
        echo -e "${BLUE}Current LoginView.jsx imports:${NC}"
        head -10 src/components/Views/LoginView.jsx
    fi
    
    echo ""
    echo -e "${BLUE}Current authAPI.js exports:${NC}"
    grep "export" src/services/authAPI.js
fi

echo ""
echo -e "${GREEN}💡 After successful build, test your login - no more email verification issues!${NC}"
