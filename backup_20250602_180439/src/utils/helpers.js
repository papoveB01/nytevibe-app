// Safe helper functions with proper error handling
// NO JSX IN THIS FILE - Only pure JavaScript functions

export const getCrowdLabel = (level) => {
  const levels = ['Unknown', 'Quiet', 'Moderate', 'Busy', 'Very Busy', 'Packed'];
  const numLevel = parseInt(level) || 0;
  return levels[numLevel] || levels[0];
};

export const getCrowdColor = (level) => {
  const colors = [
    'text-gray-500',
    'text-green-600',
    'text-yellow-600', 
    'text-orange-600',
    'text-red-600',
    'text-purple-600'
  ];
  const numLevel = parseInt(level) || 0;
  return colors[numLevel] || colors[0];
};

export const formatTime = (minutes) => {
  const numMinutes = parseInt(minutes) || 0;
  if (numMinutes === 0) return 'No wait';
  if (numMinutes < 60) return `${numMinutes}m`;
  const hours = Math.floor(numMinutes / 60);
  const remainingMinutes = numMinutes % 60;
  return remainingMinutes > 0 ? `${hours}h ${remainingMinutes}m` : `${hours}h`;
};

export const safeString = (str, fallback = '') => {
  if (typeof str === 'string') {
    return str.trim();
  }
  return fallback;
};

export const safeArray = (arr, fallback = []) => {
  return Array.isArray(arr) ? arr : fallback;
};

export const safeNumber = (num, fallback = 0) => {
  const parsed = parseFloat(num);
  return isNaN(parsed) ? fallback : parsed;
};

// FIXED: Get user initials from user profile data
export const getUserInitials = (userProfile) => {
  if (!userProfile) return 'U';
  
  const firstName = safeString(userProfile.firstName);
  const lastName = safeString(userProfile.lastName);
  const username = safeString(userProfile.username);
  
  if (firstName && lastName) {
    return `${firstName.charAt(0).toUpperCase()}${lastName.charAt(0).toUpperCase()}`;
  }
  
  if (firstName) {
    return firstName.charAt(0).toUpperCase();
  }
  
  if (username) {
    return username.charAt(0).toUpperCase();
  }
  
  return 'U';
};

// FIXED: Get level icon TYPE (not JSX) based on user level
export const getLevelIconType = (level) => {
  const numLevel = parseInt(level) || 1;
  
  if (numLevel >= 20) {
    return 'crown';
  } else if (numLevel >= 15) {
    return 'trophy';
  } else if (numLevel >= 10) {
    return 'award';
  } else if (numLevel >= 5) {
    return 'zap';
  } else {
    return 'star';
  }
};

// FIXED: Get level title based on user level
export const getLevelTitle = (level) => {
  const numLevel = parseInt(level) || 1;
  
  if (numLevel >= 20) {
    return 'Nightlife Legend';
  } else if (numLevel >= 15) {
    return 'Scene Master';
  } else if (numLevel >= 10) {
    return 'Venue Expert';
  } else if (numLevel >= 5) {
    return 'Night Explorer';
  } else {
    return 'New Member';
  }
};

// FIXED: Format points with proper number formatting
export const formatPoints = (points) => {
  const numPoints = parseInt(points) || 0;
  
  if (numPoints >= 1000000) {
    return `${(numPoints / 1000000).toFixed(1)}M`;
  } else if (numPoints >= 1000) {
    return `${(numPoints / 1000).toFixed(1)}K`;
  } else {
    return numPoints.toString();
  }
};

export const openGoogleMaps = (venue) => {
  if (!venue) return;
  
  const address = safeString(venue.address);
  const name = safeString(venue.name);
  
  if (address) {
    const encodedAddress = encodeURIComponent(address);
    const url = `https://www.google.com/maps/search/?api=1&query=${encodedAddress}`;
    window.open(url, '_blank');
  } else if (name) {
    const encodedName = encodeURIComponent(name);
    const url = `https://www.google.com/maps/search/?api=1&query=${encodedName}+Houston+TX`;
    window.open(url, '_blank');
  }
};

export const getDirections = (venue) => {
  if (!venue) return;
  
  const address = safeString(venue.address);
  
  if (address) {
    const encodedAddress = encodeURIComponent(address);
    const url = `https://www.google.com/maps/dir/?api=1&destination=${encodedAddress}`;
    window.open(url, '_blank');
  }
};

export const formatRating = (rating, decimals = 1) => {
  const numRating = safeNumber(rating, 0);
  return numRating.toFixed(decimals);
};

export const pluralize = (count, singular, plural) => {
  const numCount = safeNumber(count, 0);
  return numCount === 1 ? singular : (plural || `${singular}s`);
};

