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
import './App.css';

// 🚨 EMERGENCY: Inline loading screen to avoid context issues
const SessionLoadingScreen = () => (
  <div className="session-loading-screen">
    <div className="session-loading-content">
      <div className="session-loading-logo">nYtevibe</div>
      <div className="session-loading-spinner"></div>
      <div className="session-loading-text">Checking for existing session...</div>
    </div>
  </div>
);

// 🚨 EMERGENCY: Inline reset button to avoid import issues
const EmergencyReset = () => {
  const handleReset = () => {
    try {
      localStorage.clear();
      sessionStorage.clear();
      window.location.reload(true);
    } catch (error) {
      window.location.href = window.location.href;
    }
  };

  return (
    <div style={{
      position: 'fixed',
      top: '10px',
      right: '10px',
      zIndex: 10000,
      background: '#ff4444',
      color: 'white',
      padding: '8px 12px',
      borderRadius: '5px',
      cursor: 'pointer'
    }}>
      <button onClick={handleReset} style={{ background: 'none', border: 'none', color: 'white' }}>
        🚨 Reset App
      </button>
    </div>
  );
};

// 🛡️ Safe App Content - Only used INSIDE AppProvider
function AppContent() {
  const { state, actions } = useApp();
  const [searchQuery, setSearchQuery] = useState('');
  const [venueFilter, setVenueFilter] = useState('all');
  const [showShareModal, setShowShareModal] = useState(false);
  const [shareVenue, setShareVenue] = useState(null);

  // Show loading screen during session check
  if (state.isCheckingSession) {
    return <SessionLoadingScreen />;
  }

  // Safe view rendering
  const renderCurrentView = () => {
    try {
      switch (state.currentView) {
        case 'landing':
          return <WelcomeLandingPage />;
        
        case 'login':
          return <LoginPage />;
        
        case 'home':
          if (!state.isAuthenticated) {
            actions.setCurrentView('landing');
            return <WelcomeLandingPage />;
          }
          return (
            <>
              <Header
                searchQuery={searchQuery}
                setSearchQuery={setSearchQuery}
                onClearSearch={() => {
                  setSearchQuery('');
                  setVenueFilter('all');
                }}
              />
              <div className="content-frame">
                <HomeView
                  searchQuery={searchQuery}
                  setSearchQuery={setSearchQuery}
                  venueFilter={venueFilter}
                  setVenueFilter={setVenueFilter}
                  onVenueClick={(venue) => {
                    actions.setSelectedVenue(venue);
                    actions.setCurrentView('details');
                  }}
                  onVenueShare={(venue) => {
                    setShareVenue(venue);
                    setShowShareModal(true);
                  }}
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
                onBack={() => {
                  actions.setCurrentView('home');
                  actions.setSelectedVenue(null);
                }}
                onShare={(venue) => {
                  setShareVenue(venue);
                  setShowShareModal(true);
                }}
              />
            </div>
          );
        
        default:
          return <WelcomeLandingPage />;
      }
    } catch (error) {
      console.error('❌ View rendering error:', error);
      return <WelcomeLandingPage />;
    }
  };

  return (
    <div className="app-layout">
      {renderCurrentView()}
      
      {/* Notifications */}
      {state.notifications.length > 0 && (
        <div className="notification-container">
          {state.notifications.map((notification) => (
            <div
              key={notification.id}
              className={`notification notification-${notification.type}`}
            >
              <div className="notification-content">
                <span className="notification-message">{notification.message}</span>
                <button
                  onClick={() => actions.removeNotification(notification.id)}
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

// 🚨 MAIN APP: Wraps everything in provider safely
function App() {
  try {
    return (
      <AppProvider>
        <EmergencyReset />
        <AppContent />
      </AppProvider>
    );
  } catch (error) {
    console.error('❌ Critical App error:', error);
    
    // Nuclear fallback
    return (
      <div style={{ 
        height: '100vh', 
        display: 'flex', 
        alignItems: 'center', 
        justifyContent: 'center',
        flexDirection: 'column',
        background: '#1e293b',
        color: 'white'
      }}>
        <h1>🚨 App Error</h1>
        <p>Critical error occurred. Please reset the application.</p>
        <button 
          onClick={() => {
            localStorage.clear();
            window.location.reload();
          }}
          style={{
            background: '#ef4444',
            color: 'white',
            border: 'none',
            padding: '12px 24px',
            borderRadius: '8px',
            marginTop: '20px',
            cursor: 'pointer'
          }}
        >
          🔄 Reset Application
        </button>
      </div>
    );
  }
}

export default App;
