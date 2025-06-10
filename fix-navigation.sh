#!/bin/bash

# Navigation Debug & Fix Script
echo "🔍 NAVIGATION DEBUG & FIX"
echo "========================="

# 1. First, let's add debug to ExistingApp.jsx to see what's happening
echo "📝 Adding debug logging to ExistingApp.jsx..."

# Backup current file
cp src/ExistingApp.jsx src/ExistingApp.jsx.backup.$(date +%Y%m%d_%H%M%S)

# Add debug logging to the navigation handlers
sed -i 's/const handleShowRegistration = () => {/const handleShowRegistration = () => {\
    console.log("🔍 DEBUG: handleShowRegistration called");\
    console.log("🔍 DEBUG: actions exists:", !!actions);\
    console.log("🔍 DEBUG: actions.setCurrentView exists:", !!(actions \&\& actions.setCurrentView));/g' src/ExistingApp.jsx

sed -i 's/const handleShowForgotPassword = () => {/const handleShowForgotPassword = () => {\
    console.log("🔍 DEBUG: handleShowForgotPassword called");\
    console.log("🔍 DEBUG: actions exists:", !!actions);\
    console.log("🔍 DEBUG: actions.setCurrentView exists:", !!(actions \&\& actions.setCurrentView));/g' src/ExistingApp.jsx

echo "✅ Debug logging added to ExistingApp.jsx"

# 2. Create a simple test version of LoginView that doesn't depend on Context
echo "📝 Creating simplified test LoginView..."

cat > src/components/Views/LoginView.test.jsx << 'EOF'
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
EOF

echo "✅ Test LoginView created"

# 3. Temporarily modify ExistingApp.jsx to use test LoginView
echo "📝 Creating test version of ExistingApp..."

# Create a test line to import TestLoginView
echo "
// 🧪 TEMPORARY TEST IMPORT
import LoginViewTest from './components/Views/LoginView.test.jsx';
" >> src/ExistingApp.jsx

# Replace the login case in renderCurrentView
sed -i 's/case '"'"'login'"'"':/case '"'"'login'"'"':\
        \/\/ 🧪 TEMPORARY: Use test LoginView\
        return (\
          <LoginViewTest \
            onRegister={handleShowRegistration}\
            onForgotPassword={handleShowForgotPassword}\
          \/>\
        );\
        \/\/ Original login view (commented out for test):\
        \/\* return (/g' src/ExistingApp.jsx

# Comment out the original LoginView return
sed -i 's/return (/\/\*return (/g' src/ExistingApp.jsx
sed -i 's/        );$/        ); *\//g' src/ExistingApp.jsx

echo "✅ ExistingApp.jsx modified to use test LoginView"

echo ""
echo "🎯 TEST READY!"
echo "=============="
echo ""
echo "Next steps:"
echo "1. Run: npm run dev"
echo "2. Open browser and go to login page"
echo "3. Click the '🧪 Test Create Account' and '🧪 Test Forgot Password' buttons"
echo "4. Check browser console for debug messages"
echo ""
echo "What to look for:"
echo "✅ If buttons work: Issue is Context-related in original LoginView"
echo "❌ If buttons don't work: Issue is CSS/event handling related"
echo ""
echo "Report back what happens!"

# 4. Create rollback script
cat > rollback_test.sh << 'EOF'
#!/bin/bash
echo "🔄 Rolling back test changes..."

# Restore ExistingApp.jsx from backup
BACKUP_FILE=$(ls src/ExistingApp.jsx.backup.* | tail -1)
if [ -f "$BACKUP_FILE" ]; then
    cp "$BACKUP_FILE" src/ExistingApp.jsx
    echo "✅ ExistingApp.jsx restored from $BACKUP_FILE"
else
    echo "❌ No backup found"
fi

# Remove test LoginView
if [ -f "src/components/Views/LoginView.test.jsx" ]; then
    rm src/components/Views/LoginView.test.jsx
    echo "✅ Test LoginView removed"
fi

echo "🏁 Rollback complete"
EOF

chmod +x rollback_test.sh

echo ""
echo "📝 Rollback script created: ./rollback_test.sh"
echo "Run this to restore original files after testing"
