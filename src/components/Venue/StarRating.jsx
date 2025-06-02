import React from 'react';
import { Star } from 'lucide-react';

const StarRating = ({ rating, size = 'sm', showCount = false, totalRatings = 0, interactive = false, onRatingChange }) => {
  const sizes = {
    sm: 'w-3 h-3',
    md: 'w-4 h-4',
    lg: 'w-5 h-5',
    xl: 'w-6 h-6'
  };

  const handleStarClick = (starRating) => {
    if (interactive && onRatingChange) {
      onRatingChange(starRating);
    }
  };

  return (
    <div className="star-rating">
      <div className="stars">
        {[1, 2, 3, 4, 5].map((star) => (
          <Star
            key={star}
            className={`${sizes[size]} ${
              star <= rating
                ? 'text-yellow-400 fill-current'
                : 'text-gray-300'
            } ${interactive ? 'cursor-pointer hover:text-yellow-400' : ''}`}
            onClick={() => handleStarClick(star)}
          />
        ))}
      </div>
      {showCount && totalRatings > 0 && (
        <span className="rating-text">
          {rating.toFixed(1)} ({totalRatings} reviews)
        </span>
      )}
    </div>
  );
};

export default StarRating;
