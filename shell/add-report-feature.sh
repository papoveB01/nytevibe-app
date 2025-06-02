#!/bin/bash

# Add Venue Report Feature to nYtevibe
# Adds report status button and enhanced reporting functionality

echo "🔧 Adding Venue Report Feature to nYtevibe..."

# 1. Update VenueDetailsView to add Report Status button
echo "📝 Updating VenueDetailsView with Report Status button..."
cat > src/components/Views/VenueDetailsView.jsx << 'EOF'
import React from 'react';
import { ArrowLeft, MapPin, Clock, Phone, Star, Users, Share2, Navigation, AlertTriangle, ThumbsUp } from 'lucide-react';
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

  const handleRateVenue = () => {
    actions.setSelectedVenue(venue);
    actions.setShowRatingModal(true);
  };

  const handleReportStatus = () => {
    actions.setSelectedVenue(venue);
    actions.setShowReportModal(true);
  };

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
                <div className="info-label">Current Status</div>
                <div className="info-value">
                  <span className={getCrowdColor(venue.crowdLevel)}>
                    {getCrowdLabel(venue.crowdLevel)}
                  </span>
                  {venue.waitTime > 0 && (
                    <span className="ml-2 text-gray-600">• {venue.waitTime} min wait</span>
                  )}
                </div>
              </div>
            </div>

            <div className="info-item">
              <Clock className="info-icon" />
              <div>
                <div className="info-label">Last Updated</div>
                <div className="info-value text-gray-600">{venue.lastUpdate}</div>
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

        {/* Navigation & Share Actions */}
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

        {/* Community Actions */}
        <div className="community-actions-section">
          <h3>Help the Community</h3>
          <p className="community-subtitle">Share your experience and help others know what to expect!</p>
          
          <div className="action-buttons-section">
            <Button 
              variant="warning" 
              onClick={handleRateVenue}
              className="community-action-btn"
            >
              <Star className="w-4 h-4" />
              Rate Venue
              <span className="action-points">+5 pts</span>
            </Button>
            <Button 
              variant="primary" 
              onClick={handleReportStatus}
              className="community-action-btn report-btn"
            >
              <AlertTriangle className="w-4 h-4" />
              Report Status
              <span className="action-points">+10 pts</span>
            </Button>
          </div>
          
          <div className="community-stats">
            <div className="stat-box">
              <Users className="w-4 h-4 text-blue-500" />
              <span className="stat-number">{venue.reports}</span>
              <span className="stat-label">recent reports</span>
            </div>
            <div className="stat-box">
              <ThumbsUp className="w-4 h-4 text-green-500" />
              <span className="stat-number">{venue.confidence}%</span>
              <span className="stat-label">confidence</span>
            </div>
          </div>
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
EOF

# 2. Update ReportModal with enhanced functionality
echo "📝 Enhancing ReportModal with better UI and functionality..."
cat > src/components/Venue/ReportModal.jsx << 'EOF'
import React, { useState } from 'react';
import { Users, Clock, AlertTriangle, CheckCircle, X } from 'lucide-react';
import { useApp } from '../../context/AppContext';
import Modal from '../UI/Modal';
import Button from '../UI/Button';
import { getCrowdLabel, getCrowdColor } from '../../utils/helpers';

