import React from 'react';
import { ArrowLeft } from 'lucide-react';
import { useApp } from '../../context/AppContext';

const VenueDetailsView = ({ onBack, onShare }) => {
  const { state } = useApp();
  const venue = state.selectedVenue;

  if (!venue) {
    return (
      <div className="venue-details-view">
        <div className="details-header">
          <button onClick={onBack} className="back-button">
            <ArrowLeft className="w-5 h-5" />
            <span>Back</span>
          </button>
          <h2>Venue Not Found</h2>
        </div>
      </div>
    );
  }

  return (
    <div className="venue-details-view">
      <div className="details-header">
        <button onClick={onBack} className="back-button">
          <ArrowLeft className="w-5 h-5" />
          <span>Back</span>
        </button>
        <h2>{venue.name}</h2>
      </div>

      <div className="details-hero">
        <div className="hero-content">
          <h1 className="venue-title">{venue.name}</h1>
          <div className="venue-subtitle">
            <span className="venue-type">{venue.type}</span>
            <span className="venue-separator">•</span>
            <span className="venue-address">{venue.address}</span>
          </div>
        </div>
      </div>

      <div className="tab-content-wrapper">
        <div className="section">
          <h4>About This Venue</h4>
          <p>Experience the best of Houston nightlife at {venue.name}. Located in {venue.city}, this {venue.type.toLowerCase()} offers {venue.vibe.join(', ').toLowerCase()} vibes.</p>
        </div>

        <div className="section">
          <h4>Current Status</h4>
          <p>Crowd Level: {venue.crowdLevel}/5</p>
          <p>Wait Time: {venue.waitTime > 0 ? `${venue.waitTime} minutes` : 'No wait'}</p>
          <p>Last Updated: {venue.lastUpdate}</p>
        </div>

        <div className="section">
          <h4>Contact Information</h4>
          <p>Address: {venue.address}</p>
          <p>Phone: {venue.phone}</p>
          <p>Hours: {venue.hours}</p>
        </div>
      </div>
    </div>
  );
};

export default VenueDetailsView;
