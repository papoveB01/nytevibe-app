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