const ReportModal = () => {
  const { state, actions } = useApp();
  const [crowdLevel, setCrowdLevel] = useState(3);
  const [waitTime, setWaitTime] = useState(0);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [reportType, setReportType] = useState('status'); // 'status' or 'issue'

  const venue = state.selectedVenue;

  const handleSubmit = async () => {
    if (!venue) return;

    setIsSubmitting(true);
    
    // Simulate API call
    setTimeout(() => {
      if (reportType === 'status') {
        actions.reportVenue(venue.id, { crowdLevel, waitTime });
        actions.addNotification({
          type: 'success',
          message: `Thanks! Venue status updated successfully. You earned 10 points!`,
          duration: 4000
        });
      } else {
        actions.addNotification({
          type: 'success',
          message: `Thanks for reporting! We'll review this issue shortly.`,
          duration: 4000
        });
      }
      
      setIsSubmitting(false);
      handleClose();
    }, 1000);
  };

  const handleClose = () => {
    actions.setShowReportModal(false);
    setCrowdLevel(3);
    setWaitTime(0);
    setReportType('status');
    setIsSubmitting(false);
  };

  if (!venue) return null;

  return (
    <Modal
      isOpen={state.showReportModal}
      onClose={handleClose}
      title="Report Venue Status"
      maxWidth="max-w-lg"
    >
      <div className="report-modal-content">
        <div className="venue-info-header">
          <h4 className="venue-name">{venue.name}</h4>
          <p className="venue-location">{venue.type} • {venue.distance}</p>
        </div>

        <div className="report-type-selector">
          <h5>What would you like to report?</h5>
          <div className="report-type-buttons">
            <button
              onClick={() => setReportType('status')}
              className={`report-type-btn ${reportType === 'status' ? 'active' : ''}`}
            >
              <Users className="w-4 h-4" />
              <span>Update Status</span>
              <span className="points-badge">+10 pts</span>
            </button>
            <button
              onClick={() => setReportType('issue')}
              className={`report-type-btn ${reportType === 'issue' ? 'active' : ''}`}
            >
              <AlertTriangle className="w-4 h-4" />
              <span>Report Issue</span>
            </button>
          </div>
        </div>

        {reportType === 'status' && (
          <div className="status-report-section">
            <div className="form-group">
              <label className="form-label">
                <Users className="w-4 h-4" />
                How busy is it right now?
              </label>
              <div className="crowd-level-selector">
                {[1, 2, 3, 4, 5].map((level) => (
                  <button
                    key={level}
                    onClick={() => setCrowdLevel(level)}
                    className={`crowd-level-btn ${crowdLevel === level ? 'active' : ''}`}
                    data-level={level}
                  >
                    <div className={`crowd-indicator ${getCrowdColor(level).split(' ')[1]}`}></div>
                    <span>{getCrowdLabel(level)}</span>
                  </button>
                ))}
              </div>
            </div>

            <div className="form-group">
              <label className="form-label">
                <Clock className="w-4 h-4" />
                Current wait time (minutes)
              </label>
              <div className="wait-time-selector">
                <input
                  type="range"
                  min="0"
                  max="60"
                  value={waitTime}
                  onChange={(e) => setWaitTime(Number(e.target.value))}
                  className="wait-time-slider"
                />
                <div className="wait-time-display">
                  <span className="wait-time-value">{waitTime}</span>
                  <span className="wait-time-unit">minutes</span>
                </div>
              </div>
              <div className="wait-time-presets">
                {[0, 5, 10, 15, 30].map((time) => (
                  <button
                    key={time}
                    onClick={() => setWaitTime(time)}
                    className={`preset-btn ${waitTime === time ? 'active' : ''}`}
                  >
                    {time === 0 ? 'No wait' : `${time}m`}
                  </button>
                ))}
              </div>
            </div>
          </div>
        )}

        {reportType === 'issue' && (
          <div className="issue-report-section">
            <div className="form-group">
              <label className="form-label">What's the issue?</label>
              <div className="issue-options">
                <button className="issue-option-btn">
                  <X className="w-4 h-4" />
                  <span>Venue is closed</span>
                </button>
                <button className="issue-option-btn">
                  <AlertTriangle className="w-4 h-4" />
                  <span>Wrong information</span>
                </button>
                <button className="issue-option-btn">
                  <AlertTriangle className="w-4 h-4" />
                  <span>Safety concern</span>
                </button>
                <button className="issue-option-btn">
                  <AlertTriangle className="w-4 h-4" />
                  <span>Other issue</span>
                </button>
              </div>
            </div>
            <div className="form-group">
              <label className="form-label">Additional details (optional)</label>
              <textarea
                className="form-textarea"
                rows={3}
                placeholder="Describe the issue..."
              />
            </div>
          </div>
        )}

        <div className="modal-actions">
          <Button 
            onClick={handleSubmit} 
            disabled={isSubmitting}
            className="submit-btn"
          >
            {isSubmitting ? (
              <>
                <div className="spinner"></div>
                Submitting...
              </>
            ) : (
              <>
                <CheckCircle className="w-4 h-4" />
                {reportType === 'status' ? 'Update Status' : 'Report Issue'}
              </>
            )}
          </Button>
          <Button variant="secondary" onClick={handleClose} disabled={isSubmitting}>
            Cancel
          </Button>
        </div>

        <div className="report-help-text">
          <p>Your reports help keep venue information accurate and help other users make better decisions!</p>
        </div>
      </div>
    </Modal>
  );
};

export default ReportModal;
EOF

# 3. Update AppContext to handle reporting properly
echo "📝 Updating AppContext with enhanced reporting functionality..."
cat > src/context/AppContext.jsx << 'EOF'
import React, { createContext, useContext, useReducer, useCallback } from 'react';

const AppContext = createContext();

