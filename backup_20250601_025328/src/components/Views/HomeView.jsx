import React, { useState, useEffect } from 'react';
import VenueCard from '../Venue/VenueCard';
import PromotionalBanner from '../Layout/PromotionalBanner';
import { useVenues } from '../../hooks/useVenues';
import { useApp } from '../../context/AppContext';
import { PROMOTIONAL_BANNERS } from '../../constants';

const HomeView = ({
  searchQuery,
  setSearchQuery,
  venueFilter,
  setVenueFilter,
  onVenueClick,
  onVenueShare
}) => {
  const { getFilteredVenues, updateVenueData } = useVenues();
  const { actions } = useApp();
  const [currentBannerIndex, setCurrentBannerIndex] = useState(0);

  // Auto-rotate promotional banners
  useEffect(() => {
    const interval = setInterval(() => {
      setCurrentBannerIndex((prev) => 
        (prev + 1) % PROMOTIONAL_BANNERS.length
      );
    }, 5000); // 5 seconds

    return () => clearInterval(interval);
  }, []);

  // Auto-update venue data
  useEffect(() => {
    const interval = setInterval(() => {
      updateVenueData();
    }, 45000); // 45 seconds

    return () => clearInterval(interval);
  }, [updateVenueData]);

  const filteredVenues = getFilteredVenues(searchQuery, venueFilter);
  const currentBanner = PROMOTIONAL_BANNERS[currentBannerIndex];

  const filterOptions = [
    { value: 'all', label: 'All Venues', count: filteredVenues.length },
    { value: 'following', label: 'Following', count: null },
    { value: 'nearby', label: 'Nearby', count: null },
    { value: 'open', label: 'Open Now', count: null },
    { value: 'promotions', label: 'Promotions', count: null }
  ];

  const handleBannerClick = () => {
    if (currentBanner.venue) {
      actions.addNotification({
        type: 'default',
        message: `🎯 Showing ${currentBanner.venue} promotion details...`
      });
    } else {
      actions.addNotification({
        type: 'default',
        message: `💡 ${currentBanner.title}`
      });
    }
  };

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
          <div className="filter-buttons">
            {filterOptions.map((option) => (
              <button
                key={option.value}
                onClick={() => setVenueFilter(option.value)}
                className={`filter-button ${venueFilter === option.value ? 'active' : ''}`}
              >
                {option.label}
                {option.count !== null && (
                  <span className="filter-count">({option.count})</span>
                )}
              </button>
            ))}
          </div>
        </div>

        {/* Search Results Info */}
        {searchQuery && (
          <div className="search-results-info">
            <span className="results-text">
              {filteredVenues.length} result{filteredVenues.length !== 1 ? 's' : ''} for "{searchQuery}"
            </span>
            {filteredVenues.length > 0 && (
              <button
                onClick={() => setSearchQuery('')}
                className="clear-search-button"
              >
                Clear search
              </button>
            )}
          </div>
        )}

        {/* Venues List */}
        <div className="venues-section">
          {filteredVenues.length > 0 ? (
            <div className="venues-list">
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
            <div className="no-results">
              <div className="no-results-content">
                <span className="no-results-icon">🔍</span>
                <h3 className="no-results-title">No venues found</h3>
                <p className="no-results-message">
                  {searchQuery
                    ? `No venues match "${searchQuery}". Try a different search term.`
                    : 'No venues match the current filter. Try selecting a different filter.'}
                </p>
                {(searchQuery || venueFilter !== 'all') && (
                  <button
                    onClick={() => {
                      setSearchQuery('');
                      setVenueFilter('all');
                    }}
                    className="reset-filters-button"
                  >
                    Show All Venues
                  </button>
                )}
              </div>
            </div>
          )}
        </div>

        {/* Footer */}
        <div className="home-footer">
          <p className="footer-text">
            Showing {filteredVenues.length} of {getFilteredVenues('', 'all').length} venues in Houston
          </p>
          <p className="footer-update">
            Data updates every 45 seconds • Last update: Just now
          </p>
        </div>
      </div>
    </div>
  );
};

export default HomeView;
