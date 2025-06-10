import React, { useState, useEffect } from 'react';
import { useApp } from '../../context/AppContext';
import authAPI from '../../services/authAPI';
import './Login.css';

const Login = ({ onLoginSuccess }) => {
  const { actions } = useApp();
  const [formData, setFormData] = useState({
    login: '',  // Can be email or username
    password: ''
  });
  const [rememberMe, setRememberMe] = useState(true); // Default to true for better UX
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [showPassword, setShowPassword] = useState(false);

  // Clear error when component unmounts
  useEffect(() => {
    return () => setError('');
  }, []);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: value
    }));
    // Clear error when user types
    if (error) setError('');
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    setError('');

    // Debug logging
    console.log('=== LOGIN DEBUG ===');
    console.log('Login attempt:', {
      login: formData.login,
      rememberMe: rememberMe
    });

    try {
      // Use authAPI service for login
      const response = await authAPI.login(
        formData.login,
        formData.password,
        rememberMe
      );

      console.log('Login response:', {
        success: response.success,
        rememberMe: rememberMe,
        expiresAt: response.expires_at
      });

      if (response.success) {
        // Success! The authAPI has already stored the token and user data
        console.log('Login successful!', {
          user: response.user,
          tokenExpiry: response.expires_at
        });

        // Update app context if actions are available
        if (actions) {
          actions.setUser(response.user);
          actions.setIsAuthenticated(true);
          actions.setCurrentView('home');
        }

        // Call the success callback if provided
        if (onLoginSuccess) {
          onLoginSuccess(response);
        }
      } else {
        // Handle specific error cases
        let errorMessage = 'Login failed. Please try again.';
        
        if (response.code === 'EMAIL_NOT_VERIFIED') {
          errorMessage = 'Please verify your email before logging in. Check your inbox for the verification link.';
        } else if (response.code === 'INVALID_CREDENTIALS') {
          errorMessage = 'Invalid username/email or password. Please try again.';
        } else if (response.code === 'ACCOUNT_SUSPENDED') {
          errorMessage = 'Your account has been suspended. Please contact support.';
        } else if (response.code === 'NETWORK_ERROR') {
          errorMessage = 'Network error. Please check your connection and try again.';
        } else if (response.error) {
          errorMessage = response.error;
        }
        
        setError(errorMessage);
        console.error('Login failed:', response);
      }
    } catch (error) {
      console.error('Unexpected error during login:', error);
      setError('An unexpected error occurred. Please try again.');
    } finally {
      setLoading(false);
    }
  };

  const handleForgotPassword = () => {
    if (actions) {
      actions.setCurrentView('forgot-password');
    }
  };

  const handleSignUp = () => {
    if (actions) {
      actions.setCurrentView('register');
    }
  };

  const togglePasswordVisibility = () => {
    setShowPassword(!showPassword);
  };

  return (
    <div className="login-container">
      <div className="login-card">
        <div className="login-header">
          <h1 className="app-logo">nYtevibe</h1>
          <h2>Welcome Back</h2>
          <p>Sign in to continue to your nightlife experience</p>
        </div>

        <form onSubmit={handleSubmit} className="login-form">
          <div className="form-group">
            <label htmlFor="login">Username or Email</label>
            <input
              type="text"
              id="login"
              name="login"
              value={formData.login}
              onChange={handleChange}
              placeholder="Enter your username or email"
              required
              disabled={loading}
              autoComplete="username"
              autoFocus
              className="form-input"
            />
          </div>

          <div className="form-group">
            <label htmlFor="password">Password</label>
            <div className="password-input-wrapper">
              <input
                type={showPassword ? "text" : "password"}
                id="password"
                name="password"
                value={formData.password}
                onChange={handleChange}
                placeholder="Enter your password"
                required
                disabled={loading}
                autoComplete="current-password"
                className="form-input"
              />
              <button
                type="button"
                className="password-toggle"
                onClick={togglePasswordVisibility}
                tabIndex="-1"
                aria-label={showPassword ? "Hide password" : "Show password"}
              >
                {showPassword ? (
                  <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                    <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"/>
                    <line x1="1" y1="1" x2="23" y2="23"/>
                  </svg>
                ) : (
                  <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                    <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                    <circle cx="12" cy="12" r="3"/>
                  </svg>
                )}
              </button>
            </div>
          </div>

          <div className="form-options">
            <label className="remember-me-container">
              <input
                type="checkbox"
                checked={rememberMe}
                onChange={(e) => setRememberMe(e.target.checked)}
                disabled={loading}
                className="remember-checkbox"
              />
              <span className="remember-label">Keep me logged in for 30 days</span>
            </label>
            
            <button
              type="button"
              className="forgot-password-link"
              onClick={handleForgotPassword}
              disabled={loading}
            >
              Forgot Password?
            </button>
          </div>

          {error && (
            <div className="error-message">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" className="error-icon">
                <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/>
                <line x1="12" y1="9" x2="12" y2="13"/>
                <line x1="12" y1="17" x2="12.01" y2="17"/>
              </svg>
              <span>{error}</span>
            </div>
          )}

          <button
            type="submit"
            className="login-button"
            disabled={loading}
          >
            {loading ? (
              <>
                <span className="button-spinner"></span>
                <span>Signing in...</span>
              </>
            ) : (
              'Sign In'
            )}
          </button>
        </form>

        <div className="login-footer">
          <p className="signup-prompt">
            Don't have an account?{' '}
            <button
              type="button"
              className="signup-link"
              onClick={handleSignUp}
              disabled={loading}
            >
              Sign up
            </button>
          </p>
        </div>

        {rememberMe && (
          <div className="security-note">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor">
              <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
              <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
            </svg>
            <p>Your session will remain active for 30 days on this device</p>
          </div>
        )}

        {/* Debug info in development */}
        {process.env.NODE_ENV === 'development' && (
          <div className="debug-info">
            <small>Check browser console for debug information</small>
          </div>
        )}
      </div>
    </div>
  );
};

export default Login;
