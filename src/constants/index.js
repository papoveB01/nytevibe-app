export const EMOJI_OPTIONS = ['📍', '💕', '🏈', '🎉', '🍻', '☕', '🌙', '🎵', '🍽️', '🎭', '🏃', '💼', '💨', '🔥'];

export const VIBE_OPTIONS = [
  "Chill", "Lively", "Loud", "Dancing", "Sports", "Date Night",
  "Business", "Family", "Hip-Hop", "R&B", "Live Music", "Karaoke",
  "Hookah", "Rooftop", "VIP", "Happy Hour"
];

export const UPDATE_INTERVALS = {
  VENUE_DATA: 45000, // 45 seconds
  NOTIFICATION_DURATION: 3000, // 3 seconds
  PROMOTION_PULSE: 3000, // 3 seconds
  FOLLOW_ANIMATION: 2000, // 2 seconds
  BANNER_ROTATION: 4000 // 4 seconds
};

export const PROMOTIONAL_BANNERS = [
  {
    id: 'community',
    type: 'community',
    icon: 'MessageCircle',
    title: "Help your community!",
    subtitle: "Rate venues and report status to earn points",
    bgColor: "linear-gradient(135deg, #3b82f6, #2563eb)",
    borderColor: "#3b82f6",
    iconColor: "#ffffff",
    textColor: "#ffffff"
  },
  {
    id: 'nyc-promo',
    type: 'promotion',
    venue: 'NYC Vibes',
    icon: 'Gift',
    title: "NYC Vibes says: Free Hookah for Ladies! 🎉",
    subtitle: "6:00 PM - 10:00 PM • Tonight Only • Limited Time",
    bgColor: "linear-gradient(135deg, #ec4899, #db2777)",
    borderColor: "#ec4899",
    iconColor: "#ffffff",
    textColor: "#ffffff"
  },
  {
    id: 'red-sky-grand-opening',
    type: 'promotion',
    venue: 'Red Sky Hookah Lounge',
    icon: 'Sparkles',
    title: "Red Sky: Grand Opening Special! 🔥",
    subtitle: "50% Off Premium Hookah • Live DJ • VIP Lounge Available",
    bgColor: "linear-gradient(135deg, #ef4444, #dc2626)",
    borderColor: "#ef4444",
    iconColor: "#ffffff",
    textColor: "#ffffff"
  },
  {
    id: 'best-regards-event',
    type: 'event',
    venue: 'Best Regards',
    icon: 'Volume2',
    title: "Best Regards Says: Guess who's here tonight! 🎵",
    subtitle: "#DJ Chin is spinning • 9:00 PM - 2:00 AM • Don't miss out!",
    bgColor: "linear-gradient(135deg, #a855f7, #9333ea)",
    borderColor: "#a855f7",
    iconColor: "#ffffff",
    textColor: "#ffffff"
  },
  {
    id: 'rumors-special',
    type: 'promotion',
    venue: 'Rumors',
    icon: 'Calendar',
    title: "Rumors: R&B Night Special! 🎤",
    subtitle: "2-for-1 cocktails • Live R&B performances • 8:00 PM start",
    bgColor: "linear-gradient(135deg, #22c55e, #16a34a)",
    borderColor: "#22c55e",
    iconColor: "#ffffff",
    textColor: "#ffffff"
  },
  {
    id: 'classic-game',
    type: 'event',
    venue: 'Classic',
    icon: 'Volume2',
    title: "Classic Bar: Big Game Tonight! 🏈",
    subtitle: "Texans vs Cowboys • 50¢ wings • Free shots for TDs!",
    bgColor: "linear-gradient(135deg, #fb923c, #f97316)",
    borderColor: "#fb923c",
    iconColor: "#ffffff",
    textColor: "#ffffff"
  },
  {
    id: 'social-new',
    type: 'social',
    icon: 'UserPlus',
    title: "Connect with friends! 👥",
    subtitle: "Share venues, create lists, and discover together",
    bgColor: "linear-gradient(135deg, #a855f7, #9333ea)",
    borderColor: "#a855f7",
    iconColor: "#ffffff",
    textColor: "#ffffff"
  },
  {
    id: 'ai-recommendations',
    type: 'ai',
    icon: 'Brain',
    title: "AI-Powered Recommendations! 🤖",
    subtitle: "Discover venues tailored to your taste profile",
    bgColor: "linear-gradient(135deg, #22c55e, #16a34a)",
    borderColor: "#22c55e",
    iconColor: "#ffffff",
    textColor: "#ffffff"
  }
];

export const POINT_SYSTEM = {
  FOLLOW_VENUE: 3,
  UNFOLLOW_VENUE: -2,
  RATE_VENUE: 5,
  REPORT_VENUE: 10,
  SHARE_VENUE: 2,
  CREATE_LIST: 10,
  HELPFUL_REVIEW: 1
};

export const USER_LEVELS = [
  { name: 'Bronze Explorer', tier: 'bronze', minPoints: 0, maxPoints: 499 },
  { name: 'Silver Scout', tier: 'silver', minPoints: 500, maxPoints: 999 },
  { name: 'Gold Explorer', tier: 'gold', minPoints: 1000, maxPoints: 1999 },
  { name: 'Platinum Pioneer', tier: 'platinum', minPoints: 2000, maxPoints: 4999 },
  { name: 'Diamond Legend', tier: 'diamond', minPoints: 5000, maxPoints: 999999 }
];
