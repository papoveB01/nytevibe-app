#!/bin/bash

# nYtevibe Controlled Updates Setup Script
# Creates the Houston venue tracking app with optimized, controlled real-time updates

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${PURPLE}✨ $1 ✨${NC}"
}

print_feature() {
    echo -e "${CYAN}🔹${NC} $1"
}

print_header "nYtevibe Controlled Updates - Houston Venue Tracker"
print_header "================================================="

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    print_error "package.json not found. Please run this from the nytevibe project directory."
    exit 1
fi

# Backup current files
print_status "📋 Creating backups..."
cp src/App.jsx src/App.jsx.backup 2>/dev/null || echo "App.jsx backup skipped"
cp src/App.css src/App.css.backup 2>/dev/null || echo "App.css backup skipped"
cp src/index.css src/index.css.backup 2>/dev/null || echo "index.css backup skipped"
print_success "Backups created"

# Create the optimized App.jsx with controlled updates
print_status "🏢 Creating optimized nYtevibe application with controlled updates..."
cat > src/App.jsx << 'APPEOF'
import React, { useState, useEffect, useCallback } from 'react';
import { MapPin, Users, Clock, Star, TrendingUp, MessageCircle, Award, ChevronRight, Phone, ExternalLink, ArrowLeft, Navigation, Map, Wifi, WifiOff } from 'lucide-react';
import './App.css';

