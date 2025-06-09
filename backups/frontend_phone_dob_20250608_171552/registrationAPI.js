/**
 * nYtevibe Registration API Service
 * Handles all registration-related API calls including email verification
 * UPDATED: Now includes real-time username/email availability checking
 */

const API_CONFIG = {
  baseURL: 'https://system.nytevibe.com/api',
  timeout: 30000,
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'X-Requested-With': 'XMLHttpRequest'
  }
};

class APIError extends Error {
  constructor(errorData, status) {
    super(errorData.message || 'API Error');
    this.status = status;
    this.errors = errorData.errors || {};
    this.code = errorData.code;
    this.retryAfter = errorData.retry_after;
  }
}

// 🔧 FIX: Enhanced prepareRegistrationData function (moved to top)
const prepareRegistrationData = (formData) => {
  const data = {
    username: formData.username?.trim(),
    email: formData.email?.trim().toLowerCase(),
    password: formData.password,
    password_confirmation: formData.passwordConfirmation,  // Fix: camelCase → snake_case
    first_name: formData.firstName,                        // Fix: camelCase → snake_case  
    last_name: formData.lastName,                          // Fix: camelCase → snake_case
    
    // Handle user_type properly - default to 'user' if not specified
//    user_type: formData.userType || 'user'
  // Only include user_type for business accounts - omit for regular users  
...(formData.userType === 'business' && { user_type: 'business' })
  };

  // Optional fields - only include if they have values
  if (formData.dateOfBirth && formData.dateOfBirth.trim()) {
    data.date_of_birth = formData.dateOfBirth;
  }
  
  if (formData.phone && formData.phone.trim()) {
    data.phone = formData.phone.trim();
  }
  
  if (formData.country && formData.country.trim()) {
    data.country = formData.country;
  }
  
  if (formData.state && formData.state.trim()) {
    data.state = formData.state;
  }
  
  if (formData.city && formData.city.trim()) {
    data.city = formData.city;
  }
  
  if (formData.zipcode && formData.zipcode.trim()) {
    data.zipcode = formData.zipcode.trim();
  }

  return data;
};

class RegistrationAPI {
  constructor() {
    this.baseURL = API_CONFIG.baseURL;
  }

  async register(userData) {
    try {
      // 🔧 FIX: Use prepareRegistrationData to map camelCase → snake_case
      const registrationData = prepareRegistrationData(userData);
      
      console.log('📤 Original form data:', userData);
      console.log('📤 Mapped registration data:', registrationData);
      
      const response = await fetch(`${this.baseURL}/auth/register`, {
        method: 'POST',
        headers: {
          ...API_CONFIG.headers,
          'Origin': 'https://blackaxl.com'
        },
        body: JSON.stringify(registrationData), // 🔧 FIX: Use mapped data
        credentials: 'include'
      });

      const data = await response.json();
      console.log('📥 Registration response:', data);

      if (!response.ok) {
        throw new APIError(data, response.status);
      }

      return data;
    } catch (error) {
      if (error instanceof APIError) {
        throw error;
      }
      // Network or other errors
      throw new APIError({
        message: 'Network error. Please check your connection.',
        code: 'NETWORK_ERROR'
      }, 0);
    }
  }

  async login(credentials) {
    try {
      // 🔧 FIX: Use correct login endpoint
      const response = await fetch(`${this.baseURL}/auth/login`, {
        method: 'POST',
        headers: {
          ...API_CONFIG.headers,
          'Origin': 'https://blackaxl.com'
        },
        body: JSON.stringify(credentials),
        credentials: 'include'
      });

      const data = await response.json();

      if (!response.ok) {
        throw new APIError(data, response.status);
      }

      return data;
    } catch (error) {
      if (error instanceof APIError) {
        throw error;
      }
      throw new APIError({
        message: 'Network error. Please check your connection.',
        code: 'NETWORK_ERROR'
      }, 0);
    }
  }

  async verifyEmail(token) {
    try {
      const response = await fetch(`${this.baseURL}/auth/verify-email`, {
        method: 'POST',
        headers: API_CONFIG.headers,
        body: JSON.stringify({ token })
      });

      const data = await response.json();

      if (!response.ok) {
        throw new APIError(data, response.status);
      }

      return data;
    } catch (error) {
      if (error instanceof APIError) {
        throw error;
      }
      throw new APIError({
        message: 'Network error. Please check your connection.',
        code: 'NETWORK_ERROR'
      }, 0);
    }
  }

