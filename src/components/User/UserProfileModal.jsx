import React from 'react';
import { X, User, Edit3, Heart, BarChart3, Settings, HelpCircle } from 'lucide-react';
import { useApp } from '../../context/AppContext';
import Modal from '../UI/Modal';
import { getUserInitials, getLevelIcon } from '../../utils/helpers';

const UserProfileModal = () => {
  const { state, actions } = useApp();
  const { userProfile } = state;

  const handleClose = () => {
    actions.setShowUserProfileModal(false);
  };

  const handleMenuAction = (action) => {
    handleClose();
    switch (action) {
      case 'profile':
        actions.addNotification({
          type: 'default',
          message: '🔍 Opening Full Profile View...'
        });
        break;
      case 'edit':
        actions.addNotification({
          type: 'default',
          message: '✏️ Opening Profile Editor...'
        });
        break;
      case 'lists':
        actions.addNotification({
          type: 'default',
          message: '💕 Opening Venue Lists...'
        });
        break;
      case 'activity':
        actions.addNotification({
          type: 'default',
          message: '📊 Opening Activity History...'
        });
        break;
      case 'settings':
        actions.addNotification({
          type: 'default',
          message: '⚙️ Opening Settings...'
        });
        break;
      case 'help':
        actions.addNotification({
          type: 'default',
          message: '🆘 Opening Help & Support...'
        });
        break;
      default:
        break;
    }
  };

  const initials = getUserInitials(userProfile.firstName, userProfile.lastName);
  const levelIcon = getLevelIcon(userProfile.levelTier);

  return (
    <Modal
      isOpen={state.showUserProfileModal}
      onClose={handleClose}
      title="User Profile"
      className="user-profile-modal"
    >
      <div className="user-profile-modal-content">
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
            <div className="profile-stat-label">Ratings</div>
          </div>
          <div className="profile-stat">
            <div className="profile-stat-number">{userProfile.totalFollows}</div>
            <div className="profile-stat-label">Following</div>
          </div>
        </div>

        {/* Menu Items */}
        <div className="profile-modal-menu">
          <button className="profile-menu-item" onClick={() => handleMenuAction('profile')}>
            <User className="profile-menu-icon" />
            <div className="profile-menu-text">
              <span className="profile-menu-title">View Full Profile</span>
              <span className="profile-menu-subtitle">See complete profile details</span>
            </div>
          </button>

          <button className="profile-menu-item" onClick={() => handleMenuAction('edit')}>
            <Edit3 className="profile-menu-icon" />
            <div className="profile-menu-text">
              <span className="profile-menu-title">Update Profile</span>
              <span className="profile-menu-subtitle">Edit your profile information</span>
            </div>
          </button>

          <button className="profile-menu-item" onClick={() => handleMenuAction('lists')}>
            <Heart className="profile-menu-icon" />
            <div className="profile-menu-text">
              <span className="profile-menu-title">My Venue Lists</span>
              <span className="profile-menu-subtitle">Manage your saved venues</span>
            </div>
          </button>

          <button className="profile-menu-item" onClick={() => handleMenuAction('activity')}>
            <BarChart3 className="profile-menu-icon" />
            <div className="profile-menu-text">
              <span className="profile-menu-title">Activity History</span>
              <span className="profile-menu-subtitle">View your platform activity</span>
            </div>
          </button>

          <div className="profile-menu-divider"></div>

          <button className="profile-menu-item" onClick={() => handleMenuAction('settings')}>
            <Settings className="profile-menu-icon" />
            <div className="profile-menu-text">
              <span className="profile-menu-title">Settings</span>
              <span className="profile-menu-subtitle">Account and privacy settings</span>
            </div>
          </button>

          <button className="profile-menu-item" onClick={() => handleMenuAction('help')}>
            <HelpCircle className="profile-menu-icon" />
            <div className="profile-menu-text">
              <span className="profile-menu-title">Help & Support</span>
              <span className="profile-menu-subtitle">Get help and contact support</span>
            </div>
          </button>
        </div>
      </div>
    </Modal>
  );
};

export default UserProfileModal;
