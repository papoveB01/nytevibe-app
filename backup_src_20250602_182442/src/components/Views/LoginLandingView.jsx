import React, { useState, useEffect } from 'react';
import { Eye, EyeOff, User, Lock, ArrowRight, Sparkles, Smartphone, Zap } from 'lucide-react';

const LoginLandingView = ({ onLogin, onNavigateToRegister, onForgotPassword }) => {
  // Pre-fill with demo credentials for development
  const [formData, setFormData] = useState({
    email: 'demo@nytevibe.com',
    password: 'demo123'
  });
  const [showPassword, setShowPassword] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState('');
  const [isMobile, setIsMobile] = useState(false);
  const [autoLoginReady, setAutoLoginReady] = useState(true);

  // Demo credentials for testing
  const demoCredentials = {
    email: 'demo@nytevibe.com',
    password: 'demo123'
  };

  // Detect mobile device
  useEffect(() => {
    const checkMobile = () => {
      setIsMobile(window.innerWidth <= 768);
    };
    
    checkMobile();
    window.addEventListener('resize', checkMobile);
    return () => window.removeEventListener('resize', checkMobile);
  }, []);

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: value
    }));
    if (error) setError('');
    
    // Check if credentials match demo for auto-login readiness
    const newFormData = { ...formData, [name]: value };
    setAutoLoginReady(
      newFormData.email === demoCredentials.email && 
      newFormData.password === demoCredentials.password
    );
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setIsLoading(true);
    setError('');

    // Simulate API call delay (shorter for development)
    setTimeout(() => {
      // Demo authentication
      if (formData.email === demoCredentials.email && formData.password === demoCredentials.password) {
        onLogin({
          id: 'demo_user_001',
          email: formData.email,
          firstName: 'Demo',
          lastName: 'User',
          level: 3,
          points: 1250
        });
      } else if (formData.email && formData.password) {
        // For demo purposes, accept any valid email/password combination
        onLogin({
          id: `user_${Date.now()}`,
          email: formData.email,
          firstName: formData.email.split('@')[0],
          lastName: 'User',
          level: 1,
          points: 0
        });
      } else {
        setError('Please enter both email and password');
      }
      setIsLoading(false);
    }, 800); // Faster for development
  };

  const fillDemoCredentials = () => {
    setFormData(demoCredentials);
    setError('');
    setAutoLoginReady(true);
  };

  const handleQuickLogin = () => {
    if (autoLoginReady) {
      handleSubmit({ preventDefault: () => {} });
    } else {
      fillDemoCredentials();
      setTimeout(() => {
        handleSubmit({ preventDefault: () => {} });
      }, 100);
    }
  };

  // Mobile-optimized layout
  if (isMobile) {
    return (
      <div className="login-landing-page mobile-optimized">
        {/* Mobile Background */}
        <div className="mobile-login-background">
          <div className="mobile-gradient-overlay"></div>
          <div className="mobile-pattern"></div>
        </div>

        {/* Mobile Header */}
        <div className="mobile-login-header">
          <div className="mobile-brand-logo">
            <div className="mobile-logo-icon">
              <Sparkles className="mobile-logo-sparkle" />
            </div>
            <h1 className="mobile-brand-title">nYtevibe</h1>
          </div>
          <p className="mobile-brand-tagline">Houston's Best Nightlife</p>
        </div>

        {/* Mobile Login Form */}
        <div className="mobile-login-container">
          <div className="mobile-login-card">
            <div className="mobile-login-header-text">
              <h2 className="mobile-login-title">Welcome Back</h2>
              <p className="mobile-login-subtitle">Ready to discover Houston's nightlife</p>
            </div>

            {/* Mobile Dev Helper Banner */}
            <div className="mobile-dev-banner">
              <div className="mobile-dev-content">
                <div className="mobile-dev-info">
                  <Zap size={16} />
                  <span><strong>DEV MODE:</strong> Credentials pre-filled for testing</span>
                </div>
                <button 
                  type="button" 
                  className="mobile-quick-login-btn"
                  onClick={handleQuickLogin}
                  disabled={isLoading}
                >
                  {isLoading ? 'Logging In...' : 'Quick Login'}
                </button>
              </div>
            </div>

            {/* Mobile Form */}
            <form onSubmit={handleSubmit} className="mobile-login-form">
              {error && (
                <div className="mobile-error-banner">
                  <span className="mobile-error-text">{error}</span>
                </div>
              )}

              <div className="mobile-form-group">
                <label className="mobile-form-label">Email Address</label>
                <div className="mobile-input-wrapper">
                  <User className="mobile-input-icon" />
                  <input
                    type="email"
                    name="email"
                    value={formData.email}
                    onChange={handleInputChange}
                    placeholder="Enter your email"
                    className="mobile-form-input"
                    autoComplete="email"
                    autoCapitalize="none"
                    autoCorrect="off"
                    spellCheck="false"
                    required
                  />
                </div>
              </div>

              <div className="mobile-form-group">
                <label className="mobile-form-label">Password</label>
                <div className="mobile-input-wrapper">
                  <Lock className="mobile-input-icon" />
                  <input
                    type={showPassword ? 'text' : 'password'}
                    name="password"
                    value={formData.password}
                    onChange={handleInputChange}
                    placeholder="Enter your password"
                    className="mobile-form-input"
                    autoComplete="current-password"
                    required
                  />
                  <button
                    type="button"
                    className="mobile-password-toggle"
                    onClick={() => setShowPassword(!showPassword)}
                  >
                    {showPassword ? <EyeOff size={20} /> : <Eye size={20} />}
                  </button>
                </div>
              </div>

              <button
                type="submit"
                className={`mobile-login-submit-btn ${isLoading ? 'loading' : ''} ${autoLoginReady ? 'ready' : ''}`}
                disabled={isLoading}
              >
                {isLoading ? (
                  <div className="mobile-loading-content">
                    <div className="mobile-loading-spinner"></div>
                    <span>Signing In...</span>
                  </div>
                ) : (
                  <div className="mobile-button-content">
                    <span>{autoLoginReady ? 'Sign In (Ready!)' : 'Sign In'}</span>
                    <ArrowRight size={20} />
                  </div>
                )}
              </button>
            </form>

            {/* Mobile Footer Actions */}
            <div className="mobile-footer-actions">
              <button
                type="button"
                className="mobile-forgot-password-link"
                onClick={onForgotPassword}
              >
                Forgot Password?
              </button>
              
              <div className="mobile-register-section">
                <span className="mobile-register-text">New to nYtevibe? </span>
                <button
                  type="button"
                  className="mobile-register-link"
                  onClick={onNavigateToRegister}
                >
                  Join the Community
                </button>
              </div>
            </div>
          </div>
        </div>

        {/* Mobile Footer */}
        <div className="mobile-login-footer">
          <p>&copy; 2025 nYtevibe. Discover Houston's Best Nightlife.</p>
        </div>
      </div>
    );
  }

  // Desktop layout with auto-login features
  return (
    <div className="login-landing-page">
      {/* Background Effects */}
      <div className="login-background">
        <div className="login-gradient-overlay"></div>
        <div className="login-pattern"></div>
      </div>

      {/* Main Content */}
      <div className="login-container">
        {/* Left Side - Branding */}
        <div className="login-branding">
          <div className="brand-content">
            <div className="brand-logo">
              <div className="logo-icon">
                <Sparkles className="logo-sparkle" />
              </div>
              <h1 className="brand-title">nYtevibe</h1>
              <p className="brand-tagline">Houston's Premier Nightlife Discovery Platform</p>
            </div>
            
            <div className="feature-highlights">
              <div className="feature-item">
                <div className="feature-icon">🌟</div>
                <div className="feature-text">
                  <h4>Real-Time Insights</h4>
                  <p>Live crowd levels and wait times</p>
                </div>
              </div>
              <div className="feature-item">
                <div className="feature-icon">🎯</div>
                <div className="feature-text">
                  <h4>Smart Discovery</h4>
                  <p>AI-powered venue recommendations</p>
                </div>
              </div>
              <div className="feature-item">
                <div className="feature-icon">👥</div>
                <div className="feature-text">
                  <h4>Community Driven</h4>
                  <p>Reviews and ratings from locals</p>
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Right Side - Login Form */}
        <div className="login-form-section">
          <div className="login-card">
            <div className="login-header">
              <h2 className="login-title">Welcome Back</h2>
              <p className="login-subtitle">Ready to discover Houston's best nightlife</p>
            </div>

            {/* Development Helper Banner */}
            <div className="dev-helper-banner">
              <div className="dev-content">
                <div className="dev-info">
                  <Zap size={18} />
                  <div>
                    <strong>🚀 Development Mode</strong>
                    <span>Credentials pre-filled for quick testing</span>
                  </div>
                </div>
                <button 
                  type="button" 
                  className="quick-login-btn"
                  onClick={handleQuickLogin}
                  disabled={isLoading}
                >
                  {isLoading ? 'Logging In...' : 'Quick Login'}
                </button>
              </div>
            </div>

            {/* Login Form */}
            <form onSubmit={handleSubmit} className="login-form">
              {error && (
                <div className="error-banner">
                  <span className="error-text">{error}</span>
                </div>
              )}

              <div className="form-group">
                <label className="form-label">Email Address</label>
                <div className="input-wrapper">
                  <User className="input-icon" />
                  <input
                    type="email"
                    name="email"
                    value={formData.email}
                    onChange={handleInputChange}
                    placeholder="Enter your email"
                    className="form-input pre-filled"
                    autoComplete="email"
                    required
                  />
                </div>
              </div>

              <div className="form-group">
                <label className="form-label">Password</label>
                <div className="input-wrapper">
                  <Lock className="input-icon" />
                  <input
                    type={showPassword ? 'text' : 'password'}
                    name="password"
                    value={formData.password}
                    onChange={handleInputChange}
                    placeholder="Enter your password"
                    className="form-input pre-filled"
                    autoComplete="current-password"
                    required
                  />
                  <button
                    type="button"
                    className="password-toggle"
                    onClick={() => setShowPassword(!showPassword)}
                  >
                    {showPassword ? <EyeOff size={18} /> : <Eye size={18} />}
                  </button>
                </div>
              </div>

              <div className="form-options">
                <button
                  type="button"
                  className="forgot-password-link"
                  onClick={onForgotPassword}
                >
                  Forgot Password?
                </button>
              </div>

              <button
                type="submit"
                className={`login-submit-btn ${isLoading ? 'loading' : ''} ${autoLoginReady ? 'ready' : ''}`}
                disabled={isLoading}
              >
                {isLoading ? (
                  <div className="loading-content">
                    <div className="loading-spinner"></div>
                    <span>Signing In...</span>
                  </div>
                ) : (
                  <div className="button-content">
                    <span>{autoLoginReady ? 'Sign In (Ready!)' : 'Sign In'}</span>
                    <ArrowRight size={18} />
                  </div>
                )}
              </button>
            </form>

            {/* Register Link */}
            <div className="register-section">
              <p className="register-text">
                New to nYtevibe?{' '}
                <button
                  type="button"
                  className="register-link"
                  onClick={onNavigateToRegister}
                >
                  Join the Community
                </button>
              </p>
            </div>
          </div>
        </div>
      </div>

      {/* Footer */}
      <div className="login-footer">
        <p>&copy; 2025 nYtevibe. Discover Houston's Best Nightlife.</p>
      </div>
    </div>
  );
};

export default LoginLandingView;
