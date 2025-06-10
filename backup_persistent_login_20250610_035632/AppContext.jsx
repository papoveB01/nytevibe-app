import React, { createContext, useContext, useReducer, useCallback } from 'react';
import authAPI from '../services/authAPI';

const AppContext = createContext();

// Initial state
const initialState = {
  // Authentication & User
  user: null,
  isAuthenticated: false,
  userProfile: null,
  userType: null,
  
  // UI State
  currentView: 'landing',
  searchQuery: '',
  isLoading: false,
  
  // Venue Related
  selectedVenue: null,
  followedVenues: new Set(),
  
  // Notifications
  notifications: [],
  
  // Modal states
  showRatingModal: false,
  showReportModal: false,
  showShareModal: false,
  showUserProfileModal: false,
  
  // Registration state
  registrationStep: 1,
  registrationData: {},
  
  // Email verification state
  verificationMessage: {
    show: false,
    email: '',
    type: '' // 'registration_success', 'resend_verification'
  },
  
  // Share modal state
  shareVenue: null,
  
  // Error state
  error: null,
  
  // Demo venue data
  venues: [
    {
      id: 'venue_001',
      name: 'Rooftop Lounge',
      type: 'Rooftop Bar',
      address: '123 Downtown Ave, Houston, TX 77002',
      rating: 4.5,
      totalRatings: 324,
      crowdLevel: 75,
      waitTime: 15,
      followersCount: 1289,
      reports: 45,
      lastUpdate: '5 min ago',
      confidence: 92,
      hasPromotion: true,
      promotionText: 'Happy Hour: 50% off cocktails until 8 PM!',
      vibe: ['Upscale', 'City Views', 'Cocktails', 'Live Music'],
      phone: '+1-713-555-0123',
      hours: 'Mon-Thu 5PM-12AM, Fri-Sat 5PM-2AM, Sun 6PM-11PM',
      reviews: [
        {
          id: 'rev_001',
          user: 'Sarah M.',
          rating: 5,
          date: '2 days ago',
          comment: 'Amazing views and great cocktails! The rooftop atmosphere is perfect for date night.',
          helpful: 12
        },
        {
          id: 'rev_002',
          user: 'Mike R.',
          rating: 4,
          date: '1 week ago',
          comment: 'Good vibes and decent drinks. Can get crowded on weekends but worth the wait.',
          helpful: 8
        }
      ]
    },
    {
      id: 'venue_002',
      name: 'Underground Club',
      type: 'Dance Club',
      address: '456 Music District, Houston, TX 77004',
      rating: 4.2,
      totalRatings: 567,
      crowdLevel: 90,
      waitTime: 30,
      followersCount: 2134,
      reports: 78,
      lastUpdate: '2 min ago',
      confidence: 88,
      hasPromotion: false,
      promotionText: '',
      vibe: ['EDM', 'Dancing', 'Late Night', 'Underground'],
      phone: '+1-713-555-0124',
      hours: 'Thu-Sat 10PM-4AM',
      reviews: [
        {
          id: 'rev_003',
          user: 'Alex P.',
          rating: 5,
          date: '3 days ago',
          comment: 'Best EDM club in Houston! Amazing sound system and the crowd is always energetic.',
          helpful: 15
        }
      ]
    },
    {
      id: 'venue_003',
      name: 'Craft Beer Garden',
      type: 'Beer Garden',
      address: '789 Brewery Lane, Houston, TX 77006',
      rating: 4.7,
      totalRatings: 891,
      crowdLevel: 45,
      waitTime: 0,
      followersCount: 3456,
      reports: 23,
      lastUpdate: '1 min ago',
      confidence: 95,
      hasPromotion: true,
      promotionText: 'Try our new seasonal IPA - 20% off today only!',
      vibe: ['Craft Beer', 'Outdoor', 'Relaxed', 'Food Trucks'],
      phone: '+1-713-555-0125',
      hours: 'Mon-Wed 4PM-11PM, Thu-Sat 2PM-12AM, Sun 2PM-10PM',
      reviews: [
        {
          id: 'rev_004',
          user: 'Jennifer L.',
          rating: 5,
          date: '1 day ago',
          comment: 'Love the outdoor setting and amazing beer selection. Food trucks on weekends are a bonus!',
          helpful: 20
        }
      ]
    },
    {
      id: 'venue_004',
      name: 'Jazz Corner',
      type: 'Jazz Club',
      address: '321 Heritage St, Houston, TX 77007',
      rating: 4.8,
      totalRatings: 234,
      crowdLevel: 60,
      waitTime: 5,
      followersCount: 987,
      reports: 12,
      lastUpdate: '8 min ago',
      confidence: 87,
      hasPromotion: false,
      promotionText: '',
      vibe: ['Live Jazz', 'Intimate', 'Classic', 'Wine Bar'],
      phone: '+1-713-555-0126',
      hours: 'Tue-Sun 7PM-1AM',
      reviews: [
        {
          id: 'rev_005',
          user: 'Robert K.',
          rating: 5,
          date: '4 days ago',
          comment: 'Authentic jazz experience with talented local musicians. Intimate setting with excellent acoustics.',
          helpful: 9
        }
      ]
    },
    {
      id: 'venue_005',
      name: 'Sports Bar Central',
      type: 'Sports Bar',
      address: '654 Stadium Dr, Houston, TX 77008',
      rating: 4.1,
      totalRatings: 445,
      crowdLevel: 85,
      waitTime: 20,
      followersCount: 1678,
      reports: 34,
      lastUpdate: '3 min ago',
      confidence: 91,
      hasPromotion: true,
      promotionText: 'Game Day Special: $2 beers during all Texans games!',
      vibe: ['Sports', 'Casual', 'Big Screens', 'Wings'],
      phone: '+1-713-555-0127',
      hours: 'Daily 11AM-2AM',
      reviews: [
        {
          id: 'rev_006',
          user: 'Tom W.',
          rating: 4,
          date: '5 days ago',
          comment: 'Great place to watch the game with friends. Lots of TVs and good bar food.',
          helpful: 6
        }
      ]
    },
    {
      id: 'venue_006',
      name: 'Mixology Lab',
      type: 'Cocktail Lounge',
      address: '987 Innovation Blvd, Houston, TX 77009',
      rating: 4.6,
      totalRatings: 312,
      crowdLevel: 55,
      waitTime: 10,
      followersCount: 2567,
      reports: 18,
      lastUpdate: '6 min ago',
      confidence: 89,
      hasPromotion: false,
      promotionText: '',
      vibe: ['Craft Cocktails', 'Sophisticated', 'Innovation', 'Date Night'],
      phone: '+1-713-555-0128',
      hours: 'Wed-Sat 6PM-2AM',
      reviews: [
        {
          id: 'rev_007',
          user: 'Lisa H.',
          rating: 5,
          date: '2 days ago',
          comment: 'Incredible cocktail creations! Each drink is like a work of art. Definitely worth the premium prices.',
          helpful: 14
        }
      ]
    }
  ]
};

