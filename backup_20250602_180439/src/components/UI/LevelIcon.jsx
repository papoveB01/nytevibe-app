import React from 'react';
import { Star, Trophy, Crown, Zap, Award } from 'lucide-react';
import { getLevelIconType } from '../../utils/helpers';

const LevelIcon = ({ level, size = 12, className = '' }) => {
  const iconType = getLevelIconType(level);
  
  const iconProps = {
    size,
    className
  };
  
  switch (iconType) {
    case 'crown':
      return <Crown {...iconProps} />;
    case 'trophy':
      return <Trophy {...iconProps} />;
    case 'award':
      return <Award {...iconProps} />;
    case 'zap':
      return <Zap {...iconProps} />;
    case 'star':
    default:
      return <Star {...iconProps} />;
  }
};

export default LevelIcon;
