import React, { useState } from 'react';
import { X, Users, Clock, TrendingUp, AlertTriangle } from 'lucide-react';
import { useApp } from '../../context/AppContext';
import { getCrowdLabel } from '../../utils/helpers';

const ReportModal = () => {
  const { state, actions } = useApp();
  const { showReportModal, selectedVenue } = state;
  const [reportType, setReportType] = useState('crowd');
  const [crowdLevel, setCrowdLevel] = useState(50);
  const [waitTime, setWaitTime] = useState(0);
  const [notes, setNotes] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);

  if (!showReportModal || !selectedVenue) return null;

  const handleClose = () => {
    actions.setShowReportModal(false);
    setReportType('crowd');
    setCrowdLevel(50);
    setWaitTime(0);
    setNotes('');
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setIsSubmitting(true);

    // Simulate API call
    setTimeout(() => {
      actions.addNotification({
        type: 'success',
        message: `📊 Thanks for updating ${selectedVenue.name}! Your report helps keep the community informed.`,
        duration: 5000
      });
      
      setIsSubmitting(false);
      handleClose();
    }, 1500);
  };

  const reportTypes = [
    {
      id: 'crowd',
      label: 'Crowd Level',
      icon: Users,
      description: 'How busy is it right now?'
    },
    {
      id: 'wait',
      label: 'Wait Time',
      icon: Clock,
      description: 'How long is the wait to get in?'
    },
    {
      id: 'general',
      label: 'General Update',
      icon: TrendingUp,
      description: 'Share any other updates'
    }
  ];

  return (
    <div className="modal-overlay" onClick={handleClose}>
      <div className="modal-content" onClick={(e) => e.stopPropagation()}>
        <div className="modal-header">
          <h3 className="modal-title">Report Status for {selectedVenue.name}</h3>
          <button onClick={handleClose} className="modal-close">
            <X className="w-5 h-5" />
          </button>
        </div>

        <form onSubmit={handleSubmit} className="modal-body">
          <div className="report-type-section">
            <label className="form-label">What would you like to report?</label>
            <div className="report-types">
              {reportTypes.map((type) => (
                <button
                  key={type.id}
                  type="button"
                  onClick={() => setReportType(type.id)}
                  className={`report-type-button ${reportType === type.id ? 'active' : ''}`}
                >
                  <type.icon className="w-5 h-5" />
                  <div className="report-type-content">
                    <span className="report-type-label">{type.label}</span>
                    <span className="report-type-description">{type.description}</span>
                  </div>
                </button>
              ))}
            </div>
          </div>

          {reportType === 'crowd' && (
            <div className="crowd-level-section">
              <label className="form-label">
                Crowd Level: {getCrowdLabel(crowdLevel)}
              </label>
              <input
                type="range"
                min="0"
                max="100"
                value={crowdLevel}
                onChange={(e) => setCrowdLevel(parseInt(e.target.value))}
                className="crowd-slider"
              />
              <div className="crowd-labels">
                <span>Empty</span>
                <span>Moderate</span>
                <span>Packed</span>
              </div>
            </div>
          )}

          {reportType === 'wait' && (
            <div className="wait-time-section">
              <label className="form-label">
                Wait Time: {waitTime === 0 ? 'No wait' : `${waitTime} minutes`}
              </label>
              <input
                type="range"
                min="0"
                max="60"
                step="5"
                value={waitTime}
                onChange={(e) => setWaitTime(parseInt(e.target.value))}
                className="wait-slider"
              />
              <div className="wait-labels">
                <span>No wait</span>
                <span>30 min</span>
                <span>60+ min</span>
              </div>
            </div>
          )}

          <div className="notes-section">
            <label htmlFor="notes" className="form-label">
              Additional Notes (optional)
            </label>
            <textarea
              id="notes"
              value={notes}
              onChange={(e) => setNotes(e.target.value)}
              placeholder="Any additional details about the current situation..."
              className="form-textarea"
              rows={3}
            />
          </div>

          <div className="modal-actions">
            <button
              type="button"
              onClick={handleClose}
              className="cancel-button"
              disabled={isSubmitting}
            >
              Cancel
            </button>
            <button
              type="submit"
              disabled={isSubmitting}
              className="submit-button"
            >
              {isSubmitting ? (
                <>
                  <div className="loading-spinner"></div>
                  Submitting...
                </>
              ) : (
                <>
                  <TrendingUp className="w-4 h-4" />
                  Submit Report
                </>
              )}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};

export default ReportModal;
