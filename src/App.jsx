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
