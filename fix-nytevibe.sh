#!/bin/bash

# nYtevibe Complete Fix Script
# Fixes all display issues: profile, menus, carousel, venue list, and details

echo "🔧 Fixing nYtevibe Display Issues..."

# Create missing UserProfile component
echo "📝 Creating UserProfile component..."
mkdir -p src/components/User
cat > src/components/User/UserProfile.jsx << 'EOF'
import React from 'react';
import { User, Trophy, Star, Heart } from 'lucide-react';
import { useApp } from '../../context/AppContext';
import { getLevelColor, getLevelIcon } from '../../utils/helpers';

const UserProfile = () => {
  const { state } = useApp();
  const { userProfile } = state;

  return (
    <div className="user-profile-header">
      <div className="profile-avatar">
        {userProfile.avatar ? (
          <img src={userProfile.avatar} alt="Profile" className="avatar-image" />
        ) : (
          <div className="avatar-placeholder">
            <User className="w-6 h-6 text-white" />
          </div>
        )}
      </div>
      
      <div className="profile-info">
        <div className="profile-name">
          {userProfile.firstName} {userProfile.lastName}
        </div>
        <div className="profile-level">
          <span className="level-icon">{getLevelIcon(userProfile.levelTier)}</span>
          <span className="level-text" style={{ color: getLevelColor(userProfile.levelTier) }}>
            {userProfile.level}
          </span>
          <span className="points-text">{userProfile.points} pts</span>
        </div>
      </div>
      
      <div className="profile-stats">
        <div className="stat-item">
          <Heart className="w-4 h-4 text-red-500" />
          <span>{userProfile.totalFollows}</span>
        </div>
        <div className="stat-item">
          <Star className="w-4 h-4 text-yellow-500" />
          <span>{userProfile.totalRatings}</span>
        </div>
        <div className="stat-item">
          <Trophy className="w-4 h-4 text-blue-500" />
          <span>{userProfile.totalReports}</span>
        </div>
      </div>
    </div>
  );
};

export default UserProfile;
EOF

# Create missing Badge component
echo "📝 Creating Badge component..."
mkdir -p src/components/UI
cat > src/components/UI/Badge.jsx << 'EOF'
import React from 'react';

const Badge = ({ children, variant = 'primary', className = '' }) => {
  const variantClasses = {
    primary: 'badge badge-primary',
    green: 'badge badge-green',
    yellow: 'badge badge-yellow',
    red: 'badge badge-red',
    blue: 'badge badge-blue'
  };

  return (
    <span className={`${variantClasses[variant]} ${className}`}>
      {children}
    </span>
  );
};

export default Badge;
EOF

# Create missing FollowButton component
echo "📝 Creating FollowButton component..."
mkdir -p src/components/Follow
cat > src/components/Follow/FollowButton.jsx << 'EOF'
import React from 'react';
import { Heart, Plus } from 'lucide-react';
import { useVenues } from '../../hooks/useVenues';

const FollowButton = ({ venue, size = 'md', showCount = false }) => {
  const { isVenueFollowed, toggleFollow } = useVenues();
  const followed = isVenueFollowed(venue.id);

  const handleClick = (e) => {
    e.stopPropagation();
    toggleFollow(venue);
  };

  return (
    <button
      onClick={handleClick}
      className={`follow-button ${followed ? 'followed' : ''}`}
      title={followed ? 'Unfollow venue' : 'Follow venue'}
    >
      {followed ? (
        <Heart className="follow-icon filled w-5 h-5" />
      ) : (
        <Plus className="follow-icon outline w-5 h-5" />
      )}
      {showCount && venue.followersCount > 0 && (
        <span className="follow-count">{venue.followersCount}</span>
      )}
    </button>
  );
};

export default FollowButton;
EOF

# Create missing FollowStats component
echo "📝 Creating FollowStats component..."
cat > src/components/Follow/FollowStats.jsx << 'EOF'
import React from 'react';
import { Users, Heart, TrendingUp } from 'lucide-react';
import { useVenues } from '../../hooks/useVenues';

const FollowStats = ({ venue }) => {
  const { isVenueFollowed } = useVenues();
  const followed = isVenueFollowed(venue.id);

  return (
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
      
      {followed && (
        <div className="follow-stat you-follow">
          <Heart className="stat-icon" />
          <span className="stat-text">You follow this venue</span>
        </div>
      )}
    </div>
  );
};

