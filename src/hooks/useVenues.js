import { useApp } from '../context/AppContext';

export const useVenues = () => {
  const { state, actions } = useApp();
  
  // 🛡️ ULTRA-SAFE: Defensive filtering with comprehensive null checks
  const filteredVenues = (state.venues || []).filter(venue => {
    // Early return if venue is invalid
    if (!venue) return false;
    
    // Get search query safely
    const searchQuery = state.searchQuery || '';
    
    // If no search query, include all venues
    if (!searchQuery) return true;
    
    // Safe search query processing
    const safeSearchQuery = searchQuery.toLowerCase();
    
    // Safe venue name check
    const nameMatch = venue.name && typeof venue.name === 'string' 
      ? venue.name.toLowerCase().includes(safeSearchQuery) 
      : false;
    
    // Safe venue type check  
    const typeMatch = venue.type && typeof venue.type === 'string'
      ? venue.type.toLowerCase().includes(safeSearchQuery)
      : false;
    
    // Safe venue vibe check
    const vibeMatch = Array.isArray(venue.vibe) 
      ? venue.vibe.some(v => v && typeof v === 'string' && v.toLowerCase().includes(safeSearchQuery))
      : false;
    
    return nameMatch || typeMatch || vibeMatch;
  });
  
  // 🛡️ ULTRA-SAFE: Safe venue following check
  const isVenueFollowed = (venueId) => {
    // Comprehensive safety checks
    if (!venueId || !state || !state.userProfile) {
      return false;
    }
    
    // Check if favoriteVenues exists and is an array
    const favoriteVenues = state.userProfile.favoriteVenues;
    if (!Array.isArray(favoriteVenues)) {
      return false;
    }
    
    return favoriteVenues.includes(venueId);
  };
  
  // 🛡️ ULTRA-SAFE: Safe venue lookup
  const getVenueById = (venueId) => {
    if (!venueId || !Array.isArray(state.venues)) {
      return null;
    }
    return state.venues.find(venue => venue && venue.id === venueId) || null;
  };
  
  return {
    venues: filteredVenues,
    allVenues: state.venues || [],
    isVenueFollowed,
    getVenueById,
    toggleFollow: actions ? actions.toggleVenueFollow : () => {},
    updateVenueData: actions ? actions.updateVenueData : () => {}
  };
};
