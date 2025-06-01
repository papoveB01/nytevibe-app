import React, { useState, useEffect } from 'react';
import {
  ArrowLeft, MapPin, Clock, Phone, Star, Users, Share2, Navigation,
  ExternalLink, Heart, Calendar, Globe, Wifi, CreditCard, Car,
  Music, Volume2, Utensils, Coffee, Wine, ShoppingBag, ThumbsUp
} from 'lucide-react';
import { useApp } from '../../context/AppContext';
import { useVenues } from '../../hooks/useVenues';
import StarRating from '../Venue/StarRating';
import { getCrowdLabel, getCrowdColor, openGoogleMaps, getDirections } from '../../utils/helpers';

const VenueDetailsView = ({ onBack, onShare }) => {
  const { state, actions } = useApp();
  const { selectedVenue: venue } = state;
  const { isVenueFollowed, toggleFollow } = useVenues();
  const [activeTab, setActiveTab] = useState('overview');
  const [showAllReviews, setShowAllReviews] = useState(false);

  useEffect(() => {
    // Auto-scroll to top when venue details open
    window.scrollTo(0, 0);
  }, [venue]);

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
        <div className="details-content">
          <p>The selected venue could not be found.</p>
        </div>
      </div>
    );
  }

  const isFollowed = isVenueFollowed(venue.id);

  // Safe action handlers with error boundaries
  const handleFollow = () => {
    try {
      toggleFollow(venue);
      actions.addNotification({
        type: 'success',
        message: isFollowed 
          ? `💔 Unfollowed ${venue.name} (-2 points)` 
          : `❤️ Following ${venue.name} (+3 points)`
      });
    } catch (error) {
      console.error('Follow action error:', error);
      actions.addNotification({
        type: 'error',
        message: 'Follow action failed. Please try again.'
      });
    }
  };

  const handleShare = () => {
    try {
      if (onShare) {
        onShare(venue);
      } else {
        // Direct modal activation
        actions.setShareVenue(venue);
        actions.setShowShareModal(true);
      }
      actions.addNotification({
        type: 'default',
        message: `📤 Opening share options for ${venue.name}...`
      });
    } catch (error) {
      console.error('Share action error:', error);
      actions.addNotification({
        type: 'error',
        message: 'Share action failed. Please try again.'
      });
    }
  };

  const handleRate = () => {
    try {
      actions.setSelectedVenue(venue);
      actions.setShowRatingModal(true);
      actions.addNotification({
        type: 'default',
        message: `⭐ Opening rating form for ${venue.name}...`
      });
    } catch (error) {
      console.error('Rate action error:', error);
      actions.addNotification({
        type: 'error',
        message: 'Rating form failed to open. Please try again.'
      });
    }
  };

  const handleReport = () => {
    try {
      actions.setSelectedVenue(venue);
      actions.setShowReportModal(true);
      actions.addNotification({
        type: 'default',
        message: `📊 Opening status report for ${venue.name}...`
      });
    } catch (error) {
      console.error('Report action error:', error);
      actions.addNotification({
        type: 'error',
        message: 'Report form failed to open. Please try again.'
      });
    }
  };

  const handlePhoneCall = () => {
    try {
      const phoneNumber = venue.phone.replace(/\D/g, '');
      window.open(`tel:${phoneNumber}`);
      actions.addNotification({
        type: 'default',
        message: `📞 Calling ${venue.name} at ${venue.phone}...`
      });
    } catch (error) {
      console.error('Phone call error:', error);
      actions.addNotification({
        type: 'error',
        message: 'Phone call failed. Please try manually dialing.'
      });
    }
  };

  const handleViewOnMaps = () => {
    try {
      openGoogleMaps(venue);
      actions.addNotification({
        type: 'default',
        message: `🗺️ Opening ${venue.name} location on Google Maps...`
      });
    } catch (error) {
      console.error('Maps view error:', error);
      actions.addNotification({
        type: 'error',
        message: 'Failed to open maps. Please try again.'
      });
    }
  };

  const handleGetDirections = () => {
    try {
      getDirections(venue);
      actions.addNotification({
        type: 'default',
        message: `🧭 Getting directions to ${venue.name}...`
      });
    } catch (error) {
      console.error('Directions error:', error);
      actions.addNotification({
        type: 'error',
        message: 'Failed to get directions. Please try again.'
      });
    }
  };

  const handleWebsite = () => {
    try {
      const websiteUrl = `https://www.${venue.name.toLowerCase().replace(/\s+/g, '')}.com`;
      window.open(websiteUrl, '_blank');
      actions.addNotification({
        type: 'default',
        message: `🌐 Opening ${venue.name} website...`
      });
    } catch (error) {
      console.error('Website error:', error);
      actions.addNotification({
        type: 'error',
        message: 'Failed to open website. Please try again.'
      });
    }
  };

  const handleHelpfulReview = (reviewId, currentHelpful) => {
    try {
      actions.addNotification({
        type: 'success',
        message: `👍 Marked review as helpful! (+1 point)`
      });
    } catch (error) {
      console.error('Helpful review error:', error);
      actions.addNotification({
        type: 'error',
        message: 'Failed to mark as helpful. Please try again.'
      });
    }
  };

  const handleTabChange = (tabId) => {
    try {
      setActiveTab(tabId);
      actions.addNotification({
        type: 'default',
        message: `📑 Switched to ${tabId.charAt(0).toUpperCase() + tabId.slice(1)} tab`
      });
    } catch (error) {
      console.error('Tab change error:', error);
      setActiveTab('overview'); // Fallback to overview
    }
  };

  const displayedReviews = showAllReviews ? venue.reviews : venue.reviews?.slice(0, 3) || [];

  const amenities = [
    { icon: Wifi, label: 'Free WiFi', available: true },
    { icon: Car, label: 'Parking', available: true },
    { icon: CreditCard, label: 'Card Accepted', available: true },
    { icon: Music, label: 'Live Music', available: venue.vibe.includes('Live Music') },
    { icon: Utensils, label: 'Food Menu', available: venue.type.includes('Grill') || venue.type.includes('Restaurant') },
    { icon: Coffee, label: 'Coffee', available: venue.type.includes('Cafe') || venue.type.includes('Coffee') },
    { icon: Wine, label: 'Full Bar', available: venue.type.includes('Bar') || venue.type.includes('Lounge') },
    { icon: ShoppingBag, label: 'VIP Service', available: venue.vibe.includes('VIP') }
  ];

  const renderStarBreakdown = () => {
    const breakdown = venue.ratingBreakdown || {};
    const total = venue.totalRatings || 1;

    return (
      <div className="rating-breakdown">
        <h4>Rating Breakdown</h4>
        {[5, 4, 3, 2, 1].map(rating => {
          const count = breakdown[rating] || 0;
          const percentage = (count / total) * 100;

          return (
            <div key={rating} className="rating-row">
              <span className="rating-label">{rating} ⭐</span>
              <div className="rating-bar">
                <div 
                  className="rating-fill" 
                  style={{ width: `${percentage}%` }}
                ></div>
              </div>
              <span className="rating-count">({count})</span>
            </div>
          );
        })}
      </div>
    );
  };

  const renderTabContent = () => {
    switch (activeTab) {
      case 'overview':
        return (
          <div className="tab-content">
            {/* Vibe Tags */}
            <div className="section">
              <h4>Vibe & Atmosphere</h4>
              <div className="vibe-tags-large">
                {venue.vibe.map((tag, index) => (
                  <span key={index} className="vibe-tag">
                    {tag}
                  </span>
                ))}
              </div>
            </div>

            {/* Promotion */}
            {venue.hasPromotion && (
              <div className="section">
                <div className="promotion-highlight">
                  <div className="promotion-icon">🎉</div>
                  <div className="promotion-content">
                    <h4>Special Promotion</h4>
                    <p>{venue.promotionText}</p>
                  </div>
                </div>
              </div>
            )}

            {/* Amenities */}
            <div className="section">
              <h4>Amenities & Features</h4>
              <div className="amenities-grid">
                {amenities.map((amenity, index) => (
                  <div
                    key={index}
                    className={`amenity-item ${amenity.available ? 'available' : 'unavailable'}`}
                  >
                    <amenity.icon className="amenity-icon" />
                    <span>{amenity.label}</span>
                  </div>
                ))}
              </div>
            </div>

            {/* Quick Actions */}
            <div className="section">
              <div className="quick-actions">
                <button
                  className="action-button primary"
                  onClick={handleRate}
                >
                  <Star className="w-4 h-4" />
                  Rate & Review (+5 points)
                </button>
                <button
                  className="action-button secondary"
                  onClick={handleReport}
                >
                  <Users className="w-4 h-4" />
                  Report Status (+10 points)
                </button>
              </div>
            </div>
          </div>
        );

      case 'reviews':
        return (
          <div className="tab-content">
            {/* Rating Summary */}
            <div className="section">
              <div className="rating-summary">
                <div className="rating-overview">
                  <div className="rating-score">
                    <span className="score">{venue.rating.toFixed(1)}</span>
                    <div className="rating-stars">
                      <StarRating rating={venue.rating} size="lg" />
                    </div>
                    <span className="rating-label">Based on {venue.totalRatings} reviews</span>
                  </div>
                  {renderStarBreakdown()}
                </div>
              </div>
            </div>

            {/* Reviews List */}
            <div className="section">
              <div className="reviews-header">
                <h4>Customer Reviews</h4>
                <button
                  className="write-review-button"
                  onClick={handleRate}
                >
                  Write a Review
                </button>
              </div>

              <div className="reviews-list">
                {displayedReviews.map((review) => (
                  <div key={review.id} className="review-card">
                    <div className="review-header">
                      <div className="review-author">
                        <div className="author-avatar">
                          {review.user.charAt(0)}
                        </div>
                        <div className="author-info">
                          <span className="author-name">{review.user}</span>
                          <div className="review-meta">
                            <StarRating rating={review.rating} size="sm" />
                            <span className="review-date">{review.date}</span>
                          </div>
                        </div>
                      </div>
                      <div className="review-helpful">
                        <button 
                          className="helpful-button"
                          onClick={() => handleHelpfulReview(review.id, review.helpful)}
                        >
                          <ThumbsUp className="w-3 h-3" />
                          {review.helpful}
                        </button>
                      </div>
                    </div>
                    <div className="review-content">
                      <p>{review.comment}</p>
                    </div>
                  </div>
                ))}
              </div>

              {venue.reviews && venue.reviews.length > 3 && (
                <div className="reviews-actions">
                  <button
                    className="show-more-reviews"
                    onClick={() => {
                      try {
                        setShowAllReviews(!showAllReviews);
                        actions.addNotification({
                          type: 'default',
                          message: showAllReviews ? 'Showing fewer reviews' : `Showing all ${venue.reviews.length} reviews`
                        });
                      } catch (error) {
                        console.error('Show reviews error:', error);
                      }
                    }}
                  >
                    {showAllReviews ? 'Show Less' : `Show All ${venue.reviews.length} Reviews`}
                  </button>
                </div>
              )}
            </div>
          </div>
        );

      case 'info':
        return (
          <div className="tab-content">
            {/* Contact Information */}
            <div className="section">
              <h4>Contact & Location</h4>
              <div className="contact-info">
                <div className="contact-item">
                  <MapPin className="contact-icon" />
                  <div className="contact-details">
                    <span className="contact-label">Address</span>
                    <span className="contact-value">{venue.address}</span>
                  </div>
                  <button
                    className="contact-action"
                    onClick={handleViewOnMaps}
                    title="View on Google Maps"
                  >
                    <ExternalLink className="w-4 h-4" />
                  </button>
                </div>

                <div className="contact-item">
                  <Phone className="contact-icon" />
                  <div className="contact-details">
                    <span className="contact-label">Phone</span>
                    <span className="contact-value">{venue.phone}</span>
                  </div>
                  <button
                    className="contact-action"
                    onClick={handlePhoneCall}
                    title="Call venue"
                  >
                    <ExternalLink className="w-4 h-4" />
                  </button>
                </div>

                <div className="contact-item">
                  <Clock className="contact-icon" />
                  <div className="contact-details">
                    <span className="contact-label">Hours</span>
                    <span className="contact-value">{venue.hours}</span>
                  </div>
                </div>

                <div className="contact-item">
                  <Globe className="contact-icon" />
                  <div className="contact-details">
                    <span className="contact-label">Website</span>
                    <span className="contact-value">www.{venue.name.toLowerCase().replace(/\s+/g, '')}.com</span>
                  </div>
                  <button 
                    className="contact-action"
                    onClick={handleWebsite}
                    title="Visit website"
                  >
                    <ExternalLink className="w-4 h-4" />
                  </button>
                </div>
              </div>
            </div>

            {/* Navigation Actions */}
            <div className="section">
              <h4>Get Directions</h4>
              <div className="navigation-actions">
                <button
                  className="nav-button maps"
                  onClick={handleViewOnMaps}
                >
                  <MapPin className="w-5 h-5" />
                  <div>
                    <span className="nav-title">View on Maps</span>
                    <span className="nav-subtitle">See location & nearby places</span>
                  </div>
                </button>

                <button
                  className="nav-button directions"
                  onClick={handleGetDirections}
                >
                  <Navigation className="w-5 h-5" />
                  <div>
                    <span className="nav-title">Get Directions</span>
                    <span className="nav-subtitle">Turn-by-turn navigation</span>
                  </div>
                </button>
              </div>
            </div>

            {/* Venue Statistics */}
            <div className="section">
              <h4>Venue Statistics</h4>
              <div className="venue-stats">
                <div className="stat-card">
                  <div className="stat-number">{venue.followersCount}</div>
                  <div className="stat-label">Followers</div>
                </div>
                <div className="stat-card">
                  <div className="stat-number">{venue.reports}</div>
                  <div className="stat-label">Reports</div>
                </div>
                <div className="stat-card">
                  <div className="stat-number">{venue.confidence}%</div>
                  <div className="stat-label">Confidence</div>
                </div>
                <div className="stat-card">
                  <div className="stat-number">{venue.totalRatings}</div>
                  <div className="stat-label">Reviews</div>
                </div>
              </div>
            </div>
          </div>
        );

      default:
        return (
          <div className="tab-content">
            <div className="section">
              <p>Tab content not found. Please try refreshing the page.</p>
            </div>
          </div>
        );
    }
  };

  return (
    <div className="venue-details-view">
      {/* Header */}
      <div className="details-header">
        <button onClick={onBack} className="back-button">
          <ArrowLeft className="w-5 h-5" />
          <span>Back to Search</span>
        </button>
        <div className="header-actions">
          <button
            className={`follow-button-header ${isFollowed ? 'following' : ''}`}
            onClick={handleFollow}
            title={isFollowed ? `Unfollow ${venue.name}` : `Follow ${venue.name}`}
          >
            <Heart className={`w-4 h-4 ${isFollowed ? 'fill-current' : ''}`} />
            <span>{isFollowed ? 'Following' : 'Follow'}</span>
          </button>
          <button 
            className="share-button-header" 
            onClick={handleShare}
            title={`Share ${venue.name}`}
          >
            <Share2 className="w-4 h-4" />
            <span>Share</span>
          </button>
        </div>
      </div>

      {/* Hero Section */}
      <div className="details-hero">
        <div className="hero-content">
          <div className="venue-title-section">
            <h1 className="venue-title">{venue.name}</h1>
            <div className="venue-subtitle">
              <span className="venue-type">{venue.type}</span>
              <span className="venue-separator">•</span>
              <span className="venue-distance">{venue.distance}</span>
            </div>
            <div className="venue-rating-section">
              <StarRating
                rating={venue.rating}
                size="lg"
                showCount={true}
                totalRatings={venue.totalRatings}
              />
            </div>
          </div>
        </div>
      </div>

      {/* Status Cards */}
      <div className="status-cards-section">
        <div className="status-cards">
          <div 
            className="status-card crowd clickable"
            onClick={handleReport}
            title="Click to report current crowd level"
          >
            <div className="status-icon-wrapper">
              <Users className="status-card-icon" />
            </div>
            <div className="status-info">
              <span className="status-label">Crowd Level</span>
              <span className={`status-value ${getCrowdColor(venue.crowdLevel).split(' ').pop()}`}>
                {getCrowdLabel(venue.crowdLevel)}
              </span>
              <span className="status-meta">Updated {venue.lastUpdate}</span>
            </div>
          </div>

          <div 
            className="status-card wait clickable"
            onClick={handleReport}
            title="Click to report current wait time"
          >
            <div className="status-icon-wrapper">
              <Clock className="status-card-icon" />
            </div>
            <div className="status-info">
              <span className="status-label">Wait Time</span>
              <span className="status-value">
                {venue.waitTime > 0 ? `${venue.waitTime} min` : 'No wait'}
              </span>
              <span className="status-meta">{venue.confidence}% confidence</span>
            </div>
          </div>

          <div 
            className="status-card followers clickable"
            onClick={handleFollow}
            title={isFollowed ? 'Click to unfollow' : 'Click to follow'}
          >
            <div className="status-icon-wrapper">
              <Heart className="status-card-icon" />
            </div>
            <div className="status-info">
              <span className="status-label">Followers</span>
              <span className="status-value">{venue.followersCount}</span>
              <span className="status-meta">{isFollowed ? 'You follow this' : 'Join the community'}</span>
            </div>
          </div>
        </div>
      </div>

      {/* Tab Navigation */}
      <div className="tab-navigation">
        <div className="tab-buttons">
          {[
            { id: 'overview', label: 'Overview' },
            { id: 'reviews', label: 'Reviews', count: venue.reviews?.length },
            { id: 'info', label: 'Info' }
          ].map((tab) => (
            <button
              key={tab.id}
              className={`tab-button ${activeTab === tab.id ? 'active' : ''}`}
              onClick={() => handleTabChange(tab.id)}
            >
              {tab.label}
              {tab.count && <span className="tab-count">({tab.count})</span>}
            </button>
          ))}
        </div>
      </div>

      {/* Tab Content */}
      <div className="tab-content-wrapper">
        {renderTabContent()}
      </div>
    </div>
  );
};

export default VenueDetailsView;
