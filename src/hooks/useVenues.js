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
        message: `Following ${venue.name} (+3 points!)`,
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

  const getFilteredVenues = useCallback((searchQuery, filter) => {
    let filtered = state.venues;

    // Apply search filter
    if (searchQuery.trim()) {
      const query = searchQuery.toLowerCase();
      filtered = filtered.filter(venue =>
        venue.name.toLowerCase().includes(query) ||
        venue.type.toLowerCase().includes(query) ||
        venue.city.toLowerCase().includes(query) ||
        venue.vibe.some(v => v.toLowerCase().includes(query))
      );
    }

    // Apply category filter
    switch (filter) {
      case 'followed':
        filtered = filtered.filter(venue => isVenueFollowed(venue.id));
        break;
      case 'nearby':
        filtered = filtered.filter(venue => parseFloat(venue.distance) <= 0.5);
        break;
      case 'open':
        filtered = filtered.filter(venue => venue.isOpen);
        break;
      case 'promotions':
        filtered = filtered.filter(venue => venue.hasPromotion);
        break;
      default:
        // 'all' - no additional filtering
        break;
    }

    return filtered;
  }, [state.venues, isVenueFollowed]);

  return {
    venues: state.venues,
    selectedVenue: state.selectedVenue,
    updateVenueData,
    isVenueFollowed,
    followVenue,
    unfollowVenue,
    toggleFollow,
    getFilteredVenues
  };
};
