import { readFileSync, writeFileSync } from 'fs';

try {
    let content = readFileSync('src/ExistingApp.jsx', 'utf8');
    
    // Add useEffect import if missing
    if (!content.includes('useEffect') && content.includes('import React')) {
        content = content.replace(
            /import React from 'react'/,
            "import React, { useEffect } from 'react'"
        );
    } else if (!content.includes('useEffect')) {
        content = content.replace(
            /from 'react'/,
            ", useEffect } from 'react'"
        );
    }
    
    // Add navigation effect after useApp() if not present
    if (!content.includes('Auto-navigate authenticated users')) {
        const navEffect = `
    // Auto-navigate authenticated users away from login
    useEffect(() => {
        if (state.isAuthenticated && ['login', 'register'].includes(state.currentView)) {
            actions.setView('home');
        }
    }, [state.isAuthenticated, state.currentView]);`;
        
        // Insert after useApp() call
        content = content.replace(
            /const \{ state, actions \} = useApp\(\);/,
            `const { state, actions } = useApp();${navEffect}`
        );
        console.log('✓ Added auto-navigation effect');
    }
    
    // Ensure view rendering uses currentView
    if (content.includes('switch') && content.includes('currentView')) {
        console.log('✓ View switching already uses currentView');
    } else {
        console.log('⚠️  You may need to update view rendering to use state.currentView');
    }
    
    writeFileSync('src/ExistingApp.jsx', content);
    console.log('✅ ExistingApp.jsx updated successfully');
} catch (error) {
    console.error('Error updating ExistingApp:', error.message);
}
