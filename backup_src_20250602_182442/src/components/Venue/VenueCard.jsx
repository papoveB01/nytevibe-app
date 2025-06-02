import React from 'react';
import { MapPin, Clock, Star, Users, TrendingUp } from 'lucide-react';
import { useApp } from '../../context/AppContext';
import FollowButton from '../Follow/FollowButton';
import StarRating from './StarRating';

const VenueCard = ({ venue, onSelect }) => {
  const { actions } = useApp();

  // Safe venue data extraction with fallbacks
  const safeVenue = {
    id: venue?.id || '',
    name: venue?.name || 'Unknown Venue',
    type: venue?.type || 'Venue',
    address: venue?.address || 'Address not available',
    crowdLevel: venue?.crowdLevel || 1,
    waitTime: venue?.waitTime || 0,
    rating: venue?.rating || 0,
    totalRatings: venue?.totalRatings || 0,
    lastUpdate: venue?.lastUpdate || 'Recently',
    confidence: venue?.confidence || 0,
    vibe: venue?.vibe || [],
    followersCount: venue?.followersCount || 0,
    reports: venue?.reports || 0,
    hasPromotion: venue?.hasPromotion || false,
    promotionText: venue?.promotionText || ''
  };

  const getCrowdLabel = (level) => {
    const levels = ['Unknown', 'Quiet', 'Moderate', 'Busy', 'Very Busy', 'Packed'];
    return levels[level] || levels[0];
  };

  const getCrowdColor = (level) => {
    const colors = [
      'text-gray-500',
      'text-green-600',
      'text-yellow-600', 
      'text-orange-600',
      'text-red-600',
      'text-purple-600'
    ];
    return colors[level] || colors[0];
  };

  const handleCardClick = () => {
    if (onSelect && typeof onSelect === 'function') {
      onSelect(safeVenue);
    }
  };

  const handleDetailsClick = (e) => {
    e.stopPropagation();
    handleCardClick();
  };

  return (
    <div className="venue-card-container" onClick={handleCardClick}>
      {/* Promotion Banner */}
      {safeVenue.hasPromotion && safeVenue.promotionText && (
        <div className="promotional-banner promotion">
          <div className="banner-content">
            <div className="banner-text">
              <div className="banner-title">🎉 Special Offer</div>
              <div className="banner-subtitle">{safeVenue.promotionText}</div>
            </div>
            <div className="banner-indicator">🔥</div>
          </div>
        </div>
      )}

      {/* Venue Header */}
      <div className="venue-card-header-fixed">
        <div className="venue-info-section">
          <h3 className="venue-name">{safeVenue.name}</h3>
          <p className="venue-type">{safeVenue.type}</p>
          <div className="venue-address">
            <MapPin size={14} />
            <span>{safeVenue.address}</span>
          </div>
        </div>
        <div className="venue-actions-section">
          <FollowButton venue={safeVenue} />
        </div>
      </div>

      {/* Venue Status */}
      <div className="venue-status-section">
        <div className="status-items">
          <div className="status-item crowd">
            <Users size={16} />
            <span className={`status-text ${getCrowdColor(safeVenue.crowdLevel)}`}>
              {getCrowdLabel(safeVenue.crowdLevel)}
            </span>
          </div>
          <div className="status-item wait">
            <Clock size={16} />
            <span className="status-text">
              {safeVenue.waitTime > 0 ? `${safeVenue.waitTime}m wait` : 'No wait'}
            </span>
          </div>
        </div>
        <div className="status-meta">
          <span className="last-update">Updated {safeVenue.lastUpdate}</span>
          <span className="confidence">{safeVenue.confidence}% confidence</span>
        </div>
      </div>

      {/* Venue Vibe Tags */}
      {Array.isArray(safeVenue.vibe) && safeVenue.vibe.length > 0 && (
        <div className="venue-vibe-section">
          {safeVenue.vibe.slice(0, 3).map((tag, index) => (
            <span key={index} className="vibe-tag">
              {typeof tag === 'string' ? tag : 'Vibe'}
            </span>
          ))}
          {safeVenue.vibe.length > 3 && (
            <span className="vibe-tag more">+{safeVenue.vibe.length - 3} more</span>
          )}
        </div>
      )}

      {/* Venue Rating */}
      <div className="venue-rating-section">
        <StarRating 
          rating={safeVenue.rating} 
          size="sm" 
          showCount={true}
          totalRatings={safeVenue.totalRatings}
        />
      </div>

      {/* Venue Stats */}
      <div className="venue-stats-section">
        <div className="stat-item">
          <Users size={14} />
          <span>{safeVenue.followersCount} followers</span>
        </div>
        <div className="stat-item">
          <TrendingUp size={14} />
          <span>{safeVenue.reports} reports</span>
        </div>
      </div>

      {/* Details Button */}
      <button 
        className="details-btn-full"
        onClick={handleDetailsClick}
      >
        View Details
      </button>
    </div>
  );
};

export default VenueCard;
