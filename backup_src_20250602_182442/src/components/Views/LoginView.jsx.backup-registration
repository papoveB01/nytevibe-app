import React, { useState } from 'react';
import { ArrowLeft, Eye, EyeOff, Lock, User, AlertCircle } from 'lucide-react';

const LoginView = ({ onBack, onLogin }) => {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [error, setError] = useState('');
  const [isLoading, setIsLoading] = useState(false);

  const demoCredentials = {
    username: 'demouser',
    password: 'demopass'
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setIsLoading(true);

    // Simulate API call delay
    setTimeout(() => {
      if (username === demoCredentials.username && password === demoCredentials.password) {
        onLogin({
          id: 'usr_demo',
          username: username,
          firstName: 'Demo',
          lastName: 'User'
        });
      } else {
        setError('Invalid username or password. Try: demouser / demopass');
      }
      setIsLoading(false);
    }, 1000);
  };

  const handleForgotPassword = () => {
    alert('Demo: Use credentials - Username: demouser, Password: demopass');
  };

  const handleSignup = () => {
    alert('Demo: Use existing credentials - Username: demouser, Password: demopass');
  };

  const fillDemoCredentials = () => {
    setUsername(demoCredentials.username);
    setPassword(demoCredentials.password);
    setError('');
  };

  return (
    <div className="login-page">
      <div className="login-background">
        <div className="login-gradient"></div>
      </div>

      <div className="login-container">
        {/* Header */}
        <div className="login-header">
          <button onClick={onBack} className="back-button-login">
            <ArrowLeft className="w-5 h-5" />
            <span>Back to Landing</span>
          </button>
        </div>

        {/* Login Card */}
        <div className="login-card">
          <div className="login-card-header">
            <div className="login-logo">
              <div className="logo-icon">
                <User className="w-8 h-8" />
              </div>
              <h1 className="login-title">Welcome Back</h1>
              <p className="login-subtitle">Sign in to discover Houston's nightlife</p>
            </div>
          </div>

          <div className="login-card-body">
            {/* Demo Credentials Banner */}
            <div className="demo-banner">
              <div className="demo-content">
                <div className="demo-icon">
                  <AlertCircle className="w-4 h-4" />
                </div>
                <div className="demo-text">
                  <strong>Demo Mode:</strong> Username: demouser, Password: demopass
                </div>
                <button 
                  onClick={fillDemoCredentials}
                  className="demo-fill-button"
                  type="button"
                >
                  Fill Demo
                </button>
              </div>
            </div>

            {/* Login Form */}
            <form onSubmit={handleSubmit} className="login-form">
              {error && (
                <div className="error-banner">
                  <AlertCircle className="w-4 h-4" />
                  <span>{error}</span>
                </div>
              )}

              <div className="form-group">
                <label htmlFor="username" className="form-label">
                  Username
                </label>
                <div className="input-wrapper">
                  <User className="input-icon" />
                  <input
                    id="username"
                    type="text"
                    value={username}
                    onChange={(e) => setUsername(e.target.value)}
                    className="form-input"
                    placeholder="Enter your username"
                    required
                  />
                </div>
              </div>

              <div className="form-group">
                <label htmlFor="password" className="form-label">
                  Password
                </label>
                <div className="input-wrapper">
                  <Lock className="input-icon" />
                  <input
                    id="password"
                    type={showPassword ? 'text' : 'password'}
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    className="form-input"
                    placeholder="Enter your password"
                    required
                  />
                  <button
                    type="button"
                    onClick={() => setShowPassword(!showPassword)}
                    className="password-toggle"
                  >
                    {showPassword ? (
                      <EyeOff className="w-4 h-4" />
                    ) : (
                      <Eye className="w-4 h-4" />
                    )}
                  </button>
                </div>
              </div>

              <div className="form-actions">
                <button
                  type="submit"
                  disabled={isLoading}
                  className={`login-button ${isLoading ? 'loading' : ''}`}
                >
                  {isLoading ? (
                    <>
                      <div className="loading-spinner"></div>
                      Signing In...
                    </>
                  ) : (
                    'Sign In'
                  )}
                </button>
              </div>

              <div className="form-links">
                <button
                  type="button"
                  onClick={handleForgotPassword}
                  className="forgot-password-link"
                >
                  Forgot Password?
                </button>
              </div>
            </form>
          </div>

          <div className="login-card-footer">
            <p className="signup-text">
              New to nYtevibe?{' '}
              <button onClick={handleSignup} className="signup-link">
                Sign up here
              </button>
            </p>
          </div>
        </div>

        {/* Features Preview */}
        <div className="login-features">
          <h3 className="features-title">What you'll get:</h3>
          <ul className="features-list">
            <li>🌟 Discover trending venues in real-time</li>
            <li>💖 Save and follow your favorite spots</li>
            <li>⭐ Rate and review venues</li>
            <li>🎯 Get personalized recommendations</li>
            <li>📊 Earn points for community contributions</li>
          </ul>
        </div>
      </div>
    </div>
  );
};

export default LoginView;
