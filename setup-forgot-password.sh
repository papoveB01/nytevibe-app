#!/bin/bash

# =============================================================================
# nYtevibe Forgot Password Feature Implementation Setup Script
# =============================================================================
# 
# This script creates the complete file structure and basic implementation
# for the forgot password feature based on the comprehensive implementation plan.
#
# Version: 1.0
# Date: June 4, 2025
# Project: nYtevibe Houston Nightlife Discovery Platform
#
# =============================================================================

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Emojis for better UX
ROCKET="🚀"
CHECK="✅"
FOLDER="📁"
FILE="📄"
CODE="💻"
GEAR="⚙️"
TEST="🧪"
STYLE="🎨"

# =============================================================================
# Helper Functions
# =============================================================================

print_header() {
    echo ""
    echo -e "${PURPLE}=============================================================================${NC}"
    echo -e "${PURPLE}  $1${NC}"
    echo -e "${PURPLE}=============================================================================${NC}"
    echo ""
}

print_step() {
    echo -e "${BLUE}${ROCKET} $1${NC}"
}

print_success() {
    echo -e "${GREEN}${CHECK} $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${CYAN}ℹ️  $1${NC}"
}

create_directory() {
    if [ ! -d "$1" ]; then
        mkdir -p "$1"
        print_success "Created directory: $1"
    else
        print_info "Directory already exists: $1"
    fi
}

backup_file() {
    if [ -f "$1" ]; then
        cp "$1" "$1.backup-$(date +%Y%m%d-%H%M%S)"
        print_warning "Backed up existing file: $1"
    fi
}

# =============================================================================
# Project Validation
# =============================================================================

validate_project() {
    print_header "Project Validation"
    
    # Check if we're in a React project
    if [ ! -f "package.json" ]; then
        print_error "package.json not found. Please run this script from your React project root."
        exit 1
    fi
    
    # Check if src directory exists
    if [ ! -d "src" ]; then
        print_error "src directory not found. This doesn't appear to be a React project."
        exit 1
    fi
    
    # Check if this is the nYtevibe project
    if grep -q "nytevibe\|blackaxl" package.json 2>/dev/null; then
        print_success "nYtevibe project detected"
    else
        print_warning "Project name doesn't match nYtevibe. Continuing anyway..."
    fi
    
    print_success "Project validation complete"
}

# =============================================================================
# Directory Structure Setup
# =============================================================================

setup_directories() {
    print_header "Setting Up Directory Structure ${FOLDER}"
    
    # Core directories
    create_directory "src/components/Views"
    create_directory "src/services"
    create_directory "src/utils"
    create_directory "src/context"
    create_directory "src/router"
    create_directory "src/styles"
    
    # Test directories
    create_directory "src/__tests__"
    create_directory "src/__tests__/components"
    create_directory "src/__tests__/services"
    create_directory "src/__tests__/utils"
    
    # Component-specific test directories
    create_directory "src/__tests__/components/Views"
    
    print_success "Directory structure setup complete"
}

# =============================================================================
# Utility Files Creation
# =============================================================================

create_url_utils() {
    print_step "Creating URL utilities ${FILE}"
    
    cat > "src/utils/urlUtils.js" << 'EOF'
/**
 * URL Utilities for Password Reset Token Handling
 * nYtevibe Password Reset Implementation
 * 
 * Handles secure extraction and validation of reset tokens from URLs
 */

/**
 * Extract reset token from URL parameters
 * @returns {string|null} Reset token or null if not found
 */
export const getTokenFromURL = () => {
  const urlParams = new URLSearchParams(window.location.search);
  return urlParams.get('token');
};

/**
 * Extract email from URL parameters
 * @returns {string|null} Email or null if not found
 */
export const getEmailFromURL = () => {
  const urlParams = new URLSearchParams(window.location.search);
  return urlParams.get('email');
};

/**
 * Validate URL parameters for password reset
 * @returns {{isValid: boolean, token?: string, email?: string, errors: string[]}}
 */
export const validateResetURL = () => {
  const token = getTokenFromURL();
  const email = getEmailFromURL();
  const errors = [];

  if (!token) {
    errors.push('Reset token is missing from the URL');
  }

  if (!email) {
    errors.push('Email is missing from the URL');
  }

  if (email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
    errors.push('Invalid email format in URL');
  }

  if (token && !/^[A-Za-z0-9+/=._-]+$/.test(token)) {
    errors.push('Invalid token format in URL');
  }

  return {
    isValid: errors.length === 0,
    token,
    email,
    errors
  };
};

/**
 * Clean URL parameters after successful password reset
 */
export const cleanResetURLParams = () => {
  const url = new URL(window.location);
  url.searchParams.delete('token');
  url.searchParams.delete('email');
  window.history.replaceState({}, document.title, url.pathname);
};

/**
 * Build reset URL for testing/development
 * @param {string} token - Reset token
 * @param {string} email - User email
 * @returns {string} Complete reset URL
 */
export const buildResetURL = (token, email) => {
  const baseURL = window.location.origin;
  return `${baseURL}/reset-password?token=${encodeURIComponent(token)}&email=${encodeURIComponent(email)}`;
};
EOF

    print_success "Created src/utils/urlUtils.js"
}

