import React from 'react';
import { Heart, Plus } from 'lucide-react';
import { useVenues } from '../../hooks/useVenues';

const FollowButton = ({ venue, size = 'md', showCount = false }) => {
  const { isVenueFollowed, toggleFollow } = useVenues();
  const followed = isVenueFollowed(venue.id);

  const handleClick = (e) => {
    e.stopPropagation();
    toggleFollow(venue);
  };

  return (
    <button
      onClick={handleClick}
      className={`follow-button ${followed ? 'followed' : ''}`}
      title={followed ? 'Unfollow venue' : 'Follow venue'}
    >
      {followed ? (
        <Heart className="follow-icon filled w-5 h-5" />
      ) : (
        <Plus className="follow-icon outline w-5 h-5" />
      )}
      {showCount && venue.followersCount > 0 && (
        <span className="follow-count">{venue.followersCount}</span>
      )}
    </button>
  );
};

export default FollowButton;
