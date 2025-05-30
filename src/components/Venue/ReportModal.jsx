import React, { useState } from 'react';
import { useApp } from '../../context/AppContext';
import Modal from '../UI/Modal';
import Button from '../UI/Button';

const ReportModal = () => {
  const { state, actions } = useApp();
  const [crowdLevel, setCrowdLevel] = useState(3);
  const [waitTime, setWaitTime] = useState(0);

  const handleSubmit = () => {
    if (state.selectedVenue) {
      // Handle report submission
      actions.addNotification({
        type: 'success',
        message: 'Venue status updated successfully!'
      });
      actions.setShowReportModal(false);
    }
  };

  const handleClose = () => {
    actions.setShowReportModal(false);
  };

  return (
    <Modal
      isOpen={state.showReportModal}
      onClose={handleClose}
      title={`Report Status for ${state.selectedVenue?.name || 'Venue'}`}
    >
      <div className="space-y-4">
        <div>
          <label className="block text-sm font-medium mb-2">Crowd Level</label>
          <select
            value={crowdLevel}
            onChange={(e) => setCrowdLevel(Number(e.target.value))}
            className="form-input"
          >
            <option value={1}>Empty</option>
            <option value={2}>Quiet</option>
            <option value={3}>Moderate</option>
            <option value={4}>Busy</option>
            <option value={5}>Packed</option>
          </select>
        </div>
        
        <div>
          <label className="block text-sm font-medium mb-2">Wait Time (minutes)</label>
          <input
            type="number"
            value={waitTime}
            onChange={(e) => setWaitTime(Number(e.target.value))}
            className="form-input"
            min="0"
            max="120"
          />
        </div>
        
        <div className="flex gap-2">
          <Button onClick={handleSubmit}>
            Submit Report
          </Button>
          <Button variant="secondary" onClick={handleClose}>
            Cancel
          </Button>
        </div>
      </div>
    </Modal>
  );
};

export default ReportModal;