  async resendVerificationEmail(email) {
    try {
      const response = await fetch(`${this.baseURL}/auth/resend-verification`, {
        method: 'POST',
        headers: API_CONFIG.headers,
        body: JSON.stringify({ email })
      });

      const data = await response.json();

      if (!response.ok) {
        throw new APIError(data, response.status);
      }

      return data;
    } catch (error) {
      if (error instanceof APIError) {
        throw error;
      }
      throw new APIError({
        message: 'Network error. Please check your connection.',
        code: 'NETWORK_ERROR'
      }, 0);
    }
  }

  // Placeholder for future country API call
  async getCountries() {
    // TODO: Implement when backend endpoint is ready
    // Return hardcoded US and Canada for now
    return [
      { code: 'US', name: 'United States' },
      { code: 'CA', name: 'Canada' }
    ];
  }

  // ===============================================================
  // 🆕 REAL-TIME AVAILABILITY CHECKING METHODS
  // ===============================================================

  /**
   * Check username availability in real-time
   * @param {string} username - Username to check
   * @returns {Promise<{available: boolean, message: string, suggestions?: string[], checking: boolean}>}
   */
  async checkUsernameAvailability(username) {
    try {
      // Client-side validation first
      if (!username || username.trim().length < 3) {
        return {
          available: false,
          message: 'Username must be at least 3 characters',
          checking: false
        };
      }

      if (username.trim().length > 50) {
        return {
          available: false,
          message: 'Username must be less than 50 characters',
          checking: false
        };
      }

      // Check format (alphanumeric, underscore, dash only)
      if (!/^[a-zA-Z0-9_.-]+$/.test(username.trim())) {
        return {
          available: false,
          message: 'Username can only contain letters, numbers, underscore, and dash',
          checking: false
        };
      }

      const response = await fetch(`${this.baseURL}/auth/check-username`, {
        method: 'POST',
        headers: {
          ...API_CONFIG.headers,
          'Origin': 'https://blackaxl.com'
        },
        body: JSON.stringify({ username: username.trim() }),
        credentials: 'include'
      });

      const data = await response.json();

      if (!response.ok) {
        throw new APIError(data, response.status);
      }

      return {
        available: data.available,
        message: data.message,
        suggestions: data.suggestions || [],
        checking: false
      };
    } catch (error) {
      console.error('Username availability check error:', error);
      
      // Handle specific error cases
      if (error instanceof APIError) {
        if (error.status === 422) {
          return {
            available: false,
            message: 'Invalid username format',
            checking: false,
            error: true
          };
        }
        if (error.status === 429) {
          return {
            available: false,
            message: 'Too many requests. Please slow down.',
            checking: false,
            error: true
          };
        }
      }

      return {
        available: false,
        message: 'Unable to check username availability',
        checking: false,
        error: true
      };
    }
  }

  /**
   * Check email availability in real-time
   * @param {string} email - Email to check
   * @returns {Promise<{available: boolean, message: string, checking: boolean}>}
   */
  async checkEmailAvailability(email) {
    try {
      // Client-side validation first
      if (!email || !email.includes('@')) {
        return {
          available: false,
          message: 'Please enter a valid email address',
          checking: false
        };
      }

      // Basic email format validation
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (!emailRegex.test(email.trim())) {
        return {
          available: false,
          message: 'Please enter a valid email format',
          checking: false
        };
      }

      if (email.trim().length > 255) {
        return {
          available: false,
          message: 'Email address is too long',
          checking: false
        };
      }

      const response = await fetch(`${this.baseURL}/auth/check-email`, {
        method: 'POST',
        headers: {
          ...API_CONFIG.headers,
          'Origin': 'https://blackaxl.com'
        },
        body: JSON.stringify({ email: email.trim().toLowerCase() }),
        credentials: 'include'
      });

      const data = await response.json();

      if (!response.ok) {
        throw new APIError(data, response.status);
      }

      return {
        available: data.available,
        message: data.message,
        checking: false
      };
    } catch (error) {
      console.error('Email availability check error:', error);
      
      // Handle specific error cases
      if (error instanceof APIError) {
        if (error.status === 422) {
          return {
            available: false,
            message: 'Invalid email format',
            checking: false,
            error: true
          };
        }
        if (error.status === 429) {
          return {
            available: false,
            message: 'Too many requests. Please slow down.',
            checking: false,
            error: true
          };
        }
      }

      return {
        available: false,
        message: 'Unable to check email availability',
        checking: false,
        error: true
      };
    }
  }
}

export default new RegistrationAPI();
export { APIError, prepareRegistrationData };
