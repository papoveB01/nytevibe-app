import React, { useState, useEffect } from 'react';
import { useApp } from '../../context/AppContext';
import VenueCard from '../Venue/VenueCard';
import PromotionalBanner from '../Layout/PromotionalBanner';
import { PROMOTIONAL_BANNERS } from '../../constants';

const HomeView = ({ 
  searchQuery, 
  setSearchQuery, 
  venueFilter, 
  setVenueFilter, 
  onVenueClick, 
  onVenueShare 
}) => {
  const { state } = useApp();
  const [currentBannerIndex, setCurrentBannerIndex] = useState(0);

  // Auto-rotate promotional banners
  useEffect(() => {
    const interval = setInterval(() => {
      setCurrentBannerIndex((prev) => (prev + 1) % PROMOTIONAL_BANNERS.length);
    }, 4000);

    return () => clearInterval(interval);
  }, []);

  // Filter venues based on search and filter
  const filteredVenues = state.venues.filter(venue => {
    const matchesSearch = !searchQuery || 
      venue.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
      venue.type.toLowerCase().includes(searchQuery.toLowerCase()) ||
      venue.city.toLowerCase().includes(searchQuery.toLowerCase()) ||
      venue.vibe.some(v => v.toLowerCase().includes(searchQuery.toLowerCase()));

    const matchesFilter = venueFilter === 'all' || 
      (venueFilter === 'followed' && state.userProfile.followedVenues.includes(venue.id)) ||
      (venueFilter === 'nearby' && parseFloat(venue.distance) <= 0.5) ||
      (venueFilter === 'open' && venue.isOpen) ||
      (venueFilter === 'promotions' && venue.hasPromotion);

    return matchesSearch && matchesFilter;
  });

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
      <div className="promotional-section mb-6">
        <PromotionalBanner 
          banner={PROMOTIONAL_BANNERS[currentBannerIndex]}
          onClick={() => console.log('Banner clicked')}
        />
      </div>

      {/* Filter Bar */}
      <div className="filter-bar mb-6">
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
                onClick={onVenueClick}
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
            {searchQuery && (
              <button 
                onClick={() => setSearchQuery('')}
                className="btn btn-primary mt-4"
              >
                Clear Search
              </button>
            )}
          </div>
        )}
      </div>
    </div>
  );
};

export default HomeView;
