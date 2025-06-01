#!/bin/bash

# nYtevibe v2.1 Update Script
# Adds Login System with Authentication Flow
# From Landing Page -> Login Page -> User Interface

echo "🚀 Updating nYtevibe from v2.0 to v2.1..."
echo "📋 Adding Login System with Authentication Flow"
echo ""

# Ensure we're in the right directory
if [ ! -f "package.json" ]; then
    echo "❌ Error: package.json not found. Please run this script from the nytevibe project root."
    exit 1
fi

echo "📁 Creating new directory structure for v2.1..."

# Create new directories
mkdir -p src/components/Auth
mkdir -p src/views/Auth

echo "🔐 Creating LoginPage component..."

# Create LoginPage.jsx
cat > src/views/Auth/LoginPage.jsx << 'EOF'
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

    // Simulate login process
    setTimeout(() => {
      if (username === 'userDemo' && password === 'userDemo') {
        // Successful login
        actions.login({
          username: 'userDemo',
          isAuthenticated: true
        });
        actions.addNotification({
          type: 'success',
          message: '🎉 Welcome back! Login successful'
        });
        actions.setCurrentView('home');
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
      message: '🔗 Password reset link sent to your email'
    });
  };

  const handleSignup = () => {
    actions.addNotification({
      type: 'default',
      message: '📝 Signup functionality coming soon!'
    });
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
                  Signing In...
                </>
              ) : (
                <>
                  <User className="w-4 h-4" />
                  Sign In
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
        </div>
      </div>
    </div>
  );
};

export default LoginPage;
EOF

echo "🎨 Creating LoginPage CSS..."

# Create LoginPage.css
cat > src/views/Auth/LoginPage.css << 'EOF'
/* LoginPage.css - nYtevibe v2.1 Authentication Styles */

.login-page {
  min-height: 100vh;
  background: linear-gradient(135deg, #1e293b 0%, #334155 50%, #475569 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 20px;
  position: relative;
  overflow-y: auto;
}

.login-page::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: url('data:image/svg+xml,<svg width="60" height="60" viewBox="0 0 60 60" xmlns="http://www.w3.org/2000/svg"><g fill="none" fill-rule="evenodd"><g fill="%23ffffff" fill-opacity="0.03"><circle cx="30" cy="30" r="4"/></g></svg>') repeat;
  pointer-events: none;
}

.login-container {
  width: 100%;
  max-width: 420px;
  position: relative;
  z-index: 1;
}

/* Header */
.login-header {
  margin-bottom: 20px;
}

.back-to-landing {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px 16px;
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 8px;
  color: rgba(255, 255, 255, 0.8);
  font-size: 0.875rem;
  cursor: pointer;
  transition: all 0.3s ease;
  backdrop-filter: blur(10px);
}

.back-to-landing:hover {
  background: rgba(255, 255, 255, 0.15);
  color: white;
  transform: translateX(-2px);
}

/* Login Card */
.login-card {
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(20px);
  border-radius: 20px;
  padding: 40px;
  box-shadow: 0 25px 50px rgba(0, 0, 0, 0.25);
  border: 1px solid rgba(255, 255, 255, 0.2);
}

/* Branding */
.login-branding {
  text-align: center;
  margin-bottom: 30px;
}

