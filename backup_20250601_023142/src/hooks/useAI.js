import { useApp } from '../context/AppContext';

export const useAI = () => {
  const { state } = useApp();

  const getRecommendations = (userPreferences = {}) => {
    try {
      // Simple AI recommendation logic based on user's followed venues
      const followedVenues = state.venues.filter(venue => 
        state.userProfile.followedVenues.includes(venue.id)
      );

      const unfollowedVenues = state.venues.filter(venue => 
        !state.userProfile.followedVenues.includes(venue.id)
      );

      // Get common vibes from followed venues
      const commonVibes = followedVenues.reduce((vibes, venue) => {
        venue.vibe.forEach(v => {
          vibes[v] = (vibes[v] || 0) + 1;
        });
        return vibes;
      }, {});

      // Recommend venues with similar vibes
      const recommendations = unfollowedVenues
        .map(venue => ({
          ...venue,
          score: venue.vibe.reduce((score, vibe) => {
            return score + (commonVibes[vibe] || 0);
          }, 0) + venue.rating // Add rating boost
        }))
        .filter(venue => venue.score > 0)
        .sort((a, b) => b.score - a.score)
        .slice(0, 3);

      return recommendations;
    } catch (error) {
      console.error('Error getting AI recommendations:', error);
      return [];
    }
  };

  const getPersonalizedMessage = () => {
    try {
      const timeOfDay = new Date().getHours();
      const userName = state.userProfile.firstName;
      
      if (timeOfDay < 12) {
        return `Good morning, ${userName}! Ready to discover some new spots?`;
      } else if (timeOfDay < 18) {
        return `Good afternoon, ${userName}! What's your vibe today?`;
      } else {
        return `Good evening, ${userName}! Let's find your perfect night out!`;
      }
    } catch (error) {
      return "Ready to discover something new?";
    }
  };

  return {
    getRecommendations,
    getPersonalizedMessage
  };
};
