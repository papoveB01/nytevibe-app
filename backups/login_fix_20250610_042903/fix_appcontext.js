import { readFileSync, writeFileSync } from 'fs';

try {
    let content = readFileSync('src/context/AppContext.jsx', 'utf8');
    
    // Add currentView to initial state if missing
    if (!content.includes('currentView:')) {
        content = content.replace(
            /const \[state, setState\] = useState\(\{/,
            `const [state, setState] = useState({
        currentView: 'landing',`
        );
        console.log('✓ Added currentView to state');
    }
    
    // Add setView action if missing
    if (!content.includes('setView:')) {
        content = content.replace(
            /const actions = \{/,
            `const actions = {
        setView: (view) => {
            setState(prev => ({ ...prev, currentView: view }));
        },`
        );
        console.log('✓ Added setView action');
    }
    
    // Update login action to set currentView to 'home'
    const loginPattern = /setState\(prev => \(\{[\s\S]*?isAuthenticated: true,[\s\S]*?\}\)\);/g;
    let updatedLogin = false;
    
    content = content.replace(loginPattern, (match) => {
        if (!match.includes('currentView:')) {
            updatedLogin = true;
            return match.replace(
                'isAuthenticated: true,',
                `isAuthenticated: true,
                        currentView: 'home',`
            );
        }
        return match;
    });
    
    if (updatedLogin) {
        console.log('✓ Updated login to navigate to home');
    }
    
    writeFileSync('src/context/AppContext.jsx', content);
    console.log('✅ AppContext.jsx updated successfully');
} catch (error) {
    console.error('Error updating AppContext:', error.message);
}
