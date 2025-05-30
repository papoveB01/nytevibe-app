#!/bin/bash

# nYtevibe Completely Invisible Background Refresh Script
# Makes all background updates completely undetectable to users

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${PURPLE}✨ $1 ✨${NC}"
}

print_feature() {
    echo -e "${CYAN}👻${NC} $1"
}

print_header "nYtevibe Completely Invisible Background Refresh"
print_header "==============================================="

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    print_error "package.json not found. Please run this from the nytevibe project directory."
    exit 1
fi

# Backup current files
print_status "📋 Creating backups..."
cp src/App.jsx src/App.jsx.backup 2>/dev/null || echo "App.jsx backup skipped"
print_success "Backups created"

# Create the enhanced App.jsx with completely invisible background updates
print_status "👻 Creating App.jsx with completely invisible background refresh..."
cat > src/App.jsx << 'APPEOF'
import React, { useState, useEffect, useCallback, useMemo } from 'react';
import { MapPin, Users, Clock, Star, TrendingUp, MessageCircle, Award, ChevronRight, Phone, ExternalLink, ArrowLeft, Navigation, Map, Search, X, Filter, ChevronLeft, Volume2, Calendar, Gift } from 'lucide-react';
import './App.css';

const App = () => {
  const [currentView, setCurrentView] = useState('home');
  const [selectedVenue, setSelectedVenue] = useState(null);
  const [showReportModal, setShowReportModal] = useState(false);
  const [showRatingModal, setShowRatingModal] = useState(false);
  const [showReviewsModal, setShowReviewsModal] = useState(false);
  const [userPoints, setUserPoints] = useState(147);
  const [userLevel, setUserLevel] = useState('Silver Reporter');
  const [searchQuery, setSearchQuery] = useState('');
  const [searchFocused, setSearchFocused] = useState(false);
  const [currentBannerIndex, setCurrentBannerIndex] = useState(0);

  // Promotional banners data (unchanged)
  const promotionalBanners = [
    {
      id: 'community',
      type: 'community',
      icon: MessageCircle,
      title: "Help your community!",
      subtitle: "Rate venues and report status to earn points",
      bgColor: "rgba(59, 130, 246, 0.1)",
      borderColor: "rgba(59, 130, 246, 0.2)",
      iconColor: "var(--primary-600)"
    },
    {
      id: 'nyc-promo',
      type: 'promotion',
      venue: 'NYC Vibes',
      icon: Gift,
      title: "NYC Vibes says: Free Hookah for Ladies! 🎉",
      subtitle: "6:00 PM - 10:00 PM • Tonight Only • Limited Time",
      bgColor: "rgba(236, 72, 153, 0.1)",
      borderColor: "rgba(236, 72, 153, 0.2)",
      iconColor: "#ec4899"
    },
    {
      id: 'best-regards-event',
      type: 'event',
      venue: 'Best Regards',
      icon: Volume2,
      title: "Best Regards Says: Guess who's here tonight! 🎵",
      subtitle: "#DJ Chin is spinning • 9:00 PM - 2:00 AM • Don't miss out!",
      bgColor: "rgba(168, 85, 247, 0.1)",
      borderColor: "rgba(168, 85, 247, 0.2)",
      iconColor: "#a855f7"
    },
    {
      id: 'rumors-special',
      type: 'promotion',
      venue: 'Rumors',
      icon: Calendar,
      title: "Rumors: R&B Night Special! 🎤",
      subtitle: "2-for-1 cocktails • Live R&B performances • 8:00 PM start",
      bgColor: "rgba(34, 197, 94, 0.1)",
      borderColor: "rgba(34, 197, 94, 0.2)",
      iconColor: "#22c55e"
    },
    {
      id: 'classic-game',
      type: 'event',
      venue: 'Classic',
      icon: Volume2,
      title: "Classic Bar: Big Game Tonight! 🏈",
      subtitle: "Texans vs Cowboys • 50¢ wings • Free shots for TDs!",
      bgColor: "rgba(251, 146, 60, 0.1)",
      borderColor: "rgba(251, 146, 60, 0.2)",
      iconColor: "#fb923c"
    }
  ];

  // Auto-rotate banners every 4 seconds
  useEffect(() => {
    const interval = setInterval(() => {
      setCurrentBannerIndex((prev) => (prev + 1) % promotionalBanners.length);
    }, 4000);

    return () => clearInterval(interval);
  }, [promotionalBanners.length]);

  // Manual banner navigation
  const nextBanner = () => {
    setCurrentBannerIndex((prev) => (prev + 1) % promotionalBanners.length);
  };

  const previousBanner = () => {
    setCurrentBannerIndex((prev) => (prev - 1 + promotionalBanners.length) % promotionalBanners.length);
  };

  const goToBanner = (index) => {
    setCurrentBannerIndex(index);
  };

  // Enhanced Houston area venues with promotional data
  const [venues, setVenues] = useState([
    {
      id: 1,
      name: "NYC Vibes",
      type: "Lounge",
      distance: "0.2 mi",
      crowdLevel: 4,
      waitTime: 15,
      lastUpdate: "2 min ago", // This will NEVER change from background updates
      vibe: ["Lively", "Hip-Hop"],
      confidence: 95, // This will NEVER change from background updates
      reports: 8, // This will NEVER change from background updates
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
      trending: "stable", // This will NEVER change from background updates
      hasPromotion: true,
      promotionText: "Free Hookah for Ladies 6-10PM!",
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
      distance: "1.2 mi",
      crowdLevel: 3,
      waitTime: 25,
      lastUpdate: "12 min ago",
      vibe: ["Upscale", "City Views"],
      confidence: 82,
      reports: 6,
      lat: 29.7633,
      lng: -95.3632,
      address: "7890 Skyline Drive, Houston, TX 77006",
      city: "Houston",
      postcode: "77006",
      phone: "(713) 555-7890",
      hours: "Open until 1:00 AM",
      rating: 4.4,
      totalRatings: 94,
      ratingBreakdown: { 5: 38, 4: 32, 3: 18, 2: 4, 1: 2 },
      isOpen: true,
      trending: "up",
      hasPromotion: false,
      reviews: [
        { id: 1, user: "Sofia M.", rating: 5, comment: "Stunning city views! Perfect for special occasions.", date: "1 day ago", helpful: 16 }
      ]
    },
    {
      id: 6,
      name: "Dive Deep",
      type: "Dive Bar",
      distance: "2.1 mi",
      crowdLevel: 2,
      waitTime: 0,
      lastUpdate: "15 min ago",
      vibe: ["Casual", "Local"],
      confidence: 71,
      reports: 4,
      lat: 29.7372,
      lng: -95.3991,
      address: "2468 River Street, Montrose, TX 77006",
      city: "Montrose",
      postcode: "77006",
      phone: "(713) 555-2468",
      hours: "Open until 2:00 AM",
      rating: 3.8,
      totalRatings: 67,
      ratingBreakdown: { 5: 18, 4: 22, 3: 19, 2: 6, 1: 2 },
      isOpen: true,
      trending: "stable",
      hasPromotion: false,
      reviews: [
        { id: 1, user: "Jake P.", rating: 4, comment: "Authentic dive bar experience. Great for locals!", date: "3 days ago", helpful: 8 }
      ]
    },
    {
      id: 7,
      name: "Sugar Land Social",
      type: "Lounge",
      distance: "18.5 mi",
      crowdLevel: 4,
      waitTime: 35,
      lastUpdate: "6 min ago",
      vibe: ["Trendy", "Suburban"],
      confidence: 89,
      reports: 11,
      lat: 29.6196,
      lng: -95.6349,
      address: "1357 Town Square, Sugar Land, TX 77479",
      city: "Sugar Land",
      postcode: "77479",
      phone: "(281) 555-1357",
      hours: "Open until 12:00 AM",
      rating: 4.3,
      totalRatings: 142,
      ratingBreakdown: { 5: 52, 4: 48, 3: 28, 2: 10, 1: 4 },
      isOpen: true,
      trending: "up",
      hasPromotion: false,
      reviews: [
        { id: 1, user: "Ashley K.", rating: 5, comment: "Great suburban spot! Clean and well-managed.", date: "2 days ago", helpful: 12 }
      ]
    },
    {
      id: 8,
      name: "Woodlands Tavern",
      type: "Tavern",
      distance: "25.3 mi",
      crowdLevel: 2,
      waitTime: 10,
      lastUpdate: "20 min ago",
      vibe: ["Family-Friendly", "Quiet"],
      confidence: 77,
      reports: 3,
      lat: 30.1588,
      lng: -95.4613,
      address: "9876 Forest Lane, The Woodlands, TX 77380",
      city: "The Woodlands",
      postcode: "77380",
      phone: "(281) 555-9876",
      hours: "Open until 11:00 PM",
      rating: 4.0,
      totalRatings: 58,
      ratingBreakdown: { 5: 22, 4: 20, 3: 12, 2: 3, 1: 1 },
      isOpen: true,
      trending: "stable",
      hasPromotion: false,
      reviews: [
        { id: 1, user: "Mark D.", rating: 4, comment: "Nice family atmosphere. Good food and drinks.", date: "1 week ago", helpful: 6 }
      ]
    }
  ]);

  // Smart search functionality (unchanged)
  const filteredVenues = useMemo(() => {
    if (!searchQuery.trim()) return venues;
    
    const query = searchQuery.toLowerCase().trim();
    
    return venues.filter(venue => {
      return (
        venue.name.toLowerCase().includes(query) ||
        venue.city.toLowerCase().includes(query) ||
        venue.postcode.includes(query) ||
        venue.type.toLowerCase().includes(query) ||
        venue.address.toLowerCase().includes(query)
      );
    });
  }, [venues, searchQuery]);

  // Clear search
  const clearSearch = () => {
    setSearchQuery('');
    setSearchFocused(false);
  };

  // Google Maps integration functions
  const openGoogleMaps = (venue) => {
    const address = encodeURIComponent(venue.address);
    const url = `https://www.google.com/maps/search/?api=1&query=${address}`;
    window.open(url, '_blank');
  };

  const getDirections = (venue) => {
    const address = encodeURIComponent(venue.address);
    const url = `https://www.google.com/maps/dir/?api=1&destination=${address}`;
    window.open(url, '_blank');
  };

  // COMPLETELY INVISIBLE background updates - users will NEVER see any changes
  const updateVenueDataInvisibly = useCallback(() => {
    setVenues(prevVenues => 
      prevVenues.map(venue => {
        // EXTREMELY rare updates - only 2% chance (was 10%)
        const shouldUpdate = Math.random() > 0.98;
        
        if (shouldUpdate) {
          // MICROSCOPIC changes - only 0.02 change maximum (was 0.1)
          const crowdChange = (Math.random() - 0.5) * 0.02;
          const newCrowdLevel = Math.max(1, Math.min(5, venue.crowdLevel + crowdChange));
          
          // Wait time changes are also microscopic - maximum ±0.5 minutes
          const waitChange = Math.round((Math.random() - 0.5) * 0.5);
          
          return {
            ...venue,
            crowdLevel: newCrowdLevel,
            waitTime: Math.max(0, venue.waitTime + waitChange),
            // NEVER update these visible fields from background refresh:
            // lastUpdate: venue.lastUpdate, (keep original)
            // confidence: venue.confidence, (keep original)
            // reports: venue.reports, (keep original)
            // trending: venue.trending, (keep original)
          };
        }
        return venue;
      })
    );
  }, []);

  // Background update interval - much longer and only when page is visible
  useEffect(() => {
    let interval;
    
    // Only update when:
    // 1. User is on home view
    // 2. Page is visible (not hidden)
    // 3. Much longer interval (5 minutes instead of 2)
    if (currentView === 'home' && !document.hidden) {
      interval = setInterval(() => {
        updateVenueDataInvisibly();
      }, 300000); // 5 minutes (300 seconds) - very infrequent
    }

    return () => {
      if (interval) {
        clearInterval(interval);
      }
    };
  }, [currentView, updateVenueDataInvisibly]);

  // Page visibility - no visible updates when page becomes visible
  useEffect(() => {
    const handleVisibilityChange = () => {
      // Do absolutely nothing visible when page becomes visible
      // Let the normal interval handle updates invisibly
    };

    document.addEventListener('visibilitychange', handleVisibilityChange);
    
    return () => {
      document.removeEventListener('visibilitychange', handleVisibilityChange);
    };
  }, []);

  const getCrowdLabel = (level) => {
    const labels = ["", "Empty", "Quiet", "Moderate", "Busy", "Packed"];
    return labels[Math.round(level)] || "Unknown";
  };

  const getCrowdColor = (level) => {
    if (level <= 2) return "badge badge-green";
    if (level <= 3) return "badge badge-yellow";
    return "badge badge-red";
  };

  // Interactive Promotional Banner Component (unchanged)
  const PromotionalBanner = () => {
    const currentBanner = promotionalBanners[currentBannerIndex];
    const IconComponent = currentBanner.icon;

    return (
      <div className="promotional-banner-container">
        <div 
          className="promotional-banner"
          style={{
            background: currentBanner.bgColor,
            borderColor: currentBanner.borderColor
          }}
        >
          <button 
            onClick={previousBanner}
            className="banner-nav banner-nav-left"
            aria-label="Previous promotion"
          >
            <ChevronLeft className="w-4 h-4" />
          </button>

          <div className="banner-content">
            <IconComponent 
              className="banner-icon" 
              style={{ color: currentBanner.iconColor }}
            />
            <div>
              <div className="banner-title">{currentBanner.title}</div>
              <div className="banner-subtitle">{currentBanner.subtitle}</div>
            </div>
          </div>

          <button 
            onClick={nextBanner}
            className="banner-nav banner-nav-right"
            aria-label="Next promotion"
          >
            <ChevronRight className="w-4 h-4" />
          </button>
        </div>

        {/* Banner Indicators */}
        <div className="banner-indicators">
          {promotionalBanners.map((_, index) => (
            <button
              key={index}
              onClick={() => goToBanner(index)}
              className={`banner-indicator ${index === currentBannerIndex ? 'active' : ''}`}
              aria-label={`Go to promotion ${index + 1}`}
            />
          ))}
        </div>
      </div>
    );
  };

  // Smart Search Bar Component (unchanged)
  const SearchBar = () => (
    <div className={`search-container ${searchFocused ? 'search-focused' : ''}`}>
      <div className="search-wrapper">
        <Search className="search-icon" />
        <input
          type="text"
          placeholder="Search venues, cities, or postcodes..."
          value={searchQuery}
          onChange={(e) => setSearchQuery(e.target.value)}
          onFocus={() => setSearchFocused(true)}
          onBlur={() => setSearchFocused(false)}
          className="search-input"
        />
        {searchQuery && (
          <button onClick={clearSearch} className="search-clear">
            <X className="w-4 h-4" />
          </button>
        )}
      </div>
      {searchQuery && (
        <div className="search-results-info">
          {filteredVenues.length === 0 ? (
            <span className="text-muted">No venues found for "{searchQuery}"</span>
          ) : (
            <span className="text-muted">
              {filteredVenues.length} venue{filteredVenues.length !== 1 ? 's' : ''} found
            </span>
          )}
        </div>
      )}
    </div>
  );

  // Star Rating Component (unchanged)
  const StarRating = ({ rating, size = 'sm', showCount = false, totalRatings = 0, interactive = false, onRatingChange = null }) => {
    const [hoverRating, setHoverRating] = useState(0);
    
    const starSize = size === 'lg' ? 'w-6 h-6' : size === 'md' ? 'w-5 h-5' : 'w-4 h-4';
    
    return (
      <div className="flex items-center">
        <div className="flex">
          {[1, 2, 3, 4, 5].map((star) => (
            <Star
              key={star}
              className={`${starSize} cursor-${interactive ? 'pointer' : 'default'} transition-colors ${
                star <= (interactive ? (hoverRating || rating) : rating)
                  ? 'fill-yellow-400 text-yellow-400'
                  : 'text-gray-300'
              }`}
              onMouseEnter={() => interactive && setHoverRating(star)}
              onMouseLeave={() => interactive && setHoverRating(0)}
              onClick={() => interactive && onRatingChange && onRatingChange(star)}
            />
          ))}
        </div>
        {showCount && (
          <span className="ml-2 text-sm text-muted">
            {rating.toFixed(1)} ({totalRatings} {totalRatings === 1 ? 'review' : 'reviews'})
          </span>
        )}
      </div>
    );
  };

  // Rating Breakdown Component (unchanged)
  const RatingBreakdown = ({ breakdown, totalRatings }) => {
    return (
      <div className="space-y-2">
        {[5, 4, 3, 2, 1].map((stars) => {
          const count = breakdown[stars] || 0;
          const percentage = totalRatings > 0 ? (count / totalRatings) * 100 : 0;
          
          return (
            <div key={stars} className="flex items-center text-sm">
              <span className="w-3 text-muted">{stars}</span>
              <Star className="w-3 h-3 fill-yellow-400 text-yellow-400 mx-1" />
              <div className="flex-1 mx-2 bg-gray-200 rounded-full h-2">
                <div 
                  className="bg-yellow-400 h-2 rounded-full transition-all duration-300"
                  style={{ width: `${percentage}%` }}
                />
              </div>
              <span className="w-8 text-right text-muted">{count}</span>
            </div>
          );
        })}
      </div>
    );
  };

  // Rating Modal Component (unchanged)
  const RatingModal = ({ venue, onClose, onSubmit }) => {
    const [rating, setRating] = useState(0);
    const [review, setReview] = useState('');

    const handleSubmit = () => {
      if (rating === 0) {
        alert('Please select a rating');
        return;
      }
      
      onSubmit({
        rating,
        review: review.trim(),
        date: new Date().toISOString(),
        user: 'You'
      });
      onClose();
    };

    return (
      <div className="modal-overlay">
        <div className="modal-content">
          <h3 className="text-xl font-bold mb-4 text-primary">Rate {venue.name}</h3>
          
          <div className="text-center mb-6">
            <p className="text-secondary mb-4">How would you rate your experience?</p>
            <StarRating 
              rating={rating} 
              size="lg" 
              interactive={true} 
              onRatingChange={setRating}
            />
            <p className="text-sm text-muted mt-2">
              {rating === 0 && "Select a rating"}
              {rating === 1 && "Terrible"}
              {rating === 2 && "Poor"}
              {rating === 3 && "Average"}
              {rating === 4 && "Good"}
              {rating === 5 && "Excellent"}
            </p>
          </div>

          <div className="mb-6">
            <label className="block text-sm font-semibold mb-2 text-secondary">
              Write a review (optional)
            </label>
            <textarea
              value={review}
              onChange={(e) => setReview(e.target.value)}
              className="form-input form-textarea"
              rows="4"
              placeholder="Share your experience with others..."
              maxLength="500"
            />
            <div className="text-xs text-muted mt-1 text-right">
              {review.length}/500 characters
            </div>
          </div>

          <div className="flex space-x-3">
            <button
              onClick={onClose}
              className="btn btn-secondary flex-1"
            >
              Cancel
            </button>
            <button
              onClick={handleSubmit}
              className="btn btn-primary flex-1"
              disabled={rating === 0}
            >
              Submit Rating (+10 points)
            </button>
          </div>
        </div>
      </div>
    );
  };

  // Reviews Modal Component (unchanged)
  const ReviewsModal = ({ venue, onClose }) => {
    const sortedReviews = venue.reviews.sort((a, b) => b.helpful - a.helpful);

    return (
      <div className="modal-overlay">
        <div className="modal-content max-w-2xl">
          <div className="flex justify-between items-start mb-4">
            <h3 className="text-xl font-bold text-primary">Reviews for {venue.name}</h3>
            <button onClick={onClose} className="btn btn-secondary text-sm">×</button>
          </div>

          <div className="mb-6">
            <div className="flex items-center justify-between mb-4">
              <div>
                <StarRating 
                  rating={venue.rating} 
                  size="lg" 
                  showCount={true} 
                  totalRatings={venue.totalRatings}
                />
              </div>
              <button
                onClick={() => {
                  onClose();
                  setShowRatingModal(true);
                }}
                className="btn btn-primary"
              >
                Write Review
              </button>
            </div>
            
            <RatingBreakdown 
              breakdown={venue.ratingBreakdown} 
              totalRatings={venue.totalRatings}
            />
          </div>

          <div className="max-h-96 overflow-y-auto space-y-4">
            {sortedReviews.map((review) => (
              <div key={review.id} className="card p-4">
                <div className="flex items-start justify-between mb-2">
                  <div>
                    <div className="flex items-center mb-1">
                      <span className="font-semibold text-sm">{review.user}</span>
                      <span className="mx-2 text-muted">•</span>
                      <StarRating rating={review.rating} size="sm" />
                    </div>
                    <p className="text-sm text-muted">{review.date}</p>
                  </div>
                </div>
                
                <p className="text-secondary mb-3">{review.comment}</p>
                
                <div className="flex items-center text-sm text-muted">
                  <span>{review.helpful} people found this helpful</span>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    );
  };

  // Report Modal Component (unchanged)
  const ReportModal = ({ venue, onClose, onSubmit }) => {
    const [crowdLevel, setCrowdLevel] = useState(Math.round(venue.crowdLevel));
    const [waitTime, setWaitTime] = useState(venue.waitTime);
    const [vibe, setVibe] = useState([]);
    const [note, setNote] = useState('');

    const vibeOptions = ["Chill", "Lively", "Loud", "Dancing", "Sports", "Date Night", "Business", "Family", "Hip-Hop", "R&B", "Live Music", "Karaoke"];

    const toggleVibe = (option) => {
      setVibe(prev => 
        prev.includes(option) 
          ? prev.filter(v => v !== option)
          : [...prev, option]
      );
    };

    const handleSubmit = () => {
      onSubmit({
        crowdLevel,
        waitTime,
        vibe,
        note
      });
      onClose();
    };

    return (
      <div className="modal-overlay">
        <div className="modal-content">
          <h3 className="text-xl font-bold mb-4 text-primary">Report Status: {venue.name}</h3>
          
          <div className="mb-4">
            <label className="block text-sm font-semibold mb-3 text-secondary">How busy is it?</label>
            <div className="flex space-x-2">
              {[1,2,3,4,5].map(level => (
                <button
                  key={level}
                  onClick={() => setCrowdLevel(level)}
                  className={`w-12 h-12 rounded-full flex items-center justify-center text-sm font-bold transition-all ${
                    crowdLevel === level 
                      ? 'btn btn-primary' 
                      : 'btn btn-secondary'
                  }`}
                >
                  {level}
                </button>
              ))}
            </div>
            <div className="text-xs text-muted mt-2">
              1 = Empty, 5 = Packed
            </div>
          </div>

          <div className="mb-4">
            <label className="block text-sm font-semibold mb-2 text-secondary">Wait time (minutes)</label>
            <input
              type="number"
              value={waitTime}
              onChange={(e) => setWaitTime(Number(e.target.value))}
              className="form-input"
              min="0"
              max="120"
              placeholder="0"
            />
          </div>

          <div className="mb-4">
            <label className="block text-sm font-semibold mb-3 text-secondary">Vibe (select all that apply)</label>
            <div className="flex flex-wrap gap-2">
              {vibeOptions.map(option => (
                <button
                  key={option}
                  onClick={() => toggleVibe(option)}
                  className={`px-3 py-2 rounded-full text-sm font-medium transition-all ${
                    vibe.includes(option)
                      ? 'btn btn-primary'
                      : 'btn btn-secondary'
                  }`}
                >
                  {option}
                </button>
              ))}
            </div>
          </div>

          <div className="mb-6">
            <label className="block text-sm font-semibold mb-2 text-secondary">Additional notes (optional)</label>
            <textarea
              value={note}
              onChange={(e) => setNote(e.target.value)}
              className="form-input form-textarea"
              rows="3"
              placeholder="Any special events, music, atmosphere details..."
            />
          </div>

          <div className="flex space-x-3">
            <button
              onClick={onClose}
              className="btn btn-secondary flex-1"
            >
              Cancel
            </button>
            <button
              onClick={handleSubmit}
              className="btn btn-primary flex-1"
            >
              Submit Report (+5 points)
            </button>
          </div>
        </div>
      </div>
    );
  };

  // Enhanced Venue Card Component with promotion indicators (unchanged)
  const VenueCard = ({ venue, onClick, showReportButton = true }) => {
    const highlightText = (text, query) => {
      if (!query.trim()) return text;
      
      const parts = text.split(new RegExp(`(${query})`, 'gi'));
      return parts.map((part, index) => 
        part.toLowerCase() === query.toLowerCase() ? (
          <mark key={index} className="search-highlight">{part}</mark>
        ) : part
      );
    };

    return (
      <div className="card card-venue animate-fadeIn">
        {venue.hasPromotion && (
          <div className="venue-promotion-badge">
            <Gift className="w-3 h-3 mr-1" />
            <span className="text-xs font-semibold">{venue.promotionText}</span>
          </div>
        )}

        <div className="flex justify-between items-start mb-3">
          <div className="flex-1">
            <div className="flex items-center mb-1">
              <h3 className="text-lg font-bold text-primary mr-2">
                {searchQuery ? highlightText(venue.name, searchQuery) : venue.name}
              </h3>
            </div>
            <div className="flex items-center text-secondary text-sm mb-1">
              <MapPin className="icon icon-sm mr-2" />
              <span className="font-medium">{venue.type} • {venue.distance}</span>
            </div>
            <div className="flex items-center mb-2">
              <StarRating 
                rating={venue.rating} 
                size="sm" 
                showCount={true} 
                totalRatings={venue.totalRatings}
              />
            </div>
            <div className="text-xs text-muted">
              {searchQuery ? highlightText(`${venue.city}, ${venue.postcode}`, searchQuery) : `${venue.city}, ${venue.postcode}`}
            </div>
          </div>
          <div className="text-right">
            <div className={getCrowdColor(venue.crowdLevel)}>
              <Users className="icon icon-sm mr-1" />
              {getCrowdLabel(venue.crowdLevel)}
            </div>
          </div>
        </div>

        <div className="flex items-center justify-between mb-4">
          <div className="flex items-center space-x-4 text-sm text-secondary">
            <div className="flex items-center">
              <Clock className="icon icon-sm mr-1" />
              <span className="font-medium">{venue.waitTime > 0 ? `${venue.waitTime} min wait` : 'No wait'}</span>
            </div>
            <div className="flex items-center">
              <TrendingUp className="icon icon-sm mr-1" />
              <span className="font-medium">{venue.confidence}% confidence</span>
            </div>
          </div>
          <span className="text-xs text-muted font-medium">{venue.lastUpdate}</span>
        </div>

        <div className="flex flex-wrap gap-2 mb-4">
          {venue.vibe.map((tag, index) => (
            <span key={index} className="badge badge-blue">
              {tag}
            </span>
          ))}
        </div>

        <div className="flex space-x-2">
          <button
            onClick={(e) => {
              e.stopPropagation();
              setSelectedVenue(venue);
              setShowRatingModal(true);
            }}
            className="btn btn-warning flex-1"
          >
            Rate
          </button>
          {showReportButton && (
            <button
              onClick={(e) => {
                e.stopPropagation();
                setSelectedVenue(venue);
                setShowReportModal(true);
              }}
              className="btn btn-primary flex-1"
            >
              Update
            </button>
          )}
          <button
            onClick={() => onClick(venue)}
            className="btn btn-secondary flex-1 flex items-center justify-center"
          >
            Details
            <ChevronRight className="icon icon-sm ml-2" />
          </button>
        </div>
      </div>
    );
  };

  // Venue Detail Component (unchanged)
  const VenueDetail = ({ venue }) => (
    <div className="app-container animate-slideIn">
      <div className="app-header">
        <div className="header-content">
          <button
            onClick={() => setCurrentView('home')}
            className="btn btn-secondary mb-3 text-sm flex items-center"
          >
            <ArrowLeft className="icon icon-sm mr-2" />
            Back to venues
          </button>
          <h1 className="app-title">{venue.name}</h1>
          <p className="app-subtitle font-semibold">{venue.type} • {venue.hours}</p>
          <div className="flex items-center justify-between mt-3">
            <StarRating 
              rating={venue.rating} 
              size="lg" 
              showCount={true} 
              totalRatings={venue.totalRatings}
            />
            <button
              onClick={() => {
                setSelectedVenue(venue);
                setShowReviewsModal(true);
              }}
              className="btn btn-secondary text-sm"
            >
              Read Reviews
            </button>
          </div>
        </div>
      </div>

      <div className="p-4 space-y-4">
        {venue.hasPromotion && (
          <div className="card promotion-card">
            <div className="flex items-center mb-2">
              <Gift className="w-5 h-5 mr-2 text-primary" />
              <h3 className="font-bold text-primary">Current Promotion</h3>
            </div>
            <p className="text-secondary font-medium">{venue.promotionText}</p>
          </div>
        )}

        <div className="card">
          <h3 className="font-bold text-lg mb-4 text-primary">Current Status</h3>
          <div className="grid grid-cols-2 gap-4">
            <div className="stats-card">
              <div className="stats-number">{Math.round(venue.crowdLevel)}/5</div>
              <div className="stats-label">Crowd Level</div>
            </div>
            <div className="stats-card" style={{background: 'var(--gradient-success)'}}>
              <div className="stats-number">{venue.waitTime}m</div>
              <div className="stats-label">Wait Time</div>
            </div>
          </div>
          <div className="mt-4 text-sm text-muted text-center">
            Last updated {venue.lastUpdate} • {venue.reports} reports today • {venue.confidence}% confidence
          </div>
        </div>

        <div className="card">
          <h3 className="font-bold text-lg mb-4 text-primary">Location & Contact</h3>
          
          <div className="flex items-start space-x-3 mb-4">
            <MapPin className="icon icon-lg text-primary mt-1" />
            <div className="flex-1">
              <div className="text-sm font-semibold text-primary">{venue.address}</div>
              <div className="text-xs text-muted">{venue.city}, {venue.postcode} • {venue.distance} away</div>
            </div>
          </div>

          <div className="flex items-center space-x-3 mb-4">
            <Phone className="icon icon-lg text-primary" />
            <a href={`tel:${venue.phone}`} className="text-sm font-semibold text-primary hover:underline">
              {venue.phone}
            </a>
          </div>

          <div className="flex items-center space-x-3 mb-6">
            <Clock className="icon icon-lg text-primary" />
            <div className="text-sm font-semibold text-primary">{venue.hours}</div>
          </div>

          <div className="flex space-x-3">
            <button
              onClick={() => openGoogleMaps(venue)}
              className="btn btn-success flex-1 flex items-center justify-center"
            >
              <Map className="icon icon-sm mr-2" />
              View on Map
            </button>
            <button
              onClick={() => getDirections(venue)}
              className="btn btn-primary flex-1 flex items-center justify-center"
            >
              <Navigation className="icon icon-sm mr-2" />
              Directions
            </button>
          </div>
        </div>

        <div className="card">
          <h3 className="font-bold text-lg mb-4 text-primary">Vibe & Atmosphere</h3>
          <div className="flex flex-wrap gap-2">
            {venue.vibe.map((tag, index) => (
              <span key={index} className="badge badge-blue text-sm px-4 py-2">
                {tag}
              </span>
            ))}
          </div>
        </div>

        <div className="grid grid-cols-2 gap-3">
          <button
            onClick={() => {
              setSelectedVenue(venue);
              setShowReportModal(true);
            }}
            className="btn btn-primary py-4 font-bold text-base"
          >
            Update Status (+5 pts)
          </button>
          <button
            onClick={() => {
              setSelectedVenue(venue);
              setShowRatingModal(true);
            }}
            className="btn btn-warning py-4 font-bold text-base"
          >
            Rate Venue (+10 pts)
          </button>
        </div>
      </div>
    </div>
  );

  // Enhanced Home View Component with interactive banner
  const HomeView = () => {
    const [sortBy, setSortBy] = useState('distance');
    
    const sortedVenues = [...filteredVenues].sort((a, b) => {
      switch (sortBy) {
        case 'rating':
          return b.rating - a.rating;
        case 'crowd':
          return b.crowdLevel - a.crowdLevel;
        default:
          return parseFloat(a.distance) - parseFloat(b.distance);
      }
    });

    return (
      <div className="app-container animate-fadeIn">
        <div className="app-header">
          <div className="header-content">
            <div className="flex items-center justify-between mb-4">
              <div>
                <h1 className="app-title">nYtevibe</h1>
                <p className="app-subtitle">Houston Area • Live Venue Tracker</p>
              </div>
              <div className="text-right">
                <div className="user-stats">
                  <Award className="icon icon-sm mr-2" />
                  <span>{userPoints} pts</span>
                </div>
                <div className="user-level">{userLevel}</div>
              </div>
            </div>
            
            {/* Smart Search Bar */}
            <SearchBar />
            
            {/* Interactive Promotional Banner */}
            <PromotionalBanner />
          </div>
        </div>

        <div className="p-4 space-y-4">
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-xl font-bold text-white">
              {searchQuery ? `Search Results` : 'Nearby Venues'}
            </h2>
            <div className="flex items-center space-x-2">
              <span className="text-sm text-white">Sort:</span>
              <select 
                value={sortBy} 
                onChange={(e) => setSortBy(e.target.value)}
                className="form-input text-sm py-1 px-2 sort-dropdown"
              >
                <option value="distance">Distance</option>
                <option value="rating">Rating</option>
                <option value="crowd">Crowd Level</option>
              </select>
            </div>
          </div>
          
          {sortedVenues.length === 0 ? (
            <div className="card text-center py-8">
              <Search className="w-12 h-12 mx-auto text-muted mb-4" />
              <h3 className="text-lg font-semibold text-primary mb-2">No venues found</h3>
              <p className="text-muted">Try searching for a different venue name, city, or postcode.</p>
              {searchQuery && (
                <button
                  onClick={clearSearch}
                  className="btn btn-primary mt-4"
                >
                  Clear Search
                </button>
              )}
            </div>
          ) : (
            sortedVenues.map((venue, index) => (
              <div key={venue.id} style={{animationDelay: `${index * 0.1}s`}}>
                <VenueCard
                  venue={venue}
                  onClick={(venue) => {
                    setSelectedVenue(venue);
                    setCurrentView('detail');
                  }}
                />
              </div>
            ))
          )}
        </div>
      </div>
    );
  };

  // Handle report submission - ONLY user actions create visible updates
  const handleReportSubmit = (reportData) => {
    setVenues(prevVenues =>
      prevVenues.map(venue =>
        venue.id === selectedVenue.id
          ? {
              ...venue,
              crowdLevel: reportData.crowdLevel,
              waitTime: reportData.waitTime,
              vibe: reportData.vibe.length > 0 ? reportData.vibe : venue.vibe,
              lastUpdate: "Just now", // Only user reports show "Just now"
              reports: venue.reports + 1,
              confidence: Math.min(99, venue.confidence + 3),
              trending: "stable"
            }
          : venue
      )
    );
    setUserPoints(prev => prev + 5);
    setSelectedVenue(null);
  };

  // Handle rating submission - ONLY user actions create visible updates
  const handleRatingSubmit = (ratingData) => {
    setVenues(prevVenues =>
      prevVenues.map(venue =>
        venue.id === selectedVenue.id
          ? {
              ...venue,
              reviews: [
                {
                  id: venue.reviews.length + 1,
                  user: ratingData.user,
                  rating: ratingData.rating,
                  comment: ratingData.review || "No comment provided",
                  date: "Just now",
                  helpful: 0
                },
                ...venue.reviews
              ],
              ratingBreakdown: {
                ...venue.ratingBreakdown,
                [ratingData.rating]: (venue.ratingBreakdown[ratingData.rating] || 0) + 1
              },
              totalRatings: venue.totalRatings + 1,
              rating: ((venue.rating * venue.totalRatings) + ratingData.rating) / (venue.totalRatings + 1)
            }
          : venue
      )
    );
    setUserPoints(prev => prev + 10);
    setSelectedVenue(null);
  };

  return (
    <div className="font-sans">
      {currentView === 'home' && <HomeView />}
      {currentView === 'detail' && selectedVenue && <VenueDetail venue={selectedVenue} />}
      
      {showReportModal && selectedVenue && (
        <ReportModal
          venue={selectedVenue}
          onClose={() => {
            setShowReportModal(false);
            setSelectedVenue(null);
          }}
          onSubmit={handleReportSubmit}
        />
      )}

      {showRatingModal && selectedVenue && (
        <RatingModal
          venue={selectedVenue}
          onClose={() => {
            setShowRatingModal(false);
            setSelectedVenue(null);
          }}
          onSubmit={handleRatingSubmit}
        />
      )}

      {showReviewsModal && selectedVenue && (
        <ReviewsModal
          venue={selectedVenue}
          onClose={() => {
            setShowReviewsModal(false);
            setSelectedVenue(null);
          }}
        />
      )}
    </div>
  );
};

export default App;
APPEOF

print_success "Enhanced App.jsx with completely invisible background refresh created"

# Test the build
print_status "🔨 Building the invisible refresh version..."
if npm run build; then
    print_success "Build completed successfully"
else
    print_error "Build failed"
    exit 1
fi

# Deploy to web directory
print_status "🚀 Deploying invisible refresh version..."
sudo mkdir -p /var/www/html/nytevibe
if sudo cp -r dist/* /var/www/html/nytevibe/; then
    print_success "Invisible refresh version deployed to /var/www/html/nytevibe"
else
    print_error "Failed to deploy"
    exit 1
fi

# Set proper permissions
print_status "🔧 Setting secure permissions..."
sudo chown -R www-data:www-data /var/www/html/nytevibe
sudo chmod -R 755 /var/www/html/nytevibe

print_header "COMPLETELY INVISIBLE BACKGROUND REFRESH COMPLETE!"
print_header "================================================="
print_success ""
print_success "👻 COMPLETELY INVISIBLE UPDATES:"
print_feature "🔇 Updates every 5 minutes (was 2 minutes) - very infrequent"
print_feature "📉 Only 2% chance of venue updating per cycle (was 10%)"
print_feature "🎯 Microscopic changes: ±0.02 crowd level, ±0.5 min wait time"
print_feature "🚫 NEVER updates lastUpdate timestamps"
print_feature "🚫 NEVER updates confidence percentages"
print_feature "🚫 NEVER updates report counts"
print_feature "🚫 NEVER updates trending indicators"
print_feature "👻 Changes so small they're undetectable to users"
print_success ""
print_success "🔍 WHAT USERS WILL NEVER SEE:"
print_feature "❌ No 'Just now' timestamps from background updates"
print_feature "❌ No changing confidence percentages"
print_feature "❌ No incrementing report counts"
print_feature "❌ No trending direction changes"
print_feature "❌ No visible crowd level fluctuations"
print_feature "❌ No noticeable wait time changes"
print_feature "❌ No update animations or indicators"
print_feature "❌ No refresh notifications or status"
print_success ""
print_success "✅ ONLY USER ACTIONS CREATE VISIBLE CHANGES:"
print_feature "👤 Only manual reports show 'Just now'"
print_feature "⭐ Only user ratings update counts"
print_feature "📊 Only user submissions affect confidence"
print_feature "📈 Only user reports change trending status"
print_feature "🎮 Users are in complete control of visible updates"
print_success ""
print_success "🎯 TECHNICAL IMPROVEMENTS:"
print_feature "⏰ 5-minute intervals (300 seconds) vs previous 2 minutes"
print_feature "📊 2% update probability vs previous 10%"
print_feature "🔬 0.02 maximum change vs previous 0.1"
print_feature "🎭 Background updates preserve all visible metadata"
print_feature "🚫 No visual feedback whatsoever from background refresh"
print_feature "📱 Zero impact on user experience or battery life"
print_success ""
print_success "🎨 USER EXPERIENCE:"
print_feature "📱 App feels completely static and stable"
print_feature "🎮 Users control all visible changes through interactions"
print_feature "⚡ Lightning-fast, responsive interface"
print_feature "🔋 Minimal battery usage from infrequent updates"
print_feature "👻 Background refresh is completely undetectable"
print_feature "✨ Smooth, distraction-free venue browsing"
print_success ""
print_success "🎉 Perfect! Your venue tracker now has truly invisible background refresh!"
print_success "Users will never notice any automatic updates happening!"
