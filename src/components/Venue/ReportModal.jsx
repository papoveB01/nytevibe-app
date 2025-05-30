import React, { useState } from 'react';
import { Users, Clock, AlertTriangle, CheckCircle, X } from 'lucide-react';
import { useApp } from '../../context/AppContext';
import Modal from '../UI/Modal';
import Button from '../UI/Button';
import { getCrowdLabel, getCrowdColor } from '../../utils/helpers';

const ReportModal = () => {
  const { state, actions } = useApp();
  const [crowdLevel, setCrowdLevel] = useState(3);
  const [waitTime, setWaitTime] = useState(0);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [reportType, setReportType] = useState('status'); // 'status' or 'issue'

  const venue = state.selectedVenue;

  const handleSubmit = async () => {
    if (!venue) return;

    setIsSubmitting(true);
    
    // Simulate API call
    setTimeout(() => {
      if (reportType === 'status') {
        actions.reportVenue(venue.id, { crowdLevel, waitTime });
        actions.addNotification({
          type: 'success',
          message: `Thanks! Venue status updated successfully. You earned 10 points!`,
          duration: 4000
        });
      } else {
        actions.addNotification({
          type: 'success',
          message: `Thanks for reporting! We'll review this issue shortly.`,
          duration: 4000
        });
      }
      
      setIsSubmitting(false);
      handleClose();
    }, 1000);
  };

  const handleClose = () => {
    actions.setShowReportModal(false);
    setCrowdLevel(3);
    setWaitTime(0);
    setReportType('status');
    setIsSubmitting(false);
  };

  if (!venue) return null;

  return (
    <Modal
      isOpen={state.showReportModal}
      onClose={handleClose}
      title="Report Venue Status"
      maxWidth="max-w-lg"
    >
      <div className="report-modal-content">
        <div className="venue-info-header">
          <h4 className="venue-name">{venue.name}</h4>
          <p className="venue-location">{venue.type} • {venue.distance}</p>
        </div>

        <div className="report-type-selector">
          <h5>What would you like to report?</h5>
          <div className="report-type-buttons">
            <button
              onClick={() => setReportType('status')}
              className={`report-type-btn ${reportType === 'status' ? 'active' : ''}`}
            >
              <Users className="w-4 h-4" />
              <span>Update Status</span>
              <span className="points-badge">+10 pts</span>
            </button>
            <button
              onClick={() => setReportType('issue')}
              className={`report-type-btn ${reportType === 'issue' ? 'active' : ''}`}
            >
              <AlertTriangle className="w-4 h-4" />
              <span>Report Issue</span>
            </button>
          </div>
        </div>

        {reportType === 'status' && (
          <div className="status-report-section">
            <div className="form-group">
              <label className="form-label">
                <Users className="w-4 h-4" />
                How busy is it right now?
              </label>
              <div className="crowd-level-selector">
                {[1, 2, 3, 4, 5].map((level) => (
                  <button
                    key={level}
                    onClick={() => setCrowdLevel(level)}
                    className={`crowd-level-btn ${crowdLevel === level ? 'active' : ''}`}
                    data-level={level}
                  >
                    <div className={`crowd-indicator ${getCrowdColor(level).split(' ')[1]}`}></div>
                    <span>{getCrowdLabel(level)}</span>
                  </button>
                ))}
              </div>
            </div>

            <div className="form-group">
              <label className="form-label">
                <Clock className="w-4 h-4" />
                Current wait time (minutes)
              </label>
              <div className="wait-time-selector">
                <input
                  type="range"
                  min="0"
                  max="60"
                  value={waitTime}
                  onChange={(e) => setWaitTime(Number(e.target.value))}
                  className="wait-time-slider"
                />
                <div className="wait-time-display">
                  <span className="wait-time-value">{waitTime}</span>
                  <span className="wait-time-unit">minutes</span>
                </div>
              </div>
              <div className="wait-time-presets">
                {[0, 5, 10, 15, 30].map((time) => (
                  <button
                    key={time}
                    onClick={() => setWaitTime(time)}
                    className={`preset-btn ${waitTime === time ? 'active' : ''}`}
                  >
                    {time === 0 ? 'No wait' : `${time}m`}
                  </button>
                ))}
              </div>
            </div>
          </div>
        )}

        {reportType === 'issue' && (
          <div className="issue-report-section">
            <div className="form-group">
              <label className="form-label">What's the issue?</label>
              <div className="issue-options">
                <button className="issue-option-btn">
                  <X className="w-4 h-4" />
                  <span>Venue is closed</span>
                </button>
                <button className="issue-option-btn">
                  <AlertTriangle className="w-4 h-4" />
                  <span>Wrong information</span>
                </button>
                <button className="issue-option-btn">
                  <AlertTriangle className="w-4 h-4" />
                  <span>Safety concern</span>
                </button>
                <button className="issue-option-btn">
                  <AlertTriangle className="w-4 h-4" />
                  <span>Other issue</span>
                </button>
              </div>
            </div>
            <div className="form-group">
              <label className="form-label">Additional details (optional)</label>
              <textarea
                className="form-textarea"
                rows={3}
                placeholder="Describe the issue..."
              />
            </div>
          </div>
        )}

        <div className="modal-actions">
          <Button 
            onClick={handleSubmit} 
            disabled={isSubmitting}
            className="submit-btn"
          >
            {isSubmitting ? (
              <>
                <div className="spinner"></div>
                Submitting...
              </>
            ) : (
              <>
                <CheckCircle className="w-4 h-4" />
                {reportType === 'status' ? 'Update Status' : 'Report Issue'}
              </>
            )}
          </Button>
          <Button variant="secondary" onClick={handleClose} disabled={isSubmitting}>
            Cancel
          </Button>
        </div>

        <div className="report-help-text">
          <p>Your reports help keep venue information accurate and help other users make better decisions!</p>
        </div>
      </div>
    </Modal>
  );
};

export default ReportModal;
