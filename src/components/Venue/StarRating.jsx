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

  const containerClasses = {
    sm: 'gap-1',
    md: 'gap-2',
    lg: 'gap-2'
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
        } ${interactive ? 'cursor-pointer hover:text-yellow-500 transition-colors' : ''}`}
        onClick={interactive ? () => onRate?.(starNumber) : undefined}
      />
    );
  });

  return (
    <div className={`star-rating-container flex items-center ${containerClasses[size]}`}>
      <div className="star-rating flex items-center gap-1">
        {stars}
      </div>
      {showCount && totalRatings > 0 && (
        <span className={`rating-count text-gray-600 font-medium ${
          size === 'sm' ? 'text-xs' : size === 'lg' ? 'text-base' : 'text-sm'
        }`}>
          {rating.toFixed(1)} ({totalRatings} {totalRatings === 1 ? 'review' : 'reviews'})
        </span>
      )}
    </div>
  );
};

export default StarRating;
