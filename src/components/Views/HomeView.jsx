import React, { useState, useEffect } from 'react';
import PromotionalBanner from '../Layout/PromotionalBanner';
import VenueCard from '../Venue/VenueCard';
import { useApp } from '../../context/AppContext';
import { useVenues } from '../../hooks/useVenues';
import { PROMOTIONAL_BANNERS } from '../../constants';

const HomeView = ({
  searchQuery,
  setSearchQuery,
  venueFilter,
  setVenueFilter,
  onVenueClick,
  onVenueShare
}) => {
  const { actions } = useApp();
  const { getFilteredVenues, updateVenueData } = useVenues();
  const [currentBannerIndex, setCurrentBannerIndex] = useState(0);

  // Auto-rotate promotional banners
  useEffect(() => {
    const interval = setInterval(() => {
      setCurrentBannerIndex((prev) => 
        (prev + 1) % PROMOTIONAL_BANNERS.length
      );
    }, 5000); // Change every 5 seconds

    return () => clearInterval(interval);
  }, []);

  // Auto-update venue data every 45 seconds
  useEffect(() => {
    const interval = setInterval(() => {
      updateVenueData();
    }, 45000);

    return () => clearInterval(interval);
  }, [updateVenueData]);

  const filteredVenues = getFilteredVenues(searchQuery, venueFilter);
  const currentBanner = PROMOTIONAL_BANNERS[currentBannerIndex];

  const handleBannerClick = () => {
    actions.addNotification({
      type: 'default',
      message: `🎉 ${currentBanner.title}`
    });
  };

  const filterOptions = [
    { value: 'all', label: 'All Venues', count: filteredVenues.length },
    { value: 'following', label: 'Following', count: 0 },
    { value: 'nearby', label: 'Nearby', count: 0 },
    { value: 'open', label: 'Open Now', count: 0 },
    { value: 'promotions', label: 'Promotions', count: 0 }
  ];

  return (
    <div className="home-view">
      <div className="home-content">
        {/* Promotional Banner */}
        <div className="promotional-section">
          <PromotionalBanner
            banner={currentBanner}
            onClick={handleBannerClick}
          />
          <div className="banner-indicators">
            {PROMOTIONAL_BANNERS.map((_, index) => (
              <button
                key={index}
                className={`banner-indicator ${index === currentBannerIndex ? 'active' : ''}`}
                onClick={() => setCurrentBannerIndex(index)}
              />
            ))}
          </div>
        </div>

        {/* Filter Bar */}
        <div className="filter-bar">
          <div className="filter-options">
            {filterOptions.map((option) => (
              <button
                key={option.value}
                onClick={() => setVenueFilter(option.value)}
                className={`filter-option ${venueFilter === option.value ? 'active' : ''}`}
              >
                {option.label}
                {option.value === 'all' && (
                  <span className="filter-count">({option.count})</span>
                )}
              </button>
            ))}
          </div>
        </div>

        {/* Search Results Info */}
        {searchQuery && (
          <div className="search-results-info">
            <span className="results-count">
              {filteredVenues.length} venue{filteredVenues.length !== 1 ? 's' : ''} found
            </span>
            <span className="search-query">for "{searchQuery}"</span>
            <button
              onClick={() => setSearchQuery('')}
              className="clear-search-btn"
            >
              Clear search
            </button>
          </div>
        )}

        {/* Venues Grid */}
        <div className="venues-section">
          {filteredVenues.length > 0 ? (
            <div className="venues-grid">
              {filteredVenues.map((venue) => (
                <VenueCard
                  key={venue.id}
                  venue={venue}
                  onClick={onVenueClick}
                  onShare={onVenueShare}
                  searchQuery={searchQuery}
                />
              ))}
            </div>
          ) : (
            <div className="no-venues">
              <div className="no-venues-icon">🔍</div>
              <h3 className="no-venues-title">No venues found</h3>
              <p className="no-venues-message">
                {searchQuery
                  ? `No venues match "${searchQuery}". Try adjusting your search.`
                  : 'No venues match the current filter. Try selecting a different filter.'
                }
              </p>
              {searchQuery && (
                <button
                  onClick={() => setSearchQuery('')}
                  className="clear-search-btn"
                >
                  Clear search
                </button>
              )}
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

export default HomeView;
