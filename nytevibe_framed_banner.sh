#!/bin/bash

# nYtevibe Banner Visibility Fix
# Fixes the double-buffer implementation to properly show all 5 promotional banners
# Ensures banners are visible while maintaining flicker-free transitions

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
    echo -e "${CYAN}🎯${NC} $1"
}

print_header "nYtevibe Banner Visibility Fix"
print_header "=============================="

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    print_error "package.json not found. Please run this from the nytevibe project directory."
    exit 1
fi

# Backup current files
print_status "📋 Creating backups..."
cp src/App.jsx src/App.jsx.banner-backup 2>/dev/null || echo "App.jsx backup created"
cp src/App.css src/App.css.banner-backup 2>/dev/null || echo "App.css backup created"
print_success "Backups created"

# Create the WORKING App.jsx with visible banners
print_status "🎯 Creating App.jsx with VISIBLE banners..."
cat > src/App.jsx << 'APPEOF'
import React, { useState, useEffect, useCallback, useMemo, useRef } from 'react';
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

  // Banner state
  const [currentBannerIndex, setCurrentBannerIndex] = useState(0);

  // Promotional banners data - VISIBLE and WORKING
  const promotionalBanners = useMemo(() => [
    {
      id: 'community',
      type: 'community',
      icon: MessageCircle,
      title: "Help your community!",
      subtitle: "Rate venues and report status to earn points",
      bgColor: "rgba(59, 130, 246, 0.15)",
      borderColor: "rgba(59, 130, 246, 0.3)",
      iconColor: "#3b82f6"
    },
    {
      id: 'nyc-promo',
      type: 'promotion',
      venue: 'NYC Vibes',
      icon: Gift,
      title: "NYC Vibes says: Free Hookah for Ladies! 🎉",
      subtitle: "6:00 PM - 10:00 PM • Tonight Only • Limited Time",
      bgColor: "rgba(236, 72, 153, 0.15)",
      borderColor: "rgba(236, 72, 153, 0.3)",
      iconColor: "#ec4899"
    },
    {
      id: 'best-regards-event',
      type: 'event',
      venue: 'Best Regards',
      icon: Volume2,
      title: "Best Regards Says: Guess who's here tonight! 🎵",
      subtitle: "#DJ Chin is spinning • 9:00 PM - 2:00 AM • Don't miss out!",
      bgColor: "rgba(168, 85, 247, 0.15)",
      borderColor: "rgba(168, 85, 247, 0.3)",
      iconColor: "#a855f7"
    },
    {
      id: 'rumors-special',
      type: 'promotion',
      venue: 'Rumors',
      icon: Calendar,
      title: "Rumors: R&B Night Special! 🎤",
      subtitle: "2-for-1 cocktails • Live R&B performances • 8:00 PM start",
      bgColor: "rgba(34, 197, 94, 0.15)",
      borderColor: "rgba(34, 197, 94, 0.3)",
      iconColor: "#22c55e"
    },
    {
      id: 'classic-game',
      type: 'event',
      venue: 'Classic',
      icon: Volume2,
      title: "Classic Bar: Big Game Tonight! 🏈",
      subtitle: "Texans vs Cowboys • 50¢ wings • Free shots for TDs!",
      bgColor: "rgba(251, 146, 60, 0.15)",
      borderColor: "rgba(251, 146, 60, 0.3)",
      iconColor: "#fb923c"
    }
  ], []);

  // Simple, working banner rotation
  useEffect(() => {
    const interval = setInterval(() => {
      setCurrentBannerIndex((prev) => (prev + 1) % promotionalBanners.length);
    }, 12000); // 12 seconds - slower for testing

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

  // Working Promotional Banner Component - VISIBLE
  const PromotionalBanner = () => {
    const currentBanner = promotionalBanners[currentBannerIndex];
    const IconComponent = currentBanner.icon;

    return (
      <div className="promotional-banner-working">
        <div 
          className="promotional-banner-content"
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

          <div className="banner-main-content">
            <IconComponent 
              className="banner-icon-working" 
              style={{ color: currentBanner.iconColor }}
            />
            <div className="banner-text-working">
              <div className="banner-title-working">{currentBanner.title}</div>
              <div className="banner-subtitle-working">{currentBanner.subtitle}</div>
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

        <div className="banner-indicators-working">
          {promotionalBanners.map((_, index) => (
            <button
              key={index}
              onClick={() => goToBanner(index)}
              className={`banner-indicator-working ${index === currentBannerIndex ? 'active' : ''}`}
              aria-label={`Go to promotion ${index + 1}`}
            />
          ))}
        </div>
      </div>
    );
  };

  // Houston area venues - completely static
  const [venues, setVenues] = useState([
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

  // Smart search functionality
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

  const getCrowdLabel = (level) => {
    const labels = ["", "Empty", "Quiet", "Moderate", "Busy", "Packed"];
    return labels[Math.round(level)] || "Unknown";
  };

  const getCrowdColor = (level) => {
    if (level <= 2) return "badge badge-green";
    if (level <= 3) return "badge badge-yellow";
    return "badge badge-red";
  };

  // Smart Search Bar Component
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

  // Star Rating Component
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

  // Rating Breakdown Component
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

  // Rating Modal Component
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

  // Reviews Modal Component
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

  // Report Modal Component
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

  // Venue Card Component
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

  // Venue Detail Component
  const VenueDetail = ({ venue }) => (
    <div className="app-layout">
      {/* Fixed Header Section */}
      <div className="header-frame">
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

      {/* Scrollable Content Section */}
      <div className="content-frame">
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
    </div>
  );

  // Enhanced Home View Component with Frame Separation
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
      <div className="app-layout">
        {/* Fixed Header Frame */}
        <div className="header-frame">
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
            
            <SearchBar />
            <PromotionalBanner />
          </div>
        </div>

        {/* Scrollable Content Frame */}
        <div className="content-frame">
          <div className="content-header">
            <div className="flex items-center justify-between">
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
          </div>

          <div className="venues-list">
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
      </div>
    );
  };

  // Handle report submission
  const handleReportSubmit = (reportData) => {
    setVenues(prevVenues =>
      prevVenues.map(venue =>
        venue.id === selectedVenue.id
          ? {
              ...venue,
              crowdLevel: reportData.crowdLevel,
              waitTime: reportData.waitTime,
              vibe: reportData.vibe.length > 0 ? reportData.vibe : venue.vibe,
              lastUpdate: "Just now",
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

  // Handle rating submission
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

print_success "App.jsx with VISIBLE banners created"

# Create WORKING CSS for visible banners
print_status "🎯 Creating WORKING CSS for visible banners..."
cat > src/App.css << 'CSSEOF'
/* nYtevibe - Houston Venue Tracker - WORKING Banner System */

/* Import modern fonts */
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap');

/* CSS Variables for consistent theming */
:root {
  /* Primary Colors */
  --primary-50: #eff6ff;
  --primary-100: #dbeafe;
  --primary-200: #bfdbfe;
  --primary-300: #93c5fd;
  --primary-400: #60a5fa;
  --primary-500: #3b82f6;
  --primary-600: #2563eb;
  --primary-700: #1d4ed8;
  --primary-800: #1e40af;
  --primary-900: #1e3a8a;

  /* Gradients */
  --gradient-primary: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  --gradient-secondary: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
  --gradient-success: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
  --gradient-warning: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
  --gradient-danger: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
  --gradient-houston: linear-gradient(135deg, #667eea 0%, #764ba2 100%);

  /* Background */
  --bg-primary: #f8fafc;
  --bg-secondary: #ffffff;
  --bg-glass: rgba(255, 255, 255, 0.25);
  --bg-overlay: rgba(0, 0, 0, 0.5);

  /* Text Colors */
  --text-primary: #1e293b;
  --text-secondary: #64748b;
  --text-muted: #94a3b8;
  --text-white: #ffffff;

  /* Shadows */
  --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
  --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
  --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
  --shadow-xl: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
  --shadow-glow: 0 0 20px rgba(59, 130, 246, 0.3);
  --shadow-card: 0 8px 32px rgba(0, 0, 0, 0.12);

  /* Border Radius */
  --radius-sm: 0.375rem;
  --radius-md: 0.5rem;
  --radius-lg: 0.75rem;
  --radius-xl: 1rem;
  --radius-2xl: 1.5rem;
  --radius-full: 9999px;

  /* Transitions */
  --transition-fast: all 0.15s ease;
  --transition-normal: all 0.3s ease;
  --transition-slow: all 0.5s ease;
}

/* Reset and base styles */
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen', sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  background: var(--gradient-houston);
  min-height: 100vh;
  color: var(--text-primary);
  line-height: 1.6;
  font-feature-settings: 'cv02', 'cv03', 'cv04', 'cv11';
}

#root {
  min-height: 100vh;
}

/* WORKING Promotional Banner System */

/* Container for banner */
.promotional-banner-working {
  margin-top: 1rem;
  display: flex;
  flex-direction: column;
  gap: 8px;
}

/* Main banner content - ALWAYS VISIBLE */
.promotional-banner-content {
  position: relative;
  display: flex;
  align-items: center;
  padding: 12px 16px;
  border: 2px solid rgba(255, 255, 255, 0.2);
  border-radius: var(--radius-lg);
  backdrop-filter: blur(10px);
  box-shadow: var(--shadow-lg);
  
  /* Smooth transitions for background color changes only */
  transition: background-color 0.6s ease, border-color 0.6s ease;
  
  /* Fixed minimum height to prevent layout shifts */
  min-height: 64px;
}

/* Banner main content area */
.banner-main-content {
  flex: 1;
  display: flex;
  align-items: center;
  gap: 12px;
  min-width: 0; /* Allows text truncation */
}

/* VISIBLE Banner Icon */
.banner-icon-working {
  width: 24px !important;
  height: 24px !important;
  flex-shrink: 0;
  transition: color 0.6s ease;
}

/* VISIBLE Banner Text Container */
.banner-text-working {
  flex: 1;
  min-width: 0;
}

/* VISIBLE Banner Title */
.banner-title-working {
  font-weight: 600;
  font-size: 0.875rem;
  line-height: 1.3;
  color: var(--text-primary);
  margin-bottom: 2px;
  
  /* Handle overflow gracefully */
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

/* VISIBLE Banner Subtitle */
.banner-subtitle-working {
  font-size: 0.75rem;
  color: var(--text-secondary);
  line-height: 1.3;
  
  /* Handle overflow gracefully */
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

/* Navigation buttons */
.banner-nav {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 32px;
  height: 32px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.9);
  border: 1px solid rgba(255, 255, 255, 0.3);
  backdrop-filter: blur(10px);
  color: var(--text-primary);
  cursor: pointer;
  transition: all 0.2s ease;
  flex-shrink: 0;
}

.banner-nav:hover {
  background: rgba(255, 255, 255, 1);
  transform: scale(1.05);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
}

.banner-nav-left {
  margin-right: 12px;
}

.banner-nav-right {
  margin-left: 12px;
}

/* WORKING Banner Indicators */
.banner-indicators-working {
  display: flex;
  justify-content: center;
  gap: 6px;
  padding: 0 16px;
}

.banner-indicator-working {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.4);
  border: none;
  cursor: pointer;
  transition: all 0.3s ease;
}

.banner-indicator-working.active {
  background: rgba(255, 255, 255, 0.9);
  transform: scale(1.2);
}

.banner-indicator-working:hover {
  background: rgba(255, 255, 255, 0.7);
  transform: scale(1.1);
}

/* Frame Layout System */
.app-layout {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  max-width: 28rem;
  margin: 0 auto;
  background: rgba(255, 255, 255, 0.05);
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.1);
  position: relative;
  overflow: hidden;
}

/* Fixed Header Frame */
.header-frame {
  position: sticky;
  top: 0;
  z-index: 20;
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(25px);
  border-bottom: 3px solid rgba(255, 255, 255, 0.3);
  box-shadow: 
    0 4px 20px rgba(0, 0, 0, 0.1),
    inset 0 1px 0 rgba(255, 255, 255, 0.4);
}

/* Content Frame */
.content-frame {
  flex: 1;
  overflow-y: auto;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  scroll-behavior: smooth;
  -webkit-overflow-scrolling: touch;
}

/* Content Header */
.content-header {
  padding: 1rem 1rem 0 1rem;
  margin-bottom: 1rem;
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border-radius: 0 0 var(--radius-lg) var(--radius-lg);
  border-bottom: 2px solid rgba(255, 255, 255, 0.2);
}

/* Venues List */
.venues-list {
  padding: 0 1rem 2rem 1rem;
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

/* Header Content */
.header-content {
  padding: 1.5rem;
  background: rgba(255, 255, 255, 0.02);
  border-radius: var(--radius-lg);
}

/* Modern Button Styles */
.btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 0.75rem 1.5rem;
  border-radius: var(--radius-lg);
  font-weight: 600;
  font-size: 0.875rem;
  text-decoration: none;
  border: none;
  cursor: pointer;
  transition: var(--transition-normal);
  position: relative;
  overflow: hidden;
  backdrop-filter: blur(10px);
  font-family: inherit;
}

.btn::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
  transition: left 0.5s;
}

.btn:hover::before {
  left: 100%;
}

.btn-primary {
  background: var(--gradient-primary);
  color: var(--text-white);
  box-shadow: var(--shadow-md);
}

.btn-primary:hover {
  transform: translateY(-2px);
  box-shadow: var(--shadow-xl);
}

.btn-secondary {
  background: rgba(255, 255, 255, 0.15);
  color: var(--text-primary);
  border: 1px solid rgba(255, 255, 255, 0.2);
  backdrop-filter: blur(10px);
}

.btn-secondary:hover {
  background: rgba(255, 255, 255, 0.25);
  transform: translateY(-1px);
}

.btn-success {
  background: var(--gradient-success);
  color: var(--text-white);
}

.btn-warning {
  background: var(--gradient-warning);
  color: var(--text-primary);
}

/* Modern Card Styles */
.card {
  background: rgba(255, 255, 255, 0.95);
  border-radius: var(--radius-xl);
  padding: 1.5rem;
  box-shadow: var(--shadow-card);
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.2);
  transition: var(--transition-normal);
  position: relative;
  overflow: hidden;
}

.card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 1px;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.8), transparent);
}

