import { useApp } from '../context/AppContext';

export const useVenues = () => {
  try {
    const { state, actions } = useApp();
    
    const isVenueFollowed = (venueId) => {
      try {
        return state.userProfile?.followedVenues?.includes(venueId) || false;
      } catch (error) {
        console.error('❌ isVenueFollowed error:', error);
        return false;
      }
    };

    const toggleFollow = (venue) => {
      try {
        const isFollowed = isVenueFollowed(venue.id);
        
        if (isFollowed) {
          actions.addNotification({
            type: 'success',
            message: `💔 Unfollowed ${venue.name} (-2 points)`
          });
        } else {
          actions.addNotification({
            type: 'success', 
            message: `❤️ Following ${venue.name} (+3 points)`
          });
        }
      } catch (error) {
        console.error('❌ toggleFollow error:', error);
        actions.addNotification({
          type: 'error',
          message: 'Follow action failed. Please try again.'
        });
      }
    };

    const updateVenueData = () => {
      try {
        // Simulate venue data updates
        console.log('🔄 Updating venue data...');
      } catch (error) {
        console.error('❌ updateVenueData error:', error);
      }
    };

    return {
      isVenueFollowed,
      toggleFollow,
      updateVenueData
    };
  } catch (error) {
    console.error('❌ useVenues hook error:', error);
    
    // Safe fallback
    return {
      isVenueFollowed: () => false,
      toggleFollow: () => {},
      updateVenueData: () => {}
    };
  }
};