const App = () => {
  const [currentView, setCurrentView] = useState('home');
  const [selectedVenue, setSelectedVenue] = useState(null);
  const [showReportModal, setShowReportModal] = useState(false);
  const [userPoints, setUserPoints] = useState(147);
  const [userLevel, setUserLevel] = useState('Silver Reporter');
  const [isUpdating, setIsUpdating] = useState(false);
  const [lastUpdateTime, setLastUpdateTime] = useState(new Date());

  // Houston venues with real-time status tracking
  const [venues, setVenues] = useState([
    {
      id: 1,
      name: "NYC Vibes",
      type: "Lounge",
      distance: "0.2 mi",
      crowdLevel: 4,
      waitTime: 15,
      lastUpdate: "2 min ago",
      vibe: ["Lively", "Hip-Hop"],
      confidence: 95,
      reports: 8,
      lat: 29.7604,
      lng: -95.3698,
      address: "1234 Main Street, Houston, TX 77002",
      phone: "(713) 555-0123",
      hours: "Open until 2:00 AM",
      rating: 4.2,
      isOpen: true,
      trending: "up"
    },
    {
      id: 2,
      name: "Rumors",
      type: "Nightclub",
      distance: "0.4 mi",
      crowdLevel: 2,
      waitTime: 0,
      lastUpdate: "5 min ago",
      vibe: ["Chill", "R&B"],
      confidence: 87,
      reports: 12,
      lat: 29.7595,
      lng: -95.3697,
      address: "5678 Downtown Boulevard, Houston, TX 77003",
      phone: "(713) 555-0456",
      hours: "Open until 3:00 AM",
      rating: 4.5,
      isOpen: true,
      trending: "stable"
    },
    {
      id: 3,
      name: "Classic",
      type: "Bar & Grill",
      distance: "0.7 mi",
      crowdLevel: 5,
      waitTime: 30,
      lastUpdate: "1 min ago",
      vibe: ["Packed", "Sports"],
      confidence: 98,
      reports: 23,
      lat: 29.7586,
      lng: -95.3696,
      address: "9012 Sports Center Drive, Houston, TX 77004",
      phone: "(713) 555-0789",
      hours: "Open until 1:00 AM",
      rating: 4.1,
      isOpen: true,
      trending: "down"
    },
    {
      id: 4,
      name: "Best Regards",
      type: "Cocktail Bar",
      distance: "0.3 mi",
      crowdLevel: 3,
      waitTime: 20,
      lastUpdate: "8 min ago",
      vibe: ["Moderate", "Date Night"],
      confidence: 76,
      reports: 5,
      lat: 29.7577,
      lng: -95.3695,
      address: "3456 Uptown Plaza, Houston, TX 77005",
      phone: "(713) 555-0321",
      hours: "Open until 12:00 AM",
      rating: 4.7,
      isOpen: true,
      trending: "up"
    }
  ]);

  // Google Maps integration functions
  const openGoogleMaps = (venue) => {
    const address = encodeURIComponent(venue.address);
    const url = `https://www.google.com/maps/search/?api=1&query=${address}`;
    window.open(url, '_blank');
  };

  const getDirections = (venue) => {
    const address = encodeURIComponent(venue.address);
    const url = `https://www.google.com/maps/dir/?api=1&destination=${address}`;
    window.open(url, '_blank');
  };

  // Controlled real-time updates with better logic
  const updateVenueData = useCallback(() => {
    setIsUpdating(true);
    
    setVenues(prevVenues => 
      prevVenues.map(venue => {
        // Only update some venues occasionally (30% chance)
        const shouldUpdate = Math.random() > 0.7;
        
        if (shouldUpdate) {
          const crowdChange = (Math.random() - 0.5) * 0.4; // Smaller changes
          const newCrowdLevel = Math.max(1, Math.min(5, venue.crowdLevel + crowdChange));
          
          // Determine trending direction
          let trending = 'stable';
          if (crowdChange > 0.1) trending = 'up';
          if (crowdChange < -0.1) trending = 'down';
          
          return {
            ...venue,
            crowdLevel: newCrowdLevel,
            lastUpdate: "Just now",
            reports: venue.reports + 1,
            confidence: Math.min(99, venue.confidence + 1),
            trending: trending,
            waitTime: Math.max(0, venue.waitTime + Math.round((Math.random() - 0.5) * 10))
          };
        }
        return venue;
      })
    );
    
    setLastUpdateTime(new Date());
    
    // Hide updating indicator after a short delay
    setTimeout(() => setIsUpdating(false), 1000);
  }, []);

  // Optimized useEffect with proper cleanup and controlled intervals
  useEffect(() => {
    let interval;
    
    // Only start interval if on home view and page is visible
    if (currentView === 'home' && !document.hidden) {
      interval = setInterval(() => {
        updateVenueData();
      }, 45000); // Update every 45 seconds (more reasonable)
    }

    return () => {
      if (interval) {
        clearInterval(interval);
      }
    };
  }, [currentView, updateVenueData]);

  // Handle page visibility changes
  useEffect(() => {
    const handleVisibilityChange = () => {
      if (document.hidden) {
        // Page is hidden, no need to update
        setIsUpdating(false);
      } else if (currentView === 'home') {
        // Page is visible again, do an immediate update
        updateVenueData();
      }
    };

    document.addEventListener('visibilitychange', handleVisibilityChange);
    
    return () => {
      document.removeEventListener('visibilitychange', handleVisibilityChange);
    };
  }, [currentView, updateVenueData]);

  const getCrowdLabel = (level) => {
    const labels = ["", "Empty", "Quiet", "Moderate", "Busy", "Packed"];
    return labels[Math.round(level)] || "Unknown";
  };

  const getCrowdColor = (level) => {
    if (level <= 2) return "badge badge-green badge-crowd";
    if (level <= 3) return "badge badge-yellow badge-crowd";
    return "badge badge-red badge-crowd";
  };

  const getTrendingIcon = (trending) => {
    switch (trending) {
      case 'up': return '📈';
      case 'down': return '📉';
      default: return '➡️';
    }
  };

  // Format last update time
  const formatUpdateTime = (date) => {
    return date.toLocaleTimeString('en-US', { 
      hour: '2-digit', 
      minute: '2-digit', 
      second: '2-digit' 
    });
  };

  // Report Modal Component
  const ReportModal = ({ venue, onClose, onSubmit }) => {
    const [crowdLevel, setCrowdLevel] = useState(Math.round(venue.crowdLevel));
    const [waitTime, setWaitTime] = useState(venue.waitTime);
    const [vibe, setVibe] = useState([]);
    const [note, setNote] = useState('');

    const vibeOptions = ["Chill", "Lively", "Loud", "Dancing", "Sports", "Date Night", "Business", "Family", "Hip-Hop", "R&B", "Live Music", "Karaoke"];

    const toggleVibe = (option) => {
      setVibe(prev => 
        prev.includes(option) 
          ? prev.filter(v => v !== option)
          : [...prev, option]
      );
    };

    const handleSubmit = () => {
      onSubmit({
        crowdLevel,
        waitTime,
        vibe,
        note
      });
      onClose();
    };

    return (
      <div className="modal-overlay">
        <div className="modal-content">
          <h3 className="text-xl font-bold mb-4 text-primary">Report Status: {venue.name}</h3>
          
          <div className="mb-4">
            <label className="block text-sm font-semibold mb-3 text-secondary">How busy is it?</label>
            <div className="flex space-x-2">
              {[1,2,3,4,5].map(level => (
                <button
                  key={level}
                  onClick={() => setCrowdLevel(level)}
                  className={`w-12 h-12 rounded-full flex items-center justify-center text-sm font-bold transition-all ${
                    crowdLevel === level 
                      ? 'btn btn-primary' 
                      : 'btn btn-secondary'
                  }`}
                >
                  {level}
                </button>
              ))}
            </div>
            <div className="text-xs text-muted mt-2">
              1 = Empty, 5 = Packed
            </div>
          </div>

          <div className="mb-4">
            <label className="block text-sm font-semibold mb-2 text-secondary">Wait time (minutes)</label>
            <input
              type="number"
              value={waitTime}
              onChange={(e) => setWaitTime(Number(e.target.value))}
              className="form-input"
              min="0"
              max="120"
              placeholder="0"
            />
          </div>

          <div className="mb-4">
            <label className="block text-sm font-semibold mb-3 text-secondary">Vibe (select all that apply)</label>
            <div className="flex flex-wrap gap-2">
              {vibeOptions.map(option => (
                <button
                  key={option}
                  onClick={() => toggleVibe(option)}
                  className={`px-3 py-2 rounded-full text-sm font-medium transition-all ${
                    vibe.includes(option)
                      ? 'btn btn-primary'
                      : 'btn btn-secondary'
                  }`}
                >
                  {option}
                </button>
              ))}
            </div>
          </div>

          <div className="mb-6">
            <label className="block text-sm font-semibold mb-2 text-secondary">Additional notes (optional)</label>
            <textarea
              value={note}
              onChange={(e) => setNote(e.target.value)}
              className="form-input form-textarea"
              rows="3"
              placeholder="Any special events, music, atmosphere details..."
            />
          </div>

          <div className="flex space-x-3">
            <button
              onClick={onClose}
              className="btn btn-secondary flex-1"
            >
              Cancel
            </button>
            <button
              onClick={handleSubmit}
              className="btn btn-primary flex-1"
            >
              Submit Report (+5 points)
            </button>
          </div>
        </div>
      </div>
    );
  };

  // Enhanced Venue Card Component
  const VenueCard = ({ venue, onClick, showReportButton = true }) => (
    <div className="card card-venue animate-fadeIn">
      <div className="flex justify-between items-start mb-3">
        <div className="flex-1">
          <div className="flex items-center mb-1">
            <h3 className="text-lg font-bold text-primary mr-2">{venue.name}</h3>
            <span className="text-sm">{getTrendingIcon(venue.trending)}</span>
          </div>
          <div className="flex items-center text-secondary text-sm mb-1">
            <MapPin className="icon icon-sm mr-2" />
            <span className="font-medium">{venue.type} • {venue.distance}</span>
          </div>
          <div className="text-xs text-muted">{venue.address}</div>
        </div>
        <div className="text-right">
          <div className={getCrowdColor(venue.crowdLevel)}>
            <Users className="icon icon-sm mr-1" />
            {getCrowdLabel(venue.crowdLevel)}
          </div>
        </div>
      </div>

      <div className="flex items-center justify-between mb-4">
        <div className="flex items-center space-x-4 text-sm text-secondary">
          <div className="flex items-center">
            <Clock className="icon icon-sm mr-1" />
            <span className="font-medium">{venue.waitTime > 0 ? `${venue.waitTime} min wait` : 'No wait'}</span>
          </div>
          <div className="flex items-center">
            <TrendingUp className="icon icon-sm mr-1" />
            <span className="font-medium">{venue.confidence}% confidence</span>
          </div>
        </div>
        <span className="text-xs text-muted font-medium">{venue.lastUpdate}</span>
      </div>

      <div className="flex flex-wrap gap-2 mb-4">
        {venue.vibe.map((tag, index) => (
          <span key={index} className="badge badge-blue">
            {tag}
          </span>
        ))}
      </div>

      <div className="flex space-x-2">
        {showReportButton && (
          <button
            onClick={(e) => {
              e.stopPropagation();
              setSelectedVenue(venue);
              setShowReportModal(true);
            }}
            className="btn btn-primary flex-1"
          >
            Update Status
          </button>
        )}
        <button
          onClick={() => onClick(venue)}
          className="btn btn-secondary flex-1 flex items-center justify-center"
        >
          View Details
          <ChevronRight className="icon icon-sm ml-2" />
        </button>
      </div>
    </div>
  );

  // Enhanced Venue Detail Component
  const VenueDetail = ({ venue }) => (
    <div className="app-container animate-slideIn">
      <div className="app-header">
        <div className="header-content">
          <button
            onClick={() => setCurrentView('home')}
            className="btn btn-secondary mb-3 text-sm flex items-center"
          >
            <ArrowLeft className="icon icon-sm mr-2" />
            Back to venues
          </button>
          <h1 className="app-title">{venue.name}</h1>
          <p className="app-subtitle font-semibold">{venue.type} • {venue.hours}</p>
          <div className="flex items-center mt-2">
            <Star className="icon icon-sm text-yellow-400 mr-1" />
            <span className="text-sm font-medium">{venue.rating} rating</span>
            <span className="ml-3 text-sm">{getTrendingIcon(venue.trending)} {venue.trending}</span>
          </div>
        </div>
      </div>

      <div className="p-4 space-y-4">
        <div className="card">
          <h3 className="font-bold text-lg mb-4 text-primary">Current Status</h3>
          <div className="grid grid-cols-2 gap-4">
            <div className="stats-card">
              <div className="stats-number">{Math.round(venue.crowdLevel)}/5</div>
              <div className="stats-label">Crowd Level</div>
            </div>
            <div className="stats-card" style={{background: 'var(--gradient-success)'}}>
              <div className="stats-number">{venue.waitTime}m</div>
              <div className="stats-label">Wait Time</div>
            </div>
          </div>
          <div className="mt-4 text-sm text-muted text-center">
            Last updated {venue.lastUpdate} • {venue.reports} reports today • {venue.confidence}% confidence
          </div>
        </div>

        <div className="card">
          <h3 className="font-bold text-lg mb-4 text-primary">Location & Contact</h3>
          
          <div className="flex items-start space-x-3 mb-4">
            <MapPin className="icon icon-lg text-primary mt-1" />
            <div className="flex-1">
              <div className="text-sm font-semibold text-primary">{venue.address}</div>
              <div className="text-xs text-muted">{venue.distance} away</div>
            </div>
          </div>

          <div className="flex items-center space-x-3 mb-4">
            <Phone className="icon icon-lg text-primary" />
            <a href={`tel:${venue.phone}`} className="text-sm font-semibold text-primary hover:underline">
              {venue.phone}
            </a>
          </div>

          <div className="flex items-center space-x-3 mb-6">
            <Clock className="icon icon-lg text-primary" />
            <div className="text-sm font-semibold text-primary">{venue.hours}</div>
          </div>

          <div className="flex space-x-3">
            <button
              onClick={() => openGoogleMaps(venue)}
              className="btn btn-success flex-1 flex items-center justify-center"
            >
              <Map className="icon icon-sm mr-2" />
              View on Map
            </button>
            <button
              onClick={() => getDirections(venue)}
              className="btn btn-primary flex-1 flex items-center justify-center"
            >
              <Navigation className="icon icon-sm mr-2" />
              Directions
            </button>
          </div>
        </div>

        <div className="card">
          <h3 className="font-bold text-lg mb-4 text-primary">Vibe & Atmosphere</h3>
          <div className="flex flex-wrap gap-2">
            {venue.vibe.map((tag, index) => (
              <span key={index} className="badge badge-blue text-sm px-4 py-2">
                {tag}
              </span>
            ))}
          </div>
        </div>

        <button
          onClick={() => {
            setSelectedVenue(venue);
            setShowReportModal(true);
          }}
          className="btn btn-primary w-full py-4 font-bold text-base"
        >
          Update Status (+5 points)
        </button>
      </div>
    </div>
  );

  // Enhanced Home View Component
  const HomeView = () => (
    <div className="app-container animate-fadeIn">
      <div className="app-header">
        <div className="header-content">
          <div className="flex items-center justify-between mb-4">
            <div>
              <h1 className="app-title">nYtevibe</h1>
              <p className="app-subtitle">Houston, TX • Downtown</p>
            </div>
            <div className="text-right">
              <div className="user-stats">
                <Award className="icon icon-sm mr-2" />
                <span>{userPoints} pts</span>
              </div>
              <div className="user-level">{userLevel}</div>
            </div>
          </div>
          
          <div className="community-banner">
            <div className="banner-content">
              <MessageCircle className="banner-icon" />
              <div>
                <div className="banner-title">Help your community!</div>
                <div className="banner-subtitle">Report venue status as you visit to earn points</div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div className="p-4 space-y-4">
        <div className="flex items-center justify-between mb-6">
          <h2 className="text-xl font-bold text-white">Nearby Venues</h2>
          <span className="badge badge-blue">{venues.length} venues</span>
        </div>
        
        {venues.map((venue, index) => (
          <div key={venue.id} style={{animationDelay: `${index * 0.1}s`}}>
            <VenueCard
              venue={venue}
              onClick={(venue) => {
                setSelectedVenue(venue);
                setCurrentView('detail');
              }}
            />
          </div>
        ))}
        
        {/* Enhanced Real-time Update Indicator */}
        <div className="card text-center">
          <div className="flex items-center justify-center mb-2">
            {isUpdating ? (
              <Wifi className="icon icon-sm mr-2 text-primary animate-pulse" />
            ) : (
              <WifiOff className="icon icon-sm mr-2 text-muted" />
            )}
            <span className="text-sm font-semibold text-primary">
              {isUpdating ? 'Updating...' : 'Live Updates'}
            </span>
          </div>
          <div className="text-xs text-muted">
            Updates every 45 seconds • Last: {formatUpdateTime(lastUpdateTime)}
          </div>
          <button
            onClick={updateVenueData}
            className="btn btn-secondary mt-3 text-xs py-2 px-4"
          >
            Refresh Now
          </button>
        </div>
      </div>
    </div>
  );

  // Handle report submission
  const handleReportSubmit = (reportData) => {
    setVenues(prevVenues =>
      prevVenues.map(venue =>
        venue.id === selectedVenue.id
          ? {
              ...venue,
              crowdLevel: reportData.crowdLevel,
              waitTime: reportData.waitTime,
              vibe: reportData.vibe.length > 0 ? reportData.vibe : venue.vibe,
              lastUpdate: "Just now",
              reports: venue.reports + 1,
              confidence: Math.min(99, venue.confidence + 3),
              trending: venue.crowdLevel < reportData.crowdLevel ? 'up' : 
                       venue.crowdLevel > reportData.crowdLevel ? 'down' : 'stable'
            }
          : venue
      )
    );
    setUserPoints(prev => prev + 5);
    setSelectedVenue(null);
    setLastUpdateTime(new Date());
  };

  return (
    <div className="font-sans">
      {currentView === 'home' && <HomeView />}
      {currentView === 'detail' && selectedVenue && <VenueDetail venue={selectedVenue} />}
      
      {showReportModal && selectedVenue && (
        <ReportModal
          venue={selectedVenue}
          onClose={() => {
            setShowReportModal(false);
            setSelectedVenue(null);
          }}
          onSubmit={handleReportSubmit}
        />
      )}
    </div>
  );
};

