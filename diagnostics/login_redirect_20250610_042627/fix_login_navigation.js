const fs = require('fs');

function fixLoginComponent(filePath) {
    if (!fs.existsSync(filePath)) return;
    
    let content = fs.readFileSync(filePath, 'utf8');
    
    // Find the successful login handling
    const successPattern = /if\s*\(\s*response\.success\s*\)\s*{([^}]+)}/;
    
    if (successPattern.test(content)) {
        // Add navigation after successful login
        content = content.replace(successPattern, (match, group1) => {
            if (!group1.includes('setView') && !group1.includes('navigate')) {
                return match.replace('{', `{
                    // Navigate to home view after successful login
                    actions.setView('home');`);
            }
            return match;
        });
        
        // Alternative pattern for result.success
        const altPattern = /if\s*\(\s*result\.success\s*\)\s*{([^}]+)}/;
        content = content.replace(altPattern, (match, group1) => {
            if (!group1.includes('setView') && !group1.includes('navigate')) {
                return match.replace('{', `{
                    // Navigate to home view after successful login
                    actions.setView('home');`);
            }
            return match;
        });
    }
    
    fs.writeFileSync(filePath + '.fixed', content);
    console.log(`Fixed login component: ${filePath}.fixed`);
}

// Fix all login components
const loginComponents = [
    'src/components/Views/LoginView.jsx',
    'src/components/auth/Login.jsx',
    'src/components/auth/LoginTest.jsx'
];

loginComponents.forEach(fixLoginComponent);
