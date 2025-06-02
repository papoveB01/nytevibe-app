import React from 'react';
import { Heart, TrendingUp, Users, Star } from 'lucide-react';
import { useVenues } from '../../hooks/useVenues';

const FollowStats = ({ venue }) => {
  const { isVenueFollowed } = useVenues();
  const isFollowed = isVenueFollowed(venue.id);

  const stats = [
    {
      icon: Heart,
      label: 'Followers',
      value: venue.followersCount,
      color: 'text-red-500'
    },
    {
      icon: Star,
      label: 'Rating',
      value: venue.rating.toFixed(1),
      color: 'text-yellow-500'
    },
    {
      icon: Users,
      label: 'Reviews',
      value: venue.totalRatings,
      color: 'text-blue-500'
    },
    {
      icon: TrendingUp,
      label: 'Reports',
      value: venue.reports,
      color: 'text-green-500'
    }
  ];

  return (
    <div className="follow-stats">
      <div className="stats-grid">
        {stats.map((stat, index) => (
          <div key={index} className="stat-item">
            <div className={`stat-icon ${stat.color}`}>
              <stat.icon className="w-4 h-4" />
            </div>
            <div className="stat-content">
              <span className="stat-value">{stat.value}</span>
              <span className="stat-label">{stat.label}</span>
            </div>
          </div>
        ))}
      </div>
      
      {isFollowed && (
        <div className="following-indicator">
          <Heart className="w-3 h-3 text-red-500 fill-current" />
          <span>You follow this venue</span>
        </div>
      )}
    </div>
  );
};

export default FollowStats;
