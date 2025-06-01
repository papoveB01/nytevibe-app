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
