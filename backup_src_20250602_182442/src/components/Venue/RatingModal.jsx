import React from 'react';
import Modal from '../UI/Modal';
import { useApp } from '../../context/AppContext';

const RatingModal = () => {
  const { state, actions } = useApp();
  
  const handleClose = () => {
    actions.setShowRatingModal(false);
  };

  return (
    <Modal
      isOpen={state.showRatingModal}
      onClose={handleClose}
      title="Rate Venue"
    >
      <div>
        <p>Rating functionality coming soon...</p>
      </div>
    </Modal>
  );
};

export default RatingModal;
