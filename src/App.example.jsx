import React, { useState } from 'react';
import Login from './components/auth/Login';
import LoginTest from './components/auth/LoginTest';

function App() {
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [showTest, setShowTest] = useState(false);

  const handleLoginSuccess = (data) => {
    console.log('Login successful:', data);
    setIsAuthenticated(true);
  };

  const handleLogout = () => {
    localStorage.removeItem('token');
    localStorage.removeItem('user');
    setIsAuthenticated(false);
  };

  if (!isAuthenticated) {
    return (
      <div>
        <div style={{ padding: '20px', textAlign: 'center' }}>
          <button 
            onClick={() => setShowTest(!showTest)}
            style={{ 
              padding: '10px 20px', 
              backgroundColor: '#17a2b8', 
              color: 'white', 
              border: 'none', 
              borderRadius: '4px',
              cursor: 'pointer',
              marginBottom: '20px'
            }}
          >
            {showTest ? 'Hide Test' : 'Show Login Test'}
          </button>
        </div>
        
        {showTest ? (
          <LoginTest />
        ) : (
          <Login onLoginSuccess={handleLoginSuccess} />
        )}
      </div>
    );
  }

  return (
    <div style={{ padding: '20px' }}>
      <h1>Welcome! You are logged in.</h1>
      <button onClick={handleLogout}>Logout</button>
    </div>
  );
}

export default App;