export default FollowStats;
EOF

# Create PromotionalCarousel component
echo "📝 Creating PromotionalCarousel component..."
cat > src/components/Layout/PromotionalCarousel.jsx << 'EOF'
import React, { useState, useEffect } from 'react';
import { ChevronLeft, ChevronRight } from 'lucide-react';
import PromotionalBanner from './PromotionalBanner';
import { PROMOTIONAL_BANNERS } from '../../constants';

const PromotionalCarousel = () => {
  const [currentIndex, setCurrentIndex] = useState(0);
  const [isAutoPlaying, setIsAutoPlaying] = useState(true);

  useEffect(() => {
    if (!isAutoPlaying) return;
    
    const interval = setInterval(() => {
      setCurrentIndex((prev) => (prev + 1) % PROMOTIONAL_BANNERS.length);
    }, 4000);

    return () => clearInterval(interval);
  }, [isAutoPlaying]);

  const goToPrevious = () => {
    setCurrentIndex((prev) => 
      prev === 0 ? PROMOTIONAL_BANNERS.length - 1 : prev - 1
    );
    setIsAutoPlaying(false);
  };

  const goToNext = () => {
    setCurrentIndex((prev) => (prev + 1) % PROMOTIONAL_BANNERS.length);
    setIsAutoPlaying(false);
  };

  const currentBanner = PROMOTIONAL_BANNERS[currentIndex];

  return (
    <div className="promotional-carousel">
      <div className="carousel-container">
        <button 
          onClick={goToPrevious}
          className="carousel-nav carousel-nav-left"
          aria-label="Previous promotion"
        >
          <ChevronLeft className="w-5 h-5" />
        </button>

        <div className="carousel-content">
          <PromotionalBanner 
            banner={currentBanner}
            onClick={() => console.log('Banner clicked:', currentBanner.title)}
          />
        </div>

        <button 
          onClick={goToNext}
          className="carousel-nav carousel-nav-right"
          aria-label="Next promotion"
        >
          <ChevronRight className="w-5 h-5" />
        </button>
      </div>

      <div className="carousel-indicators">
        {PROMOTIONAL_BANNERS.map((_, index) => (
          <button
            key={index}
            onClick={() => {
              setCurrentIndex(index);
              setIsAutoPlaying(false);
            }}
            className={`carousel-indicator ${index === currentIndex ? 'active' : ''}`}
            aria-label={`Go to promotion ${index + 1}`}
          />
        ))}
      </div>
    </div>
  );
};

export default PromotionalCarousel;
EOF

# Create VenueList component
echo "📝 Creating VenueList component..."
mkdir -p src/components/Venue
cat > src/components/Venue/VenueList.jsx << 'EOF'
import React from 'react';
import VenueCard from './VenueCard';

const VenueList = ({ venues, searchQuery, onVenueClick, onShare }) => {
  if (!venues || venues.length === 0) {
    return (
      <div className="empty-state">
        <div className="empty-state-content">
          <h3>No venues found</h3>
          <p>Try adjusting your search or filters to find venues.</p>
        </div>
      </div>
    );
  }

  return (
    <div className="venue-list">
      <div className="venues-grid">
        {venues.map((venue) => (
          <VenueCard
            key={venue.id}
            venue={venue}
            searchQuery={searchQuery}
            onClick={onVenueClick}
            onShare={onShare}
          />
        ))}
      </div>
    </div>
  );
};

export default VenueList;
EOF

# Create VenueDetails component
echo "📝 Creating VenueDetails component..."
cat > src/components/Venue/VenueDetails.jsx << 'EOF'
import React from 'react';
import { ArrowLeft, MapPin, Clock, Phone, Star, Users, Share2, Navigation } from 'lucide-react';
import { useApp } from '../../context/AppContext';
import FollowButton from '../Follow/FollowButton';
import FollowStats from '../Follow/FollowStats';
import StarRating from './StarRating';
import Badge from '../UI/Badge';
import { getCrowdLabel, getCrowdColor, openGoogleMaps, getDirections } from '../../utils/helpers';

