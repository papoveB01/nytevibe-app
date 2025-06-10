#!/bin/bash

# nYtevibe Registration Process Fix Script
# Restores design/layout and fixes API integration

echo "🔧 nYtevibe Registration Process Fix"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 Restoring design and fixing API integration..."
echo ""

# Ensure we're in the project directory
if [ ! -f "package.json" ]; then
    echo "❌ Error: package.json not found. Please run this script from the nytevibe project directory."
    exit 1
fi

# 1. Create backup of current files
echo "💾 Creating backup of current files..."
cp src/App.css src/App.css.backup-registration-fix
cp src/context/AppContext.jsx src/context/AppContext.jsx.backup-registration-fix
cp src/App.jsx src/App.jsx.backup-registration-fix

# 2. Create API Service for proper backend integration
echo "🔧 Creating API service with proper field mapping..."

# Create API service file
cat > src/services/apiService.js << 'EOF'
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
EOF

# 3. Create Registration View Component
echo "📝 Creating Registration View component..."

cat > src/components/Views/RegistrationView.jsx << 'EOF'
import React, { useState } from 'react';
import { 
  ArrowLeft, 
  User, 
  Mail, 
  Lock, 
  Eye, 
  EyeOff, 
  UserCheck,
  Building2,
  AlertCircle,
  Loader2
} from 'lucide-react';
import apiService from '../../services/apiService';
import { useApp } from '../../context/AppContext';

