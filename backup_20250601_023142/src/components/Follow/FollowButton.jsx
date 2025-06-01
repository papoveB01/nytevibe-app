import React from 'react';
import { Heart } from 'lucide-react';
import { useVenues } from '../../hooks/useVenues';

const FollowButton = ({ venue, size = 'md', showCount = false }) => {
  const { isVenueFollowed, toggleFollow } = useVenues();
  const isFollowed = isVenueFollowed(venue.id);

  const handleClick = (e) => {
    e.stopPropagation();
    toggleFollow(venue);
  };

  const sizeClasses = {
    sm: 'w-8 h-8',
    md: 'w-10 h-10',
    lg: 'w-12 h-12'
  };

  const iconSizes = {
    sm: 'w-3 h-3',
    md: 'w-4 h-4',
    lg: 'w-5 h-5'
  };

  return (
    <button
      onClick={handleClick}
      className={`follow-button ${isFollowed ? 'followed' : ''} ${sizeClasses[size]}`}
      title={isFollowed ? `Unfollow ${venue.name}` : `Follow ${venue.name}`}
    >
      <Heart className={`follow-icon ${isFollowed ? 'filled' : 'outline'} ${iconSizes[size]}`} />
      {showCount && (
        <span className="follow-count">{venue.followersCount}</span>
      )}
    </button>
  );
};

export default FollowButton;
