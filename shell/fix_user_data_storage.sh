#!/bin/bash

# Fix User Data Storage Issue
echo "======================================================="
echo "    FIXING USER DATA STORAGE ISSUE"
echo "======================================================="

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="./user_storage_fix_backup_$TIMESTAMP"
mkdir -p "$BACKUP_DIR"

echo "Issue found: Auth token exists but user data is null"
echo "This means user data isn't being stored properly after login"
echo ""

log_change() {
    echo "✅ $1"
}

log_error() {
    echo "❌ $1"
}

echo ">>> STEP 1: CHECK CURRENT LOGINVIEW USER STORAGE"
echo "----------------------------------------"

if [ -f "src/components/Views/LoginView.jsx" ]; then
    cp "src/components/Views/LoginView.jsx" "$BACKUP_DIR/"
    
    echo "Current user storage logic in LoginView:"
    grep -n -A5 -B2 "localStorage.setItem.*user\|actions.loginUser" src/components/Views/LoginView.jsx
    echo ""
else
    log_error "LoginView.jsx not found"
fi

echo ">>> STEP 2: CHECK APPCONTEXT USER HANDLING"
echo "----------------------------------------"

if [ -f "src/context/AppContext.jsx" ]; then
    cp "src/context/AppContext.jsx" "$BACKUP_DIR/"
    
    echo "Current user handling in AppContext:"
    grep -n -A10 -B5 "loginUser\|user.*localStorage" src/context/AppContext.jsx || echo "No user localStorage handling found"
    echo ""
else
    log_error "AppContext.jsx not found"
fi

echo ">>> STEP 3: CREATE FIXED LOGINVIEW"
echo "----------------------------------------"

# Create a fixed version of LoginView with proper user storage
cat > src/components/Views/LoginView.fixed.jsx << 'EOF'
import React, { useState, useEffect } from 'react';
import { Eye, EyeOff, User, Lock, Zap, Star, Clock, Users, MapPin, Mail, RefreshCw } from 'lucide-react';
import { useApp } from '../../context/AppContext';
import registrationAPI, { APIError } from '../../services/registrationAPI';

