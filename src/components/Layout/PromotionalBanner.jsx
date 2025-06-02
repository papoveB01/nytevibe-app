import React from 'react';
import { MessageCircle, Gift, Sparkles, Volume2, Calendar, UserPlus, Brain } from 'lucide-react';
const iconMap = {
  MessageCircle,
  Gift,
  Sparkles,
  Volume2,
  Calendar,
  UserPlus,
  Brain
};
const PromotionalBanner = ({ banner, onClick }) => {
  const IconComponent = iconMap[banner.icon];
  return (
    <div
      className="promotional-banner"
      style={{
        background: banner.bgColor,
        borderColor: banner.borderColor,
        color: banner.textColor || '#1f2937'
      }}
      onClick={onClick}
    >
      <div className="banner-content">
        {IconComponent && (
          <IconComponent
            className="banner-icon"
            style={{ color: banner.iconColor }}
          />
        )}
        <div className="banner-text">
          <div
            className="banner-title"
            style={{ color: banner.textColor || '#1f2937' }}
          >
            {banner.title}
          </div>
          <div
            className="banner-subtitle"
            style={{ color: banner.textColor ? `${banner.textColor}CC` : '#6b7280' }}
          >
            {banner.subtitle}
          </div>
        </div>
      </div>
    </div>
  );
};
export default PromotionalBanner;
