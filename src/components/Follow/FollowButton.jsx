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
