import React, { createContext, useContext, useReducer, useCallback } from 'react';

// Initial state
const initialState = {
  // View Management
  currentView: 'home', // 'home' | 'details' | 'registration'
  selectedVenue: null,
  
  // Modal States
  showShareModal: false,
  showRatingModal: false,
  showReportModal: false,
  showUserProfileModal: false,
  shareVenue: null,
  
  // User Data
  isAuthenticated: false,
  authenticatedUser: null,
  userProfile: {
    id: 'usr_demo',
    firstName: 'Demo',
    lastName: 'User',
    username: 'demouser',
    email: 'demo@nytevibe.com',
    level: 3,
    points: 2847,
    badges: ['Explorer', 'Reviewer', 'Early Adopter'],
    followedVenues: ['venue_1', 'venue_3', 'venue_7'],
    totalReports: 12,
    totalRatings: 8,
    joinDate: '2024-03-15'
  },
  
  // App Data
  venues: [
    {
      id: 'venue_1',
      name: 'Skyline Rooftop',
      type: 'Rooftop Bar',
      address: '1200 McKinney St, Houston, TX',
      rating: 4.2,
      totalRatings: 45,
      crowdLevel: 3,
      waitTime: 15,
      lastUpdate: '10 minutes ago',
      confidence: 85,
      followersCount: 230,
      reports: 24,
      hours: 'Open until 2:00 AM',
      phone: '+1 (713) 555-0123',
      vibe: ['Upscale', 'City Views', 'Cocktails', 'Date Night'],
      hasPromotion: true,
      promotionText: '🍹 Happy Hour: 5-7 PM - Half price cocktails!',
      reviews: [
        {
          id: 'rev_1',
          user: 'Sarah M.',
          rating: 5,
          comment: 'Amazing views and great cocktails! Perfect for date night.',
          date: '2 days ago',
          helpful: 12
        },
        {
          id: 'rev_2',
          user: 'Mike R.',
          rating: 4,
          comment: 'Great atmosphere but can get crowded on weekends.',
          date: '1 week ago',
          helpful: 8
        }
      ]
    },
    {
      id: 'venue_2',
      name: 'Underground Lounge',
      type: 'Cocktail Lounge',
      address: '815 Walker St, Houston, TX',
      rating: 4.7,
      totalRatings: 89,
      crowdLevel: 2,
      waitTime: 5,
      lastUpdate: '5 minutes ago',
      confidence: 92,
      followersCount: 445,
      reports: 36,
      hours: 'Open until 1:00 AM',
      phone: '+1 (713) 555-0124',
      vibe: ['Intimate', 'Craft Cocktails', 'Jazz Music', 'Speakeasy'],
      hasPromotion: false,
      reviews: [
        {
          id: 'rev_3',
          user: 'Emma T.',
          rating: 5,
          comment: 'Hidden gem! Amazing craft cocktails and intimate atmosphere.',
          date: '3 days ago',
          helpful: 15
        }
      ]
    },
    {
      id: 'venue_3',
      name: 'Beat Street Dance Club',
      type: 'Dance Club',
      address: '2120 Walker St, Houston, TX',
      rating: 4.1,
      totalRatings: 127,
      crowdLevel: 4,
      waitTime: 25,
      lastUpdate: '2 minutes ago',
      confidence: 78,
      followersCount: 892,
      reports: 52,
      hours: 'Open until 3:00 AM',
      phone: '+1 (713) 555-0125',
      vibe: ['High Energy', 'EDM', 'Dancing', 'Young Crowd'],
      hasPromotion: true,
      promotionText: '🎵 Ladies Night: Friday - No cover for ladies before 11 PM',
      reviews: [
        {
          id: 'rev_4',
          user: 'Carlos D.',
          rating: 4,
          comment: 'Great music and energy! Gets very packed though.',
          date: '1 day ago',
          helpful: 6
        }
      ]
    },
    {
      id: 'venue_4',
      name: 'The Local Tavern',
      type: 'Sports Bar',
      address: '3421 Smith St, Houston, TX',
      rating: 3.8,
      totalRatings: 203,
      crowdLevel: 2,
      waitTime: 0,
      lastUpdate: '15 minutes ago',
      confidence: 89,
      followersCount: 156,
      reports: 41,
      hours: 'Open until 12:00 AM',
      phone: '+1 (713) 555-0126',
      vibe: ['Casual', 'Sports', 'Beer', 'Wings'],
      hasPromotion: false,
      reviews: [
        {
          id: 'rev_5',
          user: 'Tom W.',
          rating: 4,
          comment: 'Good spot to watch the game with friends. Great wings!',
          date: '4 days ago',
          helpful: 9
        }
      ]
    },
    {
      id: 'venue_5',
      name: 'Neon Nights',
      type: 'Nightclub',
      address: '1515 Texas Ave, Houston, TX',
      rating: 4.5,
      totalRatings: 78,
      crowdLevel: 3,
      waitTime: 10,
      lastUpdate: '8 minutes ago',
      confidence: 91,
      followersCount: 667,
      reports: 29,
      hours: 'Open until 4:00 AM',
      phone: '+1 (713) 555-0127',
      vibe: ['Trendy', 'Hip Hop', 'VIP Service', 'Late Night'],
      hasPromotion: true,
      promotionText: '🎉 Weekend Special: Bottle service packages 20% off',
      reviews: [
        {
          id: 'rev_6',
          user: 'Jessica L.',
          rating: 5,
          comment: 'Best nightclub in Houston! Amazing music and VIP service.',
          date: '2 days ago',
          helpful: 18
        }
      ]
    },
    {
      id: 'venue_6',
      name: 'Bourbon & Blues',
      type: 'Live Music Bar',
      address: '920 Main St, Houston, TX',
      rating: 4.3,
      totalRatings: 156,
      crowdLevel: 1,
      waitTime: 0,
      lastUpdate: '12 minutes ago',
      confidence: 94,
      followersCount: 324,
      reports: 38,
      hours: 'Open until 1:00 AM',
      phone: '+1 (713) 555-0128',
      vibe: ['Live Music', 'Blues', 'Whiskey', 'Mature Crowd'],
      hasPromotion: false,
      reviews: [
        {
          id: 'rev_7',
          user: 'Robert K.',
          rating: 4,
          comment: 'Excellent live music and great selection of bourbon.',
          date: '5 days ago',
          helpful: 11
        }
      ]
    }
  ],
  
  // Search and Filter
  searchQuery: '',
  activeFilter: 'all',
  
  // Notifications
  notifications: [],
  
  // Promotional Banners
  banners: [
    {
      id: 'banner_1',
      type: 'summer',
      icon: '🌞',
      title: 'Summer Rooftop Season',
      subtitle: 'Discover Houston\'s best rooftop bars and lounges',
      active: true
    },
    {
      id: 'banner_2',
      type: 'weekend',
      icon: '🎉',
      title: 'Weekend Party Guide',
      subtitle: 'Find the hottest weekend spots and events',
      active: false
    },
    {
      id: 'banner_3',
      type: 'happy-hour',
      icon: '🍸',
      title: 'Happy Hour Deals',
      subtitle: 'Best drink specials across the city',
      active: false
    }
  ],
  activeBannerIndex: 0,
  
  // System
  lastDataUpdate: new Date().toLocaleTimeString()
};

