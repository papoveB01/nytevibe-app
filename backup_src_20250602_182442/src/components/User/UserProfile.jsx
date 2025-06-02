import React from 'react';
import { useApp } from '../../context/AppContext';
import { getUserInitials, getLevelIcon } from '../../utils/helpers';

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

  const initials = getUserInitials(userProfile.firstName, userProfile.lastName);
  const levelIcon = getLevelIcon(userProfile.levelTier);

  return (
    <div className="user-profile-trigger">
      <button
        className="user-profile-button"
        onClick={handleProfileClick}
        title="Open profile menu"
      >
        <div className="user-avatar-trigger">{initials}</div>
        <div className="user-info-trigger">
          <div className="user-name-trigger">
            {userProfile.firstName} {userProfile.lastName}
          </div>
          <div className="user-level-trigger">
            {levelIcon} {userProfile.level}
            <span className="points-trigger">{userProfile.points.toLocaleString()}</span>
          </div>
        </div>
        <svg className="profile-chevron" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M19 9l-7 7-7-7"/>
        </svg>
      </button>
    </div>
  );
};

export default UserProfile;
