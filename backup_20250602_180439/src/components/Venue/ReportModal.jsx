import React, { useState } from 'react';
import { X, Users, Clock } from 'lucide-react';
import { useApp } from '../../context/AppContext';

const ReportModal = () => {
  const { state, actions } = useApp();
  const [crowdLevel, setCrowdLevel] = useState(2);
  const [waitTime, setWaitTime] = useState(0);
  const [comments, setComments] = useState('');

  if (!state.showReportModal || !state.selectedVenue) {
    return null;
  }

  const venue = state.selectedVenue;

  const handleClose = () => {
    actions.setShowReportModal(false);
    setCrowdLevel(2);
    setWaitTime(0);
    setComments('');
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    actions.addNotification({
      type: 'success',
      message: `📊 Status reported for ${venue.name || 'venue'}. Thanks for helping the community!`
    });
    handleClose();
  };

  const crowdLabels = ['Unknown', 'Quiet', 'Moderate', 'Busy', 'Very Busy', 'Packed'];

  return (
    <div className="modal-overlay" onClick={handleClose}>
      <div className="modal-content" onClick={(e) => e.stopPropagation()}>
        <div className="modal-header">
          <h3>Report Status for {venue.name || 'Venue'}</h3>
          <button className="modal-close" onClick={handleClose}>
            <X size={20} />
          </button>
        </div>
        <form onSubmit={handleSubmit} className="modal-body">
          <div className="report-section">
            <label>
              <Users size={16} />
              Crowd Level
            </label>
            <div className="crowd-options">
              {crowdLabels.slice(1).map((label, index) => (
                <button
                  key={index + 1}
                  type="button"
                  className={`crowd-option ${crowdLevel === index + 1 ? 'active' : ''}`}
                  onClick={() => setCrowdLevel(index + 1)}
                >
                  {label}
                </button>
              ))}
            </div>
          </div>
          <div className="report-section">
            <label>
              <Clock size={16} />
              Wait Time (minutes)
            </label>
            <input
              type="number"
              value={waitTime}
              onChange={(e) => setWaitTime(Math.max(0, parseInt(e.target.value) || 0))}
              min="0"
              max="120"
              placeholder="0"
            />
          </div>
          <div className="report-section">
            <label>Additional Comments</label>
            <textarea
              value={comments}
              onChange={(e) => setComments(e.target.value)}
              placeholder="Any additional details about the venue..."
              rows={3}
            />
          </div>
          <div className="modal-actions">
            <button type="button" onClick={handleClose} className="btn-secondary">
              Cancel
            </button>
            <button type="submit" className="btn-primary">
              Submit Report
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};

export default ReportModal;
