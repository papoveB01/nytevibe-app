import { readFileSync } from 'fs';

console.log('Analyzing ExistingApp.jsx view rendering...\n');

const content = readFileSync('src/ExistingApp.jsx', 'utf8');

// Check if using currentView from state
const usesCurrentView = content.includes('state.currentView');
const hasViewSwitch = content.includes('switch') && content.includes('currentView');
const hasConditionalRendering = content.includes('isAuthenticated ?');

console.log('Diagnosis:');
console.log('- Uses state.currentView:', usesCurrentView);
console.log('- Has view switching logic:', hasViewSwitch);
console.log('- Has conditional rendering:', hasConditionalRendering);

// Check for the view rendering pattern
if (!usesCurrentView || !hasViewSwitch) {
    console.log('\n⚠️  Issue: ExistingApp may not be properly using currentView for rendering');
}

// Look for HomeView import
const hasHomeView = content.includes('HomeView');
console.log('- HomeView imported:', hasHomeView);
