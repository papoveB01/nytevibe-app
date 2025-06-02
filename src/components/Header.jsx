import React, { useState, useEffect } from 'react';
import { Search, X, Menu, Filter } from 'lucide-react';
import UserProfile from './User/UserProfile';

const Header = ({ searchQuery, setSearchQuery, onClearSearch }) => {
  const [showSearch, setShowSearch] = useState(false);
  const [showMenu, setShowMenu] = useState(false);
  const [userLocation, setUserLocation] = useState('Your City');

  // Get user's location
  useEffect(() => {
    const getUserLocation = async () => {
      try {
        if ('geolocation' in navigator) {
          navigator.geolocation.getCurrentPosition(
            async (position) => {
              try {
                // Try to get city name from coordinates
                const response = await fetch(
                  `https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=${position.coords.latitude}&longitude=${position.coords.longitude}&localityLanguage=en`
                );
                const data = await response.json();
                const city = data.city || data.locality || data.principalSubdivision || 'Your City';
                setUserLocation(city);
              } catch (error) {
                // Fallback to default if geocoding fails
                setUserLocation('Your Area');
              }
            },
            (error) => {
              // Handle geolocation errors gracefully
              setUserLocation('Your Area');
            },
            { timeout: 5000, enableHighAccuracy: false }
          );
        }
      } catch (error) {
        setUserLocation('Your Area');
      }
    };

    getUserLocation();
  }, []);

  const handleSearchToggle = () => {
    setShowSearch(!showSearch);
    if (showSearch && searchQuery) {
      onClearSearch();
    }
  };

  return (
    <>
      <header className="mobile-header">
        {/* Main Header Bar */}
        <div className="mobile-header-main">
          <div className="mobile-brand">
            <h1 className="mobile-app-title">nYtevibe</h1>
            <span className="mobile-location">{userLocation}</span>
          </div>
          <div className="mobile-header-actions">
            <button
              className="mobile-icon-button"
              onClick={handleSearchToggle}
              aria-label="Search"
            >
              {showSearch ? <X className="w-5 h-5" /> : <Search className="w-5 h-5" />}
            </button>
            <UserProfile />
          </div>
        </div>

        {/* Expandable Search Bar */}
        {showSearch && (
          <div className="mobile-search-expanded">
            <div className="mobile-search-container">
              <Search className="mobile-search-icon" />
              <input
                type="text"
                placeholder="Search venues, vibes..."
                className="mobile-search-input"
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                autoFocus
              />
              {searchQuery && (
                <button
                  onClick={onClearSearch}
                  className="mobile-search-clear"
                  aria-label="Clear search"
                >
                  <X className="w-4 h-4" />
                </button>
              )}
            </div>
          </div>
        )}
      </header>

      {/* Mobile Bottom Navigation */}
      <nav className="mobile-bottom-nav">
        <div className="mobile-nav-items">
          <button className="mobile-nav-item active">
            <div className="mobile-nav-icon">🏠</div>
            <span className="mobile-nav-label">Discover</span>
          </button>
          <button className="mobile-nav-item">
            <div className="mobile-nav-icon">❤️</div>
            <span className="mobile-nav-label">Following</span>
          </button>
          <button className="mobile-nav-item">
            <div className="mobile-nav-icon">📍</div>
            <span className="mobile-nav-label">Map</span>
          </button>
          <button className="mobile-nav-item">
            <div className="mobile-nav-icon">⭐</div>
            <span className="mobile-nav-label">Reviews</span>
          </button>
        </div>
      </nav>
    </>
  );
};

export default Header;
