import React, { useState } from 'react';
import { Eye, EyeOff, User, Lock, Zap } from 'lucide-react';

const LoginViewTest = ({ onRegister, onForgotPassword }) => {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');

  const handleSubmit = async (e) => {
    e.preventDefault();
    console.log('🧪 TEST: Form submitted');
    setError('Form submission works! (Test mode)');
  };

  const handleRegisterClick = (e) => {
    e.preventDefault();
    console.log('🧪 TEST: Register button clicked');
    console.log('🧪 TEST: onRegister function:', typeof onRegister);
    
    if (onRegister && typeof onRegister === 'function') {
      console.log('🧪 TEST: Calling onRegister...');
      onRegister();
    } else {
      console.error('🧪 TEST: onRegister is not a function!', onRegister);
      alert('Register button clicked! (onRegister function missing)');
    }
  };

  const handleForgotPasswordClick = (e) => {
    e.preventDefault();
    console.log('🧪 TEST: Forgot Password button clicked');
    console.log('🧪 TEST: onForgotPassword function:', typeof onForgotPassword);
    
    if (onForgotPassword && typeof onForgotPassword === 'function') {
      console.log('🧪 TEST: Calling onForgotPassword...');
      onForgotPassword();
    } else {
      console.error('🧪 TEST: onForgotPassword is not a function!', onForgotPassword);
      alert('Forgot Password button clicked! (onForgotPassword function missing)');
    }
  };

  return (
    <div style={{ 
      maxWidth: '400px', 
      margin: '2rem auto', 
      padding: '2rem', 
      border: '2px solid #007bff',
      borderRadius: '8px',
      backgroundColor: '#f8f9fa'
    }}>
      <h2 style={{ textAlign: 'center', color: '#007bff' }}>
        🧪 TEST LOGIN VIEW
      </h2>
      
      {error && (
        <div style={{ 
          background: '#d4edda', 
          color: '#155724', 
          padding: '10px', 
          borderRadius: '4px',
          marginBottom: '1rem'
        }}>
          {error}
        </div>
      )}

      <form onSubmit={handleSubmit}>
        <div style={{ marginBottom: '1rem' }}>
          <label>Username:</label>
          <input
            type="text"
            value={username}
            onChange={(e) => setUsername(e.target.value)}
            style={{ 
              width: '100%', 
              padding: '8px', 
              marginTop: '4px',
              border: '1px solid #ccc',
              borderRadius: '4px'
            }}
            placeholder="Test username"
          />
        </div>

        <div style={{ marginBottom: '1rem' }}>
          <label>Password:</label>
          <input
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            style={{ 
              width: '100%', 
              padding: '8px', 
              marginTop: '4px',
              border: '1px solid #ccc',
              borderRadius: '4px'
            }}
            placeholder="Test password"
          />
        </div>

        <button
          type="submit"
          style={{
            width: '100%',
            padding: '12px',
            backgroundColor: '#007bff',
            color: 'white',
            border: 'none',
            borderRadius: '4px',
            cursor: 'pointer',
            marginBottom: '1rem'
          }}
        >
          🧪 Test Sign In
        </button>
      </form>

      <div style={{ textAlign: 'center', marginTop: '1rem' }}>
        <button
          type="button"
          onClick={handleRegisterClick}
          style={{
            background: 'none',
            border: 'none',
            color: '#007bff',
            textDecoration: 'underline',
            cursor: 'pointer',
            padding: '8px',
            margin: '0 10px',
            fontSize: '16px'
          }}
        >
          🧪 Test Create Account
        </button>
        
        <button
          type="button"
          onClick={handleForgotPasswordClick}
          style={{
            background: 'none',
            border: 'none',
            color: '#007bff',
            textDecoration: 'underline',
            cursor: 'pointer',
            padding: '8px',
            margin: '0 10px',
            fontSize: '16px'
          }}
        >
          🧪 Test Forgot Password
        </button>
      </div>

      <div style={{ 
        marginTop: '2rem', 
        padding: '1rem', 
        backgroundColor: '#e9ecef',
        borderRadius: '4px',
        fontSize: '14px'
      }}>
        <strong>🔬 Test Instructions:</strong>
        <ul style={{ marginTop: '8px', paddingLeft: '20px' }}>
          <li>Click navigation buttons to test</li>
          <li>Check browser console for debug logs</li>
          <li>If buttons work, issue is Context-related</li>
          <li>If buttons don't work, issue is CSS/event-related</li>
        </ul>
      </div>
    </div>
  );
};

export default LoginViewTest;
