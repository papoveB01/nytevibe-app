import React from 'react';
import { Facebook, Twitter, Instagram, Copy, MessageCircle } from 'lucide-react';
import Modal from '../UI/Modal';
import Button from '../UI/Button';
import { shareVenue } from '../../utils/helpers';

const ShareModal = ({ venue, isOpen, onClose }) => {
  if (!venue) return null;

  const handleShare = (platform) => {
    shareVenue(venue, platform);
    onClose();
  };

  const shareOptions = [
    { platform: 'facebook', icon: Facebook, label: 'Facebook', color: 'text-blue-600' },
    { platform: 'twitter', icon: Twitter, label: 'Twitter', color: 'text-blue-400' },
    { platform: 'instagram', icon: Instagram, label: 'Instagram', color: 'text-pink-600' },
    { platform: 'whatsapp', icon: MessageCircle, label: 'WhatsApp', color: 'text-green-600' },
    { platform: 'copy', icon: Copy, label: 'Copy Link', color: 'text-gray-600' }
  ];

  return (
    <Modal
      isOpen={isOpen}
      onClose={onClose}
      title={`Share ${venue.name}`}
    >
      <div className="space-y-3">
        {shareOptions.map(({ platform, icon: Icon, label, color }) => (
          <button
            key={platform}
            onClick={() => handleShare(platform)}
            className="flex items-center gap-3 w-full p-3 rounded-lg hover:bg-gray-50 transition-colors"
          >
            <Icon className={`w-5 h-5 ${color}`} />
            <span>{label}</span>
          </button>
        ))}
      </div>
    </Modal>
  );
};

export default ShareModal;
