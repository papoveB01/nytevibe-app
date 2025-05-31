import React, { useState, useEffect } from 'react';
import { useApp } from '../../context/AppContext';
import { useVenues } from '../../hooks/useVenues';
import VenueCard from '../Venue/VenueCard';
import PromotionalBanner from '../Layout/PromotionalBanner';
import { PROMOTIONAL_BANNERS, UPDATE_INTERVALS } from '../../constants';

const HomeView = ({ searchQuery, venueFilter, setVenueFilter, onVenueShare }) => {
  const { state } = useApp();
  const { getFilteredVenues } = useVenues();
  const [currentBannerIndex, setCurrentBannerIndex] = useState(0);

  // Auto-rotate promotional banners
  useEffect(() => {
    const interval = setInterval(() => {
      setCurrentBannerIndex((prev) => (prev + 1) % PROMOTIONAL_BANNERS.length);
    }, UPDATE_INTERVALS.BANNER_ROTATION);

    return () => clearInterval(interval);
  }, []);

  // Filter venues based on search and filter
  const filteredVenues = getFilteredVenues(searchQuery, venueFilter);

  const filterOptions = [
    { id: 'all', label: 'All Venues' },
    { id: 'followed', label: 'Following' },
    { id: 'nearby', label: 'Nearby' },
    { id: 'open', label: 'Open Now' },
    { id: 'promotions', label: 'Promotions' }
  ];

  return (
    <div className="home-view">
      {/* Promotional Banner */}
      <div className="promotional-section">
        <PromotionalBanner
          banner={PROMOTIONAL_BANNERS[currentBannerIndex]}
          onClick={() => console.log('Banner clicked')}
        />
      </div>

      {/* Filter Bar */}
      <div className="filter-bar">
        <div className="filter-scroll">
          {filterOptions.map((filter) => (
            <button
              key={filter.id}
              onClick={() => setVenueFilter(filter.id)}
              className={`filter-button ${venueFilter === filter.id ? 'active' : ''}`}
            >
              {filter.label}
            </button>
          ))}
        </div>
      </div>

      {/* Venues Grid */}
      <div className="venues-section">
        {filteredVenues.length > 0 ? (
          <div className="venues-grid">
            {filteredVenues.map((venue) => (
              <VenueCard
                key={venue.id}
                venue={venue}
                searchQuery={searchQuery}
                onShare={onVenueShare}
              />
            ))}
          </div>
        ) : (
          <div className="no-results">
            <h3>No venues found</h3>
            <p>
              {searchQuery
                ? `No venues match "${searchQuery}". Try a different search term.`
                : 'No venues match your current filter. Try selecting a different filter.'
              }
            </p>
          </div>
        )}
      </div>
    </div>
  );
};

export default HomeView;
