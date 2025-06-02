import React from 'react';
import { useApp } from '../../context/AppContext';
import PromotionalBanner from '../Layout/PromotionalBanner';
import VenueCard from '../Venue/VenueCard';

const HomeView = () => {
  const { state, actions } = useApp();

  // Safe data extraction with fallbacks
  const venues = state?.venues || [];
  const searchQuery = state?.searchQuery || '';
  const activeFilter = state?.activeFilter || 'all';

  const handleVenueSelect = (venue) => {
    if (venue && venue.id) {
      actions.setSelectedVenue(venue);
      actions.setCurrentView('details');
    }
  };

  // Filter venues safely
  const getFilteredVenues = () => {
    try {
      let filtered = venues;

      // Apply search filter
      if (searchQuery && searchQuery.trim()) {
        const query = searchQuery.toLowerCase().trim();
        filtered = filtered.filter(venue => {
          const name = venue?.name || '';
          const type = venue?.type || '';
          const address = venue?.address || '';
          const vibe = venue?.vibe || [];
          
          return (
            name.toLowerCase().includes(query) ||
            type.toLowerCase().includes(query) ||
            address.toLowerCase().includes(query) ||
            (Array.isArray(vibe) && vibe.some(v => 
              typeof v === 'string' && v.toLowerCase().includes(query)
            ))
          );
        });
      }

      // Apply category filter
      if (activeFilter && activeFilter !== 'all') {
        filtered = filtered.filter(venue => {
          const type = venue?.type || '';
          const hasPromotion = venue?.hasPromotion || false;
          
          switch (activeFilter) {
            case 'bars':
              return type.toLowerCase().includes('bar');
            case 'clubs':
              return type.toLowerCase().includes('club');
            case 'lounges':
              return type.toLowerCase().includes('lounge');
            case 'promotions':
              return hasPromotion;
            default:
              return true;
          }
        });
      }

      return filtered;
    } catch (error) {
      console.error('Error filtering venues:', error);
      return venues;
    }
  };

  const filteredVenues = getFilteredVenues();

  return (
    <div className="home-view">
      {/* Promotional Banner */}
      <PromotionalBanner />

      {/* Search Results Info */}
      {searchQuery && searchQuery.trim() && (
        <div className="search-results-info">
          <p className="search-results-text">
            {filteredVenues.length} venue{filteredVenues.length !== 1 ? 's' : ''} found for "{searchQuery}"
          </p>
          {filteredVenues.length === 0 && (
            <p className="no-results-text">
              Try adjusting your search or browse all venues below.
            </p>
          )}
        </div>
      )}

      {/* Venues Grid */}
      <div className="venues-section">
        <div className="venues-grid">
          {filteredVenues.length > 0 ? (
            filteredVenues.map(venue => (
              <VenueCard
                key={venue?.id || Math.random()}
                venue={venue}
                onSelect={handleVenueSelect}
              />
            ))
          ) : !searchQuery ? (
            <div className="no-venues-message">
              <h3>No venues available</h3>
              <p>Check back soon for Houston's hottest venues!</p>
            </div>
          ) : null}
        </div>
      </div>
    </div>
  );
};

export default HomeView;
