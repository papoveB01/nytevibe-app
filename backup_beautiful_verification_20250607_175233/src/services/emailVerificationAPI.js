// src/services/emailVerificationAPI.js
// Phase 2: API service to connect with Phase 1 backend

const API_BASE_URL = 'https://system.nytevibe.com/api';

class EmailVerificationAPI {
  /**
   * Verify email using the verification link
   * @param {string} userId - User UUID
   * @param {string} hash - Verification hash
   * @returns {Promise<Object>} Verification result
   */
  static async verifyEmail(userId, hash) {
    try {
      const response = await fetch(`${API_BASE_URL}/email/verify/${userId}/${hash}`, {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        credentials: 'include', // Include cookies if needed
      });

      const data = await response.json();
      
      return {
        success: response.ok,
        status: response.status,
        data: data,
        code: data.code || null
      };
    } catch (error) {
      console.error('Email verification error:', error);
      return {
        success: false,
        status: 500,
        data: {
          status: 'error',
          message: 'Network error occurred',
          code: 'NETWORK_ERROR'
        }
      };
    }
  }

  /**
   * Check verification status for a user
   * @param {string} userId - User UUID
   * @returns {Promise<Object>} Verification status
   */
  static async checkVerificationStatus(userId) {
    try {
      const response = await fetch(`${API_BASE_URL}/email/verify-status/${userId}`, {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        credentials: 'include',
      });

      const data = await response.json();
      
      return {
        success: response.ok,
        status: response.status,
        data: data,
        isVerified: data.data?.is_verified || false,
        verifiedAt: data.data?.verified_at || null
      };
    } catch (error) {
      console.error('Status check error:', error);
      return {
        success: false,
        status: 500,
        data: {
          status: 'error',
          message: 'Network error occurred'
        },
        isVerified: false
      };
    }
  }

  /**
   * Resend verification email
   * @param {string} email - User email address
   * @returns {Promise<Object>} Resend result
   */
  static async resendVerificationEmail(email) {
    try {
      const response = await fetch(`${API_BASE_URL}/email/resend-verification`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        credentials: 'include',
        body: JSON.stringify({ email }),
      });

      const data = await response.json();
      
      return {
        success: response.ok,
        status: response.status,
        data: data
      };
    } catch (error) {
      console.error('Resend verification error:', error);
      return {
        success: false,
        status: 500,
        data: {
          status: 'error',
          message: 'Network error occurred'
        }
      };
    }
  }

  /**
   * Parse verification URL to extract user ID and hash
   * Supports both new format (/verify/id/hash) and URL params (?user_id=...&hash=...)
   * @param {string} url - Current URL or verification URL
   * @returns {Object} Parsed verification parameters
   */
  static parseVerificationURL(url = window.location.href) {
    const urlObj = new URL(url);
    
    // Check URL path for /verify/{id}/{hash} format
    const pathMatch = urlObj.pathname.match(/\/verify\/([^\/]+)\/([^\/]+)/);
    if (pathMatch) {
      return {
        userId: pathMatch[1],
        hash: pathMatch[2],
        format: 'path'
      };
    }

    // Check URL parameters for ?user_id=...&hash=... format
    const params = new URLSearchParams(urlObj.search);
    const userId = params.get('user_id') || params.get('id');
    const hash = params.get('hash');
    
    if (userId && hash) {
      return {
        userId,
        hash,
        format: 'params'
      };
    }

    // Legacy token support (if needed)
    const token = params.get('token');
    if (token) {
      return {
        token,
        format: 'token'
      };
    }

    return {
      userId: null,
      hash: null,
      token: null,
      format: 'unknown'
    };
  }

  /**
   * Verify email using current URL parameters
   * Automatically detects URL format and extracts verification data
   * @returns {Promise<Object>} Verification result
   */
  static async verifyFromCurrentURL() {
    const parsed = this.parseVerificationURL();
    
    if (parsed.userId && parsed.hash) {
      return this.verifyEmail(parsed.userId, parsed.hash);
    }
    
    throw new Error('Invalid verification URL format');
  }
}

export default EmailVerificationAPI;
