import React from 'react';
import { ArrowLeft, MapPin, Clock, Phone, Star, Users, Share2, Navigation } from 'lucide-react';
import { useApp } from '../../context/AppContext';
import FollowButton from '../Follow/FollowButton';
import FollowStats from '../Follow/FollowStats';
import StarRating from '../Venue/StarRating';
import Badge from '../UI/Badge';
import Button from '../UI/Button';
import { getCrowdLabel, getCrowdColor, openGoogleMaps, getDirections } from '../../utils/helpers';

const VenueDetailsView = ({ onBack, onShare }) => {
  const { state, actions } = useApp();
  const { selectedVenue: venue } = state;

  if (!venue) {
    return (
      <div className="venue-details-view">
        <div className="details-header">
          <button onClick={onBack} className="back-button">
            <ArrowLeft className="w-5 h-5" />
          </button>
          <h2>Venue Not Found</h2>
        </div>
        <div className="details-content">
          <p>The selected venue could not be found.</p>
        </div>
      </div>
    );
  }

  return (
    <div className="venue-details-view">
      <div className="details-header">
        <button onClick={onBack} className="back-button">
          <ArrowLeft className="w-5 h-5" />
        </button>
        <h2>{venue.name}</h2>
        <FollowButton venue={venue} size="md" />
      </div>

      <div className="details-content">
        <div className="venue-header-section">
          <div className="venue-title-section">
            <h1>{venue.name}</h1>
            <div className="venue-subtitle">
              <span>{venue.type}</span>
              <span className="separator">•</span>
              <span>{venue.distance}</span>
              <span className="separator">•</span>
              <span className={getCrowdColor(venue.crowdLevel)}>
                {getCrowdLabel(venue.crowdLevel)}
              </span>
            </div>
            <StarRating 
              rating={venue.rating} 
              size="lg" 
              showCount={true} 
              totalRatings={venue.totalRatings}
            />
          </div>
        </div>

        <FollowStats venue={venue} />

        {venue.hasPromotion && (
          <div className="promotion-section">
            <div className="promotion-card">
              <h3>🎉 Special Promotion</h3>
              <p>{venue.promotionText}</p>
            </div>
          </div>
        )}

        <div className="venue-info-section">
          <h3>Information</h3>
          <div className="info-grid">
            <div className="info-item">
              <MapPin className="info-icon" />
              <div>
                <div className="info-label">Address</div>
                <div className="info-value">{venue.address}</div>
              </div>
            </div>
            
            <div className="info-item">
              <Phone className="info-icon" />
              <div>
                <div className="info-label">Phone</div>
                <div className="info-value">{venue.phone}</div>
              </div>
            </div>
            
            <div className="info-item">
              <Clock className="info-icon" />
              <div>
                <div className="info-label">Hours</div>
                <div className="info-value">{venue.hours}</div>
              </div>
            </div>
            
            <div className="info-item">
              <Users className="info-icon" />
              <div>
                <div className="info-label">Wait Time</div>
                <div className="info-value">
                  {venue.waitTime > 0 ? `${venue.waitTime} minutes` : 'No wait'}
                </div>
              </div>
            </div>
          </div>
        </div>

        <div className="venue-vibe-section">
          <h3>Vibe</h3>
          <div className="vibe-tags">
            {venue.vibe.map((tag, index) => (
              <Badge key={index} variant="primary">
                {tag}
              </Badge>
            ))}
          </div>
        </div>

        <div className="action-buttons-section">
          <Button onClick={() => openGoogleMaps(venue)}>
            <MapPin className="w-4 h-4" />
            View on Maps
          </Button>
          <Button variant="secondary" onClick={() => getDirections(venue)}>
            <Navigation className="w-4 h-4" />
            Get Directions
          </Button>
          <Button variant="secondary" onClick={() => onShare(venue)}>
            <Share2 className="w-4 h-4" />
            Share
          </Button>
        </div>

        <div className="action-buttons-section">
          <Button 
            variant="warning" 
            onClick={() => actions.setShowRatingModal(true)}
          >
            <Star className="w-4 h-4" />
            Rate Venue
          </Button>
          <Button 
            variant="secondary" 
            onClick={() => actions.setShowReportModal(true)}
          >
            <Users className="w-4 h-4" />
            Report Status
          </Button>
        </div>

        {venue.reviews && venue.reviews.length > 0 && (
          <div className="reviews-section">
            <h3>Recent Reviews</h3>
            <div className="reviews-list">
              {venue.reviews.map((review) => (
                <div key={review.id} className="review-card">
                  <div className="review-header">
                    <div className="review-user">{review.user}</div>
                    <div className="review-rating">
                      <StarRating rating={review.rating} size="sm" />
                    </div>
                  </div>
                  <div className="review-comment">{review.comment}</div>
                  <div className="review-footer">
                    <span className="review-date">{review.date}</span>
                    <span className="review-helpful">👍 {review.helpful} helpful</span>
                  </div>
                </div>
              ))}
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

export default VenueDetailsView;