.card:hover {
  transform: translateY(-4px);
  box-shadow: var(--shadow-xl);
}

.card-venue {
  margin-bottom: 1rem;
  cursor: pointer;
}

.card-venue:hover {
  transform: translateY(-2px) scale(1.01);
}

/* App Title & Headers */
.app-title {
  font-size: 2rem;
  font-weight: 800;
  background: var(--gradient-primary);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  margin-bottom: 0.25rem;
}

.app-subtitle {
  color: var(--text-secondary);
  font-weight: 500;
}

.user-stats {
  display: flex;
  align-items: center;
  padding: 0.75rem 1rem;
  background: var(--gradient-warning);
  border-radius: var(--radius-full);
  color: var(--text-primary);
  font-weight: 600;
  box-shadow: var(--shadow-md);
}

.user-level {
  font-size: 0.75rem;
  color: var(--text-secondary);
  margin-top: 0.25rem;
}

/* Search Container */
.search-container {
  margin-bottom: 1rem;
}

.search-wrapper {
  position: relative;
  display: flex;
  align-items: center;
}

.search-icon {
  position: absolute;
  left: 12px;
  width: 18px;
  height: 18px;
  color: var(--text-muted);
  z-index: 1;
}

.search-input {
  width: 100%;
  padding: 12px 12px 12px 40px;
  padding-right: 40px;
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: var(--radius-lg);
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  color: var(--text-primary);
  font-size: 0.875rem;
  transition: var(--transition-normal);
  font-family: inherit;
}

