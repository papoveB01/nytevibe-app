import { useState, useCallback } from 'react';
import { useApp } from '../context/AppContext';

export const useAI = () => {
  const { state } = useApp();
  const [isLoading, setIsLoading] = useState(false);

  const getRecommendations = useCallback(async (userPreferences) => {
    setIsLoading(true);
    
    // Simulate AI recommendation logic
    setTimeout(() => {
      setIsLoading(false);
    }, 1000);
    
    return state.venues.filter(venue => 
      venue.rating >= 4.0 && !state.userProfile.followedVenues.includes(venue.id)
    ).slice(0, 3);
  }, [state.venues, state.userProfile.followedVenues]);

  return {
    getRecommendations,
    isLoading
  };
};
