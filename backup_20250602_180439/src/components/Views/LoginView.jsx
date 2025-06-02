import React, { useState } from 'react';
import { ArrowLeft, Eye, EyeOff, Mail, Lock, LogIn } from 'lucide-react';

const LoginView = ({ onBack, onLogin, onSwitchToRegister }) => {
  const [username, setUsername] = useState('demouser');
  const [password, setPassword] = useState('demopass');
  const [showPassword, setShowPassword] = useState(false);
  const [error, setError] = useState('');
  const [isLoading, setIsLoading] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setIsLoading(true);

    try {
      const result = await onLogin({
        email: username,
        password: password
      });

      if (!result.success) {
        setError(result.error || 'Login failed. Please try again.');
      }
    } catch (error) {
      setError('An unexpected error occurred. Please try again.');
    } finally {
      setIsLoading(false);
    }
  };

  const fillDemoCredentials = () => {
    setUsername('demouser');
    setPassword('demopass');
    setError('');
  };

  return (
    <div className="login-page">
      <div className="login-background">
        <div className="login-gradient"></div>
      </div>
      
      <div className="login-container">
        <div className="login-card">
          <div className="login-header">
            <button onClick={onBack} className="back-button">
              <ArrowLeft className="w-4 h-4" />
              <span>Back to Landing</span>
            </button>
          </div>

          <div className="login-card-header">
            <div className="login-logo">
              <div className="logo-icon">
                <LogIn className="w-8 h-8" />
              </div>
              <div className="logo-text">
                <h2 className="login-title">Welcome Back</h2>
                <p className="login-subtitle">Sign in to continue to nYtevibe</p>
              </div>
            </div>
          </div>

          <div className="demo-banner">
            <div className="demo-content">
              <div className="demo-text">
                <strong>Demo:</strong> Use <code>demouser</code> / <code>demopass</code>
              </div>
              <button 
                type="button" 
                className="demo-fill-button"
                onClick={fillDemoCredentials}
              >
                Fill Demo
              </button>
            </div>
          </div>

          {error && (
            <div className="error-banner">
              <span className="error-icon">⚠️</span>
              {error}
            </div>
          )}

          <form onSubmit={handleSubmit} className="login-form">
            <div className="form-group">
              <label htmlFor="username" className="form-label">Email or Username</label>
              <div className="input-wrapper">
                <Mail className="input-icon" size={16} />
                <input
                  id="username"
                  type="text"
                  value={username}
                  onChange={(e) => setUsername(e.target.value)}
                  className="form-input"
                  placeholder="Enter your email or username"
                  required
                />
              </div>
            </div>

            <div className="form-group">
              <label htmlFor="password" className="form-label">Password</label>
              <div className="input-wrapper">
                <Lock className="input-icon" size={16} />
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
                  className="password-toggle"
                  onClick={() => setShowPassword(!showPassword)}
                >
                  {showPassword ? <EyeOff size={16} /> : <Eye size={16} />}
                </button>
              </div>
            </div>

            <button
              type="submit"
              className={`login-button ${isLoading ? 'loading' : ''}`}
              disabled={isLoading}
            >
              {isLoading ? (
                <>
                  <div className="loading-spinner"></div>
                  Signing In...
                </>
              ) : (
                <>
                  <LogIn className="w-4 h-4" />
                  Sign In
                </>
              )}
            </button>
          </form>

          <div className="login-card-footer">
            <p>
              Don't have an account?{' '}
              <button 
                type="button" 
                className="link-button"
                onClick={onSwitchToRegister}
              >
                Create Account
              </button>
            </p>
            <p>
              <button type="button" className="link-button">
                Forgot Password?
              </button>
            </p>
          </div>
        </div>

        <div className="login-features">
          <h3>Houston's Premier Nightlife Discovery</h3>
          <ul className="features-list">
            <li>🔍 Real-time venue discovery</li>
            <li>📊 Live crowd levels and wait times</li>
            <li>⭐ Community-driven reviews</li>
            <li>❤️ Follow your favorite venues</li>
            <li>🎯 Personalized recommendations</li>
            <li>🏆 Earn points and achievements</li>
          </ul>
        </div>
      </div>
    </div>
  );
};

export default LoginView;