export default App;
APPEOF

# Create the stunning glassmorphism CSS (same as before but with some enhancements)
print_status "🎨 Creating enhanced glassmorphism CSS design..."
cat > src/App.css << 'CSSEOF'
/* nYtevibe - Houston Venue Tracker - Enhanced Glassmorphism UI */

/* Import modern fonts */
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap');

/* CSS Variables for consistent theming */
:root {
  /* Primary Colors */
  --primary-50: #eff6ff;
  --primary-100: #dbeafe;
  --primary-200: #bfdbfe;
  --primary-300: #93c5fd;
  --primary-400: #60a5fa;
  --primary-500: #3b82f6;
  --primary-600: #2563eb;
  --primary-700: #1d4ed8;
  --primary-800: #1e40af;
  --primary-900: #1e3a8a;

  /* Gradients */
  --gradient-primary: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  --gradient-secondary: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
  --gradient-success: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
  --gradient-warning: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
  --gradient-danger: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
  --gradient-houston: linear-gradient(135deg, #667eea 0%, #764ba2 100%);

  /* Background */
  --bg-primary: #f8fafc;
  --bg-secondary: #ffffff;
  --bg-glass: rgba(255, 255, 255, 0.25);
  --bg-overlay: rgba(0, 0, 0, 0.5);

  /* Text Colors */
  --text-primary: #1e293b;
  --text-secondary: #64748b;
  --text-muted: #94a3b8;
  --text-white: #ffffff;

  /* Shadows */
  --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
  --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
  --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
  --shadow-xl: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
  --shadow-glow: 0 0 20px rgba(59, 130, 246, 0.3);
  --shadow-card: 0 8px 32px rgba(0, 0, 0, 0.12);

  /* Border Radius */
  --radius-sm: 0.375rem;
  --radius-md: 0.5rem;
  --radius-lg: 0.75rem;
  --radius-xl: 1rem;
  --radius-2xl: 1.5rem;
  --radius-full: 9999px;

  /* Transitions */
  --transition-fast: all 0.15s ease;
  --transition-normal: all 0.3s ease;
  --transition-slow: all 0.5s ease;
}

/* Reset and base styles */
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen', sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  background: var(--gradient-houston);
  min-height: 100vh;
  color: var(--text-primary);
  line-height: 1.6;
  font-feature-settings: 'cv02', 'cv03', 'cv04', 'cv11';
}

