#!/bin/bash

# nYtevibe Complete System Builder v2.0
# Builds the entire nYtevibe application from v1.0 to v2.0 with all advanced features
# Including: Landing page, user profile dropdown, enhanced venue system, real-time features

echo "🚀 Building nYtevibe v2.0 - Complete Houston Nightlife Discovery Platform"
echo "=================================================================="
echo ""

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    echo "❌ Error: package.json not found. Please run this script in your nytevibe project directory."
    echo "   If this is a new project, run: npm create vite@latest nytevibe -- --template react"
    exit 1
fi

echo "📁 Creating enhanced directory structure..."

# Create all required directories
mkdir -p src/components/Layout
mkdir -p src/components/User
mkdir -p src/components/Search
mkdir -p src/components/Venue
mkdir -p src/components/Views
mkdir -p src/components/Social
mkdir -p src/components/LandingPage
mkdir -p src/context
mkdir -p src/hooks
mkdir -p src/utils
mkdir -p src/constants
mkdir -p src/views/Landing

echo "✅ Directory structure created"

# 1. Enhanced Constants with v2.0 features
echo "📝 Creating enhanced constants/index.js..."

cat > src/constants/index.js << 'EOF'
export const EMOJI_OPTIONS = ['📍', '💕', '🏈', '🎉', '🍻', '☕', '🌙', '🎵', '🍽️', '🎭', '🏃', '💼', '💨', '🔥'];

export const VIBE_OPTIONS = [
  "Chill", "Lively", "Loud", "Dancing", "Sports", "Date Night",
  "Business", "Family", "Hip-Hop", "R&B", "Live Music", "Karaoke",
  "Hookah", "Rooftop", "VIP", "Happy Hour"
];

export const UPDATE_INTERVALS = {
  VENUE_DATA: 45000, // 45 seconds
  NOTIFICATION_DURATION: 3000, // 3 seconds
  PROMOTION_PULSE: 3000, // 3 seconds
  FOLLOW_ANIMATION: 2000, // 2 seconds
  BANNER_ROTATION: 4000 // 4 seconds
};

export const PROMOTIONAL_BANNERS = [
  {
    id: 'community',
    type: 'community',
    icon: 'MessageCircle',
    title: "Help your community!",
    subtitle: "Rate venues and report status to earn points",
    bgColor: "linear-gradient(135deg, #3b82f6, #2563eb)",
    borderColor: "#3b82f6",
    iconColor: "#ffffff",
    textColor: "#ffffff"
  },
  {
    id: 'nyc-promo',
    type: 'promotion',
    venue: 'NYC Vibes',
    icon: 'Gift',
    title: "NYC Vibes says: Free Hookah for Ladies! 🎉",
    subtitle: "6:00 PM - 10:00 PM • Tonight Only • Limited Time",
    bgColor: "linear-gradient(135deg, #ec4899, #db2777)",
    borderColor: "#ec4899",
    iconColor: "#ffffff",
    textColor: "#ffffff"
  },
  {
    id: 'red-sky-grand-opening',
    type: 'promotion',
    venue: 'Red Sky Hookah Lounge',
    icon: 'Sparkles',
    title: "Red Sky: Grand Opening Special! 🔥",
    subtitle: "50% Off Premium Hookah • Live DJ • VIP Lounge Available",
    bgColor: "linear-gradient(135deg, #ef4444, #dc2626)",
    borderColor: "#ef4444",
    iconColor: "#ffffff",
    textColor: "#ffffff"
  },
  {
    id: 'best-regards-event',
    type: 'event',
    venue: 'Best Regards',
    icon: 'Volume2',
    title: "Best Regards Says: Guess who's here tonight! 🎵",
    subtitle: "#DJ Chin is spinning • 9:00 PM - 2:00 AM • Don't miss out!",
    bgColor: "linear-gradient(135deg, #a855f7, #9333ea)",
    borderColor: "#a855f7",
    iconColor: "#ffffff",
    textColor: "#ffffff"
  },
  {
    id: 'rumors-special',
    type: 'promotion',
    venue: 'Rumors',
    icon: 'Calendar',
    title: "Rumors: R&B Night Special! 🎤",
    subtitle: "2-for-1 cocktails • Live R&B performances • 8:00 PM start",
    bgColor: "linear-gradient(135deg, #22c55e, #16a34a)",
    borderColor: "#22c55e",
    iconColor: "#ffffff",
    textColor: "#ffffff"
  },
  {
    id: 'classic-game',
    type: 'event',
    venue: 'Classic',
    icon: 'Volume2',
    title: "Classic Bar: Big Game Tonight! 🏈",
    subtitle: "Texans vs Cowboys • 50¢ wings • Free shots for TDs!",
    bgColor: "linear-gradient(135deg, #fb923c, #f97316)",
    borderColor: "#fb923c",
    iconColor: "#ffffff",
    textColor: "#ffffff"
  },
  {
    id: 'social-new',
    type: 'social',
    icon: 'UserPlus',
    title: "Connect with friends! 👥",
    subtitle: "Share venues, create lists, and discover together",
    bgColor: "linear-gradient(135deg, #a855f7, #9333ea)",
    borderColor: "#a855f7",
    iconColor: "#ffffff",
    textColor: "#ffffff"
  },
  {
    id: 'ai-recommendations',
    type: 'ai',
    icon: 'Brain',
    title: "AI-Powered Recommendations! 🤖",
    subtitle: "Discover venues tailored to your taste profile",
    bgColor: "linear-gradient(135deg, #22c55e, #16a34a)",
    borderColor: "#22c55e",
    iconColor: "#ffffff",
    textColor: "#ffffff"
  }
];

export const POINT_SYSTEM = {
  FOLLOW_VENUE: 3,
  UNFOLLOW_VENUE: -2,
  RATE_VENUE: 5,
  REPORT_VENUE: 10,
  SHARE_VENUE: 2,
  CREATE_LIST: 10,
  HELPFUL_REVIEW: 1
};

export const USER_LEVELS = [
  { name: 'Bronze Explorer', tier: 'bronze', minPoints: 0, maxPoints: 499 },
  { name: 'Silver Scout', tier: 'silver', minPoints: 500, maxPoints: 999 },
  { name: 'Gold Explorer', tier: 'gold', minPoints: 1000, maxPoints: 1999 },
  { name: 'Platinum Pioneer', tier: 'platinum', minPoints: 2000, maxPoints: 4999 },
  { name: 'Diamond Legend', tier: 'diamond', minPoints: 5000, maxPoints: 999999 }
];
EOF

# 2. Enhanced Utility Functions
echo "📝 Creating enhanced utils/helpers.js..."

cat > src/utils/helpers.js << 'EOF'
// Enhanced utility functions for nYtevibe v2.0

export const getCrowdLabel = (level) => {
  const labels = ["", "Empty", "Quiet", "Moderate", "Busy", "Packed"];
  return labels[Math.round(level)] || "Unknown";
};

export const getCrowdColor = (level) => {
  if (level <= 2) return "badge badge-green";
  if (level <= 3) return "badge badge-yellow";
  return "badge badge-red";
};

export const getTrendingIcon = (trending) => {
  switch (trending) {
    case 'up': return '📈';
    case 'down': return '📉';
    default: return '➡️';
  }
};

export const formatTimestamp = (timestamp) => {
  const date = new Date(timestamp);
  const now = new Date();
  const diffInHours = (now - date) / (1000 * 60 * 60);

  if (diffInHours < 24) {
    return date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
  } else if (diffInHours < 24 * 7) {
    return date.toLocaleDateString([], { weekday: 'short', hour: '2-digit', minute: '2-digit' });
  } else {
    return date.toLocaleDateString([], { month: 'short', day: 'numeric' });
  }
};

export const getUserInitials = (firstName, lastName) => {
  return `${firstName.charAt(0)}${lastName.charAt(0)}`.toUpperCase();
};

export const getLevelColor = (tier) => {
  const colors = {
    bronze: '#cd7f32',
    silver: '#c0c0c0',
    gold: '#ffd700',
    platinum: '#e5e4e2',
    diamond: '#b9f2ff'
  };
  return colors[tier] || '#c0c0c0';
};

