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
