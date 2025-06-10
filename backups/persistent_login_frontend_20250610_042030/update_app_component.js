const fs = require('fs');

function updateAppComponent(filePath) {
    let content = fs.readFileSync(filePath, 'utf8');
    
    // Check if useAuthPersistence is already imported
    if (!content.includes('useAuthPersistence')) {
        // Add import
        const importPattern = /import .* from ['"]react['"]/;
        const authPersistenceImport = `\nimport { useAuthPersistence } from './hooks/useAuthPersistence';`;
        
        if (importPattern.test(content)) {
            content = content.replace(importPattern, (match) => `${match}${authPersistenceImport}`);
        } else {
            // Add at the beginning after other imports
            const firstImport = content.match(/import .* from .*/);
            if (firstImport) {
                content = content.replace(firstImport[0], firstImport[0] + authPersistenceImport);
            }
        }
        
        // Add the hook usage
        const componentPattern = /function\s+\w+\s*\(\s*\)\s*{/;
        const hookUsage = `
    // Initialize persistent authentication
    useAuthPersistence();
`;
        
        content = content.replace(componentPattern, (match) => `${match}${hookUsage}`);
    }
    
    fs.writeFileSync(filePath, content);
    console.log(`Updated App component: ${filePath}`);
}

// Update the App component
const appComponents = ['src/App.jsx', 'src/ExistingApp.jsx'];
for (const component of appComponents) {
    if (fs.existsSync(component)) {
        updateAppComponent(component);
    }
}
