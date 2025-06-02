import React from 'react';
import { 
  X, User, Edit, List, Activity, Settings, HelpCircle, 
  LogOut, Star, MapPin, Users, Heart 
} from 'lucide-react';
import { useApp } from '../../context/AppContext';
import { getUserInitials, getLevelIcon } from '../../utils/helpers';

const UserProfileModal = () => {
  const { state, actions } = useApp();
  const { userProfile, showUserProfileModal } = state;

  if (!showUserProfileModal) return null;

  const handleClose = () => {
    actions.setShowUserProfileModal(false);
  };

  const handleMenuAction = (action) => {
    handleClose();
    
    const messages = {
      profile: '🔍 Opening Full Profile View...',
      edit: '✏️ Opening Profile Editor...',
      lists: '📝 Opening Your Venue Lists...',
      activity: '📊 Opening Activity History...',
      settings: '⚙️ Opening Settings...',
      help: '❓ Opening Help Center...',
      logout: '👋 Logging out...'
    };

    actions.addNotification({
      type: action === 'logout' ? 'info' : 'default',
      message: messages[action] || 'Action selected',
      duration: 3000
    });

    if (action === 'logout') {
      setTimeout(() => {
        actions.logoutUser();
      }, 1000);
    }
  };

  const initials = getUserInitials(userProfile);
  const levelIcon = getLevelIcon(userProfile.level);

  const menuItems = [
    { icon: User, label: 'View Profile', action: 'profile' },
    { icon: Edit, label: 'Edit Profile', action: 'edit' },
    { icon: List, label: 'My Lists', action: 'lists' },
    { icon: Activity, label: 'Activity', action: 'activity' },
    { icon: Settings, label: 'Settings', action: 'settings' },
    { icon: HelpCircle, label: 'Help', action: 'help' },
    { icon: LogOut, label: 'Sign Out', action: 'logout', danger: true }
  ];

  return (
    <div className="modal-overlay" onClick={handleClose}>
      <div className="modal-content user-profile-modal-content" onClick={(e) => e.stopPropagation()}>
        <button
          onClick={handleClose}
          className="modal-close-button"
        >
          <X className="w-5 h-5" />
        </button>

        {/* Profile Header */}
        <div className="profile-modal-header">
          <div className="profile-modal-avatar">
            <div className="modal-avatar-large">{initials}</div>
          </div>
          <div className="profile-modal-info">
            <h3 className="profile-modal-name">
              {userProfile.firstName} {userProfile.lastName}
            </h3>
            <p className="profile-modal-username">@{userProfile.username}</p>
            <div className="profile-modal-level">
              <span className="level-badge-modal">
                {levelIcon} {userProfile.level}
              </span>
            </div>
          </div>
        </div>

        {/* Stats Grid */}
        <div className="profile-modal-stats">
          <div className="profile-stat">
            <div className="profile-stat-number">{userProfile.points.toLocaleString()}</div>
            <div className="profile-stat-label">Points</div>
          </div>
          <div className="profile-stat">
            <div className="profile-stat-number">{userProfile.totalReports}</div>
            <div className="profile-stat-label">Reports</div>
          </div>
          <div className="profile-stat">
            <div className="profile-stat-number">{userProfile.totalRatings}</div>
            <div className="profile-stat-label">Reviews</div>
          </div>
          <div className="profile-stat">
            <div className="profile-stat-number">{userProfile.followingCount}</div>
            <div className="profile-stat-label">Following</div>
          </div>
        </div>

        {/* Menu Items */}
        <div className="profile-modal-menu">
          {menuItems.map((item, index) => (
            <button
              key={index}
              className={`profile-menu-item ${item.danger ? 'danger' : ''}`}
              onClick={() => handleMenuAction(item.action)}
            >
              <item.icon className="w-5 h-5" />
              <span>{item.label}</span>
            </button>
          ))}
        </div>
      </div>
    </div>
  );
};

export default UserProfileModal;
