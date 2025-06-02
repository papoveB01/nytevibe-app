import React from 'react';
import Modal from '../UI/Modal';
import { useApp } from '../../context/AppContext';

const ReportModal = () => {
  const { state, actions } = useApp();
  
  const handleClose = () => {
    actions.setShowReportModal(false);
  };

  return (
    <Modal
      isOpen={state.showReportModal}
      onClose={handleClose}
      title="Report Status"
    >
      <div>
        <p>Report functionality coming soon...</p>
      </div>
    </Modal>
  );
};

export default ReportModal;
