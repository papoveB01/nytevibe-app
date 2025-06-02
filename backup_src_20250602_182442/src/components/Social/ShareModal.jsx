import React from 'react';
import Modal from '../UI/Modal';
import { useApp } from '../../context/AppContext';

const ShareModal = () => {
  const { state, actions } = useApp();
  
  const handleClose = () => {
    actions.setShowShareModal(false);
  };

  return (
    <Modal
      isOpen={state.showShareModal}
      onClose={handleClose}
      title="Share Venue"
    >
      <div>
        <p>Share functionality coming soon...</p>
      </div>
    </Modal>
  );
};

export default ShareModal;