const initialState = {
  userProfile: {
    id: 'usr_12345',
    firstName: 'Papove',
    lastName: 'Bombando',
    username: 'papove_bombando',
    email: 'papove.bombando@example.com',
    phone: '+1 (713) 555-0199',
    avatar: null,
    points: 1247,
    level: 'Gold Explorer',
    levelTier: 'gold',
    memberSince: '2023',
    totalReports: 89,
    totalRatings: 156,
    totalFollows: 3,
    followedVenues: [1, 3, 4],
    badgesEarned: ['Early Bird', 'Community Helper', 'Venue Expert', 'Houston Local', 'Social Butterfly'],
    preferences: {
      notifications: true,
      privateProfile: false,
      shareLocation: true,
      pushNotifications: true,
      emailDigest: true,
      friendsCanSeeFollows: true
    },
    socialStats: {
      friendsCount: 24,
      sharedVenues: 12,
      receivedRecommendations: 8,
      sentRecommendations: 15
    },
    followLists: [
      {
        id: 'date-night',
        name: 'Date Night Spots',
        emoji: '💕',
        venueIds: [4],
        createdAt: '2024-01-15',
        isPublic: true
      },
      {
        id: 'sports-bars',
        name: 'Sports Bars',
        emoji: '🏈',
        venueIds: [3],
        createdAt: '2024-01-20',
        isPublic: true
      },
      {
        id: 'weekend-vibes',
        name: 'Weekend Vibes',
        emoji: '🎉',
        venueIds: [1],
        createdAt: '2024-02-01',
        isPublic: false
      },
      {
        id: 'hookah-spots',
        name: 'Hookah Lounges',
        emoji: '💨',
        venueIds: [6],
        createdAt: '2024-02-10',
        isPublic: true
      }
    ],
    followHistory: [
      {
        id: 'fh_001',
        venueId: 4,
        venueName: 'Best Regards',
        action: 'follow',
        timestamp: '2024-02-15T18:30:00Z',
        reason: 'Added to Date Night Spots list',
        listId: 'date-night'
      },
      {
        id: 'fh_002',
        venueId: 3,
        venueName: 'Classic',
        action: 'follow',
        timestamp: '2024-02-10T14:20:00Z',
        reason: 'Recommended by AI based on sports preferences'
      },
      {
        id: 'fh_003',
        venueId: 1,
        venueName: 'NYC Vibes',
        action: 'follow',
        timestamp: '2024-02-05T20:15:00Z',
        reason: 'Shared by friend @sarah_houston'
      }
    ]
  },
  venues: [
    {
      id: 1,
      name: "NYC Vibes",
      type: "Lounge",
      distance: "0.2 mi",
      crowdLevel: 4,
      waitTime: 15,
      lastUpdate: "2 min ago",
      vibe: ["Lively", "Hip-Hop"],
      confidence: 95,
      reports: 8,
      lat: 29.7604,
      lng: -95.3698,
      address: "1234 Main Street, Houston, TX 77002",
      city: "Houston",
      postcode: "77002",
      phone: "(713) 555-0123",
      hours: "Open until 2:00 AM",
      rating: 4.2,
      totalRatings: 127,
      ratingBreakdown: { 5: 48, 4: 39, 3: 25, 2: 12, 1: 3 },
      isOpen: true,
      trending: "stable",
      hasPromotion: true,
      promotionText: "Free Hookah for Ladies 6-10PM!",
      followersCount: 342,
      reviews: [
        { id: 1, user: "Mike R.", rating: 5, comment: "Amazing vibe and music! Perfect for a night out.", date: "2 days ago", helpful: 12 },
        { id: 2, user: "Sarah L.", rating: 4, comment: "Great atmosphere but can get really crowded.", date: "1 week ago", helpful: 8 },
        { id: 3, user: "James T.", rating: 5, comment: "Best hip-hop venue in Houston! Love the energy.", date: "2 weeks ago", helpful: 15 }
      ]
    },
    {
      id: 2,
      name: "Rumors",
      type: "Nightclub",
      distance: "0.4 mi",
      crowdLevel: 2,
      waitTime: 0,
      lastUpdate: "5 min ago",
      vibe: ["Chill", "R&B"],
      confidence: 87,
      reports: 12,
      lat: 29.7595,
      lng: -95.3697,
      address: "5678 Downtown Boulevard, Houston, TX 77003",
      city: "Houston",
      postcode: "77003",
      phone: "(713) 555-0456",
      hours: "Open until 3:00 AM",
      rating: 4.5,
      totalRatings: 89,
      ratingBreakdown: { 5: 42, 4: 28, 3: 12, 2: 5, 1: 2 },
      isOpen: true,
      trending: "stable",
      hasPromotion: true,
      promotionText: "R&B Night - 2-for-1 Cocktails!",
      followersCount: 128,
      reviews: [
        { id: 1, user: "Alex P.", rating: 5, comment: "Smooth R&B vibes and great cocktails!", date: "3 days ago", helpful: 9 },
        { id: 2, user: "Maria G.", rating: 4, comment: "Love the music selection, drinks are pricey though.", date: "5 days ago", helpful: 6 }
      ]
    },
    {
      id: 3,
      name: "Classic",
      type: "Bar & Grill",
      distance: "0.7 mi",
      crowdLevel: 5,
      waitTime: 30,
      lastUpdate: "1 min ago",
      vibe: ["Packed", "Sports"],
      confidence: 98,
      reports: 23,
      lat: 29.7586,
      lng: -95.3696,
      address: "9012 Sports Center Drive, Houston, TX 77004",
      city: "Houston",
      postcode: "77004",
      phone: "(713) 555-0789",
      hours: "Open until 1:00 AM",
      rating: 4.1,
      totalRatings: 203,
      ratingBreakdown: { 5: 67, 4: 81, 3: 32, 2: 18, 1: 5 },
      isOpen: true,
      trending: "stable",
      hasPromotion: true,
      promotionText: "Big Game Tonight! 50¢ Wings!",
      followersCount: 567,
      reviews: [
        { id: 1, user: "Tom B.", rating: 4, comment: "Great for watching games! Food is solid too.", date: "1 day ago", helpful: 14 },
        { id: 2, user: "Lisa K.", rating: 5, comment: "Best sports bar in the area. Always lively!", date: "3 days ago", helpful: 11 },
        { id: 3, user: "Dave M.", rating: 3, comment: "Can get too loud during big games.", date: "1 week ago", helpful: 7 }
      ]
    },
    {
      id: 4,
      name: "Best Regards",
      type: "Cocktail Bar",
      distance: "0.3 mi",
      crowdLevel: 3,
      waitTime: 20,
      lastUpdate: "8 min ago",
      vibe: ["Moderate", "Date Night"],
      confidence: 76,
      reports: 5,
      lat: 29.7577,
      lng: -95.3695,
      address: "3456 Uptown Plaza, Houston, TX 77005",
      city: "Houston",
      postcode: "77005",
      phone: "(713) 555-0321",
      hours: "Open until 12:00 AM",
      rating: 4.7,
      totalRatings: 156,
      ratingBreakdown: { 5: 89, 4: 47, 3: 15, 2: 3, 1: 2 },
      isOpen: true,
      trending: "stable",
      hasPromotion: true,
      promotionText: "DJ Chin Tonight! 9PM-2AM",
      followersCount: 234,
      reviews: [
        { id: 1, user: "Emma S.", rating: 5, comment: "Perfect date night spot! Cocktails are incredible.", date: "2 days ago", helpful: 18 },
        { id: 2, user: "Ryan C.", rating: 5, comment: "Classy atmosphere, amazing bartender skills.", date: "4 days ago", helpful: 13 },
        { id: 3, user: "Kate W.", rating: 4, comment: "Beautiful venue but a bit pricey for drinks.", date: "1 week ago", helpful: 9 }
      ]
    },
    {
      id: 5,
      name: "The Rooftop",
      type: "Rooftop Bar",
      distance: "0.5 mi",
      crowdLevel: 3,
      waitTime: 10,
      lastUpdate: "12 min ago",
      vibe: ["Trendy", "City Views"],
      confidence: 82,
      reports: 6,
      lat: 29.7588,
      lng: -95.3694,
      address: "7890 Skyline Avenue, Houston, TX 77006",
      city: "Houston",
      postcode: "77006",
      phone: "(713) 555-0999",
      hours: "Open until 1:00 AM",
      rating: 4.6,
      totalRatings: 98,
      ratingBreakdown: { 5: 52, 4: 31, 3: 10, 2: 3, 1: 2 },
      isOpen: true,
      trending: "up",
      hasPromotion: false,
      promotionText: "",
      followersCount: 189,
      reviews: [
        { id: 1, user: "Nina K.", rating: 5, comment: "Best city views in Houston! Great for photos.", date: "1 day ago", helpful: 16 },
        { id: 2, user: "Carlos M.", rating: 4, comment: "Amazing sunset views, drinks are expensive though.", date: "3 days ago", helpful: 9 }
      ]
    },
    {
      id: 6,
      name: "Red Sky Hookah Lounge & Bar",
      type: "Hookah Lounge",
      distance: "0.6 mi",
      crowdLevel: 4,
      waitTime: 25,
      lastUpdate: "3 min ago",
      vibe: ["Hookah", "Chill", "VIP", "Lively"],
      confidence: 91,
      reports: 14,
      lat: 29.7620,
      lng: -95.3710,
      address: "4567 Richmond Avenue, Houston, TX 77027",
      city: "Houston",
      postcode: "77027",
      phone: "(713) 555-0777",
      hours: "Open until 3:00 AM",
      rating: 4.4,
      totalRatings: 76,
      ratingBreakdown: { 5: 38, 4: 22, 3: 11, 2: 3, 1: 2 },
      isOpen: true,
      trending: "up",
      hasPromotion: true,
      promotionText: "Grand Opening: 50% Off Premium Hookah!",
      followersCount: 95,
      reviews: [
        { id: 1, user: "Ahmed K.", rating: 5, comment: "Best hookah in Houston! Premium quality and great atmosphere.", date: "1 day ago", helpful: 22 },
        { id: 2, user: "Jessica M.", rating: 4, comment: "Love the VIP lounge area. Great for groups and celebrations.", date: "2 days ago", helpful: 18 },
        { id: 3, user: "Papove B.", rating: 5, comment: "Finally, a quality hookah spot! Clean, modern, and excellent service.", date: "3 days ago", helpful: 15 },
        { id: 4, user: "Layla S.", rating: 4, comment: "Beautiful interior design and wide selection of flavors. A bit pricey but worth it.", date: "5 days ago", helpful: 12 }
      ]
    }
  ],
  notifications: [],
  currentView: 'home',
  selectedVenue: null,
  showRatingModal: false,
  showReportModal: false,
  showVenueDetails: false,
  friends: [
    {
      id: 'usr_98765',
      name: 'Sarah Martinez',
      username: 'sarah_houston',
      avatar: null,
      mutualFollows: 2,
      isOnline: true,
      lastSeen: 'now'
    },
    {
      id: 'usr_54321',
      name: 'David Chen',
      username: 'david_htx',
      avatar: null,
      mutualFollows: 1,
      isOnline: false,
      lastSeen: '2 hours ago'
    },
    {
      id: 'usr_11111',
      name: 'Lisa Rodriguez',
      username: 'lisa_nightlife',
      avatar: null,
      mutualFollows: 3,
      isOnline: true,
      lastSeen: 'now'
    }
  ]
};