// Action types
const actionTypes = {
  // View Management
  SET_CURRENT_VIEW: 'SET_CURRENT_VIEW',
  SET_SELECTED_VENUE: 'SET_SELECTED_VENUE',
  
  // Modal Management
  SET_SHOW_SHARE_MODAL: 'SET_SHOW_SHARE_MODAL',
  SET_SHOW_RATING_MODAL: 'SET_SHOW_RATING_MODAL',
  SET_SHOW_REPORT_MODAL: 'SET_SHOW_REPORT_MODAL',
  SET_SHOW_USER_PROFILE_MODAL: 'SET_SHOW_USER_PROFILE_MODAL',
  SET_SHARE_VENUE: 'SET_SHARE_VENUE',
  
  // Authentication
  LOGIN_SUCCESS: 'LOGIN_SUCCESS',
  LOGOUT: 'LOGOUT',
  REGISTER_SUCCESS: 'REGISTER_SUCCESS',
  
  // User Actions
  FOLLOW_VENUE: 'FOLLOW_VENUE',
  UNFOLLOW_VENUE: 'UNFOLLOW_VENUE',
  RATE_VENUE: 'RATE_VENUE',
  REPORT_VENUE: 'REPORT_VENUE',
  
  // Search and Filter
  SET_SEARCH_QUERY: 'SET_SEARCH_QUERY',
  SET_ACTIVE_FILTER: 'SET_ACTIVE_FILTER',
  
  // Notifications
  ADD_NOTIFICATION: 'ADD_NOTIFICATION',
  REMOVE_NOTIFICATION: 'REMOVE_NOTIFICATION',
  
  // Banners
  SET_ACTIVE_BANNER: 'SET_ACTIVE_BANNER',
  
  // Data Management
  UPDATE_VENUE_DATA: 'UPDATE_VENUE_DATA',
  RESET_USER_DATA: 'RESET_USER_DATA'
};

