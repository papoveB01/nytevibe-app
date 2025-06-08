/**
 * nYtevibe Registration API Service
 * Handles all registration-related API calls including email verification
 * No username/email availability checking
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
}

export default new RegistrationAPI();
export { APIError, prepareRegistrationData };
