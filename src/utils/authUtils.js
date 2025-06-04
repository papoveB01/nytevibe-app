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