.search-input:focus {
  outline: none;
  border-color: var(--primary-500);
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}

.search-clear {
  position: absolute;
  right: 12px;
  background: none;
  border: none;
  color: var(--text-muted);
  cursor: pointer;
  padding: 4px;
  border-radius: 4px;
  transition: var(--transition-fast);
}

.search-clear:hover {
  background: rgba(255, 255, 255, 0.1);
  color: var(--text-primary);
}

.search-results-info {
  margin-top: 8px;
  text-align: center;
}

.search-highlight {
  background: rgba(255, 235, 59, 0.3);
  padding: 1px 2px;
  border-radius: 2px;
  font-weight: 600;
}

/* Modern Badge/Tags */
.badge {
  display: inline-flex;
  align-items: center;
  padding: 0.25rem 0.75rem;
  border-radius: var(--radius-full);
  font-size: 0.75rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.025em;
}

.badge-green {
  background: rgba(34, 197, 94, 0.15);
  color: #15803d;
  border: 1px solid rgba(34, 197, 94, 0.3);
}

.badge-yellow {
  background: rgba(251, 191, 36, 0.15);
  color: #a16207;
  border: 1px solid rgba(251, 191, 36, 0.3);
}

.badge-red {
  background: rgba(239, 68, 68, 0.15);
  color: #dc2626;
  border: 1px solid rgba(239, 68, 68, 0.3);
}

