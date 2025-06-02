import React from 'react';
import { Heart, Users, TrendingUp } from 'lucide-react';
import { useVenues } from '../../hooks/useVenues';

const FollowStats = ({ venue }) => {
  const { isVenueFollowed } = useVenues();
  const isFollowed = isVenueFollowed(venue.id);

  return (
    <div className="venue-follow-stats">
      <div className={`follow-stat ${isFollowed ? 'you-follow' : ''}`}>
        <Heart className="stat-icon" />
        <span className="stat-number">{venue.followersCount}</span>
        <span className="stat-label">
          {isFollowed ? 'You follow this' : 'Followers'}
        </span>
      </div>
      
      <div className="follow-stat">
        <Users className="stat-icon" />
        <span className="stat-number">{venue.reports}</span>
        <span className="stat-label">Reports</span>
      </div>
      
      <div className="follow-stat">
        <TrendingUp className="stat-icon" />
        <span className="stat-number">{venue.confidence}%</span>
        <span className="stat-label">Accuracy</span>
      </div>
    </div>
  );
};

export default FollowStats;
