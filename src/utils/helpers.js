export const getCrowdLabel = (level) => {
  if (level >= 80) return 'Very Busy';
  if (level >= 60) return 'Busy';
  if (level >= 40) return 'Moderate';
  if (level >= 20) return 'Light';
  return 'Empty';
};

export const getCrowdColor = (level) => {
  if (level >= 80) return 'text-red-600 bg-red-50';
  if (level >= 60) return 'text-orange-600 bg-orange-50';
  if (level >= 40) return 'text-yellow-600 bg-yellow-50';
  if (level >= 20) return 'text-green-600 bg-green-50';
  return 'text-gray-600 bg-gray-50';
};

export const formatTime = (timestamp) => {
  const now = new Date();
  const time = new Date(timestamp);
  const diff = now - time;
  
  const minutes = Math.floor(diff / 60000);
  const hours = Math.floor(minutes / 60);
  const days = Math.floor(hours / 24);
  
  if (days > 0) return `${days} day${days > 1 ? 's' : ''} ago`;
  if (hours > 0) return `${hours} hour${hours > 1 ? 's' : ''} ago`;
  if (minutes > 0) return `${minutes} min ago`;
  return 'Just now';
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

export const getUserInitials = (user) => {
  if (!user) return 'U';
  const firstName = user.firstName || '';
  const lastName = user.lastName || '';
  return (firstName.charAt(0) + lastName.charAt(0)).toUpperCase() || 'U';
};

export const getLevelIcon = (level) => {
  switch (level) {
    case 'Explorer': return '🔍';
    case 'Insider': return '⭐';
    case 'VIP': return '👑';
    case 'Legend': return '🏆';
    default: return '🔍';
  }
};

export const shareVenue = async (venue, platform) => {
  const text = `Check out ${venue.name} on nYtevibe! ${venue.type} with ${venue.rating}⭐ rating.`;
  const url = `https://nytevibe.com/venue/${venue.id}`;
  
  if (platform === 'native' && navigator.share) {
    try {
      await navigator.share({
        title: `${venue.name} - nYtevibe`,
        text: text,
        url: url
      });
      return true;
    } catch (error) {
      console.log('Share cancelled');
      return false;
    }
  }
  
  // Fallback sharing
  const shareUrls = {
    twitter: `https://twitter.com/intent/tweet?text=${encodeURIComponent(text)}&url=${encodeURIComponent(url)}`,
    facebook: `https://www.facebook.com/sharer/sharer.php?u=${encodeURIComponent(url)}`,
    linkedin: `https://www.linkedin.com/sharing/share-offsite/?url=${encodeURIComponent(url)}`
  };
  
  if (shareUrls[platform]) {
    window.open(shareUrls[platform], '_blank', 'width=600,height=400');
    return true;
  }
  
  // Copy to clipboard fallback
  try {
    await navigator.clipboard.writeText(`${text} ${url}`);
    return true;
  } catch (error) {
    return false;
  }
};