// Action types
const actionTypes = {
  // Authentication actions
  SET_USER: 'SET_USER',
  SET_AUTH: 'SET_AUTH',
  LOGIN_SUCCESS: 'LOGIN_SUCCESS',
  LOGIN_FAILURE: 'LOGIN_FAILURE',
  LOGOUT: 'LOGOUT',
  
  // UI State actions
  SET_CURRENT_VIEW: 'SET_CURRENT_VIEW',
  SET_SEARCH_QUERY: 'SET_SEARCH_QUERY',
  SET_LOADING: 'SET_LOADING',
  SET_ERROR: 'SET_ERROR',
  CLEAR_ERROR: 'CLEAR_ERROR',
  
  // User actions
  SET_USER_TYPE: 'SET_USER_TYPE',
  LOGIN_USER: 'LOGIN_USER',
  LOGOUT_USER: 'LOGOUT_USER',
  
  // Venue actions
  SET_SELECTED_VENUE: 'SET_SELECTED_VENUE',
  TOGGLE_VENUE_FOLLOW: 'TOGGLE_VENUE_FOLLOW',
  UPDATE_VENUE_DATA: 'UPDATE_VENUE_DATA',
  
  // Notification actions
  ADD_NOTIFICATION: 'ADD_NOTIFICATION',
  REMOVE_NOTIFICATION: 'REMOVE_NOTIFICATION',
  
  // Modal actions
  SET_SHOW_RATING_MODAL: 'SET_SHOW_RATING_MODAL',
  SET_SHOW_REPORT_MODAL: 'SET_SHOW_REPORT_MODAL',
  SET_SHOW_SHARE_MODAL: 'SET_SHOW_SHARE_MODAL',
  SET_SHOW_USER_PROFILE_MODAL: 'SET_SHOW_USER_PROFILE_MODAL',
  SET_SHARE_VENUE: 'SET_SHARE_VENUE',
  SUBMIT_VENUE_RATING: 'SUBMIT_VENUE_RATING',
  SUBMIT_VENUE_REPORT: 'SUBMIT_VENUE_REPORT',
  
  // Registration actions
  SET_REGISTRATION_STEP: 'SET_REGISTRATION_STEP',
  UPDATE_REGISTRATION_DATA: 'UPDATE_REGISTRATION_DATA',
  CLEAR_REGISTRATION_DATA: 'CLEAR_REGISTRATION_DATA',
  
  // Email verification actions
  SET_VERIFICATION_MESSAGE: 'SET_VERIFICATION_MESSAGE',
  CLEAR_VERIFICATION_MESSAGE: 'CLEAR_VERIFICATION_MESSAGE'
};

