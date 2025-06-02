import React, { useEffect, useCallback } from 'react';
import { AppProvider, useApp } from './context/AppContext';
import Header from './components/Layout/Header';
import HomeView from './components/Views/HomeView';
import VenueDetailsView from './components/Views/VenueDetailsView';
import RegistrationView from './components/Views/RegistrationView';
import ShareModal from './components/Social/ShareModal';
import RatingModal from './components/Venue/RatingModal';
import ReportModal from './components/Venue/ReportModal';
import UserProfileModal from './components/User/UserProfileModal';
import './App.css';

function AppContent() {
  const { state, actions } = useApp();
  const { 
    currentView, 
    selectedVenue, 
    searchQuery, 
    activeFilter,
    showShareModal,
    showRatingModal,
    showReportModal,
    showUserProfileModal
  } = state;

  // Auto-update venue data every 45 seconds
  const updateVenueData = useCallback(() => {
    actions.updateVenueData();
  }, [actions]);

  useEffect(() => {
    const interval = setInterval(updateVenueData, 45000);
    return () => clearInterval(interval);
  }, [updateVenueData]);

  // Filter venues based on search query and active filter
  const filteredVenues = state.venues.filter(venue => {
    const matchesSearch = !searchQuery || 
      venue.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
      venue.type.toLowerCase().includes(searchQuery.toLowerCase()) ||
      venue.address.toLowerCase().includes(searchQuery.toLowerCase()) ||
      venue.vibe.some(v => v.toLowerCase().includes(searchQuery.toLowerCase()));

    const matchesFilter = activeFilter === 'all' || 
      (activeFilter === 'bars' && venue.type.toLowerCase().includes('bar')) ||
      (activeFilter === 'clubs' && (venue.type.toLowerCase().includes('club') || venue.type.toLowerCase().includes('dance'))) ||
      (activeFilter === 'lounges' && venue.type.toLowerCase().includes('lounge')) ||
      (activeFilter === 'promotions' && venue.hasPromotion);

    return matchesSearch && matchesFilter;
  });

  // Event Handlers
  const handleViewVenueDetails = (venue) => {
    actions.setSelectedVenue(venue);
    actions.setCurrentView('details');
    actions.addNotification({
      type: 'default',
      message: `📍 Viewing details for ${venue.name}`
    });
  };

  const handleBackToHome = () => {
    actions.setCurrentView('home');
    actions.setSelectedVenue(null);
  };

  const handleShare = (venue) => {
    actions.setShareVenue(venue);
    actions.setShowShareModal(true);
  };

  const handleSearchChange = (query) => {
    actions.setSearchQuery(query);
  };

  const handleClearSearch = () => {
    actions.setSearchQuery('');
    actions.setActiveFilter('all');
    actions.addNotification({
      type: 'success',
      message: '🔍 Search cleared - showing all venues'
    });
  };

  const handleFilterChange = (filter) => {
    actions.setActiveFilter(filter);
  };

  // Registration handlers
  const handleShowRegistration = () => {
    actions.setCurrentView('registration');
  };

  const handleRegistrationSuccess = (userData) => {
    console.log('✅ Registration successful, user data:', userData);
    
    // Register user in context
    actions.registerUser(userData);
    
    // Show success notification
    actions.addNotification({
      type: 'success',
      message: `🎉 Welcome to nYtevibe, ${userData.firstName || userData.first_name}! Registration successful.`,
      duration: 5000
    });
    
    // Navigate to home
    actions.setCurrentView('home');
  };

  const handleBackFromRegistration = () => {
    actions.setCurrentView('home');
  };

  // Auto-rotate promotional banners
  useEffect(() => {
    const interval = setInterval(() => {
      const nextIndex = (state.activeBannerIndex + 1) % state.banners.length;
      actions.setActiveBanner(nextIndex);
    }, 5000);

    return () => clearInterval(interval);
  }, [state.activeBannerIndex, state.banners.length, actions]);

  return (
    <div className="app-layout">
      {/* Header - Show on home and details views */}
      {currentView !== 'registration' && (
        <Header
          searchQuery={searchQuery}
          setSearchQuery={handleSearchChange}
          onClearSearch={handleClearSearch}
          activeFilter={activeFilter}
          onFilterChange={handleFilterChange}
          onShowRegistration={handleShowRegistration}
        />
      )}

      {/* Main Content */}
      <main className="main-content">
        {currentView === 'home' && (
          <HomeView
            venues={filteredVenues}
            searchQuery={searchQuery}
            onViewDetails={handleViewVenueDetails}
            onShare={handleShare}
          />
        )}

        {currentView === 'details' && (
          <VenueDetailsView
            venue={selectedVenue}
            onBack={handleBackToHome}
            onShare={handleShare}
          />
        )}

        {currentView === 'registration' && (
          <RegistrationView
            onBack={handleBackFromRegistration}
            onRegistrationSuccess={handleRegistrationSuccess}
          />
        )}
      </main>

      {/* Modals */}
      {showShareModal && <ShareModal />}
      {showRatingModal && <RatingModal />}
      {showReportModal && <ReportModal />}
      {showUserProfileModal && <UserProfileModal />}
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
