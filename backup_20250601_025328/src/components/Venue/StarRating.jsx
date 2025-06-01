import React from 'react';
import { Star } from 'lucide-react';

const StarRating = ({ 
  rating = 0, 
  size = 'md', 
  showCount = false, 
  totalRatings = 0,
  interactive = false,
  onRatingChange = null 
}) => {
  const fullStars = Math.floor(rating);
  const hasHalfStar = rating % 1 >= 0.5;
  const emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

  const sizeClasses = {
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

  const renderStar = (type, index) => {
    const classes = [
      'star-rating-icon',
      sizeClasses[size],
      type === 'full' ? 'text-yellow-400 fill-current' : 
      type === 'half' ? 'text-yellow-400' : 'text-gray-300',
      interactive ? 'cursor-pointer hover:scale-110 transition-transform' : ''
    ].filter(Boolean).join(' ');

    return (
      <Star
        key={`${type}-${index}`}
        className={classes}
        onClick={() => handleStarClick(index + 1)}
      />
    );
  };

  return (
    <div className="star-rating">
      <div className="flex items-center gap-1">
        {/* Full stars */}
        {Array.from({ length: fullStars }, (_, i) => renderStar('full', i))}
        
        {/* Half star */}
        {hasHalfStar && (
          <div className="relative">
            <Star className={`${sizeClasses[size]} text-gray-300`} />
            <div className="absolute inset-0 overflow-hidden" style={{ width: '50%' }}>
              <Star className={`${sizeClasses[size]} text-yellow-400 fill-current`} />
            </div>
          </div>
        )}
        
        {/* Empty stars */}
        {Array.from({ length: emptyStars }, (_, i) => renderStar('empty', fullStars + (hasHalfStar ? 1 : 0) + i))}
      </div>
      
      {showCount && totalRatings > 0 && (
        <span className="rating-count text-sm text-gray-600 ml-2">
          ({totalRatings} review{totalRatings !== 1 ? 's' : ''})
        </span>
      )}
      
      {!showCount && size !== 'sm' && (
        <span className="rating-value text-sm text-gray-600 ml-2">
          {rating.toFixed(1)}
        </span>
      )}
    </div>
  );
};

export default StarRating;
