import React from 'react';
import { X, Facebook, Twitter, Instagram, MessageCircle, Link } from 'lucide-react';
import { useApp } from '../../context/AppContext';

const ShareModal = () => {
  const { state, actions } = useApp();

  if (!state.showShareModal || !state.shareVenue) {
    return null;
  }

  const venue = state.shareVenue;

  const handleClose = () => {
    actions.setShowShareModal(false);
    actions.setShareVenue(null);
  };

  const handleShare = (platform) => {
    // Simulate sharing
    actions.addNotification({
      type: 'success',
      message: `📱 Shared ${venue.name || 'venue'} on ${platform}!`
    });
    handleClose();
  };

  return (
    <div className="modal-overlay" onClick={handleClose}>
      <div className="modal-content" onClick={(e) => e.stopPropagation()}>
        <div className="modal-header">
          <h3>Share {venue.name || 'Venue'}</h3>
          <button className="modal-close" onClick={handleClose}>
            <X size={20} />
          </button>
        </div>
        <div className="modal-body">
          <div className="share-options">
            <button className="share-option" onClick={() => handleShare('Facebook')}>
              <Facebook size={20} />
              <span>Facebook</span>
            </button>
            <button className="share-option" onClick={() => handleShare('Twitter')}>
              <Twitter size={20} />
              <span>Twitter</span>
            </button>
            <button className="share-option" onClick={() => handleShare('Instagram')}>
              <Instagram size={20} />
              <span>Instagram</span>
            </button>
            <button className="share-option" onClick={() => handleShare('WhatsApp')}>
              <MessageCircle size={20} />
              <span>WhatsApp</span>
            </button>
            <button className="share-option" onClick={() => handleShare('Copy Link')}>
              <Link size={20} />
              <span>Copy Link</span>
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default ShareModal;