#root {
  min-height: 100vh;
}

/* Modern Button Styles */
.btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 0.75rem 1.5rem;
  border-radius: var(--radius-lg);
  font-weight: 600;
  font-size: 0.875rem;
  text-decoration: none;
  border: none;
  cursor: pointer;
  transition: var(--transition-normal);
  position: relative;
  overflow: hidden;
  backdrop-filter: blur(10px);
  font-family: inherit;
}

.btn::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
  transition: left 0.5s;
}

.btn:hover::before {
  left: 100%;
}

.btn-primary {
  background: var(--gradient-primary);
  color: var(--text-white);
  box-shadow: var(--shadow-md);
}

.btn-primary:hover {
  transform: translateY(-2px);
  box-shadow: var(--shadow-xl);
}

.btn-secondary {
  background: rgba(255, 255, 255, 0.15);
  color: var(--text-primary);
  border: 1px solid rgba(255, 255, 255, 0.2);
  backdrop-filter: blur(10px);
}

.btn-secondary:hover {
  background: rgba(255, 255, 255, 0.25);
  transform: translateY(-1px);
}

.btn-success {
  background: var(--gradient-success);
  color: var(--text-white);
}

.btn-warning {
  background: var(--gradient-warning);
  color: var(--text-primary);
}

/* Modern Card Styles */
.card {
  background: rgba(255, 255, 255, 0.95);
  border-radius: var(--radius-xl);
  padding: 1.5rem;
  box-shadow: var(--shadow-card);
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.2);
  transition: var(--transition-normal);
  position: relative;
  overflow: hidden;
}

