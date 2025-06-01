import React from 'react';
import { Star } from 'lucide-react';

const StarRating = ({ 
  rating, 
  size = 'md', 
  showCount = false, 
  totalRatings = 0,
  interactive = false,
  onRatingChange = null
}) => {
  const sizeClasses = {
    sm: 'w-3 h-3',
    md: 'w-4 h-4', 
    lg: 'w-5 h-5'
  };

  const starClass = sizeClasses[size];
  const fullStars = Math.floor(rating);
  const hasHalfStar = rating % 1 !== 0;

  const handleStarClick = (starRating) => {
    if (interactive && onRatingChange) {
      onRatingChange(starRating);
    }
  };

  return (
    <div className="star-rating">
      <div className="stars-container">
        {[1, 2, 3, 4, 5].map((star) => (
          <Star
            key={star}
            className={`${starClass} ${
              star <= fullStars ? 'text-yellow-400 fill-current' : 
              star === fullStars + 1 && hasHalfStar ? 'text-yellow-400 fill-current opacity-50' :
              'text-gray-300'
            } ${interactive ? 'cursor-pointer hover:text-yellow-400' : ''}`}
            onClick={() => handleStarClick(star)}
          />
        ))}
      </div>
      {showCount && totalRatings > 0 && (
        <span className="rating-count">({totalRatings})</span>
      )}
    </div>
  );
};

export default StarRating;
