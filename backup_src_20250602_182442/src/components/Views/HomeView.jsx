import React from 'react';
import { useApp } from '../../context/AppContext';

const HomeView = ({ searchQuery, setSearchQuery, venueFilter, setVenueFilter, onVenueClick, onVenueShare }) => {
  const { state } = useApp();

  return (
    <div className="home-view">
      <div className="home-content">
        <div className="promotional-section">
          <div className="promotional-banner" style={{background: 'rgba(59, 130, 246, 0.9)', borderColor: '#3b82f6'}}>
            <div className="banner-content">
              <div className="banner-text">
                <div className="banner-title" style={{color: '#ffffff'}}>
                  Welcome to nYtevibe!
                </div>
                <div className="banner-subtitle" style={{color: '#ffffff'}}>
                  Discover Houston's best nightlife venues
                </div>
              </div>
            </div>
          </div>
        </div>

        <div className="venues-section">
          <div className="venues-grid">
            {state.venues.map((venue) => (
              <div key={venue.id} className="venue-card-container" onClick={() => onVenueClick(venue)}>
                <div className="venue-card-header-fixed">
                  <div className="venue-info-section">
                    <div className="venue-title-row">
                      <h3 className="venue-name">{venue.name}</h3>
                    </div>
                    <div className="venue-location-row">
                      <span className="location-text">{venue.type} • {venue.distance}</span>
                    </div>
                    <div className="venue-address">{venue.city}, {venue.postcode}</div>
                  </div>
                </div>
                
                <div className="venue-status-section">
                  <div className="status-items">
                    <div className="status-item">
                      <span className="status-text">
                        {venue.waitTime > 0 ? `${venue.waitTime} min wait` : 'No wait'}
                      </span>
                    </div>
                  </div>
                  <span className="last-update">{venue.lastUpdate}</span>
                </div>

                <div className="venue-vibe-section">
                  {venue.vibe.slice(0, 3).map((tag, index) => (
                    <span key={index} className="badge badge-blue">
                      {tag}
                    </span>
                  ))}
                </div>

                <div className="venue-action-buttons-single">
                  <button className="details-btn-full">
                    View Details
                  </button>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
};

export default HomeView;
