import React, { useState, useEffect } from 'react';
import { AppProvider, useApp } from './context/AppContext';
import Header from './components/Layout/Header';
import LandingView from './components/Views/LandingView';
import LoginView from './components/Views/LoginView';
import HomeView from './components/Views/HomeView';
import VenueDetailsView from './components/Views/VenueDetailsView';
import UserProfileModal from './components/User/UserProfileModal';
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
  const { updateVenueData } = useVenues();
  const { notifications, removeNotification } = useNotifications();

  // Auto-update venue data
  useEffect(() => {
    if (state.isAuthenticated && !['landing', 'login'].includes(state.currentView)) {
      const interval = setInterval(() => {
        updateVenueData();
      }, 45000);
      return () => clearInterval(interval);
    }
  }, [updateVenueData, state.currentView, state.isAuthenticated]);

  // User type selection handler
  const handleSelectUserType = (userType) => {
    actions.setUserType(userType);
    if (userType === 'user') {
      actions.setCurrentView('login');
    } else {
      actions.setCurrentView('home');
      actions.addNotification({
        type: 'success',
        message: '🏢 Welcome to nYtevibe Business! Start showcasing your venue.',
        duration: 4000
      });
    }
  };

  // Login handler
  const handleLogin = (userData) => {
    actions.loginUser(userData);
    actions.addNotification({
      type: 'success',
      message: `🎉 Welcome back, ${userData.firstName}! Start discovering Houston's best nightlife.`,
      duration: 4000
    });
  };

  // Navigation handlers
  const handleBackToLanding = () => {
    actions.setCurrentView('landing');
    actions.setUserType(null);
  };

  const handleVenueClick = (venue) => {
    actions.setSelectedVenue(venue);
    actions.setCurrentView('details');
  };

  const handleBackToHome = () => {
    actions.setCurrentView('home');
    actions.setSelectedVenue(null);
  };

  const handleVenueShare = (venue) => {
    actions.setShareVenue(venue);
    actions.setShowShareModal(true);
  };

  const handleClearSearch = () => {
    setSearchQuery('');
    setVenueFilter('all');
  };

  // Show header only when not on landing or login page
  const showHeader = !['landing', 'login'].includes(state.currentView);

  return (
    <div className="app-layout">
      {showHeader && (
        <Header
          searchQuery={searchQuery}
          setSearchQuery={setSearchQuery}
          onClearSearch={handleClearSearch}
        />
      )}

      <div className="content-frame">
        {state.currentView === 'landing' && (
          <LandingView onSelectUserType={handleSelectUserType} />
        )}

        {state.currentView === 'login' && (
          <LoginView
            onBack={handleBackToLanding}
            onLogin={handleLogin}
          />
        )}

        {state.currentView === 'home' && (
          <HomeView
            searchQuery={searchQuery}
            setSearchQuery={setSearchQuery}
            venueFilter={venueFilter}
            setVenueFilter={setVenueFilter}
            onVenueClick={handleVenueClick}
            onVenueShare={handleVenueShare}
          />
        )}

        {state.currentView === 'details' && (
          <VenueDetailsView
            onBack={handleBackToHome}
            onShare={handleVenueShare}
          />
        )}
      </div>

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
      <ShareModal />
      <RatingModal />
      <ReportModal />
      <UserProfileModal />
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
