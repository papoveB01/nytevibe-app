import React, { createContext, useContext, useReducer, useCallback } from 'react';
import { SessionManager } from '../utils/sessionManager';

const AppContext = createContext();

const initialState = {
  isAuthenticated: false,
  currentUser: null,
  sessionInfo: null,
  isCheckingSession: true,
  currentView: 'landing',
  currentMode: null,
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
    }
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
        { id: 2, user: "Sarah L.", rating: 4, comment: "Great atmosphere but can get really crowded.", date: "1 week ago", helpful: 8 }
      ]
    }
  ],
  notifications: [],
  selectedVenue: null,
  showRatingModal: false,
  showReportModal: false,
  showShareModal: false,
  shareVenue: null
};

const appReducer = (state, action) => {
  try {
    switch (action.type) {
      case 'SET_SESSION_CHECK_COMPLETE':
        return { ...state, isCheckingSession: false };
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
  } catch (error) {
    console.error('Reducer error:', error);
    return { ...state };
  }
};

export const AppProvider = ({ children }) => {
  const [state, dispatch] = useReducer(appReducer, initialState);

  // 🚨 EMERGENCY FIX: Single, stable session initialization
  React.useEffect(() => {
    let mounted = true;
    let timeoutId = null;

    const emergencySafeInit = () => {
      if (!mounted) return;
      
      console.log('🔍 Emergency-safe session check...');
      
      try {
        // Clear any problematic sessions
        const hasIssues = localStorage.getItem('nytevibe_session_issues');
        if (hasIssues) {
          console.log('🧹 Auto-clearing problematic session...');
          SessionManager.clearSession();
        }

        // Safe session restoration
        SessionManager.cleanupExpiredSessions();
        const session = SessionManager.getValidSession();
        
        if (session && mounted) {
          const sessionInfo = SessionManager.getSessionInfo();
          dispatch({
            type: 'RESTORE_SESSION',
            payload: { user: session.user, sessionInfo }
          });
          console.log('✅ Session restored safely');
        } else if (mounted) {
          dispatch({ type: 'SET_SESSION_CHECK_COMPLETE' });
          console.log('💡 No valid session found, showing landing page');
        }
      } catch (error) {
        console.error('❌ Session initialization error:', error);
        try {
          SessionManager.clearSession();
          if (mounted) {
            dispatch({ type: 'SET_SESSION_CHECK_COMPLETE' });
          }
        } catch (e) {
          console.error('❌ Critical error in emergency fallback');
        }
      }
    };

    // Delayed initialization for stability
    timeoutId = setTimeout(emergencySafeInit, 500);

    // Cleanup function
    return () => {
      mounted = false;
      if (timeoutId) {
        clearTimeout(timeoutId);
      }
    };
  }, []); // 🚨 CRITICAL: Empty dependency array

  // Emergency-safe actions
  const actions = {
    login: useCallback((userData) => {
      try {
        console.log('🔐 Creating login session...');
        const sessionData = SessionManager.createSession(userData);
        if (sessionData) {
          const sessionInfo = SessionManager.getSessionInfo();
          dispatch({
            type: 'LOGIN',
            payload: { user: userData, sessionInfo }
          });
          return true;
        }
        return false;
      } catch (error) {
        console.error('❌ Login error:', error);
        return false;
      }
    }, []),

    logout: useCallback(() => {
      try {
        console.log('🚪 Emergency-safe logout...');
        SessionManager.clearSession();
        dispatch({ type: 'LOGOUT' });
      } catch (error) {
        console.error('❌ Logout error:', error);
        dispatch({ type: 'LOGOUT' });
      }
    }, []),

    setCurrentView: useCallback((view) => {
      try {
        dispatch({ type: 'SET_CURRENT_VIEW', payload: view });
      } catch (error) {
        console.error('❌ View change error:', error);
      }
    }, []),

    setCurrentMode: useCallback((mode) => {
      try {
        dispatch({ type: 'SET_CURRENT_MODE', payload: mode });
      } catch (error) {
        console.error('❌ Mode change error:', error);
      }
    }, []),

    setSelectedVenue: useCallback((venue) => {
      try {
        dispatch({ type: 'SET_SELECTED_VENUE', payload: venue });
      } catch (error) {
        console.error('❌ Venue selection error:', error);
      }
    }, []),

    setShowRatingModal: useCallback((show) => {
      try {
        dispatch({ type: 'SET_SHOW_RATING_MODAL', payload: show });
      } catch (error) {
        console.error('❌ Modal error:', error);
      }
    }, []),

    setShowReportModal: useCallback((show) => {
      try {
        dispatch({ type: 'SET_SHOW_REPORT_MODAL', payload: show });
      } catch (error) {
        console.error('❌ Modal error:', error);
      }
    }, []),

    addNotification: useCallback((notification) => {
      try {
        dispatch({ type: 'ADD_NOTIFICATION', payload: notification });
      } catch (error) {
        console.error('❌ Notification error:', error);
      }
    }, []),

    removeNotification: useCallback((id) => {
      try {
        dispatch({ type: 'REMOVE_NOTIFICATION', payload: id });
      } catch (error) {
        console.error('❌ Notification removal error:', error);
      }
    }, [])
  };

  return (
    <AppContext.Provider value={{ state, actions }}>
      {children}
    </AppContext.Provider>
  );
};

export const useApp = () => {
  try {
    const context = useContext(AppContext);
    if (!context) {
      throw new Error('useApp must be used within AppProvider');
    }
    return context;
  } catch (error) {
    console.error('❌ useApp hook error:', error);
    return { state: initialState, actions: {} };
  }
};
