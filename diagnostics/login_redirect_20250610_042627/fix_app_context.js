const fs = require('fs');

let content = fs.readFileSync('src/context/AppContext.jsx', 'utf8');

// Check if setView exists
if (!content.includes('setView')) {
    // Add setView to actions
    const actionsPattern = /const actions = {/;
    const setViewAction = `
        setView: (view) => {
            setState(prev => ({ ...prev, currentView: view }));
        },`;
    
    content = content.replace(actionsPattern, `const actions = {${setViewAction}`);
    
    // Add currentView to initial state if not exists
    if (!content.includes('currentView')) {
        const statePattern = /useState\(\s*{/;
        content = content.replace(statePattern, `useState({
        currentView: 'landing',`);
    }
}

// Update login action to set view after success
const loginSuccessPattern = /setState\(prev => \({[\s\S]*?isAuthenticated: true,[\s\S]*?}\)\);/;
const updatedLoginSuccess = content.match(loginSuccessPattern)?.[0]?.replace(
    'isAuthenticated: true,',
    'isAuthenticated: true,\n                        currentView: \'home\','
);

if (updatedLoginSuccess) {
    content = content.replace(loginSuccessPattern, updatedLoginSuccess);
}

fs.writeFileSync('src/context/AppContext.jsx.fixed', content);
console.log('Created fixed AppContext at: src/context/AppContext.jsx.fixed');
