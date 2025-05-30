import React from 'react';
import { User, Trophy, Star, Heart } from 'lucide-react';
import { useApp } from '../../context/AppContext';
import { getLevelColor, getLevelIcon } from '../../utils/helpers';

const UserProfile = () => {
  const { state } = useApp();
  const { userProfile } = state;

  return (
    <div className="user-profile-header">
      <div className="profile-avatar">
        {userProfile.avatar ? (
          <img src={userProfile.avatar} alt="Profile" className="avatar-image" />
        ) : (
          <div className="avatar-placeholder">
            <User className="w-6 h-6 text-white" />
          </div>
        )}
      </div>
      
      <div className="profile-info">
        <div className="profile-name">
          {userProfile.firstName} {userProfile.lastName}
        </div>
        <div className="profile-level">
          <span className="level-icon">{getLevelIcon(userProfile.levelTier)}</span>
          <span className="level-text" style={{ color: getLevelColor(userProfile.levelTier) }}>
            {userProfile.level}
          </span>
          <span className="points-text">{userProfile.points} pts</span>
        </div>
      </div>
      
      <div className="profile-stats">
        <div className="stat-item">
          <Heart className="w-4 h-4 text-red-500" />
          <span>{userProfile.totalFollows}</span>
        </div>
        <div className="stat-item">
          <Star className="w-4 h-4 text-yellow-500" />
          <span>{userProfile.totalRatings}</span>
        </div>
        <div className="stat-item">
          <Trophy className="w-4 h-4 text-blue-500" />
          <span>{userProfile.totalReports}</span>
        </div>
      </div>
    </div>
  );
};

export default UserProfile;
