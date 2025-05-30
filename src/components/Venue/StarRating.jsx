import React from 'react';
import { Star } from 'lucide-react';

const StarRating = ({ 
  rating = 0, 
  size = 'md', 
  showCount = false, 
  totalRatings = 0,
  interactive = false,
  onRate = null 
}) => {
  const sizeClasses = {
    sm: 'w-3 h-3',
    md: 'w-4 h-4',
    lg: 'w-5 h-5'
  };

  const stars = Array.from({ length: 5 }, (_, index) => {
    const starNumber = index + 1;
    const isFilled = starNumber <= Math.floor(rating);
    const isHalfFilled = starNumber === Math.ceil(rating) && rating % 1 !== 0;

    return (
      <Star
        key={index}
        className={`${sizeClasses[size]} ${
          isFilled || isHalfFilled ? 'fill-current text-yellow-400' : 'text-gray-300'
        } ${interactive ? 'cursor-pointer hover:text-yellow-500' : ''}`}
        onClick={interactive ? () => onRate?.(starNumber) : undefined}
      />
    );
  });

  return (
    <div className="star-rating-container">
      <div className="star-rating">
        {stars}
      </div>
      {showCount && totalRatings > 0 && (
        <span className="rating-count">
          {rating.toFixed(1)} ({totalRatings})
        </span>
      )}
    </div>
  );
};

export default StarRating;
