# React Application Source Code Analysis

**Generated on:** Tue 03 Jun 2025 08:45:07 PM UTC  
**Project Directory:** `.`  
**Focus:** Application source code and structure only  

## Table of Contents
1. [Application Structure Overview](#application-structure-overview)
2. [Main Entry Points](#main-entry-points)
3. [React Components](#react-components)
4. [Pages & Views](#pages--views)
5. [Custom Hooks](#custom-hooks)
6. [Utilities & Helpers](#utilities--helpers)
7. [Services & API](#services--api)
8. [State Management](#state-management)
9. [Styles & UI](#styles--ui)
10. [Assets & Resources](#assets--resources)
11. [Application Architecture Summary](#application-architecture-summary)

---

## Application Structure Overview

Complete source code structure of the React application.

### Source Directory Structure

**src/ directory:**
```
src/App.css
src/App.jsx
src/components/Auth/EmailVerificationView.jsx
src/components/Follow/FollowButton.jsx
src/components/Follow/FollowStats.jsx
src/components/Header.jsx
src/components/Layout/Header.jsx
src/components/Layout/PromotionalBanner.jsx
src/components/Layout/SearchBar.jsx
src/components/Modals/RatingModal.jsx
src/components/Modals/ReportModal.jsx
src/components/Modals/ShareModal.jsx
src/components/NetworkStatus.jsx
src/components/Notifications.jsx
src/components/Registration/RegistrationView.jsx
src/components/ServerStatus.jsx
src/components/Social/ShareModal.jsx
src/components/UI/Badge.jsx
src/components/UI/Button.jsx
src/components/UI/Modal.jsx
src/components/User/UserProfile.jsx
src/components/User/UserProfileModal.jsx
src/components/Venue/RatingModal.jsx
src/components/Venue/ReportModal.jsx
src/components/Venue/StarRating.jsx
src/components/Venue/VenueCard.jsx
src/components/Views/HomeView.jsx
src/components/Views/LoginView.jsx
src/components/Views/VenueDetailsView.jsx
src/constants/index.js
src/context/AppContext.jsx
src/hooks/useAI.js
src/hooks/useNotifications.js
src/hooks/useVenues.js
src/main.jsx
src/services/registrationAPI.js
src/utils/healthCheckTest.js
src/utils/helpers.js
src/utils/registrationValidation.js
```

### File Statistics
| File Type | Count |
|-----------|-------|
| JavaScript (.js) | 50 |
| JSX (.jsx) | 150 |
| TypeScript (.ts) | 0 |
| TSX (.tsx) | 0 |
| CSS (.css) | 19 |
| SCSS (.scss) | 0 |
| **Total Source Files** | **219** |

## Main Entry Points

Application entry points and main files.

### Entry Point: main.jsx

**Path:** `src/main.jsx`
**Size:** 214 bytes

```javascript
import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App.jsx'

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
)
```

---

### Entry Point: App.jsx

**Path:** `src/App.jsx`
**Size:** 4969 bytes

```javascript
import React, { useState, useEffect } from 'react';
import { AppProvider, useApp } from './context/AppContext';
import { useVenues } from './hooks/useVenues';

// Views
import LoginView from './components/Views/LoginView';
import HomeView from './components/Views/HomeView';
import VenueDetailsView from './components/Views/VenueDetailsView';
import RegistrationView from './components/Registration/RegistrationView';
import EmailVerificationView from './components/Auth/EmailVerificationView';

// Components
import Header from './components/Header';
import Notifications from './components/Notifications';

// Modals
import RatingModal from './components/Modals/RatingModal';
import ReportModal from './components/Modals/ReportModal';
import ShareModal from './components/Modals/ShareModal';
import UserProfileModal from './components/User/UserProfileModal';

import './App.css';

function AppContent() {
const { state, actions } = useApp();
const { updateVenueData } = useVenues();
const [searchQuery, setSearchQuery] = useState('');
const [isMobile, setIsMobile] = useState(false);

// Mobile detection
useEffect(() => {
const checkMobile = () => {
const mobile = window.innerWidth <= 768 ||
/Android|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
setIsMobile(mobile);
};

checkMobile();
window.addEventListener('resize', checkMobile);
return () => window.removeEventListener('resize', checkMobile);
}, []);

// Handle email verification from URL
useEffect(() => {
const urlParams = new URLSearchParams(window.location.search);
const verificationToken = urlParams.get('token');
const verifyEmail = urlParams.get('verify');

if (verificationToken && verifyEmail) {
actions.setCurrentView('email-verification');
// Clean up URL
window.history.replaceState({}, document.title, window.location.pathname);
}
}, [actions]);

// Update search query in context
useEffect(() => {
actions.setSearchQuery(searchQuery);
}, [searchQuery, actions]);

// Auto-update venue data periodically when authenticated
useEffect(() => {
if (state.isAuthenticated && !['login', 'register', 'email-verification'].includes(state.currentView)) {
const interval = setInterval(() => {
updateVenueData();
}, 45000);

return () => clearInterval(interval);
}
}, [updateVenueData, state.currentView, state.isAuthenticated]);

// Initialize app to login view if not authenticated
useEffect(() => {
if (!state.isAuthenticated && !['login', 'register', 'email-verification'].includes(state.currentView)) {
actions.setCurrentView('login');
}
}, [state.isAuthenticated, state.currentView, actions]);

const handleShowRegistration = () => {
actions.setCurrentView('register');
};

const handleBackToLogin = () => {
actions.setCurrentView('login');
};

const handleRegistrationSuccess = (userData) => {
// Registration success should redirect to login with verification message
actions.setCurrentView('login');
};

const handleEmailVerificationSuccess = () => {
actions.setCurrentView('login');
actions.clearVerificationMessage();
};

const handleVenueSelect = (venue) => {
actions.setSelectedVenue(venue);
actions.setCurrentView('details');
};

const handleBackToHome = () => {
actions.setCurrentView('home');
actions.setSelectedVenue(null);
};

const handleClearSearch = () => {
setSearchQuery('');
};

// Get verification token and email from URL or localStorage
const getVerificationData = () => {
const urlParams = new URLSearchParams(window.location.search);
const token = urlParams.get('token');
const email = urlParams.get('email') || localStorage.getItem('pending_verification_email');
return { token, email };
};

// Determine if header should be shown (not on login, register, or verification pages)
const showHeader = !['login', 'register', 'email-verification'].includes(state.currentView);

return (
<div className={`app ${isMobile ? 'mobile' : 'desktop'}`}>
{/* Header */}
{showHeader && (
<Header
searchQuery={searchQuery}
setSearchQuery={setSearchQuery}
onClearSearch={handleClearSearch}
isMobile={isMobile}
/>
)}

{/* Main Content */}
<main className={`main-content ${isMobile ? 'mobile-main' : ''}`}>
{state.currentView === 'login' && (
<LoginView onRegister={handleShowRegistration} />
)}

{state.currentView === 'register' && (
<RegistrationView
onBack={handleBackToLogin}
onSuccess={handleRegistrationSuccess}
/>
)}

{state.currentView === 'email-verification' && (
<EmailVerificationView
onBack={handleBackToLogin}
onSuccess={handleEmailVerificationSuccess}
token={getVerificationData().token}
email={getVerificationData().email}
/>
)}

{state.currentView === 'home' && (
<HomeView onVenueSelect={handleVenueSelect} />
)}

{state.currentView === 'details' && (
<VenueDetailsView onBack={handleBackToHome} />
)}
</main>

{/* Modals */}
<RatingModal />
<ReportModal />
<ShareModal />
<UserProfileModal />

{/* Notifications */}
<Notifications />
</div>
);
}

function App() {
return (
<AppProvider>
<AppContent />
</AppProvider>
);
}

export default App;
```

---

## React Components

All React components with complete source code and analysis.

### Component: App.jsx

**Path:** `backup_20250601_023142/src/App.jsx`
**Size:** 6652 bytes

```javascript
import React, { useState, useEffect } from 'react';
import { AppProvider, useApp } from './context/AppContext';
import WelcomeLandingPage from './views/Landing/WelcomeLandingPage';
import LoginPage from './views/Auth/LoginPage';
import Header from './components/Layout/Header';
import HomeView from './components/Views/HomeView';
import VenueDetailsView from './components/Views/VenueDetailsView';
import ShareModal from './components/Social/ShareModal';
import RatingModal from './components/Venue/RatingModal';
import ReportModal from './components/Venue/ReportModal';
import { useVenues } from './hooks/useVenues';
import './App.css';

// 🚨 EMERGENCY: Inline loading screen to avoid context issues
const SessionLoadingScreen = () => (
  <div className="session-loading-screen">
    <div className="session-loading-content">
      <div className="session-loading-logo">nYtevibe</div>
      <div className="session-loading-spinner"></div>
      <div className="session-loading-text">Checking for existing session...</div>
    </div>
  </div>
);

// 🚨 EMERGENCY: Inline reset button to avoid import issues
const EmergencyReset = () => {
  const handleReset = () => {
    try {
      localStorage.clear();
      sessionStorage.clear();
      window.location.reload(true);
    } catch (error) {
      window.location.href = window.location.href;
    }
  };

  return (
    <div style={{
      position: 'fixed',
      top: '10px',
      right: '10px',
      zIndex: 10000,
      background: '#ff4444',
      color: 'white',
      padding: '8px 12px',
      borderRadius: '5px',
      cursor: 'pointer'
    }}>
      <button onClick={handleReset} style={{ background: 'none', border: 'none', color: 'white' }}>
        🚨 Reset App
      </button>
    </div>
  );
};

// 🛡️ Safe App Content - Only used INSIDE AppProvider
function AppContent() {
  const { state, actions } = useApp();
  const [searchQuery, setSearchQuery] = useState('');
  const [venueFilter, setVenueFilter] = useState('all');
  const [showShareModal, setShowShareModal] = useState(false);
  const [shareVenue, setShareVenue] = useState(null);

  // Show loading screen during session check
  if (state.isCheckingSession) {
    return <SessionLoadingScreen />;
  }

  // Safe view rendering
  const renderCurrentView = () => {
    try {
      switch (state.currentView) {
        case 'landing':
          return <WelcomeLandingPage />;
        
        case 'login':
          return <LoginPage />;
        
        case 'home':
          if (!state.isAuthenticated) {
            actions.setCurrentView('landing');
            return <WelcomeLandingPage />;
          }
          return (
            <>
              <Header
                searchQuery={searchQuery}
                setSearchQuery={setSearchQuery}
                onClearSearch={() => {
                  setSearchQuery('');
                  setVenueFilter('all');
                }}
              />
              <div className="content-frame">
                <HomeView
                  searchQuery={searchQuery}
                  setSearchQuery={setSearchQuery}
                  venueFilter={venueFilter}
                  setVenueFilter={setVenueFilter}
                  onVenueClick={(venue) => {
                    actions.setSelectedVenue(venue);
                    actions.setCurrentView('details');
                  }}
                  onVenueShare={(venue) => {
                    setShareVenue(venue);
                    setShowShareModal(true);
                  }}
                />
              </div>
            </>
          );
        
        case 'details':
          if (!state.isAuthenticated) {
            actions.setCurrentView('landing');
            return <WelcomeLandingPage />;
          }
          return (
            <div className="content-frame">
              <VenueDetailsView
                onBack={() => {
                  actions.setCurrentView('home');
                  actions.setSelectedVenue(null);
                }}
                onShare={(venue) => {
                  setShareVenue(venue);
                  setShowShareModal(true);
                }}
              />
            </div>
          );
        
        default:
          return <WelcomeLandingPage />;
      }
    } catch (error) {
      console.error('❌ View rendering error:', error);
      return <WelcomeLandingPage />;
    }
  };

  return (
    <div className="app-layout">
      {renderCurrentView()}
      
      {/* Notifications */}
      {state.notifications.length > 0 && (
        <div className="notification-container">
          {state.notifications.map((notification) => (
            <div
              key={notification.id}
              className={`notification notification-${notification.type}`}
            >
              <div className="notification-content">
                <span className="notification-message">{notification.message}</span>
                <button
                  onClick={() => actions.removeNotification(notification.id)}
                  className="notification-close"
                >
                  ×
                </button>
              </div>
            </div>
          ))}
        </div>
      )}

      {/* Modals */}
      <ShareModal
        venue={shareVenue}
        isOpen={showShareModal}
        onClose={() => {
          setShowShareModal(false);
          setShareVenue(null);
        }}
      />
      <RatingModal />
      <ReportModal />
    </div>
  );
}

// 🚨 MAIN APP: Wraps everything in provider safely
function App() {
  try {
    return (
      <AppProvider>
        <EmergencyReset />
        <AppContent />
      </AppProvider>
    );
  } catch (error) {
    console.error('❌ Critical App error:', error);
    
    // Nuclear fallback
    return (
      <div style={{ 
        height: '100vh', 
        display: 'flex', 
        alignItems: 'center', 
        justifyContent: 'center',
        flexDirection: 'column',
        background: '#1e293b',
        color: 'white'
      }}>
        <h1>🚨 App Error</h1>
        <p>Critical error occurred. Please reset the application.</p>
        <button 
          onClick={() => {
            localStorage.clear();
            window.location.reload();
          }}
          style={{
            background: '#ef4444',
            color: 'white',
            border: 'none',
            padding: '12px 24px',
            borderRadius: '8px',
            marginTop: '20px',
            cursor: 'pointer'
          }}
        >
          🔄 Reset Application
        </button>
      </div>
    );
  }
}

export default App;
```

---

#### Component Analysis: App

**Hooks Used:** useState useEffect useApp useVenues
**Props:** No props detected
**State Management:** Local state with hooks

**Key Imports:**
```javascript
import React, { useState, useEffect } from 'react';
import { AppProvider, useApp } from './context/AppContext';
import WelcomeLandingPage from './views/Landing/WelcomeLandingPage';
import LoginPage from './views/Auth/LoginPage';
import Header from './components/Layout/Header';
```

### Component: FollowButton.jsx

**Path:** `backup_20250601_023142/src/components/Follow/FollowButton.jsx`
**Size:** 1025 bytes

```javascript
import React from 'react';
import { Heart } from 'lucide-react';
import { useVenues } from '../../hooks/useVenues';

const FollowButton = ({ venue, size = 'md', showCount = false }) => {
  const { isVenueFollowed, toggleFollow } = useVenues();
  const isFollowed = isVenueFollowed(venue.id);

  const handleClick = (e) => {
    e.stopPropagation();
    toggleFollow(venue);
  };

  const sizeClasses = {
    sm: 'w-8 h-8',
    md: 'w-10 h-10',
    lg: 'w-12 h-12'
  };

  const iconSizes = {
    sm: 'w-3 h-3',
    md: 'w-4 h-4',
    lg: 'w-5 h-5'
  };

  return (
    <button
      onClick={handleClick}
      className={`follow-button ${isFollowed ? 'followed' : ''} ${sizeClasses[size]}`}
      title={isFollowed ? `Unfollow ${venue.name}` : `Follow ${venue.name}`}
    >
      <Heart className={`follow-icon ${isFollowed ? 'filled' : 'outline'} ${iconSizes[size]}`} />
      {showCount && (
        <span className="follow-count">{venue.followersCount}</span>
      )}
    </button>
  );
};

export default FollowButton;
```

---

#### Component Analysis: FollowButton

**Hooks Used:** useVenues
**Props:** Uses props
**State Management:** Local state with hooks

**Key Imports:**
```javascript
import React from 'react';
import { Heart } from 'lucide-react';
import { useVenues } from '../../hooks/useVenues';
```

### Component: FollowStats.jsx

**Path:** `backup_20250601_023142/src/components/Follow/FollowStats.jsx`
**Size:** 1216 bytes

```javascript
import React from 'react';
import { Heart, Users, TrendingUp } from 'lucide-react';
import { useVenues } from '../../hooks/useVenues';

const FollowStats = ({ venue }) => {
  const { isVenueFollowed } = useVenues();
  const isFollowed = isVenueFollowed(venue.id);

  return (
    <div className="venue-follow-stats">
      <div className="follow-stat">
        <Heart className="stat-icon" />
        <span className="stat-number">{venue.followersCount}</span>
        <span className="stat-label">followers</span>
      </div>
      
      <div className="follow-stat">
        <Users className="stat-icon" />
        <span className="stat-number">{venue.reports}</span>
        <span className="stat-label">reports</span>
      </div>
      
      <div className="follow-stat">
        <TrendingUp className="stat-icon" />
        <span className="stat-number">{venue.confidence}%</span>
        <span className="stat-label">accuracy</span>
      </div>
      
      {isFollowed && (
        <div className="follow-stat you-follow">
          <Heart className="stat-icon" />
          <span className="stat-text">You follow this venue</span>
        </div>
      )}
    </div>
  );
};

export default FollowStats;
```

---

#### Component Analysis: FollowStats

**Hooks Used:** useVenues
**Props:** Uses props
**State Management:** Local state with hooks

**Key Imports:**
```javascript
import React from 'react';
import { Heart, Users, TrendingUp } from 'lucide-react';
import { useVenues } from '../../hooks/useVenues';
```

### Component: Header.jsx

**Path:** `backup_20250601_023142/src/components/Layout/Header.jsx`
**Size:** 791 bytes

```javascript
import React from 'react';
import UserProfile from '../User/UserProfile';
import SearchBar from './SearchBar';

const Header = ({ searchQuery, setSearchQuery, onClearSearch }) => {
  return (
    <div className="header-frame">
      <div className="header-content">
        <div className="header-top">
          <div className="header-branding">
            <h1 className="app-title">nYtevibe</h1>
            <p className="app-subtitle">Houston Nightlife Discovery</p>
          </div>
          <UserProfile />
        </div>
        <SearchBar
          searchQuery={searchQuery}
          setSearchQuery={setSearchQuery}
          onClearSearch={onClearSearch}
          placeholder="Search venues, areas, or vibes..."
        />
      </div>
    </div>
  );
};

export default Header;
```

---

#### Component Analysis: Header

**Hooks Used:** None detected
**Props:** Uses props
**State Management:** Stateless component

**Key Imports:**
```javascript
import React from 'react';
import UserProfile from '../User/UserProfile';
import SearchBar from './SearchBar';
```

### Component: PromotionalBanner.jsx

**Path:** `backup_20250601_023142/src/components/Layout/PromotionalBanner.jsx`
**Size:** 1250 bytes

```javascript
import React from 'react';
import { MessageCircle, Gift, Sparkles, Volume2, Calendar, UserPlus, Brain } from 'lucide-react';

const iconMap = {
  MessageCircle,
  Gift,
  Sparkles,
  Volume2,
  Calendar,
  UserPlus,
  Brain
};

const PromotionalBanner = ({ banner, onClick }) => {
  const IconComponent = iconMap[banner.icon];

  return (
    <div
      className="promotional-banner"
      style={{
        background: banner.bgColor,
        borderColor: banner.borderColor,
        color: banner.textColor || '#1f2937'
      }}
      onClick={onClick}
    >
      <div className="banner-content">
        {IconComponent && (
          <IconComponent
            className="banner-icon"
            style={{ color: banner.iconColor }}
          />
        )}
        <div className="banner-text">
          <div
            className="banner-title"
            style={{ color: banner.textColor || '#1f2937' }}
          >
            {banner.title}
          </div>
          <div
            className="banner-subtitle"
            style={{ color: banner.textColor ? `${banner.textColor}CC` : '#6b7280' }}
          >
            {banner.subtitle}
          </div>
        </div>
      </div>
    </div>
  );
};

export default PromotionalBanner;
```

---

#### Component Analysis: PromotionalBanner

**Hooks Used:** None detected
**Props:** Uses props
**State Management:** Stateless component

**Key Imports:**
```javascript
import React from 'react';
import { MessageCircle, Gift, Sparkles, Volume2, Calendar, UserPlus, Brain } from 'lucide-react';
```

### Component: SearchBar.jsx

**Path:** `backup_20250601_023142/src/components/Layout/SearchBar.jsx`
**Size:** 947 bytes

```javascript
import React from 'react';
import { Search, X } from 'lucide-react';

const SearchBar = ({ 
  searchQuery, 
  setSearchQuery, 
  onClearSearch,
  placeholder = "Search venues, areas, or vibes..." 
}) => {
  const handleClear = () => {
    setSearchQuery('');
    if (onClearSearch) {
      onClearSearch();
    }
  };

  return (
    <div className="search-bar-container">
      <div className="search-bar">
        <Search className="search-icon" />
        <input
          type="text"
          value={searchQuery}
          onChange={(e) => setSearchQuery(e.target.value)}
          placeholder={placeholder}
          className="search-input"
        />
        {searchQuery && (
          <button
            onClick={handleClear}
            className="search-clear"
            title="Clear search"
          >
            <X className="w-4 h-4" />
          </button>
        )}
      </div>
    </div>
  );
};

export default SearchBar;
```

---

#### Component Analysis: SearchBar

**Hooks Used:** None detected
**Props:** No props detected
**State Management:** Stateless component

**Key Imports:**
```javascript
import React from 'react';
import { Search, X } from 'lucide-react';
```

### Component: SearchSection.jsx

**Path:** `backup_20250601_023142/src/components/Search/SearchSection.jsx`
**Size:** 696 bytes

```javascript
import React from 'react';
import { Search, X } from 'lucide-react';

const SearchSection = ({ searchQuery, setSearchQuery, onClearSearch }) => {
  return (
    <div className="search-container">
      <Search className="search-icon" size={20} />
      <input
        type="text"
        placeholder="Search venues, types, or locations..."
        value={searchQuery}
        onChange={(e) => setSearchQuery(e.target.value)}
        className="search-input"
      />
      {searchQuery && (
        <button
          onClick={onClearSearch}
          className="clear-search-button"
        >
          <X size={16} />
        </button>
      )}
    </div>
  );
};

export default SearchSection;
```

---

#### Component Analysis: SearchSection

**Hooks Used:** None detected
**Props:** Uses props
**State Management:** Stateless component

**Key Imports:**
```javascript
import React from 'react';
import { Search, X } from 'lucide-react';
```

### Component: ShareModal.jsx

**Path:** `backup_20250601_023142/src/components/Social/ShareModal.jsx`
**Size:** 2863 bytes

```javascript
import React from 'react';
import { X, Facebook, Twitter, Instagram, Copy, MessageCircle, ExternalLink } from 'lucide-react';
import { shareVenue } from '../../utils/helpers';

const ShareModal = ({ venue, isOpen, onClose }) => {
  if (!venue || !isOpen) return null;

  const handleShare = (platform) => {
    shareVenue(venue, platform);
    onClose();
  };

  const shareOptions = [
    {
      platform: 'facebook',
      icon: Facebook,
      label: 'Facebook',
      color: 'text-blue-600',
      bgColor: 'bg-blue-50 hover:bg-blue-100'
    },
    {
      platform: 'twitter',
      icon: Twitter,
      label: 'Twitter',
      color: 'text-blue-400',
      bgColor: 'bg-blue-50 hover:bg-blue-100'
    },
    {
      platform: 'instagram',
      icon: Instagram,
      label: 'Instagram',
      color: 'text-pink-600',
      bgColor: 'bg-pink-50 hover:bg-pink-100'
    },
    {
      platform: 'whatsapp',
      icon: MessageCircle,
      label: 'WhatsApp',
      color: 'text-green-600',
      bgColor: 'bg-green-50 hover:bg-green-100'
    },
    {
      platform: 'copy',
      icon: Copy,
      label: 'Copy Link',
      color: 'text-gray-600',
      bgColor: 'bg-gray-50 hover:bg-gray-100'
    }
  ];

  return (
    <div className="modal-overlay" onClick={onClose}>
      <div className="modal-content share-modal" onClick={(e) => e.stopPropagation()}>
        <div className="modal-header">
          <h3 className="modal-title">Share {venue.name}</h3>
          <button onClick={onClose} className="modal-close">
            <X className="w-4 h-4" />
          </button>
        </div>

        <div className="modal-body">
          <div className="share-preview">
            <div className="share-venue-info">
              <h4 className="share-venue-name">{venue.name}</h4>
              <p className="share-venue-details">
                {venue.type} • ⭐ {venue.rating}/5 ({venue.totalRatings} reviews)
              </p>
              <p className="share-venue-address">{venue.address}</p>
            </div>
          </div>

          <div className="share-options">
            <label className="share-options-label">Share via</label>
            <div className="share-buttons">
              {shareOptions.map(({ platform, icon: Icon, label, color, bgColor }) => (
                <button
                  key={platform}
                  onClick={() => handleShare(platform)}
                  className={`share-option ${bgColor} transition-colors duration-200`}
                >
                  <Icon className={`w-5 h-5 ${color}`} />
                  <span className="share-option-label">{label}</span>
                  <ExternalLink className="w-3 h-3 text-gray-400" />
                </button>
              ))}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default ShareModal;
```

---

#### Component Analysis: ShareModal

**Hooks Used:** None detected
**Props:** Uses props
**State Management:** Stateless component

**Key Imports:**
```javascript
import React from 'react';
import { X, Facebook, Twitter, Instagram, Copy, MessageCircle, ExternalLink } from 'lucide-react';
import { shareVenue } from '../../utils/helpers';
```

### Component: Badge.jsx

**Path:** `backup_20250601_023142/src/components/UI/Badge.jsx`
**Size:** 638 bytes

```javascript
import React from 'react';

const Badge = ({ 
  children, 
  variant = 'primary', 
  size = 'md',
  className = ''
}) => {
  const baseClasses = 'badge';
  const variantClasses = {
    primary: 'badge-blue',
    green: 'badge-green',
    yellow: 'badge-yellow',
    red: 'badge-red',
    gray: 'badge-gray'
  };
  const sizeClasses = {
    sm: 'badge-sm',
    md: 'badge-md',
    lg: 'badge-lg'
  };

  const classes = [
    baseClasses,
    variantClasses[variant],
    sizeClasses[size],
    className
  ].filter(Boolean).join(' ');

  return (
    <span className={classes}>
      {children}
    </span>
  );
};

export default Badge;
```

---

#### Component Analysis: Badge

**Hooks Used:** None detected
**Props:** No props detected
**State Management:** Stateless component

**Key Imports:**
```javascript
import React from 'react';
```

### Component: Button.jsx

**Path:** `backup_20250601_023142/src/components/UI/Button.jsx`
**Size:** 783 bytes

```javascript
import React from 'react';

const Button = ({ 
  children, 
  variant = 'primary', 
  size = 'md', 
  disabled = false, 
  onClick,
  className = '',
  ...props 
}) => {
  const baseClasses = 'btn';
  const variantClasses = {
    primary: 'btn-primary',
    secondary: 'btn-secondary',
    warning: 'btn-warning',
    danger: 'btn-danger'
  };
  const sizeClasses = {
    sm: 'btn-sm',
    md: 'btn-md',
    lg: 'btn-lg'
  };

  const classes = [
    baseClasses,
    variantClasses[variant],
    sizeClasses[size],
    disabled ? 'btn-disabled' : '',
    className
  ].filter(Boolean).join(' ');

  return (
    <button
      className={classes}
      disabled={disabled}
      onClick={onClick}
      {...props}
    >
      {children}
    </button>
  );
};

export default Button;
```

---

#### Component Analysis: Button

**Hooks Used:** None detected
**Props:** No props detected
**State Management:** Stateless component

**Key Imports:**
```javascript
import React from 'react';
```

### Component: Modal.jsx

**Path:** `backup_20250601_023142/src/components/UI/Modal.jsx`
**Size:** 1471 bytes

```javascript
import React, { useEffect } from 'react';
import { X } from 'lucide-react';

const Modal = ({ 
  isOpen, 
  onClose, 
  title, 
  children, 
  size = 'md',
  className = ''
}) => {
  useEffect(() => {
    if (isOpen) {
      document.body.style.overflow = 'hidden';
    } else {
      document.body.style.overflow = 'unset';
    }

    return () => {
      document.body.style.overflow = 'unset';
    };
  }, [isOpen]);

  useEffect(() => {
    const handleEscape = (e) => {
      if (e.key === 'Escape') {
        onClose();
      }
    };

    if (isOpen) {
      document.addEventListener('keydown', handleEscape);
    }

    return () => {
      document.removeEventListener('keydown', handleEscape);
    };
  }, [isOpen, onClose]);

  if (!isOpen) return null;

  const sizeClasses = {
    sm: 'modal-sm',
    md: 'modal-md',
    lg: 'modal-lg',
    xl: 'modal-xl'
  };

  return (
    <div className="modal-overlay" onClick={onClose}>
      <div 
        className={`modal-content ${sizeClasses[size]} ${className}`}
        onClick={(e) => e.stopPropagation()}
      >
        {title && (
          <div className="modal-header">
            <h3 className="modal-title">{title}</h3>
            <button onClick={onClose} className="modal-close">
              <X className="w-4 h-4" />
            </button>
          </div>
        )}
        <div className="modal-body">
          {children}
        </div>
      </div>
    </div>
  );
};

export default Modal;
```

---

#### Component Analysis: Modal

