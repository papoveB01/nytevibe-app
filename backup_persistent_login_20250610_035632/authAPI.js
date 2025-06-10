/**
 * Authentication API Service
 * nYtevibe Authentication System
 * 
 * Centralized API service for all authentication operations
 * including login, logout, password reset, and user management
 * 
 * Updated: Added 30-day persistent login functionality
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
   * User login with remember me functionality
   * @param {string} identifier - User email or username
   * @param {string} password - User password
   * @param {boolean} rememberMe - Keep user logged in for 30 days
   * @returns {Promise<{success: boolean, user?: object, token?: string, error?: string}>}
   */
  async login(identifier, password, rememberMe = false) {
    try {
      const response = await this.request('/auth/login', {
        method: 'POST',
        body: JSON.stringify({ 
          login: identifier,  // Backend expects 'login' field
          password, 
          remember_me: rememberMe 
        })
      });

      if (response.ok) {
        const data = await response.json();
        
        // Store token with expiration metadata
        const tokenData = {
          token: data.data.token,
          expires_at: data.data.expires_at || (rememberMe 
            ? new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString() // 30 days
            : new Date(Date.now() + 24 * 60 * 60 * 1000).toISOString()),  // 24 hours
          remember_me: rememberMe,
          created_at: new Date().toISOString()
        };
        
        // Store all auth data
        localStorage.setItem('auth_token', data.data.token);
        localStorage.setItem('auth_token_data', JSON.stringify(tokenData));
        localStorage.setItem('user_data', JSON.stringify(data.data.user));
        
        return {
          success: true,
          user: data.data.user,
          token: data.data.token,
          message: data.message,
          expires_at: tokenData.expires_at
        };
      } else {
        const errorData = await response.json();
        return {
          success: false,
          error: errorData.error?.message || errorData.message || 'Login failed',
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
      // Only make logout request if we have a valid token
      if (this.isTokenValid()) {
        await this.request('/auth/logout', {
          method: 'POST'
        });
      }
    } catch (error) {
      console.error('Logout error:', error);
    } finally {
      // Clear all auth data
      this.clearAuth();
    }
    
    return { success: true };
  }

  /**
   * Get current user
   * @returns {Promise<{success: boolean, user?: object, error?: string}>}
   */
  async getCurrentUser() {
    // Check token validity first
    if (!this.isTokenValid()) {
      this.clearAuth();
      return {
        success: false,
        error: 'Session expired',
        code: 'TOKEN_EXPIRED'
      };
    }

    try {
      const response = await this.request('/auth/user', {
        method: 'GET'
      });

      if (response.ok) {
        const data = await response.json();
        
        // Update cached user data
        localStorage.setItem('user_data', JSON.stringify(data.data.user || data.data));
        
        return {
          success: true,
          user: data.data.user || data.data
        };
      } else if (response.status === 401) {
        // Token invalid on server side, clear auth
        this.clearAuth();
        return {
          success: false,
          error: 'Session expired',
          code: 'UNAUTHORIZED'
        };
      } else {
        return {
          success: false,
          error: 'Failed to get user data',
          code: 'ERROR'
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
  // Token Management Methods
  // =============================================================================

  /**
   * Check if the stored token is still valid
   * @returns {boolean} Token validity status
   */
  isTokenValid() {
    const tokenDataStr = localStorage.getItem('auth_token_data');
    const token = localStorage.getItem('auth_token');
    
    if (!tokenDataStr || !token) {
      return false;
    }

    try {
      const tokenData = JSON.parse(tokenDataStr);
      const expiresAt = new Date(tokenData.expires_at);
      const now = new Date();
      
      return now < expiresAt;
    } catch (error) {
      console.error('Error checking token validity:', error);
      return false;
    }
  }

  /**
   * Get token expiration time
   * @returns {Date|null} Token expiration date or null
   */
  getTokenExpiration() {
    const tokenDataStr = localStorage.getItem('auth_token_data');
    
    if (!tokenDataStr) {
      return null;
    }

    try {
      const tokenData = JSON.parse(tokenDataStr);
      return new Date(tokenData.expires_at);
    } catch (error) {
      return null;
    }
  }

  /**
   * Check if remember me was enabled
   * @returns {boolean} Remember me status
   */
  isRememberMeEnabled() {
    const tokenDataStr = localStorage.getItem('auth_token_data');
    
    if (!tokenDataStr) {
      return false;
    }

    try {
      const tokenData = JSON.parse(tokenDataStr);
      return tokenData.remember_me === true;
    } catch (error) {
      return false;
    }
  }

  /**
   * Refresh user session if needed
   * @returns {Promise<{success: boolean, user?: object}>}
   */
  async refreshSession() {
    if (!this.isTokenValid()) {
      this.clearAuth();
      return { success: false, error: 'Session expired' };
    }

    // Get fresh user data from server
    return await this.getCurrentUser();
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
    return this.isTokenValid();
  }

  /**
   * Get stored auth token
   * @returns {string|null} Auth token or null
   */
  getToken() {
    // Check validity before returning token
    if (!this.isTokenValid()) {
      this.clearAuth();
      return null;
    }
    return localStorage.getItem('auth_token');
  }

  /**
   * Get cached user data
   * @returns {object|null} User data or null
   */
  getCachedUser() {
    if (!this.isTokenValid()) {
      this.clearAuth();
      return null;
    }
    
    const userData = localStorage.getItem('user_data');
    return userData ? JSON.parse(userData) : null;
  }

  /**
   * Clear all authentication data
   */
  clearAuth() {
    localStorage.removeItem('auth_token');
    localStorage.removeItem('auth_token_data');
    localStorage.removeItem('user_data');
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

    const response = await fetch(url, requestOptions);

    // Handle 401 Unauthorized globally
    if (response.status === 401 && endpoint !== '/auth/login') {
      this.clearAuth();
      // Optionally dispatch an event for the app to handle
      window.dispatchEvent(new CustomEvent('auth:expired'));
    }

    return response;
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

// Export both the instance and the class
export default authAPI;
export { AuthAPI };
