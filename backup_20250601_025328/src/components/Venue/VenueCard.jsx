import React, { useState } from 'react';
import { MapPin, Users, Clock, Star, TrendingUp, Share2, ChevronRight, Gift, Heart, Zap } from 'lucide-react';
import FollowButton from '../Follow/FollowButton';
import FollowStats from '../Follow/FollowStats';
import StarRating from './StarRating';
import Badge from '../UI/Badge';
import { useVenues } from '../../hooks/useVenues';
import { useApp } from '../../context/AppContext';
import { getCrowdLabel, getCrowdColor, getTrendingIcon } from '../../utils/helpers';

const VenueCard = ({
  venue,
  onClick,
  onShare,
  searchQuery = ''
}) => {
  const { isVenueFollowed } = useVenues();
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

  const getPromoIcon = (text) => {
    if (text.toLowerCase().includes('free') || 
        text.toLowerCase().includes('50%') || 
        text.toLowerCase().includes('%')) {
      return <Zap className="w-3 h-3" />;
    }
    if (text.toLowerCase().includes('dj') || 
        text.toLowerCase().includes('music')) {
      return <span className="promo-emoji">🎵</span>;
    }
    if (text.toLowerCase().includes('game') || 
        text.toLowerCase().includes('sports')) {
      return <span className="promo-emoji">🏈</span>;
    }
    return <Gift className="w-3 h-3" />;
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
            <StarRating
              rating={venue.rating}
              size="sm"
              showCount={true}
              totalRatings={venue.totalRatings}
            />
          </div>

          <div className="venue-address">
            {searchQuery ? highlightText(`${venue.city}, ${venue.postcode}`, searchQuery) : `${venue.city}, ${venue.postcode}`}
          </div>
        </div>

        <div className="venue-actions-section">
          <div className="top-actions">
            <FollowButton venue={venue} size="md" showCount={false} />
            <button
              onClick={(e) => {
                e.stopPropagation();
                onShare?.(venue);
              }}
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

      {venue.hasPromotion && venue.promotionText.toLowerCase().includes('grand opening') && (
        <div className="promotion-strip">
          <Zap className="w-3 h-3" />
          <span className="strip-text">Grand Opening Special</span>
        </div>
      )}

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
          <Badge key={index} variant="primary">
            {tag}
          </Badge>
        ))}
      </div>

      <FollowStats venue={venue} />

      <div className="venue-action-buttons-single">
        <button
          onClick={handleDetails}
          className="action-btn details-btn-full"
        >
          View Details
          <ChevronRight className="details-icon" />
        </button>
      </div>
    </div>
  );
};

export default VenueCard;
