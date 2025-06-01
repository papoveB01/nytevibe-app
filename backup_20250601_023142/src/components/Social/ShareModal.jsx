import React from 'react';
import { X, Facebook, Twitter, Instagram, Copy, MessageCircle, ExternalLink } from 'lucide-react';
import { shareVenue } from '../../utils/helpers';

const ShareModal = ({ venue, isOpen, onClose }) => {
  if (!venue || !isOpen) return null;

  const handleShare = (platform) => {
    shareVenue(venue, platform);
    onClose();
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

  return (
    <div className="modal-overlay" onClick={onClose}>
      <div className="modal-content share-modal" onClick={(e) => e.stopPropagation()}>
        <div className="modal-header">
          <h3 className="modal-title">Share {venue.name}</h3>
          <button onClick={onClose} className="modal-close">
            <X className="w-4 h-4" />
          </button>
        </div>

        <div className="modal-body">
          <div className="share-preview">
            <div className="share-venue-info">
              <h4 className="share-venue-name">{venue.name}</h4>
              <p className="share-venue-details">
                {venue.type} • ⭐ {venue.rating}/5 ({venue.totalRatings} reviews)
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
        </div>
      </div>
    </div>
  );
};

export default ShareModal;