const appReducer = (state, action) => {
  switch (action.type) {
    case 'SET_CURRENT_VIEW':
      return { ...state, currentView: action.payload };
    case 'SET_SELECTED_VENUE':
      return { ...state, selectedVenue: action.payload };
    case 'SET_SHOW_RATING_MODAL':
      return { ...state, showRatingModal: action.payload };
    case 'SET_SHOW_REPORT_MODAL':
      return { ...state, showReportModal: action.payload };
    case 'UPDATE_VENUE_DATA':
      return {
        ...state,
        venues: state.venues.map(venue => ({
          ...venue,
          crowdLevel: Math.max(1, Math.min(5, venue.crowdLevel + (Math.random() - 0.5))),
          waitTime: Math.max(0, venue.waitTime + Math.floor((Math.random() - 0.5) * 10)),
          lastUpdate: "Just now",
          confidence: Math.max(70, Math.min(98, venue.confidence + Math.floor((Math.random() - 0.5) * 10)))
        }))
      };
    case 'FOLLOW_VENUE':
      const { venueId, venueName } = action.payload;
      const newFollowedVenues = [...state.userProfile.followedVenues];
      if (!newFollowedVenues.includes(venueId)) {
        newFollowedVenues.push(venueId);
      }
      return {
        ...state,
        userProfile: {
          ...state.userProfile,
          followedVenues: newFollowedVenues,
          points: state.userProfile.points + 3,
          totalFollows: state.userProfile.totalFollows + 1
        },
        venues: state.venues.map(venue =>
          venue.id === venueId
            ? { ...venue, followersCount: venue.followersCount + 1 }
            : venue
        )
      };
    case 'UNFOLLOW_VENUE':
      const unfollowVenueId = action.payload.venueId;
      const filteredFollowedVenues = state.userProfile.followedVenues.filter(id => id !== unfollowVenueId);
      return {
        ...state,
        userProfile: {
          ...state.userProfile,
          followedVenues: filteredFollowedVenues,
          points: Math.max(0, state.userProfile.points - 2),
          totalFollows: Math.max(0, state.userProfile.totalFollows - 1)
        },
        venues: state.venues.map(venue =>
          venue.id === unfollowVenueId
            ? { ...venue, followersCount: Math.max(0, venue.followersCount - 1) }
            : venue
        )
      };
    case 'REPORT_VENUE':
      const { venueId: reportVenueId, reportData } = action.payload;
      return {
        ...state,
        venues: state.venues.map(venue => {
          if (venue.id === reportVenueId) {
            return {
              ...venue,
              crowdLevel: reportData.crowdLevel || venue.crowdLevel,
              waitTime: reportData.waitTime !== undefined ? reportData.waitTime : venue.waitTime,
              reports: venue.reports + 1,
              lastUpdate: "Just now",
              confidence: Math.min(98, venue.confidence + 5)
            };
          }
          return venue;
        }),
        userProfile: {
          ...state.userProfile,
          points: state.userProfile.points + 10,
          totalReports: state.userProfile.totalReports + 1
        }
      };
    case 'RATE_VENUE':
      const { venueId: rateVenueId, rating, comment } = action.payload;
      return {
        ...state,
        venues: state.venues.map(venue => {
          if (venue.id === rateVenueId) {
            const newTotalRatings = venue.totalRatings + 1;
            const newRating = ((venue.rating * venue.totalRatings) + rating) / newTotalRatings;
            return {
              ...venue,
              rating: Math.round(newRating * 10) / 10,
              totalRatings: newTotalRatings
            };
          }
          return venue;
        }),
        userProfile: {
          ...state.userProfile,
          points: state.userProfile.points + 5,
          totalRatings: state.userProfile.totalRatings + 1
        }
      };
    case 'ADD_NOTIFICATION':
      const notification = {
        id: Date.now(),
        type: action.payload.type || 'default',
        message: action.payload.message,
        duration: action.payload.duration || 3000,
        timestamp: Date.now()
      };
      return {
        ...state,
        notifications: [notification, ...state.notifications]
      };
    case 'REMOVE_NOTIFICATION':
      return {
        ...state,
        notifications: state.notifications.filter(n => n.id !== action.payload)
      };
    default:
      return state;
  }
};

