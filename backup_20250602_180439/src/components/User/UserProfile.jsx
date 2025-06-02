import React from 'react';
import { useApp } from '../../context/AppContext';
import { getUserInitials } from '../../utils/helpers';
import LevelIcon from '../UI/LevelIcon';

const UserProfile = () => {
  const { state, actions } = useApp();
  const { userProfile } = state;

  const handleProfileClick = () => {
    actions.setShowUserProfileModal(true);
    actions.addNotification({
      type: 'default',
      message: '👤 Opening user profile...'
    });
  };

  return (
    <div className="user-profile-trigger">
      <button
        className="user-profile-button"
        onClick={handleProfileClick}
        title="Open profile menu"
      >
        <div className="user-avatar-trigger">
          {getUserInitials(userProfile)}
        </div>
        <div className="user-info-trigger">
          <div className="user-name-trigger">
            {userProfile.firstName} {userProfile.lastName}
          </div>
          <div className="user-level-trigger">
            <LevelIcon level={userProfile.level} size={12} />
            Level {userProfile.level}
            <span className="points-trigger">
              {userProfile.points?.toLocaleString()} pts
            </span>
          </div>
        </div>
        <svg className="profile-chevron" width="12" height="12" viewBox="0 0 12 12" fill="currentColor">
          <path d="M4 3l4 3-4 3" stroke="currentColor" strokeWidth="1.5" fill="none" strokeLinecap="round" strokeLinejoin="round"/>
        </svg>
      </button>
    </div>
  );
};

export default UserProfile;
