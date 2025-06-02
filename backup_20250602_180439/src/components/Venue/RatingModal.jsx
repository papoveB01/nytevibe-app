import React, { useState } from 'react';
import { X, Star } from 'lucide-react';
import { useApp } from '../../context/AppContext';

const RatingModal = () => {
  const { state, actions } = useApp();
  const [rating, setRating] = useState(0);
  const [comment, setComment] = useState('');

  if (!state.showRatingModal || !state.selectedVenue) {
    return null;
  }

  const venue = state.selectedVenue;

  const handleClose = () => {
    actions.setShowRatingModal(false);
    setRating(0);
    setComment('');
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    if (rating > 0) {
      actions.addNotification({
        type: 'success',
        message: `⭐ Thank you for rating ${venue.name || 'this venue'}!`
      });
      handleClose();
    }
  };

  return (
    <div className="modal-overlay" onClick={handleClose}>
      <div className="modal-content" onClick={(e) => e.stopPropagation()}>
        <div className="modal-header">
          <h3>Rate {venue.name || 'Venue'}</h3>
          <button className="modal-close" onClick={handleClose}>
            <X size={20} />
          </button>
        </div>
        <form onSubmit={handleSubmit} className="modal-body">
          <div className="rating-section">
            <label>Your Rating</label>
            <div className="rating-stars">
              {[1, 2, 3, 4, 5].map((star) => (
                <button
                  key={star}
                  type="button"
                  className={`rating-star ${star <= rating ? 'active' : ''}`}
                  onClick={() => setRating(star)}
                >
                  <Star size={24} fill={star <= rating ? 'currentColor' : 'none'} />
                </button>
              ))}
            </div>
          </div>
          <div className="comment-section">
            <label>Comment (Optional)</label>
            <textarea
              value={comment}
              onChange={(e) => setComment(e.target.value)}
              placeholder="Share your experience..."
              rows={4}
            />
          </div>
          <div className="modal-actions">
            <button type="button" onClick={handleClose} className="btn-secondary">
              Cancel
            </button>
            <button type="submit" className="btn-primary" disabled={rating === 0}>
              Submit Rating
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};

export default RatingModal;
