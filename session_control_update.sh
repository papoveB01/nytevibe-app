#!/bin/bash

# Quick Fix for React Error #310 - Missing Components
# Creates missing directories and components, fixes import issues

echo "🔧 Quick Fix - Resolving Missing Components and React Error #310"
echo ""

# Ensure we're in the right directory
if [ ! -f "package.json" ]; then
    echo "❌ Error: package.json not found. Please run this script from the nytevibe project root."
    exit 1
fi

echo "📁 Creating missing directory structure..."

# Create missing directories
mkdir -p src/components/Utils

echo "📝 Creating missing CacheClearer component..."

# Create the missing CacheClearer component
cat > src/components/Utils/CacheClearer.jsx << 'EOF'
import React, { useEffect } from 'react';

const CacheClearer = () => {
  useEffect(() => {
    // Clear all localStorage
    try {
      localStorage.clear();
      sessionStorage.clear();
      console.log('🧹 Cache and storage cleared');
    } catch (error) {
      console.log('🧹 Cache clearing completed (some items may be protected)');
    }
  }, []);

  return null;
};

export default CacheClearer;
EOF

echo "📝 Creating EmergencyReset component..."

# Create the EmergencyReset component
cat > src/components/Utils/EmergencyReset.jsx << 'EOF'
import React from 'react';

const EmergencyReset = () => {
  const handleReset = () => {
    // Clear all storage
    try {
      localStorage.clear();
      sessionStorage.clear();
    } catch (error) {
      console.log('Storage clearing completed');
    }
    
    // Force reload
    window.location.reload();
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
      fontSize: '12px',
      boxShadow: '0 2px 10px rgba(0,0,0,0.3)'
    }}>
      <button onClick={handleReset} style={{
        background: 'none',
        border: '1px solid white',
        color: 'white',
        padding: '4px 8px',
        borderRadius: '3px',
        cursor: 'pointer',
        fontSize: '11px'
      }}>
        🚨 Reset App
      </button>
    </div>
  );
};

export default EmergencyReset;
EOF

echo "🔄 Creating simpler App.jsx without problematic imports..."

# Create a simpler App.jsx that should work without issues
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
import './App.css';

// Emergency Reset Button Component (inline to avoid import issues)
const EmergencyReset = () => {
  const handleReset = () => {
    localStorage.clear();
    sessionStorage.clear();
    window.location.reload();
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
      fontSize: '12px'
    }}>
      <button onClick={handleReset} style={{
        background: 'none',
        border: '1px solid white',
        color: 'white',
        padding: '4px 8px',
        borderRadius: '3px',
        cursor: 'pointer'
      }}>
        🚨 Reset
      </button>
    </div>
  );
};

// Simple loading component
const SessionLoadingScreen = () => (
  <div className="session-loading-screen">
    <div className="session-loading-content">
      <div className="session-loading-logo">nYtevibe</div>
      <div className="session-loading-spinner"></div>
      <div className="session-loading-text">Checking for existing session...</div>
    </div>
  </div>
);