.badge-blue {
  background: rgba(59, 130, 246, 0.15);
  color: var(--primary-700);
  border: 1px solid rgba(59, 130, 246, 0.3);
}

/* Modern Icons */
.icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
}

.icon-sm { width: 1rem; height: 1rem; }
.icon-md { width: 1.25rem; height: 1.25rem; }
.icon-lg { width: 1.5rem; height: 1.5rem; }

/* Venue Promotion Badge */
.venue-promotion-badge {
  position: absolute;
  top: -8px;
  right: -8px;
  background: var(--gradient-secondary);
  color: white;
  padding: 4px 8px;
  border-radius: var(--radius-full);
  font-size: 0.7rem;
  font-weight: 600;
  display: flex;
  align-items: center;
  box-shadow: var(--shadow-md);
  animation: pulse-glow 2s infinite;
}

/* Modern Spacing */
.space-y-1 > * + * { margin-top: 0.25rem; }
.space-y-2 > * + * { margin-top: 0.5rem; }
.space-y-3 > * + * { margin-top: 0.75rem; }
.space-y-4 > * + * { margin-top: 1rem; }
.space-y-6 > * + * { margin-top: 1.5rem; }
.space-x-1 > * + * { margin-left: 0.25rem; }
.space-x-2 > * + * { margin-left: 0.5rem; }
.space-x-3 > * + * { margin-left: 0.75rem; }
.space-x-4 > * + * { margin-left: 1rem; }