enhance_auth_utils() {
    print_step "Enhancing authentication utilities ${FILE}"
    
    # Check if authUtils.js exists
    if [ -f "src/utils/authUtils.js" ]; then
        backup_file "src/utils/authUtils.js"
        print_info "Backing up existing authUtils.js and enhancing it"
        
        # Append new functions to existing file
        cat >> "src/utils/authUtils.js" << 'EOF'

// =============================================================================
// Password Reset Utilities (Added by setup script)
// =============================================================================

/**
 * Validate forgot password form
 * @param {string} identifier - Email or username
 * @returns {{isValid: boolean, errors: object}}
 */
export const validateForgotPasswordForm = (identifier) => {
  const errors = {};

  if (!identifier || identifier.trim().length === 0) {
    errors.identifier = 'Email or username is required';
  } else if (identifier.trim().length < 3) {
    errors.identifier = 'Please enter a valid email or username';
  } else if (identifier.trim().length > 255) {
    errors.identifier = 'Input is too long';
  }

  return {
    isValid: Object.keys(errors).length === 0,
    errors
  };
};

/**
 * Validate password reset form
 * @param {string} password - New password
 * @param {string} passwordConfirmation - Password confirmation
 * @returns {{isValid: boolean, errors: object}}
 */
export const validatePasswordResetForm = (password, passwordConfirmation) => {
  const errors = {};

  // Password strength validation
  const strengthErrors = validatePasswordStrength(password);
  if (strengthErrors.length > 0) {
    errors.password = strengthErrors;
  }

  // Password confirmation validation
  if (!passwordConfirmation) {
    errors.passwordConfirmation = 'Please confirm your password';
  } else if (password !== passwordConfirmation) {
    errors.passwordConfirmation = 'Passwords do not match';
  }

  return {
    isValid: Object.keys(errors).length === 0,
    errors
  };
};

/**
 * Validate password strength
 * @param {string} password - Password to validate
 * @returns {string[]} Array of validation error messages
 */
export const validatePasswordStrength = (password) => {
  const errors = [];

  if (!password) {
    errors.push('Password is required');
    return errors;
  }

  if (password.length < 8) {
    errors.push('Password must be at least 8 characters long');
  }

  if (!/[A-Z]/.test(password)) {
    errors.push('Password must contain at least one uppercase letter');
  }

  if (!/[a-z]/.test(password)) {
    errors.push('Password must contain at least one lowercase letter');
  }

  if (!/[0-9]/.test(password)) {
    errors.push('Password must contain at least one number');
  }

  if (!/[!@#$%^&*(),.?":{}|<>]/.test(password)) {
    errors.push('Password must contain at least one special character');
  }

  return errors;
};

/**
 * Get password strength score and label
 * @param {string} password - Password to evaluate
 * @returns {{score: number, label: string, color: string}}
 */
export const getPasswordStrength = (password) => {
  if (!password) return { score: 0, label: 'No password', color: '#e5e7eb' };

  let score = 0;
  const checks = [
    password.length >= 8,
    /[A-Z]/.test(password),
    /[a-z]/.test(password),
    /[0-9]/.test(password),
    /[!@#$%^&*(),.?":{}|<>]/.test(password),
    password.length >= 12
  ];

  score = checks.filter(Boolean).length;

  const strengthLevels = {
    0: { label: 'Very Weak', color: '#ef4444' },
    1: { label: 'Very Weak', color: '#ef4444' },
    2: { label: 'Weak', color: '#f97316' },
    3: { label: 'Fair', color: '#eab308' },
    4: { label: 'Good', color: '#22c55e' },
    5: { label: 'Strong', color: '#16a34a' },
    6: { label: 'Very Strong', color: '#15803d' }
  };

  return {
    score,
    ...strengthLevels[score]
  };
};

/**
 * Format password reset error messages
 * @param {string} error - Error message
 * @param {string} code - Error code
 * @param {object} data - Additional error data
 * @returns {string} User-friendly error message
 */
export const getPasswordResetErrorMessage = (error, code, data) => {
  switch (code) {
    case 'USER_NOT_FOUND':
      return 'If an account with that email exists, you will receive a reset link.';
    
    case 'INVALID_TOKEN':
      return 'This password reset link has expired or is invalid. Please request a new one.';
    
    case 'RATE_LIMIT_EXCEEDED':
      return 'Too many password reset attempts. Please try again later.';
    
    case 'VALIDATION_ERROR':
      if (data?.details) {
        const firstError = Object.values(data.details)[0];
        return Array.isArray(firstError) ? firstError[0] : firstError;
      }
      return 'Please check your input and try again.';
    
    case 'NETWORK_ERROR':
      return 'Unable to connect to the server. Please check your internet connection.';
    
    default:
      return error || 'An unexpected error occurred. Please try again.';
  }
};

/**
 * Sanitize identifier input (email or username)
 * @param {string} identifier - Input identifier
 * @returns {string} Sanitized identifier
 */
export const sanitizeIdentifier = (identifier) => {
  if (!identifier) return '';
  return identifier.trim().toLowerCase();
};

/**
 * Mask email for privacy protection
 * @param {string} email - Email to mask
 * @returns {string} Masked email
 */
export const maskEmail = (email) => {
  if (!email || !email.includes('@')) return '';
  
  const [username, domain] = email.split('@');
  const maskedUsername = username.length <= 2 
    ? username 
    : username.charAt(0) + '*'.repeat(username.length - 2) + username.charAt(username.length - 1);
  
  return `${maskedUsername}@${domain}`;
};

/**
 * Format retry countdown for rate limiting
 * @param {number} seconds - Seconds remaining
 * @returns {string} Formatted countdown string
 */
export const formatRetryCountdown = (seconds) => {
  const mins = Math.floor(seconds / 60);
  const secs = seconds % 60;
  return mins > 0
    ? `${mins}:${secs.toString().padStart(2, '0')}`
    : `${secs}s`;
};
EOF
    else
        # Create new authUtils.js file
        cat > "src/utils/authUtils.js" << 'EOF'
/**
 * Authentication Utilities
 * nYtevibe Authentication System
 * 
 * Centralized utilities for authentication, validation, and security
 */

// =============================================================================
// Existing Login Utilities (Preserve existing functions)
// =============================================================================

/**
 * Get authentication error message (existing function - enhance as needed)
 * @param {string} error - Error message
 * @param {string} code - Error code
 * @param {object} data - Additional error data
 * @returns {string} User-friendly error message
 */
export const getAuthErrorMessage = (error, code, data) => {
  switch (code) {
    case 'INVALID_CREDENTIALS':
      return 'Invalid username or password. Please check your credentials and try again.';
    
    case 'EMAIL_NOT_VERIFIED':
      return 'Please verify your email address before signing in.';
    
    case 'ACCOUNT_SUSPENDED':
      return 'Your account has been suspended. Please contact support.';
    
    case 'ACCOUNT_BANNED':
      return 'Your account has been banned. Please contact support.';
    
    case 'ACCOUNT_PENDING':
      return 'Your account is pending approval. Please wait for confirmation.';
    
    case 'RATE_LIMIT_EXCEEDED':
      return 'Too many login attempts. Please wait before trying again.';
    
    case 'NETWORK_ERROR':
      return 'Connection error. Please check your internet and try again.';
    
    default:
      return error || 'An unexpected error occurred. Please try again.';
  }
};

/**
 * Validate login form (existing function - enhance as needed)
 * @param {string} username - Username or email
 * @param {string} password - Password
 * @returns {{isValid: boolean, errors: object}}
 */
export const validateLoginForm = (username, password) => {
  const errors = {};

  if (!username || username.trim().length === 0) {
    errors.username = 'Username or email is required';
  }

  if (!password || password.length === 0) {
    errors.password = 'Password is required';
  }

  return { 
    isValid: Object.keys(errors).length === 0, 
    errors 
  };
};

/**
 * Sanitize username (existing function - enhance as needed)
 * @param {string} username - Username to sanitize
 * @returns {string} Sanitized username
 */
export const sanitizeUsername = (username) => {
  return username ? username.trim().toLowerCase() : '';
};

/**
 * Check if credentials are demo credentials
 * @param {string} username - Username
 * @param {string} password - Password
 * @returns {boolean} True if demo credentials
 */
export const isDemoCredentials = (username, password) => {
  return username === 'demouser' && password === 'demopass';
};

// =============================================================================
// Password Reset Utilities (New)
// =============================================================================

/**
 * Validate forgot password form
 * @param {string} identifier - Email or username
 * @returns {{isValid: boolean, errors: object}}
 */
export const validateForgotPasswordForm = (identifier) => {
  const errors = {};

  if (!identifier || identifier.trim().length === 0) {
    errors.identifier = 'Email or username is required';
  } else if (identifier.trim().length < 3) {
    errors.identifier = 'Please enter a valid email or username';
  } else if (identifier.trim().length > 255) {
    errors.identifier = 'Input is too long';
  }

  return {
    isValid: Object.keys(errors).length === 0,
    errors
  };
};

/**
 * Validate password reset form
 * @param {string} password - New password
 * @param {string} passwordConfirmation - Password confirmation
 * @returns {{isValid: boolean, errors: object}}
 */
export const validatePasswordResetForm = (password, passwordConfirmation) => {
  const errors = {};

  // Password strength validation
  const strengthErrors = validatePasswordStrength(password);
  if (strengthErrors.length > 0) {
    errors.password = strengthErrors;
  }

  // Password confirmation validation
  if (!passwordConfirmation) {
    errors.passwordConfirmation = 'Please confirm your password';
  } else if (password !== passwordConfirmation) {
    errors.passwordConfirmation = 'Passwords do not match';
  }

  return {
    isValid: Object.keys(errors).length === 0,
    errors
  };
};

/**
 * Validate password strength
 * @param {string} password - Password to validate
 * @returns {string[]} Array of validation error messages
 */
export const validatePasswordStrength = (password) => {
  const errors = [];

  if (!password) {
    errors.push('Password is required');
    return errors;
  }

  if (password.length < 8) {
    errors.push('Password must be at least 8 characters long');
  }

  if (!/[A-Z]/.test(password)) {
    errors.push('Password must contain at least one uppercase letter');
  }

  if (!/[a-z]/.test(password)) {
    errors.push('Password must contain at least one lowercase letter');
  }

  if (!/[0-9]/.test(password)) {
    errors.push('Password must contain at least one number');
  }

  if (!/[!@#$%^&*(),.?":{}|<>]/.test(password)) {
    errors.push('Password must contain at least one special character');
  }

  return errors;
};

/**
 * Get password strength score and label
 * @param {string} password - Password to evaluate
 * @returns {{score: number, label: string, color: string}}
 */
export const getPasswordStrength = (password) => {
  if (!password) return { score: 0, label: 'No password', color: '#e5e7eb' };

  let score = 0;
  const checks = [
    password.length >= 8,
    /[A-Z]/.test(password),
    /[a-z]/.test(password),
    /[0-9]/.test(password),
    /[!@#$%^&*(),.?":{}|<>]/.test(password),
    password.length >= 12
  ];

  score = checks.filter(Boolean).length;

  const strengthLevels = {
    0: { label: 'Very Weak', color: '#ef4444' },
    1: { label: 'Very Weak', color: '#ef4444' },
    2: { label: 'Weak', color: '#f97316' },
    3: { label: 'Fair', color: '#eab308' },
    4: { label: 'Good', color: '#22c55e' },
    5: { label: 'Strong', color: '#16a34a' },
    6: { label: 'Very Strong', color: '#15803d' }
  };

  return {
    score,
    ...strengthLevels[score]
  };
};

/**
 * Format password reset error messages
 * @param {string} error - Error message
 * @param {string} code - Error code
 * @param {object} data - Additional error data
 * @returns {string} User-friendly error message
 */
export const getPasswordResetErrorMessage = (error, code, data) => {
  switch (code) {
    case 'USER_NOT_FOUND':
      return 'If an account with that email exists, you will receive a reset link.';
    
    case 'INVALID_TOKEN':
      return 'This password reset link has expired or is invalid. Please request a new one.';
    
    case 'RATE_LIMIT_EXCEEDED':
      return 'Too many password reset attempts. Please try again later.';
    
    case 'VALIDATION_ERROR':
      if (data?.details) {
        const firstError = Object.values(data.details)[0];
        return Array.isArray(firstError) ? firstError[0] : firstError;
      }
      return 'Please check your input and try again.';
    
    case 'NETWORK_ERROR':
      return 'Unable to connect to the server. Please check your internet connection.';
    
    default:
      return error || 'An unexpected error occurred. Please try again.';
  }
};

/**
 * Sanitize identifier input (email or username)
 * @param {string} identifier - Input identifier
 * @returns {string} Sanitized identifier
 */
export const sanitizeIdentifier = (identifier) => {
  if (!identifier) return '';
  return identifier.trim().toLowerCase();
};

/**
 * Mask email for privacy protection
 * @param {string} email - Email to mask
 * @returns {string} Masked email
 */
export const maskEmail = (email) => {
  if (!email || !email.includes('@')) return '';
  
  const [username, domain] = email.split('@');
  const maskedUsername = username.length <= 2 
    ? username 
    : username.charAt(0) + '*'.repeat(username.length - 2) + username.charAt(username.length - 1);
  
  return `${maskedUsername}@${domain}`;
};

/**
 * Format retry countdown for rate limiting
 * @param {number} seconds - Seconds remaining
 * @returns {string} Formatted countdown string
 */
export const formatRetryCountdown = (seconds) => {
  const mins = Math.floor(seconds / 60);
  const secs = seconds % 60;
  return mins > 0
    ? `${mins}:${secs.toString().padStart(2, '0')}`
    : `${secs}s`;
};
EOF
    fi

    print_success "Enhanced src/utils/authUtils.js"
}

# =============================================================================
# Service Files Creation
# =============================================================================

enhance_auth_api() {
    print_step "Enhancing authentication API service ${CODE}"
    
    if [ -f "src/services/authAPI.js" ]; then
        backup_file "src/services/authAPI.js"
        print_info "Backing up existing authAPI.js and enhancing it"
        
        # Append new methods to existing file
        cat >> "src/services/authAPI.js" << 'EOF'

  // =============================================================================
  // Password Reset Methods (Added by setup script)
  // =============================================================================

  /**
   * Send password reset link
   * @param {string} identifier - Email or username
   * @returns {Promise<{success: boolean, data?: object, error?: string, code?: string}>}
   */
  async forgotPassword(identifier) {
    try {
      const response = await this.request('/auth/forgot-password', {
        method: 'POST',
        body: JSON.stringify({ identifier })
      });

      if (response.ok) {
        const data = await response.json();
        return {
          success: true,
          data: data.data,
          message: data.message
        };
      } else {
        const errorData = await response.json();
        return {
          success: false,
          error: errorData.error?.message || 'Failed to send reset link',
          code: errorData.error?.code,
          retryAfter: errorData.error?.retry_after,
          data: errorData.error?.data
        };
      }
    } catch (error) {
      console.error('Forgot password error:', error);
      return {
        success: false,
        error: 'Network error. Please check your connection.',
        code: 'NETWORK_ERROR'
      };
    }
  }

  /**
   * Reset password with token
   * @param {string} token - Reset token from email
   * @param {string} email - User email
   * @param {string} password - New password
   * @param {string} passwordConfirmation - Password confirmation
   * @returns {Promise<{success: boolean, error?: string, code?: string}>}
   */
  async resetPassword(token, email, password, passwordConfirmation) {
    try {
      const response = await this.request('/auth/reset-password', {
        method: 'POST',
        body: JSON.stringify({
          token,
          email,
          password,
          password_confirmation: passwordConfirmation
        })
      });

      if (response.ok) {
        const data = await response.json();
        return {
          success: true,
          message: data.message
        };
      } else {
        const errorData = await response.json();
        return {
          success: false,
          error: errorData.error?.message || 'Failed to reset password',
          code: errorData.error?.code,
          details: errorData.error?.details,
          retryAfter: errorData.error?.retry_after
        };
      }
    } catch (error) {
      console.error('Reset password error:', error);
      return {
        success: false,
        error: 'Network error. Please check your connection.',
        code: 'NETWORK_ERROR'
      };
    }
  }

  /**
   * Verify reset token validity
   * @param {string} token - Reset token
   * @param {string} email - User email
   * @returns {Promise<{success: boolean, error?: string, code?: string}>}
   */
  async verifyResetToken(token, email) {
    try {
      const response = await this.request('/auth/verify-reset-token', {
        method: 'POST',
        body: JSON.stringify({ token, email })
      });

      if (response.ok) {
        const data = await response.json();
        return {
          success: true,
          message: data.message
        };
      } else {
        const errorData = await response.json();
        return {
          success: false,
          error: errorData.error?.message || 'Invalid token',
          code: errorData.error?.code
        };
      }
    } catch (error) {
      console.error('Verify token error:', error);
      return {
        success: false,
        error: 'Network error. Please check your connection.',
        code: 'NETWORK_ERROR'
      };
    }
  }

} // End of class - DO NOT REMOVE THIS LINE
EOF
    else
        # Create new authAPI.js file with complete structure
        cat > "src/services/authAPI.js" << 'EOF'
/**
 * Authentication API Service
 * nYtevibe Authentication System
 * 
 * Centralized API service for all authentication operations
 * including login, logout, password reset, and user management
 */

class AuthAPI {
  constructor() {
    this.baseURL = 'https://system.nytevibe.com/api';
    this.timeout = 30000; // 30 seconds
  }

  // =============================================================================
  // Core Authentication Methods
  // =============================================================================

  /**
   * User login
   * @param {string} email - User email or username
   * @param {string} password - User password
   * @param {boolean} remember - Remember session
   * @returns {Promise<{success: boolean, user?: object, token?: string, error?: string}>}
   */
  async login(email, password, remember = false) {
    try {
      const response = await this.request('/auth/login', {
        method: 'POST',
        body: JSON.stringify({ email, password, remember })
      });

      if (response.ok) {
        const data = await response.json();
        
        // Store token and user data
        localStorage.setItem('auth_token', data.data.token);
        localStorage.setItem('user_data', JSON.stringify(data.data.user));
        
        return {
          success: true,
          user: data.data.user,
          token: data.data.token,
          message: data.message
        };
      } else {
        const errorData = await response.json();
        return {
          success: false,
          error: errorData.error?.message || 'Login failed',
          code: errorData.error?.code,
          data: errorData.error?.data
        };
      }
    } catch (error) {
      console.error('Login error:', error);
      return {
        success: false,
        error: 'Network error. Please check your connection.',
        code: 'NETWORK_ERROR'
      };
    }
  }

  /**
   * User logout
   * @returns {Promise<{success: boolean, error?: string}>}
   */
  async logout() {
    try {
      await this.request('/auth/logout', {
        method: 'POST'
      });
    } catch (error) {
      console.error('Logout error:', error);
    } finally {
      // Clear local storage regardless of API response
      localStorage.removeItem('auth_token');
      localStorage.removeItem('user_data');
    }
    
    return { success: true };
  }

  /**
   * Get current user
   * @returns {Promise<{success: boolean, user?: object, error?: string}>}
   */
  async getCurrentUser() {
    try {
      const response = await this.request('/auth/user', {
        method: 'GET'
      });

      if (response.ok) {
        const data = await response.json();
        
        // Update cached user data
        localStorage.setItem('user_data', JSON.stringify(data.data.user));
        
        return {
          success: true,
          user: data.data.user
        };
      } else {
        return {
          success: false,
          error: 'Failed to get user data',
          code: 'UNAUTHORIZED'
        };
      }
    } catch (error) {
      console.error('Get user error:', error);
      return {
        success: false,
        error: 'Network error. Please check your connection.',
        code: 'NETWORK_ERROR'
      };
    }
  }

  // =============================================================================
  // Password Reset Methods
  // =============================================================================

  /**
   * Send password reset link
   * @param {string} identifier - Email or username
   * @returns {Promise<{success: boolean, data?: object, error?: string, code?: string}>}
   */
  async forgotPassword(identifier) {
    try {
      const response = await this.request('/auth/forgot-password', {
        method: 'POST',
        body: JSON.stringify({ identifier })
      });

      if (response.ok) {
        const data = await response.json();
        return {
          success: true,
          data: data.data,
          message: data.message
        };
      } else {
        const errorData = await response.json();
        return {
          success: false,
          error: errorData.error?.message || 'Failed to send reset link',
          code: errorData.error?.code,
          retryAfter: errorData.error?.retry_after,
          data: errorData.error?.data
        };
      }
    } catch (error) {
      console.error('Forgot password error:', error);
      return {
        success: false,
        error: 'Network error. Please check your connection.',
        code: 'NETWORK_ERROR'
      };
    }
  }

  /**
   * Reset password with token
   * @param {string} token - Reset token from email
   * @param {string} email - User email
   * @param {string} password - New password
   * @param {string} passwordConfirmation - Password confirmation
   * @returns {Promise<{success: boolean, error?: string, code?: string}>}
   */
  async resetPassword(token, email, password, passwordConfirmation) {
    try {
      const response = await this.request('/auth/reset-password', {
        method: 'POST',
        body: JSON.stringify({
          token,
          email,
          password,
          password_confirmation: passwordConfirmation
        })
      });

      if (response.ok) {
        const data = await response.json();
        return {
          success: true,
          message: data.message
        };
      } else {
        const errorData = await response.json();
        return {
          success: false,
          error: errorData.error?.message || 'Failed to reset password',
          code: errorData.error?.code,
          details: errorData.error?.details,
          retryAfter: errorData.error?.retry_after
        };
      }
    } catch (error) {
      console.error('Reset password error:', error);
      return {
        success: false,
        error: 'Network error. Please check your connection.',
        code: 'NETWORK_ERROR'
      };
    }
  }

  /**
   * Verify reset token validity
   * @param {string} token - Reset token
   * @param {string} email - User email
   * @returns {Promise<{success: boolean, error?: string, code?: string}>}
   */
  async verifyResetToken(token, email) {
    try {
      const response = await this.request('/auth/verify-reset-token', {
        method: 'POST',
        body: JSON.stringify({ token, email })
      });

      if (response.ok) {
        const data = await response.json();
        return {
          success: true,
          message: data.message
        };
      } else {
        const errorData = await response.json();
        return {
          success: false,
          error: errorData.error?.message || 'Invalid token',
          code: errorData.error?.code
        };
      }
    } catch (error) {
      console.error('Verify token error:', error);
      return {
        success: false,
        error: 'Network error. Please check your connection.',
        code: 'NETWORK_ERROR'
      };
    }
  }

  // =============================================================================
  // Utility Methods
  // =============================================================================

  /**
   * Check if user is authenticated
   * @returns {boolean} Authentication status
   */
  isAuthenticated() {
    return !!localStorage.getItem('auth_token');
  }

  /**
   * Get stored auth token
   * @returns {string|null} Auth token or null
   */
  getToken() {
    return localStorage.getItem('auth_token');
  }

  /**
   * Get cached user data
   * @returns {object|null} User data or null
   */
  getCachedUser() {
    const userData = localStorage.getItem('user_data');
    return userData ? JSON.parse(userData) : null;
  }

  /**
   * Make authenticated API request
   * @param {string} endpoint - API endpoint
   * @param {object} options - Request options
   * @returns {Promise<Response>} Fetch response
   */
  async request(endpoint, options = {}) {
    const url = `${this.baseURL}${endpoint}`;
    
    const headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
      'Origin': window.location.origin,
      ...options.headers
    };

    // Add auth token if available and not already included
    const token = this.getToken();
    if (token && !headers.Authorization) {
      headers.Authorization = `Bearer ${token}`;
    }

    const requestOptions = {
      ...options,
      headers,
      timeout: this.timeout
    };

    return fetch(url, requestOptions);
  }

  /**
   * Get request headers
   * @param {boolean} includeAuth - Include authorization header
   * @returns {object} Headers object
   */
  getHeaders(includeAuth = true) {
    const headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
      'Origin': window.location.origin
    };

    if (includeAuth) {
      const token = this.getToken();
      if (token) {
        headers.Authorization = `Bearer ${token}`;
      }
    }

    return headers;
  }
}

// Create singleton instance
const authAPI = new AuthAPI();

export default authAPI;
EOF
    fi

    print_success "Enhanced src/services/authAPI.js"
}

# =============================================================================
# Component Files Creation
# =============================================================================

create_forgot_password_view() {
    print_step "Creating ForgotPasswordView component ${CODE}"
    
    cat > "src/components/Views/ForgotPasswordView.jsx" << 'EOF'
/**
 * Forgot Password View Component
 * nYtevibe Password Reset Implementation
 * 
 * Handles the initial password reset request workflow
 */

import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import authAPI from '../../services/authAPI';
import { 
  validateForgotPasswordForm, 
  sanitizeIdentifier, 
  getPasswordResetErrorMessage,
  maskEmail,
  formatRetryCountdown 
} from '../../utils/authUtils';

const ForgotPasswordView = () => {
  // Form state
  const [identifier, setIdentifier] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [validationErrors, setValidationErrors] = useState({});

  // Success state
  const [emailSent, setEmailSent] = useState(false);
  const [maskedEmail, setMaskedEmail] = useState('');

  // Rate limiting state
  const [isRateLimited, setIsRateLimited] = useState(false);
  const [retryCountdown, setRetryCountdown] = useState(0);

  // Error state
  const [error, setError] = useState('');

  // Rate limiting countdown effect
  useEffect(() => {
    let interval = null;
    if (isRateLimited && retryCountdown > 0) {
      interval = setInterval(() => {
        setRetryCountdown(prev => {
          if (prev <= 1) {
            setIsRateLimited(false);
            return 0;
          }
          return prev - 1;
        });
      }, 1000);
    }
    return () => clearInterval(interval);
  }, [isRateLimited, retryCountdown]);

  // Clear errors when user types
  useEffect(() => {
    if (identifier) {
      setError('');
      setValidationErrors({});
    }
  }, [identifier]);

  const handleIdentifierChange = (e) => {
    setIdentifier(e.target.value);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    // Clear previous states
    setError('');
    setValidationErrors({});

    // Sanitize and validate input
    const sanitizedIdentifier = sanitizeIdentifier(identifier);
    const validation = validateForgotPasswordForm(sanitizedIdentifier);

    if (!validation.isValid) {
      setValidationErrors(validation.errors);
      return;
    }

    setIsLoading(true);

    try {
      const result = await authAPI.forgotPassword(sanitizedIdentifier);

      if (result.success) {
        setEmailSent(true);
        setMaskedEmail(result.data?.email || maskEmail(sanitizedIdentifier));
        setIdentifier(''); // Clear form
      } else {
        handleError(result);
      }
    } catch (error) {
      console.error('Forgot password error:', error);
      setError('An unexpected error occurred. Please try again.');
    } finally {
      setIsLoading(false);
    }
  };

  const handleError = (result) => {
    const { error, code, retryAfter } = result;

    switch (code) {
      case 'RATE_LIMIT_EXCEEDED':
        setIsRateLimited(true);
        setRetryCountdown(retryAfter || 60);
        break;
      
      default:
        setError(getPasswordResetErrorMessage(error, code, result.data));
        break;
    }
  };

  const handleRetry = () => {
    setError('');
    setValidationErrors({});
    setEmailSent(false);
    setMaskedEmail('');
  };

  return (
    <div className="auth-container">
      <div className="auth-card">
        {/* Header Section */}
        <div className="auth-header">
          <h1>Reset Your Password</h1>
          <p>Enter your email or username to receive a reset link</p>
        </div>

        {/* Success Banner */}
        {emailSent && (
          <div className="success-banner">
            <div className="success-content">
              <div className="success-icon">✅</div>
              <div>
                <p><strong>Reset link sent!</strong></p>
                <p>We've sent a password reset link to <strong>{maskedEmail}</strong></p>
                <small>Check your email and follow the instructions. If you don't see it, check your spam folder.</small>
              </div>
            </div>
            <button 
              onClick={handleRetry}
              className="link-button"
              type="button"
            >
              Send another link
            </button>
          </div>
        )}

        {/* Rate Limiting Banner */}
        {isRateLimited && (
          <div className="rate-limit-banner">
            <div className="rate-limit-content">
              <div className="warning-icon">⏰</div>
              <div>
                <p><strong>Too many attempts</strong></p>
                <p>Please wait <strong>{formatRetryCountdown(retryCountdown)}</strong> before trying again</p>
              </div>
            </div>
          </div>
        )}

        {/* Error Banner */}
        {error && (
          <div className="error-banner">
            <div className="error-content">
              <div className="error-icon">❌</div>
              <div>
                <p>{error}</p>
              </div>
            </div>
          </div>
        )}

        {/* Form Section */}
        {!emailSent && (
          <form onSubmit={handleSubmit} noValidate>
            <div className="form-group">
              <label htmlFor="identifier">Email or Username</label>
              <input
                id="identifier"
                type="text"
                value={identifier}
                onChange={handleIdentifierChange}
                placeholder="Enter your email or username"
                disabled={isLoading || isRateLimited}
                className={validationErrors.identifier ? 'error' : ''}
                autoComplete="username"
                autoFocus
              />
              {validationErrors.identifier && (
                <span className="error-text">{validationErrors.identifier}</span>
              )}
            </div>

            <button
              type="submit"
              disabled={isLoading || isRateLimited || !identifier.trim()}
              className="auth-button primary"
            >
              {isLoading ? (
                <>
                  <span className="loading-spinner"></span>
                  Sending Reset Link...
                </>
              ) : (
                'Send Reset Link'
              )}
            </button>
          </form>
        )}

        {/* Navigation Links */}
        <div className="auth-links">
          <Link to="/login" className="link-button">
            <span className="arrow-left">←</span>
            Back to Login
          </Link>
        </div>

        {/* Help Text */}
        <div className="auth-help">
          <p><strong>Need help?</strong></p>
          <p>If you're having trouble resetting your password, please contact our support team.</p>
        </div>
      </div>
    </div>
  );
};

export default ForgotPasswordView;
EOF

    print_success "Created src/components/Views/ForgotPasswordView.jsx"
}

create_reset_password_view() {
    print_step "Creating ResetPasswordView component ${CODE}"
    
    cat > "src/components/Views/ResetPasswordView.jsx" << 'EOF'
/**
 * Reset Password View Component
 * nYtevibe Password Reset Implementation
 * 
 * Handles password reset form with token validation
 */

import React, { useState, useEffect } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import authAPI from '../../services/authAPI';
import { 
  validatePasswordResetForm, 
  getPasswordStrength,
  getPasswordResetErrorMessage,
  formatRetryCountdown 
} from '../../utils/authUtils';
import { 
  getTokenFromURL, 
  getEmailFromURL, 
  validateResetURL, 
  cleanResetURLParams 
} from '../../utils/urlUtils';

const ResetPasswordView = () => {
  const navigate = useNavigate();

  // URL parameters
  const [token, setToken] = useState('');
  const [email, setEmail] = useState('');

  // Form state
  const [password, setPassword] = useState('');
  const [passwordConfirmation, setPasswordConfirmation] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);

  // UI state
  const [isLoading, setIsLoading] = useState(false);
  const [validationErrors, setValidationErrors] = useState({});
  const [tokenValidated, setTokenValidated] = useState(false);
  const [tokenValidating, setTokenValidating] = useState(true);

  // Success state
  const [resetSuccess, setResetSuccess] = useState(false);
  const [redirectCountdown, setRedirectCountdown] = useState(5);

  // Rate limiting state
  const [isRateLimited, setIsRateLimited] = useState(false);
  const [retryCountdown, setRetryCountdown] = useState(0);

  // Error state
  const [error, setError] = useState('');

  // Initialize token validation on mount
  useEffect(() => {
    const initializeReset = async () => {
      const urlValidation = validateResetURL();
      
      if (!urlValidation.isValid) {
        setError('Invalid reset link. Please request a new password reset.');
        setTokenValidating(false);
        return;
      }

      setToken(urlValidation.token);
      setEmail(urlValidation.email);

      // Validate token with backend
      try {
        const result = await authAPI.verifyResetToken(urlValidation.token, urlValidation.email);
        
        if (result.success) {
          setTokenValidated(true);
        } else {
          setError(getPasswordResetErrorMessage(result.error, result.code));
        }
      } catch (error) {
        console.error('Token validation error:', error);
        setError('Failed to validate reset link. Please try again.');
      }
      
      setTokenValidating(false);
    };

    initializeReset();
  }, []);

  // Rate limiting countdown effect
  useEffect(() => {
    let interval = null;
    if (isRateLimited && retryCountdown > 0) {
      interval = setInterval(() => {
        setRetryCountdown(prev => {
          if (prev <= 1) {
            setIsRateLimited(false);
            return 0;
          }
          return prev - 1;
        });
      }, 1000);
    }
    return () => clearInterval(interval);
  }, [isRateLimited, retryCountdown]);

  // Success redirect countdown effect
  useEffect(() => {
    let interval = null;
    if (resetSuccess && redirectCountdown > 0) {
      interval = setInterval(() => {
        setRedirectCountdown(prev => {
          if (prev <= 1) {
            cleanResetURLParams();
            navigate('/login', { 
              state: { 
                message: 'Password reset successful! You can now log in with your new password.' 
              } 
            });
            return 0;
          }
          return prev - 1;
        });
      }, 1000);
    }
    return () => clearInterval(interval);
  }, [resetSuccess, redirectCountdown, navigate]);

  // Clear errors when user types
  useEffect(() => {
    if (password || passwordConfirmation) {
      setError('');
      setValidationErrors({});
    }
  }, [password, passwordConfirmation]);

  const handlePasswordChange = (e) => {
    setPassword(e.target.value);
  };

  const handlePasswordConfirmationChange = (e) => {
    setPasswordConfirmation(e.target.value);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    // Clear previous states
    setError('');
    setValidationErrors({});

    // Validate form
    const validation = validatePasswordResetForm(password, passwordConfirmation);

    if (!validation.isValid) {
      setValidationErrors(validation.errors);
      return;
    }

    setIsLoading(true);

    try {
      const result = await authAPI.resetPassword(token, email, password, passwordConfirmation);

      if (result.success) {
        setResetSuccess(true);
        setPassword('');
        setPasswordConfirmation('');
      } else {
        handleError(result);
      }
    } catch (error) {
      console.error('Reset password error:', error);
      setError('An unexpected error occurred. Please try again.');
    } finally {
      setIsLoading(false);
    }
  };

  const handleError = (result) => {
    const { error, code, retryAfter, details } = result;

    switch (code) {
      case 'RATE_LIMIT_EXCEEDED':
        setIsRateLimited(true);
        setRetryCountdown(retryAfter || 60);
        break;
      
      case 'VALIDATION_ERROR':
        if (details) {
          setValidationErrors(details);
        } else {
          setError(getPasswordResetErrorMessage(error, code, result.data));
        }
        break;
      
      case 'INVALID_TOKEN':
        setError(getPasswordResetErrorMessage(error, code));
        setTimeout(() => {
          navigate('/forgot-password');
        }, 3000);
        break;
      
      default:
        setError(getPasswordResetErrorMessage(error, code, result.data));
        break;
    }
  };

  const getPasswordStrengthInfo = () => {
    if (!password) return null;
    return getPasswordStrength(password);
  };

  const isFormValid = () => {
    return password && 
           passwordConfirmation && 
           password === passwordConfirmation && 
           getPasswordStrength(password).score >= 4;
  };

  if (tokenValidating) {
    return (
      <div className="auth-container">
        <div className="auth-card">
          <div className="loading-state">
            <span className="loading-spinner"></span>
            <p>Validating reset link...</p>
          </div>
        </div>
      </div>
    );
  }

  if (!tokenValidated) {
    return (
      <div className="auth-container">
        <div className="auth-card">
          <div className="invalid-token">
            <div className="error-icon">❌</div>
            <h2>Invalid Reset Link</h2>
            <p>{error}</p>
            <Link to="/forgot-password" className="auth-button primary">
              Request New Reset Link
            </Link>
          </div>
        </div>
      </div>
    );
  }

  if (resetSuccess) {
    return (
      <div className="auth-container">
        <div className="auth-card">
          <div className="reset-success">
            <div className="success-icon">✅</div>
            <h2>Password Reset Successful</h2>
            <p>Your password has been updated successfully.</p>
            <p>Redirecting to login in <strong>{redirectCountdown}</strong> seconds...</p>
            <Link to="/login" className="auth-button primary">
              Login Now
            </Link>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="auth-container">
      <div className="auth-card">
        {/* Header Section */}
        <div className="auth-header">
          <h1>Set New Password</h1>
          <p>Create a strong, secure password for your account</p>
        </div>

        {/* Rate Limiting Banner */}
        {isRateLimited && (
          <div className="rate-limit-banner">
            <div className="rate-limit-content">
              <div className="warning-icon">⏰</div>
              <div>
                <p><strong>Too many attempts</strong></p>
                <p>Please wait <strong>{formatRetryCountdown(retryCountdown)}</strong> before trying again</p>
              </div>
            </div>
          </div>
        )}

        {/* Error Banner */}
        {error && (
          <div className="error-banner">
            <div className="error-content">
              <div className="error-icon">❌</div>
              <div>
                <p>{error}</p>
              </div>
            </div>
          </div>
        )}

        {/* Form Section */}
        <form onSubmit={handleSubmit} noValidate>
          {/* New Password Field */}
          <div className="form-group">
            <label htmlFor="password">New Password</label>
            <div className="password-input-wrapper">
              <input
                id="password"
                type={showPassword ? 'text' : 'password'}
                value={password}
                onChange={handlePasswordChange}
                placeholder="Enter new password"
                disabled={isLoading || isRateLimited}
                className={validationErrors.password ? 'error' : ''}
                autoComplete="new-password"
              />
              <button
                type="button"
                onClick={() => setShowPassword(!showPassword)}
                className="password-toggle"
                disabled={isLoading || isRateLimited}
              >
                {showPassword ? '👁️' : '👁️‍🗨️'}
              </button>
            </div>
            
            {/* Password Strength Indicator */}
            {password && (
              <div className="password-strength">
                <div className="strength-bar">
                  <div 
                    className="strength-fill" 
                    style={{ 
                      width: `${(getPasswordStrengthInfo()?.score || 0) * 16.67}%`,
                      backgroundColor: getPasswordStrengthInfo()?.color 
                    }}
                  ></div>
                </div>
                <span 
                  className="strength-label"
                  style={{ color: getPasswordStrengthInfo()?.color }}
                >
                  {getPasswordStrengthInfo()?.label}
                </span>
              </div>
            )}
            
            {validationErrors.password && (
              <div className="field-errors">
                {Array.isArray(validationErrors.password) 
                  ? validationErrors.password.map((error, index) => (
                      <span key={index} className="error-text">{error}</span>
                    ))
                  : <span className="error-text">{validationErrors.password}</span>
                }
              </div>
            )}
          </div>

          {/* Confirm Password Field */}
          <div className="form-group">
            <label htmlFor="passwordConfirmation">Confirm Password</label>
            <div className="password-input-wrapper">
              <input
                id="passwordConfirmation"
                type={showConfirmPassword ? 'text' : 'password'}
                value={passwordConfirmation}
                onChange={handlePasswordConfirmationChange}
                placeholder="Confirm new password"
                disabled={isLoading || isRateLimited}
                className={validationErrors.passwordConfirmation ? 'error' : ''}
                autoComplete="new-password"
              />
              <button
                type="button"
                onClick={() => setShowConfirmPassword(!showConfirmPassword)}
                className="password-toggle"
                disabled={isLoading || isRateLimited}
              >
                {showConfirmPassword ? '👁️' : '👁️‍🗨️'}
              </button>
            </div>
            {validationErrors.passwordConfirmation && (
              <span className="error-text">{validationErrors.passwordConfirmation}</span>
            )}
          </div>

          <button
            type="submit"
            disabled={isLoading || isRateLimited || !isFormValid()}
            className="auth-button primary"
          >
            {isLoading ? (
              <>
                <span className="loading-spinner"></span>
                Resetting Password...
              </>
            ) : (
              'Reset Password'
            )}
          </button>
        </form>

        {/* Security Tips */}
        <div className="security-tips">
          <h4>Password Requirements:</h4>
          <ul>
            <li>At least 8 characters long</li>
            <li>Contains uppercase and lowercase letters</li>
            <li>Includes at least one number</li>
            <li>Has at least one special character</li>
          </ul>
        </div>
      </div>
    </div>
  );
};

export default ResetPasswordView;
EOF

    print_success "Created src/components/Views/ResetPasswordView.jsx"
}

# =============================================================================
# Router Configuration
# =============================================================================

update_router_config() {
    print_step "Updating router configuration ${GEAR}"
    
    # Check if AppRouter.jsx exists
    if [ -f "src/router/AppRouter.jsx" ]; then
        backup_file "src/router/AppRouter.jsx"
        
        # Add import statements if not present
        if ! grep -q "ForgotPasswordView" "src/router/AppRouter.jsx"; then
            sed -i '1i import ForgotPasswordView from "../components/Views/ForgotPasswordView";' "src/router/AppRouter.jsx"
        fi
        
        if ! grep -q "ResetPasswordView" "src/router/AppRouter.jsx"; then
            sed -i '2i import ResetPasswordView from "../components/Views/ResetPasswordView";' "src/router/AppRouter.jsx"
        fi
        
        print_info "Added import statements to AppRouter.jsx"
        print_warning "Please manually add the following routes to your router:"
        echo ""
        echo "  <Route path=\"/forgot-password\" element={<ForgotPasswordView />} />"
        echo "  <Route path=\"/reset-password\" element={<ResetPasswordView />} />"
        echo ""
    else
        # Create new router file
        cat > "src/router/AppRouter.jsx" << 'EOF'
/**
 * App Router Configuration
 * nYtevibe Routing System
 */

import React from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';

// Import Views
import LoginView from '../components/Views/LoginView';
import ForgotPasswordView from '../components/Views/ForgotPasswordView';
import ResetPasswordView from '../components/Views/ResetPasswordView';
import HomeView from '../components/Views/HomeView';

// Import Route Components
import ProtectedRoute from './ProtectedRoute';
import PublicRoute from './PublicRoute';

const AppRouter = () => {
  return (
    <Router>
      <Routes>
        {/* Public Routes */}
        <Route 
          path="/login" 
          element={
            <PublicRoute>
              <LoginView />
            </PublicRoute>
          } 
        />
        
        <Route 
          path="/forgot-password" 
          element={
            <PublicRoute>
              <ForgotPasswordView />
            </PublicRoute>
          } 
        />
        
        <Route 
          path="/reset-password" 
          element={
            <PublicRoute>
              <ResetPasswordView />
            </PublicRoute>
          } 
        />

        {/* Protected Routes */}
        <Route 
          path="/home" 
          element={
            <ProtectedRoute>
              <HomeView />
            </ProtectedRoute>
          } 
        />

        {/* Default Routes */}
        <Route path="/" element={<Navigate to="/home" replace />} />
        <Route path="*" element={<Navigate to="/home" replace />} />
      </Routes>
    </Router>
  );
};

export default AppRouter;
EOF
        print_success "Created src/router/AppRouter.jsx"
    fi
}

# =============================================================================
# Style Enhancements
# =============================================================================

create_password_reset_styles() {
    print_step "Creating password reset styles ${STYLE}"
    
    cat > "src/styles/password-reset.css" << 'EOF'
/**
 * Password Reset Styles
 * nYtevibe Password Reset Implementation
 * 
 * Styles for forgot password and reset password components
 */

/* =============================================================================
   Success Banner Styles
   ============================================================================= */

.success-banner {
  background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%);
  border: 1px solid #22c55e;
  border-radius: 16px;
  padding: 20px;
  margin-bottom: 24px;
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
  animation: fadeInUp 0.3s ease-out;
}

.success-content {
  display: flex;
  align-items: flex-start;
  gap: 12px;
  flex: 1;
}

.success-icon {
  font-size: 24px;
  line-height: 1;
  margin-top: 2px;
}

.success-banner p {
  margin: 0 0 4px 0;
  color: #065f46;
  font-weight: 500;
}

.success-banner small {
  color: #047857;
  font-size: 14px;
  line-height: 1.4;
}

/* =============================================================================
   Rate Limiting Banner Styles
   ============================================================================= */

.rate-limit-banner {
  background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
  border: 1px solid #f59e0b;
  border-radius: 16px;
  padding: 20px;
  margin-bottom: 24px;
  display: flex;
  align-items: center;
  gap: 16px;
  animation: shake 0.5s ease-in-out;
}

.rate-limit-content {
  display: flex;
  align-items: center;
  gap: 12px;
}

.warning-icon {
  font-size: 24px;
  line-height: 1;
}

.rate-limit-banner p {
  margin: 0;
  color: #92400e;
}

.rate-limit-banner strong {
  font-family: 'SF Mono', 'Monaco', monospace;
  font-weight: 600;
}

/* =============================================================================
   Error Banner Styles
   ============================================================================= */

.error-banner {
  background: linear-gradient(135deg, #fecaca 0%, #fca5a5 100%);
  border: 1px solid #ef4444;
  border-radius: 16px;
  padding: 20px;
  margin-bottom: 24px;
  display: flex;
  align-items: center;
  gap: 16px;
  animation: fadeInUp 0.3s ease-out;
}

.error-content {
  display: flex;
  align-items: center;
  gap: 12px;
}

.error-icon {
  font-size: 24px;
  line-height: 1;
}

.error-banner p {
  margin: 0;
  color: #991b1b;
  font-weight: 500;
}

/* =============================================================================
   Password Input Styles
   ============================================================================= */

.password-input-wrapper {
  position: relative;
  display: flex;
  align-items: center;
}

.password-input-wrapper input {
  flex: 1;
  padding-right: 48px;
}

.password-toggle {
  position: absolute;
  right: 12px;
  background: none;
  border: none;
  cursor: pointer;
  padding: 4px;
  font-size: 18px;
  color: #6b7280;
  transition: color 0.2s ease;
}

.password-toggle:hover {
  color: #374151;
}

.password-toggle:disabled {
  cursor: not-allowed;
  opacity: 0.5;
}

/* =============================================================================
   Password Strength Indicator
   ============================================================================= */

.password-strength {
  margin-top: 8px;
  display: flex;
  align-items: center;
  gap: 12px;
}

.strength-bar {
  flex: 1;
  height: 4px;
  background-color: #e5e7eb;
  border-radius: 2px;
  overflow: hidden;
}

.strength-fill {
  height: 100%;
  transition: width 0.3s ease, background-color 0.3s ease;
  border-radius: 2px;
}

.strength-label {
  font-size: 12px;
  font-weight: 600;
  transition: color 0.3s ease;
  min-width: 80px;
  text-align: right;
}

/* =============================================================================
   Field Error Styles
   ============================================================================= */

.field-errors {
  margin-top: 8px;
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.field-errors .error-text {
  font-size: 14px;
  color: #ef4444;
  line-height: 1.4;
}

/* =============================================================================
   Loading and Success States
   ============================================================================= */

.loading-state {
  text-align: center;
  padding: 40px 20px;
}

.loading-state .loading-spinner {
  display: inline-block;
  margin-bottom: 16px;
}

.loading-state p {
  color: #6b7280;
  font-size: 16px;
}

.invalid-token {
  text-align: center;
  padding: 40px 20px;
}

.invalid-token .error-icon {
  font-size: 48px;
  margin-bottom: 16px;
  display: block;
}

.invalid-token h2 {
  color: #ef4444;
  margin: 0 0 12px 0;
  font-size: 24px;
}

.invalid-token p {
  color: #6b7280;
  margin: 0 0 24px 0;
  line-height: 1.6;
}

.reset-success {
  text-align: center;
  padding: 40px 20px;
}

.reset-success .success-icon {
  font-size: 48px;
  margin-bottom: 16px;
  display: block;
}

.reset-success h2 {
  color: #22c55e;
  margin: 0 0 12px 0;
  font-size: 24px;
}

.reset-success p {
  color: #6b7280;
  margin: 0 0 12px 0;
  line-height: 1.6;
}

.reset-success strong {
  color: #374151;
}

/* =============================================================================
   Security Tips Styles
   ============================================================================= */

.security-tips {
  margin-top: 24px;
  padding: 16px;
  background: #f8fafc;
  border-radius: 12px;
  border: 1px solid #e2e8f0;
}

.security-tips h4 {
  margin: 0 0 12px 0;
  font-size: 14px;
  font-weight: 600;
  color: #374151;
}

.security-tips ul {
  margin: 0;
  padding-left: 20px;
  list-style-type: disc;
}

.security-tips li {
  font-size: 14px;
  color: #6b7280;
  line-height: 1.4;
  margin-bottom: 4px;
}

.security-tips li:last-child {
  margin-bottom: 0;
}

/* =============================================================================
   Help Text Styles
   ============================================================================= */

.auth-help {
  margin-top: 24px;
  padding: 16px;
  text-align: center;
  background: #f8fafc;
  border-radius: 12px;
  border: 1px solid #e2e8f0;
}

.auth-help p {
  margin: 0 0 8px 0;
  font-size: 14px;
  line-height: 1.5;
}

.auth-help p:last-child {
  margin-bottom: 0;
}

.auth-help strong {
  color: #374151;
}

/* =============================================================================
   Link Button Enhancements
   ============================================================================= */

.link-button {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  font-size: 14px;
  color: #6366f1;
  text-decoration: none;
  transition: color 0.2s ease;
}

.link-button:hover {
  color: #4f46e5;
  text-decoration: underline;
}

.arrow-left {
  font-size: 16px;
  line-height: 1;
}

/* =============================================================================
   Loading Spinner Enhancement
   ============================================================================= */

.loading-spinner {
  display: inline-block;
  width: 16px;
  height: 16px;
  border: 2px solid transparent;
  border-top: 2px solid currentColor;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin-right: 8px;
}

@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

/* =============================================================================
   Responsive Design
   ============================================================================= */

@media (max-width: 768px) {
  .success-banner,
  .rate-limit-banner,
  .error-banner {
    padding: 16px;
    border-radius: 12px;
  }
  
  .success-content,
  .rate-limit-content,
  .error-content {
    gap: 8px;
  }
  
  .success-icon,
  .warning-icon,
  .error-icon {
    font-size: 20px;
  }
  
  .password-toggle {
    right: 8px;
    font-size: 16px;
  }
  
  .strength-label {
    min-width: 60px;
    font-size: 11px;
  }
}

/* =============================================================================
   Animation Keyframes
   ============================================================================= */

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes shake {
  0%, 100% { transform: translateX(0); }
  25% { transform: translateX(-5px); }
  75% { transform: translateX(5px); }
}

/* =============================================================================
   Dark Mode Support (if applicable)
   ============================================================================= */

@media (prefers-color-scheme: dark) {
  .security-tips,
  .auth-help {
    background: #1f2937;
    border-color: #374151;
  }
  
  .security-tips h4 {
    color: #f9fafb;
  }
  
  .security-tips li {
    color: #d1d5db;
  }
  
  .auth-help p {
    color: #d1d5db;
  }
  
  .auth-help strong {
    color: #f9fafb;
  }
}
EOF

    print_success "Created src/styles/password-reset.css"
}

# =============================================================================
# Test Files Creation
# =============================================================================

create_test_files() {
    print_step "Creating test files ${TEST}"
    
    # ForgotPasswordView test
    cat > "src/__tests__/components/Views/ForgotPasswordView.test.js" << 'EOF'
/**
 * ForgotPasswordView Component Tests
 * nYtevibe Password Reset Testing
 */

import React from 'react';
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import { BrowserRouter } from 'react-router-dom';
import ForgotPasswordView from '../../../components/Views/ForgotPasswordView';
import authAPI from '../../../services/authAPI';

// Mock the authAPI
jest.mock('../../../services/authAPI', () => ({
  forgotPassword: jest.fn()
}));

const MockedForgotPasswordView = () => (
  <BrowserRouter>
    <ForgotPasswordView />
  </BrowserRouter>
);

describe('ForgotPasswordView', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  test('renders forgot password form correctly', () => {
    render(<MockedForgotPasswordView />);
    
    expect(screen.getByText('Reset Your Password')).toBeInTheDocument();
    expect(screen.getByLabelText('Email or Username')).toBeInTheDocument();
    expect(screen.getByRole('button', { name: 'Send Reset Link' })).toBeInTheDocument();
    expect(screen.getByText('Back to Login')).toBeInTheDocument();
  });

  test('validates empty input', async () => {
    render(<MockedForgotPasswordView />);
    
    const submitButton = screen.getByRole('button', { name: 'Send Reset Link' });
    expect(submitButton).toBeDisabled();
  });

  test('validates email input correctly', async () => {
    render(<MockedForgotPasswordView />);
    
    const input = screen.getByLabelText('Email or Username');
    const submitButton = screen.getByRole('button', { name: 'Send Reset Link' });
    
    // Test valid email
    fireEvent.change(input, { target: { value: 'test@example.com' } });
    expect(submitButton).not.toBeDisabled();
    
    // Test valid username
    fireEvent.change(input, { target: { value: 'testuser' } });
    expect(submitButton).not.toBeDisabled();
  });

  test('handles successful email submission', async () => {
    authAPI.forgotPassword.mockResolvedValue({
      success: true,
      data: { email: 't***@example.com' }
    });

    render(<MockedForgotPasswordView />);
    
    const input = screen.getByLabelText('Email or Username');
    const submitButton = screen.getByRole('button', { name: 'Send Reset Link' });
    
    fireEvent.change(input, { target: { value: 'test@example.com' } });
    fireEvent.click(submitButton);

    await waitFor(() => {
      expect(screen.getByText(/Reset link sent!/)).toBeInTheDocument();
      expect(screen.getByText(/t\*\*\*@example\.com/)).toBeInTheDocument();
    });
  });

  test('handles rate limiting correctly', async () => {
    authAPI.forgotPassword.mockResolvedValue({
      success: false,
      code: 'RATE_LIMIT_EXCEEDED',
      retryAfter: 60
    });

    render(<MockedForgotPasswordView />);
    
    const input = screen.getByLabelText('Email or Username');
    const submitButton = screen.getByRole('button', { name: 'Send Reset Link' });
    
    fireEvent.change(input, { target: { value: 'test@example.com' } });
    fireEvent.click(submitButton);

    await waitFor(() => {
      expect(screen.getByText(/Too many attempts/)).toBeInTheDocument();
    });
  });

  test('handles user not found gracefully', async () => {
    authAPI.forgotPassword.mockResolvedValue({
      success: false,
      code: 'USER_NOT_FOUND'
    });

    render(<MockedForgotPasswordView />);
    
    const input = screen.getByLabelText('Email or Username');
    const submitButton = screen.getByRole('button', { name: 'Send Reset Link' });
    
    fireEvent.change(input, { target: { value: 'nonexistent@example.com' } });
    fireEvent.click(submitButton);

    await waitFor(() => {
      expect(screen.getByText(/If an account with that email exists/)).toBeInTheDocument();
    });
  });
});
EOF

    # ResetPasswordView test
    cat > "src/__tests__/components/Views/ResetPasswordView.test.js" << 'EOF'
/**
 * ResetPasswordView Component Tests
 * nYtevibe Password Reset Testing
 */

import React from 'react';
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import { BrowserRouter } from 'react-router-dom';
import ResetPasswordView from '../../../components/Views/ResetPasswordView';
import authAPI from '../../../services/authAPI';

// Mock the authAPI
jest.mock('../../../services/authAPI', () => ({
  verifyResetToken: jest.fn(),
  resetPassword: jest.fn()
}));

// Mock URL search params
const mockSearchParams = new URLSearchParams();
mockSearchParams.set('token', 'test-token');
mockSearchParams.set('email', 'test@example.com');

Object.defineProperty(window, 'location', {
  value: {
    search: mockSearchParams.toString()
  },
  writable: true
});

const MockedResetPasswordView = () => (
  <BrowserRouter>
    <ResetPasswordView />
  </BrowserRouter>
);

describe('ResetPasswordView', () => {
  beforeEach(() => {
    jest.clearAllMocks();
    window.location.search = mockSearchParams.toString();
  });

  test('validates token on component mount', async () => {
    authAPI.verifyResetToken.mockResolvedValue({ success: true });
    
    render(<MockedResetPasswordView />);
    
    await waitFor(() => {
      expect(authAPI.verifyResetToken).toHaveBeenCalledWith('test-token', 'test@example.com');
    });
  });

  test('shows invalid token message for expired tokens', async () => {
    authAPI.verifyResetToken.mockResolvedValue({
      success: false,
      code: 'INVALID_TOKEN'
    });
    
    render(<MockedResetPasswordView />);
    
    await waitFor(() => {
      expect(screen.getByText('Invalid Reset Link')).toBeInTheDocument();
      expect(screen.getByText('Request New Reset Link')).toBeInTheDocument();
    });
  });

  test('validates password strength correctly', async () => {
    authAPI.verifyResetToken.mockResolvedValue({ success: true });
    
    render(<MockedResetPasswordView />);
    
    await waitFor(() => {
      expect(screen.getByLabelText('New Password')).toBeInTheDocument();
    });
    
    const passwordInput = screen.getByLabelText('New Password');
    
    // Test weak password
    fireEvent.change(passwordInput, { target: { value: 'weak' } });
    
    await waitFor(() => {
      expect(screen.getByText('Very Weak')).toBeInTheDocument();
    });
    
    // Test strong password
    fireEvent.change(passwordInput, { target: { value: 'StrongPass123!' } });
    
    await waitFor(() => {
      expect(screen.getByText('Strong')).toBeInTheDocument();
    });
  });

  test('validates password confirmation matching', async () => {
    authAPI.verifyResetToken.mockResolvedValue({ success: true });
    
    render(<MockedResetPasswordView />);
    
    await waitFor(() => {
      expect(screen.getByLabelText('New Password')).toBeInTheDocument();
    });
    
    const passwordInput = screen.getByLabelText('New Password');
    const confirmInput = screen.getByLabelText('Confirm Password');
    
    fireEvent.change(passwordInput, { target: { value: 'StrongPass123!' } });
    fireEvent.change(confirmInput, { target: { value: 'DifferentPass123!' } });
    
    const submitButton = screen.getByRole('button', { name: 'Reset Password' });
    fireEvent.click(submitButton);
    
    await waitFor(() => {
      expect(screen.getByText('Passwords do not match')).toBeInTheDocument();
    });
  });

  test('successfully resets password', async () => {
    authAPI.verifyResetToken.mockResolvedValue({ success: true });
    authAPI.resetPassword.mockResolvedValue({ success: true });
    
    render(<MockedResetPasswordView />);
    
    await waitFor(() => {
      expect(screen.getByLabelText('New Password')).toBeInTheDocument();
    });
    
    const passwordInput = screen.getByLabelText('New Password');
    const confirmInput = screen.getByLabelText('Confirm Password');
    const submitButton = screen.getByRole('button', { name: 'Reset Password' });
    
    fireEvent.change(passwordInput, { target: { value: 'StrongPass123!' } });
    fireEvent.change(confirmInput, { target: { value: 'StrongPass123!' } });
    fireEvent.click(submitButton);
    
    await waitFor(() => {
      expect(screen.getByText('Password Reset Successful')).toBeInTheDocument();
    });
  });
});
EOF

    # AuthAPI tests
    cat > "src/__tests__/services/authAPI.test.js" << 'EOF'
/**
 * AuthAPI Service Tests
 * nYtevibe Authentication API Testing
 */

import authAPI from '../../services/authAPI';

// Mock fetch
global.fetch = jest.fn();

describe('AuthAPI Password Reset Methods', () => {
  beforeEach(() => {
    jest.clearAllMocks();
    localStorage.clear();
  });

  describe('forgotPassword', () => {
    test('handles successful password reset request', async () => {
      const mockResponse = {
        ok: true,
        json: () => Promise.resolve({
          success: true,
          data: { email: 't***@example.com' },
          message: 'Reset link sent'
        })
      };
      
      fetch.mockResolvedValue(mockResponse);
      
      const result = await authAPI.forgotPassword('test@example.com');
      
      expect(result.success).toBe(true);
      expect(result.data.email).toBe('t***@example.com');
    });

    test('handles user not found error', async () => {
      const mockResponse = {
        ok: false,
        json: () => Promise.resolve({
          error: {
            code: 'USER_NOT_FOUND',
            message: 'User not found'
          }
        })
      };
      
      fetch.mockResolvedValue(mockResponse);
      
      const result = await authAPI.forgotPassword('nonexistent@example.com');
      
      expect(result.success).toBe(false);
      expect(result.code).toBe('USER_NOT_FOUND');
    });

    test('handles rate limiting', async () => {
      const mockResponse = {
        ok: false,
        json: () => Promise.resolve({
          error: {
            code: 'RATE_LIMIT_EXCEEDED',
            message: 'Too many attempts',
            retry_after: 60
          }
        })
      };
      
      fetch.mockResolvedValue(mockResponse);
      
      const result = await authAPI.forgotPassword('test@example.com');
      
      expect(result.success).toBe(false);
      expect(result.code).toBe('RATE_LIMIT_EXCEEDED');
      expect(result.retryAfter).toBe(60);
    });
  });

  describe('resetPassword', () => {
    test('handles successful password reset', async () => {
      const mockResponse = {
        ok: true,
        json: () => Promise.resolve({
          success: true,
          message: 'Password reset successfully'
        })
      };
      
      fetch.mockResolvedValue(mockResponse);
      
      const result = await authAPI.resetPassword(
        'test-token',
        'test@example.com',
        'NewPass123!',
        'NewPass123!'
      );
      
      expect(result.success).toBe(true);
    });

    test('handles invalid token error', async () => {
      const mockResponse = {
        ok: false,
        json: () => Promise.resolve({
          error: {
            code: 'INVALID_TOKEN',
            message: 'Invalid or expired token'
          }
        })
      };
      
      fetch.mockResolvedValue(mockResponse);
      
      const result = await authAPI.resetPassword(
        'invalid-token',
        'test@example.com',
        'NewPass123!',
        'NewPass123!'
      );
      
      expect(result.success).toBe(false);
      expect(result.code).toBe('INVALID_TOKEN');
    });
  });

  describe('verifyResetToken', () => {
    test('handles valid token', async () => {
      const mockResponse = {
        ok: true,
        json: () => Promise.resolve({
          success: true,
          message: 'Token is valid'
        })
      };
      
      fetch.mockResolvedValue(mockResponse);
      
      const result = await authAPI.verifyResetToken('test-token', 'test@example.com');
      
      expect(result.success).toBe(true);
    });

    test('handles invalid token', async () => {
      const mockResponse = {
        ok: false,
        json: () => Promise.resolve({
          error: {
            code: 'INVALID_TOKEN',
            message: 'Invalid token'
          }
        })
      };
      
      fetch.mockResolvedValue(mockResponse);
      
      const result = await authAPI.verifyResetToken('invalid-token', 'test@example.com');
      
      expect(result.success).toBe(false);
      expect(result.code).toBe('INVALID_TOKEN');
    });
  });
});
EOF

    # Utility tests
    cat > "src/__tests__/utils/urlUtils.test.js" << 'EOF'
/**
 * URL Utils Tests
 * nYtevibe URL Utilities Testing
 */

import {
  getTokenFromURL,
  getEmailFromURL,
  validateResetURL,
  cleanResetURLParams,
  buildResetURL
} from '../../utils/urlUtils';

describe('URL Utils', () => {
  beforeEach(() => {
    // Mock window.location
    delete window.location;
    window.location = {
      search: '',
      origin: 'https://blackaxl.com'
    };
  });

  describe('getTokenFromURL', () => {
    test('extracts token from URL parameters', () => {
      window.location.search = '?token=test-token&email=test@example.com';
      expect(getTokenFromURL()).toBe('test-token');
    });

    test('returns null when no token parameter', () => {
      window.location.search = '?email=test@example.com';
      expect(getTokenFromURL()).toBeNull();
    });
  });

  describe('getEmailFromURL', () => {
    test('extracts email from URL parameters', () => {
      window.location.search = '?token=test-token&email=test@example.com';
      expect(getEmailFromURL()).toBe('test@example.com');
    });

    test('returns null when no email parameter', () => {
      window.location.search = '?token=test-token';
      expect(getEmailFromURL()).toBeNull();
    });
  });

  describe('validateResetURL', () => {
    test('validates complete reset URL', () => {
      window.location.search = '?token=test-token&email=test@example.com';
      const result = validateResetURL();
      
      expect(result.isValid).toBe(true);
      expect(result.token).toBe('test-token');
      expect(result.email).toBe('test@example.com');
      expect(result.errors).toHaveLength(0);
    });

    test('invalidates URL missing token', () => {
      window.location.search = '?email=test@example.com';
      const result = validateResetURL();
      
      expect(result.isValid).toBe(false);
      expect(result.errors).toContain('Reset token is missing from the URL');
    });

    test('invalidates URL missing email', () => {
      window.location.search = '?token=test-token';
      const result = validateResetURL();
      
      expect(result.isValid).toBe(false);
      expect(result.errors).toContain('Email is missing from the URL');
    });

    test('invalidates URL with invalid email format', () => {
      window.location.search = '?token=test-token&email=invalid-email';
      const result = validateResetURL();
      
      expect(result.isValid).toBe(false);
      expect(result.errors).toContain('Invalid email format in URL');
    });
  });

  describe('buildResetURL', () => {
    test('builds complete reset URL', () => {
      const url = buildResetURL('test-token', 'test@example.com');
      expect(url).toBe('https://blackaxl.com/reset-password?token=test-token&email=test%40example.com');
    });
  });
});
EOF

    cat > "src/__tests__/utils/authUtils.test.js" << 'EOF'
/**
 * Auth Utils Tests
 * nYtevibe Authentication Utilities Testing
 */

import {
  validateForgotPasswordForm,
  validatePasswordResetForm,
  validatePasswordStrength,
  getPasswordStrength,
  maskEmail,
  formatRetryCountdown
} from '../../utils/authUtils';

describe('Auth Utils', () => {
  describe('validateForgotPasswordForm', () => {
    test('validates correct email', () => {
      const result = validateForgotPasswordForm('test@example.com');
      expect(result.isValid).toBe(true);
      expect(result.errors).toEqual({});
    });

    test('validates correct username', () => {
      const result = validateForgotPasswordForm('testuser');
      expect(result.isValid).toBe(true);
      expect(result.errors).toEqual({});
    });

    test('invalidates empty input', () => {
      const result = validateForgotPasswordForm('');
      expect(result.isValid).toBe(false);
      expect(result.errors.identifier).toBe('Email or username is required');
    });

    test('invalidates too short input', () => {
      const result = validateForgotPasswordForm('ab');
      expect(result.isValid).toBe(false);
      expect(result.errors.identifier).toBe('Please enter a valid email or username');
    });
  });

  describe('validatePasswordStrength', () => {
    test('validates strong password', () => {
      const errors = validatePasswordStrength('StrongPass123!');
      expect(errors).toHaveLength(0);
    });

    test('invalidates weak password', () => {
      const errors = validatePasswordStrength('weak');
      expect(errors.length).toBeGreaterThan(0);
      expect(errors).toContain('Password must be at least 8 characters long');
    });

    test('requires uppercase letter', () => {
      const errors = validatePasswordStrength('lowercase123!');
      expect(errors).toContain('Password must contain at least one uppercase letter');
    });

    test('requires special character', () => {
      const errors = validatePasswordStrength('NoSpecial123');
      expect(errors).toContain('Password must contain at least one special character');
    });
  });

  describe('getPasswordStrength', () => {
    test('rates strong password correctly', () => {
      const strength = getPasswordStrength('VeryStrongPass123!');
      expect(strength.score).toBeGreaterThanOrEqual(5);
      expect(strength.label).toMatch(/Strong/);
    });

    test('rates weak password correctly', () => {
      const strength = getPasswordStrength('weak');
      expect(strength.score).toBeLessThan(3);
      expect(strength.label).toMatch(/Weak/);
    });
  });

  describe('maskEmail', () => {
    test('masks email correctly', () => {
      expect(maskEmail('test@example.com')).toBe('t**t@example.com');
      expect(maskEmail('a@example.com')).toBe('a@example.com');
      expect(maskEmail('ab@example.com')).toBe('ab@example.com');
    });

    test('handles invalid email', () => {
      expect(maskEmail('invalid')).toBe('');
      expect(maskEmail('')).toBe('');
    });
  });

  describe('formatRetryCountdown', () => {
    test('formats seconds correctly', () => {
      expect(formatRetryCountdown(30)).toBe('30s');
      expect(formatRetryCountdown(5)).toBe('5s');
    });

    test('formats minutes and seconds correctly', () => {
      expect(formatRetryCountdown(90)).toBe('1:30');
      expect(formatRetryCountdown(125)).toBe('2:05');
    });
  });
});
EOF

    print_success "Created comprehensive test files"
}

# =============================================================================
# Update LoginView
# =============================================================================

update_login_view() {
    print_step "Updating LoginView with forgot password link ${CODE}"
    
    if [ -f "src/components/Views/LoginView.jsx" ]; then
        backup_file "src/components/Views/LoginView.jsx"
        
        # Check if forgot password link already exists
        if ! grep -q "forgot-password" "src/components/Views/LoginView.jsx"; then
            print_info "Adding forgot password link to LoginView"
            
            # Create a simple patch instruction file
            cat > "LOGIN_VIEW_UPDATE_INSTRUCTIONS.md" << 'EOF'
# LoginView Update Instructions

Please manually add the following forgot password link to your LoginView component:

## Add this import at the top:
```javascript
import { Link } from 'react-router-dom';
```

## Add this link after the password field (before the submit button):
```javascript
<div className="auth-links">
  <Link to="/forgot-password" className="forgot-password-link">
    Forgot your password?
  </Link>
</div>
```

## Or add it after the submit button:
```javascript
{/* Navigation Links */}
<div className="auth-links">
  <Link to="/forgot-password" className="link-button">
    Forgot your password?
  </Link>
</div>
```

The exact placement depends on your current LoginView structure.
EOF
            
            print_warning "Created LOGIN_VIEW_UPDATE_INSTRUCTIONS.md with manual update instructions"
        else
            print_info "Forgot password link already exists in LoginView"
        fi
    else
        print_warning "LoginView.jsx not found. Please manually add forgot password link."
    fi
}

# =============================================================================
# Package.json Updates
# =============================================================================

update_package_json() {
    print_step "Checking package.json dependencies ${GEAR}"
    
    # Check if required dependencies exist
    if [ -f "package.json" ]; then
        if ! grep -q "react-router-dom" package.json; then
            print_warning "react-router-dom not found in package.json"
            print_info "Please run: npm install react-router-dom"
        fi
        
        print_info "Dependencies check complete"
    fi
}

# =============================================================================
# Import Update Script
# =============================================================================

create_import_update_script() {
    print_step "Creating import update helper script ${GEAR}"
    
    cat > "update-imports.sh" << 'EOF'
#!/bin/bash

# Helper script to add necessary imports to existing files
# Run this after the main setup to ensure all imports are correct

echo "🔄 Updating imports in existing files..."

# Update App.jsx if it exists
if [ -f "src/App.jsx" ]; then
    echo "📝 Updating App.jsx imports..."
    if ! grep -q "password-reset.css" "src/App.jsx"; then
        sed -i '1i import "./styles/password-reset.css";' "src/App.jsx"
        echo "✅ Added password-reset.css import to App.jsx"
    fi
fi

# Update main.jsx if it exists
if [ -f "src/main.jsx" ]; then
    echo "📝 Checking main.jsx..."
    if ! grep -q "password-reset.css" "src/main.jsx"; then
        sed -i '1i import "./styles/password-reset.css";' "src/main.jsx"
        echo "✅ Added password-reset.css import to main.jsx"
    fi
fi

echo "✅ Import updates complete!"
EOF

    chmod +x "update-imports.sh"
    print_success "Created update-imports.sh helper script"
}

# =============================================================================
# Final Documentation
# =============================================================================

create_implementation_guide() {
    print_step "Creating implementation guide ${FILE}"
    
    cat > "FORGOT_PASSWORD_IMPLEMENTATION_GUIDE.md" << 'EOF'
# nYtevibe Forgot Password Implementation Guide

## 🎉 Setup Complete!

The forgot password feature implementation is now ready. This guide will help you complete the integration.

## 📁 Files Created

### Components
- `src/components/Views/ForgotPasswordView.jsx` - Initial password reset form
- `src/components/Views/ResetPasswordView.jsx` - Password reset form with token validation

### Services
- `src/services/authAPI.js` - Enhanced with password reset methods
  - `forgotPassword(identifier)`
  - `resetPassword(token, email, password, passwordConfirmation)`
  - `verifyResetToken(token, email)`

### Utilities
- `src/utils/urlUtils.js` - URL token handling utilities
- `src/utils/authUtils.js` - Enhanced with password reset validation

### Styles
- `src/styles/password-reset.css` - Complete styling for password reset components

### Tests
- `src/__tests__/components/Views/ForgotPasswordView.test.js`
- `src/__tests__/components/Views/ResetPasswordView.test.js`
- `src/__tests__/services/authAPI.test.js`
- `src/__tests__/utils/urlUtils.test.js`
- `src/__tests__/utils/authUtils.test.js`

## 🔧 Manual Integration Steps

### 1. Update Your Router

Add these routes to your router configuration:

```javascript
import ForgotPasswordView from '../components/Views/ForgotPasswordView';
import ResetPasswordView from '../components/Views/ResetPasswordView';

// Add to your routes:
<Route path="/forgot-password" element={<ForgotPasswordView />} />
<Route path="/reset-password" element={<ResetPasswordView />} />
```

### 2. Update LoginView

Add a "Forgot Password?" link to your login form:

```javascript
import { Link } from 'react-router-dom';

// Add after password field:
<div className="auth-links">
  <Link to="/forgot-password" className="forgot-password-link">
    Forgot your password?
  </Link>
</div>
```

### 3. Import Styles

Add the password reset styles to your main CSS file or App.jsx:

```javascript
import "./styles/password-reset.css";
```

### 4. Update AuthAPI (if needed)

If you already have an authAPI service, merge the new methods from the created file.

## 🚀 Testing the Implementation

### 1. Start your development server
```bash
npm start
```

### 2. Test the flow:
1. Go to `/login`
2. Click "Forgot your password?"
3. Enter email/username and submit
4. Check browser console for API calls
5. Test with reset URL: `/reset-password?token=test&email=test@example.com`

### 3. Run tests:
```bash
npm test
```

## 🔗 API Integration

The components are configured to work with your backend at `https://system.nytevibe.com/api`.

Endpoints used:
- `POST /auth/forgot-password`
- `POST /auth/reset-password`
- `POST /auth/verify-reset-token`

## 🎨 Styling

The components use your existing nYtevibe design system and include:
- Success/error banners
- Rate limiting indicators
- Password strength meters
- Loading states
- Responsive design

## 🛠️ Customization

### Colors
Update CSS variables in `password-reset.css`:
```css
:root {
  --primary-color: #6366f1;
  --success-color: #22c55e;
  --error-color: #ef4444;
  --warning-color: #f59e0b;
}
```

### Messages
Customize error messages in `authUtils.js`:
```javascript
export const getPasswordResetErrorMessage = (error, code, data) => {
  // Customize messages here
};
```

## 🔍 Troubleshooting

### Common Issues:

1. **Router not working**: Ensure React Router is installed and configured
2. **Styles not applied**: Import the CSS file in your main component
3. **API calls failing**: Check CORS settings and API endpoint URLs
4. **Tests failing**: Install testing dependencies and mock functions

### Debug Commands:

```javascript
// Check authAPI integration
console.log('Auth API methods:', Object.getOwnPropertyNames(authAPI));

// Test password strength
import { getPasswordStrength } from './utils/authUtils';
console.log(getPasswordStrength('TestPass123!'));

// Test URL utilities
import { validateResetURL } from './utils/urlUtils';
console.log(validateResetURL());
```

## 📋 Next Steps

1. ✅ Complete manual integration steps above
2. ✅ Test the complete flow
3. ✅ Run all tests and ensure they pass
4. ✅ Customize styling to match your design
5. ✅ Deploy to production

## 🎯 Production Checklist

- [ ] All tests passing
- [ ] Error handling tested
- [ ] Rate limiting tested
- [ ] Email integration verified
- [ ] Mobile responsiveness checked
- [ ] Accessibility compliance verified
- [ ] Security review completed

## 🆘 Support

If you encounter any issues:

1. Check the console for error messages
2. Verify API endpoints are working
3. Ensure all dependencies are installed
4. Check the test files for examples

The implementation follows the same patterns as your existing login system and should integrate seamlessly with your nYtevibe application.

---

**Status: 🟢 Ready for Integration**

Your forgot password feature is complete and ready to be integrated into your production application!
EOF

    print_success "Created FORGOT_PASSWORD_IMPLEMENTATION_GUIDE.md"
}

# =============================================================================
# Main Execution
# =============================================================================

main() {
    print_header "nYtevibe Forgot Password Implementation Setup ${ROCKET}"
    
    print_info "This script will create all necessary files for the forgot password feature"
    print_info "Based on the comprehensive implementation plan and your existing login system"
    echo ""
    
    # Project validation
    validate_project
    
    # Setup directory structure
    setup_directories
    
    # Create utility files
    create_url_utils
    enhance_auth_utils
    
    # Create/enhance service files
    enhance_auth_api
    
    # Create component files
    create_forgot_password_view
    create_reset_password_view
    
    # Update router configuration
    update_router_config
    
    # Create styles
    create_password_reset_styles
    
    # Create test files
    create_test_files
    
    # Update existing files
    update_login_view
    update_package_json
    
    # Create helper scripts and documentation
    create_import_update_script
    create_implementation_guide
    
    # Final summary
    print_header "Setup Complete! ${CHECK}"
    
    print_success "All files have been created successfully!"
    echo ""
    print_info "📋 Next steps:"
    echo "  1. Read FORGOT_PASSWORD_IMPLEMENTATION_GUIDE.md for integration instructions"
    echo "  2. Update your router with the new routes"
    echo "  3. Add the forgot password link to your LoginView"
    echo "  4. Import the password-reset.css styles"
    echo "  5. Run ./update-imports.sh to update import statements"
    echo "  6. Test the implementation"
    echo ""
    print_info "📖 Files to review:"
    echo "  • FORGOT_PASSWORD_IMPLEMENTATION_GUIDE.md - Complete integration guide"
    echo "  • LOGIN_VIEW_UPDATE_INSTRUCTIONS.md - LoginView update instructions"
    echo "  • update-imports.sh - Helper script for imports"
    echo ""
    print_warning "⚠️  Manual steps required:"
    echo "  • Update router configuration"
    echo "  • Add forgot password link to LoginView"
    echo "  • Import CSS styles"
    echo ""
    print_success "🎉 Your nYtevibe forgot password feature is ready for integration!"
    echo ""
    print_info "Run the following to test:"
    echo "  npm test                    # Run all tests"
    echo "  npm start                   # Start development server"
    echo "  ./update-imports.sh         # Update import statements"
    echo ""
}

# Execute main function
main "$@"
EOF
