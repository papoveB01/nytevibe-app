// Authentication utility functions

export const validateEmail = (email) => {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
};

export const validatePassword = (password) => {
  // Basic password validation - at least 6 characters
  return password && password.length >= 6;
};

export const validateLoginForm = (formData) => {
  const errors = {};
  
  if (!formData.email) {
    errors.email = 'Email is required';
  } else if (!validateEmail(formData.email)) {
    errors.email = 'Please enter a valid email address';
  }
  
  if (!formData.password) {
    errors.password = 'Password is required';
  } else if (!validatePassword(formData.password)) {
    errors.password = 'Password must be at least 6 characters';
  }
  
  return {
    isValid: Object.keys(errors).length === 0,
    errors
  };
};

// Simulate API calls for demo purposes
export const authAPI = {
  login: async (credentials) => {
    // Simulate network delay
    await new Promise(resolve => setTimeout(resolve, 1500));
    
    // Demo authentication logic
    const demoUsers = [
      {
        email: 'demo@nytevibe.com',
        password: 'demo123',
        user: {
          id: 'demo_user_001',
          email: 'demo@nytevibe.com',
          firstName: 'Demo',
          lastName: 'User',
          level: 3,
          points: 1250
        }
      },
      {
        email: 'user@example.com',
        password: 'password123',
        user: {
          id: 'user_002',
          email: 'user@example.com',
          firstName: 'John',
          lastName: 'Doe',
          level: 2,
          points: 850
        }
      }
    ];
    
    const matchedUser = demoUsers.find(
      user => user.email === credentials.email && user.password === credentials.password
    );
    
    if (matchedUser) {
      return {
        success: true,
        user: matchedUser.user,
        token: `demo_token_${Date.now()}`
      };
    } else {
      throw new Error('Invalid email or password');
    }
  },
  
  forgotPassword: async (email) => {
    await new Promise(resolve => setTimeout(resolve, 1000));
    
    if (validateEmail(email)) {
      return {
        success: true,
        message: 'Password reset link sent to your email'
      };
    } else {
      throw new Error('Please enter a valid email address');
    }
  }
};

// Local storage utilities for demo
export const tokenStorage = {
  get: () => localStorage.getItem('nytevibe_token'),
  set: (token) => localStorage.setItem('nytevibe_token', token),
  remove: () => localStorage.removeItem('nytevibe_token')
};
