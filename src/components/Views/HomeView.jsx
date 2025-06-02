import React, { useState, useRef, useEffect } from 'react';
import { Filter, MapPin, Users, Clock, TrendingUp, ChevronRight } from 'lucide-react';
import { useVenues } from '../../hooks/useVenues';
import VenueCard from '../Venue/VenueCard';

const HomeView = ({ onVenueSelect }) => {
  const { venues } = useVenues();
  const [activeFilter, setActiveFilter] = useState('all');
  const [showFilters, setShowFilters] = useState(false);
  const [userLocation, setUserLocation] = useState('your area');
  const filterScrollRef = useRef(null);

  // Get user's location for personalized greeting
  useEffect(() => {
    const getUserLocation = async () => {
      try {
        if ('geolocation' in navigator) {
          navigator.geolocation.getCurrentPosition(
            async (position) => {
              try {
                const response = await fetch(
                  `https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=${position.coords.latitude}&longitude=${position.coords.longitude}&localityLanguage=en`
                );
                const data = await response.json();
                const city = data.city || data.locality || data.principalSubdivision || 'your area';
                setUserLocation(city);
              } catch (error) {
                setUserLocation('your area');
              }
            },
            (error) => {
              setUserLocation('your area');
            },
            { timeout: 5000, enableHighAccuracy: false }
          );
        }
      } catch (error) {
        setUserLocation('your area');
      }
    };

    getUserLocation();
  }, []);

  const filters = [
    { id: 'all', label: 'All', icon: MapPin, color: '#3b82f6' },
    { id: 'busy', label: 'Busy', icon: Users, color: '#ef4444' },
    { id: 'quick', label: 'No Wait', icon: Clock, color: '#10b981' },
    { id: 'trending', label: 'Trending', icon: TrendingUp, color: '#8b5cf6' }
  ];

  const filteredVenues = venues.filter(venue => {
    switch (activeFilter) {
      case 'busy':
        return venue.crowdLevel >= 70;
      case 'quick':
        return venue.waitTime === 0;
      case 'trending':
        return venue.followersCount > 1000;
      default:
        return true;
    }
  });

  const promotionalVenues = venues.filter(venue => venue.hasPromotion);

  // Mobile pull-to-refresh simulation
  const [isRefreshing, setIsRefreshing] = useState(false);
  const handleRefresh = () => {
    setIsRefreshing(true);
    setTimeout(() => setIsRefreshing(false), 1500);
  };

  return (
    <div className="mobile-home-view">
      {/* Mobile Hero Section */}
      <div className="mobile-hero">
        <div className="mobile-greeting">
          <h2 className="mobile-greeting-text">Discover Tonight</h2>
          <p className="mobile-greeting-subtitle">What's happening in {userLocation}</p>
        </div>

        {isRefreshing && (
          <div className="mobile-refresh-indicator">
            <div className="refresh-spinner"></div>
            <span>Updating venues...</span>
          </div>
        )}
      </div>

      {/* Quick Stats Bar */}
      <div className="mobile-stats-bar">
        <div className="mobile-stat">
          <span className="mobile-stat-number">{venues.length}</span>
          <span className="mobile-stat-label">Venues</span>
        </div>
        <div className="mobile-stat">
          <span className="mobile-stat-number">{promotionalVenues.length}</span>
          <span className="mobile-stat-label">Deals</span>
        </div>
        <div className="mobile-stat">
          <span className="mobile-stat-number">{venues.filter(v => v.waitTime === 0).length}</span>
          <span className="mobile-stat-label">No Wait</span>
        </div>
        <div className="mobile-stat">
          <span className="mobile-stat-number">{venues.filter(v => v.crowdLevel >= 70).length}</span>
          <span className="mobile-stat-label">Busy</span>
        </div>
      </div>

      {/* Mobile Filter Chips */}
      <div className="mobile-filters-section">
        <div className="mobile-filters-header">
          <h3 className="mobile-section-title">Filter by</h3>
          <button
            className="mobile-filter-toggle"
            onClick={() => setShowFilters(!showFilters)}
          >
            <Filter className="w-4 h-4" />
          </button>
        </div>

        <div className="mobile-filters-scroll" ref={filterScrollRef}>
          {filters.map(filter => (
            <button
              key={filter.id}
              onClick={() => setActiveFilter(filter.id)}
              className={`mobile-filter-chip ${activeFilter === filter.id ? 'active' : ''}`}
              style={{
                '--filter-color': filter.color
              }}
            >
              <filter.icon className="mobile-filter-icon" />
              <span className="mobile-filter-label">{filter.label}</span>
              {activeFilter === filter.id && (
                <div className="mobile-filter-count">
                  {filter.id === 'all' ? venues.length : filteredVenues.length}
                </div>
              )}
            </button>
          ))}
        </div>
      </div>

      {/* Promotional Carousel */}
      {promotionalVenues.length > 0 && (
        <div className="mobile-promos-section">
          <div className="mobile-section-header">
            <h3 className="mobile-section-title">🎉 Special Deals</h3>
            <button className="mobile-see-all">
              See All <ChevronRight className="w-4 h-4" />
            </button>
          </div>

          <div className="mobile-promos-scroll">
            {promotionalVenues.map(venue => (
              <div
                key={venue.id}
                className="mobile-promo-card"
                onClick={() => onVenueSelect(venue)}
              >
                <div className="mobile-promo-badge">DEAL</div>
                <div className="mobile-promo-content">
                  <h4 className="mobile-promo-title">{venue.name}</h4>
                  <p className="mobile-promo-text">{venue.promotionText}</p>
                  <div className="mobile-promo-cta">View Deal</div>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Mobile Venues Feed */}
      <div className="mobile-venues-section">
        <div className="mobile-section-header">
          <h3 className="mobile-section-title">
            {activeFilter === 'all' ? 'All Venues' : filters.find(f => f.id === activeFilter)?.label}
          </h3>
          <div className="mobile-venues-count">
            {filteredVenues.length} venues
          </div>
        </div>

        <div className="mobile-venues-feed">
          {filteredVenues.map(venue => (
            <VenueCard
              key={venue.id}
              venue={venue}
              onClick={() => onVenueSelect(venue)}
              mobileLayout={true}
            />
          ))}

          {filteredVenues.length === 0 && (
            <div className="mobile-empty-state">
              <div className="mobile-empty-icon">🔍</div>
              <h3 className="mobile-empty-title">No venues found</h3>
              <p className="mobile-empty-description">
                Try a different filter or check back later
              </p>
              <button
                className="mobile-empty-action"
                onClick={() => setActiveFilter('all')}
              >
                Show All Venues
              </button>
            </div>
          )}
        </div>
      </div>

      {/* Pull to refresh area */}
      <div
        className="mobile-pull-refresh"
        onTouchStart={handleRefresh}
      >
        <span>Pull to refresh</span>
      </div>
    </div>
  );
};

export default HomeView;
