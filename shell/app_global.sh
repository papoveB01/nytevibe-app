#!/bin/bash

# nYtevibe Globalize App Script
# Updates Houston-specific content to global, location-aware content

echo "🌍 nYtevibe Globalization Update"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔄 Converting from Houston-specific to global service..."
echo ""

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    echo "❌ Error: package.json not found. Please run this script from your React project directory."
    exit 1
fi

# Create backups
echo "💾 Creating backups..."
cp src/components/Header.jsx src/components/Header.jsx.backup-globalize
cp src/components/Views/LoginView.jsx src/components/Views/LoginView.jsx.backup-globalize
cp src/components/Views/HomeView.jsx src/components/Views/HomeView.jsx.backup-globalize
cp src/context/AppContext.jsx src/context/AppContext.jsx.backup-globalize

# Update Header to be location-aware
echo "📍 Updating Header for global location awareness..."

cat > src/components/Header.jsx << 'EOF'
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
EOF

# Update LoginView for global context
echo "🌐 Updating LoginView for global appeal..."

cat > src/components/Views/LoginView.jsx << 'EOF'
import React, { useState } from 'react';
import { Eye, EyeOff, User, Lock, Zap, Star, Clock, Users } from 'lucide-react';

const LoginView = ({ onLogin }) => {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [error, setError] = useState('');
  const [isLoading, setIsLoading] = useState(false);

  const demoCredentials = {
    username: 'demouser',
    password: 'demopass'
  };

  const fillDemoCredentials = () => {
    setUsername(demoCredentials.username);
    setPassword(demoCredentials.password);
    setError('');
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setIsLoading(true);

    // Simulate realistic API call delay
    setTimeout(() => {
      if (username === demoCredentials.username && password === demoCredentials.password) {
        onLogin({
          id: 'usr_demo',
          username: username,
          firstName: 'Demo',
          lastName: 'User'
        });
      } else {
        setError('Invalid username or password. Try: demouser / demopass');
      }
      setIsLoading(false);
    }, 1000);
  };

  const features = [
    { icon: Star, text: "Rate and review the hottest venues worldwide" },
    { icon: Clock, text: "Get real-time crowd levels and wait times" },
    { icon: Users, text: "Connect with fellow nightlife enthusiasts globally" },
    { icon: Zap, text: "Discover trending spots in your city and beyond" }
  ];

  return (
    <div className="login-page">
      <div className="login-background">
        <div className="login-gradient"></div>
      </div>
      
      <div className="login-container">
        <div className="login-card">
          <div className="login-card-header">
            <div className="login-logo">
              <div className="logo-icon">
                <Zap className="w-10 h-10 text-white" />
              </div>
              <h2 className="login-title">Welcome to nYtevibe</h2>
              <p className="login-subtitle">Global Nightlife Discovery Platform</p>
            </div>
          </div>

          <div className="demo-banner">
            <div className="demo-content">
              <div className="demo-info">
                <h4 className="demo-title">Demo Account Available</h4>
                <p className="demo-description">
                  Try nYtevibe with our demo account. Click below to auto-fill credentials.
                </p>
              </div>
              <button
                type="button"
                onClick={fillDemoCredentials}
                className="demo-fill-button"
              >
                Fill Demo
              </button>
            </div>
          </div>

          <form onSubmit={handleSubmit} className="login-form">
            {error && (
              <div className="error-banner">
                <span className="error-icon">⚠️</span>
                <span className="error-text">{error}</span>
              </div>
            )}

            <div className="form-group">
              <label htmlFor="username" className="form-label">Username</label>
              <div className="input-wrapper">
                <User className="input-icon" />
                <input
                  id="username"
                  type="text"
                  value={username}
                  onChange={(e) => setUsername(e.target.value)}
                  className="form-input"
                  placeholder="Enter your username"
                  required
                />
              </div>
            </div>

            <div className="form-group">
              <label htmlFor="password" className="form-label">Password</label>
              <div className="input-wrapper">
                <Lock className="input-icon" />
                <input
                  id="password"
                  type={showPassword ? 'text' : 'password'}
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  className="form-input"
                  placeholder="Enter your password"
                  required
                />
                <button
                  type="button"
                  onClick={() => setShowPassword(!showPassword)}
                  className="password-toggle"
                >
                  {showPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                </button>
              </div>
            </div>

            <button
              type="submit"
              disabled={isLoading}
              className={`login-button ${isLoading ? 'loading' : ''}`}
            >
              {isLoading ? (
                <>
                  <div className="loading-spinner"></div>
                  Signing In...
                </>
              ) : (
                <>
                  <User className="w-4 h-4" />
                  Enter nYtevibe
                </>
              )}
            </button>
          </form>

          <div className="login-card-footer">
            <p className="footer-text">
              New to nYtevibe?{' '}
              <button className="footer-link">Create Account</button>
            </p>
          </div>
        </div>

        <div className="login-features">
          <h3 className="features-title">Discover Nightlife Worldwide</h3>
          <ul className="features-list">
            {features.map((feature, index) => (
              <li key={index} className="feature-item">
                <feature.icon className="w-4 h-4 text-blue-400" />
                <span>{feature.text}</span>
              </li>
            ))}
          </ul>
          
          <div className="platform-stats">
            <div className="stat-highlight">
              <span className="stat-number">10K+</span>
              <span className="stat-label">Venues</span>
            </div>
            <div className="stat-highlight">
              <span className="stat-number">50K+</span>
              <span className="stat-label">Users</span>
            </div>
            <div className="stat-highlight">
              <span className="stat-number">200+</span>
              <span className="stat-label">Cities</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default LoginView;
EOF

# Update HomeView for location-aware content
echo "🏠 Updating HomeView for global context..."

cat > src/components/Views/HomeView.jsx << 'EOF'
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
EOF

# Update AppContext with global demo data
echo "🗂️ Updating AppContext with global demo data..."

cat > src/context/AppContext.jsx << 'EOF'
import React, { createContext, useContext, useReducer, useCallback } from 'react';

const AppContext = createContext();

const initialState = {
  // Navigation
  currentView: 'login',
  searchQuery: '',
  
  // Authentication
  userType: null,
  isAuthenticated: false,
  authenticatedUser: null,
  
  // Modals
  showRatingModal: false,
  showReportModal: false,
  showShareModal: false,
  showUserProfileModal: false,
  selectedVenue: null,
  shareVenue: null,
  
  // User Profile
  userProfile: {
    id: 'usr_demo',
    firstName: 'Demo',
    lastName: 'User',
    username: 'demouser',
    email: 'demo@nytevibe.com',
    level: 'Explorer',
    points: 2847,
    joinDate: 'March 2024',
    totalReports: 23,
    totalRatings: 15,
    followingCount: 42,
    followersCount: 67,
    venueListsCount: 8,
    favoriteVenues: []
  },
  
  // Venues Data - Global Demo Venues
  venues: [
    {
      id: 'venue_1',
      name: 'SkyBar Downtown',
      type: 'Rooftop Lounge',
      address: '1600 Main St, Downtown',
      phone: '(555) 123-0123',
      hours: '5:00 PM - 2:00 AM',
      rating: 4.5,
      totalRatings: 289,
      ratingBreakdown: { 5: 180, 4: 65, 3: 30, 2: 10, 1: 4 },
      crowdLevel: 75,
      waitTime: 15,
      lastUpdate: '2 min ago',
      confidence: 95,
      followersCount: 1247,
      reports: 89,
      vibe: ['Upscale', 'City Views', 'Cocktails', 'Date Night'],
      hasPromotion: true,
      promotionText: 'Happy Hour: 50% off craft cocktails until 7 PM!',
      reviews: [
        {
          id: 'review_1',
          user: 'Sarah M.',
          rating: 5,
          date: '2 days ago',
          comment: 'Amazing rooftop views of the city! The cocktails are expertly crafted and the atmosphere is perfect for a special night out.',
          helpful: 12
        },
        {
          id: 'review_2',
          user: 'Mike R.',
          rating: 4,
          date: '1 week ago',
          comment: 'Great spot for drinks with friends. Can get busy on weekends but the view makes it worth the wait.',
          helpful: 8
        },
        {
          id: 'review_3',
          user: 'Jennifer L.',
          rating: 5,
          date: '2 weeks ago',
          comment: 'Perfect for a date night! Staff is attentive and the sunset views are breathtaking.',
          helpful: 15
        }
      ]
    },
    {
      id: 'venue_2',
      name: 'The Underground',
      type: 'Dance Club',
      address: '2314 Nightlife District',
      phone: '(555) 123-0456',
      hours: '9:00 PM - 3:00 AM',
      rating: 4.2,
      totalRatings: 567,
      ratingBreakdown: { 5: 280, 4: 150, 3: 90, 2: 35, 1: 12 },
      crowdLevel: 90,
      waitTime: 25,
      lastUpdate: '1 min ago',
      confidence: 92,
      followersCount: 2156,
      reports: 156,
      vibe: ['Electronic', 'High Energy', 'Late Night', 'Dancing'],
      hasPromotion: false,
      promotionText: '',
      reviews: [
        {
          id: 'review_4',
          user: 'Alex T.',
          rating: 5,
          date: '3 days ago',
          comment: 'Best EDM club in the city! Sound system is incredible and the DJs always bring the energy.',
          helpful: 24
        },
        {
          id: 'review_5',
          user: 'Maria G.',
          rating: 4,
          date: '1 week ago',
          comment: 'Love the underground vibe! Gets very crowded but that adds to the energy.',
          helpful: 18
        }
      ]
    },
    {
      id: 'venue_3',
      name: 'Whiskey & Wine',
      type: 'Bar & Grill',
      address: '4201 Entertainment Ave',
      phone: '(555) 123-0789',
      hours: '4:00 PM - 12:00 AM',
      rating: 4.3,
      totalRatings: 423,
      ratingBreakdown: { 5: 200, 4: 120, 3: 70, 2: 25, 1: 8 },
      crowdLevel: 45,
      waitTime: 0,
      lastUpdate: '5 min ago',
      confidence: 88,
      followersCount: 892,
      reports: 67,
      vibe: ['Casual', 'Sports Bar', 'Craft Beer', 'Wings'],
      hasPromotion: true,
      promotionText: 'Monday Night Football: $0.50 wings and $3 beer specials!',
      reviews: [
        {
          id: 'review_6',
          user: 'Chris P.',
          rating: 4,
          date: '1 day ago',
          comment: 'Great place to watch the game with friends. Wings are delicious and beer selection is solid.',
          helpful: 9
        }
      ]
    },
    {
      id: 'venue_4',
      name: 'Luna Tapas',
      type: 'Wine Bar',
      address: '1953 Cultural District',
      phone: '(555) 123-0321',
      hours: '5:00 PM - 11:00 PM',
      rating: 4.7,
      totalRatings: 198,
      ratingBreakdown: { 5: 140, 4: 35, 3: 15, 2: 6, 1: 2 },
      crowdLevel: 35,
      waitTime: 0,
      lastUpdate: '3 min ago',
      confidence: 91,
      followersCount: 578,
      reports: 34,
      vibe: ['Intimate', 'Wine Selection', 'Small Plates', 'Romantic'],
      hasPromotion: false,
      promotionText: '',
      reviews: [
        {
          id: 'review_7',
          user: 'Diana K.',
          rating: 5,
          date: '4 days ago',
          comment: 'Cozy atmosphere with an excellent wine selection. Perfect for a quiet evening.',
          helpful: 14
        }
      ]
    },
    {
      id: 'venue_5',
      name: 'Neon Nights',
      type: 'Karaoke Lounge',
      address: '3847 Music Row',
      phone: '(555) 123-0654',
      hours: '7:00 PM - 2:00 AM',
      rating: 4.1,
      totalRatings: 334,
      ratingBreakdown: { 5: 150, 4: 100, 3: 60, 2: 20, 1: 4 },
      crowdLevel: 60,
      waitTime: 10,
      lastUpdate: '4 min ago',
      confidence: 87,
      followersCount: 743,
      reports: 78,
      vibe: ['Karaoke', 'Fun', 'Group Friendly', 'Themed Drinks'],
      hasPromotion: true,
      promotionText: 'Karaoke Competition Tonight: Winner gets $100 bar tab!',
      reviews: [
        {
          id: 'review_8',
          user: 'Tommy L.',
          rating: 4,
          date: '2 days ago',
          comment: 'So much fun! Private rooms are great for groups and the song selection is huge.',
          helpful: 11
        }
      ]
    }
  ],
  
  // Notifications
  notifications: []
};

const appReducer = (state, action) => {
  switch (action.type) {
    case 'SET_CURRENT_VIEW':
      return { ...state, currentView: action.payload };
    
    case 'SET_SEARCH_QUERY':
      return { ...state, searchQuery: action.payload };
    
    case 'SET_USER_TYPE':
      return { ...state, userType: action.payload };
    
    case 'LOGIN_SUCCESS':
      return {
        ...state,
        isAuthenticated: true,
        authenticatedUser: action.payload,
        currentView: 'home'
      };
    
    case 'LOGOUT':
      return {
        ...state,
        isAuthenticated: false,
        authenticatedUser: null,
        currentView: 'login',
        userType: null
      };
    
    case 'SET_SHOW_RATING_MODAL':
      return { ...state, showRatingModal: action.payload };
    
    case 'SET_SHOW_REPORT_MODAL':
      return { ...state, showReportModal: action.payload };
    
    case 'SET_SHOW_SHARE_MODAL':
      return { ...state, showShareModal: action.payload };
    
    case 'SET_SHOW_USER_PROFILE_MODAL':
      return { ...state, showUserProfileModal: action.payload };
    
    case 'SET_SELECTED_VENUE':
      return { ...state, selectedVenue: action.payload };
    
    case 'SET_SHARE_VENUE':
      return { ...state, shareVenue: action.payload };
    
    case 'ADD_NOTIFICATION':
      const newNotification = {
        id: Date.now(),
        ...action.payload,
        timestamp: new Date().toISOString()
      };
      return {
        ...state,
        notifications: [newNotification, ...state.notifications.slice(0, 4)]
      };
    
    case 'REMOVE_NOTIFICATION':
      return {
        ...state,
        notifications: state.notifications.filter(n => n.id !== action.payload)
      };
    
    case 'TOGGLE_VENUE_FOLLOW':
      const venueId = action.payload;
      const isCurrentlyFollowed = state.userProfile.favoriteVenues.includes(venueId);
      const updatedFavorites = isCurrentlyFollowed
        ? state.userProfile.favoriteVenues.filter(id => id !== venueId)
        : [...state.userProfile.favoriteVenues, venueId];
      
      return {
        ...state,
        userProfile: {
          ...state.userProfile,
          favoriteVenues: updatedFavorites
        },
        venues: state.venues.map(venue =>
          venue.id === venueId
            ? {
                ...venue,
                followersCount: isCurrentlyFollowed
                  ? venue.followersCount - 1
                  : venue.followersCount + 1
              }
            : venue
        )
      };
    
    case 'UPDATE_VENUE_DATA':
      return {
        ...state,
        venues: state.venues.map(venue => ({
          ...venue,
          crowdLevel: Math.max(10, Math.min(100, venue.crowdLevel + (Math.random() - 0.5) * 20)),
          waitTime: Math.max(0, venue.waitTime + Math.floor((Math.random() - 0.5) * 10)),
          lastUpdate: 'Just now',
          confidence: Math.max(75, Math.min(98, venue.confidence + (Math.random() - 0.5) * 10))
        }))
      };
    
    default:
      return state;
  }
};

export const AppProvider = ({ children }) => {
  const [state, dispatch] = useReducer(appReducer, initialState);
  
  const actions = {
    setCurrentView: useCallback((view) => {
      dispatch({ type: 'SET_CURRENT_VIEW', payload: view });
    }, []),
    
    setSearchQuery: useCallback((query) => {
      dispatch({ type: 'SET_SEARCH_QUERY', payload: query });
    }, []),
    
    setUserType: useCallback((userType) => {
      dispatch({ type: 'SET_USER_TYPE', payload: userType });
    }, []),
    
    loginUser: useCallback((userData) => {
      dispatch({ type: 'LOGIN_SUCCESS', payload: userData });
    }, []),
    
    logoutUser: useCallback(() => {
      dispatch({ type: 'LOGOUT' });
    }, []),
    
    setShowRatingModal: useCallback((show) => {
      dispatch({ type: 'SET_SHOW_RATING_MODAL', payload: show });
    }, []),
    
    setShowReportModal: useCallback((show) => {
      dispatch({ type: 'SET_SHOW_REPORT_MODAL', payload: show });
    }, []),
    
    setShowShareModal: useCallback((show) => {
      dispatch({ type: 'SET_SHOW_SHARE_MODAL', payload: show });
    }, []),
    
    setShowUserProfileModal: useCallback((show) => {
      dispatch({ type: 'SET_SHOW_USER_PROFILE_MODAL', payload: show });
    }, []),
    
    setSelectedVenue: useCallback((venue) => {
      dispatch({ type: 'SET_SELECTED_VENUE', payload: venue });
    }, []),
    
    setShareVenue: useCallback((venue) => {
      dispatch({ type: 'SET_SHARE_VENUE', payload: venue });
    }, []),
    
    addNotification: useCallback((notification) => {
      dispatch({ type: 'ADD_NOTIFICATION', payload: notification });
    }, []),
    
    removeNotification: useCallback((id) => {
      dispatch({ type: 'REMOVE_NOTIFICATION', payload: id });
    }, []),
    
    toggleVenueFollow: useCallback((venueId) => {
      dispatch({ type: 'TOGGLE_VENUE_FOLLOW', payload: venueId });
    }, []),
    
    updateVenueData: useCallback(() => {
      dispatch({ type: 'UPDATE_VENUE_DATA' });
    }, [])
  };
  
  return (
    <AppContext.Provider value={{ state, actions }}>
      {children}
    </AppContext.Provider>
  );
};

export const useApp = () => {
  const context = useContext(AppContext);
  if (!context) {
    throw new Error('useApp must be used within an AppProvider');
  }
  return context;
};
EOF

# Update the setup script comments to reflect global nature
echo "📝 Updating setup script comments..."

if [ -f "restore_app.sh" ]; then
    sed -i.bak 's/Houston.s Premier Nightlife Discovery Platform/Global Nightlife Discovery Platform/g' restore_app.sh
    sed -i.bak 's/Houston nightlife/global nightlife/g' restore_app.sh
    sed -i.bak 's/Setting up Houston.s Premier/Setting up Global/g' restore_app.sh
    rm -f restore_app.sh.bak
    echo "   ✅ Updated setup script descriptions"
else
    echo "   ℹ️ Setup script not found (may be in different location)"
fi

echo ""
echo "✅ Globalization Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🌍 Global Updates Applied:"
echo "   ✅ Header now shows user's detected location"
echo "   ✅ Login page updated with global messaging"
echo "   ✅ Platform stats updated for global scale"
echo "   ✅ HomeView greeting uses user's location"
echo "   ✅ Demo venue data made location-generic"
echo "   ✅ All 'Houston' references updated to global context"
echo "   ✅ Feature descriptions updated for worldwide appeal"
echo ""
echo "📍 Location Features Added:"
echo "   • Automatic location detection using geolocation API"
echo "   • Fallback to 'Your Area' if location unavailable"
echo "   • Dynamic city name in header and greetings"
echo "   • Privacy-friendly location handling"
echo ""
echo "🌐 Global Content Changes:"
echo "   • 'Houston's Premier' → 'Global Nightlife Discovery Platform'"
echo "   • '50+ Venues' → '10K+ Venues' (global scale)"
echo "   • '1K+ Users' → '50K+ Users' (global scale)"
echo "   • Added '200+ Cities' stat"
echo "   • Demo venues use generic addresses"
echo ""
echo "🔧 Technical Enhancements:"
echo "   • Geolocation API integration"
echo "   • Reverse geocoding for city names"
echo "   • Error handling for location services"
echo "   • Timeout and fallback mechanisms"
echo ""
echo "📱 User Experience:"
echo "   • Personalized location-based greetings"
echo "   • Global platform messaging"
echo "   • Worldwide appeal in feature descriptions"
echo "   • Maintained all existing functionality"
echo ""
echo "🔧 To test the changes:"
echo "   npm run dev"
echo "   Grant location permission when prompted"
echo "   Notice personalized location in header"
echo "   Check global messaging throughout app"
echo ""
echo "Status: 🟢 GLOBAL NIGHTLIFE PLATFORM READY"
