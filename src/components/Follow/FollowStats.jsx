import React from 'react';
import { Users, Heart, TrendingUp } from 'lucide-react';
import { useVenues } from '../../hooks/useVenues';

const FollowStats = ({ venue }) => {
  const { isVenueFollowed } = useVenues();
  const followed = isVenueFollowed(venue.id);

  return (
    <div className="venue-follow-stats">
      <div className="follow-stat">
        <Users className="stat-icon" />
        <span className="stat-number">{venue.followersCount}</span>
        <span className="stat-label">followers</span>
      </div>
      
      <div className="follow-stat">
        <TrendingUp className="stat-icon" />
        <span className="stat-number">{venue.reports}</span>
        <span className="stat-label">reports</span>
      </div>
      
      {followed && (
        <div className="follow-stat you-follow">
          <Heart className="stat-icon" />
          <span className="stat-text">You follow this venue</span>
        </div>
      )}
    </div>
  );
};

export default FollowStats;