const VenueDetails = () => {
  const { state, actions } = useApp();
  const { selectedVenue } = state;

  if (!selectedVenue) {
    return (
      <div className="venue-details-view">
        <div className="details-header">
          <button 
            onClick={() => actions.setCurrentView('home')}
            className="back-button"
          >
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

  const venue = selectedVenue;

  const handleBack = () => {
    actions.setCurrentView('home');
    actions.setSelectedVenue(null);
  };

  return (
    <div className="venue-details-view">
      <div className="details-header">
        <button onClick={handleBack} className="back-button">
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
          <button 
            onClick={() => openGoogleMaps(venue)}
            className="btn btn-primary"
          >
            <MapPin className="w-4 h-4" />
            View on Maps
          </button>
          <button 
            onClick={() => getDirections(venue)}
            className="btn btn-secondary"
          >
            <Navigation className="w-4 h-4" />
            Get Directions
          </button>
          <button 
            onClick={() => console.log('Share venue:', venue.name)}
            className="btn btn-secondary"
          >
            <Share2 className="w-4 h-4" />
            Share
          </button>
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

export default VenueDetails;
EOF

# Create FilterBar component
echo "📝 Creating FilterBar component..."
cat > src/components/Layout/FilterBar.jsx << 'EOF'
import React from 'react';
import { Filter, Heart, MapPin, Clock, Gift } from 'lucide-react';

const FilterBar = ({ activeFilter, onFilterChange }) => {
  const filters = [
    { id: 'all', label: 'All Venues', icon: Filter },
    { id: 'followed', label: 'Following', icon: Heart },
    { id: 'nearby', label: 'Nearby', icon: MapPin },
    { id: 'open', label: 'Open Now', icon: Clock },
    { id: 'promotions', label: 'Promotions', icon: Gift }
  ];

  return (
    <div className="filter-bar">
      <div className="filter-scroll">
        {filters.map((filter) => {
          const IconComponent = filter.icon;
          return (
            <button
              key={filter.id}
              onClick={() => onFilterChange(filter.id)}
              className={`filter-button ${activeFilter === filter.id ? 'active' : ''}`}
            >
              <IconComponent className="w-4 h-4" />
              <span>{filter.label}</span>
            </button>
          );
        })}
      </div>
    </div>
  );
};

export default FilterBar;
EOF

# Create NotificationSystem component
echo "📝 Creating NotificationSystem component..."
cat > src/components/Layout/NotificationSystem.jsx << 'EOF'
import React from 'react';
import { X, CheckCircle, AlertCircle, Heart, Info } from 'lucide-react';
import { useNotifications } from '../../hooks/useNotifications';

const NotificationSystem = () => {
  const { notifications, removeNotification } = useNotifications();

  const getNotificationIcon = (type) => {
    switch (type) {
      case 'success':
        return <CheckCircle className="w-5 h-5 text-green-500" />;
      case 'error':
        return <AlertCircle className="w-5 h-5 text-red-500" />;
      case 'follow':
        return <Heart className="w-5 h-5 text-red-500" />;
      case 'unfollow':
        return <Heart className="w-5 h-5 text-gray-500" />;
      default:
        return <Info className="w-5 h-5 text-blue-500" />;
    }
  };

  if (notifications.length === 0) return null;

  return (
    <div className="notification-container">
      {notifications.map((notification) => (
        <div
          key={notification.id}
          className={`notification notification-${notification.type}`}
        >
          <div className="notification-content">
            {getNotificationIcon(notification.type)}
            <span className="notification-message">{notification.message}</span>
            <button
              onClick={() => removeNotification(notification.id)}
              className="notification-close"
            >
              <X className="w-4 h-4" />
            </button>
          </div>
        </div>
      ))}
    </div>
  );
};

export default NotificationSystem;
EOF

# Fix the main App.jsx with proper structure
echo "📝 Fixing main App.jsx structure..."
cat > src/App.jsx << 'EOF'
import React, { useEffect } from 'react';
import { AppProvider, useApp } from './context/AppContext';
import Header from './components/Layout/Header';
import PromotionalCarousel from './components/Layout/PromotionalCarousel';
import FilterBar from './components/Layout/FilterBar';
import VenueList from './components/Venue/VenueList';
import VenueDetails from './components/Venue/VenueDetails';
import NotificationSystem from './components/Layout/NotificationSystem';
import { useVenues } from './hooks/useVenues';
import { shareVenue } from './utils/helpers';
import { UPDATE_INTERVALS } from './constants';
import './App.css';

const AppContent = () => {
  const { state, actions } = useApp();
  const { searchVenues, updateVenueData } = useVenues();
  
  const {
    currentView,
    searchQuery,
    venueFilter,
    selectedVenue
  } = state;

  // Auto-update venue data every 45 seconds
  useEffect(() => {
    const interval = setInterval(() => {
      updateVenueData();
    }, UPDATE_INTERVALS.VENUE_DATA);

    return () => clearInterval(interval);
  }, [updateVenueData]);

  // Get filtered venues
  const filteredVenues = searchVenues(searchQuery, venueFilter);

  const handleShare = (venue) => {
    shareVenue(venue, 'copy');
    actions.addNotification({
      type: 'success',
      message: `${venue.name} link copied to clipboard!`,
      duration: UPDATE_INTERVALS.NOTIFICATION_DURATION
    });
  };

  const handleClearSearch = () => {
    actions.setSearchQuery('');
  };

  // Render based on current view
  const renderContent = () => {
    switch (currentView) {
      case 'detail':
        return <VenueDetails />;
      case 'home':
      default:
        return (
          <div className="home-view">
            <PromotionalCarousel />
            <FilterBar 
              activeFilter={venueFilter}
              onFilterChange={actions.setVenueFilter}
            />
            <div className="home-content">
              <VenueList
                venues={filteredVenues}
                searchQuery={searchQuery}
                onShare={handleShare}
              />
              {filteredVenues.length === 0 && searchQuery && (
                <div className="no-results">
                  <h3>No venues found for "{searchQuery}"</h3>
                  <p>Try a different search term or clear your search to see all venues.</p>
                  <button onClick={handleClearSearch} className="btn btn-primary">
                    Clear Search
                  </button>
                </div>
              )}
            </div>
          </div>
        );
    }
  };

  return (
    <div className="app-layout">
      <Header 
        searchQuery={searchQuery}
        setSearchQuery={actions.setSearchQuery}
        onClearSearch={handleClearSearch}
      />
      
      <div className="content-frame">
        {renderContent()}
      </div>

      <NotificationSystem />
    </div>
  );
};

const App = () => {
  return (
    <AppProvider>
      <AppContent />
    </AppProvider>
  );
};

export default App;
EOF

# Add missing CSS for new components
echo "📝 Adding CSS for new components..."
cat >> src/App.css << 'EOF'

/* User Profile Header Styles */
.user-profile-header {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 16px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 12px;
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.profile-avatar {
  position: relative;
}

.avatar-image {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  object-fit: cover;
  border: 2px solid rgba(255, 255, 255, 0.3);
}

.avatar-placeholder {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  background: linear-gradient(135deg, #6b7280, #4b5563);
  display: flex;
  align-items: center;
  justify-content: center;
  border: 2px solid rgba(255, 255, 255, 0.3);
}

.profile-info {
  flex: 1;
  min-width: 0;
}

.profile-name {
  font-weight: 700;
  color: white;
  font-size: 1rem;
  margin-bottom: 2px;
}

.profile-level {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 0.875rem;
}

.level-icon {
  font-size: 1rem;
}

.level-text {
  font-weight: 600;
}

.points-text {
  color: rgba(255, 255, 255, 0.8);
  font-size: 0.75rem;
}

.profile-stats {
  display: flex;
  gap: 12px;
}

.stat-item {
  display: flex;
  align-items: center;
  gap: 4px;
  background: rgba(255, 255, 255, 0.1);
  padding: 4px 8px;
  border-radius: 8px;
  font-size: 0.75rem;
  color: white;
  font-weight: 500;
}

/* Promotional Carousel Styles */
.promotional-carousel {
  margin-bottom: 20px;
}

.carousel-container {
  position: relative;
  display: flex;
  align-items: center;
  gap: 12px;
}

.carousel-content {
  flex: 1;
  overflow: hidden;
}

.carousel-nav {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 40px;
  height: 40px;
  border-radius: 50%;
  border: 2px solid #e2e8f0;
  background: #ffffff;
  color: #64748b;
  cursor: pointer;
  transition: all 0.2s ease;
  flex-shrink: 0;
}

.carousel-nav:hover {
  background: #f8fafc;
  border-color: #cbd5e1;
  color: #475569;
  transform: scale(1.05);
}

.carousel-indicators {
  display: flex;
  justify-content: center;
  gap: 8px;
  margin-top: 12px;
}

.carousel-indicator {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  border: none;
  background: #cbd5e1;
  cursor: pointer;
  transition: all 0.2s ease;
}

.carousel-indicator.active {
  background: #3b82f6;
  transform: scale(1.2);
}

.carousel-indicator:hover {
  background: #94a3b8;
}

/* Filter Bar Styles */
.filter-bar {
  margin-bottom: 20px;
  overflow-x: auto;
  scrollbar-width: none;
  -ms-overflow-style: none;
}

.filter-bar::-webkit-scrollbar {
  display: none;
}

.filter-scroll {
  display: flex;
  gap: 12px;
  padding: 4px 0;
  min-width: max-content;
}

.filter-button {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 8px 16px;
  border: 2px solid #e5e7eb;
  border-radius: 12px;
  background: #ffffff;
  color: #6b7280;
  font-size: 0.875rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;
  white-space: nowrap;
  flex-shrink: 0;
}

.filter-button:hover {
  border-color: #d1d5db;
  background: #f9fafb;
  color: #374151;
}

.filter-button.active {
  border-color: #3b82f6;
  background: #eff6ff;
  color: #3b82f6;
}

/* Empty State Styles */
.empty-state {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 300px;
  text-align: center;
}

.empty-state-content h3 {
  color: #374151;
  font-size: 1.25rem;
  font-weight: 600;
  margin-bottom: 8px;
}

.empty-state-content p {
  color: #6b7280;
  font-size: 0.875rem;
}

/* No Results Styles */
.no-results {
  text-align: center;
  padding: 60px 20px;
  background: #ffffff;
  border-radius: 16px;
  margin-top: 20px;
}

.no-results h3 {
  color: #374151;
  font-size: 1.25rem;
  font-weight: 600;
  margin-bottom: 8px;
}

.no-results p {
  color: #6b7280;
  margin-bottom: 20px;
}

/* Venue Details Styles */
.venue-details-view {
  min-height: 100vh;
  background: #f8fafc;
}

.details-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px 20px;
  background: #ffffff;
  border-bottom: 1px solid #e2e8f0;
  position: sticky;
  top: 0;
  z-index: 100;
}

.details-header h2 {
  color: #1e293b;
  font-weight: 700;
  margin: 0;
  flex: 1;
  text-align: center;
}

.back-button {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 40px;
  height: 40px;
  border-radius: 50%;
  border: 2px solid #e2e8f0;
  background: #f8fafc;
  color: #64748b;
  cursor: pointer;
  transition: all 0.2s ease;
}

.back-button:hover {
  background: #e2e8f0;
  border-color: #cbd5e1;
  color: #475569;
}

.details-content {
  padding: 20px;
  max-width: 800px;
  margin: 0 auto;
}

.venue-header-section {
  background: #ffffff;
  padding: 24px;
  border-radius: 16px;
  margin-bottom: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.venue-title-section h1 {
  font-size: 1.75rem;
  font-weight: 700;
  color: #1f2937;
  margin-bottom: 8px;
}

.venue-subtitle {
  color: #6b7280;
  font-size: 1rem;
  margin-bottom: 12px;
  display: flex;
  align-items: center;
  gap: 8px;
}

.separator {
  color: #d1d5db;
}

.promotion-section {
  margin-bottom: 20px;
}

.promotion-card {
  background: linear-gradient(135deg, #fef3c7, #fde68a);
  border: 1px solid #f59e0b;
  border-radius: 12px;
  padding: 16px;
}

.promotion-card h3 {
  color: #92400e;
  font-weight: 600;
  margin-bottom: 8px;
}

.promotion-card p {
  color: #b45309;
  margin: 0;
}

.venue-info-section {
  background: #ffffff;
  padding: 20px;
  border-radius: 16px;
  margin-bottom: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.venue-info-section h3 {
  color: #1f2937;
  font-weight: 600;
  margin-bottom: 16px;
}

.info-grid {
  display: grid;
  gap: 16px;
}

.info-item {
  display: flex;
  align-items: flex-start;
  gap: 12px;
}

.info-icon {
  width: 20px;
  height: 20px;
  color: #6b7280;
  flex-shrink: 0;
  margin-top: 2px;
}

.info-label {
  font-size: 0.75rem;
  color: #6b7280;
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.info-value {
  color: #1f2937;
  font-weight: 500;
}

.vibe-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.action-buttons-section {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
  gap: 12px;
  margin-bottom: 20px;
}

.reviews-section {
  background: #ffffff;
  padding: 20px;
  border-radius: 16px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.reviews-section h3 {
  color: #1f2937;
  font-weight: 600;
  margin-bottom: 16px;
}

.reviews-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.review-card {
  border: 1px solid #e5e7eb;
  border-radius: 12px;
  padding: 16px;
  background: #f9fafb;
}

.review-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
}

.review-user {
  font-weight: 600;
  color: #1f2937;
}

.review-comment {
  color: #374151;
  margin-bottom: 8px;
  line-height: 1.5;
}

.review-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 0.75rem;
  color: #6b7280;
}

.review-helpful {
  display: flex;
  align-items: center;
  gap: 4px;
}

/* Notification Styles */
.notification-container {
  position: fixed;
  top: 20px;
  right: 20px;
  z-index: 1000;
  display: flex;
  flex-direction: column;
  gap: 12px;
  max-width: 400px;
}

.notification {
  background: #ffffff;
  border-radius: 12px;
  padding: 12px 16px;
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
  border-left: 4px solid;
  animation: slideInRight 0.3s ease-out;
}

.notification-success {
  border-left-color: #10b981;
}

.notification-error {
  border-left-color: #ef4444;
}

.notification-follow {
  border-left-color: #ef4444;
}

.notification-unfollow {
  border-left-color: #6b7280;
}

.notification-default {
  border-left-color: #3b82f6;
}

.notification-content {
  display: flex;
  align-items: center;
  gap: 8px;
}

.notification-message {
  flex: 1;
  font-weight: 500;
  color: #1f2937;
}

.notification-close {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 24px;
  height: 24px;
  border: none;
  background: none;
  color: #6b7280;
  cursor: pointer;
  border-radius: 4px;
  transition: all 0.2s ease;
}

.notification-close:hover {
  background: #f3f4f6;
  color: #374151;
}

@keyframes slideInRight {
  from {
    opacity: 0;
    transform: translateX(100%);
  }
  to {
    opacity: 1;
    transform: translateX(0);
  }
}

/* Mobile Responsive Updates */
@media (max-width: 768px) {
  .user-profile-header {
    flex-direction: column;
    gap: 8px;
    padding: 12px;
  }
  
  .profile-stats {
    align-self: stretch;
    justify-content: space-around;
  }
  
  .carousel-nav {
    width: 36px;
    height: 36px;
  }
  
  .filter-scroll {
    padding-bottom: 8px;
  }
  
  .action-buttons-section {
    grid-template-columns: 1fr;
  }
  
  .notification-container {
    top: 10px;
    right: 10px;
    left: 10px;
    max-width: none;
  }
}

@media (max-width: 480px) {
  .details-header {
    padding: 12px 16px;
  }
  
  .details-content {
    padding: 16px;
  }
  
  .venue-header-section {
    padding: 16px;
  }
  
  .venue-title-section h1 {
    font-size: 1.5rem;
  }
}
EOF

echo "✅ nYtevibe Display Fix Complete!"
echo ""
echo "🎯 Fixed Components:"
echo "   ✅ UserProfile - Now visible in header with stats"
echo "   ✅ PromotionalCarousel - Interactive banner carousel"
echo "   ✅ FilterBar - Venue filtering with active states"
echo "   ✅ VenueList - Proper venue grid display"
echo "   ✅ VenueDetails - Complete detail view"
echo "   ✅ NotificationSystem - Toast notifications"
echo "   ✅ All missing UI components (Badge, FollowButton, etc.)"
echo ""
echo "🔧 Structural Fixes:"
echo "   ✅ Fixed App.jsx component structure"
echo "   ✅ Added proper view routing"
echo "   ✅ Fixed component imports and exports"
echo "   ✅ Added responsive CSS for mobile"
echo "   ✅ Fixed navigation between views"
echo ""
echo "🚀 To apply the fixes:"
echo "   1. npm install (to ensure dependencies)"
echo "   2. npm run dev"
echo "   3. Check browser console for any remaining errors"
echo ""
echo "📱 The app should now display:"
echo "   • Papove Bombando profile in top-right"
echo "   • Promotional banner carousel"
echo "   • Filter buttons (All, Following, Nearby, etc.)"
echo "   • White venue cards in grid layout"
echo "   • Working details page when clicking venues"
echo "   • Toast notifications for actions"
EOF
