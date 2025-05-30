#!/bin/bash

# nYtevibe Modular Enhancement Script
# This script enhances your existing modular implementation with complete data and exact styling

echo "🎯 Enhancing nYtevibe Modular Implementation with Complete Specifications..."

# Create complete constants file
echo "📝 Creating complete constants/index.js..."
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
  FOLLOW_ANIMATION: 2000 // 2 seconds
};

export const PROMOTIONAL_BANNERS = [
  {
    id: 'community',
    type: 'community',
    icon: 'MessageCircle',
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
    icon: 'Gift',
    title: "NYC Vibes says: Free Hookah for Ladies! 🎉",
    subtitle: "6:00 PM - 10:00 PM • Tonight Only • Limited Time",
    bgColor: "rgba(236, 72, 153, 0.15)",
    borderColor: "rgba(236, 72, 153, 0.3)",
    iconColor: "#ec4899"
  },
  {
    id: 'red-sky-grand-opening',
    type: 'promotion',
    venue: 'Red Sky Hookah Lounge',
    icon: 'Sparkles',
    title: "Red Sky: Grand Opening Special! 🔥",
    subtitle: "50% Off Premium Hookah • Live DJ • VIP Lounge Available",
    bgColor: "rgba(239, 68, 68, 0.15)",
    borderColor: "rgba(239, 68, 68, 0.3)",
    iconColor: "#ef4444"
  },
  {
    id: 'best-regards-event',
    type: 'event',
    venue: 'Best Regards',
    icon: 'Volume2',
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
    icon: 'Calendar',
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
    icon: 'Volume2',
    title: "Classic Bar: Big Game Tonight! 🏈",
    subtitle: "Texans vs Cowboys • 50¢ wings • Free shots for TDs!",
    bgColor: "rgba(251, 146, 60, 0.15)",
    borderColor: "rgba(251, 146, 60, 0.3)",
    iconColor: "#fb923c"
  },
  {
    id: 'social-new',
    type: 'social',
    icon: 'UserPlus',
    title: "Connect with friends! 👥",
    subtitle: "Share venues, create lists, and discover together",
    bgColor: "rgba(168, 85, 247, 0.15)",
    borderColor: "rgba(168, 85, 247, 0.3)",
    iconColor: "#a855f7"
  },
  {
    id: 'ai-recommendations',
    type: 'ai',
    icon: 'Brain',
    title: "AI-Powered Recommendations! 🤖",
    subtitle: "Discover venues tailored to your taste profile",
    bgColor: "rgba(34, 197, 94, 0.15)",
    borderColor: "rgba(34, 197, 94, 0.3)",
    iconColor: "#22c55e"
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

# Create complete venue data
echo "📝 Creating data/venues.js with complete venue information..."
mkdir -p src/data
cat > src/data/venues.js << 'EOF'
export const VENUES_DATA = [
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
];
EOF

# Create complete user data
echo "📝 Creating data/user.js with Papove Bombando profile..."
cat > src/data/user.js << 'EOF'
export const USER_PROFILE_DATA = {
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
};

export const FRIENDS_DATA = [
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
];
EOF

# Update helpers.js with exact implementation
echo "📝 Updating utils/helpers.js with complete helper functions..."
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
      return true;
    case 'twitter':
      window.open(`https://twitter.com/intent/tweet?text=${encodeURIComponent(shareText)}&url=${encodeURIComponent(shareUrl)}`);
      return true;
    case 'instagram':
      navigator.clipboard.writeText(shareUrl);
      return true;
    case 'copy':
      navigator.clipboard.writeText(`${shareText}\n${shareUrl}`);
      return true;
    case 'whatsapp':
      window.open(`https://wa.me/?text=${encodeURIComponent(`${shareText}\n${shareUrl}`)}`);
      return true;
    default:
      navigator.clipboard.writeText(`${shareText}\n${shareUrl}`);
      return true;
  }
};

export const getPromoIcon = (text) => {
  if (text.toLowerCase().includes('free') || text.toLowerCase().includes('50%') || text.toLowerCase().includes('%')) {
    return 'Zap';
  }
  if (text.toLowerCase().includes('dj') || text.toLowerCase().includes('music')) {
    return '🎵';
  }
  if (text.toLowerCase().includes('game') || text.toLowerCase().includes('sports')) {
    return '🏈';
  }
  return 'Gift';
};

