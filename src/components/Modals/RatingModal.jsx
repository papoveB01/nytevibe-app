import React, { useState } from 'react';
import { X, Star } from 'lucide-react';
import { useApp } from '../../context/AppContext';

const RatingModal = () => {
  const { state, actions } = useApp();
  const { showRatingModal, selectedVenue } = state;
  const [rating, setRating] = useState(0);
  const [comment, setComment] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);

  if (!showRatingModal || !selectedVenue) return null;

  const handleClose = () => {
    actions.setShowRatingModal(false);
    setRating(0);
    setComment('');
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (rating === 0) return;

    setIsSubmitting(true);

    // Simulate API call
    setTimeout(() => {
      actions.addNotification({
        type: 'success',
        message: `⭐ Thank you for rating ${selectedVenue.name}! Your review helps the community.`,
        duration: 5000
      });
      
      setIsSubmitting(false);
      handleClose();
    }, 1500);
  };

  return (
    <div className="modal-overlay" onClick={handleClose}>
      <div className="modal-content" onClick={(e) => e.stopPropagation()}>
        <div className="modal-header">
          <h3 className="modal-title">Rate {selectedVenue.name}</h3>
          <button onClick={handleClose} className="modal-close">
            <X className="w-5 h-5" />
          </button>
        </div>

        <form onSubmit={handleSubmit} className="modal-body">
          <div className="rating-section">
            <label className="form-label">How was your experience?</label>
            <div className="rating-stars-large">
              {[1, 2, 3, 4, 5].map((star) => (
                <Star
                  key={star}
                  className={`rating-star ${star <= rating ? 'active' : ''}`}
                  onClick={() => setRating(star)}
                />
              ))}
            </div>
            {rating > 0 && (
              <p className="rating-text">
                {rating === 1 && "Poor experience"}
                {rating === 2 && "Below average"}
                {rating === 3 && "Average experience"}
                {rating === 4 && "Good experience"}
                {rating === 5 && "Excellent experience"}
              </p>
            )}
          </div>

          <div className="comment-section">
            <label htmlFor="comment" className="form-label">
              Share your thoughts (optional)
            </label>
            <textarea
              id="comment"
              value={comment}
              onChange={(e) => setComment(e.target.value)}
              placeholder="Tell others about your experience at this venue..."
              className="form-textarea"
              rows={4}
            />
          </div>

          <div className="modal-actions">
            <button
              type="button"
              onClick={handleClose}
              className="cancel-button"
              disabled={isSubmitting}
            >
              Cancel
            </button>
            <button
              type="submit"
              disabled={rating === 0 || isSubmitting}
              className="submit-button"
            >
              {isSubmitting ? (
                <>
                  <div className="loading-spinner"></div>
                  Submitting...
                </>
              ) : (
                <>
                  <Star className="w-4 h-4" />
                  Submit Rating
                </>
              )}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};

export default RatingModal;