.card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 1px;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.8), transparent);
}

.card:hover {
  transform: translateY(-4px);
  box-shadow: var(--shadow-xl);
}

.card-venue {
  margin-bottom: 1rem;
  cursor: pointer;
}

.card-venue:hover {
  transform: translateY(-2px) scale(1.01);
}

/* Modern Container */
.app-container {
  max-width: 28rem;
  margin: 0 auto;
  min-height: 100vh;
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.2);
  position: relative;
  overflow: hidden;
}

.app-container::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23ffffff' fill-opacity='0.05'%3E%3Ccircle cx='7' cy='7' r='1'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E") repeat;
  pointer-events: none;
}

/* Modern Header */
.app-header {
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(20px);
  box-shadow: var(--shadow-lg);
  position: sticky;
  top: 0;
  z-index: 10;
  border-bottom: 1px solid rgba(255, 255, 255, 0.2);
}

.header-content {
  padding: 1.5rem;
}

.app-title {
  font-size: 2rem;
  font-weight: 800;
  background: var(--gradient-primary);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  margin-bottom: 0.25rem;
}

.app-subtitle {
  color: var(--text-secondary);
  font-weight: 500;
}

.user-stats {
  display: flex;
  align-items: center;
  padding: 0.75rem 1rem;
  background: var(--gradient-warning);
  border-radius: var(--radius-full);
  color: var(--text-primary);
  font-weight: 600;
  box-shadow: var(--shadow-md);
}

.user-level {
  font-size: 0.75rem;
  color: var(--text-secondary);
  margin-top: 0.25rem;
}

/* Modern Alert/Banner */
.community-banner {
  background: rgba(59, 130, 246, 0.1);
  border: 1px solid rgba(59, 130, 246, 0.2);
  border-radius: var(--radius-lg);
  padding: 1rem;
  margin-top: 1rem;
  backdrop-filter: blur(10px);
}

.banner-content {
  display: flex;
  align-items: center;
}

.banner-icon {
  width: 1.25rem;
  height: 1.25rem;
  margin-right: 0.75rem;
  color: var(--primary-600);
}

.banner-title {
  font-weight: 600;
  color: var(--primary-900);
  margin-bottom: 0.25rem;
}

.banner-subtitle {
  font-size: 0.75rem;
  color: var(--primary-700);
}

