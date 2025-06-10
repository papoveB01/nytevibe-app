import { readFileSync, writeFileSync, existsSync } from 'fs';

const loginFiles = [
    'src/components/Views/LoginView.jsx',
    'src/components/auth/Login.jsx'
];

for (const file of loginFiles) {
    if (!existsSync(file)) continue;
    
    try {
        let content = readFileSync(file, 'utf8');
        let updated = false;
        
        // Find the login success handler
        const successPattern = /console\.log\(['"]✅ Login successful['"]\);?/;
        
        if (successPattern.test(content)) {
            content = content.replace(successPattern, (match) => {
                if (!content.includes("actions.setView('home')")) {
                    updated = true;
                    return `${match}
                    // Navigate to home immediately
                    if (actions.setView) {
                        console.log('Navigating to home view...');
                        actions.setView('home');
                    }`;
                }
                return match;
            });
        }
        
        // Also check for setMessage patterns
        const messagePattern = /setMessage\(['"]Login successful['"]\);?/;
        if (messagePattern.test(content) && !content.includes("actions.setView('home')")) {
            content = content.replace(messagePattern, (match) => {
                updated = true;
                return `${match}
                    // Navigate to home immediately
                    if (actions.setView) {
                        console.log('Navigating to home view...');
                        actions.setView('home');
                    }`;
            });
        }
        
        if (updated) {
            writeFileSync(file, content);
            console.log(`✅ Updated ${file} with navigation`);
        }
    } catch (error) {
        console.error(`Error updating ${file}:`, error.message);
    }
}
