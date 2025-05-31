import React, { useState, useEffect } from 'react';
import { AppProvider, useApp } from './context/AppContext';
import WelcomeLandingPage from './views/Landing/WelcomeLandingPage';
import Header from './components/Layout/Header';
import HomeView from './components/Views/HomeView';
import VenueDetailsView from './components/Views/VenueDetailsView';
import ShareModal from './components/Social/ShareModal';
import RatingModal from './components/Venue/RatingModal';
import ReportModal from './components/Venue/ReportModal';
import { useVenues } from './hooks/useVenues';
import { useNotifications } from './hooks/useNotifications';
import { UPDATE_INTERVALS } from './constants';
import './App.css';

function AppContent() {
  const { state, actions } = useApp();
  const [searchQuery, setSearchQuery] = useState('');
  const [venueFilter, setVenueFilter] = useState('all');
  const { updateVenueData } = useVenues();
  const { notifications, removeNotification } = useNotifications();

  // Real-time updates for user mode
  useEffect(() => {
    let interval;
    if (state.currentMode === 'user' && state.currentView === 'home' && !document.hidden) {
      interval = setInterval(() => {
        updateVenueData();
      }, UPDATE_INTERVALS.VENUE_DATA);
    }

    return () => {
      if (interval) clearInterval(interval);
    };
  }, [state.currentMode, state.currentView, updateVenueData]);

  // Pause updates when tab is hidden
  useEffect(() => {
    const handleVisibilityChange = () => {
      if (!document.hidden && state.currentMode === 'user' && state.currentView === 'home') {
        updateVenueData();
      }
    };

    document.addEventListener('visibilitychange', handleVisibilityChange);
    return () => {
      document.removeEventListener('visibilitychange', handleVisibilityChange);
    };
  }, [state.currentMode, state.currentView, updateVenueData]);

  const handleVenueShare = (venue) => {
    actions.setShareVenue(venue);
    actions.setShowShareModal(true);
  };

  const handleClearSearch = () => {
    setSearchQuery('');
    setVenueFilter('all');
  };

  const handleBackToHome = () => {
    actions.setCurrentView('home');
    actions.setSelectedVenue(null);
  };

  // Show landing page first
  if (state.currentView === 'landing' || !state.currentMode) {
    return <WelcomeLandingPage />;
  }

  // Render based on selected mode and view
  return (
    <div className="app-layout">
      {/* Header for customer mode home view */}
      {state.currentMode === 'user' && state.currentView === 'home' && (
        <Header
          searchQuery={searchQuery}
          setSearchQuery={setSearchQuery}
          onClearSearch={handleClearSearch}
        />
      )}

      {/* Main content */}
      <div className="content-frame">
        {/* Customer Mode Views */}
        {state.currentMode === 'user' && state.currentView === 'home' && (
          <HomeView
            searchQuery={searchQuery}
            venueFilter={venueFilter}
            setVenueFilter={setVenueFilter}
            onVenueShare={handleVenueShare}
          />
        )}

        {state.currentMode === 'user' && state.currentView === 'details' && (
          <VenueDetailsView
            onBack={handleBackToHome}
            onShare={handleVenueShare}
          />
        )}

        {/* Venue Owner Mode */}
        {state.currentMode === 'venue_owner' && (
          <div className="venue-owner-dashboard">
            <div style={{ padding: '40px', textAlign: 'center', color: 'white' }}>
              <h2>🏪 Business Dashboard</h2>
              <p>Venue owner interface coming soon...</p>
              <button 
                onClick={() => actions.setCurrentMode('user')}
                style={{ 
                  padding: '12px 24px', 
                  margin: '20px 10px',
                  background: '#3b82f6', 
                  color: 'white', 
                  border: 'none', 
                  borderRadius: '8px',
                  cursor: 'pointer'
                }}
              >
                Switch to Customer View
              </button>
              <button 
                onClick={() => {
                  actions.setCurrentView('landing');
                  actions.setCurrentMode(null);
                }}
                style={{ 
                  padding: '12px 24px', 
                  margin: '20px 10px',
                  background: '#6b7280', 
                  color: 'white', 
                  border: 'none', 
                  borderRadius: '8px',
                  cursor: 'pointer'
                }}
              >
                Back to Landing
              </button>
            </div>
          </div>
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
      <ShareModal
        venue={state.shareVenue}
        isOpen={state.showShareModal}
        onClose={() => {
          actions.setShowShareModal(false);
          actions.setShareVenue(null);
        }}
      />

      <RatingModal />
      <ReportModal />

      {/* Return to landing button for customer mode */}
      {state.currentMode === 'user' && (
        <button 
          onClick={() => {
            actions.setCurrentView('landing');
            actions.setCurrentMode(null);
          }}
          className="back-to-landing-button"
        >
          ← Back to Landing
        </button>
      )}
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
