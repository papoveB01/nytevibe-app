import React, { useState, useEffect } from 'react';
import { useApp } from './context/AppContext';
import { useVenues } from './hooks/useVenues';

// Views
import LoginView from './components/Views/LoginView';
import HomeView from './components/Views/HomeView';
import VenueDetailsView from './components/Views/VenueDetailsView';
import RegistrationView from './components/Registration/RegistrationView';
import EmailVerificationView from './components/Auth/EmailVerificationView';
import ForgotPasswordView from './components/Views/ForgotPasswordView';
import ResetPasswordView from './components/Views/ResetPasswordView';
import TermsAndConditions from './components/TermsAndConditions';
import PrivacyPolicy from './components/PrivacyPolicy';

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
  const [verificationData, setVerificationData] = useState({ token: null, email: null, userId: null });
  const [resetData, setResetData] = useState({ token: null, email: null });

  // Defensive check for state
  if (!state) {
    console.error('App state is undefined');
    return <div>Loading...</div>;
  }

  // Ensure currentView has a default value
  const currentView = state.currentView || 'landing';
  const isAuthenticated = state.isAuthenticated || false;
  const isLoading = state.isLoading || false;

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

  // Handle both email verification AND password reset from URL
  useEffect(() => {
    const urlParams = new URLSearchParams(window.location.search);
    
    // Email verification logic
    const verificationToken = urlParams.get('token');
    const verifyEmail = urlParams.get('verify');
    const userId = urlParams.get('userId');

    console.log('🔍 ExistingApp.jsx URL Parameter Debug:');
    console.log('- verificationToken:', verificationToken);
    console.log('- verifyEmail:', verifyEmail);
    console.log('- userId:', userId);
    console.log('- email:', urlParams.get("email"));

    if (verificationToken && verifyEmail && actions) {
      setVerificationData({ 
        token: verificationToken, 
        email: urlParams.get("email") || localStorage.getItem("pending_verification_email"),
        userId: userId
      });
      actions.setCurrentView('email-verification');
      // Clean up URL
      window.history.replaceState({}, document.title, window.location.pathname);
      return; // Exit early for email verification
    }

    // Password reset logic
    const resetToken = urlParams.get('token');
    const resetEmail = urlParams.get('email');

    // Check if this is a password reset link (has both token and email, but no 'verify' param)
    if (resetToken && resetEmail && !verifyEmail && actions) {
      setResetData({ token: resetToken, email: resetEmail });
      actions.setCurrentView('reset-password');
      // Clean up URL
      window.history.replaceState({}, document.title, window.location.pathname);
    }
  }, [actions]);

  // Handle Terms and Conditions AND Privacy Policy URL paths
  useEffect(() => {
    const pathname = window.location.pathname;
    
    // Check if URL is /terms, /terms-and-conditions, /privacy, or /privacy-policy
    if ((pathname === '/terms' || pathname === '/terms-and-conditions') && actions) {
      actions.setCurrentView('terms');
    } else if ((pathname === '/privacy' || pathname === '/privacy-policy') && actions) {
      actions.setCurrentView('privacy');
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
    // Extra safety checks for React re-render race conditions 
    if (!currentView || !isAuthenticated || !updateVenueData) { 
      return; 
    } 
    const authViews = ['landing', 'login', 'register', 'email-verification', 'forgot-password', 'reset-password', 'terms', 'privacy'];
    
    // Verify authViews is array and currentView is string before using .includes() 
    if (!Array.isArray(authViews) || typeof currentView !== 'string') {
      return; 
    }
    
    if (isAuthenticated && !authViews.includes(currentView)) {      
      const interval = setInterval(() => {
        updateVenueData();
      }, 45000);

      return () => clearInterval(interval);
    }
  }, [updateVenueData, currentView, isAuthenticated]);

  const handleShowRegistration = () => {
    if (actions) actions.setCurrentView('register');
  };

  const handleBackToLogin = () => {
    if (actions) actions.setCurrentView('login');
  };

  const handleShowForgotPassword = () => {
    if (actions) actions.setCurrentView('forgot-password');
  };

  const handleForgotPasswordSuccess = () => {
    if (actions) actions.setCurrentView('login');
  };

  const handlePasswordResetSuccess = () => {
    if (actions) {
      actions.setCurrentView('login');
      // You can add a success message to your context if needed
      // actions.showNotification('Password reset successful! You can now log in with your new password.');
    }
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
    const userId = urlParams.get('userId');
    return { token, email, userId };
  };

  // Render the appropriate view based on state
  const renderCurrentView = () => {
    console.log('🖼️ ExistingApp: Rendering view:', currentView, 'Authenticated:', isAuthenticated, 'Loading:', isLoading);
    
    // Show loading during initialization
    if (isLoading) {
      return (
        <div className="loading-container">
          <div className="loading-spinner">Loading...</div>
        </div>
      );
    }
    
    // Route based on currentView - let the context handle navigation
    switch (currentView) {
      case 'landing':
        return (
          <div className="landing-view">
            <div className="landing-content">
              <h1>Welcome to nYtevibe</h1>
              <p>Discover Houston's Best Nightlife</p>
              <button onClick={handleBackToLogin} className="cta-button">
                Get Started
              </button>
            </div>
          </div>
        );
        
      case 'login':
        return (
          <LoginView 
            onRegister={handleShowRegistration}
            onForgotPassword={handleShowForgotPassword}
          />
        );
        
      case 'register':
        return (
          <RegistrationView
            onBack={handleBackToLogin}
            onSuccess={handleRegistrationSuccess}
          />
        );
        
      case 'home':
        // 🔥 FIX: Only check auth for protected routes, don't redirect here
        // Let the context handle the proper navigation
        return <HomeView onVenueSelect={handleVenueSelect} />;
        
      case 'details':
        return <VenueDetailsView onBack={handleBackToHome} />;
        
      case 'email-verification':
        return (
          <EmailVerificationView
            onBack={handleBackToLogin}
            onSuccess={handleEmailVerificationSuccess}
            token={verificationData.token}
            email={verificationData.email}
            userId={verificationData.userId}
          />
        );
        
      case 'forgot-password':
        return (
          <ForgotPasswordView
            onBack={handleBackToLogin}
            onSuccess={handleForgotPasswordSuccess}
          />
        );
        
      case 'reset-password':
        return (
          <ResetPasswordView
            onBack={handleBackToLogin}
            onSuccess={handlePasswordResetSuccess}
            token={resetData.token}
            email={resetData.email}
          />
        );
        
      case 'terms':
        return <TermsAndConditions />;
        
      case 'privacy':
        return <PrivacyPolicy />;
        
      default:
        console.log('🤔 ExistingApp: Unknown view:', currentView, '- using fallback');
        // Fallback based on authentication state
        return isAuthenticated ? (
          <HomeView onVenueSelect={handleVenueSelect} />
        ) : (
          <LoginView 
            onRegister={handleShowRegistration}
            onForgotPassword={handleShowForgotPassword}
          />
        );
    }
  };

  // Auth views list for header visibility
  const authViews = ['landing', 'login', 'register', 'email-verification', 'forgot-password', 'reset-password', 'terms', 'privacy'];

  // Safe header visibility calculation with type validation
  let showHeader = false;
  if (Array.isArray(authViews) && typeof currentView === 'string') {
    showHeader = !authViews.includes(currentView);
  }
  
  // Debug logging
  console.log('🖼️ ExistingApp Debug:', {
    currentView,
    isAuthenticated,
    isLoading,
    stateExists: !!state,
    actionsExists: !!actions,
    verificationData: verificationData
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
        {renderCurrentView()}
      </main>

      {/* Modals - Only hide on Terms and Privacy pages */}
      {currentView !== 'terms' && currentView !== 'privacy' && (
        <>
          <RatingModal />
          <ReportModal />
          <ShareModal />
          <UserProfileModal />
        </>
      )}

      {/* Notifications */}
      <Notifications />
    </div>
  );
}

// 🔥 CRITICAL FIX: Change from "App" to "ExistingApp"
function ExistingApp() {
  return (
    <AppContent />
  );
}

// 🔥 CRITICAL FIX: Export as "ExistingApp" instead of "App"
export default ExistingApp;