// Reducer
const appReducer = (state, action) => {
  console.log('🔄 Context Action:', action.type, action.payload);
  
  switch (action.type) {
    // View Management
    case actionTypes.SET_CURRENT_VIEW:
      return { ...state, currentView: action.payload };
      
    case actionTypes.SET_SELECTED_VENUE:
      return { ...state, selectedVenue: action.payload };
    
    // Modal Management
    case actionTypes.SET_SHOW_SHARE_MODAL:
      return { ...state, showShareModal: action.payload };
      
    case actionTypes.SET_SHOW_RATING_MODAL:
      return { ...state, showRatingModal: action.payload };
      
    case actionTypes.SET_SHOW_REPORT_MODAL:
      return { ...state, showReportModal: action.payload };
      
    case actionTypes.SET_SHOW_USER_PROFILE_MODAL:
      return { ...state, showUserProfileModal: action.payload };
      
    case actionTypes.SET_SHARE_VENUE:
      return { ...state, shareVenue: action.payload };
    
    // Authentication
    case actionTypes.LOGIN_SUCCESS:
      return {
        ...state,
        isAuthenticated: true,
        authenticatedUser: action.payload,
        currentView: 'home'
      };
      
    case actionTypes.LOGOUT:
      return {
        ...state,
        isAuthenticated: false,
        authenticatedUser: null,
        currentView: 'home'
      };
      
    case actionTypes.REGISTER_SUCCESS:
      return {
        ...state,
        isAuthenticated: true,
        authenticatedUser: action.payload,
        currentView: 'home'
      };
    
    // User Actions
    case actionTypes.FOLLOW_VENUE:
      return {
        ...state,
        userProfile: {
          ...state.userProfile,
          followedVenues: [...state.userProfile.followedVenues, action.payload]
        },
        venues: state.venues.map(venue => 
          venue.id === action.payload 
            ? { ...venue, followersCount: venue.followersCount + 1 }
            : venue
        )
      };
      
    case actionTypes.UNFOLLOW_VENUE:
      return {
        ...state,
        userProfile: {
          ...state.userProfile,
          followedVenues: state.userProfile.followedVenues.filter(id => id !== action.payload)
        },
        venues: state.venues.map(venue => 
          venue.id === action.payload 
            ? { ...venue, followersCount: Math.max(0, venue.followersCount - 1) }
            : venue
        )
      };
      
    case actionTypes.RATE_VENUE:
      const { venueId, rating, comment } = action.payload;
      return {
        ...state,
        venues: state.venues.map(venue => {
          if (venue.id === venueId) {
            const newReview = {
              id: `rev_${Date.now()}`,
              user: `${state.userProfile.firstName} ${state.userProfile.lastName.charAt(0)}.`,
              rating,
              comment,
              date: 'Just now',
              helpful: 0
            };
            const newReviews = [newReview, ...(venue.reviews || [])];
            const newTotalRatings = venue.totalRatings + 1;
            const newAverageRating = ((venue.rating * venue.totalRatings) + rating) / newTotalRatings;
            
            return {
              ...venue,
              rating: Math.round(newAverageRating * 10) / 10,
              totalRatings: newTotalRatings,
              reviews: newReviews
            };
          }
          return venue;
        }),
        userProfile: {
          ...state.userProfile,
          totalRatings: state.userProfile.totalRatings + 1,
          points: state.userProfile.points + 10
        }
      };
      
    case actionTypes.REPORT_VENUE:
      const { venueId: reportVenueId, crowdLevel, waitTime: reportWaitTime } = action.payload;
      return {
        ...state,
        venues: state.venues.map(venue => 
          venue.id === reportVenueId 
            ? { 
                ...venue, 
                crowdLevel, 
                waitTime: reportWaitTime || 0,
                lastUpdate: 'Just now',
                reports: venue.reports + 1,
                confidence: Math.min(95, venue.confidence + 2)
              }
            : venue
        ),
        userProfile: {
          ...state.userProfile,
          totalReports: state.userProfile.totalReports + 1,
          points: state.userProfile.points + 5
        }
      };
    
    // Search and Filter
    case actionTypes.SET_SEARCH_QUERY:
      return { ...state, searchQuery: action.payload };
      
    case actionTypes.SET_ACTIVE_FILTER:
      return { ...state, activeFilter: action.payload };
    
    // Notifications
    case actionTypes.ADD_NOTIFICATION:
      const newNotification = {
        id: `notif_${Date.now()}`,
        timestamp: new Date().toISOString(),
        ...action.payload
      };
      return {
        ...state,
        notifications: [newNotification, ...state.notifications.slice(0, 4)]
      };
      
    case actionTypes.REMOVE_NOTIFICATION:
      return {
        ...state,
        notifications: state.notifications.filter(notif => notif.id !== action.payload)
      };
    
    // Banners
    case actionTypes.SET_ACTIVE_BANNER:
      return {
        ...state,
        activeBannerIndex: action.payload,
        banners: state.banners.map((banner, index) => ({
          ...banner,
          active: index === action.payload
        }))
      };
    
    // Data Management
    case actionTypes.UPDATE_VENUE_DATA:
      return {
        ...state,
        venues: state.venues.map(venue => ({
          ...venue,
          lastUpdate: new Date().toLocaleTimeString(),
          confidence: Math.max(70, Math.min(95, venue.confidence + (Math.random() > 0.5 ? 1 : -1)))
        })),
        lastDataUpdate: new Date().toLocaleTimeString()
      };
      
    case actionTypes.RESET_USER_DATA:
      return {
        ...state,
        userProfile: initialState.userProfile,
        searchQuery: '',
        activeFilter: 'all',
        notifications: []
      };
    
    default:
      console.warn('Unknown action type:', action.type);
      return state;
  }
};