export const AppProvider = ({ children }) => {
  const [state, dispatch] = useReducer(appReducer, initialState);

  const actions = {
    setCurrentView: useCallback((view) => {
      dispatch({ type: 'SET_CURRENT_VIEW', payload: view });
    }, []),
    setSelectedVenue: useCallback((venue) => {
      dispatch({ type: 'SET_SELECTED_VENUE', payload: venue });
    }, []),
    setShowRatingModal: useCallback((show) => {
      dispatch({ type: 'SET_SHOW_RATING_MODAL', payload: show });
    }, []),
    setShowReportModal: useCallback((show) => {
      dispatch({ type: 'SET_SHOW_REPORT_MODAL', payload: show });
    }, []),
    updateVenueData: useCallback(() => {
      dispatch({ type: 'UPDATE_VENUE_DATA' });
    }, []),
    followVenue: useCallback((venueId, venueName) => {
      dispatch({ type: 'FOLLOW_VENUE', payload: { venueId, venueName } });
    }, []),
    unfollowVenue: useCallback((venueId, venueName) => {
      dispatch({ type: 'UNFOLLOW_VENUE', payload: { venueId, venueName } });
    }, []),
    reportVenue: useCallback((venueId, reportData) => {
      dispatch({ type: 'REPORT_VENUE', payload: { venueId, reportData } });
    }, []),
    rateVenue: useCallback((venueId, rating, comment) => {
      dispatch({ type: 'RATE_VENUE', payload: { venueId, rating, comment } });
    }, []),
    addNotification: useCallback((notification) => {
      dispatch({ type: 'ADD_NOTIFICATION', payload: notification });
    }, []),
    removeNotification: useCallback((id) => {
      dispatch({ type: 'REMOVE_NOTIFICATION', payload: id });
    }, [])
  };

  return (
    <AppContext.Provider value={{ state, actions }}>
      {children}
    </AppContext.Provider>
  );
};

