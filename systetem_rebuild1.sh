#!/bin/bash

# nYtevibe Complete System Rebuild Script
# Removes session complexity while preserving all enhanced features
# Based on stable v2.0 foundation with v2.1+ enhancements

echo "🚀 nYtevibe Complete System Rebuild"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 Rebuilding stable system without session complexity..."
echo ""

# Ensure we're in the project directory
if [ ! -f "package.json" ]; then
    echo "❌ Error: package.json not found. Please run this script from the nytevibe project directory."
    exit 1
fi

# Backup existing files
echo "💾 Creating backup of existing system..."
mkdir -p backup_$(date +%Y%m%d_%H%M%S)
cp -r src backup_$(date +%Y%m%d_%H%M%S)/

# Clean up any problematic session files
echo "🧹 Cleaning up session-related files..."
rm -f src/utils/sessionManager.js
rm -rf src/views/Auth/
rm -f src/components/Utils/

echo "📁 Creating clean file structure..."

# Create directory structure
mkdir -p src/components/Layout
mkdir -p src/components/User
mkdir -p src/components/Search
mkdir -p src/components/Venue
mkdir -p src/components/Follow
mkdir -p src/components/Social
mkdir -p src/components/UI
mkdir -p src/components/Views
mkdir -p src/views/Landing
mkdir -p src/context
mkdir -p src/hooks
mkdir -p src/utils
mkdir -p src/constants

echo "🔧 Creating core system files..."

# 1. package.json - Clean dependencies
cat > package.json << 'EOF'
{
  "name": "nytevibe",
  "private": true,
  "version": "2.0.1",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "lucide-react": "^0.263.1"
  },
  "devDependencies": {
    "@types/react": "^18.2.15",
    "@types/react-dom": "^18.2.7",
    "@vitejs/plugin-react": "^4.0.3",
    "vite": "^4.4.5"
  }
}
EOF

# 2. Constants
cat > src/constants/index.js << 'EOF'
export const EMOJI_OPTIONS = ['📍', '💕', '🏈', '🎉', '🍻', '☕', '🌙', '🎵', '🍽️', '🎭', '🏃', '💼', '💨', '🔥'];

export const VIBE_OPTIONS = [
  "Chill", "Lively", "Loud", "Dancing", "Sports", "Date Night",
  "Business", "Family", "Hip-Hop", "R&B", "Live Music", "Karaoke",
  "Hookah", "Rooftop", "VIP", "Happy Hour"
];