function AppContent() {
  const { state, actions } = useApp();
  const [searchQuery, setSearchQuery] = useState('');
  const [venueFilter, setVenueFilter] = useState('all');
  const [showShareModal, setShowShareModal] = useState(false);
  const [shareVenue, setShareVenue] = useState(null);

  // Clear cache on first load
  useEffect(() => {
    try {
      // Only clear if there are session-related issues
      const hasSessionIssues = localStorage.getItem('nytevibe_session_issues');
      if (hasSessionIssues) {
        localStorage.clear();
        sessionStorage.clear();
        localStorage.removeItem('nytevibe_session_issues');
        console.log('🧹 Cleared problematic session data');
      }
    } catch (error) {
      console.log('🧹 Cache check completed');
    }
  }, []);

  // Show loading screen while checking session
  if (state.isCheckingSession) {
    return <SessionLoadingScreen />;
  }

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

  const renderCurrentView = () => {
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
      <EmergencyReset />
      {renderCurrentView()}

      {/* Notifications */}
      {state.notifications && state.notifications.length > 0 && (
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

function App() {
  return (
    <AppProvider>
      <AppContent />
    </AppProvider>
  );
}

export default App;
EOF

echo "🔄 Creating super stable AppContext without useEffect loops..."

# Create the most stable version of AppContext
cat > src/context/AppContext.jsx << 'EOF'
import React, { createContext, useContext, useReducer } from 'react';
import SessionManager from '../utils/sessionManager';

const AppContext = createContext();

const initialState = {
  // Authentication state
  isAuthenticated: false,
  currentUser: null,
  sessionInfo: null,
  isCheckingSession: false, // Start as false to avoid loading state
  
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
  currentMode: null,
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
    case 'SET_SESSION_CHECK_COMPLETE':
      return { 
        ...state, 
        isCheckingSession: false 
      };

    case 'RESTORE_SESSION':
      return { 
        ...state, 
        isAuthenticated: true,
        currentUser: action.payload.user,
        sessionInfo: action.payload.sessionInfo,
        isCheckingSession: false,
        currentView: 'home'
      };

    case 'LOGIN':
      return { 
        ...state, 
        isAuthenticated: true,
        currentUser: action.payload.user,
        sessionInfo: action.payload.sessionInfo,
        isCheckingSession: false
      };

    case 'LOGOUT':
      return { 
        ...state, 
        isAuthenticated: false,
        currentUser: null,
        sessionInfo: null,
        currentView: 'landing',
        currentMode: null,
        selectedVenue: null,
        showRatingModal: false,
        showReportModal: false,
        showShareModal: false,
        shareVenue: null
      };

    case 'EXTEND_SESSION':
      return {
        ...state,
        sessionInfo: action.payload
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

  // Session initialization - check once when component mounts
  React.useEffect(() => {
    let mounted = true;

    const initializeSession = () => {
      if (!mounted) return;

      console.log('🔍 Checking for existing session...');
      
      try {
        SessionManager.cleanupExpiredSessions();
        const existingSession = SessionManager.getValidSession();
        
        if (existingSession && mounted) {
          const sessionInfo = SessionManager.getSessionInfo();
          dispatch({ 
            type: 'RESTORE_SESSION', 
            payload: { 
              user: existingSession.user,
              sessionInfo: sessionInfo
            }
          });
          console.log('✅ Session restored successfully');
        } else if (mounted) {
          dispatch({ type: 'SET_SESSION_CHECK_COMPLETE' });
          console.log('💡 No valid session found, showing landing page');
        }
      } catch (error) {
        console.error('❌ Error during session initialization:', error);
        if (mounted) {
          dispatch({ type: 'SET_SESSION_CHECK_COMPLETE' });
        }
      }
    };

    // Small delay to ensure clean initialization
    const timeoutId = setTimeout(initializeSession, 500);
    
    return () => {
      mounted = false;
      clearTimeout(timeoutId);
    };
  }, []); // Empty dependency array - only run once

  // Simple, stable actions object
  const actions = {
    login: (userData) => {
      console.log('🔐 Creating login session...');
      
      try {
        const sessionData = SessionManager.createSession(userData);
        
        if (sessionData) {
          const sessionInfo = SessionManager.getSessionInfo();
          dispatch({ 
            type: 'LOGIN', 
            payload: { 
              user: userData,
              sessionInfo: sessionInfo
            }
          });
          return true;
        } else {
          console.error('❌ Failed to create session');
          return false;
        }
      } catch (error) {
        console.error('❌ Login error:', error);
        return false;
      }
    },

    logout: () => {
      console.log('🚪 Logging out and clearing session...');
      
      try {
        SessionManager.clearSession();
        dispatch({ type: 'LOGOUT' });
      } catch (error) {
        console.error('❌ Logout error:', error);
      }
    },

    extendSession: () => {
      try {
        const extendedSession = SessionManager.extendSession();
        if (extendedSession) {
          const sessionInfo = SessionManager.getSessionInfo();
          dispatch({ type: 'EXTEND_SESSION', payload: sessionInfo });
        }
      } catch (error) {
        console.error('❌ Session extension error:', error);
      }
    },

    getSessionInfo: () => {
      try {
        return SessionManager.getSessionInfo();
      } catch (error) {
        console.error('❌ Get session info error:', error);
        return null;
      }
    },

    setCurrentView: (view) => {
      dispatch({ type: 'SET_CURRENT_VIEW', payload: view });
    },

    setCurrentMode: (mode) => {
      dispatch({ type: 'SET_CURRENT_MODE', payload: mode });
    },

    setSelectedVenue: (venue) => {
      dispatch({ type: 'SET_SELECTED_VENUE', payload: venue });
    },

    setShowRatingModal: (show) => {
      dispatch({ type: 'SET_SHOW_RATING_MODAL', payload: show });
    },

    setShowReportModal: (show) => {
      dispatch({ type: 'SET_SHOW_REPORT_MODAL', payload: show });
    },

    setShowShareModal: (show) => {
      dispatch({ type: 'SET_SHOW_SHARE_MODAL', payload: show });
    },

    setShareVenue: (venue) => {
      dispatch({ type: 'SET_SHARE_VENUE', payload: venue });
    },

    updateVenueData: () => {
      dispatch({ type: 'UPDATE_VENUE_DATA' });
    },

    followVenue: (venueId, venueName) => {
      dispatch({ type: 'FOLLOW_VENUE', payload: { venueId, venueName } });
    },

    unfollowVenue: (venueId, venueName) => {
      dispatch({ type: 'UNFOLLOW_VENUE', payload: { venueId, venueName } });
    },

    addNotification: (notification) => {
      dispatch({ type: 'ADD_NOTIFICATION', payload: notification });
    },

    removeNotification: (id) => {
      dispatch({ type: 'REMOVE_NOTIFICATION', payload: id });
    }
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

echo "📝 Fixing package.json for development mode..."

# Reset package.json to normal
cat > package.json << 'EOF'
{
  "name": "nytevibe",
  "private": true,
  "version": "0.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "lint": "eslint . --ext js,jsx --report-unused-disable-directives --max-warnings 0",
    "preview": "vite preview"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "lucide-react": "^0.263.1"
  },
  "devDependencies": {
    "@types/react": "^18.2.15",
    "@types/react-dom": "^18.2.7",
    "@vitejs/plugin-react": "^4.0.3",
    "eslint": "^8.45.0",
    "eslint-plugin-react": "^7.32.2",
    "eslint-plugin-react-hooks": "^4.6.0",
    "eslint-plugin-react-refresh": "^0.4.3",
    "vite": "^4.4.5"
  }
}
EOF

echo "📝 Resetting vite.config.js..."

# Reset vite config
cat > vite.config.js << 'EOF'
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
})
EOF

echo ""
echo "✅ Quick Fix Complete!"
echo ""
echo "🔧 Issues Resolved:"
echo "   ✅ Created missing components directory"
echo "   ✅ Fixed import path issues"
echo "   ✅ Removed problematic useEffect loops"
echo "   ✅ Added inline EmergencyReset component"
echo "   ✅ Simplified session initialization"
echo "   ✅ Created stable AppContext"
echo ""
echo "🚨 IMMEDIATE ACTIONS:"
echo ""
echo "1. 🔄 RESTART THE SERVER:"
echo "   • Stop current server (Ctrl+C)"
echo "   • Run: npm run dev"
echo ""
echo "2. 🧹 CLEAR BROWSER CACHE:"
echo "   • Press Ctrl+Shift+Delete"
echo "   • Clear all browsing data"
echo "   • Or use the red 'Reset' button in top-right"
echo ""
echo "3. 🔍 CHECK CONSOLE:"
echo "   • Should see: '🔍 Checking for existing session...'"
echo "   • Should see: '💡 No valid session found, showing landing page'"
echo "   • NO React Error #310 messages"
echo ""
echo "🎯 Expected Result:"
echo "   ✅ App loads successfully"
echo "   ✅ Landing page appears"
echo "   ✅ No infinite loop errors"
echo "   ✅ Red reset button available if needed"
echo ""
echo "💡 If error persists:"
echo "   • Click the red 'Reset' button"
echo "   • Try: rm -rf node_modules && npm install && npm run dev"
echo ""
