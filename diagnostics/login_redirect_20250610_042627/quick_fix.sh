#!/bin/bash

echo "Quick Fix for Login Redirect"
echo "============================"

# Backup current files
cp src/context/AppContext.jsx src/context/AppContext.jsx.backup
cp src/ExistingApp.jsx src/ExistingApp.jsx.backup

# Find the main login component
LOGIN_COMPONENT=""
if [ -f "src/components/Views/LoginView.jsx" ]; then
    LOGIN_COMPONENT="src/components/Views/LoginView.jsx"
    cp "$LOGIN_COMPONENT" "$LOGIN_COMPONENT.backup"
fi

# Apply the simplest fix - add navigation to login success
cat > fix_login_temp.js << 'EOFIX'
const fs = require('fs');

// Fix 1: Update AppContext login to include navigation
if (fs.existsSync('src/context/AppContext.jsx')) {
    let appContext = fs.readFileSync('src/context/AppContext.jsx', 'utf8');
    
    // Ensure currentView is in state
    if (!appContext.includes('currentView:')) {
        appContext = appContext.replace(
            /const \[state, setState\] = useState\({/,
            'const [state, setState] = useState({\n        currentView: \'landing\','
        );
    }
    
    // Add setView action if missing
    if (!appContext.includes('setView:')) {
        appContext = appContext.replace(
            /const actions = {/,
            `const actions = {
        setView: (view) => {
            setState(prev => ({ ...prev, currentView: view }));
        },`
        );
    }
    
    // Update login success to set view to home
    appContext = appContext.replace(
        /isAuthenticated: true,\s*isLoading: false/,
        'isAuthenticated: true,\n                        isLoading: false,\n                        currentView: \'home\''
    );
    
    fs.writeFileSync('src/context/AppContext.jsx', appContext);
    console.log('✓ Updated AppContext');
}

// Fix 2: Ensure ExistingApp uses currentView
if (fs.existsSync('src/ExistingApp.jsx')) {
    let existingApp = fs.readFileSync('src/ExistingApp.jsx', 'utf8');
    
    // Add useEffect to handle auth-based navigation
    if (!existingApp.includes('// Auto-navigate')) {
        const useEffectNav = `
    // Auto-navigate authenticated users away from login
    useEffect(() => {
        if (state.isAuthenticated && ['login', 'register'].includes(state.currentView)) {
            actions.setView('home');
        }
    }, [state.isAuthenticated, state.currentView]);`;
        
        // Insert after the first useEffect or after function declaration
        const insertPoint = existingApp.match(/useApp\(\);/);
        if (insertPoint) {
            existingApp = existingApp.replace(
                /useApp\(\);/,
                `useApp();\n${useEffectNav}`
            );
        }
    }
    
    fs.writeFileSync('src/ExistingApp.jsx', existingApp);
    console.log('✓ Updated ExistingApp');
}

// Fix 3: Update login component to trigger navigation
const loginComponents = [
    'src/components/Views/LoginView.jsx',
    'src/components/auth/Login.jsx'
];

for (const component of loginComponents) {
    if (fs.existsSync(component)) {
        let content = fs.readFileSync(component, 'utf8');
        
        // Add navigation after successful login
        content = content.replace(
            /console\.log\(['"]✅ Login successful['"]\);?/,
            `console.log('✅ Login successful');
                // Navigate to home view
                if (actions.setView) {
                    actions.setView('home');
                }`
        );
        
        // Alternative: look for setMessage success
        content = content.replace(
            /setMessage\(['"]Login successful['"]\);?/,
            `setMessage('Login successful');
                // Navigate to home view
                if (actions.setView) {
                    actions.setView('home');
                }`
        );
        
        fs.writeFileSync(component, content);
        console.log('✓ Updated ' + component);
    }
}

console.log('\n✅ Quick fix applied!');
console.log('Restart your development server to see the changes.');
EOFIX

node fix_login_temp.js
rm fix_login_temp.js

echo ""
echo "Quick fix applied! Please restart your development server."
echo "If the issue persists, check the diagnostic report."
