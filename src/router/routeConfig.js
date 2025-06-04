// Route definitions for future use
// This file defines routes but doesn't interfere with current app structure

export const routes = {
  home: '/',
  login: '/login',
  register: '/register',
  profile: '/profile',
  venues: '/venues',
  venueDetails: '/venue/:id',
  search: '/search',
  // Add more routes as needed in future
};

export const publicRoutes = [
  routes.home,
  routes.login,
  routes.register,
  routes.search
];

export const protectedRoutes = [
  routes.profile,
  routes.venues,
  routes.venueDetails
];
