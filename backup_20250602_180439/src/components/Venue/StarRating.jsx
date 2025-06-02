import React from 'react';
import { Star } from 'lucide-react';

const StarRating = ({ rating = 0, size = 'sm', showCount = false, totalRatings = 0 }) => {
  const numRating = parseFloat(rating) || 0;
  const numTotalRatings = parseInt(totalRatings) || 0;
  
  const getStarSize = () => {
    switch (size) {
      case 'xs': return 12;
      case 'sm': return 14;
      case 'md': return 16;
      case 'lg': return 18;
      case 'xl': return 20;
      default: return 14;
    }
  };

  const starSize = getStarSize();

  const renderStars = () => {
    const stars = [];
    for (let i = 1; i <= 5; i++) {
      const isFilled = i <= Math.floor(numRating);
      const isHalfFilled = i === Math.ceil(numRating) && numRating % 1 !== 0;
      
      stars.push(
        <div key={i} className="star-wrapper" style={{ position: 'relative' }}>
          <Star 
            size={starSize} 
            className="star-background"
            style={{ color: '#e5e7eb' }}
          />
          {(isFilled || isHalfFilled) && (
            <Star 
              size={starSize} 
              className="star-filled"
              style={{ 
                position: 'absolute',
                top: 0,
                left: 0,
                color: '#fbbf24',
                clipPath: isHalfFilled ? 'inset(0 50% 0 0)' : 'none'
              }}
              fill="currentColor"
            />
          )}
        </div>
      );
    }
    return stars;
  };

  return (
    <div className={`star-rating star-rating-${size}`}>
      <div className="stars-container" style={{ display: 'flex', gap: '2px' }}>
        {renderStars()}
      </div>
      {showCount && numTotalRatings > 0 && (
        <span className="rating-count" style={{ marginLeft: '6px', fontSize: '0.8rem', color: '#6b7280' }}>
          ({numTotalRatings})
        </span>
      )}
    </div>
  );
};

export default StarRating;
