import { readFileSync, writeFileSync } from 'fs';

try {
    let content = readFileSync('src/ExistingApp.jsx', 'utf8');
    
    // Ensure useEffect is imported
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
    
    // Add navigation effect if not present
    if (!content.includes('Auto-navigate authenticated users')) {
        const navEffect = `
    // Auto-navigate authenticated users from auth pages
    useEffect(() => {
        console.log('Auth state:', state.isAuthenticated, 'Current view:', state.currentView);
        
        // If authenticated and still on login/register, go to home
        if (state.isAuthenticated && ['login', 'register', 'landing'].includes(state.currentView)) {
            console.log('Authenticated user on auth page, navigating to home...');
            actions.setView('home');
        }
        
        // If not authenticated and trying to access protected views, go to login
        if (!state.isAuthenticated && !['landing', 'login', 'register', 'reset-password'].includes(state.currentView)) {
            console.log('Unauthenticated user on protected page, navigating to login...');
            actions.setView('login');
        }
    }, [state.isAuthenticated, state.currentView, actions]);`;
        
        // Insert after useApp() call
        const insertPattern = /const \{ state, actions \} = useApp\(\);/;
        if (insertPattern.test(content)) {
            content = content.replace(
                insertPattern,
                `const { state, actions } = useApp();${navEffect}`
            );
        }
        console.log('✓ Added auto-navigation effect');
    }
    
    // Fix the view rendering to properly use currentView
    if (!content.includes('renderCurrentView') && content.includes('return (')) {
        // Add renderCurrentView function
        const renderFunction = `
    // Render the appropriate view based on state
    const renderCurrentView = () => {
        console.log('Rendering view:', state.currentView, 'Authenticated:', state.isAuthenticated);
        
        // Loading state
        if (state.isLoading) {
            return <div>Loading...</div>;
        }
        
        // Route based on currentView
        switch (state.currentView) {
            case 'landing':
                return state.isAuthenticated ? <HomeView /> : <LandingView />;
                
            case 'login':
                return state.isAuthenticated ? <HomeView /> : <LoginView />;
                
            case 'register':
                return state.isAuthenticated ? <HomeView /> : <RegistrationView />;
                
            case 'home':
                return state.isAuthenticated ? <HomeView /> : <LoginView />;
                
            case 'profile':
                return state.isAuthenticated ? <ProfileView /> : <LoginView />;
                
            case 'venue-details':
                return state.isAuthenticated ? <VenueDetailsView /> : <LoginView />;
                
            case 'reset-password':
                return <ResetPasswordView />;
                
            case 'email-verification':
                return <EmailVerificationView />;
                
            default:
                console.log('Unknown view:', state.currentView);
                return state.isAuthenticated ? <HomeView /> : <LandingView />;
        }
    };`;
        
        // Insert before return statement
        const returnPattern = /return \(/;
        content = content.replace(returnPattern, renderFunction + '\n\n    return (');
        
        // Update the JSX to use renderCurrentView
        content = content.replace(
            /<div className="App">[\s\S]*?<\/div>/,
            `<div className="App">
            {renderCurrentView()}
        </div>`
        );
        
        console.log('✓ Added renderCurrentView function');
    }
    
    writeFileSync('src/ExistingApp.jsx', content);
    console.log('\n✅ ExistingApp.jsx updated successfully');
    
} catch (error) {
    console.error('Error:', error.message);
}
