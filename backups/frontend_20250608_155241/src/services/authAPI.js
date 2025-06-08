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
