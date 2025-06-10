  const actions = {
    // New setView action for navigation
    setView: useCallback((view) => {
      console.log('🎯 AppContext: Setting view to:', view);
      dispatch({ type: actionTypes.SET_CURRENT_VIEW, payload: view });
    }, []),
    
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
      console.log('🎯 AppContext: Legacy loginUser called');
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
    }, []),
    
    // Helper action for initialization
    setInitialized: useCallback(() => {
      dispatch({ type: actionTypes.SET_LOADING, payload: false });
    }, [])
  };