// Create context
const AppContext = createContext();

// Context provider component
export const AppProvider = ({ children }) => {
  const [state, dispatch] = useReducer(appReducer, initialState);
  
  // Action creators
  const actions = {
    // View Management
    setCurrentView: useCallback((view) => {
      dispatch({ type: actionTypes.SET_CURRENT_VIEW, payload: view });
    }, []),
    
    setSelectedVenue: useCallback((venue) => {
      dispatch({ type: actionTypes.SET_SELECTED_VENUE, payload: venue });
    }, []),
    
    // Modal Management
    setShowShareModal: useCallback((show) => {
      dispatch({ type: actionTypes.SET_SHOW_SHARE_MODAL, payload: show });
    }, []),
    
    setShowRatingModal: useCallback((show) => {
      dispatch({ type: actionTypes.SET_SHOW_RATING_MODAL, payload: show });
    }, []),
    
    setShowReportModal: useCallback((show) => {
      dispatch({ type: actionTypes.SET_SHOW_REPORT_MODAL, payload: show });
    }, []),
    
    setShowUserProfileModal: useCallback((show) => {
      dispatch({ type: actionTypes.SET_SHOW_USER_PROFILE_MODAL, payload: show });
    }, []),
    
    setShareVenue: useCallback((venue) => {
      dispatch({ type: actionTypes.SET_SHARE_VENUE, payload: venue });
    }, []),
    
    // Authentication
    loginUser: useCallback((userData) => {
      dispatch({ type: actionTypes.LOGIN_SUCCESS, payload: userData });
    }, []),
    
    logoutUser: useCallback(() => {
      dispatch({ type: actionTypes.LOGOUT });
    }, []),
    
    registerUser: useCallback((userData) => {
      dispatch({ type: actionTypes.REGISTER_SUCCESS, payload: userData });
    }, []),
    
    // User Actions
    followVenue: useCallback((venueId) => {
      dispatch({ type: actionTypes.FOLLOW_VENUE, payload: venueId });
    }, []),
    
    unfollowVenue: useCallback((venueId) => {
      dispatch({ type: actionTypes.UNFOLLOW_VENUE, payload: venueId });
    }, []),
    
    rateVenue: useCallback((venueId, rating, comment) => {
      dispatch({ type: actionTypes.RATE_VENUE, payload: { venueId, rating, comment } });
    }, []),
    
    reportVenue: useCallback((venueId, crowdLevel, waitTime, comments) => {
      dispatch({ type: actionTypes.REPORT_VENUE, payload: { venueId, crowdLevel, waitTime, comments } });
    }, []),
    
    // Search and Filter
    setSearchQuery: useCallback((query) => {
      dispatch({ type: actionTypes.SET_SEARCH_QUERY, payload: query });
    }, []),
    
    setActiveFilter: useCallback((filter) => {
      dispatch({ type: actionTypes.SET_ACTIVE_FILTER, payload: filter });
    }, []),
    
    // Notifications
    addNotification: useCallback((notification) => {
      dispatch({ type: actionTypes.ADD_NOTIFICATION, payload: notification });
    }, []),
    
    removeNotification: useCallback((notificationId) => {
      dispatch({ type: actionTypes.REMOVE_NOTIFICATION, payload: notificationId });
    }, []),
    
    // Banners
    setActiveBanner: useCallback((bannerIndex) => {
      dispatch({ type: actionTypes.SET_ACTIVE_BANNER, payload: bannerIndex });
    }, []),
    
    // Data Management
    updateVenueData: useCallback(() => {
      dispatch({ type: actionTypes.UPDATE_VENUE_DATA });
    }, []),
    
    resetUserData: useCallback(() => {
      dispatch({ type: actionTypes.RESET_USER_DATA });
    }, [])
  };
  
  const contextValue = {
    state,
    actions,
    dispatch
  };
  
  return (
    <AppContext.Provider value={contextValue}>
      {children}
    </AppContext.Provider>
  );
};

// Custom hook to use the context
export const useApp = () => {
  const context = useContext(AppContext);
  if (!context) {
    throw new Error('useApp must be used within an AppProvider');
  }
  return context;
};

export default AppContext;