export const getLevelIcon = (tier) => {
  const icons = {
    diamond: '👑',
    platinum: '🛡️',
    gold: '🏆',
    silver: '⭐',
    bronze: '🥉'
  };
  return icons[tier] || '⭐';
};

export const openGoogleMaps = (venue) => {
  const address = encodeURIComponent(venue.address);
  const url = `https://www.google.com/maps/search/?api=1&query=${address}`;
  window.open(url, '_blank');
};

export const getDirections = (venue) => {
  const address = encodeURIComponent(venue.address);
  const url = `https://www.google.com/maps/dir/?api=1&destination=${address}`;
  window.open(url, '_blank');
};

export const shareVenue = (venue, platform) => {
  const shareUrl = `https://nytevibe.com/venue/${venue.id}`;
  const shareText = `Check out ${venue.name} on nYtevibe! ${venue.type} • ${venue.rating}/5 stars`;

  switch (platform) {
    case 'facebook':
      window.open(`https://www.facebook.com/sharer/sharer.php?u=${encodeURIComponent(shareUrl)}`);
      break;
    case 'twitter':
      window.open(`https://twitter.com/intent/tweet?text=${encodeURIComponent(shareText)}&url=${encodeURIComponent(shareUrl)}`);
      break;
    case 'instagram':
      navigator.clipboard.writeText(shareUrl);
      break;
    case 'copy':
      navigator.clipboard.writeText(`${shareText}\n${shareUrl}`);
      break;
    case 'whatsapp':
      window.open(`https://wa.me/?text=${encodeURIComponent(`${shareText}\n${shareUrl}`)}`);
      break;
  }
};

// New v2.0 utilities
export const calculateUserLevel = (points) => {
  const levels = [
    { name: 'Bronze Explorer', tier: 'bronze', minPoints: 0, maxPoints: 499 },
    { name: 'Silver Scout', tier: 'silver', minPoints: 500, maxPoints: 999 },
    { name: 'Gold Explorer', tier: 'gold', minPoints: 1000, maxPoints: 1999 },
    { name: 'Platinum Pioneer', tier: 'platinum', minPoints: 2000, maxPoints: 4999 },
    { name: 'Diamond Legend', tier: 'diamond', minPoints: 5000, maxPoints: 999999 }
  ];
  
  return levels.find(level => points >= level.minPoints && points <= level.maxPoints) || levels[0];
};

export const generateUniqueId = () => {
  return Date.now().toString(36) + Math.random().toString(36).substr(2);
};

export const debounce = (func, wait) => {
  let timeout;
  return function executedFunction(...args) {
    const later = () => {
      clearTimeout(timeout);
      func(...args);
    };
    clearTimeout(timeout);
    timeout = setTimeout(later, wait);
  };
};
EOF

# 3. Enhanced Context with Navigation
echo "📝 Creating enhanced context/AppContext.jsx..."

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
        { id: 3, user: "Papove B.", rating: 5, comment: "Finally, a quality hookah spot! Clean, modern, and excellent service.", date: "3 days ago", helpful: 15 }
      ]
    }
  ],
  notifications: [],
  currentView: 'landing',
  currentMode: null, // 'user' | 'venue_owner' | null
  selectedVenue: null,
  showRatingModal: false,
  showReportModal: false,
  showShareModal: false,
  shareVenue: null,
  isTransitioning: false,
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
    }
  ]
};