// Calculate user progress to next level
export const getUserProgress = (points) => {
  const numPoints = parseInt(points) || 0;
  
  // Define level thresholds
  const levelThresholds = [
    0,     // Level 1: 0 points
    100,   // Level 2: 100 points
    250,   // Level 3: 250 points
    500,   // Level 4: 500 points
    1000,  // Level 5: 1000 points
    2000,  // Level 6: 2000 points
    4000,  // Level 7: 4000 points
    8000,  // Level 8: 8000 points
    15000, // Level 9: 15000 points
    30000, // Level 10: 30000 points
    50000, // Level 11: 50000 points
    75000, // Level 12: 75000 points
    100000,// Level 13: 100000 points
    150000,// Level 14: 150000 points
    200000,// Level 15: 200000 points
    300000,// Level 16: 300000 points
    500000,// Level 17: 500000 points
    750000,// Level 18: 750000 points
    1000000,// Level 19: 1000000 points
    2000000 // Level 20: 2000000 points
  ];
  
  let currentLevel = 1;
  let nextLevelPoints = levelThresholds[1];
  let currentLevelPoints = levelThresholds[0];
  
  for (let i = 0; i < levelThresholds.length - 1; i++) {
    if (numPoints >= levelThresholds[i] && numPoints < levelThresholds[i + 1]) {
      currentLevel = i + 1;
      currentLevelPoints = levelThresholds[i];
      nextLevelPoints = levelThresholds[i + 1];
      break;
    }
  }
  
  // If points exceed the highest threshold, user is at max level
  if (numPoints >= levelThresholds[levelThresholds.length - 1]) {
    currentLevel = levelThresholds.length;
    currentLevelPoints = levelThresholds[levelThresholds.length - 1];
    nextLevelPoints = null; // Max level reached
  }
  
  const pointsToNext = nextLevelPoints ? nextLevelPoints - numPoints : 0;
  const progressPoints = numPoints - currentLevelPoints;
  const levelPoints = nextLevelPoints ? nextLevelPoints - currentLevelPoints : 0;
  const progressPercentage = levelPoints > 0 ? (progressPoints / levelPoints) * 100 : 100;
  
  return {
    currentLevel,
    nextLevel: nextLevelPoints ? currentLevel + 1 : null,
    pointsToNext,
    progressPercentage: Math.min(progressPercentage, 100),
    currentLevelPoints,
    nextLevelPoints
  };
};

// Get achievement status based on user activity
export const getAchievementProgress = (userProfile) => {
  if (!userProfile) return [];
  
  const achievements = [
    {
      id: 'first_review',
      name: 'First Review',
      description: 'Write your first venue review',
      progress: (userProfile.totalRatings || 0) >= 1 ? 100 : 0,
      completed: (userProfile.totalRatings || 0) >= 1,
      points: 25
    },
    {
      id: 'social_butterfly',
      name: 'Social Butterfly',
      description: 'Follow 5 venues',
      progress: Math.min(((userProfile.following || 0) / 5) * 100, 100),
      completed: (userProfile.following || 0) >= 5,
      points: 50
    },
    {
      id: 'reporter',
      name: 'Community Reporter',
      description: 'Submit 10 status reports',
      progress: Math.min(((userProfile.totalReports || 0) / 10) * 100, 100),
      completed: (userProfile.totalReports || 0) >= 10,
      points: 75
    },
    {
      id: 'points_collector',
      name: 'Point Collector',
      description: 'Earn 1000 points',
      progress: Math.min(((userProfile.points || 0) / 1000) * 100, 100),
      completed: (userProfile.points || 0) >= 1000,
      points: 100
    }
  ];
  
  return achievements;
};

// Format date/time strings safely
export const formatDate = (dateString, options = {}) => {
  try {
    const date = new Date(dateString);
    if (isNaN(date.getTime())) {
      return 'Invalid Date';
    }
    
    const defaultOptions = {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
      ...options
    };
    
    return date.toLocaleDateString('en-US', defaultOptions);
  } catch (error) {
    return 'Invalid Date';
  }
};

// Format relative time (e.g., "2 hours ago")
export const formatRelativeTime = (dateString) => {
  try {
    const date = new Date(dateString);
    const now = new Date();
    const diffInSeconds = Math.floor((now - date) / 1000);
    
    if (diffInSeconds < 60) {
      return 'Just now';
    }
    
    const diffInMinutes = Math.floor(diffInSeconds / 60);
    if (diffInMinutes < 60) {
      return `${diffInMinutes} minute${diffInMinutes !== 1 ? 's' : ''} ago`;
    }
    
    const diffInHours = Math.floor(diffInMinutes / 60);
    if (diffInHours < 24) {
      return `${diffInHours} hour${diffInHours !== 1 ? 's' : ''} ago`;
    }
    
    const diffInDays = Math.floor(diffInHours / 24);
    if (diffInDays < 7) {
      return `${diffInDays} day${diffInDays !== 1 ? 's' : ''} ago`;
    }
    
    const diffInWeeks = Math.floor(diffInDays / 7);
    if (diffInWeeks < 4) {
      return `${diffInWeeks} week${diffInWeeks !== 1 ? 's' : ''} ago`;
    }
    
    return formatDate(dateString);
  } catch (error) {
    return 'Unknown time';
  }
};