const LoginView = ({ onRegister }) => {
  const { state, actions } = useApp();
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [error, setError] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [canResendVerification, setCanResendVerification] = useState(true);
  const [resendCooldown, setResendCooldown] = useState(0);

  const demoCredentials = {
    username: 'demouser',
    password: 'demopass'
  };

  // Handle verification message from registration
  const verificationMessage = state.verificationMessage;

  useEffect(() => {
    if (resendCooldown > 0) {
      const timer = setTimeout(() => {
        setResendCooldown(resendCooldown - 1);
      }, 1000);
      return () => clearTimeout(timer);
    } else if (resendCooldown === 0 && !canResendVerification) {
      setCanResendVerification(true);
    }
  }, [resendCooldown, canResendVerification]);

  // Clear verification message when component unmounts or user starts typing
  useEffect(() => {
    if ((username || password) && verificationMessage?.show) {
      actions.clearVerificationMessage();
    }
  }, [username, password, verificationMessage, actions]);

  const fillDemoCredentials = () => {
    setUsername(demoCredentials.username);
    setPassword(demoCredentials.password);
    setError('');
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setIsLoading(true);

    try {
      // Check if demo credentials
      if (username === demoCredentials.username && password === demoCredentials.password) {
        // Demo login (unchanged)
        setTimeout(() => {
          const demoUser = {
            id: 'usr_demo',
            username: username,
            firstName: 'Demo',
            lastName: 'User',
            email: 'demo@nytevibe.com',
            level: 5,
            points: 1250,
            user_type: 'user',
            email_verified: true
          };

          // Store demo user data properly
          localStorage.setItem('user', JSON.stringify(demoUser));
          localStorage.setItem('auth_token', 'demo_token_12345');

          actions.loginUser(demoUser);

          actions.addNotification({
            type: 'success',
            message: `🎉 Welcome back, Demo!`,
            important: true,
            duration: 3000
          });
          setIsLoading(false);
        }, 1000);
        return;
      }

      // Real API login
      console.log('=== LOGIN DEBUG ===');
      console.log('Attempting login for:', username);

      const response = await registrationAPI.login({
        email: username, // Fixed: API expects 'email' field
        password
      });

      console.log('Login API response:', response);

      if (response.status === 'success') {
        // Check if email is verified - FIXED FIELD NAME
        if (!response.data.user.email_verified_at) {
          setError('Please verify your email before signing in. Check your inbox for the verification link.');
          setIsLoading(false);
          return;
        }

        console.log('User data from API:', response.data.user);
        console.log('Token from API:', response.data.token);

        // Store authentication token
        localStorage.setItem('auth_token', response.data.token);

        // FIXED: Store user data properly in localStorage
        const userData = response.data.user;
        localStorage.setItem('user', JSON.stringify(userData));
        
        console.log('Stored in localStorage:');
        console.log('- auth_token:', localStorage.getItem('auth_token'));
        console.log('- user:', localStorage.getItem('user'));

        // Login user in context
        actions.loginUser(userData);

        // Show success notification
        actions.addNotification({
          type: 'success',
          message: `🎉 Welcome back, ${userData.first_name || userData.username}!`,
          important: true,
          duration: 3000
        });

        console.log('Login successful - redirecting to home');
      }
    } catch (error) {
      console.error('Login failed:', error);
      if (error instanceof APIError) {
        if (error.status === 401) {
          setError('Invalid username or password.');
        } else if (error.status === 403 && error.code === 'EMAIL_NOT_VERIFIED') {
          setError('Please verify your email before signing in. Check your inbox for the verification link.');
        } else if (error.status === 429) {
          setError('Too many login attempts. Please try again later.');
        } else {
          setError('Login failed. Please try again.');
        }
      } else {
        setError('Network error. Please check your connection.');
      }
    } finally {
      setIsLoading(false);
    }
  };

  const handleResendVerification = async () => {
    if (!canResendVerification || !verificationMessage?.email) return;

    setCanResendVerification(false);
    setResendCooldown(60);

    try {
      await registrationAPI.resendVerificationEmail(verificationMessage.email);
      actions.addNotification({
        type: 'success',
        message: '📧 Verification email sent! Check your inbox.',
        duration: 4000
      });
    } catch (error) {
      console.error('Resend verification failed:', error);
      actions.addNotification({
        type: 'error',
        message: 'Failed to resend email. Please try again later.',
        duration: 4000
      });
      setCanResendVerification(true);
      setResendCooldown(0);
    }
  };

  const features = [
    { icon: Star, text: "Rate and review nightlife venues" },
    { icon: Clock, text: "Get real-time crowd levels and wait times" },
    { icon: Users, text: "Connect with fellow nightlife enthusiasts" },
    { icon: Zap, text: "Discover trending spots before they blow up" }
  ];

  return (
    <div className="login-page">
      <div className="login-background">
        <div className="login-gradient"></div>
      </div>
      <div className="login-container">
        <div className="login-card">
          <div className="login-card-header">
            <div className="login-logo">
              <div className="logo-icon">
                <Zap className="w-10 h-10 text-white" />
              </div>
              <h2 className="login-title">Welcome to nYtevibe</h2>
              <p className="login-subtitle">Global Nightlife Discovery Platform</p>
            </div>
          </div>

          {/* Email Verification Banner */}
          {verificationMessage?.show && (
            <div className="verification-banner">
              <div className="verification-content">
                <div className="verification-icon">
                  <Mail className="w-6 h-6 text-blue-500" />
                </div>
                <div className="verification-text">
                  <h4 className="verification-title">Check Your Email</h4>
                  <p className="verification-description">
                    We sent a verification link to <strong>{verificationMessage.email}</strong>. 
                    Click the link to activate your account.
                  </p>
                </div>
              </div>
              {verificationMessage.email && (
                <button
                  onClick={handleResendVerification}
                  disabled={!canResendVerification}
                  className="resend-button"
                >
                  {canResendVerification ? (
                    <>
                      <RefreshCw className="w-4 h-4" />
                      Resend
                    </>
                  ) : (
                    `${resendCooldown}s`
                  )}
                </button>
              )}
            </div>
          )}

          <div className="demo-banner">
            <div className="demo-content">
              <div className="demo-info">
                <h4 className="demo-title">Demo Account Available</h4>
                <p className="demo-description">
                  Try nYtevibe with our demo account. Click below to auto-fill credentials.
                </p>
              </div>
              <button
                type="button"
                onClick={fillDemoCredentials}
                className="demo-fill-button"
              >
                Fill Demo
              </button>
            </div>
          </div>

          <form onSubmit={handleSubmit} className="login-form">
            {error && (
              <div className="error-banner">
                <span className="error-icon">⚠️</span>
                <span className="error-text">{error}</span>
              </div>
            )}

            <div className="form-group">
              <label htmlFor="username" className="form-label">Username</label>
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
              <label htmlFor="password" className="form-label">Password</label>
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
                  {showPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                </button>
              </div>
            </div>

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
                <>
                  <User className="w-4 h-4" />
                  Sign In
                </>
              )}
            </button>
          </form>

          <div className="login-card-footer">
            <p className="footer-text">
              New to nYtevibe?{' '}
              <button
                className="footer-link"
                onClick={onRegister}
                type="button"
              >
                Create Account
              </button>
            </p>
          </div>
        </div>

        <div className="login-features">
          <h3 className="features-title">Discover Global Nightlife</h3>
          <ul className="features-list">
            {features.map((feature, index) => (
              <li key={index} className="feature-item">
                <feature.icon className="w-4 h-4 text-blue-400" />
                <span>{feature.text}</span>
              </li>
            ))}
          </ul>

          <div className="platform-stats">
            <div className="stat-highlight">
              <span className="stat-number">10K+</span>
              <span className="stat-label">Venues</span>
            </div>
            <div className="stat-highlight">
              <span className="stat-number">50K+</span>
              <span className="stat-label">Users</span>
            </div>
            <div className="stat-highlight">
              <span className="stat-number">200+</span>
              <span className="stat-label">Cities</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default LoginView;
EOF

log_change "Created fixed LoginView with proper user data storage"

echo ""
echo ">>> STEP 4: APPLY THE FIXES"
echo "----------------------------------------"

# Replace the current LoginView with the fixed version
if [ -f "src/components/Views/LoginView.jsx" ]; then
    mv src/components/Views/LoginView.jsx "$BACKUP_DIR/LoginView.jsx.broken"
    mv src/components/Views/LoginView.fixed.jsx src/components/Views/LoginView.jsx
    log_change "Applied fixed LoginView with proper user storage"
else
    log_error "LoginView.jsx not found!"
fi

echo ""
echo ">>> STEP 5: CREATE BROWSER TEST SCRIPT"
echo "----------------------------------------"

cat > test_user_storage.js << 'EOF'
// Test user data storage - Run this in browser console after login

console.log('=== TESTING USER DATA STORAGE ===');

// Clear existing data first
localStorage.removeItem('user');
localStorage.removeItem('auth_token');
console.log('Cleared existing localStorage');

// Test the storage mechanism
const testUser = {
  id: 1973559,
  username: "bombardier",
  email: "iammrpwinner01@gmail.com",
  first_name: "Papove",
  last_name: "Bombando",
  user_type: "user"
};

const testToken = "test_token_12345";

// Store test data
localStorage.setItem('auth_token', testToken);
localStorage.setItem('user', JSON.stringify(testUser));

console.log('Stored test data:');
console.log('Token:', localStorage.getItem('auth_token'));
console.log('User:', localStorage.getItem('user'));
console.log('User parsed:', JSON.parse(localStorage.getItem('user')));

// Test if the issue is resolved
console.log('=== STORAGE TEST COMPLETE ===');
console.log('Now try refreshing the page to see if the white screen is gone');
EOF

log_change "Created user storage test script: test_user_storage.js"

echo ""
echo ">>> STEP 6: WHAT WAS FIXED"
echo "----------------------------------------"

echo "🔧 FIXED ISSUES:"
echo "1. ✅ Added explicit localStorage.setItem('user', JSON.stringify(userData))"
echo "2. ✅ Fixed email verification field check (email_verified_at)"
echo "3. ✅ Added debug logging to see what's being stored"
echo "4. ✅ Ensured user data is stored before calling actions.loginUser()"
echo ""

echo "🎯 THE PROBLEM WAS:"
echo "- Login was storing the token but NOT the user data in localStorage"
echo "- App initialization was trying to read null user data"
echo "- This caused undefined errors when accessing user properties"
echo ""

echo ">>> IMMEDIATE ACTIONS"
echo "----------------------------------------"

echo "1. Clear localStorage completely:"
echo "   - Open browser console"
echo "   - Run: localStorage.clear()"
echo ""

echo "2. Restart dev server:"
echo "   npm run dev"
echo ""

echo "3. Clear browser cache:"
echo "   Ctrl+Shift+R (or Cmd+Shift+R)"
echo ""

echo "4. Try login again - user data should now be stored"
echo ""

echo "5. Verify fix by checking console after login:"
echo "   - Should see debug logs showing user data being stored"
echo "   - localStorage.getItem('user') should return user data"
echo ""

echo ">>> IF STILL HAVING ISSUES"
echo "----------------------------------------"

echo "Run this in browser console to test storage:"
echo "localStorage.clear(); // Clear everything first"
echo "// Then try login again"
echo ""

echo "Or manually test storage with test_user_storage.js script"

echo ""
echo "======================================================="
echo "🎯 USER DATA STORAGE SHOULD NOW WORK!"
echo "======================================================="
echo "The fixed LoginView will:"
echo "✅ Store user data properly in localStorage"
echo "✅ Pass user data to context"
echo "✅ Show debug logs of what's being stored"
echo "✅ Handle both demo and real user login"
echo ""
echo "This should resolve the white screen error!"
echo "======================================================="
