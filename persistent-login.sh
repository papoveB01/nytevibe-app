#!/bin/bash

# Comprehensive Login Flow Diagnostic
# Tests the actual login with provided credentials

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

print_status() {
    echo -e "${2}[${1}]${NC} ${3}"
}

cd /var/www/nytevibe

print_status "START" "$CYAN" "Comprehensive Login Flow Diagnostic"
echo ""

# Step 1: Check current file states
print_status "STEP 1" "$BLUE" "Checking file states..."

echo "AppContext.jsx - setView action:"
grep -A3 "setView:" src/context/AppContext.jsx | head -5

echo ""
echo "AppContext.jsx - LOGIN_SUCCESS case:"
grep -A5 "case actionTypes.LOGIN_SUCCESS:" src/context/AppContext.jsx | head -8

echo ""
echo "ExistingApp.jsx - renderCurrentView usage:"
grep -n "renderCurrentView()" src/ExistingApp.jsx

echo ""
echo "LoginView.jsx - success handling:"
grep -A5 "Login successful" src/components/Views/LoginView.jsx 2>/dev/null | head -8

# Step 2: Create a test login script
print_status "STEP 2" "$PURPLE" "Creating test login script..."

cat > "${HOME}/test_login.html" << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>nYtevibe Login Test</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            background: #1a1a1a;
            color: #fff;
        }
        .section {
            background: #2a2a2a;
            padding: 20px;
            margin: 20px 0;
            border-radius: 8px;
        }
        button {
            background: #007bff;
            color: white;
            border: none;
            padding: 10px 20px;
            margin: 5px;
            cursor: pointer;
            border-radius: 4px;
        }
        .log {
            background: #333;
            padding: 10px;
            margin: 10px 0;
            border-radius: 4px;
            font-family: monospace;
            white-space: pre-wrap;
            max-height: 300px;
            overflow-y: auto;
        }
        .success { color: #28a745; }
        .error { color: #dc3545; }
        .info { color: #17a2b8; }
        .warning { color: #ffc107; }
    </style>
</head>
<body>
    <h1>nYtevibe Login Flow Test</h1>
    
    <div class="section">
        <h2>Test Credentials</h2>
        <p>Email: iammrpwinner01@gmail.com</p>
        <p>Password: Scario@02</p>
        <button onclick="testLogin()">Test Login</button>
        <button onclick="clearAll()">Clear All & Reset</button>
    </div>
    
    <div class="section">
        <h2>Login Flow Log</h2>
        <div id="flow-log" class="log"></div>
    </div>
    
    <div class="section">
        <h2>State Monitor</h2>
        <div id="state-monitor" class="log"></div>
    </div>

    <script>
        const API_BASE = 'https://system.nytevibe.com/api';
        const logDiv = document.getElementById('flow-log');
        const stateDiv = document.getElementById('state-monitor');
        
        function log(message, type = 'info') {
            const time = new Date().toLocaleTimeString();
            const entry = document.createElement('div');
            entry.className = type;
            entry.textContent = `[${time}] ${message}`;
            logDiv.appendChild(entry);
            logDiv.scrollTop = logDiv.scrollHeight;
        }
        
        function updateState() {
            const token = localStorage.getItem('auth_token');
            const user = localStorage.getItem('user_data');
            const expires = localStorage.getItem('token_expires_at');
            
            stateDiv.innerHTML = `<div class="info">Current State:
Token: ${token ? '✓ Present (' + token.substring(0, 20) + '...)' : '✗ Missing'}
User: ${user ? '✓ ' + JSON.parse(user).email : '✗ Missing'}
Expires: ${expires ? new Date(expires).toLocaleString() : 'Not set'}
</div>`;
        }
        
        async function testLogin() {
            log('Starting login test...', 'info');
            
            // Clear previous data
            localStorage.removeItem('auth_token');
            localStorage.removeItem('user_data');
            localStorage.removeItem('token_expires_at');
            log('Cleared previous authentication data', 'info');
            
            const credentials = {
                username: 'iammrpwinner01@gmail.com',
                password: 'Scario@02',
                remember_me: true
            };
            
            try {
                log('Sending login request to: ' + API_BASE + '/auth/login', 'info');
                
                const response = await fetch(`${API_BASE}/auth/login`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Accept': 'application/json'
                    },
                    body: JSON.stringify(credentials)
                });
                
                log('Response status: ' + response.status, response.ok ? 'success' : 'error');
                
                const data = await response.json();
                log('Response data: ' + JSON.stringify(data, null, 2), 'info');
                
                if (data.success) {
                    log('✅ Login successful!', 'success');
                    
                    // Check what was stored
                    if (data.data && data.data.token) {
                        localStorage.setItem('auth_token', data.data.token);
                        log('Token stored in localStorage', 'success');
                    }
                    
                    if (data.data && data.data.user) {
                        localStorage.setItem('user_data', JSON.stringify(data.data.user));
                        log('User data stored in localStorage', 'success');
                    }
                    
                    if (data.data && data.data.token_expires_at) {
                        localStorage.setItem('token_expires_at', data.data.token_expires_at);
                        log('Token expiration stored', 'success');
                    }
                    
                    updateState();
                    
                    // Test token validation
                    setTimeout(() => testTokenValidation(), 1000);
                    
                } else {
                    log('❌ Login failed: ' + (data.message || 'Unknown error'), 'error');
                }
                
            } catch (error) {
                log('❌ Network error: ' + error.message, 'error');
            }
        }
        
        async function testTokenValidation() {
            log('\nTesting token validation...', 'info');
            
            const token = localStorage.getItem('auth_token');
            if (!token) {
                log('No token to validate', 'error');
                return;
            }
            
            try {
                const response = await fetch(`${API_BASE}/auth/validate-token`, {
                    headers: {
                        'Authorization': `Bearer ${token}`,
                        'Accept': 'application/json'
                    }
                });
                
                const data = await response.json();
                log('Token validation response: ' + JSON.stringify(data, null, 2), 'info');
                
                if (data.success) {
                    log('✅ Token is valid', 'success');
                } else {
                    log('❌ Token validation failed', 'error');
                }
                
            } catch (error) {
                log('❌ Token validation error: ' + error.message, 'error');
            }
        }
        
        function clearAll() {
            localStorage.clear();
            log('🗑️ Cleared all localStorage data', 'warning');
            updateState();
        }
        
        // Monitor state changes
        setInterval(updateState, 1000);
        updateState();
    </script>
</body>
</html>
EOF

print_status "CREATED" "$GREEN" "Test page created at: ${HOME}/test_login.html"

# Step 3: Add comprehensive logging to LoginView
print_status "STEP 3" "$PURPLE" "Adding diagnostic logging to LoginView..."

cat > /tmp/add_login_diagnostics.js << 'EOF'
import { readFileSync, writeFileSync, existsSync } from 'fs';

const loginFile = 'src/components/Views/LoginView.jsx';

if (existsSync(loginFile)) {
    let content = readFileSync(loginFile, 'utf8');
    
    // Add diagnostic logging
    if (!content.includes('// DIAGNOSTIC LOGGING')) {
        // Find the handleSubmit or handleLogin function
        content = content.replace(
            /const handleSubmit = async \(e\) => {/,
            `const handleSubmit = async (e) => {
        // DIAGNOSTIC LOGGING
        console.log('🔍 LOGIN DIAGNOSTIC - Start');
        console.log('1. Form submitted');`
        );
        
        // Add logging before login call
        content = content.replace(
            /const result = await actions\.login/,
            `console.log('2. Current state before login:', { 
            isAuthenticated: state.isAuthenticated,
            currentView: state.currentView
        });
        console.log('3. Calling actions.login...');
        const result = await actions.login`
        );
        
        // Add logging after login
        content = content.replace(
            /if \(result\.success\)/,
            `console.log('4. Login result:', result);
        if (result.success)`
        );
        
        // Add logging in success block
        content = content.replace(
            /console\.log\(['"]✅ Login successful['"]\);/,
            `console.log('✅ Login successful');
            console.log('5. Checking for setView action...');
            console.log('actions.setView exists?', typeof actions.setView);`
        );
        
        // Add logging after setView call
        content = content.replace(
            /actions\.setView\(['"]home['"]\);/,
            `actions.setView('home');
            console.log('6. Called setView("home")');
            console.log('7. Checking state after setView...');
            setTimeout(() => {
                console.log('8. State 100ms after setView:', {
                    currentView: state.currentView,
                    isAuthenticated: state.isAuthenticated
                });
            }, 100);`
        );
    }
    
    writeFileSync(loginFile, content);
    console.log('✓ Added diagnostic logging to LoginView');
}
EOF

node /tmp/add_login_diagnostics.js

# Step 4: Add state change listener to AppContext
print_status "STEP 4" "$PURPLE" "Adding state change monitoring..."

cat > /tmp/add_state_monitor.js << 'EOF'
import { readFileSync, writeFileSync } from 'fs';

const contextFile = 'src/context/AppContext.jsx';
let content = readFileSync(contextFile, 'utf8');

// Add debug logging to SET_CURRENT_VIEW case
if (!content.includes('// DEBUG: View change')) {
    content = content.replace(
        /case actionTypes\.SET_CURRENT_VIEW:\s*return { \.\.\.state, currentView: action\.payload };/,
        `case actionTypes.SET_CURRENT_VIEW:
      console.log('🎯 STATE CHANGE: currentView changing from', state.currentView, 'to', action.payload);
      return { ...state, currentView: action.payload };`
    );
}

// Add debug logging to LOGIN_SUCCESS case
if (!content.includes('// DEBUG: Login success')) {
    content = content.replace(
        /case actionTypes\.LOGIN_SUCCESS:/,
        `case actionTypes.LOGIN_SUCCESS:
      console.log('🎯 STATE CHANGE: LOGIN_SUCCESS - setting currentView to home');`
    );
}

writeFileSync(contextFile, content);
console.log('✓ Added state monitoring to AppContext');
EOF

node /tmp/add_state_monitor.js

# Step 5: Create React DevTools helper
print_status "STEP 5" "$CYAN" "Creating React DevTools helper..."

cat > "${HOME}/debug_react_state.js" << 'EOF'
// Copy and paste this into browser console AFTER the app loads

// Function to find React fiber
function findReactFiber(element) {
    const key = Object.keys(element).find(key => key.startsWith('__reactFiber'));
    return element[key];
}

// Function to get app state
function getAppState() {
    try {
        const root = document.getElementById('root');
        const fiber = findReactFiber(root);
        
        // Navigate through fiber tree to find AppContext
        let current = fiber;
        let contextFound = false;
        let depth = 0;
        
        while (current && depth < 50) {
            if (current.memoizedProps && current.memoizedProps.value && 
                current.memoizedProps.value.state && current.memoizedProps.value.actions) {
                console.log('Found AppContext!');
                return current.memoizedProps.value;
            }
            current = current.child || current.sibling || (current.return && current.return.sibling);
            depth++;
        }
        
        console.log('Could not find AppContext');
        return null;
    } catch (e) {
        console.error('Error accessing React internals:', e);
        return null;
    }
}

// Monitor state changes
let lastState = null;
setInterval(() => {
    const context = getAppState();
    if (context && context.state) {
        const currentView = context.state.currentView;
        const isAuth = context.state.isAuthenticated;
        
        if (!lastState || lastState.currentView !== currentView || lastState.isAuthenticated !== isAuth) {
            console.log('📊 State Update:', {
                currentView,
                isAuthenticated: isAuth,
                user: context.state.user?.email
            });
            lastState = { currentView, isAuthenticated: isAuth };
        }
    }
}, 500);

console.log('State monitor started. Try logging in now...');

// Test function to manually trigger navigation
window.testNavigation = () => {
    const context = getAppState();
    if (context && context.actions && context.actions.setView) {
        console.log('Manually calling setView("home")...');
        context.actions.setView('home');
    } else {
        console.log('Could not find setView action');
    }
};

console.log('Use window.testNavigation() to manually test navigation');
EOF

print_status "COMPLETE" "$GREEN" "Diagnostic setup complete!"
echo ""
print_status "INSTRUCTIONS" "$YELLOW" "Follow these steps:"
echo ""
echo "1. Open the test page in your browser:"
echo "   file://${HOME}/test_login.html"
echo ""
echo "2. Click 'Test Login' to test the API directly"
echo ""
echo "3. In another tab, go to your app and:"
echo "   a. Open DevTools Console (F12)"
echo "   b. Clear localStorage: localStorage.clear()"
echo "   c. Refresh the page"
echo "   d. Try logging in with the test credentials"
echo ""
echo "4. Watch for these console messages:"
echo "   - 🔍 LOGIN DIAGNOSTIC messages (1-8)"
echo "   - 🎯 STATE CHANGE messages"
echo "   - 📊 State Update messages"
echo ""
echo "5. If login works but no redirect, try in console:"
echo "   window.testNavigation()"
echo ""
print_status "DEBUG" "$CYAN" "Restart your dev server now:"
echo "   npm start"
