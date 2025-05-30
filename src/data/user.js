export const USER_PROFILE_DATA = {
  id: 'usr_12345',
  firstName: 'Papove',
  lastName: 'Bombando',
  username: 'papove_bombando',
  email: 'papove.bombando@example.com',
  phone: '+1 (713) 555-0199',
  avatar: null,
  points: 1247,
  level: 'Gold Explorer',
  levelTier: 'gold',
  memberSince: '2023',
  totalReports: 89,
  totalRatings: 156,
  totalFollows: 3,
  followedVenues: [1, 3, 4],
  badgesEarned: ['Early Bird', 'Community Helper', 'Venue Expert', 'Houston Local', 'Social Butterfly'],
  preferences: {
    notifications: true,
    privateProfile: false,
    shareLocation: true,
    pushNotifications: true,
    emailDigest: true,
    friendsCanSeeFollows: true
  },
  socialStats: {
    friendsCount: 24,
    sharedVenues: 12,
    receivedRecommendations: 8,
    sentRecommendations: 15
  },
  followLists: [
    {
      id: 'date-night',
      name: 'Date Night Spots',
      emoji: '💕',
      venueIds: [4],
      createdAt: '2024-01-15',
      isPublic: true
    },
    {
      id: 'sports-bars',
      name: 'Sports Bars',
      emoji: '🏈',
      venueIds: [3],
      createdAt: '2024-01-20',
      isPublic: true
    },
    {
      id: 'weekend-vibes',
      name: 'Weekend Vibes',
      emoji: '🎉',
      venueIds: [1],
      createdAt: '2024-02-01',
      isPublic: false
    },
    {
      id: 'hookah-spots',
      name: 'Hookah Lounges',
      emoji: '💨',
      venueIds: [6],
      createdAt: '2024-02-10',
      isPublic: true
    }
  ],
  followHistory: [
    {
      id: 'fh_001',
      venueId: 4,
      venueName: 'Best Regards',
      action: 'follow',
      timestamp: '2024-02-15T18:30:00Z',
      reason: 'Added to Date Night Spots list',
      listId: 'date-night'
    },
    {
      id: 'fh_002',
      venueId: 3,
      venueName: 'Classic',
      action: 'follow',
      timestamp: '2024-02-10T14:20:00Z',
      reason: 'Recommended by AI based on sports preferences'
    },
    {
      id: 'fh_003',
      venueId: 1,
      venueName: 'NYC Vibes',
      action: 'follow',
      timestamp: '2024-02-05T20:15:00Z',
      reason: 'Shared by friend @sarah_houston'
    }
  ]
};

export const FRIENDS_DATA = [
  {
    id: 'usr_98765',
    name: 'Sarah Martinez',
    username: 'sarah_houston',
    avatar: null,
    mutualFollows: 2,
    isOnline: true,
    lastSeen: 'now'
  },
  {
    id: 'usr_54321',
    name: 'David Chen',
    username: 'david_htx',
    avatar: null,
    mutualFollows: 1,
    isOnline: false,
    lastSeen: '2 hours ago'
  },
  {
    id: 'usr_11111',
    name: 'Lisa Rodriguez',
    username: 'lisa_nightlife',
    avatar: null,
    mutualFollows: 3,
    isOnline: true,
    lastSeen: 'now'
  }
];
