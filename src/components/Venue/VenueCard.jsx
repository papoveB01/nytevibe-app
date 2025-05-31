import React, { useState } from 'react';
import { MapPin, Users, Clock, Star, TrendingUp, Share2, ChevronRight, Gift, Heart, Zap } from 'lucide-react';
import { useVenues } from '../../hooks/useVenues';
import { useApp } from '../../context/AppContext';
import { getCrowdLabel, getCrowdColor, getTrendingIcon } from '../../utils/helpers';

const VenueCard = ({ venue, onShare, searchQuery = '' }) => {
  const { isVenueFollowed, toggleFollow } = useVenues();
  const { actions } = useApp();
  const [showPromoTooltip, setShowPromoTooltip] = useState(false);

  const highlightText = (text, query) => {
    if (!query.trim()) return text;
    const parts = text.split(new RegExp(`(${query})`, 'gi'));
    return parts.map((part, index) =>
      part.toLowerCase() === query.toLowerCase() ? (
        <mark key={index} className="search-highlight">{part}</mark>
      ) : part
    );
  };

  const isFollowed = isVenueFollowed(venue.id);

  const handleDetails = () => {
    actions.setSelectedVenue(venue);
    actions.setCurrentView('details');
  };

  const handleFollow = (e) => {
    e.stopPropagation();
    toggleFollow(venue);
  };

  const handleShare = (e) => {
    e.stopPropagation();
    onShare?.(venue);
  };

  const getPromoIcon = (text) => {
    if (text.toLowerCase().includes('free') || text.toLowerCase().includes('50%') || text.toLowerCase().includes('%')) {
      return <Zap className="w-3 h-3" />;
    }
    if (text.toLowerCase().includes('dj') || text.toLowerCase().includes('music')) {
      return <span className="promo-emoji">🎵</span>;
    }
    if (text.toLowerCase().includes('game') || text.toLowerCase().includes('sports')) {
      return <span className="promo-emoji">🏈</span>;
    }
    return <Gift className="w-3 h-3" />;
  };

  const renderCrowdDots = (level) => {
    return Array.from({ length: 5 }, (_, i) => (
      <div
        key={i}
        className={`crowd-dot ${i < level ? 'filled' : ''}`}
      />
    ));
  };

  return (
    <div className={`venue-card-container ${isFollowed ? 'venue-followed' : ''}`}>
      {venue.hasPromotion && (
        <div
          className="venue-promotion-sleek"
          onMouseEnter={() => setShowPromoTooltip(true)}
          onMouseLeave={() => setShowPromoTooltip(false)}
        >
          {getPromoIcon(venue.promotionText)}
          {showPromoTooltip && (
            <div className="promotion-tooltip">
              <div className="tooltip-content">
                {venue.promotionText}
              </div>
              <div className="tooltip-arrow"></div>
            </div>
          )}
        </div>
      )}

      <div className="venue-card-header-fixed">
        <div className="venue-info-section">
          <div className="venue-title-row">
            <h3 className="venue-name">
              {searchQuery ? highlightText(venue.name, searchQuery) : venue.name}
            </h3>
            <span className="trending-icon">{getTrendingIcon(venue.trending)}</span>
            {isFollowed && (
              <div className="followed-indicator">
                <Heart className="w-4 h-4 text-red-500 fill-current" />
              </div>
            )}
          </div>
          
          <div className="venue-location-row">
            <MapPin className="location-icon" />
            <span className="location-text">{venue.type} • {venue.distance}</span>
          </div>
          
          <div className="venue-rating-row">
            <div className="star-rating">
              {Array.from({ length: 5 }, (_, i) => (
                <Star
                  key={i}
                  className={`w-4 h-4 ${i < Math.floor(venue.rating) ? 'fill-current text-yellow-400' : 'text-gray-300'}`}
                />
              ))}
              <span className="rating-count">
                {venue.rating.toFixed(1)} ({venue.totalRatings})
              </span>
            </div>
          </div>
          
          <div className="venue-address">
            {searchQuery ? highlightText(`${venue.city}, ${venue.postcode}`, searchQuery) : `${venue.city}, ${venue.postcode}`}
          </div>
        </div>

        <div className="venue-actions-section">
          <div className="top-actions">
            <button
              className={`follow-button ${isFollowed ? 'following' : ''}`}
              onClick={handleFollow}
              title={isFollowed ? 'Unfollow venue' : 'Follow venue'}
            >
              <Heart className={`w-5 h-5 ${isFollowed ? 'fill-current' : ''}`} />
            </button>
            <button
              onClick={handleShare}
              className="share-button"
              title="Share venue"
            >
              <Share2 className="w-4 h-4" />
            </button>
          </div>
          
          <div className="crowd-status">
            <div className={getCrowdColor(venue.crowdLevel)}>
              <Users className="crowd-icon" />
              <span className="crowd-text">{getCrowdLabel(venue.crowdLevel)}</span>
            </div>
          </div>
        </div>
      </div>

      <div className="venue-status-section">
        <div className="status-items">
          <div className="status-item">
            <Clock className="status-icon" />
            <span className="status-text">
              {venue.waitTime > 0 ? `${venue.waitTime} min wait` : 'No wait'}
            </span>
          </div>
          <div className="status-item">
            <TrendingUp className="status-icon" />
            <span className="status-text">{venue.confidence}% confidence</span>
          </div>
        </div>
        <span className="last-update">{venue.lastUpdate}</span>
      </div>

      <div className="venue-vibe-section">
        {venue.vibe.map((tag, index) => (
          <span key={index} className="badge badge-blue">
            {tag}
          </span>
        ))}
      </div>

      <div className="venue-follow-stats">
        <div className="follow-stat">
          <Users className="stat-icon" />
          <span className="stat-number">{venue.followersCount}</span>
          <span className="stat-label">followers</span>
        </div>
        <div className="follow-stat">
          <TrendingUp className="stat-icon" />
          <span className="stat-number">{venue.reports}</span>
          <span className="stat-label">reports</span>
        </div>
        {isFollowed && (
          <div className="follow-stat you-follow">
            <Heart className="stat-icon" />
            <span className="stat-text">You follow this venue</span>
          </div>
        )}
      </div>

      <div className="venue-action-buttons-single">
        <button
          onClick={handleDetails}
          className="details-btn-full"
        >
          View Details
          <ChevronRight className="details-icon" />
        </button>
      </div>
    </div>
  );
};

export default VenueCard;
