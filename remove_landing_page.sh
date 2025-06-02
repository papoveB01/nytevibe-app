#!/bin/bash

# nYtevibe Remove Landing Page Script
# Makes login page the new landing page, removes original landing page

echo "🚀 nYtevibe Remove Landing Page"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔄 Making login page the new landing page..."
echo ""

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    echo "❌ Error: package.json not found. Please run this script from your React project directory."
    exit 1
fi

# Create backups
echo "💾 Creating backups..."
cp src/App.jsx src/App.jsx.backup-remove-landing
cp src/components/Views/LoginView.jsx src/components/Views/LoginView.jsx.backup-remove-landing

# Update App.jsx to remove landing page and make login the default
echo "🔧 Updating App.jsx to remove landing page..."

cat > src/App.jsx << 'EOF'
import React, { useState, useEffect } from 'react';
import { AppProvider, useApp } from './context/AppContext';
import { useVenues } from './hooks/useVenues';

// Views (LandingView removed)
import LoginView from './components/Views/LoginView';
import HomeView from './components/Views/HomeView';
import VenueDetailsView from './components/Views/VenueDetailsView';

// Components
import Header from './components/Header';
import Notifications from './components/Notifications';

// Modals
import RatingModal from './components/Modals/RatingModal';
import ReportModal from './components/Modals/ReportModal';
import ShareModal from './components/Modals/ShareModal';
import UserProfileModal from './components/User/UserProfileModal';

import './App.css';

