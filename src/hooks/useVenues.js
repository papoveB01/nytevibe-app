import { useCallback } from 'react';
import { useApp } from '../context/AppContext';

export const useVenues = () => {
  const { state, actions } = useApp();

  const updateVenueData = useCallback(() => {
    actions.updateVenueData();
  }, [actions]);

  const isVenueFollowed = useCallback((venueId) => {
    return state.userProfile.followedVenues.includes(venueId);
  }, [state.userProfile.followedVenues]);

  const followVenue = useCallback((venue) => {
    if (!isVenueFollowed(venue.id)) {
      actions.followVenue(venue.id, venue.name);
      actions.addNotification({
        type: 'follow',
        message: `Following ${venue.name}`,
        duration: 3000
      });
    }
  }, [actions, isVenueFollowed]);

  const unfollowVenue = useCallback((venue) => {
    if (isVenueFollowed(venue.id)) {
      actions.unfollowVenue(venue.id, venue.name);
      actions.addNotification({
        type: 'unfollow',
        message: `Unfollowed ${venue.name}`,
        duration: 3000
      });
    }
  }, [actions, isVenueFollowed]);

  const toggleFollow = useCallback((venue) => {
    if (isVenueFollowed(venue.id)) {
      unfollowVenue(venue);
    } else {
      followVenue(venue);
    }
  }, [isVenueFollowed, followVenue, unfollowVenue]);

  return {
    venues: state.venues,
    selectedVenue: state.selectedVenue,
    updateVenueData,
    isVenueFollowed,
    followVenue,
    unfollowVenue,
    toggleFollow
  };
};