// Reducer
function appReducer(state, action) {
  switch (action.type) {
    // Authentication cases
    case actionTypes.SET_USER:
      return {
        ...state,
        user: action.payload,
        userProfile: action.payload // Keep backward compatibility
      };
      
    case actionTypes.SET_AUTH:
      return {
        ...state,
        isAuthenticated: action.payload
      };
      
    case actionTypes.LOGIN_SUCCESS:
      return {
        ...state,
        user: action.payload.user,
        userProfile: action.payload.user,
        isAuthenticated: true,
        error: null,
        currentView: 'home'
      };
      
    case actionTypes.LOGIN_FAILURE:
      return {
        ...state,
        user: null,
        userProfile: null,
        isAuthenticated: false,
        error: action.payload
      };
      
    case actionTypes.LOGOUT:
      return {
        ...state,
        user: null,
        userProfile: null,
        isAuthenticated: false,
        userType: null,
        currentView: 'login',
        selectedVenue: null,
        followedVenues: new Set(),
        error: null
      };
      
    // UI State cases
    case actionTypes.SET_CURRENT_VIEW:
      return { ...state, currentView: action.payload };
      
    case actionTypes.SET_SEARCH_QUERY:
      return { ...state, searchQuery: action.payload };
      
    case actionTypes.SET_LOADING:
      return { ...state, isLoading: action.payload };
      
    case actionTypes.SET_ERROR:
      return { ...state, error: action.payload };
      
    case actionTypes.CLEAR_ERROR:
      return { ...state, error: null };
      
    // Legacy user actions (kept for backward compatibility)
    case actionTypes.SET_USER_TYPE:
      return { ...state, userType: action.payload };
      
    case actionTypes.LOGIN_USER:
      return {
        ...state,
        isAuthenticated: true,
        userProfile: action.payload,
        user: action.payload,
        currentView: 'home'
      };
      
    case actionTypes.LOGOUT_USER:
      authAPI.clearAuth(); // Clear stored auth data
      return {
        ...state,
        isAuthenticated: false,
        userProfile: null,
        user: null,
        userType: null,
        currentView: 'login',
        followedVenues: new Set()
      };
      
    // Venue cases
    case actionTypes.SET_SELECTED_VENUE:
      return { ...state, selectedVenue: action.payload };
      
    case actionTypes.TOGGLE_VENUE_FOLLOW:
      const newFollowedVenues = new Set(state.followedVenues);
      const venueId = action.payload;
      if (newFollowedVenues.has(venueId)) {
        newFollowedVenues.delete(venueId);
      } else {
        newFollowedVenues.add(venueId);
      }
      return {
        ...state,
        followedVenues: newFollowedVenues,
        venues: state.venues.map(venue =>
          venue.id === venueId
            ? {
                ...venue,
                followersCount: newFollowedVenues.has(venueId)
                  ? venue.followersCount + 1
                  : venue.followersCount - 1
              }
            : venue
        )
      };
      
    case actionTypes.UPDATE_VENUE_DATA:
      return {
        ...state,
        venues: state.venues.map(venue => ({
          ...venue,
          crowdLevel: Math.max(0, Math.min(100, venue.crowdLevel + (Math.random() - 0.5) * 20)),
          waitTime: Math.max(0, venue.waitTime + Math.floor((Math.random() - 0.5) * 10)),
          lastUpdate: 'Just now',
          confidence: Math.max(70, Math.min(100, venue.confidence + (Math.random() - 0.5) * 10))
        }))
      };
      
    // Notification cases
    case actionTypes.ADD_NOTIFICATION:
      const newNotification = {
        id: Date.now() + Math.random(),
        timestamp: Date.now(),
        ...action.payload
      };
      return {
        ...state,
        notifications: [newNotification, ...state.notifications.slice(0, 4)]
      };
      
    case actionTypes.REMOVE_NOTIFICATION:
      return {
        ...state,
        notifications: state.notifications.filter(n => n.id !== action.payload)
      };
      
    // Modal cases
    case actionTypes.SET_SHOW_RATING_MODAL:
      return { ...state, showRatingModal: action.payload };
      
    case actionTypes.SET_SHOW_REPORT_MODAL:
      return { ...state, showReportModal: action.payload };
      
    case actionTypes.SET_SHOW_SHARE_MODAL:
      return { ...state, showShareModal: action.payload };
      
    case actionTypes.SET_SHOW_USER_PROFILE_MODAL:
      return { ...state, showUserProfileModal: action.payload };
      
    case actionTypes.SET_SHARE_VENUE:
      return { ...state, shareVenue: action.payload };
      
    case actionTypes.SUBMIT_VENUE_RATING:
      return {
        ...state,
        venues: state.venues.map(venue =>
          venue.id === action.payload.venueId
            ? {
                ...venue,
                rating: ((venue.rating * venue.totalRatings) + action.payload.rating) / (venue.totalRatings + 1),
                totalRatings: venue.totalRatings + 1,
                reviews: [
                  {
                    id: `rev_${Date.now()}`,
                    user: state.userProfile?.firstName + ' ' + (state.userProfile?.lastName?.charAt(0) || '') + '.',
                    rating: action.payload.rating,
                    date: 'Just now',
                    comment: action.payload.comment,
                    helpful: 0
                  },
                  ...venue.reviews
                ]
              }
            : venue
        ),
        showRatingModal: false
      };
      
    case actionTypes.SUBMIT_VENUE_REPORT:
      return {
        ...state,
        venues: state.venues.map(venue =>
          venue.id === action.payload.venueId
            ? {
                ...venue,
                crowdLevel: action.payload.crowdLevel,
                waitTime: action.payload.waitTime,
                lastUpdate: 'Just now',
                confidence: 95,
                reports: venue.reports + 1
              }
            : venue
        ),
        showReportModal: false
      };
      
    // Registration actions
    case actionTypes.SET_REGISTRATION_STEP:
      return { ...state, registrationStep: action.payload };
      
    case actionTypes.UPDATE_REGISTRATION_DATA:
      return {
        ...state,
        registrationData: { ...state.registrationData, ...action.payload }
      };
      
    case actionTypes.CLEAR_REGISTRATION_DATA:
      return {
        ...state,
        registrationData: {},
        registrationStep: 1
      };
      
    // Email verification actions
    case actionTypes.SET_VERIFICATION_MESSAGE:
      return {
        ...state,
        verificationMessage: action.payload
      };
      
    case actionTypes.CLEAR_VERIFICATION_MESSAGE:
      return {
        ...state,
        verificationMessage: {
          show: false,
          email: '',
          type: ''
        }
      };
      
    default:
      return state;
  }
}