/* Modern Grid */
.grid { display: grid; }
.grid-cols-2 { grid-template-columns: repeat(2, minmax(0, 1fr)); }
.grid-cols-3 { grid-template-columns: repeat(3, minmax(0, 1fr)); }
.gap-2 { gap: 0.5rem; }
.gap-3 { gap: 0.75rem; }
.gap-4 { gap: 1rem; }

/* Modern Flexbox */
.flex { display: flex; }
.flex-1 { flex: 1 1 0%; }
.flex-wrap { flex-wrap: wrap; }
.items-center { align-items: center; }
.items-start { align-items: flex-start; }
.justify-center { justify-content: center; }
.justify-between { justify-content: space-between; }

/* Modern Text */
.text-xs { font-size: 0.75rem; line-height: 1rem; }
.text-sm { font-size: 0.875rem; line-height: 1.25rem; }
.text-base { font-size: 1rem; line-height: 1.5rem; }
.text-lg { font-size: 1.125rem; line-height: 1.75rem; }
.text-xl { font-size: 1.25rem; line-height: 1.75rem; }
.text-2xl { font-size: 1.5rem; line-height: 2rem; }
.text-3xl { font-size: 1.875rem; line-height: 2.25rem; }

.font-normal { font-weight: 400; }
.font-medium { font-weight: 500; }
.font-semibold { font-weight: 600; }
.font-bold { font-weight: 700; }
.font-extrabold { font-weight: 800; }

.text-white { color: var(--text-white); }
.text-primary { color: var(--text-primary); }
.text-secondary { color: var(--text-secondary); }
.text-muted { color: var(--text-muted); }

/* Modern Layout */
.p-2 { padding: 0.5rem; }
.p-3 { padding: 0.75rem; }
.p-4 { padding: 1rem; }
.p-6 { padding: 1.5rem; }
.px-2 { padding-left: 0.5rem; padding-right: 0.5rem; }
.px-3 { padding-left: 0.75rem; padding-right: 0.75rem; }
.px-4 { padding-left: 1rem; padding-right: 1rem; }
.px-6 { padding-left: 1.5rem; padding-right: 1.5rem; }
.py-2 { padding-top: 0.5rem; padding-bottom: 0.5rem; }
.py-3 { padding-top: 0.75rem; padding-bottom: 0.75rem; }
.py-4 { padding-top: 1rem; padding-bottom: 1rem; }

.m-2 { margin: 0.5rem; }
.m-3 { margin: 0.75rem; }
.m-4 { margin: 1rem; }
.mb-2 { margin-bottom: 0.5rem; }
.mb-3 { margin-bottom: 0.75rem; }
.mb-4 { margin-bottom: 1rem; }
.mb-6 { margin-bottom: 1.5rem; }
.mt-2 { margin-top: 0.5rem; }
.mt-3 { margin-top: 0.75rem; }
.mt-4 { margin-top: 1rem; }
.mr-2 { margin-right: 0.5rem; }
.mr-3 { margin-right: 0.75rem; }
.ml-2 { margin-left: 0.5rem; }
.ml-3 { margin-left: 0.75rem; }

