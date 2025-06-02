class ApiService {
  constructor() {
    this.baseURL = process.env.REACT_APP_API_URL || 'http://localhost:8000/api';
    this.token = null;
    this.isOnline = navigator.onLine;
    
    // Monitor network status
    window.addEventListener('online', () => {
      this.isOnline = true;
      console.log('🌐 Network connection restored');
    });
    
    window.addEventListener('offline', () => {
      this.isOnline = false;
      console.log('📴 Network connection lost');
    });
  }

  setAuthToken(token) {
    this.token = token;
  }

  clearAuthToken() {
    this.token = null;
  }

  async request(endpoint, options = {}) {
    // Network connectivity check
    if (!this.isOnline) {
      throw new Error('No internet connection. Please check your network.');
    }

    const url = `${this.baseURL}${endpoint}`;
    
    // Request configuration with proper headers
    const config = {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
        ...options.headers,
      },
      ...options,
    };

    // Add authentication token if available
    if (this.token) {
      config.headers.Authorization = `Bearer ${this.token}`;
    }

    console.log('🚀 API Request:', {
      method: config.method,
      url: url,
      headers: config.headers,
      body: config.body ? JSON.parse(config.body) : null
    });

    try {
      const response = await fetch(url, config);
      
      console.log('📡 API Response Status:', response.status);
      
      let data;
      const contentType = response.headers.get('content-type');
      
      if (contentType && contentType.includes('application/json')) {
        data = await response.json();
      } else {
        data = await response.text();
      }

      console.log('📦 API Response Data:', data);

      if (!response.ok) {
        const errorMessage = data?.message || data?.error || `HTTP ${response.status}`;
        console.error('❌ API Error:', errorMessage);
        throw new Error(errorMessage);
      }

      return data;
    } catch (error) {
      console.error('🔥 Request Failed:', error);
      
      if (error.message.includes('Failed to fetch')) {
        throw new Error('Unable to connect to server. Please check:\n• Server is online\n• Network connectivity\n• CORS configuration');
      }
      
      throw error;
    }
  }

  // Transform frontend camelCase to backend snake_case
  transformRegistrationData(formData) {
    console.log('🔄 Transforming registration data from camelCase to snake_case');
    console.log('📝 Input data:', formData);
    
    const transformedData = {
      first_name: formData.firstName,
      last_name: formData.lastName,
      username: formData.username,
      email: formData.email,
      password: formData.password,
      password_confirmation: formData.passwordConfirmation,
      user_type: formData.userType || 'user'
    };
    
    console.log('✅ Transformed data:', transformedData);
    return transformedData;
  }

  async register(userData) {
    console.log('📋 Registration attempt with data:', userData);
    
    // Transform camelCase to snake_case for Laravel backend
    const transformedData = this.transformRegistrationData(userData);
    
    return this.request('/auth/register', {
      method: 'POST',
      body: JSON.stringify(transformedData),
    });
  }

  async login(credentials) {
    console.log('🔐 Login attempt');
    
    return this.request('/auth/login', {
      method: 'POST',
      body: JSON.stringify(credentials),
    });
  }

  async logout() {
    console.log('👋 Logout attempt');
    
    const result = await this.request('/auth/logout', {
      method: 'POST',
    });
    
    this.clearAuthToken();
    return result;
  }

  async getUserProfile() {
    return this.request('/user/profile');
  }

  async updateUserProfile(profileData) {
    return this.request('/user/profile', {
      method: 'PUT',
      body: JSON.stringify(profileData),
    });
  }

  // Venue-related API calls
  async getVenues(params = {}) {
    const queryString = new URLSearchParams(params).toString();
    const endpoint = queryString ? `/venues?${queryString}` : '/venues';
    return this.request(endpoint);
  }

  async getVenueDetails(venueId) {
    return this.request(`/venues/${venueId}`);
  }

  async followVenue(venueId) {
    return this.request(`/venues/${venueId}/follow`, {
      method: 'POST',
    });
  }

  async unfollowVenue(venueId) {
    return this.request(`/venues/${venueId}/follow`, {
      method: 'DELETE',
    });
  }

  async rateVenue(venueId, ratingData) {
    return this.request(`/venues/${venueId}/reviews`, {
      method: 'POST',
      body: JSON.stringify(ratingData),
    });
  }

  async reportVenueStatus(venueId, statusData) {
    return this.request(`/venues/${venueId}/status`, {
      method: 'POST',
      body: JSON.stringify(statusData),
    });
  }
}

// Create and export a singleton instance
const apiService = new ApiService();
export default apiService;
