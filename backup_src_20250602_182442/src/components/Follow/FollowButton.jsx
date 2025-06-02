import React from 'react';
import { Heart } from 'lucide-react';
import { useApp } from '../../context/AppContext';

const FollowButton = ({ venue, size = 'md' }) => {
  const { state, actions } = useApp();
  
  if (!venue || !venue.id) {
    return null;
  }

  const isFollowed = state?.userProfile?.followedVenues?.includes(venue.id) || false;

  const handleFollowToggle = (e) => {
    e.stopPropagation();
    
    if (isFollowed) {
      actions.unfollowVenue(venue.id);
      actions.addNotification({
        type: 'default',
        message: `💔 Unfollowed ${venue.name || 'venue'}`
      });
    } else {
      actions.followVenue(venue.id);
      actions.addNotification({
        type: 'success',
        message: `❤️ Following ${venue.name || 'venue'}`
      });
    }
  };

  const getButtonSize = () => {
    switch (size) {
      case 'sm': return { width: '32px', height: '32px', iconSize: 14 };
      case 'md': return { width: '36px', height: '36px', iconSize: 16 };
      case 'lg': return { width: '40px', height: '40px', iconSize: 18 };
      default: return { width: '36px', height: '36px', iconSize: 16 };
    }
  };

  const buttonSize = getButtonSize();

  return (
    <button
      className={`follow-button ${isFollowed ? 'following' : 'not-following'}`}
      onClick={handleFollowToggle}
      title={isFollowed ? 'Unfollow venue' : 'Follow venue'}
      style={{
        width: buttonSize.width,
        height: buttonSize.height,
        borderRadius: '50%',
        border: `2px solid ${isFollowed ? '#ef4444' : '#e5e7eb'}`,
        background: isFollowed ? '#ef4444' : '#f9fafb',
        color: isFollowed ? 'white' : '#6b7280',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        cursor: 'pointer',
        transition: 'all 0.2s ease'
      }}
    >
      <Heart 
        size={buttonSize.iconSize} 
        fill={isFollowed ? 'currentColor' : 'none'}
      />
    </button>
  );
};

export default FollowButton;
