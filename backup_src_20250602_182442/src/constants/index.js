export const EMOJI_OPTIONS = ['📍', '💕', '🏈', '🎉', '🍻', '☕', '🌙', '🎵', '🍽️', '🎭', '🏃', '💼', '💨', '🔥'];

export const VIBE_OPTIONS = [
  "Chill", "Lively", "Loud", "Dancing", "Sports", "Date Night",
  "Business", "Family", "Hip-Hop", "R&B", "Live Music", "Karaoke",
  "Hookah", "Rooftop", "VIP", "Happy Hour"
];

export const PROMOTIONAL_BANNERS = [
  {
    id: 'community',
    type: 'community',
    icon: 'MessageCircle',
    title: "Help your community!",
    subtitle: "Rate venues and report status to earn points",
    bgColor: "rgba(59, 130, 246, 0.9)",
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
    bgColor: "rgba(236, 72, 153, 0.9)",
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
    bgColor: "rgba(239, 68, 68, 0.9)",
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
    bgColor: "rgba(168, 85, 247, 0.9)",
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
    bgColor: "rgba(34, 197, 94, 0.9)",
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
    bgColor: "rgba(251, 146, 60, 0.9)",
    borderColor: "#fb923c",
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
