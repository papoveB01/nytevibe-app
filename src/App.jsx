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