function AppContent() {
  const { state, actions } = useApp();
  const { updateVenueData } = useVenues();
  const [searchQuery, setSearchQuery] = useState('');
  const [isMobile, setIsMobile] = useState(false);

  // Mobile detection
  useEffect(() => {
    const checkMobile = () => {
      const mobile = window.innerWidth <= 768 || 
        /Android|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
      setIsMobile(mobile);
    };

    checkMobile();
    window.addEventListener('resize', checkMobile);
    return () => window.removeEventListener('resize', checkMobile);
  }, []);

  // Update search query in context
  useEffect(() => {
    actions.setSearchQuery(searchQuery);
  }, [searchQuery, actions]);

  // Auto-update venue data periodically when authenticated
  useEffect(() => {
    if (state.isAuthenticated && state.currentView !== 'login') {
      const interval = setInterval(() => {
        updateVenueData();
      }, 45000);

      return () => clearInterval(interval);
    }
  }, [updateVenueData, state.currentView, state.isAuthenticated]);

  // Initialize app to login view if not authenticated
  useEffect(() => {
    if (!state.isAuthenticated && state.currentView !== 'login') {
      actions.setCurrentView('login');
    }
  }, [state.isAuthenticated, state.currentView, actions]);

  const handleLogin = (userData) => {
    // Default to user type for everyone
    actions.setUserType('user');
    actions.loginUser(userData);
    actions.addNotification({
      type: 'success',
      message: `🎉 Welcome to nYtevibe, ${userData.firstName}!`,
      important: true,
      duration: 3000
    });
  };

  const handleVenueSelect = (venue) => {
    actions.setSelectedVenue(venue);
    actions.setCurrentView('details');
  };

  const handleBackToHome = () => {
    actions.setCurrentView('home');
    actions.setSelectedVenue(null);
  };

  const handleClearSearch = () => {
    setSearchQuery('');
  };

  // Determine if header should be shown (not on login page)
  const showHeader = state.currentView !== 'login';

  return (
    <div className={`app ${isMobile ? 'mobile' : 'desktop'}`}>
      {/* Header */}
      {showHeader && (
        <Header
          searchQuery={searchQuery}
          setSearchQuery={setSearchQuery}
          onClearSearch={handleClearSearch}
          isMobile={isMobile}
        />
      )}

      {/* Main Content */}
      <main className={`main-content ${isMobile ? 'mobile-main' : ''}`}>
        {state.currentView === 'login' && (
          <LoginView onLogin={handleLogin} />
        )}
        
        {state.currentView === 'home' && (
          <HomeView onVenueSelect={handleVenueSelect} />
        )}
        
        {state.currentView === 'details' && (
          <VenueDetailsView onBack={handleBackToHome} />
        )}
      </main>

      {/* Modals */}
      <RatingModal />
      <ReportModal />
      <ShareModal />
      <UserProfileModal />

      {/* Notifications */}
      <Notifications />
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

# Update LoginView to remove back button and make it the entry point
echo "🔧 Updating LoginView to be the new landing page..."

cat > src/components/Views/LoginView.jsx << 'EOF'
import React, { useState } from 'react';
import { Eye, EyeOff, User, Lock, Zap, Star, Clock, Users } from 'lucide-react';

const LoginView = ({ onLogin }) => {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [error, setError] = useState('');
  const [isLoading, setIsLoading] = useState(false);

  const demoCredentials = {
    username: 'demouser',
    password: 'demopass'
  };

  const fillDemoCredentials = () => {
    setUsername(demoCredentials.username);
    setPassword(demoCredentials.password);
    setError('');
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setIsLoading(true);

    // Simulate realistic API call delay
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

  const features = [
    { icon: Star, text: "Rate and review Houston's hottest venues" },
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
              <p className="login-subtitle">Houston's Premier Nightlife Discovery Platform</p>
            </div>
          </div>

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
                  Enter nYtevibe
                </>
              )}
            </button>
          </form>

          <div className="login-card-footer">
            <p className="footer-text">
              New to nYtevibe?{' '}
              <button className="footer-link">Create Account</button>
            </p>
          </div>
        </div>

        <div className="login-features">
          <h3 className="features-title">Discover Houston's Nightlife</h3>
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
              <span className="stat-number">50+</span>
              <span className="stat-label">Venues</span>
            </div>
            <div className="stat-highlight">
              <span className="stat-number">1K+</span>
              <span className="stat-label">Users</span>
            </div>
            <div className="stat-highlight">
              <span className="stat-number">5K+</span>
              <span className="stat-label">Reviews</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default LoginView;
EOF

# Update CSS to add platform stats styling for the new login page
echo "🎨 Adding platform stats styling..."

cat >> src/App.css << 'EOF'

/* ============================================= */
/* NEW LOGIN LANDING PAGE STYLES */
/* ============================================= */

/* Platform stats section */
.platform-stats {
  display: flex;
  justify-content: space-between;
  margin-top: 24px;
  padding-top: 20px;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
}

.stat-highlight {
  text-align: center;
  flex: 1;
}

.stat-highlight .stat-number {
  display: block;
  font-size: 1.5rem;
  font-weight: 800;
  color: white;
  line-height: 1;
}

.stat-highlight .stat-label {
  font-size: 0.75rem;
  color: rgba(255, 255, 255, 0.7);
  text-transform: uppercase;
  letter-spacing: 0.5px;
  margin-top: 4px;
}

/* Update login title for new landing functionality */
.login-title {
  font-size: 1.5rem;
  font-weight: 800;
  margin-bottom: 8px;
  color: #1e293b;
}

.login-subtitle {
  color: #64748b;
  font-size: 0.875rem;
  margin-bottom: 4px;
}

/* Enhance features section for landing page */
.features-title {
  font-size: 1.125rem;
  font-weight: 600;
  margin-bottom: 20px;
  color: white;
  text-align: center;
}

/* Mobile responsiveness for platform stats */
@media (max-width: 768px) {
  .platform-stats {
    margin-top: 20px;
    padding-top: 16px;
  }

  .stat-highlight .stat-number {
    font-size: 1.25rem;
  }

  .stat-highlight .stat-label {
    font-size: 0.7rem;
  }

  .features-title {
    font-size: 1rem;
    margin-bottom: 16px;
  }
}

@media (max-width: 480px) {
  .platform-stats {
    flex-direction: column;
    gap: 12px;
    text-align: center;
  }

  .stat-highlight {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
  }

  .stat-highlight .stat-number,
  .stat-highlight .stat-label {
    display: inline;
    margin: 0;
  }

  .stat-highlight .stat-number {
    font-size: 1.125rem;
  }
}

EOF

# Remove the original LandingView file since it's no longer needed
echo "🗑️ Removing original LandingView file..."
if [ -f "src/components/Views/LandingView.jsx" ]; then
    mv src/components/Views/LandingView.jsx src/components/Views/LandingView.jsx.removed-backup
    echo "   ✅ LandingView.jsx moved to backup (.removed-backup)"
else
    echo "   ℹ️ LandingView.jsx not found (may have been removed already)"
fi

# Update context to handle the new flow
echo "🔧 Updating context for new landing flow..."

# Create a patch for the context to update initial state
cat > context_patch.tmp << 'EOF'
  currentView: 'login',
EOF

# Apply the patch to context (replace landing with login in initial state)
if grep -q "currentView: 'landing'" src/context/AppContext.jsx; then
    sed -i.bak "s/currentView: 'landing'/currentView: 'login'/" src/context/AppContext.jsx
    echo "   ✅ Updated AppContext initial view to 'login'"
    rm -f src/context/AppContext.jsx.bak
else
    echo "   ℹ️ AppContext already updated or using different initial view"
fi

# Clean up temporary files
rm -f context_patch.tmp

echo ""
echo "✅ Landing Page Removal Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🔄 Changes Applied:"
echo "   ✅ Removed original landing page completely"
echo "   ✅ Login page is now the entry point"
echo "   ✅ Updated app navigation flow"
echo "   ✅ Removed user type selection process"
echo "   ✅ Enhanced login page with platform stats"
echo "   ✅ Removed back button from login"
echo "   ✅ Updated app context initial state"
echo ""
echo "🎯 New App Flow:"
echo "   1. App starts with Login Page (new landing)"
echo "   2. User enters demo credentials or creates account"
echo "   3. Successful login → Home Page"
echo "   4. All other functionality remains the same"
echo ""
echo "📱 Login Page Enhancements:"
echo "   • Now serves as both landing and login"
echo "   • Added platform statistics display"
echo "   • Enhanced welcome messaging"
echo "   • Maintained mobile optimization"
echo "   • Removed unnecessary back navigation"
echo ""
echo "🔑 Demo Credentials (unchanged):"
echo "   Username: demouser"
echo "   Password: demopass"
echo ""
echo "🗃️ Files Modified:"
echo "   • src/App.jsx (updated navigation flow)"
echo "   • src/components/Views/LoginView.jsx (enhanced as landing)"
echo "   • src/context/AppContext.jsx (updated initial view)"
echo "   • src/App.css (added new styling)"
echo ""
echo "🗃️ Files Removed/Backed Up:"
echo "   • LandingView.jsx → LandingView.jsx.removed-backup"
echo ""
echo "🚀 To test the changes:"
echo "   npm run dev"
echo "   App will now start directly with the login page"
echo ""
echo "Status: 🟢 LOGIN PAGE IS NOW THE LANDING PAGE"
