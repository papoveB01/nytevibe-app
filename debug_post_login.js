// Copy and paste this into browser console after login to debug
console.log('=== POST-LOGIN DEBUG ===');

// Check localStorage for user data
console.log('localStorage user:', localStorage.getItem('user'));
console.log('localStorage token:', localStorage.getItem('auth_token'));

// Check if React context is accessible
try {
  // This will help us see what's in the React state
  console.log('Window React DevTools:', window.__REACT_DEVTOOLS_GLOBAL_HOOK__);
} catch(e) {
  console.log('React DevTools not available');
}

// Check what's undefined and causing the includes error
console.log('=== CHECKING FOR UNDEFINED ARRAYS ===');

// Common arrays that might be undefined
const commonArrays = [
  'state.currentView',
  'state.user',
  'state.venues',
  'state.notifications'
];

commonArrays.forEach(path => {
  try {
    const value = eval(path);
    console.log(`${path}:`, value, typeof value);
  } catch(e) {
    console.log(`${path}: Not accessible`);
  }
});