export const useApp = () => {
  const context = useContext(AppContext);
  if (!context) {
    throw new Error('useApp must be used within an AppProvider');
  }
  return context;
};
EOF

# 4. Add CSS for the new report modal styling
echo "📝 Adding CSS for enhanced report modal styling..."
cat >> src/App.css << 'EOF'

/* Community Actions Section */
.community-actions-section {
  background: #ffffff;
  padding: 20px;
  border-radius: 16px;
  margin-bottom: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  border-left: 4px solid #3b82f6;
}

.community-actions-section h3 {
  color: #1f2937;
  font-weight: 600;
  margin-bottom: 8px;
  display: flex;
  align-items: center;
  gap: 8px;
}

.community-subtitle {
  color: #6b7280;
  font-size: 0.875rem;
  margin-bottom: 16px;
  line-height: 1.5;
}

.community-action-btn {
  position: relative;
  flex-direction: column;
  height: auto;
  padding: 16px 20px;
  text-align: center;
  gap: 8px;
}

.report-btn {
  background: linear-gradient(135deg, #3b82f6, #2563eb);
  border: 2px solid #3b82f6;
}

.report-btn:hover {
  background: linear-gradient(135deg, #2563eb, #1d4ed8);
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(59, 130, 246, 0.4);
}

.action-points {
  font-size: 0.75rem;
  background: rgba(255, 255, 255, 0.2);
  padding: 2px 8px;
  border-radius: 12px;
  font-weight: 600;
}

.community-stats {
  display: flex;
  gap: 16px;
  margin-top: 16px;
  padding-top: 16px;
  border-top: 1px solid #e5e7eb;
}

.stat-box {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 8px 12px;
  background: #f8fafc;
  border-radius: 8px;
  flex: 1;
}

.stat-number {
  font-weight: 700;
  color: #1f2937;
}

.stat-label {
  font-size: 0.75rem;
  color: #6b7280;
}

/* Report Modal Styles */
.report-modal-content {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.venue-info-header {
  text-align: center;
  padding-bottom: 16px;
  border-bottom: 1px solid #e5e7eb;
}

.venue-info-header .venue-name {
  font-size: 1.125rem;
  font-weight: 700;
  color: #1f2937;
  margin: 0 0 4px 0;
}

.venue-info-header .venue-location {
  color: #6b7280;
  font-size: 0.875rem;
  margin: 0;
}

.report-type-selector h5 {
  font-weight: 600;
  color: #1f2937;
  margin-bottom: 12px;
}

.report-type-buttons {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 12px;
}

.report-type-btn {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
  padding: 16px 12px;
  border: 2px solid #e5e7eb;
  border-radius: 12px;
  background: #ffffff;
  color: #6b7280;
  cursor: pointer;
  transition: all 0.2s ease;
  position: relative;
}

.report-type-btn:hover {
  border-color: #d1d5db;
  background: #f9fafb;
}

.report-type-btn.active {
  border-color: #3b82f6;
  background: #eff6ff;
  color: #3b82f6;
}

.points-badge {
  position: absolute;
  top: -6px;
  right: -6px;
  background: #10b981;
  color: white;
  font-size: 0.625rem;
  font-weight: 600;
  padding: 2px 6px;
  border-radius: 10px;
  line-height: 1;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.form-label {
  display: flex;
  align-items: center;
  gap: 8px;
  font-weight: 600;
  color: #374151;
  font-size: 0.875rem;
}

.crowd-level-selector {
  display: grid;
  grid-template-columns: repeat(5, 1fr);
  gap: 8px;
}

.crowd-level-btn {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 6px;
  padding: 12px 8px;
  border: 2px solid #e5e7eb;
  border-radius: 10px;
  background: #ffffff;
  cursor: pointer;
  transition: all 0.2s ease;
  font-size: 0.75rem;
  color: #6b7280;
}

.crowd-level-btn:hover {
  border-color: #d1d5db;
  background: #f9fafb;
}

.crowd-level-btn.active {
  border-color: #3b82f6;
  background: #eff6ff;
  color: #3b82f6;
}

.crowd-indicator {
  width: 20px;
  height: 20px;
  border-radius: 50%;
  background: #e5e7eb;
}

.crowd-indicator.badge-green {
  background: linear-gradient(135deg, #10b981, #059669);
}

.crowd-indicator.badge-yellow {
  background: linear-gradient(135deg, #f59e0b, #d97706);
}

.crowd-indicator.badge-red {
  background: linear-gradient(135deg, #ef4444, #dc2626);
}

.wait-time-selector {
  display: flex;
  align-items: center;
  gap: 16px;
}

.wait-time-slider {
  flex: 1;
  height: 6px;
  border-radius: 3px;
  background: #e5e7eb;
  outline: none;
  cursor: pointer;
}

.wait-time-slider::-webkit-slider-thumb {
  appearance: none;
  width: 20px;
  height: 20px;
  border-radius: 50%;
  background: #3b82f6;
  cursor: pointer;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
}

.wait-time-slider::-moz-range-thumb {
  width: 20px;
  height: 20px;
  border-radius: 50%;
  background: #3b82f6;
  cursor: pointer;
  border: none;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
}

.wait-time-display {
  display: flex;
  flex-direction: column;
  align-items: center;
  min-width: 60px;
}

.wait-time-value {
  font-size: 1.5rem;
  font-weight: 700;
  color: #1f2937;
}

.wait-time-unit {
  font-size: 0.75rem;
  color: #6b7280;
}

.wait-time-presets {
  display: flex;
  gap: 8px;
  margin-top: 12px;
}

.preset-btn {
  padding: 6px 12px;
  border: 1px solid #e5e7eb;
  border-radius: 20px;
  background: #ffffff;
  color: #6b7280;
  font-size: 0.75rem;
  cursor: pointer;
  transition: all 0.2s ease;
}

.preset-btn:hover {
  border-color: #d1d5db;
  background: #f9fafb;
}

.preset-btn.active {
  border-color: #3b82f6;
  background: #3b82f6;
  color: white;
}

.issue-options {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 12px;
}

.issue-option-btn {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 12px 16px;
  border: 2px solid #e5e7eb;
  border-radius: 10px;
  background: #ffffff;
  color: #6b7280;
  cursor: pointer;
  transition: all 0.2s ease;
  font-size: 0.875rem;
}

.issue-option-btn:hover {
  border-color: #d1d5db;
  background: #f9fafb;
}

.issue-option-btn.active {
  border-color: #ef4444;
  background: #fef2f2;
  color: #ef4444;
}

.form-textarea {
  width: 100%;
  padding: 12px;
  border: 2px solid #e2e8f0;
  border-radius: 8px;
  background: #ffffff;
  color: #1e293b;
  font-family: inherit;
  font-size: 0.875rem;
  transition: all 0.2s ease;
  resize: vertical;
  min-height: 80px;
}

.form-textarea:focus {
  outline: none;
  border-color: #3b82f6;
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}

.modal-actions {
  display: flex;
  gap: 12px;
  padding-top: 16px;
  border-top: 1px solid #e5e7eb;
}

.submit-btn {
  flex: 1;
}

.spinner {
  width: 16px;
  height: 16px;
  border: 2px solid transparent;
  border-top: 2px solid currentColor;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

.report-help-text {
  background: #f8fafc;
  padding: 12px;
  border-radius: 8px;
  border-left: 3px solid #3b82f6;
}

.report-help-text p {
  color: #6b7280;
  font-size: 0.875rem;
  margin: 0;
  line-height: 1.5;
}

/* Mobile Responsive for Report Modal */
@media (max-width: 768px) {
  .report-type-buttons {
    grid-template-columns: 1fr;
  }
  
  .crowd-level-selector {
    grid-template-columns: repeat(3, 1fr);
  }
  
  .issue-options {
    grid-template-columns: 1fr;
  }
  
  .wait-time-selector {
    flex-direction: column;
    gap: 12px;
  }
  
  .modal-actions {
    flex-direction: column;
  }
}

@media (max-width: 480px) {
  .community-stats {
    flex-direction: column;
  }
  
  .crowd-level-selector {
    grid-template-columns: repeat(2, 1fr);
  }
}
EOF

echo "✅ Venue Report Feature Added Successfully!"
echo ""
echo "🎯 New Features Added:"
echo "   ✅ Report Status button in venue details view"
echo "   ✅ Enhanced ReportModal with crowd level and wait time sliders"
echo "   ✅ Issue reporting functionality"
echo "   ✅ Points system integration (+10 pts for reports)"
echo "   ✅ Community actions section with statistics"
echo "   ✅ Professional styling matching app design"
echo ""
echo "📱 Report Modal Features:"
echo "   • Interactive crowd level selector (Empty to Packed)"
echo "   • Wait time slider with preset buttons"
echo "   • Issue reporting for venue problems"
echo "   • Real-time feedback and point rewards"
echo "   • Mobile-responsive design"
echo ""
echo "🚀 To apply the updates:"
echo "   1. Run this script in your nytevibe project directory"
echo "   2. The app will now have enhanced reporting functionality"
echo "   3. Users can report venue status and earn points"
echo ""
echo "🎨 Styling includes:"
echo "   • Consistent button design with existing app"
echo "   • Point badges showing rewards"
echo "   • Interactive sliders and selectors"
echo "   • Community stats display"
echo "   • Professional modal layout"
EOF