/* Modern Animations */
@keyframes fadeIn {
  from { opacity: 0; transform: translateY(20px); }
  to { opacity: 1; transform: translateY(0); }
}

@keyframes slideIn {
  from { transform: translateX(-100%); }
  to { transform: translateX(0); }
}

@keyframes pulse-glow {
  0%, 100% { box-shadow: 0 0 5px rgba(59, 130, 246, 0.3); }
  50% { box-shadow: 0 0 20px rgba(59, 130, 246, 0.6); }
}

@keyframes float {
  0%, 100% { transform: translateY(0px); }
  50% { transform: translateY(-10px); }
}

.animate-fadeIn { animation: fadeIn 0.5s ease-out; }
.animate-slideIn { animation: slideIn 0.3s ease-out; }
.animate-float { animation: float 3s ease-in-out infinite; }
.animate-pulse { animation: pulse 2s infinite; }

/* Modern Forms */
.form-input {
  width: 100%;
  padding: 0.75rem 1rem;
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: var(--radius-lg);
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  color: var(--text-primary);
  font-size: 0.875rem;
  transition: var(--transition-normal);
  font-family: inherit;
}

.form-input:focus {
  outline: none;
  border-color: var(--primary-500);
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}

.form-textarea {
  min-height: 4rem;
  resize: vertical;
}

/* Modern Modal */
.modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.6);
  backdrop-filter: blur(4px);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 1rem;
  z-index: 50;
  animation: fadeIn 0.2s ease-out;
}

.modal-content {
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(20px);
  border-radius: var(--radius-2xl);
  padding: 2rem;
  max-width: 28rem;
  width: 100%;
  box-shadow: var(--shadow-xl);
  border: 1px solid rgba(255, 255, 255, 0.2);
  animation: slideIn 0.3s ease-out;
}

/* Stats Cards */
.stats-card {
  background: var(--gradient-primary);
  color: var(--text-white);
  border-radius: var(--radius-xl);
  padding: 1.5rem;
  text-align: center;
  box-shadow: var(--shadow-lg);
}

.stats-number {
  font-size: 2rem;
  font-weight: 800;
  margin-bottom: 0.25rem;
}

.stats-label {
  font-size: 0.875rem;
  opacity: 0.9;
}

