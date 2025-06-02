import React from 'react';
import Modal from '../UI/Modal';
import { useApp } from '../../context/AppContext';

const UserProfileModal = () => {
  const { state, actions } = useApp();
  
  const handleClose = () => {
    actions.setShowUserProfileModal(false);
  };

  return (
    <Modal
      isOpen={state.showUserProfileModal}
      onClose={handleClose}
      title="User Profile"
      className="user-profile-modal"
    >
      <div className="user-profile-modal-content">
        <p>User profile content coming soon...</p>
      </div>
    </Modal>
  );
};

export default UserProfileModal;