// Context Provider
export function AppProvider({ children }) {
  const [state, dispatch] = useReducer(appReducer, initialState);
  
  // Authentication actions
  const setUser = useCallback((user) => {
    dispatch({ type: actionTypes.SET_USER, payload: user });
  }, []);
  
  const setIsAuthenticated = useCallback((isAuth) => {
    dispatch({ type: actionTypes.SET_AUTH, payload: isAuth });
  }, []);
  
  const login = useCallback(async (credentials, rememberMe = false) => {
    dispatch({ type: actionTypes.SET_LOADING, payload: true });
    try {
      const response = await authAPI.login(
        credentials.login || credentials.email,
        credentials.password,
        rememberMe
      );
      
      if (response.success) {
        dispatch({ 
          type: actionTypes.LOGIN_SUCCESS, 
          payload: { user: response.user } 
        });
        
        // Add success notification
        dispatch({
          type: actionTypes.ADD_NOTIFICATION,
          payload: {
            type: 'success',
            message: 'Login successful! Welcome back!',
            duration: 3000
          }
        });
      } else {
        dispatch({ 
          type: actionTypes.LOGIN_FAILURE, 
          payload: response.error 
        });
      }
      
      return response;
    } catch (error) {
      const errorMessage = error.message || 'Login failed';
      dispatch({ 
        type: actionTypes.LOGIN_FAILURE, 
        payload: errorMessage 
      });
      throw error;
    } finally {
      dispatch({ type: actionTypes.SET_LOADING, payload: false });
    }
  }, []);
  
  const logout = useCallback(async () => {
    dispatch({ type: actionTypes.SET_LOADING, payload: true });
    try {
      await authAPI.logout();
      dispatch({ type: actionTypes.LOGOUT });
      
      // Add logout notification
      dispatch({
        type: actionTypes.ADD_NOTIFICATION,
        payload: {
          type: 'info',
          message: 'You have been logged out successfully.',
          duration: 3000
        }
      });
    } catch (error) {
      console.error('Logout error:', error);
      // Still logout on client side even if API call fails
      dispatch({ type: actionTypes.LOGOUT });
    } finally {
      dispatch({ type: actionTypes.SET_LOADING, payload: false });
    }
  }, []);
  
  // Action creators
  const actions = {
    // Authentication actions
    setUser,
    setIsAuthenticated,
    login,
    logout,
    
    // UI actions
    setCurrentView: useCallback((view) => {
      dispatch({ type: actionTypes.SET_CURRENT_VIEW, payload: view });
    }, []),
    
    setSearchQuery: useCallback((query) => {
      dispatch({ type: actionTypes.SET_SEARCH_QUERY, payload: query });
    }, []),
    
    setLoading: useCallback((loading) => {
      dispatch({ type: actionTypes.SET_LOADING, payload: loading });
    }, []),
    
    setError: useCallback((error) => {
      dispatch({ type: actionTypes.SET_ERROR, payload: error });
    }, []),
    
    clearError: useCallback(() => {
      dispatch({ type: actionTypes.CLEAR_ERROR });
    }, []),
    
    // Legacy user actions (kept for backward compatibility)
    setUserType: useCallback((userType) => {
      dispatch({ type: actionTypes.SET_USER_TYPE, payload: userType });
    }, []),
    
    loginUser: useCallback((userData) => {
      dispatch({ type: actionTypes.LOGIN_USER, payload: userData });
    }, []),
    
    logoutUser: useCallback(() => {
      dispatch({ type: actionTypes.LOGOUT_USER });
    }, []),
    
    // Venue actions
    setSelectedVenue: useCallback((venue) => {
      dispatch({ type: actionTypes.SET_SELECTED_VENUE, payload: venue });
    }, []),
    
    toggleVenueFollow: useCallback((venueId) => {
      dispatch({ type: actionTypes.TOGGLE_VENUE_FOLLOW, payload: venueId });
    }, []),
    
    updateVenueData: useCallback(() => {
      dispatch({ type: actionTypes.UPDATE_VENUE_DATA });
    }, []),
    
    // Notification actions
    addNotification: useCallback((notification) => {
      const id = Date.now();
      dispatch({ 
        type: actionTypes.ADD_NOTIFICATION, 
        payload: { ...notification, id } 
      });
      
      // Auto-remove notification after duration
      if (notification.duration) {
        setTimeout(() => {
          dispatch({ type: actionTypes.REMOVE_NOTIFICATION, payload: id });
        }, notification.duration);
      }
    }, []),
    
    removeNotification: useCallback((id) => {
      dispatch({ type: actionTypes.REMOVE_NOTIFICATION, payload: id });
    }, []),
    
    // Modal actions
    setShowRatingModal: useCallback((show) => {
      dispatch({ type: actionTypes.SET_SHOW_RATING_MODAL, payload: show });
    }, []),
    
    setShowReportModal: useCallback((show) => {
      dispatch({ type: actionTypes.SET_SHOW_REPORT_MODAL, payload: show });
    }, []),
    
    setShowShareModal: useCallback((show) => {
      dispatch({ type: actionTypes.SET_SHOW_SHARE_MODAL, payload: show });
    }, []),
    
    setShowUserProfileModal: useCallback((show) => {
      dispatch({ type: actionTypes.SET_SHOW_USER_PROFILE_MODAL, payload: show });
    }, []),
    
    setShareVenue: useCallback((venue) => {
      dispatch({ type: actionTypes.SET_SHARE_VENUE, payload: venue });
    }, []),
    
    submitVenueRating: useCallback((venueId, rating, comment) => {
      dispatch({
        type: actionTypes.SUBMIT_VENUE_RATING,
        payload: { venueId, rating, comment }
      });
    }, []),
    
    submitVenueReport: useCallback((venueId, crowdLevel, waitTime) => {
      dispatch({
        type: actionTypes.SUBMIT_VENUE_REPORT,
        payload: { venueId, crowdLevel, waitTime }
      });
    }, []),
    
    // Registration actions
    setRegistrationStep: useCallback((step) => {
      dispatch({ type: actionTypes.SET_REGISTRATION_STEP, payload: step });
    }, []),
    
    updateRegistrationData: useCallback((data) => {
      dispatch({ type: actionTypes.UPDATE_REGISTRATION_DATA, payload: data });
    }, []),
    
    clearRegistrationData: useCallback(() => {
      dispatch({ type: actionTypes.CLEAR_REGISTRATION_DATA });
    }, []),
    
    // Email verification actions
    setVerificationMessage: useCallback((message) => {
      dispatch({ type: actionTypes.SET_VERIFICATION_MESSAGE, payload: message });
    }, []),
    
    clearVerificationMessage: useCallback(() => {
      dispatch({ type: actionTypes.CLEAR_VERIFICATION_MESSAGE });
    }, [])
  };
  
  return (
    <AppContext.Provider value={{ state, actions }}>
      {children}
    </AppContext.Provider>
  );
}

// Custom hook to use the context
export function useApp() {
  const context = useContext(AppContext);
  if (!context) {
    throw new Error('useApp must be used within an AppProvider');
  }
  return context;
}

// Export context for testing
export { AppContext };