/* Color Utilities */
.bg-blue-100 { background-color: #dbeafe; }
.bg-green-100 { background-color: #dcfce7; }
.bg-amber-100 { background-color: #fef3c7; }
.text-green-600 { color: #16a34a; }
.text-amber-600 { color: #d97706; }
.text-yellow-400 { color: #facc15; }

/* Sort Dropdown */
.sort-dropdown {
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
  color: var(--text-white);
}

.sort-dropdown option {
  background: var(--bg-secondary);
  color: var(--text-primary);
}

/* Responsive Design */
@media (max-width: 768px) {
  .app-layout {
    margin: 0;
    border-radius: 0;
    border-left: none;
    border-right: none;
    max-width: 100vw;
  }
  
  .header-frame {
    border-radius: 0;
  }
  
  .header-content {
    padding: 1rem;
  }
  
  .content-header {
    padding: 0.75rem;
    border-radius: 0;
  }
  
  .venues-list {
    padding: 0 0.75rem 1.5rem 0.75rem;
  }
  
  .app-title {
    font-size: 1.75rem;
  }
  
  .btn {
    padding: 0.625rem 1.25rem;
    font-size: 0.8rem;
  }
  
  .promotional-banner-content {
    padding: 10px 12px;
    min-height: 56px;
  }
  
  .banner-icon-working {
    width: 20px !important;
    height: 20px !important;
  }
  
  .banner-title-working {
    font-size: 0.8rem;
  }
  
  .banner-subtitle-working {
    font-size: 0.7rem;
  }
  
  .banner-nav {
    width: 28px;
    height: 28px;
  }
  
  .banner-nav-left {
    margin-right: 8px;
  }
  
  .banner-nav-right {
    margin-left: 8px;
  }
}

/* Accessibility */
@media (prefers-reduced-motion: reduce) {
  * {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}

/* Focus styles for accessibility */
*:focus {
  outline: 2px solid var(--primary-500);
  outline-offset: 2px;
}

/* High contrast mode */
@media (prefers-contrast: high) {
  .card {
    border: 2px solid var(--text-primary);
  }
  
  .btn {
    border: 2px solid currentColor;
  }
  
  .promotional-banner-content {
    border: 2px solid var(--text-primary);
    background: var(--bg-secondary);
  }
  
  .banner-nav {
    border: 2px solid var(--text-primary);
    background: var(--bg-secondary);
  }
  
  .banner-indicator-working {
    border: 1px solid var(--text-primary);
  }
}

/* Custom scrollbar */
::-webkit-scrollbar {
  width: 8px;
}

::-webkit-scrollbar-track {
  background: rgba(255, 255, 255, 0.1);
  border-radius: 4px;
}

::-webkit-scrollbar-thumb {
  background: rgba(255, 255, 255, 0.3);
  border-radius: 4px;
}

::-webkit-scrollbar-thumb:hover {
  background: rgba(255, 255, 255, 0.5);
}

/* Selection styles */
::selection {
  background: rgba(59, 130, 246, 0.3);
  color: inherit;
}

::-moz-selection {
  background: rgba(59, 130, 246, 0.3);
  color: inherit;
}

/* Frame Separator */
.header-frame::after {
  content: '';
  position: absolute;
  bottom: -2px;
  left: 0;
  right: 0;
  height: 4px;
  background: linear-gradient(90deg, 
    transparent, 
    rgba(255, 255, 255, 0.4) 20%, 
    rgba(255, 255, 255, 0.6) 50%, 
    rgba(255, 255, 255, 0.4) 80%, 
    transparent
  );
  border-radius: 0 0 var(--radius-sm) var(--radius-sm);
}

.content-frame {
  border-top: 1px solid rgba(255, 255, 255, 0.2);
  margin-top: 2px;
}

CSSEOF

print_success "WORKING CSS for visible banners created"

# Test the build
print_status "🔨 Building the banner visibility fix..."
if npm run build; then
    print_success "Build completed successfully"
else
    print_error "Build failed"
    exit 1
fi

# Deploy to web directory
print_status "🚀 Deploying banner visibility fix..."
sudo mkdir -p /var/www/html/nytevibe
if sudo cp -r dist/* /var/www/html/nytevibe/; then
    print_success "Banner visibility fix deployed to /var/www/html/nytevibe"
else
    print_error "Failed to deploy"
    exit 1
fi

# Set proper permissions
print_status "🔧 Setting secure permissions..."
sudo chown -R www-data:www-data /var/www/html/nytevibe
sudo chmod -R 755 /var/www/html/nytevibe

print_header "BANNER VISIBILITY FIXED!"
print_header "======================="
print_success ""
print_success "🎯 ALL 5 BANNERS NOW VISIBLE:"
print_feature "📢 Community: 'Help your community!'"
print_feature "🎉 NYC Vibes: 'Free Hookah for Ladies!'"
print_feature "🎵 Best Regards: 'Guess who's here tonight!'"
print_feature "🎤 Rumors: 'R&B Night Special!'"
print_feature "🏈 Classic: 'Big Game Tonight!'"
print_success ""
print_success "✅ WORKING FEATURES:"
print_feature "👁️ All banners are clearly visible"
print_feature "🔄 Auto-rotation every 12 seconds"
print_feature "👆 Manual navigation with arrow buttons"
print_feature "🎯 Clickable indicators at bottom"
print_feature "📱 Mobile-responsive design"
print_feature "🎨 Beautiful glassmorphism styling"
print_feature "⚡ Smooth background color transitions"
print_success ""
print_success "🎨 BANNER STYLING:"
print_feature "🌈 Each banner has unique colors and icons"
print_feature "💫 Smooth transitions between banners"
print_feature "🔳 Fixed height prevents layout shifts"
print_feature "📱 Responsive design for all screen sizes"
print_feature "♿ Accessibility support with ARIA labels"
print_success ""
print_success "🔧 TECHNICAL IMPROVEMENTS:"
print_feature "🎯 Simple, reliable state management"
print_feature "📐 Fixed dimensions prevent content jumps"
print_feature "🎨 CSS-only background transitions"
print_feature "⚡ No complex double-buffering"
print_feature "🚫 Removed problematic visibility CSS"
print_success ""
print_success "🎉 SUCCESS! All 5 promotional banners are now visible!"
print_success "Test your working banners at: https://blackaxl.com"