const RegistrationView = ({ onBack, onRegistrationSuccess }) => {
  const { actions } = useApp();
  
  const [formData, setFormData] = useState({
    firstName: '',
    lastName: '',
    username: '',
    email: '',
    password: '',
    passwordConfirmation: '',
    userType: 'user'
  });

  const [showPassword, setShowPassword] = useState(false);
  const [showPasswordConfirm, setShowPasswordConfirm] = useState(false);
  const [errors, setErrors] = useState({});
  const [isLoading, setIsLoading] = useState(false);
  const [apiError, setApiError] = useState('');

  // Demo credentials auto-fill
  const handleDemoFill = () => {
    const timestamp = Date.now();
    setFormData({
      firstName: 'Demo',
      lastName: 'User',
      username: `demo${timestamp}`,
      email: `demo${timestamp}@nytevibe.com`,
      password: 'demo123',
      passwordConfirmation: 'demo123',
      userType: 'user'
    });
    setErrors({});
    setApiError('');
    
    actions.addNotification({
      type: 'success',
      message: '✨ Demo credentials filled! Ready to register.',
      duration: 3000
    });
  };

  const validateForm = () => {
    const newErrors = {};

    // First Name validation
    if (!formData.firstName.trim()) {
      newErrors.firstName = 'First name is required';
    }

    // Last Name validation
    if (!formData.lastName.trim()) {
      newErrors.lastName = 'Last name is required';
    }

    // Username validation
    if (!formData.username.trim()) {
      newErrors.username = 'Username is required';
    } else if (formData.username.length < 3) {
      newErrors.username = 'Username must be at least 3 characters';
    }

    // Email validation
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!formData.email.trim()) {
      newErrors.email = 'Email is required';
    } else if (!emailRegex.test(formData.email)) {
      newErrors.email = 'Please enter a valid email address';
    }

    // Password validation
    if (!formData.password) {
      newErrors.password = 'Password is required';
    } else if (formData.password.length < 6) {
      newErrors.password = 'Password must be at least 6 characters';
    }

    // Password confirmation
    if (!formData.passwordConfirmation) {
      newErrors.passwordConfirmation = 'Password confirmation is required';
    } else if (formData.password !== formData.passwordConfirmation) {
      newErrors.passwordConfirmation = 'Passwords do not match';
    }

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: value
    }));
    
    // Clear error when user starts typing
    if (errors[name]) {
      setErrors(prev => ({
        ...prev,
        [name]: ''
      }));
    }
    
    // Clear API error when user makes changes
    if (apiError) {
      setApiError('');
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    
    console.log('🚀 Registration form submitted');
    
    if (!validateForm()) {
      console.log('❌ Form validation failed');
      actions.addNotification({
        type: 'error',
        message: 'Please fix the errors above',
        duration: 4000
      });
      return;
    }

    setIsLoading(true);
    setApiError('');

    try {
      console.log('📋 Attempting registration with API service');
      
      const response = await apiService.register(formData);
      
      console.log('✅ Registration successful:', response);
      
      actions.addNotification({
        type: 'success',
        message: `🎉 Welcome to nYtevibe, ${formData.firstName}! Registration successful.`,
        duration: 5000
      });

      // Handle successful registration
      if (onRegistrationSuccess) {
        onRegistrationSuccess(response.data?.user || response.user);
      }

    } catch (error) {
      console.error('❌ Registration failed:', error);
      
      let errorMessage = 'Registration failed. Please try again.';
      
      if (error.message.includes('validation')) {
        errorMessage = 'Please check your information and try again.';
      } else if (error.message.includes('email')) {
        errorMessage = 'This email address is already registered.';
      } else if (error.message.includes('username')) {
        errorMessage = 'This username is already taken.';
      } else if (error.message.includes('connect')) {
        errorMessage = 'Unable to connect to server. Please check your connection.';
      }
      
      setApiError(errorMessage);
      
      actions.addNotification({
        type: 'error',
        message: `❌ ${errorMessage}`,
        duration: 5000
      });
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="registration-page">
      {/* Background Effects */}
      <div className="registration-background">
        <div className="registration-gradient"></div>
      </div>

      <div className="registration-container">
        {/* Header */}
        <div className="registration-header">
          <button onClick={onBack} className="back-button">
            <ArrowLeft className="w-5 h-5" />
            <span>Back</span>
          </button>
        </div>

        {/* Registration Card */}
        <div className="registration-card">
          {/* Logo and Branding */}
          <div className="registration-card-header">
            <div className="registration-logo">
              <div className="logo-icon">
                <span className="logo-text">nY</span>
              </div>
              <h1 className="registration-title">Create Account</h1>
              <p className="registration-subtitle">Join Houston's nightlife community</p>
            </div>
          </div>

          {/* Demo Banner */}
          <div className="demo-banner">
            <div className="demo-content">
              <div className="demo-info">
                <strong>🎯 Quick Demo Registration</strong>
                <p>Click to auto-fill with demo credentials for testing</p>
              </div>
              <button 
                type="button" 
                onClick={handleDemoFill}
                className="demo-fill-button"
              >
                Fill Demo
              </button>
            </div>
          </div>

          {/* API Error Display */}
          {apiError && (
            <div className="error-banner">
              <AlertCircle className="w-4 h-4" />
              <span>{apiError}</span>
            </div>
          )}

          {/* Registration Form */}
          <form onSubmit={handleSubmit} className="registration-form">
            {/* User Type Selection */}
            <div className="form-group">
              <label className="form-label">Account Type</label>
              <div className="user-type-selection">
                <button
                  type="button"
                  className={`user-type-button ${formData.userType === 'user' ? 'active' : ''}`}
                  onClick={() => setFormData(prev => ({ ...prev, userType: 'user' }))}
                >
                  <User className="w-4 h-4" />
                  <span>User</span>
                  <UserCheck className={`w-4 h-4 check-icon ${formData.userType === 'user' ? 'visible' : ''}`} />
                </button>
                <button
                  type="button"
                  className={`user-type-button ${formData.userType === 'business' ? 'active' : ''}`}
                  onClick={() => setFormData(prev => ({ ...prev, userType: 'business' }))}
                >
                  <Building2 className="w-4 h-4" />
                  <span>Business</span>
                  <UserCheck className={`w-4 h-4 check-icon ${formData.userType === 'business' ? 'visible' : ''}`} />
                </button>
              </div>
            </div>

            {/* Name Fields */}
            <div className="form-row">
              <div className="form-group">
                <label htmlFor="firstName" className="form-label">First Name</label>
                <div className="input-wrapper">
                  <User className="input-icon" />
                  <input
                    type="text"
                    id="firstName"
                    name="firstName"
                    value={formData.firstName}
                    onChange={handleInputChange}
                    className={`form-input ${errors.firstName ? 'error' : ''}`}
                    placeholder="Enter first name"
                    autoComplete="given-name"
                  />
                </div>
                {errors.firstName && <span className="error-text">{errors.firstName}</span>}
              </div>

              <div className="form-group">
                <label htmlFor="lastName" className="form-label">Last Name</label>
                <div className="input-wrapper">
                  <User className="input-icon" />
                  <input
                    type="text"
                    id="lastName"
                    name="lastName"
                    value={formData.lastName}
                    onChange={handleInputChange}
                    className={`form-input ${errors.lastName ? 'error' : ''}`}
                    placeholder="Enter last name"
                    autoComplete="family-name"
                  />
                </div>
                {errors.lastName && <span className="error-text">{errors.lastName}</span>}
              </div>
            </div>

            {/* Username Field */}
            <div className="form-group">
              <label htmlFor="username" className="form-label">Username</label>
              <div className="input-wrapper">
                <User className="input-icon" />
                <input
                  type="text"
                  id="username"
                  name="username"
                  value={formData.username}
                  onChange={handleInputChange}
                  className={`form-input ${errors.username ? 'error' : ''}`}
                  placeholder="Choose a username"
                  autoComplete="username"
                />
              </div>
              {errors.username && <span className="error-text">{errors.username}</span>}
            </div>

            {/* Email Field */}
            <div className="form-group">
              <label htmlFor="email" className="form-label">Email Address</label>
              <div className="input-wrapper">
                <Mail className="input-icon" />
                <input
                  type="email"
                  id="email"
                  name="email"
                  value={formData.email}
                  onChange={handleInputChange}
                  className={`form-input ${errors.email ? 'error' : ''}`}
                  placeholder="Enter email address"
                  autoComplete="email"
                />
              </div>
              {errors.email && <span className="error-text">{errors.email}</span>}
            </div>

            {/* Password Field */}
            <div className="form-group">
              <label htmlFor="password" className="form-label">Password</label>
              <div className="input-wrapper">
                <Lock className="input-icon" />
                <input
                  type={showPassword ? "text" : "password"}
                  id="password"
                  name="password"
                  value={formData.password}
                  onChange={handleInputChange}
                  className={`form-input ${errors.password ? 'error' : ''}`}
                  placeholder="Create password"
                  autoComplete="new-password"
                />
                <button
                  type="button"
                  className="password-toggle"
                  onClick={() => setShowPassword(!showPassword)}
                >
                  {showPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                </button>
              </div>
              {errors.password && <span className="error-text">{errors.password}</span>}
            </div>

            {/* Password Confirmation Field */}
            <div className="form-group">
              <label htmlFor="passwordConfirmation" className="form-label">Confirm Password</label>
              <div className="input-wrapper">
                <Lock className="input-icon" />
                <input
                  type={showPasswordConfirm ? "text" : "password"}
                  id="passwordConfirmation"
                  name="passwordConfirmation"
                  value={formData.passwordConfirmation}
                  onChange={handleInputChange}
                  className={`form-input ${errors.passwordConfirmation ? 'error' : ''}`}
                  placeholder="Confirm password"
                  autoComplete="new-password"
                />
                <button
                  type="button"
                  className="password-toggle"
                  onClick={() => setShowPasswordConfirm(!showPasswordConfirm)}
                >
                  {showPasswordConfirm ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                </button>
              </div>
              {errors.passwordConfirmation && <span className="error-text">{errors.passwordConfirmation}</span>}
            </div>

            {/* Submit Button */}
            <button
              type="submit"
              disabled={isLoading}
              className={`registration-button ${isLoading ? 'loading' : ''}`}
            >
              {isLoading ? (
                <>
                  <Loader2 className="w-4 h-4 loading-spinner" />
                  <span>Creating Account...</span>
                </>
              ) : (
                <>
                  <UserCheck className="w-4 h-4" />
                  <span>Create Account</span>
                </>
              )}
            </button>
          </form>

          {/* Footer */}
          <div className="registration-card-footer">
            <p>Already have an account? <button onClick={onBack} className="link-button">Sign In</button></p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default RegistrationView;
EOF

# 4. Restore and enhance CSS with registration styles
echo "🎨 Restoring CSS design and adding registration styles..."

cat > src/App.css << 'EOF'
/* ============================================= */
/* NYTEVIBE APP STYLES - RESTORED & ENHANCED */
/* ============================================= */

/* ===== CSS VARIABLES & DESIGN SYSTEM ===== */
:root {
  /* Color Palette */
  --color-primary: #3b82f6;
  --color-secondary: #8b5cf6;
  --color-accent: #fbbf24;
  
  /* Status Colors */
  --color-success: #10b981;
  --color-warning: #f59e0b;
  --color-error: #ef4444;
  --color-info: #06b6d4;
  
  /* Neutral Colors */
  --color-dark: #1e293b;
  --color-medium: #64748b;
  --color-light: #f1f5f9;
  --color-white: #ffffff;
  
  /* Gradients */
  --gradient-primary: linear-gradient(135deg, #3b82f6, #2563eb);
  --gradient-secondary: linear-gradient(135deg, #8b5cf6, #7c3aed);
  --gradient-accent: linear-gradient(135deg, #fbbf24, #f59e0b);
  --gradient-background: linear-gradient(180deg, #0f172a 0%, #1e293b 50%, #334155 100%);
  
  /* Shadows */
  --shadow-sm: 0 1px 2px rgba(0, 0, 0, 0.05);
  --shadow-md: 0 4px 6px rgba(0, 0, 0, 0.1);
  --shadow-lg: 0 10px 15px rgba(0, 0, 0, 0.1);
  --shadow-xl: 0 20px 25px rgba(0, 0, 0, 0.15);
  
  /* Border Radius */
  --radius-sm: 4px;
  --radius-md: 8px;
  --radius-lg: 12px;
  --radius-xl: 16px;
  --radius-full: 50%;
  
  /* Transitions */
  --transition-normal: all 0.2s ease;
  --transition-slow: all 0.3s ease;
  
  /* Z-Index Scale */
  --z-dropdown: 1000;
  --z-sticky: 1020;
  --z-fixed: 1030;
  --z-modal-backdrop: 1040;
  --z-modal: 1050;
  --z-popover: 1060;
  --z-tooltip: 1070;
  --z-toast: 1080;
}

/* ===== GLOBAL STYLES ===== */
*, *::before, *::after {
  box-sizing: border-box;
  max-width: 100%;
  word-wrap: break-word;
  overflow-wrap: break-word;
}

html, body {
  margin: 0;
  padding: 0;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen', 'Ubuntu', 'Cantarell', 'Fira Sans', 'Droid Sans', 'Helvetica Neue', sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  overflow-x: hidden;
  max-width: 100%;
}

body {
  background: var(--gradient-background);
  color: var(--color-white);
  line-height: 1.6;
  overflow-x: hidden;
}

#root {
  min-height: 100vh;
  overflow-x: hidden;
}

/* ===== REGISTRATION PAGE STYLES ===== */
.registration-page {
  min-height: 100vh;
  background: var(--gradient-background);
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  padding: 20px;
}

.registration-background {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 1;
}

.registration-gradient {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: radial-gradient(circle at 20% 80%, rgba(120, 119, 198, 0.3), transparent 50%),
              radial-gradient(circle at 80% 20%, rgba(255, 255, 255, 0.15), transparent 50%),
              radial-gradient(circle at 40% 40%, rgba(120, 119, 198, 0.15), transparent 50%);
}

.registration-container {
  position: relative;
  z-index: 2;
  width: 100%;
  max-width: 500px;
  display: flex;
  flex-direction: column;
  gap: 20px;
}

/* Registration Header */
.registration-header {
  display: flex;
  align-items: center;
  justify-content: flex-start;
}

.back-button {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 16px;
  border: 2px solid rgba(255, 255, 255, 0.2);
  background: rgba(255, 255, 255, 0.1);
  color: rgba(255, 255, 255, 0.8);
  border-radius: var(--radius-lg);
  cursor: pointer;
  transition: var(--transition-normal);
  font-weight: 500;
  font-size: 0.875rem;
  text-decoration: none;
}

.back-button:hover {
  background: rgba(255, 255, 255, 0.15);
  border-color: rgba(255, 255, 255, 0.3);
  color: white;
  transform: translateY(-1px);
}

/* Registration Card */
.registration-card {
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(20px);
  border-radius: 24px;
  padding: 40px;
  color: var(--color-dark);
  box-shadow: var(--shadow-xl);
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.registration-card-header {
  text-align: center;
  margin-bottom: 30px;
}

.registration-logo {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;
}

.logo-icon {
  width: 80px;
  height: 80px;
  background: var(--gradient-primary);
  border-radius: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 8px;
}

.logo-text {
  font-size: 2rem;
  font-weight: 900;
  color: white;
}

.registration-title {
  font-size: 1.875rem;
  font-weight: 800;
  color: var(--color-dark);
  margin: 0;
}

.registration-subtitle {
  color: var(--color-medium);
  margin: 0;
  font-size: 1rem;
}

/* Demo Banner */
.demo-banner {
  background: linear-gradient(135deg, #fef3c7, #fbbf24);
  border: 2px solid #f59e0b;
  border-radius: 12px;
  padding: 16px;
  margin-bottom: 24px;
}

.demo-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 16px;
}

.demo-info {
  flex: 1;
}

.demo-info strong {
  color: #92400e;
  display: block;
  margin-bottom: 4px;
}

.demo-info p {
  color: #a16207;
  margin: 0;
  font-size: 0.875rem;
}

.demo-fill-button {
  background: #92400e;
  color: white;
  border: none;
  padding: 8px 16px;
  border-radius: 8px;
  font-weight: 600;
  cursor: pointer;
  transition: var(--transition-normal);
  white-space: nowrap;
}

.demo-fill-button:hover {
  background: #7c2d12;
  transform: translateY(-1px);
}

/* Error Banner */
.error-banner {
  display: flex;
  align-items: center;
  gap: 8px;
  background: #fef2f2;
  border: 1px solid #fecaca;
  border-radius: 8px;
  padding: 12px;
  color: #dc2626;
  font-size: 0.875rem;
  margin-bottom: 20px;
}

/* Form Styles */
.registration-form {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.form-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
}

.form-label {
  font-weight: 600;
  color: var(--color-dark);
  font-size: 0.875rem;
}

.input-wrapper {
  position: relative;
  display: flex;
  align-items: center;
}

.input-icon {
  position: absolute;
  left: 12px;
  width: 18px;
  height: 18px;
  color: var(--color-medium);
  z-index: 1;
}

.form-input {
  width: 100%;
  padding: 12px 12px 12px 44px;
  border: 2px solid #e5e7eb;
  border-radius: var(--radius-lg);
  background: #ffffff;
  color: var(--color-dark);
  font-size: 0.875rem;
  transition: var(--transition-normal);
}

.form-input:focus {
  outline: none;
  border-color: var(--color-primary);
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}

.form-input.error {
  border-color: var(--color-error);
}

.form-input.error:focus {
  border-color: var(--color-error);
  box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.1);
}

.password-toggle {
  position: absolute;
  right: 12px;
  background: none;
  border: none;
  color: var(--color-medium);
  cursor: pointer;
  padding: 4px;
  border-radius: var(--radius-sm);
  transition: var(--transition-normal);
}

.password-toggle:hover {
  color: var(--color-dark);
  background: rgba(0, 0, 0, 0.05);
}

.error-text {
  color: var(--color-error);
  font-size: 0.75rem;
  font-weight: 500;
}

/* User Type Selection */
.user-type-selection {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 12px;
}

.user-type-button {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: 16px;
  border: 2px solid #e5e7eb;
  background: #f8fafc;
  border-radius: var(--radius-lg);
  cursor: pointer;
  transition: var(--transition-normal);
  position: relative;
  font-weight: 500;
  color: var(--color-medium);
}

.user-type-button:hover {
  border-color: #cbd5e1;
  background: #f1f5f9;
}

.user-type-button.active {
  border-color: var(--color-primary);
  background: rgba(59, 130, 246, 0.05);
  color: var(--color-primary);
}

.check-icon {
  position: absolute;
  top: 8px;
  right: 8px;
  opacity: 0;
  transition: var(--transition-normal);
}

.check-icon.visible {
  opacity: 1;
}

/* Registration Button */
.registration-button {
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: 14px 20px;
  background: var(--gradient-primary);
  color: white;
  border: none;
  border-radius: var(--radius-lg);
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: var(--transition-normal);
  margin-top: 8px;
}

.registration-button:hover:not(.loading) {
  background: linear-gradient(135deg, #2563eb, #1d4ed8);
  transform: translateY(-1px);
  box-shadow: var(--shadow-lg);
}

.registration-button.loading {
  background: linear-gradient(135deg, #6b7280, #4b5563);
  cursor: not-allowed;
}

.loading-spinner {
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

/* Registration Card Footer */
.registration-card-footer {
  text-align: center;
  margin-top: 24px;
  padding-top: 24px;
  border-top: 1px solid #e5e7eb;
  color: var(--color-medium);
}

.link-button {
  background: none;
  border: none;
  color: var(--color-primary);
  cursor: pointer;
  font-weight: 600;
  text-decoration: underline;
  padding: 0;
}

.link-button:hover {
  color: #2563eb;
}

/* ===== RESPONSIVE DESIGN ===== */
@media (max-width: 768px) {
  .registration-page {
    padding: 12px;
  }
  
  .registration-card {
    padding: 24px;
  }
  
  .form-row {
    grid-template-columns: 1fr;
    gap: 16px;
  }
  
  .demo-content {
    flex-direction: column;
    align-items: stretch;
    text-align: center;
    gap: 12px;
  }
  
  .user-type-selection {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 480px) {
  .registration-card {
    padding: 20px;
  }
  
  .logo-icon {
    width: 60px;
    height: 60px;
  }
  
  .logo-text {
    font-size: 1.5rem;
  }
  
  .registration-title {
    font-size: 1.5rem;
  }
}

/* ===== EXISTING STYLES (PRESERVED) ===== */
/* All existing styles for the main app are preserved below */

/* Header Styles */
.header {
  background: linear-gradient(135deg, #1e293b, #334155);
  color: white;
  position: sticky;
  top: 0;
  z-index: var(--z-sticky);
  box-shadow: var(--shadow-lg);
}

.header-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 16px 20px;
  width: 100%;
}

.header-top {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
  flex-wrap: wrap;
  gap: 12px;
}

.app-title {
  font-size: 1.875rem;
  font-weight: 800;
  color: white;
  margin: 0;
  background: linear-gradient(135deg, #3b82f6, #8b5cf6, #fbbf24);
  background-clip: text;
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-size: 200% 200%;
  animation: gradientShift 4s ease-in-out infinite;
}

@keyframes gradientShift {
  0%, 100% { background-position: 0% 50%; }
  50% { background-position: 100% 50%; }
}

.app-subtitle {
  color: rgba(255, 255, 255, 0.7);
  font-size: 0.875rem;
  margin: 0;
}

/* Search Bar Styles */
.search-section {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.search-container {
  position: relative;
  width: 100%;
}

.search-input {
  width: 100%;
  padding: 12px 12px 12px 40px;
  border: 2px solid rgba(255, 255, 255, 0.1);
  border-radius: var(--radius-lg);
  background: rgba(255, 255, 255, 0.1);
  color: white;
  font-size: 1rem;
  transition: var(--transition-normal);
}

.search-input:focus {
  outline: none;
  border-color: rgba(255, 255, 255, 0.3);
  background: rgba(255, 255, 255, 0.15);
}

.search-input::placeholder {
  color: rgba(255, 255, 255, 0.5);
}

.search-icon {
  position: absolute;
  left: 12px;
  top: 50%;
  transform: translateY(-50%);
  width: 18px;
  height: 18px;
  color: rgba(255, 255, 255, 0.5);
}

.search-clear {
  position: absolute;
  right: 12px;
  top: 50%;
  transform: translateY(-50%);
  background: none;
  border: none;
  color: #9ca3af;
  cursor: pointer;
  padding: 4px;
  border-radius: var(--radius-sm);
  transition: var(--transition-normal);
}

.search-clear:hover {
  color: white;
  background: rgba(255, 255, 255, 0.1);
}

/* Filter Bar */
.filter-bar {
  display: flex;
  gap: 12px;
  overflow-x: auto;
  padding-bottom: 4px;
  scrollbar-width: none;
  -ms-overflow-style: none;
}

.filter-bar::-webkit-scrollbar {
  display: none;
}

.filter-option {
  padding: 8px 16px;
  border: 2px solid rgba(255, 255, 255, 0.2);
  background: rgba(255, 255, 255, 0.1);
  color: rgba(255, 255, 255, 0.8);
  border-radius: var(--radius-lg);
  cursor: pointer;
  transition: var(--transition-normal);
  font-size: 0.875rem;
  font-weight: 500;
  display: flex;
  align-items: center;
  gap: 6px;
  white-space: nowrap;
  flex-shrink: 0;
}

.filter-option:hover {
  background: rgba(255, 255, 255, 0.15);
  color: white;
}

.filter-option.active {
  background: var(--gradient-primary);
  border-color: #2563eb;
  color: white;
}

/* Search Results */
.search-results-summary {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
  flex-wrap: wrap;
  gap: 8px;
}

.results-text {
  color: rgba(255, 255, 255, 0.8);
  font-size: 0.875rem;
}

.clear-search-button {
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
  color: rgba(255, 255, 255, 0.8);
  padding: 6px 12px;
  border-radius: var(--radius-lg);
  cursor: pointer;
  transition: var(--transition-normal);
  font-size: 0.875rem;
  font-weight: 500;
}

.clear-search-button:hover {
  background: rgba(255, 255, 255, 0.15);
  color: white;
}

/* User Profile Badge */
.user-profile-trigger {
  position: relative;
}

.user-profile-button {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 8px 12px;
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: var(--radius-lg);
  cursor: pointer;
  transition: var(--transition-normal);
  color: white;
  border: none;
  font-family: inherit;
}

.user-profile-button:hover {
  background: rgba(255, 255, 255, 0.15);
  border-color: rgba(255, 255, 255, 0.3);
  transform: translateY(-1px);
}

.user-avatar-trigger {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  background: var(--gradient-primary);
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 600;
  font-size: 0.875rem;
  color: white;
  flex-shrink: 0;
}

.user-info-trigger {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  min-width: 0;
  max-width: 150px;
}

.user-name-trigger {
  font-weight: 600;
  font-size: 0.875rem;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  max-width: 100%;
}

.user-level-trigger {
  font-size: 0.75rem;
  color: rgba(255, 255, 255, 0.7);
  display: flex;
  align-items: center;
  gap: 4px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  max-width: 100%;
}

.points-trigger {
  margin-left: 4px;
}

.profile-chevron {
  width: 16px;
  height: 16px;
  fill: none;
  stroke: currentColor;
  stroke-width: 2;
  flex-shrink: 0;
}

/* Home Content */
.home-content {
  min-height: calc(100vh - 200px);
  background: #f8fafc;
  background: linear-gradient(180deg, #f8fafc 0%, #f1f5f9 100%);
  padding: 24px 20px;
}

.home-container {
  max-width: 1200px;
  margin: 0 auto;
  width: 100%;
}

/* Promotional Banner */
.promotional-banner {
  background: #ffffff;
  border-radius: var(--radius-xl);
  padding: 20px 24px;
  margin-bottom: 20px;
  box-shadow: var(--shadow-md);
  border: 2px solid;
  transition: var(--transition-normal);
  cursor: pointer;
  position: relative;
  overflow: hidden;
}

.promotional-banner:hover {
  transform: translateY(-2px);
  box-shadow: var(--shadow-lg);
}

.promotional-banner.summer {
  border-color: #fbbf24;
  background: linear-gradient(135deg, #fef3c7, #fbbf24);
}

.promotional-banner.weekend {
  border-color: #8b5cf6;
  background: linear-gradient(135deg, #f3e8ff, #8b5cf6);
}

.promotional-banner.happy-hour {
  border-color: #10b981;
  background: linear-gradient(135deg, #d1fae5, #10b981);
}

.banner-content {
  display: flex;
  align-items: center;
  gap: 16px;
}

.banner-icon {
  font-size: 2rem;
  flex-shrink: 0;
}

.banner-text {
  flex: 1;
}

.banner-title {
  font-weight: 700;
  font-size: 1rem;
  margin-bottom: 4px;
  line-height: 1.4;
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.2);
}

.banner-subtitle {
  font-size: 0.875rem;
  line-height: 1.4;
  opacity: 0.95;
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
}

.banner-indicators {
  display: flex;
  justify-content: center;
  gap: 8px;
  margin-top: 16px;
}

.banner-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: rgba(0, 0, 0, 0.2);
  cursor: pointer;
  transition: var(--transition-normal);
}

.banner-dot.active {
  background: rgba(0, 0, 0, 0.6);
  transform: scale(1.2);
}

/* Venues Grid */
.venues-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: 20px;
  width: 100%;
}

/* Venue Card */
.venue-card-container {
  background: #ffffff;
  border-radius: var(--radius-xl);
  padding: 20px;
  margin-bottom: 20px;
  box-shadow: var(--shadow-md);
  transition: var(--transition-normal);
  position: relative;
  border: 2px solid transparent;
  width: 100%;
  overflow: hidden;
}

.venue-card-container:hover {
  transform: translateY(-2px);
  box-shadow: var(--shadow-lg);
}

.venue-card-header-fixed {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 16px;
  gap: 12px;
}

.venue-info-main {
  flex: 1;
  min-width: 0;
}

.venue-name {
  font-size: 1.125rem;
  font-weight: 700;
  color: #1f2937;
  margin: 0 0 4px 0;
  line-height: 1.3;
  word-wrap: break-word;
}

.venue-type {
  font-size: 0.875rem;
  color: #6b7280;
  font-weight: 500;
  margin-bottom: 8px;
}

.venue-address {
  font-size: 0.75rem;
  color: #9ca3af;
  word-wrap: break-word;
}

.venue-actions {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  gap: 8px;
  flex-shrink: 0;
}

/* Follow Button */
.follow-button {
  width: 40px;
  height: 40px;
  border-radius: var(--radius-full);
  border: 2px solid #e5e7eb;
  background: #f9fafb;
  color: #6b7280;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: var(--transition-normal);
  position: relative;
}

.follow-button:hover {
  border-color: #d1d5db;
  background: #f3f4f6;
  transform: scale(1.05);
}

.follow-button.following {
  background: var(--gradient-primary);
  border-color: #3b82f6;
  color: white;
}

.follow-button.following:hover {
  background: linear-gradient(135deg, #2563eb, #1d4ed8);
  border-color: #2563eb;
}

/* Star Rating */
.star-rating-container {
  display: flex;
  align-items: center;
  gap: 4px;
}

.stars-display {
  display: flex;
  gap: 2px;
}

.star {
  width: 16px;
  height: 16px;
  color: #d1d5db;
  fill: none;
  stroke: currentColor;
  stroke-width: 1.5;
}

.star.filled {
  color: #fbbf24;
  fill: currentColor;
}

.star.half {
  color: #fbbf24;
  fill: url(#halfFill);
  stroke: currentColor;
}

.rating-text {
  font-size: 0.875rem;
  color: #6b7280;
  font-weight: 500;
  margin-left: 4px;
}

/* Venue Status */
.venue-status-section {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
}

.status-crowd {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 4px 8px;
  border-radius: var(--radius-full);
  font-size: 0.75rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.status-crowd.quiet {
  background: #d1fae5;
  color: #047857;
}

.status-crowd.moderate {
  background: #fef3c7;
  color: #92400e;
}

.status-crowd.busy {
  background: #fed7aa;
  color: #c2410c;
}

.status-crowd.packed {
  background: #fecaca;
  color: #dc2626;
}

.status-wait {
  font-size: 0.75rem;
  color: #6b7280;
  display: flex;
  align-items: center;
  gap: 4px;
}

/* Venue Vibe Tags */
.venue-vibe-section {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
  margin-bottom: 12px;
}

.vibe-tag {
  background: var(--gradient-primary);
  color: white;
  padding: 2px 6px;
  border-radius: var(--radius-full);
  font-size: 0.625rem;
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

/* Venue Actions Section */
.venue-actions-section {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 8px;
}

.action-buttons {
  display: flex;
  gap: 8px;
}

.action-button {
  padding: 6px 12px;
  border: none;
  border-radius: var(--radius-lg);
  font-size: 0.75rem;
  font-weight: 600;
  cursor: pointer;
  transition: var(--transition-normal);
  display: flex;
  align-items: center;
  gap: 4px;
}

.rate-btn {
  background: #fef3c7;
  color: #92400e;
}

.rate-btn:hover {
  background: #fbbf24;
  color: white;
}

.report-btn {
  background: #e0f2fe;
  color: #0369a1;
}

.report-btn:hover {
  background: #0ea5e9;
  color: white;
}

.details-btn-full {
  width: 100%;
  padding: 12px 16px;
  border-radius: var(--radius-lg);
  border: none;
  font-weight: 600;
  font-size: 0.875rem;
  cursor: pointer;
  transition: var(--transition-normal);
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
  background: var(--gradient-primary);
  color: white;
  margin-top: 12px;
}

.details-btn-full:hover {
  background: linear-gradient(135deg, #2563eb, #1d4ed8);
  transform: translateY(-1px);
}

/* Follow Stats */
.follow-stats {
  background: white;
  border-radius: var(--radius-xl);
  padding: 16px 20px;
  margin-bottom: 20px;
  box-shadow: var(--shadow-md);
  border: 1px solid #e5e7eb;
}

.follow-stats-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.stats-item {
  text-align: center;
  flex: 1;
}

.stats-number {
  font-size: 1.5rem;
  font-weight: 700;
  color: #1f2937;
  margin-bottom: 2px;
}

.stats-label {
  font-size: 0.75rem;
  color: #6b7280;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  font-weight: 600;
}

/* Modal Styles */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.75);
  backdrop-filter: blur(8px);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: var(--z-modal);
  padding: 16px;
  animation: modalOverlayFadeIn 0.2s ease-out;
}

@keyframes modalOverlayFadeIn {
  from {
    opacity: 0;
    backdrop-filter: blur(0px);
  }
  to {
    opacity: 1;
    backdrop-filter: blur(8px);
  }
}

.modal-content {
  background: #ffffff;
  border-radius: 16px;
  width: 100%;
  max-width: 500px;
  max-height: 90vh;
  overflow-y: auto;
  box-shadow: 0 25px 50px rgba(0, 0, 0, 0.4);
  color: #1e293b;
  animation: modalSlideIn 0.3s ease-out;
  position: relative;
}

@keyframes modalSlideIn {
  from {
    opacity: 0;
    transform: translateY(-20px) scale(0.95);
  }
  to {
    opacity: 1;
    transform: translateY(0) scale(1);
  }
}

.modal-header {
  padding: 24px 24px 0 24px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.modal-title {
  font-size: 1.25rem;
  font-weight: 700;
  color: #1e293b;
  margin: 0;
}

.modal-close {
  background: none;
  border: none;
  font-size: 1.5rem;
  color: #9ca3af;
  cursor: pointer;
  padding: 4px;
  line-height: 1;
  border-radius: var(--radius-sm);
  transition: var(--transition-normal);
}

.modal-close:hover {
  color: #6b7280;
  background: #f3f4f6;
}

.modal-body {
  padding: 24px;
}

.modal-actions {
  display: flex;
  gap: 12px;
  justify-content: flex-end;
  padding: 0 24px 24px 24px;
}

.modal-button {
  padding: 10px 20px;
  border: none;
  border-radius: var(--radius-lg);
  font-weight: 600;
  cursor: pointer;
  transition: var(--transition-normal);
  display: flex;
  align-items: center;
  gap: 6px;
}

.modal-button.primary {
  background: var(--gradient-primary);
  color: white;
}

.modal-button.primary:hover {
  background: linear-gradient(135deg, #2563eb, #1d4ed8);
}

.modal-button.secondary {
  background: #f1f5f9;
  color: #475569;
  border: 1px solid #e2e8f0;
}

.modal-button.secondary:hover {
  background: #e2e8f0;
  color: #334155;
}

/* Notification System */
.notification-container {
  position: fixed;
  top: 20px;
  right: 20px;
  z-index: var(--z-toast);
  display: flex;
  flex-direction: column;
  gap: 12px;
  max-width: 400px;
}

.notification {
  background: white;
  border-radius: 12px;
  box-shadow: var(--shadow-xl);
  border-left: 4px solid #3b82f6;
  animation: notificationSlideIn 0.3s ease-out;
  overflow: hidden;
}

@keyframes notificationSlideIn {
  from {
    opacity: 0;
    transform: translateX(100%);
  }
  to {
    opacity: 1;
    transform: translateX(0);
  }
}

.notification.success {
  border-left-color: #10b981;
}

.notification.error {
  border-left-color: #ef4444;
}

.notification.warning {
  border-left-color: #f59e0b;
}

.notification.info {
  border-left-color: #06b6d4;
}

.notification-content {
  padding: 16px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 12px;
}

.notification-message {
  font-size: 0.875rem;
  color: #374151;
  font-weight: 500;
  flex: 1;
}

.notification-close {
  background: none;
  border: none;
  font-size: 1.25rem;
  color: #9ca3af;
  cursor: pointer;
  padding: 4px;
  line-height: 1;
  border-radius: var(--radius-sm);
  transition: var(--transition-normal);
}

.notification-close:hover {
  color: #6b7280;
  background: #f3f4f6;
}

/* Loading States */
.loading-spinner {
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

/* Mobile Responsiveness */
@media (max-width: 768px) {
  .header-content {
    padding: 12px 16px;
  }
  
  .header-top {
    margin-bottom: 12px;
  }
  
  .app-title {
    font-size: 1.5rem;
  }
  
  .app-subtitle {
    font-size: 0.75rem;
  }
  
  .home-content {
    padding: 16px;
  }
  
  .venues-grid {
    grid-template-columns: 1fr;
    gap: 16px;
  }
  
  .venue-card-container {
    padding: 16px;
    margin-bottom: 16px;
  }
  
  .promotional-banner {
    padding: 16px 20px;
    margin-bottom: 16px;
  }
  
  .banner-content {
    gap: 12px;
  }
  
  .banner-title {
    font-size: 0.9rem;
  }
  
  .banner-subtitle {
    font-size: 0.8rem;
  }
  
  .notification-container {
    top: 16px;
    right: 16px;
    left: 16px;
    max-width: none;
  }
  
  .modal-content {
    margin: 0;
    max-width: none;
    width: 100%;
    max-height: 95vh;
  }
  
  .modal-actions {
    flex-direction: column;
    gap: 8px;
  }
  
  .modal-button {
    width: 100%;
    justify-content: center;
  }
  
  .user-info-trigger {
    display: none;
  }
}

@media (max-width: 480px) {
  .venue-card-container {
    padding: 12px;
  }
  
  .venue-name {
    font-size: 1rem;
  }
  
  .details-btn-full {
    padding: 10px 14px;
    font-size: 0.8rem;
  }
  
  .modal-header,
  .modal-body,
  .modal-actions {
    padding-left: 16px;
    padding-right: 16px;
  }
}

/* Accessibility */
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}

.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border: 0;
}

/* Focus States */
button:focus,
input:focus,
select:focus,
textarea:focus {
  outline: 2px solid #fbbf24;
  outline-offset: 2px;
}

/* High Contrast Mode */
@media (prefers-contrast: high) {
  .venue-card-container {
    border: 2px solid #000;
  }
  
  .promotional-banner {
    border: 3px solid #000;
  }
}
EOF

# 5. Update AppContext to include registration state
echo "🔧 Updating AppContext with registration state..."

cat > src/context/AppContext.jsx << 'EOF'
import React, { createContext, useContext, useReducer, useCallback } from 'react';

// Initial state
const initialState = {
  // View Management
  currentView: 'home', // 'home' | 'details' | 'registration'
  selectedVenue: null,
  
  // Modal States
  showShareModal: false,
  showRatingModal: false,
  showReportModal: false,
  showUserProfileModal: false,
  shareVenue: null,
  
  // User Data
  isAuthenticated: false,
  authenticatedUser: null,
  userProfile: {
    id: 'usr_demo',
    firstName: 'Demo',
    lastName: 'User',
    username: 'demouser',
    email: 'demo@nytevibe.com',
    level: 3,
    points: 2847,
    badges: ['Explorer', 'Reviewer', 'Early Adopter'],
    followedVenues: ['venue_1', 'venue_3', 'venue_7'],
    totalReports: 12,
    totalRatings: 8,
    joinDate: '2024-03-15'
  },
  
  // App Data
  venues: [
    {
      id: 'venue_1',
      name: 'Skyline Rooftop',
      type: 'Rooftop Bar',
      address: '1200 McKinney St, Houston, TX',
      rating: 4.2,
      totalRatings: 45,
      crowdLevel: 3,
      waitTime: 15,
      lastUpdate: '10 minutes ago',
      confidence: 85,
      followersCount: 230,
      reports: 24,
      hours: 'Open until 2:00 AM',
      phone: '+1 (713) 555-0123',
      vibe: ['Upscale', 'City Views', 'Cocktails', 'Date Night'],
      hasPromotion: true,
      promotionText: '🍹 Happy Hour: 5-7 PM - Half price cocktails!',
      reviews: [
        {
          id: 'rev_1',
          user: 'Sarah M.',
          rating: 5,
          comment: 'Amazing views and great cocktails! Perfect for date night.',
          date: '2 days ago',
          helpful: 12
        },
        {
          id: 'rev_2',
          user: 'Mike R.',
          rating: 4,
          comment: 'Great atmosphere but can get crowded on weekends.',
          date: '1 week ago',
          helpful: 8
        }
      ]
    },
    {
      id: 'venue_2',
      name: 'Underground Lounge',
      type: 'Cocktail Lounge',
      address: '815 Walker St, Houston, TX',
      rating: 4.7,
      totalRatings: 89,
      crowdLevel: 2,
      waitTime: 5,
      lastUpdate: '5 minutes ago',
      confidence: 92,
      followersCount: 445,
      reports: 36,
      hours: 'Open until 1:00 AM',
      phone: '+1 (713) 555-0124',
      vibe: ['Intimate', 'Craft Cocktails', 'Jazz Music', 'Speakeasy'],
      hasPromotion: false,
      reviews: [
        {
          id: 'rev_3',
          user: 'Emma T.',
          rating: 5,
          comment: 'Hidden gem! Amazing craft cocktails and intimate atmosphere.',
          date: '3 days ago',
          helpful: 15
        }
      ]
    },
    {
      id: 'venue_3',
      name: 'Beat Street Dance Club',
      type: 'Dance Club',
      address: '2120 Walker St, Houston, TX',
      rating: 4.1,
      totalRatings: 127,
      crowdLevel: 4,
      waitTime: 25,
      lastUpdate: '2 minutes ago',
      confidence: 78,
      followersCount: 892,
      reports: 52,
      hours: 'Open until 3:00 AM',
      phone: '+1 (713) 555-0125',
      vibe: ['High Energy', 'EDM', 'Dancing', 'Young Crowd'],
      hasPromotion: true,
      promotionText: '🎵 Ladies Night: Friday - No cover for ladies before 11 PM',
      reviews: [
        {
          id: 'rev_4',
          user: 'Carlos D.',
          rating: 4,
          comment: 'Great music and energy! Gets very packed though.',
          date: '1 day ago',
          helpful: 6
        }
      ]
    },
    {
      id: 'venue_4',
      name: 'The Local Tavern',
      type: 'Sports Bar',
      address: '3421 Smith St, Houston, TX',
      rating: 3.8,
      totalRatings: 203,
      crowdLevel: 2,
      waitTime: 0,
      lastUpdate: '15 minutes ago',
      confidence: 89,
      followersCount: 156,
      reports: 41,
      hours: 'Open until 12:00 AM',
      phone: '+1 (713) 555-0126',
      vibe: ['Casual', 'Sports', 'Beer', 'Wings'],
      hasPromotion: false,
      reviews: [
        {
          id: 'rev_5',
          user: 'Tom W.',
          rating: 4,
          comment: 'Good spot to watch the game with friends. Great wings!',
          date: '4 days ago',
          helpful: 9
        }
      ]
    },
    {
      id: 'venue_5',
      name: 'Neon Nights',
      type: 'Nightclub',
      address: '1515 Texas Ave, Houston, TX',
      rating: 4.5,
      totalRatings: 78,
      crowdLevel: 3,
      waitTime: 10,
      lastUpdate: '8 minutes ago',
      confidence: 91,
      followersCount: 667,
      reports: 29,
      hours: 'Open until 4:00 AM',
      phone: '+1 (713) 555-0127',
      vibe: ['Trendy', 'Hip Hop', 'VIP Service', 'Late Night'],
      hasPromotion: true,
      promotionText: '🎉 Weekend Special: Bottle service packages 20% off',
      reviews: [
        {
          id: 'rev_6',
          user: 'Jessica L.',
          rating: 5,
          comment: 'Best nightclub in Houston! Amazing music and VIP service.',
          date: '2 days ago',
          helpful: 18
        }
      ]
    },
    {
      id: 'venue_6',
      name: 'Bourbon & Blues',
      type: 'Live Music Bar',
      address: '920 Main St, Houston, TX',
      rating: 4.3,
      totalRatings: 156,
      crowdLevel: 1,
      waitTime: 0,
      lastUpdate: '12 minutes ago',
      confidence: 94,
      followersCount: 324,
      reports: 38,
      hours: 'Open until 1:00 AM',
      phone: '+1 (713) 555-0128',
      vibe: ['Live Music', 'Blues', 'Whiskey', 'Mature Crowd'],
      hasPromotion: false,
      reviews: [
        {
          id: 'rev_7',
          user: 'Robert K.',
          rating: 4,
          comment: 'Excellent live music and great selection of bourbon.',
          date: '5 days ago',
          helpful: 11
        }
      ]
    }
  ],
  
  // Search and Filter
  searchQuery: '',
  activeFilter: 'all',
  
  // Notifications
  notifications: [],
  
  // Promotional Banners
  banners: [
    {
      id: 'banner_1',
      type: 'summer',
      icon: '🌞',
      title: 'Summer Rooftop Season',
      subtitle: 'Discover Houston\'s best rooftop bars and lounges',
      active: true
    },
    {
      id: 'banner_2',
      type: 'weekend',
      icon: '🎉',
      title: 'Weekend Party Guide',
      subtitle: 'Find the hottest weekend spots and events',
      active: false
    },
    {
      id: 'banner_3',
      type: 'happy-hour',
      icon: '🍸',
      title: 'Happy Hour Deals',
      subtitle: 'Best drink specials across the city',
      active: false
    }
  ],
  activeBannerIndex: 0,
  
  // System
  lastDataUpdate: new Date().toLocaleTimeString()
};

// Action types
const actionTypes = {
  // View Management
  SET_CURRENT_VIEW: 'SET_CURRENT_VIEW',
  SET_SELECTED_VENUE: 'SET_SELECTED_VENUE',
  
  // Modal Management
  SET_SHOW_SHARE_MODAL: 'SET_SHOW_SHARE_MODAL',
  SET_SHOW_RATING_MODAL: 'SET_SHOW_RATING_MODAL',
  SET_SHOW_REPORT_MODAL: 'SET_SHOW_REPORT_MODAL',
  SET_SHOW_USER_PROFILE_MODAL: 'SET_SHOW_USER_PROFILE_MODAL',
  SET_SHARE_VENUE: 'SET_SHARE_VENUE',
  
  // Authentication
  LOGIN_SUCCESS: 'LOGIN_SUCCESS',
  LOGOUT: 'LOGOUT',
  REGISTER_SUCCESS: 'REGISTER_SUCCESS',
  
  // User Actions
  FOLLOW_VENUE: 'FOLLOW_VENUE',
  UNFOLLOW_VENUE: 'UNFOLLOW_VENUE',
  RATE_VENUE: 'RATE_VENUE',
  REPORT_VENUE: 'REPORT_VENUE',
  
  // Search and Filter
  SET_SEARCH_QUERY: 'SET_SEARCH_QUERY',
  SET_ACTIVE_FILTER: 'SET_ACTIVE_FILTER',
  
  // Notifications
  ADD_NOTIFICATION: 'ADD_NOTIFICATION',
  REMOVE_NOTIFICATION: 'REMOVE_NOTIFICATION',
  
  // Banners
  SET_ACTIVE_BANNER: 'SET_ACTIVE_BANNER',
  
  // Data Management
  UPDATE_VENUE_DATA: 'UPDATE_VENUE_DATA',
  RESET_USER_DATA: 'RESET_USER_DATA'
};

// Reducer
const appReducer = (state, action) => {
  console.log('🔄 Context Action:', action.type, action.payload);
  
  switch (action.type) {
    // View Management
    case actionTypes.SET_CURRENT_VIEW:
      return { ...state, currentView: action.payload };
      
    case actionTypes.SET_SELECTED_VENUE:
      return { ...state, selectedVenue: action.payload };
    
    // Modal Management
    case actionTypes.SET_SHOW_SHARE_MODAL:
      return { ...state, showShareModal: action.payload };
      
    case actionTypes.SET_SHOW_RATING_MODAL:
      return { ...state, showRatingModal: action.payload };
      
    case actionTypes.SET_SHOW_REPORT_MODAL:
      return { ...state, showReportModal: action.payload };
      
    case actionTypes.SET_SHOW_USER_PROFILE_MODAL:
      return { ...state, showUserProfileModal: action.payload };
      
    case actionTypes.SET_SHARE_VENUE:
      return { ...state, shareVenue: action.payload };
    
    // Authentication
    case actionTypes.LOGIN_SUCCESS:
      return {
        ...state,
        isAuthenticated: true,
        authenticatedUser: action.payload,
        currentView: 'home'
      };
      
    case actionTypes.LOGOUT:
      return {
        ...state,
        isAuthenticated: false,
        authenticatedUser: null,
        currentView: 'home'
      };
      
    case actionTypes.REGISTER_SUCCESS:
      return {
        ...state,
        isAuthenticated: true,
        authenticatedUser: action.payload,
        currentView: 'home'
      };
    
    // User Actions
    case actionTypes.FOLLOW_VENUE:
      return {
        ...state,
        userProfile: {
          ...state.userProfile,
          followedVenues: [...state.userProfile.followedVenues, action.payload]
        },
        venues: state.venues.map(venue => 
          venue.id === action.payload 
            ? { ...venue, followersCount: venue.followersCount + 1 }
            : venue
        )
      };
      
    case actionTypes.UNFOLLOW_VENUE:
      return {
        ...state,
        userProfile: {
          ...state.userProfile,
          followedVenues: state.userProfile.followedVenues.filter(id => id !== action.payload)
        },
        venues: state.venues.map(venue => 
          venue.id === action.payload 
            ? { ...venue, followersCount: Math.max(0, venue.followersCount - 1) }
            : venue
        )
      };
      
    case actionTypes.RATE_VENUE:
      const { venueId, rating, comment } = action.payload;
      return {
        ...state,
        venues: state.venues.map(venue => {
          if (venue.id === venueId) {
            const newReview = {
              id: `rev_${Date.now()}`,
              user: `${state.userProfile.firstName} ${state.userProfile.lastName.charAt(0)}.`,
              rating,
              comment,
              date: 'Just now',
              helpful: 0
            };
            const newReviews = [newReview, ...(venue.reviews || [])];
            const newTotalRatings = venue.totalRatings + 1;
            const newAverageRating = ((venue.rating * venue.totalRatings) + rating) / newTotalRatings;
            
            return {
              ...venue,
              rating: Math.round(newAverageRating * 10) / 10,
              totalRatings: newTotalRatings,
              reviews: newReviews
            };
          }
          return venue;
        }),
        userProfile: {
          ...state.userProfile,
          totalRatings: state.userProfile.totalRatings + 1,
          points: state.userProfile.points + 10
        }
      };
      
    case actionTypes.REPORT_VENUE:
      const { venueId: reportVenueId, crowdLevel, waitTime: reportWaitTime } = action.payload;
      return {
        ...state,
        venues: state.venues.map(venue => 
          venue.id === reportVenueId 
            ? { 
                ...venue, 
                crowdLevel, 
                waitTime: reportWaitTime || 0,
                lastUpdate: 'Just now',
                reports: venue.reports + 1,
                confidence: Math.min(95, venue.confidence + 2)
              }
            : venue
        ),
        userProfile: {
          ...state.userProfile,
          totalReports: state.userProfile.totalReports + 1,
          points: state.userProfile.points + 5
        }
      };
    
    // Search and Filter
    case actionTypes.SET_SEARCH_QUERY:
      return { ...state, searchQuery: action.payload };
      
    case actionTypes.SET_ACTIVE_FILTER:
      return { ...state, activeFilter: action.payload };
    
    // Notifications
    case actionTypes.ADD_NOTIFICATION:
      const newNotification = {
        id: `notif_${Date.now()}`,
        timestamp: new Date().toISOString(),
        ...action.payload
      };
      return {
        ...state,
        notifications: [newNotification, ...state.notifications.slice(0, 4)]
      };
      
    case actionTypes.REMOVE_NOTIFICATION:
      return {
        ...state,
        notifications: state.notifications.filter(notif => notif.id !== action.payload)
      };
    
    // Banners
    case actionTypes.SET_ACTIVE_BANNER:
      return {
        ...state,
        activeBannerIndex: action.payload,
        banners: state.banners.map((banner, index) => ({
          ...banner,
          active: index === action.payload
        }))
      };
    
    // Data Management
    case actionTypes.UPDATE_VENUE_DATA:
      return {
        ...state,
        venues: state.venues.map(venue => ({
          ...venue,
          lastUpdate: new Date().toLocaleTimeString(),
          confidence: Math.max(70, Math.min(95, venue.confidence + (Math.random() > 0.5 ? 1 : -1)))
        })),
        lastDataUpdate: new Date().toLocaleTimeString()
      };
      
    case actionTypes.RESET_USER_DATA:
      return {
        ...state,
        userProfile: initialState.userProfile,
        searchQuery: '',
        activeFilter: 'all',
        notifications: []
      };
    
    default:
      console.warn('Unknown action type:', action.type);
      return state;
  }
};

// Create context
const AppContext = createContext();

// Context provider component
export const AppProvider = ({ children }) => {
  const [state, dispatch] = useReducer(appReducer, initialState);
  
  // Action creators
  const actions = {
    // View Management
    setCurrentView: useCallback((view) => {
      dispatch({ type: actionTypes.SET_CURRENT_VIEW, payload: view });
    }, []),
    
    setSelectedVenue: useCallback((venue) => {
      dispatch({ type: actionTypes.SET_SELECTED_VENUE, payload: venue });
    }, []),
    
    // Modal Management
    setShowShareModal: useCallback((show) => {
      dispatch({ type: actionTypes.SET_SHOW_SHARE_MODAL, payload: show });
    }, []),
    
    setShowRatingModal: useCallback((show) => {
      dispatch({ type: actionTypes.SET_SHOW_RATING_MODAL, payload: show });
    }, []),
    
    setShowReportModal: useCallback((show) => {
      dispatch({ type: actionTypes.SET_SHOW_REPORT_MODAL, payload: show });
    }, []),
    
    setShowUserProfileModal: useCallback((show) => {
      dispatch({ type: actionTypes.SET_SHOW_USER_PROFILE_MODAL, payload: show });
    }, []),
    
    setShareVenue: useCallback((venue) => {
      dispatch({ type: actionTypes.SET_SHARE_VENUE, payload: venue });
    }, []),
    
    // Authentication
    loginUser: useCallback((userData) => {
      dispatch({ type: actionTypes.LOGIN_SUCCESS, payload: userData });
    }, []),
    
    logoutUser: useCallback(() => {
      dispatch({ type: actionTypes.LOGOUT });
    }, []),
    
    registerUser: useCallback((userData) => {
      dispatch({ type: actionTypes.REGISTER_SUCCESS, payload: userData });
    }, []),
    
    // User Actions
    followVenue: useCallback((venueId) => {
      dispatch({ type: actionTypes.FOLLOW_VENUE, payload: venueId });
    }, []),
    
    unfollowVenue: useCallback((venueId) => {
      dispatch({ type: actionTypes.UNFOLLOW_VENUE, payload: venueId });
    }, []),
    
    rateVenue: useCallback((venueId, rating, comment) => {
      dispatch({ type: actionTypes.RATE_VENUE, payload: { venueId, rating, comment } });
    }, []),
    
    reportVenue: useCallback((venueId, crowdLevel, waitTime, comments) => {
      dispatch({ type: actionTypes.REPORT_VENUE, payload: { venueId, crowdLevel, waitTime, comments } });
    }, []),
    
    // Search and Filter
    setSearchQuery: useCallback((query) => {
      dispatch({ type: actionTypes.SET_SEARCH_QUERY, payload: query });
    }, []),
    
    setActiveFilter: useCallback((filter) => {
      dispatch({ type: actionTypes.SET_ACTIVE_FILTER, payload: filter });
    }, []),
    
    // Notifications
    addNotification: useCallback((notification) => {
      dispatch({ type: actionTypes.ADD_NOTIFICATION, payload: notification });
    }, []),
    
    removeNotification: useCallback((notificationId) => {
      dispatch({ type: actionTypes.REMOVE_NOTIFICATION, payload: notificationId });
    }, []),
    
    // Banners
    setActiveBanner: useCallback((bannerIndex) => {
      dispatch({ type: actionTypes.SET_ACTIVE_BANNER, payload: bannerIndex });
    }, []),
    
    // Data Management
    updateVenueData: useCallback(() => {
      dispatch({ type: actionTypes.UPDATE_VENUE_DATA });
    }, []),
    
    resetUserData: useCallback(() => {
      dispatch({ type: actionTypes.RESET_USER_DATA });
    }, [])
  };
  
  const contextValue = {
    state,
    actions,
    dispatch
  };
  
  return (
    <AppContext.Provider value={contextValue}>
      {children}
    </AppContext.Provider>
  );
};

// Custom hook to use the context
export const useApp = () => {
  const context = useContext(AppContext);
  if (!context) {
    throw new Error('useApp must be used within an AppProvider');
  }
  return context;
};

export default AppContext;
EOF

# 6. Update App.jsx to include registration routing
echo "🔧 Updating App.jsx with registration routing..."

cat > src/App.jsx << 'EOF'
import React, { useEffect, useCallback } from 'react';
import { AppProvider, useApp } from './context/AppContext';
import Header from './components/Layout/Header';
import HomeView from './components/Views/HomeView';
import VenueDetailsView from './components/Views/VenueDetailsView';
import RegistrationView from './components/Views/RegistrationView';
import ShareModal from './components/Social/ShareModal';
import RatingModal from './components/Venue/RatingModal';
import ReportModal from './components/Venue/ReportModal';
import UserProfileModal from './components/User/UserProfileModal';
import './App.css';

function AppContent() {
  const { state, actions } = useApp();
  const { 
    currentView, 
    selectedVenue, 
    searchQuery, 
    activeFilter,
    showShareModal,
    showRatingModal,
    showReportModal,
    showUserProfileModal
  } = state;

  // Auto-update venue data every 45 seconds
  const updateVenueData = useCallback(() => {
    actions.updateVenueData();
  }, [actions]);

  useEffect(() => {
    const interval = setInterval(updateVenueData, 45000);
    return () => clearInterval(interval);
  }, [updateVenueData]);

  // Filter venues based on search query and active filter
  const filteredVenues = state.venues.filter(venue => {
    const matchesSearch = !searchQuery || 
      venue.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
      venue.type.toLowerCase().includes(searchQuery.toLowerCase()) ||
      venue.address.toLowerCase().includes(searchQuery.toLowerCase()) ||
      venue.vibe.some(v => v.toLowerCase().includes(searchQuery.toLowerCase()));

    const matchesFilter = activeFilter === 'all' || 
      (activeFilter === 'bars' && venue.type.toLowerCase().includes('bar')) ||
      (activeFilter === 'clubs' && (venue.type.toLowerCase().includes('club') || venue.type.toLowerCase().includes('dance'))) ||
      (activeFilter === 'lounges' && venue.type.toLowerCase().includes('lounge')) ||
      (activeFilter === 'promotions' && venue.hasPromotion);

    return matchesSearch && matchesFilter;
  });

  // Event Handlers
  const handleViewVenueDetails = (venue) => {
    actions.setSelectedVenue(venue);
    actions.setCurrentView('details');
    actions.addNotification({
      type: 'default',
      message: `📍 Viewing details for ${venue.name}`
    });
  };

  const handleBackToHome = () => {
    actions.setCurrentView('home');
    actions.setSelectedVenue(null);
  };

  const handleShare = (venue) => {
    actions.setShareVenue(venue);
    actions.setShowShareModal(true);
  };

  const handleSearchChange = (query) => {
    actions.setSearchQuery(query);
  };

  const handleClearSearch = () => {
    actions.setSearchQuery('');
    actions.setActiveFilter('all');
    actions.addNotification({
      type: 'success',
      message: '🔍 Search cleared - showing all venues'
    });
  };

  const handleFilterChange = (filter) => {
    actions.setActiveFilter(filter);
  };

  // Registration handlers
  const handleShowRegistration = () => {
    actions.setCurrentView('registration');
  };

  const handleRegistrationSuccess = (userData) => {
    console.log('✅ Registration successful, user data:', userData);
    
    // Register user in context
    actions.registerUser(userData);
    
    // Show success notification
    actions.addNotification({
      type: 'success',
      message: `🎉 Welcome to nYtevibe, ${userData.firstName || userData.first_name}! Registration successful.`,
      duration: 5000
    });
    
    // Navigate to home
    actions.setCurrentView('home');
  };

  const handleBackFromRegistration = () => {
    actions.setCurrentView('home');
  };

  // Auto-rotate promotional banners
  useEffect(() => {
    const interval = setInterval(() => {
      const nextIndex = (state.activeBannerIndex + 1) % state.banners.length;
      actions.setActiveBanner(nextIndex);
    }, 5000);

    return () => clearInterval(interval);
  }, [state.activeBannerIndex, state.banners.length, actions]);

  return (
    <div className="app-layout">
      {/* Header - Show on home and details views */}
      {currentView !== 'registration' && (
        <Header
          searchQuery={searchQuery}
          setSearchQuery={handleSearchChange}
          onClearSearch={handleClearSearch}
          activeFilter={activeFilter}
          onFilterChange={handleFilterChange}
          onShowRegistration={handleShowRegistration}
        />
      )}

      {/* Main Content */}
      <main className="main-content">
        {currentView === 'home' && (
          <HomeView
            venues={filteredVenues}
            searchQuery={searchQuery}
            onViewDetails={handleViewVenueDetails}
            onShare={handleShare}
          />
        )}

        {currentView === 'details' && (
          <VenueDetailsView
            venue={selectedVenue}
            onBack={handleBackToHome}
            onShare={handleShare}
          />
        )}

        {currentView === 'registration' && (
          <RegistrationView
            onBack={handleBackFromRegistration}
            onRegistrationSuccess={handleRegistrationSuccess}
          />
        )}
      </main>

      {/* Modals */}
      {showShareModal && <ShareModal />}
      {showRatingModal && <RatingModal />}
      {showReportModal && <ReportModal />}
      {showUserProfileModal && <UserProfileModal />}
    </div>
  );
}

function App() {
  return (
    <AppProvider>
      <AppContent />
    </AppProvider>
  );
}

export default App;
EOF

# 7. Final completion message
echo ""
echo "✅ nYtevibe Registration Process Fix Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🔧 Issues Fixed:"
echo " ✅ Design and layout completely restored"
echo " ✅ Professional registration view implemented"
echo " ✅ API service with proper field mapping (camelCase → snake_case)"
echo " ✅ Comprehensive error handling and debugging"
echo " ✅ Mobile-first responsive design"
echo " ✅ Demo credentials system for testing"
echo " ✅ Context integration with registration state"
echo " ✅ Notification system for user feedback"
echo ""
echo "🔌 API Features:"
echo " ✅ Automatic field transformation (camelCase → snake_case)"
echo " ✅ Network connectivity monitoring"
echo " ✅ Comprehensive error messages and debugging"
echo " ✅ Request/response logging for troubleshooting"
echo " ✅ Proper authentication header management"
echo " ✅ CORS and connectivity error handling"
echo ""
echo "📱 Design Enhancements:"
echo " ✅ Professional registration page with glass morphism"
echo " ✅ Mobile-optimized responsive design"
echo " ✅ Interactive form validation with real-time feedback"
echo " ✅ User type selection (User/Business)"
echo " ✅ Password visibility toggles"
echo " ✅ Demo credentials auto-fill functionality"
echo " ✅ Loading states and animations"
echo ""
echo "🎯 To Test Registration:"
echo " 1. Start your development server: npm run dev"
echo " 2. Navigate to the registration page"
echo " 3. Click 'Fill Demo' to auto-populate test credentials"
echo " 4. Submit the form to test API integration"
echo " 5. Check browser console for detailed API logging"
echo ""
echo "🔍 API Debugging:"
echo " • All API requests/responses are logged to console"
echo " • Field transformation is logged (camelCase → snake_case)"
echo " • Network errors include helpful troubleshooting messages"
echo " • Check console for detailed API communication information"
echo ""
echo "📞 Backend API Expected Format:"
echo " • Endpoint: POST /api/auth/register"
echo " • Fields: first_name, last_name, username, email, password, password_confirmation, user_type"
echo " • Headers: Content-Type: application/json, Accept: application/json"
echo ""
echo "Status: 🟢 DESIGN RESTORED & API INTEGRATION READY"
EOF

# Make the script executable
chmod +x nytevibe_registration_fix.sh

echo ""
echo "🎯 Script created successfully!"
echo ""
echo "To fix your nYtevibe registration issues:"
echo "1. Save this script as 'nytevibe_registration_fix.sh'"
echo "2. Make it executable: chmod +x nytevibe_registration_fix.sh"
echo "3. Run it from your project directory: ./nytevibe_registration_fix.sh"
echo ""
echo "This script will:"
echo "✅ Restore your complete design and layout"
echo "✅ Create a professional registration page"
echo "✅ Fix API field mapping (camelCase → snake_case)"
echo "✅ Add comprehensive error handling and debugging"
echo "✅ Provide demo credentials for easy testing"
echo ""
echo "The script preserves all existing functionality while adding the registration system!"
