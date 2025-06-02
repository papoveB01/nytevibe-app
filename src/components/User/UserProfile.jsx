import React from 'react';
import { ChevronDown } from 'lucide-react';
import { useApp } from '../../context/AppContext';
import { getUserInitials, getLevelIcon } from '../../utils/helpers';

const UserProfile = () => {
  const { state, actions } = useApp();
  const { userProfile } = state;

  const handleProfileClick = () => {
    actions.setShowUserProfileModal(true);
    // Removed notification spam
  };

  const initials = getUserInitials(userProfile);
  const levelIcon = getLevelIcon(userProfile.level);

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
        <ChevronDown className="profile-chevron w-4 h-4" />
      </button>
    </div>
  );
};

export default UserProfile;
