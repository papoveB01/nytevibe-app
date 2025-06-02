import { useApp } from '../context/AppContext';

export const useVenues = () => {
  const { state, actions } = useApp();
  
  const filteredVenues = state.venues.filter(venue =>
    venue.name.toLowerCase().includes(state.searchQuery.toLowerCase()) ||
    venue.type.toLowerCase().includes(state.searchQuery.toLowerCase()) ||
    venue.vibe.some(v => v.toLowerCase().includes(state.searchQuery.toLowerCase()))
  );
  
  const isVenueFollowed = (venueId) => {
    return state.userProfile.favoriteVenues.includes(venueId);
  };
  
  const getVenueById = (venueId) => {
    return state.venues.find(venue => venue.id === venueId);
  };
  
  return {
    venues: filteredVenues,
    allVenues: state.venues,
    isVenueFollowed,
    getVenueById,
    toggleFollow: actions.toggleVenueFollow,
    updateVenueData: actions.updateVenueData
  };
};
