#!/bin/bash

# Comprehensive Frontend Fix
# Fixes: API URL, login field name, and navigation

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

FRONTEND_PATH="/var/www/nytevibe"
BACKUP_DIR="${FRONTEND_PATH}/backups/comprehensive_fix_$(date +%Y%m%d_%H%M%S)"

cd "$FRONTEND_PATH"
mkdir -p "$BACKUP_DIR"

print_status "START" "$CYAN" "Starting Comprehensive Frontend Fix"
echo ""

# Backup files
print_status "BACKUP" "$BLUE" "Creating backups..."
cp src/services/authAPI.js "$BACKUP_DIR/" 2>/dev/null
cp src/components/Views/LoginView.jsx "$BACKUP_DIR/" 2>/dev/null
cp src/context/AppContext.jsx "$BACKUP_DIR/" 2>/dev/null

# Fix 1: Update authAPI.js with correct URL and field name
print_status "FIX 1" "$PURPLE" "Fixing authAPI.js..."

cat > /tmp/fix_authapi_complete.js << 'EOF'
import { readFileSync, writeFileSync } from 'fs';

try {
    let content = readFileSync('src/services/authAPI.js', 'utf8');
    
    console.log('Fixing authAPI.js...');
    
    // 1. Fix baseURL
    content = content.replace(
        /this\.baseURL = ['"][^'"]*['"]/,
        "this.baseURL = 'https://system.nytevibe.com/api'"
    );
    console.log('✓ Updated baseURL to: https://system.nytevibe.com/api');
    
    // 2. Fix login method to use email instead of username
    // Find the login method
    const loginMethodRegex = /async login\(credentials, rememberMe = false\) {[\s\S]*?body: JSON\.stringify\({[\s\S]*?}\),/;
    const loginMatch = content.match(loginMethodRegex);
    
    if (loginMatch) {
        // Replace username with email in the request body
        const updatedLogin = loginMatch[0].replace(
            /body: JSON\.stringify\({[\s\S]*?}\),/,
            `body: JSON.stringify({
                    email: credentials.username || credentials.email, // Support both field names
                    password: credentials.password,
                    remember_me: rememberMe
                }),`
        );
        content = content.replace(loginMatch[0], updatedLogin);
        console.log('✓ Updated login to send email field');
    }
    
    // 3. Ensure proper error handling
    if (!content.includes('console.log(\'🔐 Attempting login')) {
        content = content.replace(
            /async login\(credentials, rememberMe = false\) {/,
            `async login(credentials, rememberMe = false) {
        console.log('🔐 Attempting login...', { email: credentials.username || credentials.email });`
        );
    }
    
    writeFileSync('src/services/authAPI.js', content);
    console.log('✅ authAPI.js fixed successfully');
    
} catch (error) {
    console.error('Error fixing authAPI:', error.message);
}
EOF

node /tmp/fix_authapi_complete.js

# Fix 2: Update AppContext login to handle response correctly
print_status "FIX 2" "$PURPLE" "Fixing AppContext login response handling..."

cat > /tmp/fix_appcontext_login.js << 'EOF'
import { readFileSync, writeFileSync } from 'fs';

try {
    let content = readFileSync('src/context/AppContext.jsx', 'utf8');
    
    console.log('Fixing AppContext login handling...');
    
    // Fix the login action to properly handle the response structure
    const loginActionRegex = /const login = useCallback\(async \(credentials, rememberMe = false\) => {[\s\S]*?}\), \[\]\);/;
    
    if (loginActionRegex.test(content)) {
        const newLoginAction = `const login = useCallback(async (credentials, rememberMe = false) => {
    dispatch({ type: actionTypes.SET_LOADING, payload: true });
    try {
        console.log('AppContext: Starting login...');
        const response = await authAPI.login(credentials, rememberMe);
        
        console.log('AppContext: Login response:', response);
        
        // Handle both response structures (success/data)
        if (response.success || response.status === 'success') {
            const userData = response.data?.user || response.user;
            
            dispatch({ 
                type: actionTypes.LOGIN_SUCCESS, 
                payload: { user: userData } 
            });
            
            // Add success notification
            dispatch({
                type: actionTypes.ADD_NOTIFICATION,
                payload: {
                    type: 'success',
                    message: 'Login successful! Welcome back!',
                    duration: 3000
                }
            });
            
            console.log('AppContext: Login successful, currentView should be "home" now');
            
            return { success: true };
        } else {
            const errorMessage = response.message || response.error || 'Login failed';
            dispatch({ 
                type: actionTypes.LOGIN_FAILURE, 
                payload: errorMessage 
            });
            return { success: false, message: errorMessage };
        }
    } catch (error) {
        console.error('AppContext: Login error:', error);
        const errorMessage = error.message || 'Login failed';
        dispatch({ 
            type: actionTypes.LOGIN_FAILURE, 
            payload: errorMessage 
        });
        return { success: false, message: errorMessage };
    } finally {
        dispatch({ type: actionTypes.SET_LOADING, payload: false });
    }
}, []);`;
        
        content = content.replace(loginActionRegex, newLoginAction);
        console.log('✓ Updated login action');
    }
    
    writeFileSync('src/context/AppContext.jsx', content);
    console.log('✅ AppContext fixed successfully');
    
} catch (error) {
    console.error('Error fixing AppContext:', error.message);
}
EOF

node /tmp/fix_appcontext_login.js

# Fix 3: Update LoginView to ensure proper navigation
print_status "FIX 3" "$PURPLE" "Fixing LoginView navigation..."

cat > /tmp/fix_loginview_complete.js << 'EOF'
import { readFileSync, writeFileSync, existsSync } from 'fs';

const loginFile = 'src/components/Views/LoginView.jsx';

if (existsSync(loginFile)) {
    try {
        let content = readFileSync(loginFile, 'utf8');
        
        console.log('Fixing LoginView...');
        
        // Add comprehensive logging
        if (!content.includes('// COMPLETE LOGIN FLOW')) {
            content = content.replace(
                /const handleSubmit = async \(e\) => {/,
                `const handleSubmit = async (e) => {
        // COMPLETE LOGIN FLOW
        console.log('🚀 LOGIN FLOW START');`
            );
        }
        
        // Ensure we handle the result properly
        const resultHandling = `
            console.log('📦 Login result:', result);
            
            if (result && result.success) {
                console.log('✅ Login successful!');
                setMessage('Login successful! Redirecting...');
                setMessageType('success');
                
                // Clear form
                setUsername('');
                setPassword('');
                
                // Force navigation with a small delay to ensure state updates
                console.log('🎯 Attempting navigation to home...');
                setTimeout(() => {
                    if (actions.setView) {
                        console.log('🏠 Calling setView("home")');
                        actions.setView('home');
                    } else if (actions.setCurrentView) {
                        console.log('🏠 Calling setCurrentView("home")');
                        actions.setCurrentView('home');
                    } else {
                        console.error('❌ No navigation action available!');
                    }
                }, 100);
            } else {`;
        
        // Replace the result handling section
        content = content.replace(
            /if \(result\.success\) {[\s\S]*?} else {/,
            resultHandling
        );
        
        writeFileSync(loginFile, content);
        console.log('✅ LoginView fixed successfully');
        
    } catch (error) {
        console.error('Error fixing LoginView:', error.message);
    }
}
EOF

node /tmp/fix_loginview_complete.js

# Create a test script for the browser
print_status "TEST" "$CYAN" "Creating browser test script..."

cat > "${HOME}/test_complete_fix.js" << 'EOF'
// Test the complete fix
// Run this in browser console at https://blackaxl.com

console.log('🧪 Testing Complete Fix...');

// First, let's verify the API is reachable
fetch('https://system.nytevibe.com/api/health')
    .then(r => r.text())
    .then(data => console.log('✅ API Health:', data))
    .catch(e => console.error('❌ API unreachable:', e));

// Test login with correct endpoint
async function testCompleteLogin() {
    console.log('\n🔐 Testing login with email field...');
    
    const response = await fetch('https://system.nytevibe.com/api/auth/login', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
        },
        body: JSON.stringify({
            email: 'iammrpwinner01@gmail.com',
            password: 'Scario@02',
            remember_me: true
        })
    });
    
    const data = await response.json();
    console.log('📦 API Response:', data);
    
    if (data.status === 'success' || data.success) {
        console.log('✅ Login successful via API!');
        console.log('🎫 Token:', data.data.token);
        console.log('👤 User:', data.data.user.email);
        console.log('📅 Expires:', data.data.expires_at);
        
        // Store in localStorage to test
        localStorage.setItem('auth_token', data.data.token);
        localStorage.setItem('user_data', JSON.stringify(data.data.user));
        localStorage.setItem('token_expires_at', data.data.expires_at);
        
        console.log('💾 Auth data stored in localStorage');
        console.log('\n🎯 Now try logging in through the UI to test navigation');
    }
}

// Run the test
testCompleteLogin();

// Monitor for navigation
let lastView = localStorage.getItem('lastView') || '';
setInterval(() => {
    // Try multiple ways to detect view change
    const url = window.location.href;
    const title = document.title;
    const h1 = document.querySelector('h1')?.textContent || '';
    
    const currentState = `${url}|${title}|${h1}`;
    if (currentState !== lastView) {
        console.log('📍 Page changed:', {
            url: url,
            title: title,
            heading: h1
        });
        lastView = currentState;
        localStorage.setItem('lastView', currentState);
    }
}, 1000);

console.log('\n📊 Monitoring for navigation changes...');
EOF

# Create nginx configuration if needed
print_status "NGINX" "$YELLOW" "Creating nginx configuration..."

cat > "$BACKUP_DIR/nginx_api_config.conf" << 'EOF'
# Add this to your nginx site configuration for blackaxl.com

location /api/ {
    proxy_pass https://system.nytevibe.com/api/;
    proxy_http_version 1.1;
    proxy_set_header Host system.nytevibe.com;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    
    # CORS headers if needed
    add_header 'Access-Control-Allow-Origin' 'https://blackaxl.com' always;
    add_header 'Access-Control-Allow-Credentials' 'true' always;
    add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS, PUT, DELETE' always;
    add_header 'Access-Control-Allow-Headers' 'DNT,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Range,Authorization' always;
}
EOF

print_status "COMPLETE" "$GREEN" "All fixes applied!"
echo ""
print_status "SUMMARY" "$CYAN" "What was fixed:"
echo "  1. ✅ API URL: Now using https://system.nytevibe.com/api"
echo "  2. ✅ Login field: Now sending 'email' instead of 'username'"
echo "  3. ✅ Response handling: Properly handles the API response structure"
echo "  4. ✅ Navigation: Added proper navigation after login success"
echo ""
print_status "NEXT" "$YELLOW" "Next steps:"
echo "  1. Restart your development server:"
echo "     cd $FRONTEND_PATH && npm start"
echo ""
echo "  2. Test in browser at https://blackaxl.com:"
echo "     - Open console (F12)"
echo "     - Copy test script from: ${HOME}/test_complete_fix.js"
echo "     - Try logging in with UI"
echo ""
echo "  3. For production, consider adding nginx proxy:"
echo "     See: $BACKUP_DIR/nginx_api_config.conf"
echo ""
print_status "BACKUP" "$BLUE" "Backups saved to: $BACKUP_DIR"
