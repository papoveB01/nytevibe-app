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
        borderLeftColor: banner.borderColor
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
          <div className="banner-title">{banner.title}</div>
          <div className="banner-subtitle">{banner.subtitle}</div>
        </div>
      </div>
    </div>
  );
};

export default PromotionalBanner;