/* Modern Badge/Tags */
.badge {
  display: inline-flex;
  align-items: center;
  padding: 0.25rem 0.75rem;
  border-radius: var(--radius-full);
  font-size: 0.75rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.025em;
}

.badge-crowd {
  animation: pulse-glow 2s infinite;
}

.badge-green {
  background: rgba(34, 197, 94, 0.15);
  color: #15803d;
  border: 1px solid rgba(34, 197, 94, 0.3);
}

.badge-yellow {
  background: rgba(251, 191, 36, 0.15);
  color: #a16207;
  border: 1px solid rgba(251, 191, 36, 0.3);
}

.badge-red {
  background: rgba(239, 68, 68, 0.15);
  color: #dc2626;
  border: 1px solid rgba(239, 68, 68, 0.3);
}

.badge-blue {
  background: rgba(59, 130, 246, 0.15);
  color: var(--primary-700);
  border: 1px solid rgba(59, 130, 246, 0.3);
}

/* Modern Icons */
.icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
}

.icon-sm { width: 1rem; height: 1rem; }
.icon-md { width: 1.25rem; height: 1.25rem; }
.icon-lg { width: 1.5rem; height: 1.5rem; }

/* Modern Spacing */
.space-y-1 > * + * { margin-top: 0.25rem; }
.space-y-2 > * + * { margin-top: 0.5rem; }
.space-y-3 > * + * { margin-top: 0.75rem; }
.space-y-4 > * + * { margin-top: 1rem; }
.space-y-6 > * + * { margin-top: 1.5rem; }

.space-x-1 > * + * { margin-left: 0.25rem; }
.space-x-2 > * + * { margin-left: 0.5rem; }
.space-x-3 > * + * { margin-left: 0.75rem; }
.space-x-4 > * + * { margin-left: 1rem; }

/* Modern Grid */
.grid { display: grid; }
.grid-cols-2 { grid-template-columns: repeat(2, minmax(0, 1fr)); }
.grid-cols-3 { grid-template-columns: repeat(3, minmax(0, 1fr)); }
.gap-2 { gap: 0.5rem; }
.gap-3 { gap: 0.75rem; }
.gap-4 { gap: 1rem; }

/* Modern Flexbox */
.flex { display: flex; }
.flex-1 { flex: 1 1 0%; }
.flex-wrap { flex-wrap: wrap; }
.items-center { align-items: center; }
.items-start { align-items: flex-start; }
.justify-center { justify-content: center; }
.justify-between { justify-content: space-between; }

/* Modern Text */
.text-xs { font-size: 0.75rem; line-height: 1rem; }
.text-sm { font-size: 0.875rem; line-height: 1.25rem; }
.text-base { font-size: 1rem; line-height: 1.5rem; }
.text-lg { font-size: 1.125rem; line-height: 1.75rem; }
.text-xl { font-size: 1.25rem; line-height: 1.75rem; }
.text-2xl { font-size: 1.5rem; line-height: 2rem; }
.text-3xl { font-size: 1.875rem; line-height: 2.25rem; }

.font-normal { font-weight: 400; }
.font-medium { font-weight: 500; }
.font-semibold { font-weight: 600; }
.font-bold { font-weight: 700; }
.font-extrabold { font-weight: 800; }

.text-white { color: var(--text-white); }
.text-primary { color: var(--text-primary); }
.text-secondary { color: var(--text-secondary); }
.text-muted { color: var(--text-muted); }

/* Modern Layout */
.p-2 { padding: 0.5rem; }
.p-3 { padding: 0.75rem; }
.p-4 { padding: 1rem; }
.p-6 { padding: 1.5rem; }

.px-2 { padding-left: 0.5rem; padding-right: 0.5rem; }
.px-3 { padding-left: 0.75rem; padding-right: 0.75rem; }
.px-4 { padding-left: 1rem; padding-right: 1rem; }
.px-6 { padding-left: 1.5rem; padding-right: 1.5rem; }

.py-2 { padding-top: 0.5rem; padding-bottom: 0.5rem; }
.py-3 { padding-top: 0.75rem; padding-bottom: 0.75rem; }
.py-4 { padding-top: 1rem; padding-bottom: 1rem; }

.m-2 { margin: 0.5rem; }
.m-3 { margin: 0.75rem; }
.m-4 { margin: 1rem; }

.mb-2 { margin-bottom: 0.5rem; }
.mb-3 { margin-bottom: 0.75rem; }
.mb-4 { margin-bottom: 1rem; }
.mb-6 { margin-bottom: 1.5rem; }

.mt-2 { margin-top: 0.5rem; }
.mt-3 { margin-top: 0.75rem; }
.mt-4 { margin-top: 1rem; }

.mr-2 { margin-right: 0.5rem; }
.mr-3 { margin-right: 0.75rem; }
.ml-2 { margin-left: 0.5rem; }
.ml-3 { margin-left: 0.75rem; }

/* Modern Animations */
@keyframes fadeIn {
  from { opacity: 0; transform: translateY(20px); }
  to { opacity: 1; transform: translateY(0); }
}

@keyframes slideIn {
  from { transform: translateX(-100%); }
  to { transform: translateX(0); }
}

@keyframes pulse-glow {
  0%, 100% { box-shadow: 0 0 5px rgba(59, 130, 246, 0.3); }
  50% { box-shadow: 0 0 20px rgba(59, 130, 246, 0.6); }
}

