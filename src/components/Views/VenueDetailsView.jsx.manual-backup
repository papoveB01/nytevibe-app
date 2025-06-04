import React, { useState, useEffect } from 'react';
import {
  ArrowLeft, MapPin, Clock, Phone, Star, Users, Share2, Navigation,
  ExternalLink, Heart, Calendar, Globe, Wifi, CreditCard, Car,
  Music, Volume2, Utensils, Coffee, Wine, ShoppingBag, ChevronDown
} from 'lucide-react';
import { useApp } from '../../context/AppContext';
import { useVenues } from '../../hooks/useVenues';
import StarRating from '../Venue/StarRating';
import FollowButton from '../Follow/FollowButton';
import FollowStats from '../Follow/FollowStats';
import { getCrowdLabel, getCrowdColor, openGoogleMaps, getDirections } from '../../utils/helpers';

const VenueDetailsView = ({ onBack }) => {
  const { state, actions } = useApp();
  const { selectedVenue: venue } = state;
  const { isVenueFollowed } = useVenues();
  const [activeTab, setActiveTab] = useState('overview');
  const [showAllReviews, setShowAllReviews] = useState(false);
  const [showAllAmenities, setShowAllAmenities] = useState(false);

  useEffect(() => {
    window.scrollTo(0, 0);
  }, [venue]);

  if (!venue) {
    return (
      <div className="mobile-venue-details">
        <div className="mobile-details-header">
          <button onClick={onBack} className="mobile-back-button">
            <ArrowLeft className="w-5 h-5" />
          </button>
          <h2>Venue Not Found</h2>
        </div>
      </div>
    );
  }

  const isFollowed = isVenueFollowed(venue.id);
  const displayedReviews = showAllReviews ? venue.reviews : venue.reviews?.slice(0, 2) || [];

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

  const displayedAmenities = showAllAmenities ? amenities : amenities.slice(0, 4);

  const handleShare = () => {
    actions.setShareVenue(venue);
    actions.setShowShareModal(true);
  };

  const handleRate = () => {
    actions.setSelectedVenue(venue);
    actions.setShowRatingModal(true);
  };

  const handleReport = () => {
    actions.setSelectedVenue(venue);
    actions.setShowReportModal(true);
  };

  const handleCall = () => {
    window.open(`tel:${venue.phone}`);
  };

  const handleDirections = () => {
    getDirections(venue);
  };

  const handleMaps = () => {
    openGoogleMaps(venue);
  };

  return (
    <div className="mobile-venue-details">
      {/* Mobile Header */}
      <div className="mobile-details-header">
        <button onClick={onBack} className="mobile-back-button">
          <ArrowLeft className="w-5 h-5" />
        </button>
        <div className="mobile-header-title">
          <h1 className="mobile-venue-title">{venue.name}</h1>
          <p className="mobile-venue-subtitle">{venue.type}</p>
        </div>
        <button className="mobile-share-button" onClick={handleShare}>
          <Share2 className="w-5 h-5" />
        </button>
      </div>

      {/* Mobile Hero Card */}
      <div className="mobile-hero-card">
        <div className="mobile-hero-content">
          <div className="mobile-hero-rating">
            <div className="mobile-rating-display">
              <span className="mobile-rating-score">{venue.rating.toFixed(1)}</span>
              <div className="mobile-rating-stars">
                <StarRating rating={venue.rating} size="sm" />
              </div>
            </div>
            <span className="mobile-rating-count">({venue.totalRatings} reviews)</span>
          </div>
          
          <div className="mobile-hero-address">
            <MapPin className="mobile-address-icon" />
            <span className="mobile-address-text">{venue.address}</span>
          </div>
        </div>
      </div>

      {/* Mobile Status Cards */}
      <div className="mobile-status-grid">
        <div className={`mobile-status-card crowd ${getCrowdColor(venue.crowdLevel).split(' ')[0]}`}>
          <Users className="mobile-status-card-icon" />
          <div className="mobile-status-info">
            <span className="mobile-status-label">Crowd</span>
            <span className="mobile-status-value">{getCrowdLabel(venue.crowdLevel)}</span>
          </div>
        </div>
        
        <div className="mobile-status-card wait">
          <Clock className="mobile-status-card-icon" />
          <div className="mobile-status-info">
            <span className="mobile-status-label">Wait</span>
            <span className="mobile-status-value">
              {venue.waitTime > 0 ? `${venue.waitTime}m` : 'None'}
            </span>
          </div>
        </div>
        
        <div className="mobile-status-card followers">
          <Heart className="mobile-status-card-icon" />
          <div className="mobile-status-info">
            <span className="mobile-status-label">Followers</span>
            <span className="mobile-status-value">{venue.followersCount}</span>
          </div>
        </div>
      </div>

      {/* Mobile Action Bar */}
      <div className="mobile-action-bar">
        <button className="mobile-action-button call" onClick={handleCall}>
          <Phone className="w-5 h-5" />
          <span>Call</span>
        </button>
        <button className="mobile-action-button directions" onClick={handleDirections}>
          <Navigation className="w-5 h-5" />
          <span>Directions</span>
        </button>
        <FollowButton venue={venue} size="md" showText={true} />
      </div>

      {/* Mobile Promotion */}
      {venue.hasPromotion && (
        <div className="mobile-promotion-card">
          <div className="mobile-promo-icon">🎉</div>
          <div className="mobile-promo-content">
            <h3 className="mobile-promo-title">Special Offer</h3>
            <p className="mobile-promo-text">{venue.promotionText}</p>
          </div>
        </div>
      )}

      {/* Mobile Content Sections */}
      <div className="mobile-content-sections">
        
        {/* Vibe Section */}
        <div className="mobile-content-section">
          <h3 className="mobile-section-title">Vibe & Atmosphere</h3>
          <div className="mobile-vibe-grid">
            {venue.vibe.map((tag, index) => (
              <span key={index} className="mobile-vibe-tag-large">
                {tag}
              </span>
            ))}
          </div>
        </div>

        {/* Amenities Section */}
        <div className="mobile-content-section">
          <div className="mobile-section-header">
            <h3 className="mobile-section-title">What's Available</h3>
            {amenities.length > 4 && (
              <button 
                className="mobile-toggle-button"
                onClick={() => setShowAllAmenities(!showAllAmenities)}
              >
                {showAllAmenities ? 'Show Less' : 'Show All'}
                <ChevronDown className={`w-4 h-4 transition-transform ${showAllAmenities ? 'rotate-180' : ''}`} />
              </button>
            )}
          </div>
          
          <div className="mobile-amenities-grid">
            {displayedAmenities.map((amenity, index) => (
              <div
                key={index}
                className={`mobile-amenity-item ${amenity.available ? 'available' : 'unavailable'}`}
              >
                <amenity.icon className="mobile-amenity-icon" />
                <span className="mobile-amenity-label">{amenity.label}</span>
                {amenity.available && <span className="mobile-amenity-check">✓</span>}
              </div>
            ))}
          </div>
        </div>

        {/* Reviews Section */}
        <div className="mobile-content-section">
          <div className="mobile-section-header">
            <h3 className="mobile-section-title">What People Say</h3>
            <button 
              className="mobile-write-review"
              onClick={handleRate}
            >
              Write Review
            </button>
          </div>

          <div className="mobile-reviews-summary">
            <div className="mobile-review-score">
              <span className="mobile-score-large">{venue.rating.toFixed(1)}</span>
              <div className="mobile-score-stars">
                <StarRating rating={venue.rating} size="md" />
              </div>
              <span className="mobile-score-text">Based on {venue.totalRatings} reviews</span>
            </div>
          </div>

          <div className="mobile-reviews-list">
            {displayedReviews.map((review) => (
              <div key={review.id} className="mobile-review-card">
                <div className="mobile-review-header">
                  <div className="mobile-reviewer">
                    <div className="mobile-reviewer-avatar">
                      {review.user.charAt(0)}
                    </div>
                    <div className="mobile-reviewer-info">
                      <span className="mobile-reviewer-name">{review.user}</span>
                      <div className="mobile-review-meta">
                        <StarRating rating={review.rating} size="sm" />
                        <span className="mobile-review-date">{review.date}</span>
                      </div>
                    </div>
                  </div>
                </div>
                <p className="mobile-review-text">{review.comment}</p>
                <button className="mobile-helpful-button">
                  👍 Helpful ({review.helpful})
                </button>
              </div>
            ))}
          </div>

          {venue.reviews && venue.reviews.length > 2 && (
            <button
              className="mobile-show-more-reviews"
              onClick={() => setShowAllReviews(!showAllReviews)}
            >
              {showAllReviews ? 'Show Less Reviews' : `Show All ${venue.reviews.length} Reviews`}
            </button>
          )}
        </div>

        {/* Contact Section */}
        <div className="mobile-content-section">
          <h3 className="mobile-section-title">Contact & Hours</h3>
          
          <div className="mobile-contact-grid">
            <div className="mobile-contact-item">
              <Phone className="mobile-contact-icon" />
              <div className="mobile-contact-info">
                <span className="mobile-contact-label">Phone</span>
                <span className="mobile-contact-value">{venue.phone}</span>
              </div>
              <button className="mobile-contact-action" onClick={handleCall}>
                Call
              </button>
            </div>
            
            <div className="mobile-contact-item">
              <Clock className="mobile-contact-icon" />
              <div className="mobile-contact-info">
                <span className="mobile-contact-label">Hours</span>
                <span className="mobile-contact-value">{venue.hours}</span>
              </div>
            </div>
            
            <div className="mobile-contact-item">
              <Globe className="mobile-contact-icon" />
              <div className="mobile-contact-info">
                <span className="mobile-contact-label">Website</span>
                <span className="mobile-contact-value">Visit Website</span>
              </div>
              <button className="mobile-contact-action">
                View
              </button>
            </div>
          </div>
        </div>

        {/* Action Section */}
        <div className="mobile-content-section">
          <div className="mobile-action-grid">
            <button className="mobile-action-card primary" onClick={handleRate}>
              <Star className="mobile-action-icon" />
              <span className="mobile-action-label">Rate & Review</span>
            </button>
            <button className="mobile-action-card secondary" onClick={handleReport}>
              <Users className="mobile-action-icon" />
              <span className="mobile-action-label">Report Status</span>
            </button>
          </div>
        </div>
      </div>

      {/* Mobile Bottom Padding */}
      <div className="mobile-bottom-padding"></div>
    </div>
  );
};

export default VenueDetailsView;
