import React, { useState } from 'react';
import { X, Users, Clock, AlertTriangle } from 'lucide-react';
import { useApp } from '../../context/AppContext';
import Modal from '../UI/Modal';

const ReportModal = () => {
  const { state, actions } = useApp();
  const [crowdLevel, setCrowdLevel] = useState(3);
  const [waitTime, setWaitTime] = useState(0);
  const [reportType, setReportType] = useState('status');
  const [issueDescription, setIssueDescription] = useState('');

  const handleSubmit = () => {
    if (state.selectedVenue) {
      if (reportType === 'status') {
        actions.reportVenue(state.selectedVenue.id, { crowdLevel, waitTime });
        actions.addNotification({
          type: 'success',
          message: `✅ Status updated! +10 points earned`
        });
      } else {
        actions.addNotification({
          type: 'success',
          message: `🚨 Issue reported! +10 points earned`
        });
      }

      actions.setShowReportModal(false);
      resetForm();
    }
  };

  const resetForm = () => {
    setCrowdLevel(3);
    setWaitTime(0);
    setReportType('status');
    setIssueDescription('');
  };

  const handleClose = () => {
    actions.setShowReportModal(false);
    resetForm();
  };

  const crowdOptions = [
    { value: 1, label: 'Empty', color: '#10b981', description: 'Very few people' },
    { value: 2, label: 'Quiet', color: '#10b981', description: 'Light crowd' },
    { value: 3, label: 'Moderate', color: '#f59e0b', description: 'Normal crowd' },
    { value: 4, label: 'Busy', color: '#ef4444', description: 'Getting crowded' },
    { value: 5, label: 'Packed', color: '#ef4444', description: 'Very crowded' }
  ];

  const issueTypes = [
    'Venue is closed',
    'Wrong information',
    'Safety concern',
    'Cleanliness issue',
    'Poor service',
    'Other'
  ];

  return (
    <Modal
      isOpen={state.showReportModal}
      onClose={handleClose}
      title={`Report Status for ${state.selectedVenue?.name || 'Venue'}`}
      className="report-modal"
    >
      {/* Report Type Selection */}
      <div className="report-type-section">
        <label className="section-label">What would you like to report?</label>
        <div className="report-type-options">
          <button
            className={`report-type-button ${reportType === 'status' ? 'active' : ''}`}
            onClick={() => setReportType('status')}
          >
            <Users className="w-5 h-5" />
            <div>
              <span className="type-title">Update Status</span>
              <span className="type-description">Current crowd & wait time</span>
            </div>
          </button>

          <button
            className={`report-type-button ${reportType === 'issue' ? 'active' : ''}`}
            onClick={() => setReportType('issue')}
          >
            <AlertTriangle className="w-5 h-5" />
            <div>
              <span className="type-title">Report Issue</span>
              <span className="type-description">Problem or concern</span>
            </div>
          </button>
        </div>
      </div>

      {reportType === 'status' ? (
        <div className="status-report-content">
          {/* Crowd Level */}
          <div className="input-section">
            <label className="input-label">
              <Users className="w-4 h-4" />
              Crowd Level
            </label>
            <div className="crowd-selector">
              {crowdOptions.map((option) => (
                <button
                  key={option.value}
                  className={`crowd-option ${crowdLevel === option.value ? 'selected' : ''}`}
                  onClick={() => setCrowdLevel(option.value)}
                  style={{
                    borderColor: crowdLevel === option.value ? option.color : '#e5e7eb',
                    backgroundColor: crowdLevel === option.value ? `${option.color}10` : 'white'
                  }}
                >
                  <span className="crowd-label">{option.label}</span>
                  <span className="crowd-description">{option.description}</span>
                </button>
              ))}
            </div>
          </div>

          {/* Wait Time */}
          <div className="input-section">
            <label className="input-label">
              <Clock className="w-4 h-4" />
              Wait Time (minutes)
            </label>
            <div className="wait-time-input">
              <input
                type="range"
                min="0"
                max="120"
                value={waitTime}
                onChange={(e) => setWaitTime(Number(e.target.value))}
                className="wait-time-slider"
              />
              <div className="wait-time-display">
                <span className="wait-time-value">
                  {waitTime === 0 ? 'No wait' : `${waitTime} minutes`}
                </span>
              </div>
            </div>
          </div>
        </div>
      ) : (
        <div className="issue-report-content">
          {/* Issue Type */}
          <div className="input-section">
            <label className="input-label">Issue Type</label>
            <select
              className="issue-select"
              value={issueDescription}
              onChange={(e) => setIssueDescription(e.target.value)}
            >
              <option value="">Select an issue type...</option>
              {issueTypes.map((issue, index) => (
                <option key={index} value={issue}>{issue}</option>
              ))}
            </select>
          </div>

          {/* Additional Details */}
          <div className="input-section">
            <label className="input-label">
              Additional Details <span className="optional">(Optional)</span>
            </label>
            <textarea
              className="issue-textarea"
              rows={4}
              placeholder="Please provide more details about the issue..."
              maxLength={300}
            />
            <div className="character-count">0/300</div>
          </div>
        </div>
      )}

      <div className="modal-actions">
        <button
          onClick={handleSubmit}
          className="submit-button"
        >
          {reportType === 'status' ? (
            <>
              <Users className="w-4 h-4" />
              Update Status (+10 points)
            </>
          ) : (
            <>
              <AlertTriangle className="w-4 h-4" />
              Report Issue (+10 points)
            </>
          )}
        </button>
        <button
          onClick={handleClose}
          className="cancel-button"
        >
          Cancel
        </button>
      </div>
    </Modal>
  );
};

export default ReportModal;
