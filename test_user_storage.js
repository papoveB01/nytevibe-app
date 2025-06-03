// Test user data storage - Run this in browser console after login

console.log('=== TESTING USER DATA STORAGE ===');

// Clear existing data first
localStorage.removeItem('user');
localStorage.removeItem('auth_token');
console.log('Cleared existing localStorage');

// Test the storage mechanism
const testUser = {
  id: 1973559,
  username: "bombardier",
  email: "iammrpwinner01@gmail.com",
  first_name: "Papove",
  last_name: "Bombando",
  user_type: "user"
};

const testToken = "test_token_12345";

// Store test data
localStorage.setItem('auth_token', testToken);
localStorage.setItem('user', JSON.stringify(testUser));

console.log('Stored test data:');
console.log('Token:', localStorage.getItem('auth_token'));
console.log('User:', localStorage.getItem('user'));
console.log('User parsed:', JSON.parse(localStorage.getItem('user')));

// Test if the issue is resolved
console.log('=== STORAGE TEST COMPLETE ===');
console.log('Now try refreshing the page to see if the white screen is gone');