export const PROMOTIONAL_BANNERS = [
  {
    id: 'community',
    type: 'community',
    icon: 'MessageCircle',
    title: "Help your community!",
    subtitle: "Rate venues and report status to earn points",
    bgColor: "rgba(59, 130, 246, 0.9)",
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
    bgColor: "rgba(236, 72, 153, 0.9)",
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
    bgColor: "rgba(239, 68, 68, 0.9)",
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
    bgColor: "rgba(168, 85, 247, 0.9)",
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
    bgColor: "rgba(34, 197, 94, 0.9)",
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
    bgColor: "rgba(251, 146, 60, 0.9)",
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
    bgColor: "rgba(168, 85, 247, 0.9)",
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
    bgColor: "rgba(34, 197, 94, 0.9)",
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

# 3. Helper utilities
cat > src/utils/helpers.js << 'EOF'
// Utility functions for nYtevibe

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
EOF

echo "🎯 Creating core context without session complexity..."

# 4. Clean AppContext (no session management)
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
  showShareModal: false,
  shareVenue: null,
  
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

    case 'SET_SHOW_SHARE_MODAL':
      return { ...state, showShareModal: action.payload };

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

echo "🎛️ Creating custom hooks..."

# 5. useVenues hook
cat > src/hooks/useVenues.js << 'EOF'
import { useApp } from '../context/AppContext';

export const useVenues = () => {
  const { state, actions } = useApp();

  const isVenueFollowed = (venueId) => {
    return state.userProfile.followedVenues.includes(venueId);
  };

  const toggleFollow = (venue) => {
    const isCurrentlyFollowed = isVenueFollowed(venue.id);
    
    if (isCurrentlyFollowed) {
      actions.unfollowVenue(venue.id, venue.name);
      actions.addNotification({
        type: 'default',
        message: `💔 Unfollowed ${venue.name} (-2 points)`
      });
    } else {
      actions.followVenue(venue.id, venue.name);
      actions.addNotification({
        type: 'success',
        message: `❤️ Following ${venue.name} (+3 points)`
      });
    }
  };

  const updateVenueData = () => {
    actions.updateVenueData();
  };

  const getFilteredVenues = (searchQuery, filter) => {
    let filteredVenues = state.venues;

    // Apply text search
    if (searchQuery.trim()) {
      const query = searchQuery.toLowerCase();
      filteredVenues = filteredVenues.filter(venue =>
        venue.name.toLowerCase().includes(query) ||
        venue.type.toLowerCase().includes(query) ||
        venue.city.toLowerCase().includes(query) ||
        venue.vibe.some(v => v.toLowerCase().includes(query))
      );
    }

    // Apply filters
    switch (filter) {
      case 'following':
        filteredVenues = filteredVenues.filter(venue => 
          state.userProfile.followedVenues.includes(venue.id)
        );
        break;
      case 'nearby':
        filteredVenues = filteredVenues.filter(venue => 
          parseFloat(venue.distance) <= 0.5
        );
        break;
      case 'open':
        filteredVenues = filteredVenues.filter(venue => venue.isOpen);
        break;
      case 'promotions':
        filteredVenues = filteredVenues.filter(venue => venue.hasPromotion);
        break;
      default:
        break;
    }

    return filteredVenues;
  };

  return {
    venues: state.venues,
    isVenueFollowed,
    toggleFollow,
    updateVenueData,
    getFilteredVenues
  };
};
EOF

# 6. useNotifications hook
cat > src/hooks/useNotifications.js << 'EOF'
import { useEffect } from 'react';
import { useApp } from '../context/AppContext';

export const useNotifications = () => {
  const { state, actions } = useApp();

  useEffect(() => {
    state.notifications.forEach(notification => {
      if (notification.duration && notification.duration > 0) {
        const timer = setTimeout(() => {
          actions.removeNotification(notification.id);
        }, notification.duration);

        return () => clearTimeout(timer);
      }
    });
  }, [state.notifications, actions]);

  const addNotification = (notification) => {
    actions.addNotification(notification);
  };

  const removeNotification = (id) => {
    actions.removeNotification(id);
  };

  return {
    notifications: state.notifications,
    addNotification,
    removeNotification
  };
};
EOF

# 7. useAI hook (placeholder for future)
cat > src/hooks/useAI.js << 'EOF'
export const useAI = () => {
  const getRecommendations = (userPreferences) => {
    // Placeholder for AI recommendations
    return [];
  };

  const getPersonalizedVenues = (userHistory) => {
    // Placeholder for personalized venue suggestions
    return [];
  };

  return {
    getRecommendations,
    getPersonalizedVenues
  };
};
EOF

echo "🧩 Creating UI components..."

# 8. UI Components
cat > src/components/UI/Button.jsx << 'EOF'
import React from 'react';

const Button = ({ 
  children, 
  variant = 'primary', 
  size = 'md', 
  onClick, 
  disabled = false,
  className = '',
  ...props 
}) => {
  const baseClasses = 'btn';
  const variantClasses = {
    primary: 'btn-primary',
    secondary: 'btn-secondary',
    warning: 'btn-warning'
  };
  const sizeClasses = {
    sm: 'btn-sm',
    md: 'btn-md',
    lg: 'btn-lg'
  };

  const classes = [
    baseClasses,
    variantClasses[variant],
    sizeClasses[size],
    disabled ? 'btn-disabled' : '',
    className
  ].filter(Boolean).join(' ');

  return (
    <button
      className={classes}
      onClick={onClick}
      disabled={disabled}
      {...props}
    >
      {children}
    </button>
  );
};

export default Button;
EOF

cat > src/components/UI/Modal.jsx << 'EOF'
import React from 'react';
import { X } from 'lucide-react';

const Modal = ({ 
  isOpen, 
  onClose, 
  title, 
  children, 
  className = '',
  ...props 
}) => {
  if (!isOpen) return null;

  return (
    <div className="modal-overlay" onClick={onClose}>
      <div 
        className={`modal-content ${className}`} 
        onClick={(e) => e.stopPropagation()}
        {...props}
      >
        <div className="modal-header">
          <h3 className="modal-title">{title}</h3>
          <button onClick={onClose} className="modal-close">
            <X className="w-4 h-4" />
          </button>
        </div>
        <div className="modal-body">
          {children}
        </div>
      </div>
    </div>
  );
};

export default Modal;
EOF

cat > src/components/UI/Badge.jsx << 'EOF'
import React from 'react';

const Badge = ({ 
  children, 
  variant = 'primary', 
  size = 'md',
  className = '',
  ...props 
}) => {
  const baseClasses = 'badge';
  const variantClasses = {
    primary: 'badge-blue',
    success: 'badge-green',
    warning: 'badge-yellow',
    danger: 'badge-red'
  };

  const classes = [
    baseClasses,
    variantClasses[variant],
    className
  ].filter(Boolean).join(' ');

  return (
    <span className={classes} {...props}>
      {children}
    </span>
  );
};

export default Badge;
EOF

echo "📄 Creating remaining component files..."

# Continue with next part due to length...
echo "⏳ Creating more components (part 2/3)..."

# 9. StarRating component
cat > src/components/Venue/StarRating.jsx << 'EOF'
import React from 'react';
import { Star } from 'lucide-react';

const StarRating = ({ 
  rating, 
  size = 'md', 
  showCount = false, 
  totalRatings = 0,
  interactive = false,
  onRatingChange = null
}) => {
  const sizeClasses = {
    sm: 'w-3 h-3',
    md: 'w-4 h-4', 
    lg: 'w-5 h-5'
  };

  const starClass = sizeClasses[size];
  const fullStars = Math.floor(rating);
  const hasHalfStar = rating % 1 !== 0;

  const handleStarClick = (starRating) => {
    if (interactive && onRatingChange) {
      onRatingChange(starRating);
    }
  };

  return (
    <div className="star-rating">
      <div className="stars-container">
        {[1, 2, 3, 4, 5].map((star) => (
          <Star
            key={star}
            className={`${starClass} ${
              star <= fullStars ? 'text-yellow-400 fill-current' : 
              star === fullStars + 1 && hasHalfStar ? 'text-yellow-400 fill-current opacity-50' :
              'text-gray-300'
            } ${interactive ? 'cursor-pointer hover:text-yellow-400' : ''}`}
            onClick={() => handleStarClick(star)}
          />
        ))}
      </div>
      {showCount && totalRatings > 0 && (
        <span className="rating-count">({totalRatings})</span>
      )}
    </div>
  );
};

export default StarRating;
EOF

# 10. FollowButton component
cat > src/components/Follow/FollowButton.jsx << 'EOF'
import React from 'react';
import { Heart } from 'lucide-react';
import { useVenues } from '../../hooks/useVenues';

const FollowButton = ({ venue, size = 'md', showCount = false }) => {
  const { isVenueFollowed, toggleFollow } = useVenues();
  const isFollowed = isVenueFollowed(venue.id);

  const sizeClasses = {
    sm: 'w-8 h-8',
    md: 'w-10 h-10',
    lg: 'w-12 h-12'
  };

  const iconSizeClasses = {
    sm: 'w-3 h-3',
    md: 'w-4 h-4', 
    lg: 'w-5 h-5'
  };

  const handleClick = (e) => {
    e.stopPropagation();
    toggleFollow(venue);
  };

  return (
    <div className="follow-button-container">
      <button
        onClick={handleClick}
        className={`follow-button ${sizeClasses[size]} ${isFollowed ? 'followed' : ''}`}
        title={isFollowed ? 'Unfollow' : 'Follow'}
      >
        <Heart 
          className={`follow-icon ${iconSizeClasses[size]} ${isFollowed ? 'filled' : 'outline'}`}
        />
      </button>
      {showCount && (
        <span className="follow-count">{venue.followersCount}</span>
      )}
    </div>
  );
};

export default FollowButton;
EOF

# 11. FollowStats component
cat > src/components/Follow/FollowStats.jsx << 'EOF'
import React from 'react';
import { Heart, Users, TrendingUp } from 'lucide-react';
import { useVenues } from '../../hooks/useVenues';

const FollowStats = ({ venue }) => {
  const { isVenueFollowed } = useVenues();
  const isFollowed = isVenueFollowed(venue.id);

  return (
    <div className="venue-follow-stats">
      <div className={`follow-stat ${isFollowed ? 'you-follow' : ''}`}>
        <Heart className="stat-icon" />
        <span className="stat-number">{venue.followersCount}</span>
        <span className="stat-label">
          {isFollowed ? 'You follow this' : 'Followers'}
        </span>
      </div>
      
      <div className="follow-stat">
        <Users className="stat-icon" />
        <span className="stat-number">{venue.reports}</span>
        <span className="stat-label">Reports</span>
      </div>
      
      <div className="follow-stat">
        <TrendingUp className="stat-icon" />
        <span className="stat-number">{venue.confidence}%</span>
        <span className="stat-label">Accuracy</span>
      </div>
    </div>
  );
};

export default FollowStats;
EOF

# 12. VenueCard component (enhanced)
cat > src/components/Venue/VenueCard.jsx << 'EOF'
import React, { useState } from 'react';
import { MapPin, Users, Clock, Star, TrendingUp, Share2, ChevronRight, Gift, Heart, Zap } from 'lucide-react';
import FollowButton from '../Follow/FollowButton';
import FollowStats from '../Follow/FollowStats';
import StarRating from './StarRating';
import Badge from '../UI/Badge';
import { useApp } from '../../context/AppContext';
import { getCrowdLabel, getCrowdColor, getTrendingIcon } from '../../utils/helpers';

const VenueCard = ({
  venue,
  onClick,
  onShare,
  searchQuery = ''
}) => {
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

  const handleDetails = () => {
    actions.setSelectedVenue(venue);
    actions.setCurrentView('details');
  };

  const handleShare = (e) => {
    e.stopPropagation();
    actions.setShareVenue(venue);
    actions.setShowShareModal(true);
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

  return (
    <div className="venue-card-container">
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
EOF

# 13. Header component
cat > src/components/Layout/Header.jsx << 'EOF'
import React from 'react';
import UserProfile from '../User/UserProfile';
import SearchBar from './SearchBar';

const Header = ({ searchQuery, setSearchQuery, onClearSearch }) => {
  return (
    <div className="header-frame">
      <div className="header-content">
        <div className="header-top">
          <div className="header-left">
            <h1 className="app-title">nYtevibe</h1>
            <p className="app-subtitle">Houston Nightlife Discovery</p>
          </div>
          <div className="header-right">
            <UserProfile />
          </div>
        </div>
        <div className="header-bottom">
          <SearchBar
            searchQuery={searchQuery}
            setSearchQuery={setSearchQuery}
            onClearSearch={onClearSearch}
          />
        </div>
      </div>
    </div>
  );
};

export default Header;
EOF

# 14. SearchBar component
cat > src/components/Layout/SearchBar.jsx << 'EOF'
import React from 'react';
import { Search, X } from 'lucide-react';

const SearchBar = ({ searchQuery, setSearchQuery, onClearSearch }) => {
  return (
    <div className="search-bar-container">
      <div className="search-input-wrapper">
        <Search className="search-icon" />
        <input
          type="text"
          value={searchQuery}
          onChange={(e) => setSearchQuery(e.target.value)}
          placeholder="Search venues, vibes, or locations..."
          className="search-input"
        />
        {searchQuery && (
          <button
            onClick={onClearSearch}
            className="search-clear"
            title="Clear search"
          >
            <X className="w-4 h-4" />
          </button>
        )}
      </div>
    </div>
  );
};

export default SearchBar;
EOF

# 15. UserProfile component (enhanced but no session)
cat > src/components/User/UserProfile.jsx << 'EOF'
import React, { useState, useEffect, useRef } from 'react';
import { useApp } from '../../context/AppContext';
import { getUserInitials, getLevelIcon } from '../../utils/helpers';

const UserProfile = () => {
  const { state, actions } = useApp();
  const { userProfile } = state;
  const [isDropdownOpen, setIsDropdownOpen] = useState(false);
  const dropdownRef = useRef(null);

  useEffect(() => {
    const handleClickOutside = (event) => {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target)) {
        setIsDropdownOpen(false);
      }
    };

    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
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
        </div>
      </div>

      {isDropdownOpen && <div className="dropdown-overlay" onClick={() => setIsDropdownOpen(false)} />}
    </div>
  );
};

export default UserProfile;
EOF

# Continue script...
echo "🎨 Creating complete CSS system..."

# 16. Complete App.css
cat > src/App.css << 'EOF'
/* nYtevibe Complete CSS System - Session-Free Enhanced Version */

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

.header-top {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.app-title {
  font-size: 1.875rem;
  font-weight: 800;
  color: white;
  margin: 0;
}

.app-subtitle {
  color: rgba(255, 255, 255, 0.7);
  font-size: 0.875rem;
  margin: 0;
}

/* Search Bar */
.search-bar-container {
  width: 100%;
}

.search-input-wrapper {
  position: relative;
  display: flex;
  align-items: center;
}

.search-icon {
  position: absolute;
  left: 12px;
  width: 20px;
  height: 20px;
  color: #9ca3af;
  z-index: 1;
}

.search-input {
  width: 100%;
  padding: 12px 12px 12px 44px;
  border: 2px solid rgba(255, 255, 255, 0.1);
  border-radius: var(--radius-lg);
  background: rgba(255, 255, 255, 0.1);
  color: white;
  font-size: 0.875rem;
  transition: var(--transition-normal);
}

.search-input:focus {
  outline: none;
  border-color: var(--color-primary);
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}

.search-input::placeholder {
  color: rgba(255, 255, 255, 0.5);
}

.search-clear {
  position: absolute;
  right: 12px;
  background: none;
  border: none;
  color: #9ca3af;
  cursor: pointer;
  padding: 4px;
  border-radius: var(--radius-sm);
  transition: var(--transition-normal);
}

.search-clear:hover {
  background: rgba(255, 255, 255, 0.1);
  color: white;
}

/* Venue Card Styles */
.venue-card-container {
  background: #ffffff;
  border-radius: var(--radius-xl);
  padding: 20px;
  margin-bottom: 20px;
  box-shadow: var(--shadow-md);
  transition: var(--transition-normal);
  position: relative;
  border: 2px solid transparent;
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
}

.share-button {
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

.share-button:hover {
  background: #f3f4f6;
  border-color: #d1d5db;
  color: #374151;
  transform: scale(1.05);
}

.crowd-status {
  align-self: flex-end;
}

.crowd-icon {
  width: 16px;
  height: 16px;
  margin-right: 4px;
}

.crowd-text {
  font-size: 0.875rem;
  font-weight: 600;
  color: white;
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

.badge-green {
  background: linear-gradient(135deg, #10b981, #059669);
  color: white;
  border: none;
}

.badge-yellow {
  background: linear-gradient(135deg, #f59e0b, #d97706);
  color: white;
  border: none;
}

.badge-red {
  background: linear-gradient(135deg, #ef4444, #dc2626);
  color: white;
  border: none;
}

.badge-blue {
  background: linear-gradient(135deg, #3b82f6, #2563eb);
  color: white;
  border: none;
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
  background: linear-gradient(135deg, #3b82f6, #2563eb);
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

/* Follow Button Styles */
.follow-button-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 4px;
}

.follow-button {
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
  position: relative;
}

.follow-button.followed {
  background: linear-gradient(135deg, #ef4444, #dc2626);
  border-color: #ef4444;
  color: white;
  box-shadow: 0 2px 8px rgba(239, 68, 68, 0.3);
}

.follow-button:hover {
  background: #f3f4f6;
  border-color: #d1d5db;
  color: #374151;
  transform: scale(1.05);
}

.follow-button.followed:hover {
  background: linear-gradient(135deg, #dc2626, #b91c1c);
  transform: scale(1.05);
  box-shadow: 0 4px 12px rgba(239, 68, 68, 0.4);
}

.follow-icon {
  width: 20px;
  height: 20px;
  transition: var(--transition-normal);
}

.follow-icon.filled {
  fill: currentColor;
}

.follow-icon.outline {
  fill: none;
  stroke: currentColor;
  stroke-width: 2;
}

.follow-count {
  font-size: 0.75rem;
  color: #6b7280;
  font-weight: 500;
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

.you-follow .stat-icon {
  color: #ef4444;
}

.you-follow .stat-label {
  color: #ef4444;
  font-weight: 600;
}

/* User Profile Styles */
.user-badge-container {
  position: relative;
}

.user-badge {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 8px 12px;
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: var(--radius-lg);
  cursor: pointer;
  transition: var(--transition-normal);
  color: white;
}

.user-badge:hover {
  background: rgba(255, 255, 255, 0.15);
}

.user-avatar-badge {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  background: var(--gradient-primary);
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 600;
  font-size: 0.875rem;
  color: white;
}

.user-info-badge {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
}

.user-name-badge {
  font-size: 0.875rem;
  font-weight: 600;
}

.user-level-badge {
  font-size: 0.75rem;
  color: rgba(255, 255, 255, 0.7);
  display: flex;
  align-items: center;
  gap: 4px;
}

.points-badge {
  color: #fbbf24;
  font-weight: 600;
}

.dropdown-icon {
  width: 16px;
  height: 16px;
  transition: var(--transition-normal);
}

.user-badge.open .dropdown-icon {
  transform: rotate(180deg);
}

/* User Dropdown */
.user-dropdown {
  position: absolute;
  top: 100%;
  right: 0;
  margin-top: 8px;
  width: 320px;
  background: white;
  border-radius: var(--radius-xl);
  box-shadow: var(--shadow-xl);
  border: 1px solid #e2e8f0;
  opacity: 0;
  visibility: hidden;
  transform: translateY(-10px);
  transition: all 0.2s ease;
  z-index: 1000;
}

.user-dropdown.open {
  opacity: 1;
  visibility: visible;
  transform: translateY(0);
}

.dropdown-header {
  padding: 20px;
  border-bottom: 1px solid #f1f5f9;
}

.dropdown-profile {
  display: flex;
  gap: 12px;
  margin-bottom: 16px;
}

.dropdown-avatar {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  background: var(--gradient-primary);
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 600;
  color: white;
}

.dropdown-user-info {
  flex: 1;
}

.dropdown-name {
  font-size: 1rem;
  font-weight: 600;
  color: #1e293b;
}

.dropdown-username {
  font-size: 0.875rem;
  color: #64748b;
}

.level-badge-dropdown {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  background: #f1f5f9;
  padding: 4px 8px;
  border-radius: var(--radius-sm);
  font-size: 0.75rem;
  font-weight: 500;
  color: #475569;
  margin-top: 4px;
}

.dropdown-stats {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 12px;
}

.dropdown-stat {
  text-align: center;
}

.dropdown-stat-number {
  font-size: 1rem;
  font-weight: 600;
  color: #1e293b;
}

.dropdown-stat-label {
  font-size: 0.75rem;
  color: #64748b;
}

/* Dropdown Menu */
.dropdown-menu {
  padding: 8px;
}

.dropdown-item {
  width: 100%;
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px;
  border: none;
  background: none;
  text-align: left;
  border-radius: var(--radius-lg);
  cursor: pointer;
  transition: var(--transition-normal);
  color: #374151;
  font-size: 0.875rem;
}

.dropdown-item:hover {
  background: #f8fafc;
  color: #1e293b;
}

.dropdown-item-icon {
  width: 18px;
  height: 18px;
  color: #64748b;
}

.dropdown-divider {
  height: 1px;
  background: #f1f5f9;
  margin: 8px 0;
}

.dropdown-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 999;
}

/* Star Rating */
.star-rating {
  display: flex;
  align-items: center;
  gap: 4px;
}

.stars-container {
  display: flex;
  gap: 2px;
}

.rating-count {
  font-size: 0.75rem;
  color: #6b7280;
  margin-left: 4px;
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
  z-index: 10000;
  display: flex;
  flex-direction: column;
  gap: 12px;
  max-width: 400px;
}

.notification {
  background: white;
  border-radius: 12px;
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
  border-left: 4px solid #3b82f6;
  animation: notificationSlideIn 0.3s ease-out;
  overflow: hidden;
}

.notification-success { border-left-color: #10b981; }
.notification-default { border-left-color: #3b82f6; }
.notification-warning { border-left-color: #f59e0b; }
.notification-error { border-left-color: #ef4444; }

.notification-content {
  padding: 16px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.notification-message {
  font-size: 0.875rem;
  color: #374151;
  font-weight: 500;
}

.notification-close {
  background: none;
  border: none;
  font-size: 1.25rem;
  color: #9ca3af;
  cursor: pointer;
  padding: 4px;
  line-height: 1;
}

.notification-close:hover {
  color: #374151;
}

@keyframes notificationSlideIn {
  from {
    transform: translateX(100%);
    opacity: 0;
  }
  to {
    transform: translateX(0);
    opacity: 1;
  }
}

/* Mobile Responsive */
@media (max-width: 768px) {
  .header-content {
    padding: 16px;
  }
  
  .header-top {
    flex-direction: column;
    gap: 16px;
    margin-bottom: 16px;
  }
  
  .venue-card-container {
    padding: 16px;
    margin-bottom: 16px;
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

  .user-dropdown {
    width: 280px;
  }
  
  .notification-container {
    left: 16px;
    right: 16px;
    max-width: none;
  }
}

@media (max-width: 480px) {
  .header-content {
    padding: 12px;
  }
  
  .venue-card-container {
    padding: 14px;
  }

  .details-btn-full {
    padding: 10px 16px;
    font-size: 0.8rem;
  }
  
  .user-dropdown {
    width: 260px;
  }
}

/* Animation Utilities */
.animate-fadeIn {
  animation: fadeIn 0.3s ease-out;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* Button Utilities */
.btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 8px 16px;
  border: none;
  border-radius: var(--radius-lg);
  font-size: 0.875rem;
  font-weight: 600;
  text-decoration: none;
  cursor: pointer;
  transition: var(--transition-normal);
  gap: 6px;
}

.btn-primary {
  background: var(--gradient-primary);
  color: white;
}

.btn-primary:hover {
  background: linear-gradient(135deg, #2563eb, #1d4ed8);
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(59, 130, 246, 0.4);
}

.btn-secondary {
  background: #f1f5f9;
  color: #475569;
  border: 1px solid #e2e8f0;
}

.btn-secondary:hover {
  background: #e2e8f0;
  color: #334155;
  transform: translateY(-1px);
}

/* Utility Classes */
.text-center { text-align: center; }
.text-left { text-align: left; }
.text-right { text-align: right; }
.flex { display: flex; }
.flex-1 { flex: 1; }
.items-center { align-items: center; }
.justify-center { justify-content: center; }
.justify-between { justify-content: space-between; }
.w-4 { width: 16px; }
.h-4 { height: 16px; }
.w-5 { width: 20px; }
.h-5 { height: 20px; }
.mb-2 { margin-bottom: 8px; }
.mb-3 { margin-bottom: 12px; }
.mb-4 { margin-bottom: 16px; }
.mr-1 { margin-right: 4px; }
.mr-2 { margin-right: 8px; }
.ml-2 { margin-left: 8px; }
.font-medium { font-weight: 500; }
.font-semibold { font-weight: 600; }
.font-bold { font-weight: 700; }
.text-xs { font-size: 0.75rem; }
.text-sm { font-size: 0.875rem; }
.text-lg { font-size: 1.125rem; }
.text-xl { font-size: 1.25rem; }
.text-red-500 { color: #ef4444; }
.text-yellow-400 { color: #fbbf24; }
.text-gray-300 { color: #d1d5db; }
.fill-current { fill: currentColor; }
EOF

echo "📄 Creating remaining components and views..."

# Continue with part 2 of the script to create remaining files...
echo "🔄 Script part 1 complete. Run part 2 to finish the rebuild."
echo ""
echo "✅ Core files created:"
echo "  • package.json (clean dependencies)"
echo "  • constants/index.js (promotional banners & data)"
echo "  • utils/helpers.js (utility functions)"
echo "  • context/AppContext.jsx (session-free context)"
echo "  • hooks/ (useVenues, useNotifications, useAI)"
echo "  • UI components (Button, Modal, Badge)"
echo "  • Venue components (VenueCard, StarRating, FollowButton)"
echo "  • Layout components (Header, SearchBar, UserProfile)"
echo "  • Complete App.css (professional styling)"
echo ""
EOF
