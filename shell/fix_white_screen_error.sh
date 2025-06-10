#!/bin/bash

# Fix White Screen Error After Login
echo "======================================================="
echo "    FIXING WHITE SCREEN ERROR AFTER LOGIN"
echo "======================================================="

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="./post_login_fix_backup_$TIMESTAMP"
mkdir -p "$BACKUP_DIR"

echo "Creating backups in: $BACKUP_DIR"

# Function to log changes
log_change() {
    echo "✅ $1"
}

log_error() {
    echo "❌ $1"
}

echo ""
echo ">>> ANALYZING THE ERROR"
echo "----------------------------------------"
echo "Error: Cannot read properties of undefined (reading 'includes')"
echo "This means some variable that should be an array is undefined"
echo "and code is trying to call .includes() on it."
echo ""

echo ">>> STEP 1: CHECK USER DATA STRUCTURE"
echo "----------------------------------------"

# Let's look at what the API actually returns vs what the app expects
echo "API Response Structure (from your curl):"
cat << 'EOF'
{
  "status": "success",
  "data": {
    "user": {
      "id": 1973559,
      "username": "bombardier",
      "email": "iammrpwinner01@gmail.com",
      "first_name": "Papove",
      "last_name": "Bombando",
      "user_type": "user",
      "level": 1,
      "points": 0,
      // ... other fields
    },
    "token": "..."
  }
}
EOF

echo ""
echo "Checking AppContext for array usage..."

# Check AppContext for potential issues
if [ -f "src/context/AppContext.jsx" ]; then
    cp "src/context/AppContext.jsx" "$BACKUP_DIR/"
    
    echo "Looking for .includes() usage in AppContext:"
    grep -n "includes" src/context/AppContext.jsx || echo "No .includes() found in AppContext"
    
    echo ""
    echo "Looking for array initializations:"
    grep -n "\[\]" src/context/AppContext.jsx || echo "No array initializations found"
else
    log_error "AppContext.jsx not found"
fi

echo ""
echo ">>> STEP 2: CHECK APP.JSX FOR ISSUES"
echo "----------------------------------------"

if [ -f "src/App.jsx" ]; then
    cp "src/App.jsx" "$BACKUP_DIR/"
    
    echo "Looking for .includes() usage in App.jsx:"
    grep -n -A2 -B2 "includes" src/App.jsx
    
    echo ""
    echo "These lines might be causing the error if currentView is undefined"
else
    log_error "App.jsx not found"
fi

echo ""
echo ">>> STEP 3: CREATE DEFENSIVE FIXES"
echo "----------------------------------------"

# Fix 1: Add defensive checks to App.jsx
echo "Adding defensive checks to App.jsx..."

# Create a safer version of App.jsx with defensive programming
cat > src/App.fixed.jsx << 'EOF'
import React, { useState, useEffect } from 'react';
import { AppProvider, useApp } from './context/AppContext';
import { useVenues } from './hooks/useVenues';

