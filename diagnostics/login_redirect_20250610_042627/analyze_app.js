const fs = require('fs');

const content = fs.readFileSync('src/ExistingApp.jsx', 'utf8');

// Check for view state management
const hasViewState = content.includes('currentView') || content.includes('activeView');
const hasIsAuthenticated = content.includes('isAuthenticated');
const hasNavigate = content.includes('useNavigate') || content.includes('navigate');
const hasConditionalRendering = content.includes('isAuthenticated ?') || content.includes('state.isAuthenticated');

console.log('Navigation Analysis:');
console.log('- Has view state:', hasViewState);
console.log('- Has isAuthenticated check:', hasIsAuthenticated);
console.log('- Has navigate function:', hasNavigate);
console.log('- Has conditional rendering:', hasConditionalRendering);

// Extract view switching logic
const viewSwitchMatch = content.match(/switch\s*\([^)]+\)\s*{[\s\S]*?}/);
if (viewSwitchMatch) {
    console.log('\nFound view switching logic');
}

// Check for authentication-based rendering
const authRenderMatch = content.match(/\{[^}]*isAuthenticated[^}]*\?[^}]*:[^}]*\}/);
if (authRenderMatch) {
    console.log('\nFound authentication-based rendering');
}