export const calculateUserLevel = (points) => {
  if (points < 500) return { name: 'Bronze Explorer', tier: 'bronze' };
  if (points < 1000) return { name: 'Silver Scout', tier: 'silver' };
  if (points < 2000) return { name: 'Gold Explorer', tier: 'gold' };
  if (points < 5000) return { name: 'Platinum Pioneer', tier: 'platinum' };
  return { name: 'Diamond Legend', tier: 'diamond' };
};

export const highlightText = (text, query) => {
  if (!query.trim()) return text;
  const parts = text.split(new RegExp(`(${query})`, 'gi'));
  return parts.map((part, index) => 
    part.toLowerCase() === query.toLowerCase() ? 
      `<mark class="search-highlight">${part}</mark>` : part
  ).join('');
};
EOF

# Update AppContext.jsx with complete initial state
echo "📝 Updating context/AppContext.jsx with complete initial state..."
cat > src/context/AppContext.jsx << 'EOF'
import React, { createContext, useContext, useReducer, useCallback } from 'react';
import { VENUES_DATA } from '../data/venues';
import { USER_PROFILE_DATA, FRIENDS_DATA } from '../data/user';
import { UPDATE_INTERVALS, POINT_SYSTEM } from '../constants';

const AppContext = createContext();

const initialState = {
  userProfile: USER_PROFILE_DATA,
  venues: VENUES_DATA,
  friends: FRIENDS_DATA,
  notifications: [],
  currentView: 'home',
  selectedVenue: null,
  showRatingModal: false,
  showReportModal: false,
  searchQuery: '',
  venueFilter: 'all',
  loading: false,
  error: null
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

    case 'SET_SEARCH_QUERY':
      return { ...state, searchQuery: action.payload };

    case 'SET_VENUE_FILTER':
      return { ...state, venueFilter: action.payload };

    case 'FOLLOW_VENUE':
      const { venueId, venueName, listId } = action.payload;
      const newFollowedVenues = [...state.userProfile.followedVenues];
      if (!newFollowedVenues.includes(venueId)) {
        newFollowedVenues.push(venueId);
      }

      const updatedFollowLists = state.userProfile.followLists.map(list => {
        if (list.id === listId) {
          return {
            ...list,
            venueIds: [...list.venueIds, venueId]
          };
        }
        return list;
      });

      const followHistoryEntry = {
        id: `fh_${Date.now()}`,
        venueId,
        venueName,
        action: 'follow',
        timestamp: new Date().toISOString(),
        reason: listId ? `Added to ${listId} list` : 'Manual follow',
        listId
      };

      return {
        ...state,
        userProfile: {
          ...state.userProfile,
          followedVenues: newFollowedVenues,
          followLists: updatedFollowLists,
          followHistory: [followHistoryEntry, ...state.userProfile.followHistory],
          points: state.userProfile.points + POINT_SYSTEM.FOLLOW_VENUE,
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
      const unfollowVenueName = action.payload.venueName;
      
      const filteredFollowedVenues = state.userProfile.followedVenues.filter(id => id !== unfollowVenueId);
      
      const clearedFollowLists = state.userProfile.followLists.map(list => ({
        ...list,
        venueIds: list.venueIds.filter(id => id !== unfollowVenueId)
      }));

      const unfollowHistoryEntry = {
        id: `fh_${Date.now()}`,
        venueId: unfollowVenueId,
        venueName: unfollowVenueName,
        action: 'unfollow',
        timestamp: new Date().toISOString(),
        reason: 'Manual unfollow'
      };

      return {
        ...state,
        userProfile: {
          ...state.userProfile,
          followedVenues: filteredFollowedVenues,
          followLists: clearedFollowLists,
          followHistory: [unfollowHistoryEntry, ...state.userProfile.followHistory],
          points: Math.max(0, state.userProfile.points + POINT_SYSTEM.UNFOLLOW_VENUE),
          totalFollows: Math.max(0, state.userProfile.totalFollows - 1)
        },
        venues: state.venues.map(venue =>
          venue.id === unfollowVenueId
            ? { ...venue, followersCount: Math.max(0, venue.followersCount - 1) }
            : venue
        )
      };

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

    case 'ADD_NOTIFICATION':
      const notification = {
        id: Date.now(),
        type: action.payload.type || 'default',
        message: action.payload.message,
        duration: action.payload.duration || UPDATE_INTERVALS.NOTIFICATION_DURATION,
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
          points: state.userProfile.points + POINT_SYSTEM.RATE_VENUE,
          totalRatings: state.userProfile.totalRatings + 1
        }
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
              waitTime: reportData.waitTime || venue.waitTime,
              reports: venue.reports + 1,
              lastUpdate: "Just now",
              confidence: Math.min(98, venue.confidence + 5)
            };
          }
          return venue;
        }),
        userProfile: {
          ...state.userProfile,
          points: state.userProfile.points + POINT_SYSTEM.REPORT_VENUE,
          totalReports: state.userProfile.totalReports + 1
        }
      };

    case 'SET_LOADING':
      return { ...state, loading: action.payload };

    case 'SET_ERROR':
      return { ...state, error: action.payload };

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

    setSearchQuery: useCallback((query) => {
      dispatch({ type: 'SET_SEARCH_QUERY', payload: query });
    }, []),

    setVenueFilter: useCallback((filter) => {
      dispatch({ type: 'SET_VENUE_FILTER', payload: filter });
    }, []),

    followVenue: useCallback((venueId, venueName, listId = null) => {
      dispatch({ 
        type: 'FOLLOW_VENUE', 
        payload: { venueId, venueName, listId } 
      });
    }, []),

    unfollowVenue: useCallback((venueId, venueName) => {
      dispatch({ 
        type: 'UNFOLLOW_VENUE', 
        payload: { venueId, venueName } 
      });
    }, []),

    updateVenueData: useCallback(() => {
      dispatch({ type: 'UPDATE_VENUE_DATA' });
    }, []),

    addNotification: useCallback((notification) => {
      dispatch({ type: 'ADD_NOTIFICATION', payload: notification });
    }, []),

    removeNotification: useCallback((id) => {
      dispatch({ type: 'REMOVE_NOTIFICATION', payload: id });
    }, []),

    rateVenue: useCallback((venueId, rating, comment) => {
      dispatch({ 
        type: 'RATE_VENUE', 
        payload: { venueId, rating, comment } 
      });
    }, []),

    reportVenue: useCallback((venueId, reportData) => {
      dispatch({ 
        type: 'REPORT_VENUE', 
        payload: { venueId, reportData } 
      });
    }, []),

    setLoading: useCallback((loading) => {
      dispatch({ type: 'SET_LOADING', payload: loading });
    }, []),

    setError: useCallback((error) => {
      dispatch({ type: 'SET_ERROR', payload: error });
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

# Replace the existing App.css with exact specification styling
echo "📝 Updating App.css with exact blueprint specifications..."
cat > src/App.css << 'EOF'
/* nYtevibe - Exact Blueprint Styling Implementation */

:root {
  /* Exact Color Values from Blueprint */
  --color-primary: #3b82f6;
  --color-secondary: #6b7280;
  --color-success: #10b981;
  --color-warning: #f59e0b;
  --color-danger: #ef4444;
  --color-follow: #ef4444;
  
  /* Exact Gradients from Blueprint */
  --gradient-primary: linear-gradient(135deg, #3b82f6, #2563eb);
  --gradient-secondary: linear-gradient(135deg, #6b7280, #4b5563);
  --gradient-success: linear-gradient(135deg, #10b981, #059669);
  --gradient-warning: linear-gradient(135deg, #f59e0b, #d97706);
  --gradient-danger: linear-gradient(135deg, #ef4444, #dc2626);
  --gradient-follow: linear-gradient(135deg, #ef4444, #dc2626);
  --gradient-promotion: linear-gradient(135deg, #ff6b6b, #ff5252);
  --gradient-ai: linear-gradient(135deg, #34d399, #059669);
  
  /* Background System */
  --background-primary: #1e293b;
  --card-background: #ffffff;
  
  /* Text Colors */
  --text-primary: #1e293b;
  --text-secondary: #64748b;
  --text-muted: #9ca3af;
  
  /* Exact Radius Values */
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

/* EXACT VENUE CARD IMPLEMENTATION */
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

.venue-card-container.venue-followed {
  border-color: #ef4444;
  background: #ffffff;
  box-shadow: 0 4px 6px rgba(239, 68, 68, 0.15), 0 1px 3px rgba(239, 68, 68, 0.1);
  border-width: 3px;
  position: relative;
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

/* EXACT SLEEK PROMOTION BADGE */
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
  0% {
    box-shadow: 0 2px 8px rgba(255, 107, 107, 0.4);
  }
  50% {
    box-shadow: 0 2px 8px rgba(255, 107, 107, 0.4), 0 0 0 8px rgba(255, 107, 107, 0.1);
  }
  100% {
    box-shadow: 0 2px 8px rgba(255, 107, 107, 0.4);
  }
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

/* Venue Card Layout - EXACT IMPLEMENTATION */
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
  0% {
    box-shadow: 0 0 0 0 rgba(239, 68, 68, 0.4);
  }
  70% {
    box-shadow: 0 0 0 6px rgba(239, 68, 68, 0);
  }
  100% {
    box-shadow: 0 0 0 0 rgba(239, 68, 68, 0);
  }
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

.venue-rating-row {
  margin: 4px 0;
}

/* Actions Section - EXACT IMPLEMENTATION */
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

/* EXACT BADGE IMPLEMENTATION */
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

.badge-primary {
  background: linear-gradient(135deg, #3b82f6, #2563eb);
  color: white;
  border: none;
}

.badge.badge-green {
  background: linear-gradient(135deg, #10b981, #059669);
  color: white;
  border: none;
}

.badge.badge-yellow {
  background: linear-gradient(135deg, #f59e0b, #d97706);
  color: white;
  border: none;
}

.badge.badge-red {
  background: linear-gradient(135deg, #ef4444, #dc2626);
  color: white;
  border: none;
}

.badge.badge-blue {
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

/* EXACT FOLLOW BUTTON IMPLEMENTATION */
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

/* Search Highlight */
.search-highlight {
  background-color: #fef3c7;
  color: #92400e;
  padding: 1px 2px;
  border-radius: 2px;
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

.star-rating-container {
  display: flex;
  align-items: center;
  gap: 8px;
}

.rating-count {
  font-size: 0.75rem;
  color: #6b7280;
  font-weight: 500;
}

/* Home View Layout */
.home-view {
  padding: 20px;
  max-width: 1200px;
  margin: 0 auto;
}

.home-content {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.venues-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
  gap: 20px;
}

/* Venue Details View */
.venue-details-view {
  min-height: 100vh;
  background: #f8fafc;
  background: linear-gradient(180deg, #f8fafc 0%, #f1f5f9 100%);
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
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.details-header h2 {
  color: #1e293b;
  font-weight: 700;
  margin: 0;
}

.back-button {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 40px;
  height: 40px;
  border-radius: var(--radius-full);
  border: 2px solid #e2e8f0;
  background: #f8fafc;
  color: #64748b;
  cursor: pointer;
  transition: var(--transition-normal);
}

.back-button:hover {
  background: #e2e8f0;
  border-color: #cbd5e1;
  color: #475569;
  transform: scale(1.05);
}

.details-content {
  padding: 20px;
  max-width: 800px;
  margin: 0 auto;
}

.venue-header-section {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 24px;
  background: white;
  padding: 20px;
  border-radius: 16px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.venue-title-section h1 {
  font-size: 1.5rem;
  font-weight: 700;
  color: #1f2937;
  margin-bottom: 8px;
}

.venue-subtitle {
  color: #6b7280;
  font-size: 0.875rem;
  margin-bottom: 8px;
}

.separator {
  margin: 0 8px;
  color: #d1d5db;
}

/* Promotional Banner */
.promotional-banner {
  background: #ffffff;
  border-radius: var(--radius-xl);
  padding: 16px 20px;
  margin-bottom: 20px;
  box-shadow: var(--shadow-sm);
  border-left: 4px solid;
  transition: var(--transition-normal);
  cursor: pointer;
}

.promotional-banner:hover {
  transform: translateY(-1px);
  box-shadow: var(--shadow-md);
}

.banner-content {
  display: flex;
  align-items: center;
  gap: 12px;
}

.banner-icon {
  flex-shrink: 0;
  width: 24px;
  height: 24px;
}

.banner-text {
  flex: 1;
}

.banner-title {
  font-weight: 600;
  font-size: 0.875rem;
  color: #1f2937;
  margin-bottom: 2px;
}

.banner-subtitle {
  font-size: 0.75rem;
  color: #6b7280;
  line-height: 1.4;
}

/* Modal Styles */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.7);
  backdrop-filter: blur(4px);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  padding: 16px;
}

.modal-content {
  background: #ffffff;
  border-radius: var(--radius-xl);
  width: 100%;
  max-width: 500px;
  max-height: 90vh;
  overflow-y: auto;
  box-shadow: var(--shadow-xl);
  color: #1e293b;
}

.modal-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 20px;
  border-bottom: 1px solid #f1f5f9;
}

.modal-title {
  font-size: 1.25rem;
  font-weight: 700;
  color: #1e293b;
  margin: 0;
}

.modal-close {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 32px;
  height: 32px;
  border-radius: var(--radius-full);
  border: none;
  background: #f8fafc;
  color: #64748b;
  cursor: pointer;
  transition: var(--transition-normal);
}

.modal-close:hover {
  background: #e2e8f0;
  color: #475569;
}

.modal-body {
  padding: 20px;
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

.btn-warning {
  background: var(--gradient-warning);
  color: white;
}

.btn-warning:hover {
  background: linear-gradient(135deg, #d97706, #b45309);
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(245, 158, 11, 0.4);
}

/* Form Styles */
.form-input {
  width: 100%;
  padding: 12px;
  border: 2px solid #e2e8f0;
  border-radius: var(--radius-lg);
  background: #ffffff;
  color: #1e293b;
  font-family: inherit;
  font-size: 0.875rem;
  transition: var(--transition-normal);
}

.form-input:focus {
  outline: none;
  border-color: #3b82f6;
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}

.form-input::placeholder {
  color: #9ca3af;
}

/* Notification System */
.notification-container {
  position: fixed;
  top: 20px;
  right: 20px;
  z-index: 1000;
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.notification {
  background: white;
  border-radius: 12px;
  padding: 12px 16px;
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
  animation: slideInRight 0.3s ease-out;
  max-width: 300px;
  border-left: 4px solid;
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
  font-weight: 500;
  color: #1f2937;
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

/* Filter Button */
.filter-button {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 8px 12px;
  border: 2px solid #e5e7eb;
  border-radius: 8px;
  background: #f9fafb;
  color: #6b7280;
  font-size: 0.875rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;
}

.filter-button:hover {
  border-color: #d1d5db;
  background: #f3f4f6;
}

.filter-button.active {
  border-color: #ef4444;
  background: #fef2f2;
  color: #ef4444;
}

/* Search Bar */
.search-container {
  position: relative;
  margin-bottom: 20px;
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
  width: 20px;
  height: 20px;
}

/* Mobile Responsive */
@media (max-width: 768px) {
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
  
  .top-actions {
    margin-right: 38px;
  }
  
  .venue-promotion-sleek {
    width: 28px;
    height: 28px;
    top: 8px;
    right: 8px;
  }
  
  .venues-grid {
    grid-template-columns: 1fr;
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
  
  .top-actions {
    margin-right: 32px;
  }
  
  .home-view {
    padding: 12px;
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
.fill-current { fill: currentColor; }
EOF

# Update existing hooks with complete implementations
echo "📝 Updating hooks with complete implementations..."

# Update useVenues.js
cat > src/hooks/useVenues.js << 'EOF'
import { useCallback } from 'react';
import { useApp } from '../context/AppContext';
import { UPDATE_INTERVALS } from '../constants';

export const useVenues = () => {
  const { state, actions } = useApp();

  const updateVenueData = useCallback(() => {
    actions.updateVenueData();
  }, [actions]);

  const isVenueFollowed = useCallback((venueId) => {
    return state.userProfile.followedVenues.includes(venueId);
  }, [state.userProfile.followedVenues]);

  const followVenue = useCallback((venue, listId = null) => {
    if (!isVenueFollowed(venue.id)) {
      actions.followVenue(venue.id, venue.name, listId);
      actions.addNotification({
        type: 'follow',
        message: `Following ${venue.name}`,
        duration: UPDATE_INTERVALS.NOTIFICATION_DURATION
      });
    }
  }, [actions, isVenueFollowed]);

  const unfollowVenue = useCallback((venue) => {
    if (isVenueFollowed(venue.id)) {
      actions.unfollowVenue(venue.id, venue.name);
      actions.addNotification({
        type: 'unfollow',
        message: `Unfollowed ${venue.name}`,
        duration: UPDATE_INTERVALS.NOTIFICATION_DURATION
      });
    }
  }, [actions, isVenueFollowed]);

  const toggleFollow = useCallback((venue, listId = null) => {
    if (isVenueFollowed(venue.id)) {
      unfollowVenue(venue);
    } else {
      followVenue(venue, listId);
    }
  }, [isVenueFollowed, followVenue, unfollowVenue]);

  const rateVenue = useCallback((venueId, rating, comment) => {
    actions.rateVenue(venueId, rating, comment);
    actions.addNotification({
      type: 'success',
      message: 'Rating submitted successfully!',
      duration: UPDATE_INTERVALS.NOTIFICATION_DURATION
    });
  }, [actions]);

  const reportVenue = useCallback((venueId, reportData) => {
    actions.reportVenue(venueId, reportData);
    actions.addNotification({
      type: 'success',
      message: 'Venue status updated successfully!',
      duration: UPDATE_INTERVALS.NOTIFICATION_DURATION
    });
  }, [actions]);

  const searchVenues = useCallback((query, filter = 'all') => {
    let filteredVenues = state.venues;

    // Apply text search
    if (query.trim()) {
      const lowercaseQuery = query.toLowerCase();
      filteredVenues = filteredVenues.filter(venue =>
        venue.name.toLowerCase().includes(lowercaseQuery) ||
        venue.type.toLowerCase().includes(lowercaseQuery) ||
        venue.city.toLowerCase().includes(lowercaseQuery) ||
        venue.postcode.includes(query) ||
        venue.vibe.some(v => v.toLowerCase().includes(lowercaseQuery))
      );
    }

    // Apply filter
    switch (filter) {
      case 'followed':
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
        // 'all' - no additional filtering
        break;
    }

    return filteredVenues;
  }, [state.venues, state.userProfile.followedVenues]);

  return {
    venues: state.venues,
    selectedVenue: state.selectedVenue,
    updateVenueData,
    isVenueFollowed,
    followVenue,
    unfollowVenue,
    toggleFollow,
    rateVenue,
    reportVenue,
    searchVenues
  };
};
EOF

# Update useNotifications.js
cat > src/hooks/useNotifications.js << 'EOF'
import { useEffect } from 'react';
import { useApp } from '../context/AppContext';

export const useNotifications = () => {
  const { state, actions } = useApp();

  useEffect(() => {
    // Auto-remove notifications after their duration
    const timers = state.notifications.map(notification => {
      return setTimeout(() => {
        actions.removeNotification(notification.id);
      }, notification.duration);
    });

    return () => {
      timers.forEach(timer => clearTimeout(timer));
    };
  }, [state.notifications, actions]);

  const addNotification = (notification) => {
    actions.addNotification(notification);
  };

  const removeNotification = (id) => {
    actions.removeNotification(id);
  };

  const clearAllNotifications = () => {
    state.notifications.forEach(notification => {
      actions.removeNotification(notification.id);
    });
  };

  return {
    notifications: state.notifications,
    addNotification,
    removeNotification,
    clearAllNotifications
  };
};
EOF

# Update existing VenueCard.jsx with exact implementation
echo "📝 Updating VenueCard.jsx with exact blueprint implementation..."
cat > src/components/Venue/VenueCard.jsx << 'EOF'
import React, { useState } from 'react';
import { MapPin, Users, Clock, Star, TrendingUp, Share2, ChevronRight, Gift, Heart, Zap } from 'lucide-react';
import FollowButton from '../Follow/FollowButton';
import FollowStats from '../Follow/FollowStats';
import StarRating from './StarRating';
import Badge from '../UI/Badge';
import { useVenues } from '../../hooks/useVenues';
import { useApp } from '../../context/AppContext';
import { getCrowdLabel, getCrowdColor, getTrendingIcon, getPromoIcon } from '../../utils/helpers';

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
    actions.setCurrentView('detail');
  };

  const renderPromoIcon = (text) => {
    const iconType = getPromoIcon(text);
    if (iconType === 'Zap') {
      return <Zap className="w-3 h-3" />;
    } else if (typeof iconType === 'string' && iconType.length === 2) {
      return <span className="promo-emoji">{iconType}</span>;
    } else {
      return <Gift className="w-3 h-3" />;
    }
  };

  return (
    <div className={`venue-card-container ${isFollowed ? 'venue-followed' : ''}`}>
      {venue.hasPromotion && (
        <div 
          className="venue-promotion-sleek"
          onMouseEnter={() => setShowPromoTooltip(true)}
          onMouseLeave={() => setShowPromoTooltip(false)}
        >
          {renderPromoIcon(venue.promotionText)}
          
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

# Create missing components that are referenced
echo "📝 Creating missing component implementations..."

# Create StarRating component
cat > src/components/Venue/StarRating.jsx << 'EOF'
import React from 'react';
import { Star } from 'lucide-react';

const StarRating = ({ 
  rating = 0, 
  size = 'md', 
  showCount = false, 
  totalRatings = 0,
  interactive = false,
  onRate = null 
}) => {
  const sizeClasses = {
    sm: 'w-3 h-3',
    md: 'w-4 h-4',
    lg: 'w-5 h-5'
  };

  const stars = Array.from({ length: 5 }, (_, index) => {
    const starNumber = index + 1;
    const isFilled = starNumber <= Math.floor(rating);
    const isHalfFilled = starNumber === Math.ceil(rating) && rating % 1 !== 0;

    return (
      <Star
        key={index}
        className={`${sizeClasses[size]} ${
          isFilled || isHalfFilled ? 'fill-current text-yellow-400' : 'text-gray-300'
        } ${interactive ? 'cursor-pointer hover:text-yellow-500' : ''}`}
        onClick={interactive ? () => onRate?.(starNumber) : undefined}
      />
    );
  });

  return (
    <div className="star-rating-container">
      <div className="star-rating">
        {stars}
      </div>
      {showCount && totalRatings > 0 && (
        <span className="rating-count">
          {rating.toFixed(1)} ({totalRatings})
        </span>
      )}
    </div>
  );
};

export default StarRating;
EOF

# Create PromotionalBanner component
echo "📝 Creating PromotionalBanner component..."
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
        borderLeftColor: banner.borderColor
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
          <div className="banner-title">{banner.title}</div>
          <div className="banner-subtitle">{banner.subtitle}</div>
        </div>
      </div>
    </div>
  );
};

export default PromotionalBanner;
EOF

# Create Header component
echo "📝 Creating Header component..."
cat > src/components/Layout/Header.jsx << 'EOF'
import React from 'react';
import { Search, X } from 'lucide-react';
import UserProfile from '../User/UserProfile';

const Header = ({ searchQuery, setSearchQuery, onClearSearch }) => {
  return (
    <div className="header-frame">
      <div className="header-content">
        <div className="flex justify-between items-center mb-4">
          <div>
            <h1 className="app-title">nYtevibe</h1>
            <p className="app-subtitle">Discover real-time venue vibes in Houston</p>
          </div>
          <UserProfile />
        </div>
        
        <div className="search-container">
          <Search className="search-icon" />
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
              className="absolute right-3 top-1/2 transform -translate-y-1/2 p-1 hover:bg-gray-100 rounded-full"
            >
              <X className="w-4 h-4 text-gray-400" />
            </button>
          )}
        </div>
      </div>
    </div>
  );
};

export default Header;
EOF

echo "✅ nYtevibe Modular Enhancement Complete!"
echo ""
echo "🎯 Your app now has:"
echo "   ✅ Complete venue data (6 venues with NYC Vibes, Rumors, Classic, etc.)"
echo "   ✅ Papove Bombando user profile with full stats"
echo "   ✅ Exact CSS styling with white venue cards and promotion badges"
echo "   ✅ All promotional banners and constants"
echo "   ✅ Complete follow system with animations"
echo "   ✅ Real-time updates every 45 seconds"
echo "   ✅ Exact color gradients and animations"
echo "   ✅ Mobile responsive design"
echo ""
echo "🚀 Next steps:"
echo "   1. npm install (if needed)"
echo "   2. npm run dev"
echo "   3. Test all venue interactions"
echo "   4. Verify the white venue cards with sleek promotion badges"
echo "   5. Test the follow system with heart animations"
echo ""
echo "🎨 Key Features Implemented:"
echo "   • White venue cards (#ffffff background)"
echo "   • Sleek promotion badges with pulse animation"
echo "   • Exact follow button gradients"
echo "   • Real Papove Bombando profile"
echo "   • Complete venue data with reviews"
echo "   • Promotional banners system"
echo "   • Search highlighting"
echo "   • Responsive mobile design"
echo ""
echo "✨ Your nYtevibe app now matches the exact blueprint specifications!"
EOF

chmod +x enhance-nytevibe-modular.sh
echo "🎯 Enhancement script created: enhance-nytevibe-modular.sh"
echo ""
echo "To apply the enhancements to your modular implementation:"
echo "   1. cd to your nytevibe project directory"
echo "   2. Run: bash enhance-nytevibe-modular.sh"
echo ""
echo "This will add all missing data, exact styling, and complete functionality!"
