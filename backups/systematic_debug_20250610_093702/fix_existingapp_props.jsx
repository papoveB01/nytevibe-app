// Fix for ExistingApp.jsx - Ensure navigation props are passed

// Add these handlers before return statement:
const handleShowRegistration = () => {
  if (actions) actions.setCurrentView('register');
};

const handleShowForgotPassword = () => {
  if (actions) actions.setCurrentView('forgot-password');
};

// In your LoginView usage:
<LoginView 
  onRegister={handleShowRegistration}
  onForgotPassword={handleShowForgotPassword}
/>