.login-logo {
  font-size: 2.5rem;
  font-weight: 800;
  background: linear-gradient(135deg, #3b82f6, #ec4899);
  -webkit-background-clip: text;
  background-clip: text;
  -webkit-text-fill-color: transparent;
  margin-bottom: 8px;
}

.login-title {
  font-size: 1.5rem;
  font-weight: 700;
  color: #1e293b;
  margin-bottom: 8px;
}

.login-subtitle {
  color: #64748b;
  font-size: 0.95rem;
  line-height: 1.4;
}

/* Demo Credentials */
.demo-credentials {
  background: linear-gradient(135deg, #3b82f6, #2563eb);
  border-radius: 12px;
  padding: 16px;
  margin-bottom: 24px;
  color: white;
}

.demo-header {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 8px;
}

.demo-icon {
  font-size: 1.2rem;
}

.demo-title {
  font-weight: 600;
  font-size: 0.9rem;
}

.demo-info {
  font-size: 0.875rem;
  opacity: 0.9;
}

.demo-info p {
  margin: 2px 0;
}

/* Form Styles */
.login-form {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.form-label {
  display: flex;
  align-items: center;
  gap: 8px;
  font-weight: 600;
  color: #374151;
  font-size: 0.875rem;
}

.form-input {
  width: 100%;
  padding: 14px 16px;
  border: 2px solid #e5e7eb;
  border-radius: 12px;
  background: #ffffff;
  color: #1f2937;
  font-size: 0.95rem;
  transition: all 0.3s ease;
  font-family: inherit;
}

.form-input:focus {
  outline: none;
  border-color: #3b82f6;
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
  background: #f8fafc;
}

.form-input:disabled {
  background: #f1f5f9;
  color: #94a3b8;
  cursor: not-allowed;
}

.form-input::placeholder {
  color: #9ca3af;
}

/* Password Input */
.password-input-wrapper {
  position: relative;
}

.password-input {
  padding-right: 48px;
}

.password-toggle {
  position: absolute;
  right: 14px;
  top: 50%;
  transform: translateY(-50%);
  background: none;
  border: none;
  color: #6b7280;
  cursor: pointer;
  padding: 4px;
  border-radius: 4px;
  transition: all 0.2s ease;
}

.password-toggle:hover {
  color: #374151;
  background: #f3f4f6;
}

.password-toggle:disabled {
  cursor: not-allowed;
  opacity: 0.5;
}

/* Error Message */
.error-message {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 12px 16px;
  background: #fef2f2;
  border: 1px solid #fecaca;
  border-radius: 8px;
  color: #dc2626;
  font-size: 0.875rem;
  font-weight: 500;
}

.error-icon {
  font-size: 1rem;
  flex-shrink: 0;
}

/* Login Button */
.login-button {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  width: 100%;
  padding: 16px;
  background: linear-gradient(135deg, #3b82f6, #2563eb);
  color: white;
  border: none;
  border-radius: 12px;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  margin-top: 8px;
}

.login-button:hover:not(:disabled) {
  background: linear-gradient(135deg, #2563eb, #1d4ed8);
  transform: translateY(-1px);
  box-shadow: 0 8px 25px rgba(59, 130, 246, 0.4);
}

.login-button:disabled {
  opacity: 0.7;
  cursor: not-allowed;
  transform: none;
}

.login-button.loading {
  background: linear-gradient(135deg, #6b7280, #4b5563);
}

/* Loading Spinner */
.loading-spinner {
  width: 16px;
  height: 16px;
  border: 2px solid rgba(255, 255, 255, 0.3);
  border-top: 2px solid white;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

/* Login Actions */
.login-actions {
  display: flex;
  flex-direction: column;
  gap: 16px;
  margin-top: 8px;
}

.forgot-password-link {
  background: none;
  border: none;
  color: #3b82f6;
  font-size: 0.875rem;
  font-weight: 500;
  cursor: pointer;
  text-align: center;
  padding: 8px;
  border-radius: 6px;
  transition: all 0.2s ease;
}

.forgot-password-link:hover:not(:disabled) {
  background: rgba(59, 130, 246, 0.1);
  color: #2563eb;
}

.forgot-password-link:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.signup-section {
  text-align: center;
  padding-top: 16px;
  border-top: 1px solid #e5e7eb;
}

.signup-text {
  color: #6b7280;
  font-size: 0.875rem;
  display: block;
  margin-bottom: 8px;
}

.signup-link {
  background: none;
  border: none;
  color: #ec4899;
  font-size: 0.875rem;
  font-weight: 600;
  cursor: pointer;
  padding: 8px 16px;
  border-radius: 6px;
  transition: all 0.2s ease;
}

.signup-link:hover:not(:disabled) {
  background: rgba(236, 72, 153, 0.1);
  color: #db2777;
}

.signup-link:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

/* Footer */
.login-footer {
  text-align: center;
  margin-top: 20px;
  color: rgba(255, 255, 255, 0.6);
  font-size: 0.8rem;
}

/* Mobile Responsive */
@media (max-width: 480px) {
  .login-page {
    padding: 16px;
  }

  .login-card {
    padding: 30px 24px;
  }

  .login-logo {
    font-size: 2rem;
  }

  .login-title {
    font-size: 1.25rem;
  }

  .demo-credentials {
    padding: 14px;
  }

  .form-input {
    padding: 12px 14px;
    font-size: 0.9rem;
  }

  .login-button {
    padding: 14px;
    font-size: 0.95rem;
  }
}

@media (max-width: 360px) {
  .login-card {
    padding: 24px 20px;
  }
  
  .back-to-landing {
    padding: 8px 12px;
    font-size: 0.8rem;
  }
}

/* Animation for smooth entrance */
.login-card {
  animation: loginCardEnter 0.6s ease-out;
}

@keyframes loginCardEnter {
  0% {
    opacity: 0;
    transform: translateY(20px) scale(0.95);
  }
  100% {
    opacity: 1;
    transform: translateY(0) scale(1);
  }
}

/* Focus styles for accessibility */
.form-input:focus,
.login-button:focus,
.forgot-password-link:focus,
.signup-link:focus,
.back-to-landing:focus,
.password-toggle:focus {
  outline: 2px solid #3b82f6;
  outline-offset: 2px;
}
EOF

echo "🔄 Updating WelcomeLandingPage to redirect to login..."

# Update WelcomeLandingPage.jsx
cat > src/views/Landing/WelcomeLandingPage.jsx << 'EOF'
import React, { useState } from 'react';
import { useApp } from '../../context/AppContext';
import './WelcomeLandingPage.css';

const WelcomeLandingPage = () => {
  const { actions } = useApp();
  const [isTransitioning, setIsTransitioning] = useState(false);

  const selectProfile = (mode) => {
    setIsTransitioning(true);
    
    // Set the selected mode
    actions.setCurrentMode(mode);
    
    setTimeout(() => {
      if (mode === 'user') {
        // Redirect to login page for customer
        actions.setCurrentView('login');
      } else {
        // For business, go directly to home (for now)
        actions.setCurrentView('home');
      }
      setIsTransitioning(false);
    }, 500);
  };

  return (
    <div className={`landing-page ${isTransitioning ? 'transitioning' : ''}`}>
      <div className="landing-hero">
        <h1 className="landing-title">nYtevibe</h1>
        <h2 className="landing-subtitle">Houston Nightlife Discovery</h2>
        <p className="landing-description">
          Discover real-time venue vibes, connect with your community, and experience Houston's nightlife like never before.
        </p>
      </div>

      <div className="profile-selection">
        <div className="profile-card customer-card" onClick={() => selectProfile('user')}>
          <div className="profile-icon">🎉</div>
          <h3 className="profile-title">Customer Experience</h3>
          <ul className="profile-features">
            <li>Discover venues with real-time data</li>
            <li>Follow your favorite spots</li>
            <li>Rate and review experiences</li>
            <li>Earn points and badges</li>
            <li>Share with friends</li>
            <li>Get personalized recommendations</li>
          </ul>
          <div className="profile-note">
            <span className="note-icon">🔐</span>
            <span className="note-text">Sign in required</span>
          </div>
        </div>

        <div className="profile-card business-card" onClick={() => selectProfile('venue_owner')}>
          <div className="profile-icon">📊</div>
          <h3 className="profile-title">Business Dashboard</h3>
          <ul className="profile-features">
            <li>Real-time venue analytics</li>
            <li>Manage staff and operations</li>
            <li>Monitor customer feedback</li>
            <li>Track crowd levels and trends</li>
            <li>Promote events and specials</li>
            <li>Build community engagement</li>
          </ul>
          <div className="profile-note">
            <span className="note-icon">⚡</span>
            <span className="note-text">Coming soon</span>
          </div>
        </div>
      </div>
    </div>
  );
};

export default WelcomeLandingPage;
EOF

echo "🔄 Updating WelcomeLandingPage CSS to include profile notes..."

# Add profile note styles to WelcomeLandingPage.css
cat >> src/views/Landing/WelcomeLandingPage.css << 'EOF'

/* Profile Notes for v2.1 */
.profile-note {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
  margin-top: 16px;
  padding: 8px 12px;
  background: rgba(255, 255, 255, 0.15);
  border-radius: 20px;
  font-size: 0.8rem;
  font-weight: 500;
  color: rgba(255, 255, 255, 0.9);
}

.note-icon {
  font-size: 0.9rem;
}

.customer-card .profile-note {
  background: rgba(59, 130, 246, 0.2);
  border: 1px solid rgba(59, 130, 246, 0.3);
}

.business-card .profile-note {
  background: rgba(236, 72, 153, 0.2);
  border: 1px solid rgba(236, 72, 153, 0.3);
}
EOF

echo "🔄 Updating AppContext to handle authentication..."

# Update AppContext.jsx
cat > src/context/AppContext.jsx << 'EOF'
import React, { createContext, useContext, useReducer, useCallback } from 'react';

const AppContext = createContext();

const initialState = {
  // Authentication state
  isAuthenticated: false,
  currentUser: null,
  
  userProfile: {
    id: 'usr_12345',
    firstName: 'Papove',
    lastName: 'Bombando',
    username: 'papove_bombando',
    email: 'papove.bombando@example.com',
    phone: '+1 (713) 555-0199',
    avatar: null,
    points: 1247,
    level: 'Gold Explorer',
    levelTier: 'gold',
    memberSince: '2023',
    totalReports: 89,
    totalRatings: 156,
    totalFollows: 3,
    followedVenues: [1, 3, 4],
    badgesEarned: ['Early Bird', 'Community Helper', 'Venue Expert', 'Houston Local', 'Social Butterfly'],
    preferences: {
      notifications: true,
      privateProfile: false,
      shareLocation: true,
      pushNotifications: true,
      emailDigest: true,
      friendsCanSeeFollows: true
    },
    socialStats: {
      friendsCount: 24,
      sharedVenues: 12,
      receivedRecommendations: 8,
      sentRecommendations: 15
    },
    followLists: [
      {
        id: 'date-night',
        name: 'Date Night Spots',
        emoji: '💕',
        venueIds: [4],
        createdAt: '2024-01-15',
        isPublic: true
      },
      {
        id: 'sports-bars',
        name: 'Sports Bars',
        emoji: '🏈',
        venueIds: [3],
        createdAt: '2024-01-20',
        isPublic: true
      },
      {
        id: 'weekend-vibes',
        name: 'Weekend Vibes',
        emoji: '🎉',
        venueIds: [1],
        createdAt: '2024-02-01',
        isPublic: false
      },
      {
        id: 'hookah-spots',
        name: 'Hookah Lounges',
        emoji: '💨',
        venueIds: [6],
        createdAt: '2024-02-10',
        isPublic: true
      }
    ]
  },

  venues: [
    {
      id: 1,
      name: "NYC Vibes",
      type: "Lounge",
      distance: "0.2 mi",
      crowdLevel: 4,
      waitTime: 15,
      lastUpdate: "2 min ago",
      vibe: ["Lively", "Hip-Hop"],
      confidence: 95,
      reports: 8,
      lat: 29.7604,
      lng: -95.3698,
      address: "1234 Main Street, Houston, TX 77002",
      city: "Houston",
      postcode: "77002",
      phone: "(713) 555-0123",
      hours: "Open until 2:00 AM",
      rating: 4.2,
      totalRatings: 127,
      ratingBreakdown: { 5: 48, 4: 39, 3: 25, 2: 12, 1: 3 },
      isOpen: true,
      trending: "stable",
      hasPromotion: true,
      promotionText: "Free Hookah for Ladies 6-10PM!",
      followersCount: 342,
      reviews: [
        { id: 1, user: "Mike R.", rating: 5, comment: "Amazing vibe and music! Perfect for a night out.", date: "2 days ago", helpful: 12 },
        { id: 2, user: "Sarah L.", rating: 4, comment: "Great atmosphere but can get really crowded.", date: "1 week ago", helpful: 8 },
        { id: 3, user: "James T.", rating: 5, comment: "Best hip-hop venue in Houston! Love the energy.", date: "2 weeks ago", helpful: 15 }
      ]
    },
    {
      id: 2,
      name: "Rumors",
      type: "Nightclub",
      distance: "0.4 mi",
      crowdLevel: 2,
      waitTime: 0,
      lastUpdate: "5 min ago",
      vibe: ["Chill", "R&B"],
      confidence: 87,
      reports: 12,
      lat: 29.7595,
      lng: -95.3697,
      address: "5678 Downtown Boulevard, Houston, TX 77003",
      city: "Houston",
      postcode: "77003",
      phone: "(713) 555-0456",
      hours: "Open until 3:00 AM",
      rating: 4.5,
      totalRatings: 89,
      ratingBreakdown: { 5: 42, 4: 28, 3: 12, 2: 5, 1: 2 },
      isOpen: true,
      trending: "stable",
      hasPromotion: true,
      promotionText: "R&B Night - 2-for-1 Cocktails!",
      followersCount: 128,
      reviews: [
        { id: 1, user: "Alex P.", rating: 5, comment: "Smooth R&B vibes and great cocktails!", date: "3 days ago", helpful: 9 },
        { id: 2, user: "Maria G.", rating: 4, comment: "Love the music selection, drinks are pricey though.", date: "5 days ago", helpful: 6 }
      ]
    },
    {
      id: 3,
      name: "Classic",
      type: "Bar & Grill",
      distance: "0.7 mi",
      crowdLevel: 5,
      waitTime: 30,
      lastUpdate: "1 min ago",
      vibe: ["Packed", "Sports"],
      confidence: 98,
      reports: 23,
      lat: 29.7586,
      lng: -95.3696,
      address: "9012 Sports Center Drive, Houston, TX 77004",
      city: "Houston",
      postcode: "77004",
      phone: "(713) 555-0789",
      hours: "Open until 1:00 AM",
      rating: 4.1,
      totalRatings: 203,
      ratingBreakdown: { 5: 67, 4: 81, 3: 32, 2: 18, 1: 5 },
      isOpen: true,
      trending: "stable",
      hasPromotion: true,
      promotionText: "Big Game Tonight! 50¢ Wings!",
      followersCount: 567,
      reviews: [
        { id: 1, user: "Tom B.", rating: 4, comment: "Great for watching games! Food is solid too.", date: "1 day ago", helpful: 14 },
        { id: 2, user: "Lisa K.", rating: 5, comment: "Best sports bar in the area. Always lively!", date: "3 days ago", helpful: 11 },
        { id: 3, user: "Dave M.", rating: 3, comment: "Can get too loud during big games.", date: "1 week ago", helpful: 7 }
      ]
    },
    {
      id: 4,
      name: "Best Regards",
      type: "Cocktail Bar",
      distance: "0.3 mi",
      crowdLevel: 3,
      waitTime: 20,
      lastUpdate: "8 min ago",
      vibe: ["Moderate", "Date Night"],
      confidence: 76,
      reports: 5,
      lat: 29.7577,
      lng: -95.3695,
      address: "3456 Uptown Plaza, Houston, TX 77005",
      city: "Houston",
      postcode: "77005",
      phone: "(713) 555-0321",
      hours: "Open until 12:00 AM",
      rating: 4.7,
      totalRatings: 156,
      ratingBreakdown: { 5: 89, 4: 47, 3: 15, 2: 3, 1: 2 },
      isOpen: true,
      trending: "stable",
      hasPromotion: true,
      promotionText: "DJ Chin Tonight! 9PM-2AM",
      followersCount: 234,
      reviews: [
        { id: 1, user: "Emma S.", rating: 5, comment: "Perfect date night spot! Cocktails are incredible.", date: "2 days ago", helpful: 18 },
        { id: 2, user: "Ryan C.", rating: 5, comment: "Classy atmosphere, amazing bartender skills.", date: "4 days ago", helpful: 13 },
        { id: 3, user: "Kate W.", rating: 4, comment: "Beautiful venue but a bit pricey for drinks.", date: "1 week ago", helpful: 9 }
      ]
    },
    {
      id: 5,
      name: "The Rooftop",
      type: "Rooftop Bar",
      distance: "0.5 mi",
      crowdLevel: 3,
      waitTime: 10,
      lastUpdate: "12 min ago",
      vibe: ["Trendy", "City Views"],
      confidence: 82,
      reports: 6,
      lat: 29.7588,
      lng: -95.3694,
      address: "7890 Skyline Avenue, Houston, TX 77006",
      city: "Houston",
      postcode: "77006",
      phone: "(713) 555-0999",
      hours: "Open until 1:00 AM",
      rating: 4.6,
      totalRatings: 98,
      ratingBreakdown: { 5: 52, 4: 31, 3: 10, 2: 3, 1: 2 },
      isOpen: true,
      trending: "up",
      hasPromotion: false,
      promotionText: "",
      followersCount: 189,
      reviews: [
        { id: 1, user: "Nina K.", rating: 5, comment: "Best city views in Houston! Great for photos.", date: "1 day ago", helpful: 16 },
        { id: 2, user: "Carlos M.", rating: 4, comment: "Amazing sunset views, drinks are expensive though.", date: "3 days ago", helpful: 9 }
      ]
    },
    {
      id: 6,
      name: "Red Sky Hookah Lounge & Bar",
      type: "Hookah Lounge",
      distance: "0.6 mi",
      crowdLevel: 4,
      waitTime: 25,
      lastUpdate: "3 min ago",
      vibe: ["Hookah", "Chill", "VIP", "Lively"],
      confidence: 91,
      reports: 14,
      lat: 29.7620,
      lng: -95.3710,
      address: "4567 Richmond Avenue, Houston, TX 77027",
      city: "Houston",
      postcode: "77027",
      phone: "(713) 555-0777",
      hours: "Open until 3:00 AM",
      rating: 4.4,
      totalRatings: 76,
      ratingBreakdown: { 5: 38, 4: 22, 3: 11, 2: 3, 1: 2 },
      isOpen: true,
      trending: "up",
      hasPromotion: true,
      promotionText: "Grand Opening: 50% Off Premium Hookah!",
      followersCount: 95,
      reviews: [
        { id: 1, user: "Ahmed K.", rating: 5, comment: "Best hookah in Houston! Premium quality and great atmosphere.", date: "1 day ago", helpful: 22 },
        { id: 2, user: "Jessica M.", rating: 4, comment: "Love the VIP lounge area. Great for groups and celebrations.", date: "2 days ago", helpful: 18 },
        { id: 3, user: "Papove B.", rating: 5, comment: "Finally, a quality hookah spot! Clean, modern, and excellent service.", date: "3 days ago", helpful: 15 }
      ]
    }
  ],

  notifications: [],
  currentView: 'landing',
  currentMode: null, // 'user' | 'venue_owner' | null
  selectedVenue: null,
  showRatingModal: false,
  showReportModal: false,
  showShareModal: false,
  shareVenue: null,
  isTransitioning: false,

  friends: [
    {
      id: 'usr_98765',
      name: 'Sarah Martinez',
      username: 'sarah_houston',
      avatar: null,
      mutualFollows: 2,
      isOnline: true,
      lastSeen: 'now'
    },
    {
      id: 'usr_54321',
      name: 'David Chen',
      username: 'david_htx',
      avatar: null,
      mutualFollows: 1,
      isOnline: false,
      lastSeen: '2 hours ago'
    }
  ]
};

const appReducer = (state, action) => {
  switch (action.type) {
    case 'LOGIN':
      return { 
        ...state, 
        isAuthenticated: true,
        currentUser: action.payload
      };

    case 'LOGOUT':
      return { 
        ...state, 
        isAuthenticated: false,
        currentUser: null,
        currentView: 'landing',
        currentMode: null
      };

    case 'SET_CURRENT_VIEW':
      return { ...state, currentView: action.payload };

    case 'SET_CURRENT_MODE':
      return { ...state, currentMode: action.payload };

    case 'SET_SELECTED_VENUE':
      return { ...state, selectedVenue: action.payload };

    case 'SET_SHOW_RATING_MODAL':
      return { ...state, showRatingModal: action.payload };

    case 'SET_SHOW_REPORT_MODAL':
      return { ...state, showReportModal: action.payload };

    case 'SET_SHOW_SHARE_MODAL':
      return { ...state, showShareModal: action.payload, shareVenue: action.payload ? state.shareVenue : null };

    case 'SET_SHARE_VENUE':
      return { ...state, shareVenue: action.payload };

    case 'UPDATE_VENUE_DATA':
      return {
        ...state,
        venues: state.venues.map(venue => ({
          ...venue,
          crowdLevel: Math.max(1, Math.min(5, venue.crowdLevel + (Math.random() - 0.5))),
          waitTime: Math.max(0, venue.waitTime + Math.floor((Math.random() - 0.5) * 10)),
          lastUpdate: "Just now",
          confidence: Math.max(70, Math.min(98, venue.confidence + Math.floor((Math.random() - 0.5) * 10)))
        }))
      };

    case 'FOLLOW_VENUE':
      const { venueId, venueName } = action.payload;
      const newFollowedVenues = [...state.userProfile.followedVenues];
      if (!newFollowedVenues.includes(venueId)) {
        newFollowedVenues.push(venueId);
      }
      return {
        ...state,
        userProfile: {
          ...state.userProfile,
          followedVenues: newFollowedVenues,
          points: state.userProfile.points + 3,
          totalFollows: state.userProfile.totalFollows + 1
        },
        venues: state.venues.map(venue =>
          venue.id === venueId
            ? { ...venue, followersCount: venue.followersCount + 1 }
            : venue
        )
      };

    case 'UNFOLLOW_VENUE':
      const unfollowVenueId = action.payload.venueId;
      const filteredFollowedVenues = state.userProfile.followedVenues.filter(id => id !== unfollowVenueId);
      return {
        ...state,
        userProfile: {
          ...state.userProfile,
          followedVenues: filteredFollowedVenues,
          points: Math.max(0, state.userProfile.points - 2),
          totalFollows: Math.max(0, state.userProfile.totalFollows - 1)
        },
        venues: state.venues.map(venue =>
          venue.id === unfollowVenueId
            ? { ...venue, followersCount: Math.max(0, venue.followersCount - 1) }
            : venue
        )
      };

    case 'ADD_NOTIFICATION':
      const notification = {
        id: Date.now(),
        type: action.payload.type || 'default',
        message: action.payload.message,
        duration: action.payload.duration || 3000,
        timestamp: Date.now()
      };
      return {
        ...state,
        notifications: [notification, ...state.notifications]
      };

    case 'REMOVE_NOTIFICATION':
      return {
        ...state,
        notifications: state.notifications.filter(n => n.id !== action.payload)
      };

    default:
      return state;
  }
};

export const AppProvider = ({ children }) => {
  const [state, dispatch] = useReducer(appReducer, initialState);

  const actions = {
    login: useCallback((userData) => {
      dispatch({ type: 'LOGIN', payload: userData });
    }, []),

    logout: useCallback(() => {
      dispatch({ type: 'LOGOUT' });
    }, []),

    setCurrentView: useCallback((view) => {
      dispatch({ type: 'SET_CURRENT_VIEW', payload: view });
    }, []),

    setCurrentMode: useCallback((mode) => {
      dispatch({ type: 'SET_CURRENT_MODE', payload: mode });
    }, []),

    setSelectedVenue: useCallback((venue) => {
      dispatch({ type: 'SET_SELECTED_VENUE', payload: venue });
    }, []),

    setShowRatingModal: useCallback((show) => {
      dispatch({ type: 'SET_SHOW_RATING_MODAL', payload: show });
    }, []),

    setShowReportModal: useCallback((show) => {
      dispatch({ type: 'SET_SHOW_REPORT_MODAL', payload: show });
    }, []),

    setShowShareModal: useCallback((show) => {
      dispatch({ type: 'SET_SHOW_SHARE_MODAL', payload: show });
    }, []),

    setShareVenue: useCallback((venue) => {
      dispatch({ type: 'SET_SHARE_VENUE', payload: venue });
    }, []),

    updateVenueData: useCallback(() => {
      dispatch({ type: 'UPDATE_VENUE_DATA' });
    }, []),

    followVenue: useCallback((venueId, venueName) => {
      dispatch({ type: 'FOLLOW_VENUE', payload: { venueId, venueName } });
    }, []),

    unfollowVenue: useCallback((venueId, venueName) => {
      dispatch({ type: 'UNFOLLOW_VENUE', payload: { venueId, venueName } });
    }, []),

    addNotification: useCallback((notification) => {
      dispatch({ type: 'ADD_NOTIFICATION', payload: notification });
    }, []),

    removeNotification: useCallback((id) => {
      dispatch({ type: 'REMOVE_NOTIFICATION', payload: id });
    }, [])
  };

  return (
    <AppContext.Provider value={{ state, actions }}>
      {children}
    </AppContext.Provider>
  );
};

export const useApp = () => {
  const context = useContext(AppContext);
  if (!context) {
    throw new Error('useApp must be used within an AppProvider');
  }
  return context;
};
EOF

echo "🔄 Updating App.jsx to handle new login flow..."

# Update App.jsx
cat > src/App.jsx << 'EOF'
import React, { useState, useEffect } from 'react';
import { AppProvider, useApp } from './context/AppContext';
import WelcomeLandingPage from './views/Landing/WelcomeLandingPage';
import LoginPage from './views/Auth/LoginPage';
import Header from './components/Layout/Header';
import HomeView from './components/Views/HomeView';
import VenueDetailsView from './components/Views/VenueDetailsView';
import ShareModal from './components/Social/ShareModal';
import RatingModal from './components/Venue/RatingModal';
import ReportModal from './components/Venue/ReportModal';
import { useVenues } from './hooks/useVenues';
import { useNotifications } from './hooks/useNotifications';
import './App.css';

function AppContent() {
  const { state, actions } = useApp();
  const [searchQuery, setSearchQuery] = useState('');
  const [venueFilter, setVenueFilter] = useState('all');
  const [showShareModal, setShowShareModal] = useState(false);
  const [shareVenue, setShareVenue] = useState(null);

  const { updateVenueData } = useVenues();
  const { notifications, removeNotification } = useNotifications();

  // Auto-update venue data when in home view and authenticated
  useEffect(() => {
    let interval;
    if (state.currentView === 'home' && state.isAuthenticated && !document.hidden) {
      interval = setInterval(() => {
        updateVenueData();
      }, 45000);
    }

    return () => {
      if (interval) clearInterval(interval);
    };
  }, [state.currentView, state.isAuthenticated, updateVenueData]);

  // Handle visibility change for auto-updates
  useEffect(() => {
    const handleVisibilityChange = () => {
      if (!document.hidden && state.currentView === 'home' && state.isAuthenticated) {
        updateVenueData();
      }
    };

    document.addEventListener('visibilitychange', handleVisibilityChange);
    return () => {
      document.removeEventListener('visibilitychange', handleVisibilityChange);
    };
  }, [state.currentView, state.isAuthenticated, updateVenueData]);

  const handleVenueClick = (venue) => {
    actions.setSelectedVenue(venue);
    actions.setCurrentView('details');
  };

  const handleVenueShare = (venue) => {
    setShareVenue(venue);
    setShowShareModal(true);
  };

  const handleBackToHome = () => {
    actions.setCurrentView('home');
    actions.setSelectedVenue(null);
  };

  const handleClearSearch = () => {
    setSearchQuery('');
    setVenueFilter('all');
  };

  // Render different views based on current view and authentication
  const renderCurrentView = () => {
    switch (state.currentView) {
      case 'landing':
        return <WelcomeLandingPage />;
      
      case 'login':
        return <LoginPage />;
      
      case 'home':
        if (!state.isAuthenticated) {
          // Redirect to landing if not authenticated
          actions.setCurrentView('landing');
          return <WelcomeLandingPage />;
        }
        return (
          <>
            <Header
              searchQuery={searchQuery}
              setSearchQuery={setSearchQuery}
              onClearSearch={handleClearSearch}
            />
            <div className="content-frame">
              <HomeView
                searchQuery={searchQuery}
                setSearchQuery={setSearchQuery}
                venueFilter={venueFilter}
                setVenueFilter={setVenueFilter}
                onVenueClick={handleVenueClick}
                onVenueShare={handleVenueShare}
              />
            </div>
          </>
        );
      
      case 'details':
        if (!state.isAuthenticated) {
          actions.setCurrentView('landing');
          return <WelcomeLandingPage />;
        }
        return (
          <div className="content-frame">
            <VenueDetailsView
              onBack={handleBackToHome}
              onShare={handleVenueShare}
            />
          </div>
        );
      
      default:
        return <WelcomeLandingPage />;
    }
  };

  return (
    <div className="app-layout">
      {renderCurrentView()}

      {/* Notifications */}
      {notifications.length > 0 && (
        <div className="notification-container">
          {notifications.map((notification) => (
            <div
              key={notification.id}
              className={`notification notification-${notification.type}`}
            >
              <div className="notification-content">
                <span className="notification-message">{notification.message}</span>
                <button
                  onClick={() => removeNotification(notification.id)}
                  className="notification-close"
                >
                  ×
                </button>
              </div>
            </div>
          ))}
        </div>
      )}

      {/* Modals */}
      <ShareModal
        venue={shareVenue}
        isOpen={showShareModal}
        onClose={() => {
          setShowShareModal(false);
          setShareVenue(null);
        }}
      />
      <RatingModal />
      <ReportModal />
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

echo "🔄 Adding logout functionality to UserProfile..."

# Update UserProfile.jsx to include logout functionality
cat > src/components/User/UserProfile.jsx << 'EOF'
import React, { useState, useEffect, useRef } from 'react';
import { useApp } from '../../context/AppContext';
import { getUserInitials, getLevelIcon } from '../../utils/helpers';
import './UserProfile.css';

const UserProfile = () => {
  const { state, actions } = useApp();
  const { userProfile } = state;
  const [isDropdownOpen, setIsDropdownOpen] = useState(false);
  const dropdownRef = useRef(null);

  // Close dropdown when clicking outside
  useEffect(() => {
    const handleClickOutside = (event) => {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target)) {
        setIsDropdownOpen(false);
      }
    };

    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  // Close dropdown on escape key
  useEffect(() => {
    const handleEscape = (event) => {
      if (event.key === 'Escape') {
        setIsDropdownOpen(false);
      }
    };

    document.addEventListener('keydown', handleEscape);
    return () => document.removeEventListener('keydown', handleEscape);
  }, []);

  const toggleDropdown = () => {
    setIsDropdownOpen(!isDropdownOpen);
  };

  const handleMenuAction = (action) => {
    setIsDropdownOpen(false);
    
    switch (action) {
      case 'profile':
        actions.addNotification({
          type: 'default',
          message: '🔍 Opening Full Profile View...'
        });
        break;
      case 'edit':
        actions.addNotification({
          type: 'default',
          message: '✏️ Opening Profile Editor...'
        });
        break;
      case 'lists':
        actions.addNotification({
          type: 'default',
          message: '💕 Opening Venue Lists...'
        });
        break;
      case 'activity':
        actions.addNotification({
          type: 'default',
          message: '📊 Opening Activity History...'
        });
        break;
      case 'settings':
        actions.addNotification({
          type: 'default',
          message: '⚙️ Opening Settings...'
        });
        break;
      case 'help':
        actions.addNotification({
          type: 'default',
          message: '🆘 Opening Help & Support...'
        });
        break;
      case 'signout':
        if (window.confirm('🚪 Are you sure you want to sign out?')) {
          actions.logout();
          actions.addNotification({
            type: 'success',
            message: '👋 Signed out successfully. See you next time!'
          });
        }
        break;
      default:
        break;
    }
  };

  const initials = getUserInitials(userProfile.firstName, userProfile.lastName);
  const levelIcon = getLevelIcon(userProfile.levelTier);

  return (
    <div className="user-badge-container" ref={dropdownRef}>
      <div
        className={`user-badge ${isDropdownOpen ? 'open' : ''}`}
        onClick={toggleDropdown}
      >
        <div className="user-avatar-badge">{initials}</div>
        <div className="user-info-badge">
          <div className="user-name-badge">
            {userProfile.firstName} {userProfile.lastName}
          </div>
          <div className="user-level-badge">
            {levelIcon} {userProfile.level}
            <span className="points-badge">{userProfile.points.toLocaleString()}</span>
          </div>
        </div>
        <svg className="dropdown-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M19 9l-7 7-7-7"/>
        </svg>
      </div>

      <div className={`user-dropdown ${isDropdownOpen ? 'open' : ''}`}>
        {/* Profile Details Header */}
        <div className="dropdown-header">
          <div className="dropdown-profile">
            <div className="dropdown-avatar">{initials}</div>
            <div className="dropdown-user-info">
              <div className="dropdown-name">
                {userProfile.firstName} {userProfile.lastName}
              </div>
              <div className="dropdown-username">@{userProfile.username}</div>
              <div className="dropdown-level">
                <span className="level-badge-dropdown">
                  {levelIcon} {userProfile.level}
                </span>
              </div>
            </div>
          </div>

          {/* User Stats */}
          <div className="dropdown-stats">
            <div className="dropdown-stat">
              <div className="dropdown-stat-number">{userProfile.points.toLocaleString()}</div>
              <div className="dropdown-stat-label">Points</div>
            </div>
            <div className="dropdown-stat">
              <div className="dropdown-stat-number">{userProfile.totalReports}</div>
              <div className="dropdown-stat-label">Reports</div>
            </div>
            <div className="dropdown-stat">
              <div className="dropdown-stat-number">{userProfile.totalRatings}</div>
              <div className="dropdown-stat-label">Ratings</div>
            </div>
            <div className="dropdown-stat">
              <div className="dropdown-stat-number">{userProfile.totalFollows}</div>
              <div className="dropdown-stat-label">Following</div>
            </div>
          </div>
        </div>

        {/* Menu Items */}
        <div className="dropdown-menu">
          <button className="dropdown-item" onClick={() => handleMenuAction('profile')}>
            <svg className="dropdown-item-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
            </svg>
            View Full Profile
          </button>

          <button className="dropdown-item" onClick={() => handleMenuAction('edit')}>
            <svg className="dropdown-item-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
            </svg>
            Update Profile
          </button>

          <button className="dropdown-item" onClick={() => handleMenuAction('lists')}>
            <svg className="dropdown-item-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"/>
            </svg>
            My Venue Lists
          </button>

          <button className="dropdown-item" onClick={() => handleMenuAction('activity')}>
            <svg className="dropdown-item-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/>
            </svg>
            Activity History
          </button>

          <div className="dropdown-divider"></div>

          <button className="dropdown-item" onClick={() => handleMenuAction('settings')}>
            <svg className="dropdown-item-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"/>
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
            </svg>
            Settings
          </button>

          <button className="dropdown-item" onClick={() => handleMenuAction('help')}>
            <svg className="dropdown-item-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M8.228 9c.549-1.165 2.03-2 3.772-2 2.21 0 4 1.343 4 3 0 1.4-1.278 2.575-3.006 2.907-.542.104-.994.54-.994 1.093m0 3h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
            </svg>
            Help & Support
          </button>

          <div className="dropdown-divider"></div>

          <button className="dropdown-item danger" onClick={() => handleMenuAction('signout')}>
            <svg className="dropdown-item-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"/>
            </svg>
            Sign Out
          </button>
        </div>
      </div>

      {/* Overlay */}
      {isDropdownOpen && <div className="dropdown-overlay" onClick={() => setIsDropdownOpen(false)} />}
    </div>
  );
};

export default UserProfile;
EOF

echo "🎨 Adding notification styles to App.css..."

# Add notification styles to App.css
cat >> src/App.css << 'EOF'

/* Notification System Styles - v2.1 */
.notification-container {
  position: fixed;
  top: 20px;
  right: 20px;
  z-index: 9999;
  display: flex;
  flex-direction: column;
  gap: 12px;
  max-width: 400px;
}

.notification {
  background: white;
  border-radius: 12px;
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
  border-left: 4px solid #3b82f6;
  animation: notificationSlideIn 0.3s ease-out;
  overflow: hidden;
}

.notification-success {
  border-left-color: #10b981;
}

.notification-default {
  border-left-color: #3b82f6;
}

.notification-warning {
  border-left-color: #f59e0b;
}

.notification-error {
  border-left-color: #ef4444;
}

.notification-content {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px 20px;
  gap: 12px;
}

.notification-message {
  color: #1f2937;
  font-size: 0.875rem;
  font-weight: 500;
  line-height: 1.4;
  flex: 1;
}

.notification-close {
  background: none;
  border: none;
  color: #6b7280;
  font-size: 1.2rem;
  font-weight: bold;
  cursor: pointer;
  padding: 4px;
  border-radius: 4px;
  transition: all 0.2s ease;
  flex-shrink: 0;
}

.notification-close:hover {
  background: #f3f4f6;
  color: #374151;
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

/* Mobile responsive notifications */
@media (max-width: 480px) {
  .notification-container {
    top: 16px;
    right: 16px;
    left: 16px;
    max-width: none;
  }

  .notification-content {
    padding: 14px 16px;
  }

  .notification-message {
    font-size: 0.8rem;
  }
}
EOF

echo "📝 Creating README update for v2.1..."

# Create README update
cat > README_v2.1.md << 'EOF'
# nYtevibe v2.1 - Login System Update

## 🆕 What's New in v2.1

### Authentication Flow
- **Landing Page** → **Login Page** → **User Interface**
- Secure authentication before accessing customer features
- Demo credentials: `userDemo` / `userDemo`

### New Components
- `LoginPage.jsx` - Complete authentication interface
- Enhanced `AppContext` with login/logout state management
- Updated navigation flow with authentication checks

### Features Added
1. **Professional Login Interface**
   - Username/password fields with validation
   - Show/hide password toggle
   - Demo credentials display
   - Forgot password & signup options
   - Loading states and error handling

2. **Authentication Protection**
   - Protected routes require login
   - Automatic redirects for unauthenticated users
   - Logout functionality in user dropdown

3. **Enhanced UX**
   - Smooth transitions between views
   - Professional form styling
   - Mobile-responsive design
   - Accessibility features

## 🚀 Demo Credentials
- **Username:** `userDemo`
- **Password:** `userDemo`

## 📱 User Flow
1. Landing Page → Select "Customer Experience"
2. Login Page → Enter demo credentials
3. Main App → Full venue discovery experience
4. User Profile → Sign out option available

## 🔧 Technical Updates
- Enhanced `AppContext` with authentication state
- New `LoginPage` component with form validation
- Updated `App.jsx` with view routing logic
- Protected route implementation
- Logout functionality integration

## 📁 New File Structure
```
src/
├── views/
│   └── Auth/
│       ├── LoginPage.jsx
│       └── LoginPage.css
├── context/
│   └── AppContext.jsx (enhanced)
└── App.jsx (updated routing)
```

---
*nYtevibe v2.1 - Secure Houston Nightlife Discovery*
EOF

echo ""
echo "✅ nYtevibe v2.1 Update Complete!"
echo ""
echo "🔐 New Authentication Flow:"
echo "   Landing Page → Login Page → User Interface"
echo ""
echo "🔑 Demo Credentials:"
echo "   Username: userDemo"
echo "   Password: userDemo"
echo ""
echo "📁 New Files Created:"
echo "   ✅ src/views/Auth/LoginPage.jsx"
echo "   ✅ src/views/Auth/LoginPage.css" 
echo "   ✅ README_v2.1.md"
echo ""
echo "🔄 Updated Files:"
echo "   ✅ src/views/Landing/WelcomeLandingPage.jsx"
echo "   ✅ src/views/Landing/WelcomeLandingPage.css"
echo "   ✅ src/context/AppContext.jsx"
echo "   ✅ src/App.jsx"
echo "   ✅ src/components/User/UserProfile.jsx"
echo "   ✅ src/App.css"
echo ""
echo "🎯 Key Features Added:"
echo "   ✅ Complete login system with demo credentials"
echo "   ✅ Authentication protection for all user features"
echo "   ✅ Professional login interface with validation"
echo "   ✅ Logout functionality in user dropdown"
echo "   ✅ Smooth navigation flow with proper redirects"
echo ""
echo "🚀 Ready to test!"
echo "   Run: npm run dev"
echo "   Navigate to: http://localhost:5173"
echo "   Select: Customer Experience"
echo "   Login with: userDemo / userDemo"
echo ""
echo "📋 Next Steps:"
echo "   • Test the complete authentication flow"
echo "   • Verify all protected routes work correctly"
echo "   • Test logout functionality"
echo "   • Confirm responsive design on mobile"
echo ""
