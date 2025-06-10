const fs = require('fs');

let content = fs.readFileSync('src/ExistingApp.jsx', 'utf8');

// Check how views are rendered
const hasViewSwitch = content.includes('switch');
const hasConditionalRender = content.includes('isAuthenticated ?');

// Create a proper view rendering fix
const viewRenderFix = `
    // Render view based on authentication and current view
    const renderView = () => {
        // If not authenticated and trying to access protected views
        if (!state.isAuthenticated && !['landing', 'login', 'register', 'reset-password'].includes(state.currentView)) {
            return <LoginView />;
        }

        // If authenticated and on auth pages, redirect to home
        if (state.isAuthenticated && ['login', 'register'].includes(state.currentView)) {
            actions.setView('home');
            return <HomeView />;
        }

        // Render based on current view
        switch (state.currentView) {
            case 'landing':
                return state.isAuthenticated ? <HomeView /> : <LandingView />;
            case 'login':
                return <LoginView />;
            case 'register':
                return <RegistrationView />;
            case 'home':
                return <HomeView />;
            case 'profile':
                return <ProfileView />;
            case 'venue-details':
                return <VenueDetailsView />;
            default:
                return state.isAuthenticated ? <HomeView /> : <LandingView />;
        }
    };`;

console.log('View rendering fix created. You may need to manually integrate this.');

// Save the fix suggestion
fs.writeFileSync('src/ExistingApp.jsx.fix_suggestion.js', viewRenderFix);
