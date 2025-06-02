import React from 'react';
import VenueCard from './VenueCard';

const VenueList = ({ venues, searchQuery, onVenueClick, onShare }) => {
  if (!venues || venues.length === 0) {
    return (
      <div className="empty-state">
        <div className="empty-state-content">
          <h3>No venues found</h3>
          <p>Try adjusting your search or filters to find venues.</p>
        </div>
      </div>
    );
  }

  return (
    <div className="venue-list">
      <div className="venues-grid">
        {venues.map((venue) => (
          <VenueCard
            key={venue.id}
            venue={venue}
            searchQuery={searchQuery}
            onClick={onVenueClick}
            onShare={onShare}
          />
        ))}
      </div>
    </div>
  );
};

export default VenueList;
