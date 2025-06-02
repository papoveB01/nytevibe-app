import React from 'react';
import { X, User, Star, Trophy, Heart, TrendingUp, Settings, Activity } from 'lucide-react';
import { useApp } from '../../context/AppContext';
import { getUserInitials, getLevelTitle, formatPoints } from '../../utils/helpers';
import LevelIcon from '../UI/LevelIcon';

const UserProfileModal = () => {
  const { state, actions } = useApp();

  if (!state.showUserProfileModal) {
    return null;
  }

  const userProfile = state.userProfile || {};

  const handleClose = () => {
    actions.setShowUserProfileModal(false);
  };

  const handleMenuAction = (action) => {
    actions.addNotification({
      type: 'info',
      message: `🔧 ${action} feature coming soon!`
    });
    handleClose();
  };

  return (
    <div className="modal-overlay" onClick={handleClose}>
      <div className="modal-content user-profile-modal" onClick={(e) => e.stopPropagation()}>
        <div className="modal-header">
          <h3>User Profile</h3>
          <button className="modal-close" onClick={handleClose}>
            <X size={20} />
          </button>
        </div>
        <div className="modal-body">
          {/* Profile Header */}
          <div className="profile-header">
            <div className="profile-avatar">
              {getUserInitials(userProfile)}
            </div>
            <div className="profile-info">
              <h4>{userProfile.firstName} {userProfile.lastName}</h4>
              <p>@{userProfile.username}</p>
              <div className="user-level">
                <LevelIcon level={userProfile.level} size={16} />
                <span>Level {userProfile.level} - {getLevelTitle(userProfile.level)}</span>
              </div>
            </div>
          </div>

          {/* Stats */}
          <div className="profile-stats">
            <div className="stat">
              <div className="stat-number">{formatPoints(userProfile.points || 0)}</div>
              <div className="stat-label">Points</div>
            </div>
            <div className="stat">
              <div className="stat-number">{userProfile.totalReports || 0}</div>
              <div className="stat-label">Reports</div>
            </div>
            <div className="stat">
              <div className="stat-number">{userProfile.totalRatings || 0}</div>
              <div className="stat-label">Reviews</div>
            </div>
            <div className="stat">
              <div className="stat-number">{userProfile.following || 0}</div>
              <div className="stat-label">Following</div>
            </div>
          </div>

          {/* Menu Items */}
          <div className="profile-menu">
            <button className="menu-item" onClick={() => handleMenuAction('Profile Settings')}>
              <User size={16} />
              <span>Profile Settings</span>
            </button>
            <button className="menu-item" onClick={() => handleMenuAction('My Reviews')}>
              <Star size={16} />
              <span>My Reviews</span>
            </button>
            <button className="menu-item" onClick={() => handleMenuAction('Followed Venues')}>
              <Heart size={16} />
              <span>Followed Venues</span>
            </button>
            <button className="menu-item" onClick={() => handleMenuAction('Activity')}>
              <Activity size={16} />
              <span>Activity</span>
            </button>
            <button className="menu-item" onClick={() => handleMenuAction('Settings')}>
              <Settings size={16} />
              <span>Settings</span>
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default UserProfileModal;
