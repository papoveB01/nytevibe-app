import React, { useState } from 'react';
import { useApp } from '../../context/AppContext';
import Modal from '../UI/Modal';
import StarRating from './StarRating';
import Button from '../UI/Button';

const RatingModal = () => {
  const { state, actions } = useApp();
  const [rating, setRating] = useState(0);
  const [comment, setComment] = useState('');

  const handleSubmit = () => {
    if (rating > 0 && state.selectedVenue) {
      // Handle rating submission
      actions.addNotification({
        type: 'success',
        message: 'Rating submitted successfully!'
      });
      actions.setShowRatingModal(false);
      setRating(0);
      setComment('');
    }
  };

  const handleClose = () => {
    actions.setShowRatingModal(false);
    setRating(0);
    setComment('');
  };

  return (
    <Modal
      isOpen={state.showRatingModal}
      onClose={handleClose}
      title={`Rate ${state.selectedVenue?.name || 'Venue'}`}
    >
      <div className="space-y-4">
        <div>
          <label className="block text-sm font-medium mb-2">Your Rating</label>
          <StarRating
            rating={rating}
            size="lg"
            interactive={true}
            onRate={setRating}
          />
        </div>
        
        <div>
          <label className="block text-sm font-medium mb-2">Comment (Optional)</label>
          <textarea
            value={comment}
            onChange={(e) => setComment(e.target.value)}
            className="form-input"
            rows={3}
            placeholder="Share your experience..."
          />
        </div>
        
        <div className="flex gap-2">
          <Button onClick={handleSubmit} disabled={rating === 0}>
            Submit Rating
          </Button>
          <Button variant="secondary" onClick={handleClose}>
            Cancel
          </Button>
        </div>
      </div>
    </Modal>
  );
};

export default RatingModal;
