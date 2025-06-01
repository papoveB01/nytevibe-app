import { useApp } from '../context/AppContext';

export const useVenues = () => {
  const { state, actions } = useApp();

  const isVenueFollowed = (venueId) => {
    return state.userProfile.followedVenues.includes(venueId);
  };

  const toggleFollow = (venue) => {
    const isCurrentlyFollowed = isVenueFollowed(venue.id);
    
    if (isCurrentlyFollowed) {
      actions.unfollowVenue(venue.id, venue.name);
      actions.addNotification({
        type: 'default',
        message: `💔 Unfollowed ${venue.name} (-2 points)`
      });
    } else {
      actions.followVenue(venue.id, venue.name);
      actions.addNotification({
        type: 'success',
        message: `❤️ Following ${venue.name} (+3 points)`
      });
    }
  };

  const updateVenueData = () => {
    actions.updateVenueData();
  };

  const getFilteredVenues = (searchQuery, filter) => {
    let filteredVenues = state.venues;

    // Apply text search
    if (searchQuery.trim()) {
      const query = searchQuery.toLowerCase();
      filteredVenues = filteredVenues.filter(venue =>
        venue.name.toLowerCase().includes(query) ||
        venue.type.toLowerCase().includes(query) ||
        venue.city.toLowerCase().includes(query) ||
        venue.vibe.some(v => v.toLowerCase().includes(query))
      );
    }

    // Apply filters
    switch (filter) {
      case 'following':
        filteredVenues = filteredVenues.filter(venue => 
          state.userProfile.followedVenues.includes(venue.id)
        );
        break;
      case 'nearby':
        filteredVenues = filteredVenues.filter(venue => 
          parseFloat(venue.distance) <= 0.5
        );
        break;
      case 'open':
        filteredVenues = filteredVenues.filter(venue => venue.isOpen);
        break;
      case 'promotions':
        filteredVenues = filteredVenues.filter(venue => venue.hasPromotion);
        break;
      default:
        break;
    }

    return filteredVenues;
  };

  return {
    venues: state.venues,
    isVenueFollowed,
    toggleFollow,
    updateVenueData,
    getFilteredVenues
  };
};
