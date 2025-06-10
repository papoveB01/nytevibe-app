// Auth Debug Utility
export const authDebug = {
  check: () => {
    console.log('=== Auth Debug Info ===');
    console.log('Token:', localStorage.getItem('auth_token') ? 'Present' : 'Missing');
    console.log('User Data:', localStorage.getItem('user_data') ? 'Present' : 'Missing');
    
    const userData = localStorage.getItem('user_data');
    if (userData) {
      try {
        const user = JSON.parse(userData);
        console.log('User:', user);
      } catch (e) {
        console.error('Invalid user data format');
      }
    }
  },
  
  setTestAuth: () => {
    const testUser = {
      id: 'test-123',
      username: 'testuser',
      email: 'test@example.com',
      first_name: 'Test',
      last_name: 'User'
    };
    
    localStorage.setItem('auth_token', 'test-token-persistent-login');
    localStorage.setItem('user_data', JSON.stringify(testUser));
    console.log('Test auth data set. Refresh the page to test auto-login.');
  },
  
  clear: () => {
    localStorage.removeItem('auth_token');
    localStorage.removeItem('user_data');
    localStorage.removeItem('auth_token_data');
    console.log('Auth data cleared.');
  }
};

// Make it available globally for debugging
if (typeof window !== 'undefined') {
  window.authDebug = authDebug;
}