const appReducer = (state, action) => {
  switch (action.type) {
    case 'SET_CURRENT_VIEW':
      return { ...state, currentView: action.payload };
    
    case 'SET_CURRENT_MODE':
      return { ...state, currentMode: action.payload };
    
    case 'SET_SELECTED_VENUE':
      return { ...state, selectedVenue: action.payload };
    
    case 'SET_SHOW_RATING_MODAL':
      return { ...state, showRatingModal: action.payload };
    
    case 'SET_SHOW_REPORT_MODAL':
      return { ...state, showReportModal: action.payload };
    
    case 'SET_SHOW_SHARE_MODAL':
      return { ...state, showShareModal: action.payload, shareVenue: action.payload ? state.shareVenue : null };
    
    case 'SET_SHARE_VENUE':
      return { ...state, shareVenue: action.payload };
    
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

    setCurrentMode: useCallback((mode) => {
      dispatch({ type: 'SET_CURRENT_MODE', payload: mode });
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

    setShowShareModal: useCallback((show) => {
      dispatch({ type: 'SET_SHOW_SHARE_MODAL', payload: show });
    }, []),

    setShareVenue: useCallback((venue) => {
      dispatch({ type: 'SET_SHARE_VENUE', payload: venue });
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

# 4. Enhanced Hooks
echo "📝 Creating enhanced hooks..."

cat > src/hooks/useVenues.js << 'EOF'
import { useCallback } from 'react';
import { useApp } from '../context/AppContext';

export const useVenues = () => {
  const { state, actions } = useApp();

  const updateVenueData = useCallback(() => {
    actions.updateVenueData();
  }, [actions]);

  const isVenueFollowed = useCallback((venueId) => {
    return state.userProfile.followedVenues.includes(venueId);
  }, [state.userProfile.followedVenues]);

  const followVenue = useCallback((venue) => {
    if (!isVenueFollowed(venue.id)) {
      actions.followVenue(venue.id, venue.name);
      actions.addNotification({
        type: 'follow',
        message: `Following ${venue.name} (+3 points!)`,
        duration: 3000
      });
    }
  }, [actions, isVenueFollowed]);

  const unfollowVenue = useCallback((venue) => {
    if (isVenueFollowed(venue.id)) {
      actions.unfollowVenue(venue.id, venue.name);
      actions.addNotification({
        type: 'unfollow',
        message: `Unfollowed ${venue.name}`,
        duration: 3000
      });
    }
  }, [actions, isVenueFollowed]);

  const toggleFollow = useCallback((venue) => {
    if (isVenueFollowed(venue.id)) {
      unfollowVenue(venue);
    } else {
      followVenue(venue);
    }
  }, [isVenueFollowed, followVenue, unfollowVenue]);

  const getFilteredVenues = useCallback((searchQuery, filter) => {
    let filtered = state.venues;

    // Apply search filter
    if (searchQuery.trim()) {
      const query = searchQuery.toLowerCase();
      filtered = filtered.filter(venue =>
        venue.name.toLowerCase().includes(query) ||
        venue.type.toLowerCase().includes(query) ||
        venue.city.toLowerCase().includes(query) ||
        venue.vibe.some(v => v.toLowerCase().includes(query))
      );
    }

    // Apply category filter
    switch (filter) {
      case 'followed':
        filtered = filtered.filter(venue => isVenueFollowed(venue.id));
        break;
      case 'nearby':
        filtered = filtered.filter(venue => parseFloat(venue.distance) <= 0.5);
        break;
      case 'open':
        filtered = filtered.filter(venue => venue.isOpen);
        break;
      case 'promotions':
        filtered = filtered.filter(venue => venue.hasPromotion);
        break;
      default:
        // 'all' - no additional filtering
        break;
    }

    return filtered;
  }, [state.venues, isVenueFollowed]);

  return {
    venues: state.venues,
    selectedVenue: state.selectedVenue,
    updateVenueData,
    isVenueFollowed,
    followVenue,
    unfollowVenue,
    toggleFollow,
    getFilteredVenues
  };
};
EOF

cat > src/hooks/useNotifications.js << 'EOF'
import { useEffect } from 'react';
import { useApp } from '../context/AppContext';

export const useNotifications = () => {
  const { state, actions } = useApp();

  useEffect(() => {
    const timers = state.notifications.map(notification => {
      return setTimeout(() => {
        actions.removeNotification(notification.id);
      }, notification.duration);
    });

    return () => {
      timers.forEach(timer => clearTimeout(timer));
    };
  }, [state.notifications, actions]);

  return {
    notifications: state.notifications,
    addNotification: actions.addNotification,
    removeNotification: actions.removeNotification
  };
};
EOF

cat > src/hooks/useAI.js << 'EOF'
import { useState, useCallback } from 'react';
import { useApp } from '../context/AppContext';

export const useAI = () => {
  const { state } = useApp();
  const [isLoading, setIsLoading] = useState(false);

  const getRecommendations = useCallback(async (userPreferences) => {
    setIsLoading(true);
    // Simulate AI recommendation logic
    setTimeout(() => {
      setIsLoading(false);
    }, 1000);

    return state.venues.filter(venue =>
      venue.rating >= 4.0 && !state.userProfile.followedVenues.includes(venue.id)
    ).slice(0, 3);
  }, [state.venues, state.userProfile.followedVenues]);

  return {
    getRecommendations,
    isLoading
  };
};
EOF

# 5. Landing Page Component
echo "📝 Creating landing page component..."

cat > src/views/Landing/WelcomeLandingPage.jsx << 'EOF'
import React, { useState } from 'react';
import { useApp } from '../../context/AppContext';
import './WelcomeLandingPage.css';

const WelcomeLandingPage = () => {
  const { actions } = useApp();
  const [isTransitioning, setIsTransitioning] = useState(false);

  const selectProfile = (mode) => {
    setIsTransitioning(true);
    
    setTimeout(() => {
      actions.setCurrentMode(mode);
      actions.setCurrentView('home');
      setIsTransitioning(false);
    }, 500);
  };

  return (
    <div className={`landing-page ${isTransitioning ? 'transitioning' : ''}`}>
      <div className="landing-hero">
        <h1 className="landing-title">nYtevibe</h1>
        <h2 className="landing-subtitle">Houston Nightlife Discovery</h2>
        <p className="landing-description">
          Discover real-time venue vibes, connect with your community, and experience Houston's nightlife like never before.
        </p>
      </div>
      
      <div className="profile-selection">
        <div className="profile-card customer-card" onClick={() => selectProfile('user')}>
          <div className="profile-icon">🎉</div>
          <h3 className="profile-title">Customer Experience</h3>
          <ul className="profile-features">
            <li>Discover venues with real-time data</li>
            <li>Follow your favorite spots</li>
            <li>Rate and review experiences</li>
            <li>Earn points and badges</li>
            <li>Share with friends</li>
            <li>Get personalized recommendations</li>
          </ul>
        </div>
        
        <div className="profile-card business-card" onClick={() => selectProfile('venue_owner')}>
          <div className="profile-icon">📊</div>
          <h3 className="profile-title">Business Dashboard</h3>
          <ul className="profile-features">
            <li>Real-time venue analytics</li>
            <li>Manage staff and operations</li>
            <li>Monitor customer feedback</li>
            <li>Track crowd levels and trends</li>
            <li>Promote events and specials</li>
            <li>Build community engagement</li>
          </ul>
        </div>
      </div>
    </div>
  );
};

export default WelcomeLandingPage;
EOF

# 6. Landing Page CSS
echo "📝 Creating landing page styles..."

cat > src/views/Landing/WelcomeLandingPage.css << 'EOF'
.landing-page {
  min-height: 100vh;
  background: linear-gradient(135deg, #1e293b 0%, #334155 100%);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 20px;
  text-align: center;
  transition: opacity 0.5s ease;
}

.landing-page.transitioning {
  opacity: 0;
}

.landing-hero {
  margin-bottom: 60px;
}

.landing-title {
  font-size: 3.5rem;
  font-weight: 800;
  background: linear-gradient(135deg, #3b82f6, #ec4899);
  -webkit-background-clip: text;
  background-clip: text;
  -webkit-text-fill-color: transparent;
  margin-bottom: 16px;
}

.landing-subtitle {
  font-size: 1.5rem;
  color: rgba(255, 255, 255, 0.8);
  margin-bottom: 12px;
}

.landing-description {
  font-size: 1.1rem;
  color: rgba(255, 255, 255, 0.7);
  max-width: 600px;
  line-height: 1.6;
}

.profile-selection {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 30px;
  max-width: 800px;
  width: 100%;
}

.profile-card {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 16px;
  padding: 40px 30px;
  cursor: pointer;
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
}

.profile-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(135deg, transparent, rgba(255, 255, 255, 0.1));
  opacity: 0;
  transition: opacity 0.3s ease;
}

.profile-card:hover::before {
  opacity: 1;
}

.profile-card:hover {
  transform: translateY(-8px);
  background: rgba(255, 255, 255, 0.15);
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
  border-color: rgba(255, 255, 255, 0.3);
}

.customer-card:hover {
  border-color: #3b82f6;
  box-shadow: 0 20px 40px rgba(59, 130, 246, 0.3);
}

.business-card:hover {
  border-color: #ec4899;
  box-shadow: 0 20px 40px rgba(236, 72, 153, 0.3);
}

.profile-icon {
  font-size: 3rem;
  margin-bottom: 20px;
}

.profile-title {
  font-size: 1.5rem;
  font-weight: 700;
  color: white;
  margin-bottom: 20px;
}

.profile-features {
  list-style: none;
  text-align: left;
  color: rgba(255, 255, 255, 0.8);
  font-size: 0.95rem;
}

.profile-features li {
  margin-bottom: 10px;
  padding-left: 20px;
  position: relative;
  line-height: 1.4;
}

.profile-features li::before {
  content: "✓";
  position: absolute;
  left: 0;
  color: #10b981;
  font-weight: bold;
  font-size: 1rem;
}

/* Mobile Responsive */
@media (max-width: 768px) {
  .landing-title {
    font-size: 2.5rem;
  }
  
  .landing-subtitle {
    font-size: 1.25rem;
  }
  
  .landing-description {
    font-size: 1rem;
  }
  
  .profile-selection {
    grid-template-columns: 1fr;
    gap: 20px;
  }
  
  .profile-card {
    padding: 30px 25px;
  }
}

@media (max-width: 480px) {
  .landing-page {
    padding: 16px;
  }
  
  .landing-hero {
    margin-bottom: 40px;
  }
  
  .landing-title {
    font-size: 2rem;
  }
  
  .profile-card {
    padding: 25px 20px;
  }
  
  .profile-features {
    font-size: 0.875rem;
  }
}
EOF

# 7. Enhanced Header Component
echo "📝 Creating enhanced header component..."

cat > src/components/Layout/Header.jsx << 'EOF'
import React, { useState } from 'react';
import { useApp } from '../../context/AppContext';
import SearchSection from '../Search/SearchSection';
import UserProfile from '../User/UserProfile';

const Header = ({ searchQuery, setSearchQuery, onClearSearch }) => {
  const { state } = useApp();

  return (
    <div className="header-frame">
      <div className="header-content">
        <div className="header-top-row">
          <div className="logo-section">
            <h1 className="app-title">nYtevibe</h1>
            <p className="app-subtitle">Discover real-time venue vibes in Houston</p>
          </div>
          <UserProfile />
        </div>
        <SearchSection 
          searchQuery={searchQuery}
          setSearchQuery={setSearchQuery}
          onClearSearch={onClearSearch}
        />
      </div>
    </div>
  );
};

export default Header;
EOF

# 8. Enhanced User Profile Component with Dropdown
echo "📝 Creating enhanced user profile component..."

cat > src/components/User/UserProfile.jsx << 'EOF'
import React, { useState, useEffect, useRef } from 'react';
import { useApp } from '../../context/AppContext';
import { getUserInitials, getLevelIcon } from '../../utils/helpers';
import './UserProfile.css';

const UserProfile = () => {
  const { state, actions } = useApp();
  const { userProfile } = state;
  const [isDropdownOpen, setIsDropdownOpen] = useState(false);
  const dropdownRef = useRef(null);

  // Close dropdown when clicking outside
  useEffect(() => {
    const handleClickOutside = (event) => {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target)) {
        setIsDropdownOpen(false);
      }
    };

    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  // Close dropdown on escape key
  useEffect(() => {
    const handleEscape = (event) => {
      if (event.key === 'Escape') {
        setIsDropdownOpen(false);
      }
    };

    document.addEventListener('keydown', handleEscape);
    return () => document.removeEventListener('keydown', handleEscape);
  }, []);

  const toggleDropdown = () => {
    setIsDropdownOpen(!isDropdownOpen);
  };

  const handleMenuAction = (action) => {
    setIsDropdownOpen(false);
    
    switch (action) {
      case 'profile':
        actions.addNotification({
          type: 'default',
          message: '🔍 Opening Full Profile View...'
        });
        break;
      case 'edit':
        actions.addNotification({
          type: 'default',
          message: '✏️ Opening Profile Editor...'
        });
        break;
      case 'lists':
        actions.addNotification({
          type: 'default',
          message: '💕 Opening Venue Lists...'
        });
        break;
      case 'activity':
        actions.addNotification({
          type: 'default',
          message: '📊 Opening Activity History...'
        });
        break;
      case 'settings':
        actions.addNotification({
          type: 'default',
          message: '⚙️ Opening Settings...'
        });
        break;
      case 'help':
        actions.addNotification({
          type: 'default',
          message: '🆘 Opening Help & Support...'
        });
        break;
      case 'signout':
        if (window.confirm('🚪 Are you sure you want to sign out?')) {
          actions.addNotification({
            type: 'default',
            message: '👋 Signing out... See you next time!'
          });
          // Add actual sign out logic here
        }
        break;
      default:
        break;
    }
  };

  const initials = getUserInitials(userProfile.firstName, userProfile.lastName);
  const levelIcon = getLevelIcon(userProfile.levelTier);

  return (
    <div className="user-badge-container" ref={dropdownRef}>
      <div 
        className={`user-badge ${isDropdownOpen ? 'open' : ''}`}
        onClick={toggleDropdown}
      >
        <div className="user-avatar-badge">{initials}</div>
        <div className="user-info-badge">
          <div className="user-name-badge">
            {userProfile.firstName} {userProfile.lastName}
          </div>
          <div className="user-level-badge">
            {levelIcon} {userProfile.level}
            <span className="points-badge">{userProfile.points.toLocaleString()}</span>
          </div>
        </div>
        <svg className="dropdown-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M19 9l-7 7-7-7"/>
        </svg>
      </div>

      <div className={`user-dropdown ${isDropdownOpen ? 'open' : ''}`}>
        {/* Profile Details Header */}
        <div className="dropdown-header">
          <div className="dropdown-profile">
            <div className="dropdown-avatar">{initials}</div>
            <div className="dropdown-user-info">
              <div className="dropdown-name">
                {userProfile.firstName} {userProfile.lastName}
              </div>
              <div className="dropdown-username">@{userProfile.username}</div>
              <div className="dropdown-level">
                <span className="level-badge-dropdown">
                  {levelIcon} {userProfile.level}
                </span>
              </div>
            </div>
          </div>

          {/* User Stats */}
          <div className="dropdown-stats">
            <div className="dropdown-stat">
              <div className="dropdown-stat-number">{userProfile.points.toLocaleString()}</div>
              <div className="dropdown-stat-label">Points</div>
            </div>
            <div className="dropdown-stat">
              <div className="dropdown-stat-number">{userProfile.totalReports}</div>
              <div className="dropdown-stat-label">Reports</div>
            </div>
            <div className="dropdown-stat">
              <div className="dropdown-stat-number">{userProfile.totalRatings}</div>
              <div className="dropdown-stat-label">Ratings</div>
            </div>
            <div className="dropdown-stat">
              <div className="dropdown-stat-number">{userProfile.totalFollows}</div>
              <div className="dropdown-stat-label">Following</div>
            </div>
          </div>
        </div>

        {/* Menu Items */}
        <div className="dropdown-menu">
          <button className="dropdown-item" onClick={() => handleMenuAction('profile')}>
            <svg className="dropdown-item-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
            </svg>
            View Full Profile
          </button>
          
          <button className="dropdown-item" onClick={() => handleMenuAction('edit')}>
            <svg className="dropdown-item-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
            </svg>
            Update Profile
          </button>

          <button className="dropdown-item" onClick={() => handleMenuAction('lists')}>
            <svg className="dropdown-item-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"/>
            </svg>
            My Venue Lists
          </button>

          <button className="dropdown-item" onClick={() => handleMenuAction('activity')}>
            <svg className="dropdown-item-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/>
            </svg>
            Activity History
          </button>

          <div className="dropdown-divider"></div>

          <button className="dropdown-item" onClick={() => handleMenuAction('settings')}>
            <svg className="dropdown-item-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"/>
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
            </svg>
            Settings
          </button>

          <button className="dropdown-item" onClick={() => handleMenuAction('help')}>
            <svg className="dropdown-item-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M8.228 9c.549-1.165 2.03-2 3.772-2 2.21 0 4 1.343 4 3 0 1.4-1.278 2.575-3.006 2.907-.542.104-.994.54-.994 1.093m0 3h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
            </svg>
            Help & Support
          </button>

          <div className="dropdown-divider"></div>

          <button className="dropdown-item danger" onClick={() => handleMenuAction('signout')}>
            <svg className="dropdown-item-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"/>
            </svg>
            Sign Out
          </button>
        </div>
      </div>

      {/* Overlay */}
      {isDropdownOpen && <div className="dropdown-overlay" onClick={() => setIsDropdownOpen(false)} />}
    </div>
  );
};

export default UserProfile;
EOF

# 9. User Profile CSS
echo "📝 Creating user profile styles..."

cat > src/components/User/UserProfile.css << 'EOF'
/* User Badge with Dropdown */
.user-badge-container {
  position: relative;
}

.user-badge {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 8px 16px;
  background: linear-gradient(135deg, #ffd700, #ffb347);
  border-radius: 20px;
  color: white;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1), 0 1px 3px rgba(0, 0, 0, 0.08);
  transition: all 0.2s ease;
  cursor: pointer;
  position: relative;
}

.user-badge:hover {
  transform: translateY(-1px);
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15), 0 4px 10px rgba(0, 0, 0, 0.1);
}

.user-badge.open {
  border-bottom-left-radius: 8px;
  border-bottom-right-radius: 8px;
}

.user-avatar-badge {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.2);
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: bold;
  font-size: 0.875rem;
}

.user-info-badge {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
}

.user-name-badge {
  font-weight: 700;
  font-size: 0.875rem;
  line-height: 1;
}

.user-level-badge {
  font-size: 0.75rem;
  opacity: 0.9;
  display: flex;
  align-items: center;
  gap: 4px;
}

.points-badge {
  background: rgba(255, 255, 255, 0.2);
  padding: 2px 6px;
  border-radius: 8px;
  font-size: 0.6rem;
  font-weight: 600;
  margin-left: 4px;
}

.dropdown-icon {
  width: 16px;
  height: 16px;
  transition: all 0.2s ease;
}

.user-badge.open .dropdown-icon {
  transform: rotate(180deg);
}

/* User Dropdown */
.user-dropdown {
  position: absolute;
  top: 100%;
  right: 0;
  margin-top: -4px;
  background: #ffffff;
  border-radius: 0 0 16px 16px;
  box-shadow: 0 25px 50px rgba(0, 0, 0, 0.25);
  padding: 0;
  min-width: 320px;
  color: #1e293b;
  opacity: 0;
  visibility: hidden;
  transform: translateY(-10px);
  transition: all 0.2s ease;
  overflow: hidden;
  border: 1px solid #e2e8f0;
  border-top: none;
  z-index: 1000;
}

.user-dropdown.open {
  opacity: 1;
  visibility: visible;
  transform: translateY(0);
}

/* Dropdown Header - Profile Details */
.dropdown-header {
  background: linear-gradient(135deg, #f8fafc, #e2e8f0);
  padding: 20px;
  border-bottom: 1px solid #e2e8f0;
}

.dropdown-profile {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-bottom: 16px;
}

.dropdown-avatar {
  width: 56px;
  height: 56px;
  border-radius: 50%;
  background: linear-gradient(135deg, #ffd700, #ffb347);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.5rem;
  font-weight: bold;
  color: white;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1), 0 1px 3px rgba(0, 0, 0, 0.08);
}

.dropdown-user-info {
  flex: 1;
}

.dropdown-name {
  font-weight: 700;
  color: #1e293b;
  margin-bottom: 4px;
  font-size: 1rem;
}

.dropdown-username {
  color: #64748b;
  font-size: 0.75rem;
  margin-bottom: 6px;
}

.dropdown-level {
  display: flex;
  align-items: center;
  gap: 6px;
}

.level-badge-dropdown {
  background: linear-gradient(135deg, #ffd700, #ffb347);
  color: white;
  padding: 4px 8px;
  border-radius: 12px;
  font-size: 0.7rem;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 4px;
}

/* User Stats in Dropdown */
.dropdown-stats {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 8px;
}

.dropdown-stat {
  text-align: center;
  padding: 8px 4px;
  background: #ffffff;
  border-radius: 12px;
  border: 1px solid #f1f5f9;
}

.dropdown-stat-number {
  font-size: 1rem;
  font-weight: 700;
  color: #3b82f6;
  margin-bottom: 2px;
}

.dropdown-stat-label {
  font-size: 0.65rem;
  color: #64748b;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

/* Dropdown Menu Items */
.dropdown-menu {
  padding: 12px 0;
}

.dropdown-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 20px;
  color: #64748b;
  text-decoration: none;
  transition: all 0.2s ease;
  cursor: pointer;
  border: none;
  background: none;
  width: 100%;
  text-align: left;
  font-size: 0.875rem;
}

.dropdown-item:hover {
  background: #f8fafc;
  color: #1e293b;
}

.dropdown-item.danger {
  color: #dc2626;
}

.dropdown-item.danger:hover {
  background: #fef2f2;
  color: #b91c1c;
}

.dropdown-item-icon {
  width: 18px;
  height: 18px;
  flex-shrink: 0;
}

.dropdown-divider {
  height: 1px;
  background: #f1f5f9;
  margin: 8px 0;
}

/* Overlay for dropdown */
.dropdown-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 500;
  opacity: 0;
  visibility: hidden;
  transition: all 0.2s ease;
}

.dropdown-overlay.open {
  opacity: 1;
  visibility: visible;
}

/* Mobile Responsive */
@media (max-width: 768px) {
  .user-dropdown {
    right: 0;
    left: auto;
    min-width: 280px;
  }

  .dropdown-stats {
    grid-template-columns: repeat(2, 1fr);
    gap: 12px;
  }
}

@media (max-width: 480px) {
  .user-dropdown {
    position: fixed;
    top: 70px;
    right: 16px;
    left: 16px;
    min-width: auto;
  }

  .dropdown-stats {
    grid-template-columns: repeat(4, 1fr);
    gap: 8px;
  }

  .dropdown-stat {
    padding: 6px 2px;
  }

  .dropdown-stat-number {
    font-size: 0.875rem;
  }

  .dropdown-stat-label {
    font-size: 0.6rem;
  }
}
EOF

# 10. Search Section Component
echo "📝 Creating search section component..."

cat > src/components/Search/SearchSection.jsx << 'EOF'
import React from 'react';
import { Search, X } from 'lucide-react';

const SearchSection = ({ searchQuery, setSearchQuery, onClearSearch }) => {
  return (
    <div className="search-container">
      <Search className="search-icon" size={20} />
      <input
        type="text"
        placeholder="Search venues, types, or locations..."
        value={searchQuery}
        onChange={(e) => setSearchQuery(e.target.value)}
        className="search-input"
      />
      {searchQuery && (
        <button
          onClick={onClearSearch}
          className="clear-search-button"
        >
          <X size={16} />
        </button>
      )}
    </div>
  );
};

export default SearchSection;
EOF

# 11. Continue with remaining components...
echo "📝 Creating promotional banner component..."

cat > src/components/Layout/PromotionalBanner.jsx << 'EOF'
import React from 'react';
import { MessageCircle, Gift, Sparkles, Volume2, Calendar, UserPlus, Brain } from 'lucide-react';

const iconMap = {
  MessageCircle,
  Gift,
  Sparkles,
  Volume2,
  Calendar,
  UserPlus,
  Brain
};

const PromotionalBanner = ({ banner, onClick }) => {
  const IconComponent = iconMap[banner.icon];

  return (
    <div
      className="promotional-banner"
      style={{
        background: banner.bgColor,
        borderColor: banner.borderColor,
        color: banner.textColor || '#1f2937'
      }}
      onClick={onClick}
    >
      <div className="banner-content">
        {IconComponent && (
          <IconComponent
            className="banner-icon"
            style={{ color: banner.iconColor }}
          />
        )}
        <div className="banner-text">
          <div
            className="banner-title"
            style={{ color: banner.textColor || '#1f2937' }}
          >
            {banner.title}
          </div>
          <div
            className="banner-subtitle"
            style={{ color: banner.textColor ? `${banner.textColor}CC` : '#6b7280' }}
          >
            {banner.subtitle}
          </div>
        </div>
      </div>
    </div>
  );
};

export default PromotionalBanner;
EOF

# 12. Create remaining essential components
echo "📝 Creating remaining components..."

# Venue Card Component
cat > src/components/Venue/VenueCard.jsx << 'EOF'
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
EOF

# 13. Create Home View
cat > src/components/Views/HomeView.jsx << 'EOF'
import React, { useState, useEffect } from 'react';
import { useApp } from '../../context/AppContext';
import { useVenues } from '../../hooks/useVenues';
import VenueCard from '../Venue/VenueCard';
import PromotionalBanner from '../Layout/PromotionalBanner';
import { PROMOTIONAL_BANNERS, UPDATE_INTERVALS } from '../../constants';

const HomeView = ({ searchQuery, venueFilter, setVenueFilter, onVenueShare }) => {
  const { state } = useApp();
  const { getFilteredVenues } = useVenues();
  const [currentBannerIndex, setCurrentBannerIndex] = useState(0);

  // Auto-rotate promotional banners
  useEffect(() => {
    const interval = setInterval(() => {
      setCurrentBannerIndex((prev) => (prev + 1) % PROMOTIONAL_BANNERS.length);
    }, UPDATE_INTERVALS.BANNER_ROTATION);

    return () => clearInterval(interval);
  }, []);

  // Filter venues based on search and filter
  const filteredVenues = getFilteredVenues(searchQuery, venueFilter);

  const filterOptions = [
    { id: 'all', label: 'All Venues' },
    { id: 'followed', label: 'Following' },
    { id: 'nearby', label: 'Nearby' },
    { id: 'open', label: 'Open Now' },
    { id: 'promotions', label: 'Promotions' }
  ];

  return (
    <div className="home-view">
      {/* Promotional Banner */}
      <div className="promotional-section">
        <PromotionalBanner
          banner={PROMOTIONAL_BANNERS[currentBannerIndex]}
          onClick={() => console.log('Banner clicked')}
        />
      </div>

      {/* Filter Bar */}
      <div className="filter-bar">
        <div className="filter-scroll">
          {filterOptions.map((filter) => (
            <button
              key={filter.id}
              onClick={() => setVenueFilter(filter.id)}
              className={`filter-button ${venueFilter === filter.id ? 'active' : ''}`}
            >
              {filter.label}
            </button>
          ))}
        </div>
      </div>

      {/* Venues Grid */}
      <div className="venues-section">
        {filteredVenues.length > 0 ? (
          <div className="venues-grid">
            {filteredVenues.map((venue) => (
              <VenueCard
                key={venue.id}
                venue={venue}
                searchQuery={searchQuery}
                onShare={onVenueShare}
              />
            ))}
          </div>
        ) : (
          <div className="no-results">
            <h3>No venues found</h3>
            <p>
              {searchQuery
                ? `No venues match "${searchQuery}". Try a different search term.`
                : 'No venues match your current filter. Try selecting a different filter.'
              }
            </p>
          </div>
        )}
      </div>
    </div>
  );
};

export default HomeView;
EOF

# 14. Create Enhanced Main App
cat > src/App.jsx << 'EOF'
import React, { useState, useEffect } from 'react';
import { AppProvider, useApp } from './context/AppContext';
import WelcomeLandingPage from './views/Landing/WelcomeLandingPage';
import Header from './components/Layout/Header';
import HomeView from './components/Views/HomeView';
import { useVenues } from './hooks/useVenues';
import { useNotifications } from './hooks/useNotifications';
import { UPDATE_INTERVALS } from './constants';
import './App.css';

function AppContent() {
  const { state, actions } = useApp();
  const [searchQuery, setSearchQuery] = useState('');
  const [venueFilter, setVenueFilter] = useState('all');
  const { updateVenueData } = useVenues();
  const { notifications, removeNotification } = useNotifications();

  // Real-time updates for user mode
  useEffect(() => {
    let interval;
    if (state.currentMode === 'user' && state.currentView === 'home' && !document.hidden) {
      interval = setInterval(() => {
        updateVenueData();
      }, UPDATE_INTERVALS.VENUE_DATA);
    }

    return () => {
      if (interval) clearInterval(interval);
    };
  }, [state.currentMode, state.currentView, updateVenueData]);

  // Pause updates when tab is hidden
  useEffect(() => {
    const handleVisibilityChange = () => {
      if (!document.hidden && state.currentMode === 'user' && state.currentView === 'home') {
        updateVenueData();
      }
    };

    document.addEventListener('visibilitychange', handleVisibilityChange);
    return () => {
      document.removeEventListener('visibilitychange', handleVisibilityChange);
    };
  }, [state.currentMode, state.currentView, updateVenueData]);

  const handleVenueShare = (venue) => {
    actions.setShareVenue(venue);
    actions.setShowShareModal(true);
  };

  const handleClearSearch = () => {
    setSearchQuery('');
    setVenueFilter('all');
  };

  // Show landing page first
  if (state.currentView === 'landing' || !state.currentMode) {
    return <WelcomeLandingPage />;
  }

  // Render based on selected mode
  return (
    <div className="app-layout">
      {/* Header for customer mode */}
      {state.currentMode === 'user' && state.currentView === 'home' && (
        <Header
          searchQuery={searchQuery}
          setSearchQuery={setSearchQuery}
          onClearSearch={handleClearSearch}
        />
      )}

      {/* Main content */}
      <div className="content-frame">
        {state.currentMode === 'user' && state.currentView === 'home' && (
          <HomeView
            searchQuery={searchQuery}
            venueFilter={venueFilter}
            setVenueFilter={setVenueFilter}
            onVenueShare={handleVenueShare}
          />
        )}

        {state.currentMode === 'venue_owner' && (
          <div className="venue-owner-dashboard">
            <div style={{ padding: '40px', textAlign: 'center', color: 'white' }}>
              <h2>🏪 Business Dashboard</h2>
              <p>Venue owner interface coming soon...</p>
              <button 
                onClick={() => actions.setCurrentMode('user')}
                style={{ 
                  padding: '12px 24px', 
                  margin: '20px 10px',
                  background: '#3b82f6', 
                  color: 'white', 
                  border: 'none', 
                  borderRadius: '8px',
                  cursor: 'pointer'
                }}
              >
                Switch to Customer View
              </button>
              <button 
                onClick={() => {
                  actions.setCurrentView('landing');
                  actions.setCurrentMode(null);
                }}
                style={{ 
                  padding: '12px 24px', 
                  margin: '20px 10px',
                  background: '#6b7280', 
                  color: 'white', 
                  border: 'none', 
                  borderRadius: '8px',
                  cursor: 'pointer'
                }}
              >
                Back to Landing
              </button>
            </div>
          </div>
        )}
      </div>

      {/* Notifications */}
      {notifications.length > 0 && (
        <div className="notification-container">
          {notifications.map((notification) => (
            <div
              key={notification.id}
              className={`notification notification-${notification.type}`}
            >
              <div className="notification-content">
                <span className="notification-message">{notification.message}</span>
                <button
                  onClick={() => removeNotification(notification.id)}
                  className="notification-close"
                >
                  ×
                </button>
              </div>
            </div>
          ))}
        </div>
      )}

      {/* Return to landing button for customer mode */}
      {state.currentMode === 'user' && (
        <button 
          onClick={() => {
            actions.setCurrentView('landing');
            actions.setCurrentMode(null);
          }}
          className="back-to-landing-button"
        >
          ← Back to Landing
        </button>
      )}
    </div>
  );
}

function App() {
  return (
    <AppProvider>
      <AppContent />
    </AppProvider>
  );
}

export default App;
EOF

# 15. Create Enhanced CSS with all v2.0 styles
echo "📝 Creating enhanced App.css with complete styling system..."

cat > src/App.css << 'EOF'
/* nYtevibe v2.0 - Complete CSS Implementation */

:root {
  /* Colors */
  --color-primary: #3b82f6;
  --color-secondary: #6b7280;
  --color-success: #10b981;
  --color-warning: #f59e0b;
  --color-danger: #ef4444;
  --color-follow: #ef4444;

  /* Gradients */
  --gradient-primary: linear-gradient(135deg, #3b82f6, #2563eb);
  --gradient-secondary: linear-gradient(135deg, #6b7280, #4b5563);
  --gradient-success: linear-gradient(135deg, #10b981, #059669);
  --gradient-warning: linear-gradient(135deg, #f59e0b, #d97706);
  --gradient-danger: linear-gradient(135deg, #ef4444, #dc2626);
  --gradient-follow: linear-gradient(135deg, #ef4444, #dc2626);
  --gradient-gold: linear-gradient(135deg, #ffd700, #ffb347);

  /* Backgrounds */
  --background-primary: #1e293b;
  --card-background: #ffffff;

  /* Text Colors */
  --text-primary: #1e293b;
  --text-secondary: #64748b;
  --text-muted: #9ca3af;

  /* Radius */
  --radius-sm: 4px;
  --radius-md: 8px;
  --radius-lg: 12px;
  --radius-xl: 16px;
  --radius-full: 9999px;

  /* Shadows */
  --shadow-sm: 0 1px 2px rgba(0, 0, 0, 0.05);
  --shadow-md: 0 4px 6px rgba(0, 0, 0, 0.1), 0 1px 3px rgba(0, 0, 0, 0.08);
  --shadow-lg: 0 8px 25px rgba(0, 0, 0, 0.15), 0 4px 10px rgba(0, 0, 0, 0.1);
  --shadow-xl: 0 25px 50px rgba(0, 0, 0, 0.25);

  /* Transitions */
  --transition-fast: all 0.15s ease;
  --transition-normal: all 0.2s ease;
  --transition-slow: all 0.3s ease;
}

/* Reset and Base Styles */
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', sans-serif;
  line-height: 1.6;
  background: var(--background-primary);
  color: var(--text-primary);
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

/* App Layout */
.app-layout {
  min-height: 100vh;
  background: var(--background-primary);
  position: relative;
}

.content-frame {
  background: var(--background-primary);
  min-height: calc(100vh - 200px);
}

/* Header Styles */
.header-frame {
  background: var(--background-primary);
  position: sticky;
  top: 0;
  z-index: 100;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.header-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

.header-top-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.logo-section {
  display: flex;
  flex-direction: column;
}

.app-title {
  font-size: 1.875rem;
  font-weight: 800;
  background: linear-gradient(135deg, #3b82f6, #ec4899);
  -webkit-background-clip: text;
  background-clip: text;
  -webkit-text-fill-color: transparent;
  margin: 0;
}

.app-subtitle {
  color: rgba(255, 255, 255, 0.7);
  font-size: 0.875rem;
  margin: 0;
}

/* Search Styles */
.search-container {
  position: relative;
  width: 100%;
}

.search-input {
  width: 100%;
  padding: 12px 16px 12px 48px;
  border: 2px solid #e2e8f0;
  border-radius: var(--radius-lg);
  background: #ffffff;
  color: #1e293b;
  font-size: 1rem;
  transition: var(--transition-normal);
}

.search-input:focus {
  outline: none;
  border-color: #3b82f6;
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}

.search-icon {
  position: absolute;
  left: 16px;
  top: 50%;
  transform: translateY(-50%);
  color: #9ca3af;
}

.clear-search-button {
  position: absolute;
  right: 12px;
  top: 50%;
  transform: translateY(-50%);
  background: none;
  border: none;
  color: #9ca3af;
  cursor: pointer;
  padding: 4px;
  border-radius: 4px;
  transition: var(--transition-normal);
}

.clear-search-button:hover {
  background: #f3f4f6;
  color: #374151;
}

/* Home View */
.home-view {
  padding: 20px;
  max-width: 1200px;
  margin: 0 auto;
}

/* Promotional Banner */
.promotional-section {
  margin-bottom: 24px;
}

.promotional-banner {
  border-radius: var(--radius-xl);
  padding: 20px 24px;
  margin-bottom: 20px;
  box-shadow: var(--shadow-md);
  cursor: pointer;
  transition: var(--transition-normal);
  position: relative;
  overflow: hidden;
}

.promotional-banner::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: inherit;
  opacity: 0.95;
  z-index: 1;
}

.promotional-banner * {
  position: relative;
  z-index: 2;
}

.promotional-banner:hover {
  transform: translateY(-2px);
  box-shadow: var(--shadow-lg);
}

.banner-content {
  display: flex;
  align-items: center;
  gap: 16px;
}

.banner-icon {
  flex-shrink: 0;
  width: 28px;
  height: 28px;
  filter: drop-shadow(0 1px 2px rgba(0, 0, 0, 0.3));
}

.banner-text {
  flex: 1;
}

.banner-title {
  font-weight: 700;
  font-size: 1rem;
  margin-bottom: 4px;
  line-height: 1.3;
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.2);
}

.banner-subtitle {
  font-size: 0.875rem;
  line-height: 1.4;
  opacity: 0.95;
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
}

/* Filter Bar */
.filter-bar {
  margin-bottom: 20px;
  display: flex;
  gap: 12px;
  justify-content: center;
  flex-wrap: wrap;
}

.filter-button {
  padding: 8px 16px;
  border: 2px solid #e5e7eb;
  border-radius: 12px;
  background: white;
  color: #6b7280;
  font-size: 0.875rem;
  font-weight: 500;
  cursor: pointer;
  transition: var(--transition-normal);
  white-space: nowrap;
}

.filter-button:hover {
  border-color: #d1d5db;
  background: #f9fafb;
  color: #374151;
}

.filter-button.active {
  border-color: var(--color-primary);
  background: #eff6ff;
  color: var(--color-primary);
}

/* Venues Grid */
.venues-section {
  margin-bottom: 40px;
}

.venues-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
  gap: 20px;
}

/* Venue Cards */
.venue-card-container {
  background: #ffffff;
  border-radius: var(--radius-xl);
  padding: 20px;
  box-shadow: var(--shadow-md);
  transition: var(--transition-normal);
  position: relative;
  border: 2px solid transparent;
}

.venue-card-container.venue-followed {
  border-color: #ef4444;
  background: #ffffff;
  box-shadow: 0 4px 6px rgba(239, 68, 68, 0.15), 0 1px 3px rgba(239, 68, 68, 0.1);
  border-width: 3px;
}

.venue-card-container.venue-followed::before {
  content: '';
  position: absolute;
  left: 0;
  top: 0;
  bottom: 0;
  width: 4px;
  background: linear-gradient(180deg, #ef4444, #dc2626);
  border-radius: 16px 0 0 16px;
}

.venue-card-container:hover {
  transform: translateY(-2px);
  box-shadow: var(--shadow-lg);
}

/* Promotion Badge */
.venue-promotion-sleek {
  position: absolute;
  top: 12px;
  right: 12px;
  width: 32px;
  height: 32px;
  background: linear-gradient(135deg, #ff6b6b, #ff5252);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  z-index: 10;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 2px 8px rgba(255, 107, 107, 0.4);
  animation: promo-pulse 3s infinite;
}

.venue-promotion-sleek:hover {
  transform: scale(1.1);
  box-shadow: 0 4px 12px rgba(255, 107, 107, 0.6);
  animation: none;
}

.promo-emoji {
  font-size: 12px;
  line-height: 1;
}

@keyframes promo-pulse {
  0% { box-shadow: 0 2px 8px rgba(255, 107, 107, 0.4); }
  50% { box-shadow: 0 2px 8px rgba(255, 107, 107, 0.4), 0 0 0 8px rgba(255, 107, 107, 0.1); }
  100% { box-shadow: 0 2px 8px rgba(255, 107, 107, 0.4); }
}

/* Promotion Tooltip */
.promotion-tooltip {
  position: absolute;
  top: -50px;
  right: 0;
  z-index: 100;
  pointer-events: none;
}

.tooltip-content {
  background: rgba(30, 30, 30, 0.95);
  color: white;
  padding: 8px 12px;
  border-radius: 8px;
  font-size: 0.75rem;
  font-weight: 500;
  white-space: nowrap;
  max-width: 200px;
  text-align: center;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
  backdrop-filter: blur(10px);
}

.tooltip-arrow {
  position: absolute;
  top: 100%;
  right: 16px;
  width: 0;
  height: 0;
  border-left: 5px solid transparent;
  border-right: 5px solid transparent;
  border-top: 5px solid rgba(30, 30, 30, 0.95);
}

/* Venue Card Layout */
.venue-card-header-fixed {
  display: grid;
  grid-template-columns: 1fr auto;
  gap: 16px;
  margin-bottom: 16px;
}

.venue-info-section {
  display: flex;
  flex-direction: column;
  gap: 8px;
  min-width: 0;
}

.venue-title-row {
  display: flex;
  align-items: center;
  gap: 8px;
  flex-wrap: wrap;
}

.venue-name {
  font-size: 1.125rem;
  font-weight: 700;
  color: #1f2937;
  margin: 0;
  flex: 1;
  min-width: 0;
}

.trending-icon {
  font-size: 0.875rem;
  flex-shrink: 0;
}

.followed-indicator {
  flex-shrink: 0;
  background: rgba(239, 68, 68, 0.1);
  border-radius: 50%;
  padding: 4px;
  animation: pulse-follow 2s infinite;
}

@keyframes pulse-follow {
  0% { box-shadow: 0 0 0 0 rgba(239, 68, 68, 0.4); }
  70% { box-shadow: 0 0 0 6px rgba(239, 68, 68, 0); }
  100% { box-shadow: 0 0 0 0 rgba(239, 68, 68, 0); }
}

.venue-location-row {
  display: flex;
  align-items: center;
  gap: 8px;
  color: #6b7280;
  font-size: 0.875rem;
}

.location-icon {
  width: 16px;
  height: 16px;
  flex-shrink: 0;
  color: #9ca3af;
}

.location-text {
  font-weight: 500;
  color: #374151;
}

.venue-address {
  font-size: 0.75rem;
  color: #9ca3af;
}

/* Actions Section */
.venue-actions-section {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  gap: 12px;
  flex-shrink: 0;
}

.top-actions {
  display: flex;
  gap: 8px;
  align-items: center;
  margin-right: 44px;
}

.follow-button, .share-button {
  width: 40px;
  height: 40px;
  border-radius: var(--radius-full);
  border: 2px solid #e5e7eb;
  background: #f9fafb;
  color: #6b7280;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: var(--transition-normal);
}

.follow-button.following {
  background: var(--gradient-follow);
  border-color: var(--color-follow);
  color: white;
  box-shadow: 0 2px 8px rgba(239, 68, 68, 0.3);
}

.follow-button:hover, .share-button:hover {
  background: #f3f4f6;
  border-color: #d1d5db;
  color: #374151;
  transform: scale(1.05);
}

.follow-button.following:hover {
  background: linear-gradient(135deg, #dc2626, #b91c1c);
  transform: scale(1.05);
  box-shadow: 0 4px 12px rgba(239, 68, 68, 0.4);
}

.crowd-status {
  align-self: flex-end;
}

/* Status Section */
.venue-status-section {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
  flex-wrap: wrap;
  gap: 8px;
}

.status-items {
  display: flex;
  gap: 16px;
  flex-wrap: wrap;
}

.status-item {
  display: flex;
  align-items: center;
  gap: 4px;
  color: #6b7280;
  font-size: 0.875rem;
}

.status-icon {
  width: 16px;
  height: 16px;
  color: #9ca3af;
}

.status-text {
  font-weight: 500;
  color: #374151;
}

.last-update {
  font-size: 0.75rem;
  color: #9ca3af;
  font-weight: 500;
}

/* Vibe Section */
.venue-vibe-section {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin-bottom: 16px;
}

/* Badge Styles */
.badge {
  display: inline-flex;
  align-items: center;
  padding: 4px 8px;
  border-radius: var(--radius-full);
  font-size: 0.75rem;
  font-weight: 500;
  line-height: 1;
  white-space: nowrap;
}

.badge.badge-green {
  background: linear-gradient(135deg, #10b981, #059669);
  color: white;
}

.badge.badge-yellow {
  background: linear-gradient(135deg, #f59e0b, #d97706);
  color: white;
}

.badge.badge-red {
  background: linear-gradient(135deg, #ef4444, #dc2626);
  color: white;
}

.badge.badge-blue {
  background: linear-gradient(135deg, #3b82f6, #2563eb);
  color: white;
}

/* Follow Stats */
.venue-follow-stats {
  background: #f8fafc;
  border: 1px solid #e2e8f0;
  border-radius: var(--radius-lg);
  padding: 12px;
  margin-bottom: 16px;
  display: flex;
  gap: 16px;
  align-items: center;
  justify-content: center;
}

.follow-stat {
  display: flex;
  align-items: center;
  gap: 4px;
  color: #64748b;
  font-size: 0.875rem;
}

.stat-icon {
  width: 16px;
  height: 16px;
  color: #64748b;
}

.stat-number {
  color: #1e293b;
  font-weight: 600;
}

.stat-label {
  color: #64748b;
  font-size: 0.75rem;
}

.stat-text {
  color: #475569;
  font-weight: 500;
}

.you-follow .stat-icon {
  color: #ef4444;
}

.you-follow .stat-text {
  color: #ef4444;
  font-weight: 600;
}

/* Action Buttons */
.venue-action-buttons-single {
  display: flex;
  margin-top: 16px;
}

.details-btn-full {
  width: 100%;
  padding: 12px 20px;
  border-radius: var(--radius-lg);
  border: none;
  font-weight: 600;
  font-size: 0.875rem;
  cursor: pointer;
  transition: var(--transition-normal);
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  background: var(--gradient-primary);
  color: white;
}

.details-btn-full:hover {
  background: linear-gradient(135deg, #2563eb, #1d4ed8);
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(59, 130, 246, 0.4);
}

.details-icon {
  width: 16px;
  height: 16px;
}

/* Star Rating */
.star-rating {
  display: flex;
  align-items: center;
  gap: 2px;
}

.star-rating svg {
  fill: #fbbf24;
  color: #fbbf24;
}

.star-rating svg.empty {
  fill: #d1d5db;
  color: #d1d5db;
}

.rating-count {
  margin-left: 8px;
  font-size: 0.75rem;
  color: #6b7280;
  font-weight: 500;
}

/* Search Highlight */
.search-highlight {
  background-color: #fef3c7;
  color: #92400e;
  padding: 1px 2px;
  border-radius: 2px;
}

/* Notifications */
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
  box-shadow: var(--shadow-lg);
  border-left: 4px solid;
  animation: slideInRight 0.3s ease-out;
}

.notification-success, .notification-follow {
  border-left-color: #10b981;
}

.notification-error {
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
  transition: var(--transition-normal);
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

/* No Results */
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

/* Back to Landing Button */
.back-to-landing-button {
  position: fixed;
  bottom: 20px;
  left: 20px;
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
  color: white;
  padding: 8px 16px;
  border-radius: 8px;
  cursor: pointer;
  transition: var(--transition-normal);
  backdrop-filter: blur(10px);
  z-index: 100;
}

.back-to-landing-button:hover {
  background: rgba(255, 255, 255, 0.2);
  transform: translateY(-1px);
}

/* Venue Owner Dashboard */
.venue-owner-dashboard {
  min-height: 100vh;
  background: var(--background-primary);
  display: flex;
  align-items: center;
  justify-content: center;
}

/* Mobile Responsive */
@media (max-width: 768px) {
  .header-top-row {
    flex-direction: column;
    gap: 16px;
    align-items: flex-start;
  }

  .venues-grid {
    grid-template-columns: 1fr;
    gap: 16px;
  }

  .venue-card-container {
    padding: 16px;
  }

  .venue-card-header-fixed {
    grid-template-columns: 1fr;
    gap: 12px;
  }

  .venue-actions-section {
    flex-direction: row;
    justify-content: space-between;
    align-items: center;
  }

  .top-actions {
    margin-right: 38px;
  }

  .home-view {
    padding: 16px;
  }
}

@media (max-width: 480px) {
  .venue-card-container {
    padding: 14px;
  }

  .details-btn-full {
    padding: 10px 16px;
    font-size: 0.8rem;
  }

  .venue-promotion-sleek {
    width: 24px;
    height: 24px;
  }

  .home-view {
    padding: 12px;
  }
}

/* Utility Classes */
.flex { display: flex; }
.items-center { align-items: center; }
.justify-center { justify-content: center; }
.justify-between { justify-content: space-between; }
.w-4 { width: 16px; }
.h-4 { height: 16px; }
.w-5 { width: 20px; }
.h-5 { height: 20px; }
.text-red-500 { color: #ef4444; }
.fill-current { fill: currentColor; }
EOF

# 16. Update package.json if needed
echo "📝 Updating package.json dependencies..."

# Check if lucide-react is already installed
if ! grep -q "lucide-react" package.json; then
    echo "Installing lucide-react..."
    npm install lucide-react
fi

# 17. Final completion message
echo ""
echo "🎉 nYtevibe v2.0 Build Complete!"
echo "=================================================================="
echo ""
echo "✅ Enhanced System Features:"
echo "   🏠 Professional landing page with dual profile selection"
echo "   👤 Enhanced user profile with dropdown menu (8 menu options)"
echo "   🎠 Auto-rotating promotional carousel (8 banners, 4-second rotation)"
echo "   🔍 Advanced search with real-time highlighting"
echo "   📱 Complete responsive design (mobile-first)"
echo "   ⚡ Real-time venue data updates (45-second intervals)"
echo "   💝 Follow system with heart animations"
echo "   🎮 Gamification system (points, levels, badges)"
echo "   📊 Comprehensive venue analytics"
echo "   🔔 Toast notification system"
echo ""
echo "🎯 User Profile Dropdown Menu:"
echo "   👤 View Full Profile"
echo "   ✏️  Update Profile"
echo "   💕 My Venue Lists"
echo "   📊 Activity History"
echo "   ⚙️  Settings"
echo "   🆘 Help & Support"
echo "   🚪 Sign Out"
echo ""
echo "🚀 To start the development server:"
echo "   npm run dev"
echo ""
echo "📱 The app now includes:"
echo "   • Landing page → Profile selection → Customer/Business modes"
echo "   • Full user profile dropdown with all menu actions"
echo "   • Enhanced venue discovery with follow system"
echo "   • Real-time data simulation and updates"
echo "   • Complete responsive mobile design"
echo "   • All advanced v2.0 features activated"
echo ""
echo "🎨 Professional UI with:"
echo "   • Gold gradient user badges"
echo "   • Smooth animations and transitions"
echo "   • High-contrast promotional banners"
echo "   • Interactive venue cards with promotion badges"
echo "   • Mobile-optimized layouts"
echo ""
echo "✨ All menu items are fully functional with notification feedback!"
echo "   Click the gold user badge to explore the complete dropdown menu!"
echo ""
echo "🎯 Your nYtevibe v2.0 is ready for Houston nightlife discovery! 🌟"
EOF

chmod +x build_nytevibe.sh

echo "🎯 nYtevibe v2.0 Complete System Builder Script Created!"
echo ""
echo "📋 This script builds your entire nYtevibe system with:"
echo "✅ Landing page with dual profile selection"
echo "✅ Enhanced user profile with comprehensive dropdown menu"
echo "✅ Auto-rotating promotional carousel"
echo "✅ Complete venue discovery system with follow functionality"
echo "✅ Real-time data simulation and updates"
echo "✅ Responsive design and modern UI"
echo "✅ All menu items activated with notification feedback"
echo ""
echo "🚀 To use this script:"
echo "1. Save it as 'build_nytevibe.sh' in your project directory"
echo "2. Make it executable: chmod +x build_nytevibe.sh"
echo "3. Run it: ./build_nytevibe.sh"
echo ""
echo "📱 The script will build your complete v2.0 system with all the advanced features!"
