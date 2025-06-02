import React, { useState } from 'react';
import { X, Share2, Copy, MessageCircle, Facebook, Twitter, Linkedin, Check } from 'lucide-react';
import { useApp } from '../../context/AppContext';
import { shareVenue } from '../../utils/helpers';

const ShareModal = () => {
  const { state, actions } = useApp();
  const { showShareModal, shareVenue: venue } = state;
  const [copied, setCopied] = useState(false);

  if (!showShareModal || !venue) return null;

  const handleClose = () => {
    actions.setShowShareModal(false);
    setCopied(false);
  };

  const handleShare = async (platform) => {
    const success = await shareVenue(venue, platform);
    
    if (success) {
      actions.addNotification({
        type: 'success',
        message: platform === 'copy' 
          ? '📋 Link copied to clipboard!' 
          : `🔗 Shared ${venue.name} via ${platform}!`,
        duration: 3000
      });

      if (platform === 'copy') {
        setCopied(true);
        setTimeout(() => setCopied(false), 2000);
      }
    } else {
      actions.addNotification({
        type: 'error',
        message: 'Unable to share at this time. Please try again.',
        duration: 3000
      });
    }
  };

  const shareOptions = [
    {
      id: 'native',
      label: 'Share Menu',
      icon: Share2,
      description: 'Use device share menu',
      available: !!navigator.share
    },
    {
      id: 'copy',
      label: copied ? 'Copied!' : 'Copy Link',
      icon: copied ? Check : Copy,
      description: 'Copy link to clipboard',
      available: true
    },
    {
      id: 'twitter',
      label: 'Twitter',
      icon: Twitter,
      description: 'Share on Twitter',
      available: true
    },
    {
      id: 'facebook',
      label: 'Facebook',
      icon: Facebook,
      description: 'Share on Facebook',
      available: true
    },
    {
      id: 'linkedin',
      label: 'LinkedIn',
      icon: Linkedin,
      description: 'Share on LinkedIn',
      available: true
    }
  ];

  const shareText = `Check out ${venue.name} on nYtevibe! ${venue.type} with ${venue.rating}⭐ rating and ${venue.followersCount} followers.`;

  return (
    <div className="modal-overlay" onClick={handleClose}>
      <div className="modal-content" onClick={(e) => e.stopPropagation()}>
        <div className="modal-header">
          <h3 className="modal-title">Share {venue.name}</h3>
          <button onClick={handleClose} className="modal-close">
            <X className="w-5 h-5" />
          </button>
        </div>

        <div className="modal-body">
          <div className="share-preview">
            <div className="venue-preview">
              <div className="venue-preview-header">
                <h4 className="venue-preview-name">{venue.name}</h4>
                <span className="venue-preview-type">{venue.type}</span>
              </div>
              <div className="venue-preview-stats">
                <span className="preview-rating">⭐ {venue.rating}</span>
                <span className="preview-followers">❤️ {venue.followersCount}</span>
              </div>
              <p className="venue-preview-description">
                {venue.address} • {venue.vibe.slice(0, 2).join(', ')}
              </p>
            </div>
          </div>

          <div className="share-text-section">
            <label className="form-label">Share Message</label>
            <div className="share-text">
              {shareText}
            </div>
          </div>

          <div className="share-options">
            <label className="form-label">Choose how to share</label>
            <div className="share-buttons">
              {shareOptions
                .filter(option => option.available)
                .map((option) => (
                <button
                  key={option.id}
                  onClick={() => handleShare(option.id)}
                  className={`share-option-button ${copied && option.id === 'copy' ? 'success' : ''}`}
                >
                  <option.icon className="w-5 h-5" />
                  <div className="share-option-content">
                    <span className="share-option-label">{option.label}</span>
                    <span className="share-option-description">{option.description}</span>
                  </div>
                </button>
              ))}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default ShareModal;
