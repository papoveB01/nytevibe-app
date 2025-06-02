import React from 'react';
import { MapPin, Clock, Users, Star, TrendingUp, Heart, Phone } from 'lucide-react';
import { useApp } from '../../context/AppContext';
import { getCrowdLabel, getCrowdColor } from '../../utils/helpers';
import StarRating from './StarRating';
import FollowButton from '../Follow/FollowButton';

const VenueCard = ({ venue, onClick, mobileLayout = false }) => {
  const { actions } = useApp();

  const handleDetailsClick = () => {
    actions.setSelectedVenue(venue);
    onClick?.(venue);
  };

  const handleQuickCall = (e) => {
    e.stopPropagation();
    window.open(`tel:${venue.phone}`);
  };

  if (mobileLayout) {
    return (
      <div className="mobile-venue-card" onClick={handleDetailsClick}>
        {/* Venue Header */}
        <div className="mobile-venue-header">
          <div className="mobile-venue-info">
            <h3 className="mobile-venue-name">{venue.name}</h3>
            <div className="mobile-venue-meta">
              <span className="mobile-venue-type">{venue.type}</span>
              <span className="mobile-venue-dot">•</span>
              <div className="mobile-venue-rating">
                <Star className="mobile-rating-star" />
                <span>{venue.rating.toFixed(1)}</span>
              </div>
            </div>
          </div>
          
          <div className="mobile-venue-actions">
            <FollowButton venue={venue} size="sm" />
            <button 
              className="mobile-quick-call"
              onClick={handleQuickCall}
              title="Quick call"
            >
              <Phone className="w-4 h-4" />
            </button>
          </div>
        </div>

        {/* Status Row */}
        <div className="mobile-status-row">
          <div className={`mobile-status-item crowd ${getCrowdColor(venue.crowdLevel).split(' ')[0]}`}>
            <Users className="mobile-status-icon" />
            <span className="mobile-status-text">{getCrowdLabel(venue.crowdLevel)}</span>
          </div>
          
          <div className="mobile-status-item wait">
            <Clock className="mobile-status-icon" />
            <span className="mobile-status-text">
              {venue.waitTime > 0 ? `${venue.waitTime}m wait` : 'No wait'}
            </span>
          </div>
          
          <div className="mobile-status-update">
            {venue.lastUpdate}
          </div>
        </div>

        {/* Vibe Tags */}
        <div className="mobile-vibe-tags">
          {venue.vibe.slice(0, 3).map((tag, index) => (
            <span key={index} className="mobile-vibe-tag">
              {tag}
            </span>
          ))}
          {venue.vibe.length > 3 && (
            <span className="mobile-vibe-tag more">+{venue.vibe.length - 3}</span>
          )}
        </div>

        {/* Promotion Banner */}
        {venue.hasPromotion && (
          <div className="mobile-promotion-banner">
            <span className="mobile-promo-icon">🎉</span>
            <span className="mobile-promo-text">{venue.promotionText}</span>
          </div>
        )}

        {/* Footer Stats */}
        <div className="mobile-venue-footer">
          <div className="mobile-venue-stats">
            <div className="mobile-stat-item">
              <Heart className="mobile-stat-icon" />
              <span>{venue.followersCount}</span>
            </div>
            <div className="mobile-stat-item">
              <MapPin className="mobile-stat-icon" />
              <span>{venue.address.split(',')[0]}</span>
            </div>
          </div>
          
          <div className="mobile-view-details">
            <TrendingUp className="w-4 h-4" />
            <span>Details</span>
          </div>
        </div>
      </div>
    );
  }

  // Fallback to original layout for non-mobile
  return (
    <div className="venue-card-container" onClick={handleDetailsClick}>
      <div className="venue-card-header-fixed">
        <div className="venue-info-section">
          <h3 className="venue-name">{venue.name}</h3>
          <div className="venue-meta">
            <span className="venue-type">{venue.type}</span>
            <span className="venue-separator">•</span>
            <span className="venue-address">{venue.address}</span>
          </div>
          <div className="venue-rating">
            <StarRating rating={venue.rating} size="sm" />
            <span className="rating-count">({venue.totalRatings})</span>
          </div>
        </div>
        <div className="venue-actions-section">
          <FollowButton venue={venue} size="sm" />
        </div>
      </div>

      <div className="venue-status-section">
        <div className="status-items">
          <div className="status-item crowd">
            <Users className="status-icon" />
            <span className={`status-text ${getCrowdColor(venue.crowdLevel)}`}>
              {getCrowdLabel(venue.crowdLevel)}
            </span>
          </div>
          <div className="status-item wait">
            <Clock className="status-icon" />
            <span className="status-text">
              {venue.waitTime > 0 ? `${venue.waitTime} min wait` : 'No wait'}
            </span>
          </div>
        </div>
        <div className="status-meta">
          <span className="last-update">Updated {venue.lastUpdate}</span>
          <span className="confidence">{venue.confidence}% confidence</span>
        </div>
      </div>

      <div className="venue-vibe-section">
        {venue.vibe.slice(0, 3).map((tag, index) => (
          <span key={index} className="vibe-tag">
            {tag}
          </span>
        ))}
        {venue.vibe.length > 3 && (
          <span className="vibe-tag more">+{venue.vibe.length - 3}</span>
        )}
      </div>

      {venue.hasPromotion && (
        <div className="venue-promotion">
          <span className="promotion-icon">🎉</span>
          <span className="promotion-text">{venue.promotionText}</span>
        </div>
      )}

      <div className="venue-card-footer">
        <div className="venue-stats">
          <div className="stat-item">
            <span className="stat-number">{venue.followersCount}</span>
            <span className="stat-label">followers</span>
          </div>
          <div className="stat-item">
            <span className="stat-number">{venue.reports}</span>
            <span className="stat-label">reports</span>
          </div>
        </div>
        <button className="details-btn-full">
          <span>View Details</span>
          <TrendingUp className="w-4 h-4" />
        </button>
      </div>
    </div>
  );
};

export default VenueCard;