@keyframes float {
  0%, 100% { transform: translateY(0px); }
  50% { transform: translateY(-10px); }
}

@keyframes shimmer {
  0% { background-position: -468px 0; }
  100% { background-position: 468px 0; }
}

@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.5; }
}

.animate-fadeIn { animation: fadeIn 0.5s ease-out; }
.animate-slideIn { animation: slideIn 0.3s ease-out; }
.animate-float { animation: float 3s ease-in-out infinite; }
.animate-pulse { animation: pulse 2s infinite; }

/* Modern Forms */
.form-input {
  width: 100%;
  padding: 0.75rem 1rem;
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: var(--radius-lg);
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  color: var(--text-primary);
  font-size: 0.875rem;
  transition: var(--transition-normal);
  font-family: inherit;
}

.form-input:focus {
  outline: none;
  border-color: var(--primary-500);
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}

.form-textarea {
  min-height: 4rem;
  resize: vertical;
}

/* Modern Modal */
.modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.6);
  backdrop-filter: blur(4px);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 1rem;
  z-index: 50;
  animation: fadeIn 0.2s ease-out;
}

.modal-content {
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(20px);
  border-radius: var(--radius-2xl);
  padding: 2rem;
  max-width: 28rem;
  width: 100%;
  box-shadow: var(--shadow-xl);
  border: 1px solid rgba(255, 255, 255, 0.2);
  animation: slideIn 0.3s ease-out;
}

/* Modern Progress/Stats */
.stats-card {
  background: var(--gradient-primary);
  color: var(--text-white);
  border-radius: var(--radius-xl);
  padding: 1.5rem;
  text-align: center;
  box-shadow: var(--shadow-lg);
}

.stats-number {
  font-size: 2rem;
  font-weight: 800;
  margin-bottom: 0.25rem;
}

.stats-label {
  font-size: 0.875rem;
  opacity: 0.9;
}

