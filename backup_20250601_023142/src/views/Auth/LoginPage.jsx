import React, { useState } from 'react';
import { Eye, EyeOff, Lock, User, ArrowLeft } from 'lucide-react';
import { useApp } from '../../context/AppContext';
import './LoginPage.css';

const LoginPage = () => {
  const { actions } = useApp();
  const [formData, setFormData] = useState({
    username: '',
    password: ''
  });
  const [showPassword, setShowPassword] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState('');

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: value
    }));
    // Clear error when user starts typing
    if (error) setError('');
  };

  const handleLogin = async (e) => {
    e.preventDefault();
    setIsLoading(true);
    setError('');

    // Demo credentials validation
    const { username, password } = formData;
    
    if (!username || !password) {
      setError('Please enter both username and password');
      setIsLoading(false);
      return;
    }

    // Simulate login process with loading delay
    setTimeout(() => {
      if (username === 'userDemo' && password === 'userDemo') {
        // Successful login - create session
        const userData = {
          username: 'userDemo',
          isAuthenticated: true,
          loginTime: new Date().toISOString()
        };

        const loginSuccess = actions.login(userData);
        
        if (loginSuccess) {
          actions.addNotification({
            type: 'success',
            message: '🎉 Welcome back! Login successful (Session: 24hrs)',
            duration: 4000
          });
          actions.setCurrentView('home');
        } else {
          setError('Failed to create session. Please try again.');
        }
      } else {
        // Failed login
        setError('Invalid username or password. Try userDemo/userDemo');
      }
      setIsLoading(false);
    }, 1500);
  };

  const handleBackToLanding = () => {
    actions.setCurrentView('landing');
    actions.setCurrentMode(null);
  };

  const handleForgotPassword = () => {
    actions.addNotification({
      type: 'default',
      message: '🔗 Password reset link sent to your email',
      duration: 3000
    });
  };

  const handleSignup = () => {
    actions.addNotification({
      type: 'default',
      message: '📝 Signup functionality coming soon!',
      duration: 3000
    });
  };

  const handleQuickLogin = () => {
    setFormData({ username: 'userDemo', password: 'userDemo' });
    setError('');
  };

  return (
    <div className="login-page">
      <div className="login-container">
        {/* Header */}
        <div className="login-header">
          <button onClick={handleBackToLanding} className="back-to-landing">
            <ArrowLeft className="w-5 h-5" />
            <span>Back to Selection</span>
          </button>
        </div>

        {/* Login Card */}
        <div className="login-card">
          {/* Logo/Branding */}
          <div className="login-branding">
            <h1 className="login-logo">nYtevibe</h1>
            <h2 className="login-title">Customer Login</h2>
            <p className="login-subtitle">
              Welcome back! Sign in to discover Houston's nightlife.
            </p>
          </div>

          {/* Demo Credentials Info */}
          <div className="demo-credentials">
            <div className="demo-header">
              <span className="demo-icon">🔑</span>
              <span className="demo-title">Demo Credentials</span>
            </div>
            <div className="demo-info">
              <p><strong>Username:</strong> userDemo</p>
              <p><strong>Password:</strong> userDemo</p>
              <button 
                onClick={handleQuickLogin}
                className="quick-login-btn"
                disabled={isLoading}
              >
                Quick Fill
              </button>
            </div>
          </div>

          {/* Session Info */}
          <div className="session-info">
            <div className="session-features">
              <div className="session-feature">
                <span className="feature-icon">⏰</span>
                <span className="feature-text">24-hour session</span>
              </div>
              <div className="session-feature">
                <span className="feature-icon">🔄</span>
                <span className="feature-text">Auto-login on return</span>
              </div>
              <div className="session-feature">
                <span className="feature-icon">🔒</span>
                <span className="feature-text">Secure localStorage</span>
              </div>
            </div>
          </div>

          {/* Login Form */}
          <form onSubmit={handleLogin} className="login-form">
            {/* Username Field */}
            <div className="form-group">
              <label htmlFor="username" className="form-label">
                <User className="w-4 h-4" />
                Username
              </label>
              <input
                type="text"
                id="username"
                name="username"
                value={formData.username}
                onChange={handleInputChange}
                className="form-input"
                placeholder="Enter your username"
                disabled={isLoading}
                autoComplete="username"
              />
            </div>

            {/* Password Field */}
            <div className="form-group">
              <label htmlFor="password" className="form-label">
                <Lock className="w-4 h-4" />
                Password
              </label>
              <div className="password-input-wrapper">
                <input
                  type={showPassword ? 'text' : 'password'}
                  id="password"
                  name="password"
                  value={formData.password}
                  onChange={handleInputChange}
                  className="form-input password-input"
                  placeholder="Enter your password"
                  disabled={isLoading}
                  autoComplete="current-password"
                />
                <button
                  type="button"
                  onClick={() => setShowPassword(!showPassword)}
                  className="password-toggle"
                  disabled={isLoading}
                >
                  {showPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                </button>
              </div>
            </div>

            {/* Error Message */}
            {error && (
              <div className="error-message">
                <span className="error-icon">⚠️</span>
                {error}
              </div>
            )}

            {/* Login Button */}
            <button
              type="submit"
              disabled={isLoading}
              className={`login-button ${isLoading ? 'loading' : ''}`}
            >
              {isLoading ? (
                <>
                  <div className="loading-spinner"></div>
                  Creating Session...
                </>
              ) : (
                <>
                  <User className="w-4 h-4" />
                  Sign In & Create Session
                </>
              )}
            </button>

            {/* Additional Actions */}
            <div className="login-actions">
              <button
                type="button"
                onClick={handleForgotPassword}
                className="forgot-password-link"
                disabled={isLoading}
              >
                Forgot password?
              </button>

              <div className="signup-section">
                <span className="signup-text">Don't have an account?</span>
                <button
                  type="button"
                  onClick={handleSignup}
                  className="signup-link"
                  disabled={isLoading}
                >
                  Sign up for a new account
                </button>
              </div>
            </div>
          </form>
        </div>

        {/* Footer */}
        <div className="login-footer">
          <p>© 2024 nYtevibe. Houston's Premier Nightlife Discovery Platform.</p>
          <p className="session-note">
            <span className="session-note-icon">🔐</span>
            Your session will be saved securely for 24 hours
          </p>
        </div>
      </div>
    </div>
  );
};

export default LoginPage;
