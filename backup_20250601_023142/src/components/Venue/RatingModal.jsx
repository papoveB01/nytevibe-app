import React, { useState } from 'react';
import { X, Star } from 'lucide-react';
import { useApp } from '../../context/AppContext';
import StarRating from './StarRating';

const RatingModal = () => {
  const { state, actions } = useApp();
  const [rating, setRating] = useState(0);
  const [comment, setComment] = useState('');
  const [hoveredRating, setHoveredRating] = useState(0);

  const handleSubmit = () => {
    if (rating > 0 && state.selectedVenue) {
      // Handle rating submission
      actions.addNotification({
        type: 'success',
        message: `✅ Rating submitted! +5 points earned`
      });

      // Close modal and reset form
      actions.setShowRatingModal(false);
      setRating(0);
      setComment('');
      setHoveredRating(0);
    }
  };

  const handleClose = () => {
    actions.setShowRatingModal(false);
    setRating(0);
    setComment('');
    setHoveredRating(0);
  };

  const getRatingLabel = (rating) => {
    const labels = {
      1: 'Poor',
      2: 'Fair',
      3: 'Good',
      4: 'Very Good',
      5: 'Excellent'
    };
    return labels[rating] || '';
  };

  if (!state.showRatingModal) return null;

  return (
    <div className="modal-overlay" onClick={handleClose}>
      <div className="modal-content rating-modal" onClick={(e) => e.stopPropagation()}>
        <div className="modal-header">
          <h3 className="modal-title">
            Rate {state.selectedVenue?.name || 'Venue'}
          </h3>
          <button onClick={handleClose} className="modal-close">
            <X className="w-4 h-4" />
          </button>
        </div>

        <div className="modal-body">
          <div className="rating-section">
            <label className="rating-label">Your Rating</label>
            <div className="interactive-rating">
              <div className="rating-stars-large">
                {Array.from({ length: 5 }, (_, index) => {
                  const starNumber = index + 1;
                  const isActive = starNumber <= (hoveredRating || rating);

                  return (
                    <Star
                      key={index}
                      className={`rating-star ${isActive ? 'active' : ''}`}
                      onClick={() => setRating(starNumber)}
                      onMouseEnter={() => setHoveredRating(starNumber)}
                      onMouseLeave={() => setHoveredRating(0)}
                    />
                  );
                })}
              </div>
              {(hoveredRating || rating) > 0 && (
                <div className="rating-label-text">
                  {getRatingLabel(hoveredRating || rating)}
                </div>
              )}
            </div>
          </div>

          <div className="comment-section">
            <label className="comment-label">
              Share Your Experience <span className="optional">(Optional)</span>
            </label>
            <textarea
              value={comment}
              onChange={(e) => setComment(e.target.value)}
              className="comment-textarea"
              rows={4}
              placeholder="Tell others about your experience at this venue..."
              maxLength={500}
            />
            <div className="character-count">
              {comment.length}/500
            </div>
          </div>

          <div className="modal-actions">
            <button
              onClick={handleSubmit}
              disabled={rating === 0}
              className="submit-button"
            >
              <Star className="w-4 h-4" />
              Submit Rating (+5 points)
            </button>
            <button
              onClick={handleClose}
              className="cancel-button"
            >
              Cancel
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default RatingModal;