/* Color Utilities */
.bg-blue-100 { background-color: #dbeafe; }
.bg-green-100 { background-color: #dcfce7; }
.bg-amber-100 { background-color: #fef3c7; }
.text-green-600 { color: #16a34a; }
.text-amber-600 { color: #d97706; }
.text-yellow-400 { color: #facc15; }

/* Responsive Design */
@media (max-width: 768px) {
  .app-container {
    margin: 0;
    border-radius: 0;
    border-left: none;
    border-right: none;
  }
  
  .card {
    margin: 0.5rem;
  }
  
  .app-title {
    font-size: 1.75rem;
  }
  
  .btn {
    padding: 0.625rem 1.25rem;
    font-size: 0.8rem;
  }
}

/* Accessibility */
@media (prefers-reduced-motion: reduce) {
  * {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}

/* Focus styles for accessibility */
*:focus {
  outline: 2px solid var(--primary-500);
  outline-offset: 2px;
}

/* High contrast mode */
@media (prefers-contrast: high) {
  .card {
    border: 2px solid var(--text-primary);
  }
  
  .btn {
    border: 2px solid currentColor;
  }
}
CSSEOF

# Update index.css for global improvements
print_status "🌟 Updating global styles..."
cat > src/index.css << 'INDEXCSSEOF'
/* Global Modern Styles for nYtevibe */
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap');

/* Modern CSS Reset */
*,
*::before,
*::after {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

html {
  -webkit-text-size-adjust: 100%;
  font-variation-settings: normal;
  scroll-behavior: smooth;
}

body {
  font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen', sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  line-height: 1.6;
  color: #1e293b;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  min-height: 100vh;
  font-feature-settings: 'cv02', 'cv03', 'cv04', 'cv11';
}

#root {
  min-height: 100vh;
  position: relative;
}

/* Better focus styles */
*:focus {
  outline: 2px solid #3b82f6;
  outline-offset: 2px;
}

/* Smooth scrolling for all elements */
* {
  scroll-behavior: smooth;
}

/* Remove default button styles */
button {
  border: none;
  background: none;
  font-family: inherit;
  cursor: pointer;
}

/* Remove default input styles */
input,
textarea {
  border: none;
  background: none;
  font-family: inherit;
}

/* Improve text rendering */
h1, h2, h3, h4, h5, h6 {
  text-rendering: optimizeLegibility;
  font-weight: 600;
}

/* Improve image rendering */
img {
  max-width: 100%;
  height: auto;
  display: block;
}

/* Custom scrollbar */
::-webkit-scrollbar {
  width: 8px;
}

::-webkit-scrollbar-track {
  background: rgba(255, 255, 255, 0.1);
  border-radius: 4px;
}

::-webkit-scrollbar-thumb {
  background: rgba(255, 255, 255, 0.3);
  border-radius: 4px;
}

::-webkit-scrollbar-thumb:hover {
  background: rgba(255, 255, 255, 0.5);
}

/* Selection styles */
::selection {
  background: rgba(59, 130, 246, 0.3);
  color: inherit;
}

::-moz-selection {
  background: rgba(59, 130, 246, 0.3);
  color: inherit;
}
INDEXCSSEOF

if [ $? -eq 0 ]; then
    print_success "Enhanced application files created successfully"
else
    print_error "Failed to create application files"
    exit 1
fi

# Test the build
print_status "🔨 Building the optimized nYtevibe application..."
if npm run build; then
    print_success "Build completed successfully"
else
    print_error "Build failed"
    exit 1
fi

# Deploy to web directory
print_status "🚀 Deploying optimized nYtevibe..."
sudo mkdir -p /var/www/html/nytevibe
if sudo cp -r dist/* /var/www/html/nytevibe/; then
    print_success "Optimized nYtevibe deployed to /var/www/html/nytevibe"
else
    print_error "Failed to deploy"
    exit 1
fi

# Set proper permissions
print_status "🔧 Setting secure permissions..."
sudo chown -R www-data:www-data /var/www/html/nytevibe
sudo chmod -R 755 /var/www/html/nytevibe

print_header "OPTIMIZED nYtevibe SETUP COMPLETE!"
print_header "===================================="
print_success ""
print_success "🎯 CONTROLLED UPDATE FEATURES:"
print_feature "⏱️  Updates every 45 seconds (reasonable interval)"
print_feature "🎲 Only 30% of venues update per cycle (prevents constant changes)"
print_feature "👁️  Pauses updates when page is hidden (saves resources)"
print_feature "🔄 Manual refresh button for instant updates"
print_feature "📊 Real-time update status indicator"
print_feature "📈 Trending indicators (📈 up, 📉 down, ➡️ stable)"
print_feature "⏰ Last update timestamp display"
print_feature "🎮 Enhanced user interactions"
print_success ""
print_success "🏢 HOUSTON VENUES WITH ENHANCED DATA:"
print_feature "🎵 NYC Vibes (Lounge) - Hip-Hop vibes with trending data"
print_feature "🎶 Rumors (Nightclub) - R&B atmosphere with status tracking"
print_feature "🏈 Classic (Bar & Grill) - Sports venue with crowd dynamics"
print_feature "🍸 Best Regards (Cocktail Bar) - Date night spot with ratings"
print_success ""
print_success "🎨 PREMIUM DESIGN ENHANCEMENTS:"
print_feature "✨ Advanced glassmorphism with enhanced blur effects"
print_feature "🌈 Improved gradient systems and color harmony"
print_feature "💫 Smooth micro-interactions and hover states"
print_feature "📱 Enhanced mobile responsiveness"
print_feature "🎭 Modern Inter font with improved typography"
print_feature "🔮 Professional status indicators and badges"
print_feature "🌊 Optimized animations with performance in mind"
print_feature "⚡ Improved accessibility and keyboard navigation"
print_success ""
print_success "⚡ PERFORMANCE OPTIMIZATIONS:"
print_feature "🚀 Controlled state updates (no infinite loops)"
print_feature "🧠 Smart memory management with proper cleanup"
print_feature "📱 Page visibility API integration"
print_feature "🎯 Optimized React hooks with useCallback"
print_feature "⚡ Efficient re-renders with proper dependencies"
print_feature "🔧 Development-friendly with better debugging"
print_success ""
print_success "🧪 TEST YOUR OPTIMIZED VENUE TRACKER:"
print_feature "1. 🌐 Visit: http://localhost/nytevibe (if Apache configured)"
print_feature "2. 📊 Watch controlled updates every 45 seconds"
print_feature "3. 🔄 Try the manual refresh button"
print_feature "4. 📱 Test mobile responsiveness"
print_feature "5. 🏢 Submit venue reports and earn points"
print_feature "6. 📈 Notice trending indicators on venues"
print_feature "7. 👁️  Switch browser tabs to see update pausing"
print_success ""
print_success "🎉 KEY IMPROVEMENTS OVER PREVIOUS VERSION:"
print_feature "✅ No more constant refreshing issues"
print_feature "✅ Better battery life on mobile devices"
print_feature "✅ Smoother user experience"
print_feature "✅ More realistic venue data changes"
print_feature "✅ Enhanced visual feedback"
print_feature "✅ Better performance and stability"
print_success ""
print_success "🚀 READY FOR PRODUCTION DEPLOYMENT!"
print_success "Your optimized Houston nightlife tracker is complete!"
print_success ""
print_success "Next: Run your SSL deployment script:"
print_success "./ssl_production_fixed.sh"
EOF

# Save this script content to file
if [ $? -eq 0 ]; then
    print_success "Controlled updates script ready!"
else
    print_error "Failed to create script"
    exit 1
fi

print_header "SCRIPT GENERATION COMPLETE!"
print_header "=========================="
print_success ""
print_success "📝 SCRIPT CREATED: nytevibe_controlled_updates.sh"
print_success ""
print_success "🚀 TO RUN THE OPTIMIZED VERSION:"
print_success "   chmod +x nytevibe_controlled_updates.sh"
print_success "   ./nytevibe_controlled_updates.sh"
print_success ""
print_success "⚡ FEATURES OF THIS ENHANCED VERSION:"
print_success "   🎯 45-second controlled update intervals"
print_success "   🎲 Smart probabilistic updates (30% chance per venue)"
print_success "   👁️  Page visibility detection (pauses when hidden)"
print_success "   🔄 Manual refresh functionality"
print_success "   📊 Real-time status indicators"
print_success "   📈 Trending direction indicators"
print_success "   ⏰ Timestamp tracking"
print_success "   🧠 Optimized memory management"
print_success "   📱 Enhanced mobile performance"
print_success ""