// Views
import LoginView from './components/Views/LoginView';
import HomeView from './components/Views/HomeView';
import VenueDetailsView from './components/Views/VenueDetailsView';
import RegistrationView from './components/Registration/RegistrationView';
import EmailVerificationView from './components/Auth/EmailVerificationView';

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

  // Defensive check for state
  if (!state) {
    console.error('App state is undefined');
    return <div>Loading...</div>;
  }

  // Ensure currentView has a default value
  const currentView = state.currentView || 'login';
  const isAuthenticated = state.isAuthenticated || false;

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

  // Handle email verification from URL
  useEffect(() => {
    const urlParams = new URLSearchParams(window.location.search);
    const verificationToken = urlParams.get('token');
    const verifyEmail = urlParams.get('verify');

    if (verificationToken && verifyEmail && actions) {
      actions.setCurrentView('email-verification');
      // Clean up URL
      window.history.replaceState({}, document.title, window.location.pathname);
    }
  }, [actions]);

  // Update search query in context
  useEffect(() => {
    if (actions && actions.setSearchQuery) {
      actions.setSearchQuery(searchQuery);
    }
  }, [searchQuery, actions]);

  // Auto-update venue data periodically when authenticated
  useEffect(() => {
    const authViews = ['login', 'register', 'email-verification'];
    if (isAuthenticated && !authViews.includes(currentView)) {
      const interval = setInterval(() => {
        updateVenueData();
      }, 45000);

      return () => clearInterval(interval);
    }
  }, [updateVenueData, currentView, isAuthenticated]);

  // Initialize app to login view if not authenticated
  useEffect(() => {
    const authViews = ['login', 'register', 'email-verification'];
    if (!isAuthenticated && !authViews.includes(currentView) && actions) {
      actions.setCurrentView('login');
    }
  }, [isAuthenticated, currentView, actions]);

  const handleShowRegistration = () => {
    if (actions) actions.setCurrentView('register');
  };

  const handleBackToLogin = () => {
    if (actions) actions.setCurrentView('login');
  };

  const handleRegistrationSuccess = (userData) => {
    // Registration success should redirect to login with verification message
    if (actions) actions.setCurrentView('login');
  };

  const handleEmailVerificationSuccess = () => {
    if (actions) {
      actions.setCurrentView('login');
      actions.clearVerificationMessage();
    }
  };

  const handleVenueSelect = (venue) => {
    if (actions) {
      actions.setSelectedVenue(venue);
      actions.setCurrentView('details');
    }
  };

  const handleBackToHome = () => {
    if (actions) {
      actions.setCurrentView('home');
      actions.setSelectedVenue(null);
    }
  };

  const handleClearSearch = () => {
    setSearchQuery('');
  };

  // Get verification token and email from URL or localStorage
  const getVerificationData = () => {
    const urlParams = new URLSearchParams(window.location.search);
    const token = urlParams.get('token');
    const email = urlParams.get('email') || localStorage.getItem('pending_verification_email');
    return { token, email };
  };

  // Determine if header should be shown (not on login, register, or verification pages)
  const authViews = ['login', 'register', 'email-verification'];
  const showHeader = !authViews.includes(currentView);

  // Debug logging
  console.log('App Debug:', {
    currentView,
    isAuthenticated,
    stateExists: !!state,
    actionsExists: !!actions
  });

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
        {currentView === 'login' && (
          <LoginView onRegister={handleShowRegistration} />
        )}

        {currentView === 'register' && (
          <RegistrationView
            onBack={handleBackToLogin}
            onSuccess={handleRegistrationSuccess}
          />
        )}

        {currentView === 'email-verification' && (
          <EmailVerificationView
            onBack={handleBackToLogin}
            onSuccess={handleEmailVerificationSuccess}
            token={getVerificationData().token}
            email={getVerificationData().email}
          />
        )}

        {currentView === 'home' && (
          <HomeView onVenueSelect={handleVenueSelect} />
        )}

        {currentView === 'details' && (
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

log_change "Created defensive App.jsx version"

echo ""
echo ">>> STEP 4: CHECK APPCONTEXT FOR ISSUES"
echo "----------------------------------------"

# Let's also check and potentially fix the AppContext
if [ -f "src/context/AppContext.jsx" ]; then
    echo "Examining AppContext.jsx for potential undefined arrays..."
    
    # Look for the specific pattern that might be causing issues
    echo "Current AppContext content (first 50 lines):"
    head -50 src/context/AppContext.jsx
    
    echo ""
    echo "If you see any array properties that might be undefined, we need to fix them."
else
    log_error "AppContext.jsx not found - this might be the issue!"
fi

echo ""
echo ">>> STEP 5: QUICK BROWSER DEBUG"
echo "----------------------------------------"

# Create a browser debugging snippet
cat > debug_post_login.js << 'EOF'
// Copy and paste this into browser console after login to debug
console.log('=== POST-LOGIN DEBUG ===');

// Check localStorage for user data
console.log('localStorage user:', localStorage.getItem('user'));
console.log('localStorage token:', localStorage.getItem('auth_token'));

// Check if React context is accessible
try {
  // This will help us see what's in the React state
  console.log('Window React DevTools:', window.__REACT_DEVTOOLS_GLOBAL_HOOK__);
} catch(e) {
  console.log('React DevTools not available');
}

// Check what's undefined and causing the includes error
console.log('=== CHECKING FOR UNDEFINED ARRAYS ===');

// Common arrays that might be undefined
const commonArrays = [
  'state.currentView',
  'state.user',
  'state.venues',
  'state.notifications'
];

commonArrays.forEach(path => {
  try {
    const value = eval(path);
    console.log(`${path}:`, value, typeof value);
  } catch(e) {
    console.log(`${path}: Not accessible`);
  }
});
EOF

log_change "Created browser debugging script: debug_post_login.js"

echo ""
echo ">>> STEP 6: APPLY THE FIX"
echo "----------------------------------------"

# Replace the current App.jsx with the defensive version
if [ -f "src/App.jsx" ]; then
    echo "Applying defensive fixes to App.jsx..."
    mv src/App.jsx "$BACKUP_DIR/App.jsx.original"
    mv src/App.fixed.jsx src/App.jsx
    log_change "Applied defensive fixes to App.jsx"
else
    log_error "App.jsx not found!"
fi

echo ""
echo ">>> IMMEDIATE ACTIONS"
echo "----------------------------------------"

echo "1. Restart your dev server:"
echo "   npm run dev"
echo ""

echo "2. Clear browser cache:"
echo "   Ctrl+Shift+R (or Cmd+Shift+R)"
echo ""

echo "3. Try logging in again"
echo ""

echo "4. If still getting white screen:"
echo "   - Open browser console"
echo "   - Copy/paste contents of debug_post_login.js"
echo "   - Send me the console output"
echo ""

echo "5. Check browser console for any other errors"

echo ""
echo ">>> MOST LIKELY CAUSES"
echo "----------------------------------------"
echo "🔍 The .includes() error is probably from:"
echo "  1. state.currentView is undefined"
echo "  2. Some user property expected to be an array is undefined"
echo "  3. AppContext not initializing properly after login"
echo "  4. User data structure mismatch"
echo ""

echo "✅ The defensive App.jsx should fix most of these issues"

echo ""
echo "======================================================="
echo "🎯 TEST THE FIX NOW!"
echo "======================================================="
echo "1. Restart dev server: npm run dev"
echo "2. Clear cache: Ctrl+Shift+R"
echo "3. Try login again"
echo "4. Check console for debug messages"
echo "======================================================="
