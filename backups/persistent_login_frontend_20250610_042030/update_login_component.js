const fs = require('fs');
const path = require('path');

// Function to add remember me checkbox to login form
function updateLoginComponent(filePath) {
    let content = fs.readFileSync(filePath, 'utf8');
    
    // Check if rememberMe already exists
    if (content.includes('rememberMe')) {
        console.log('Remember me functionality already exists');
        return;
    }
    
    // Add rememberMe state
    const statePattern = /const \[password, setPassword\] = useState\(['"]?['"]?\);/;
    const rememberMeState = `
    const [rememberMe, setRememberMe] = useState(false);`;
    
    if (statePattern.test(content)) {
        content = content.replace(statePattern, (match) => `${match}${rememberMeState}`);
    } else {
        // Try another pattern
        const altStatePattern = /useState\(['"]?['"]?\);\s*$/m;
        content = content.replace(altStatePattern, (match) => `${match}${rememberMeState}`);
    }
    
    // Update the login call to include rememberMe
    const loginCallPattern = /actions\.login\(\s*{\s*username[^}]+}\s*\)/;
    content = content.replace(loginCallPattern, (match) => {
        return match.replace(/\)$/, ', rememberMe)');
    });
    
    // Add remember me checkbox to the form
    const passwordInputPattern = /<input[^>]*type=['"]password['"][^>]*\/>/;
    const rememberMeCheckbox = `
                </div>
                
                {/* Remember Me Checkbox */}
                <div className="remember-me-container" style={{ marginTop: '15px', marginBottom: '15px' }}>
                    <label style={{ 
                        display: 'flex', 
                        alignItems: 'center', 
                        cursor: 'pointer',
                        fontSize: '14px',
                        color: 'inherit'
                    }}>
                        <input
                            type="checkbox"
                            checked={rememberMe}
                            onChange={(e) => setRememberMe(e.target.checked)}
                            style={{ 
                                marginRight: '8px',
                                cursor: 'pointer'
                            }}
                        />
                        Keep me logged in for 30 days
                    </label>`;
    
    // Find where to insert the checkbox (after password field)
    const passwordFieldMatch = content.match(/(<input[^>]*type=['"]password['"][^>]*\/>[\s\S]*?<\/div>)/);
    if (passwordFieldMatch) {
        content = content.replace(passwordFieldMatch[0], passwordFieldMatch[0] + rememberMeCheckbox);
    }
    
    fs.writeFileSync(filePath, content);
    console.log(`Updated login component: ${filePath}`);
}

// Update the login component
const loginComponents = [
    'src/components/Views/LoginView.jsx',
    'src/components/auth/Login.jsx',
    'src/components/auth/LoginTest.jsx'
];

for (const component of loginComponents) {
    if (fs.existsSync(component)) {
        updateLoginComponent(component);
    }
}
