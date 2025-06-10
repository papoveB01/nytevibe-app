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
        
        // Find successful login handling and add navigation
        const patterns = [
            /if \(result\.success\) \{([^}]*)\}/s,
            /if \(response\.success\) \{([^}]*)\}/s,
            /console\.log\(['"]✅ Login successful['"]\);?/
        ];
        
        for (const pattern of patterns) {
            if (pattern.test(content)) {
                content = content.replace(pattern, (match) => {
                    if (!match.includes('setView')) {
                        updated = true;
                        if (match.includes('console.log')) {
                            return `console.log('✅ Login successful');
                // Navigate to home
                if (actions.setView) {
                    actions.setView('home');
                }`;
                        } else {
                            return match.replace('{', `{
                // Navigate to home after successful login
                if (actions.setView) {
                    actions.setView('home');
                }`);
                        }
                    }
                    return match;
                });
            }
        }
        
        if (updated) {
            writeFileSync(file, content);
            console.log(`✅ Updated ${file} with navigation`);
        } else {
            console.log(`ℹ️  ${file} might already have navigation or needs manual update`);
        }
    } catch (error) {
        console.error(`Error updating ${file}:`, error.message);
    }
}
