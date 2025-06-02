import React from 'react';
import { X, Facebook, Twitter, Instagram, Copy, MessageCircle, ExternalLink } from 'lucide-react';
import { shareVenue } from '../../utils/helpers';
import { useApp } from '../../context/AppContext';
import Modal from '../UI/Modal';
const ShareModal = () => {
  const { state, actions } = useApp();
  const venue = state.shareVenue;
  const handleShare = (platform) => {
    shareVenue(venue, platform);
    let message = '';
    switch (platform) {
      case 'copy':
        message = ' 📋  Link copied to clipboard!';
        break;
      case 'instagram':
        message = ' 📋  Link copied to clipboard! Share on Instagram.';
        break;
      default:
        message = ` 📤  Shared ${venue.name} on ${platform}!`;
    }
    actions.addNotification({
      type: 'success',
      message
    });
    actions.setShowShareModal(false);
  };
  const handleClose = () => {
    actions.setShowShareModal(false);
    actions.setShareVenue(null);
  };
  const shareOptions = [
    {
      platform: 'facebook',
      icon: Facebook,
      label: 'Facebook',
      color: 'text-blue-600',
      bgColor: 'bg-blue-50 hover:bg-blue-100'
    },
    {
      platform: 'twitter',
      icon: Twitter,
      label: 'Twitter',
      color: 'text-blue-400',
      bgColor: 'bg-blue-50 hover:bg-blue-100'
    },
    {
      platform: 'instagram',
      icon: Instagram,
      label: 'Instagram',
      color: 'text-pink-600',
      bgColor: 'bg-pink-50 hover:bg-pink-100'
    },
    {
      platform: 'whatsapp',
      icon: MessageCircle,
      label: 'WhatsApp',
      color: 'text-green-600',
      bgColor: 'bg-green-50 hover:bg-green-100'
    },
    {
      platform: 'copy',
      icon: Copy,
      label: 'Copy Link',
      color: 'text-gray-600',
      bgColor: 'bg-gray-50 hover:bg-gray-100'
    }
  ];
  if (!venue || !state.showShareModal) return null;
  return (
    <Modal
      isOpen={state.showShareModal}
      onClose={handleClose}
      title={`Share ${venue.name}`}
      className="share-modal"
    >
      <div className="share-preview">
        <div className="share-venue-info">
          <h4 className="share-venue-name">{venue.name}</h4>
          <p className="share-venue-details">
            {venue.type} •  ⭐  {venue.rating}/5 ({venue.totalRatings} reviews)
          </p>
          <p className="share-venue-address">{venue.address}</p>
        </div>
      </div>
      <div className="share-options">
        <label className="share-options-label">Share via</label>
        <div className="share-buttons">
          {shareOptions.map(({ platform, icon: Icon, label, color, bgColor }) => (
            <button
              key={platform}
              onClick={() => handleShare(platform)}
              className={`share-option ${bgColor} transition-colors duration-200`}
            >
              <Icon className={`w-5 h-5 ${color}`} />
              <span className="share-option-label">{label}</span>
              <ExternalLink className="w-3 h-3 text-gray-400" />
            </button>
          ))}
        </div>
      </div>
    </Modal>
  );
};
export default ShareModal;
