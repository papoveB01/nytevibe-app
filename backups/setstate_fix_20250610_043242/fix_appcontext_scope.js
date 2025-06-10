import { readFileSync, writeFileSync } from 'fs';

try {
    let content = readFileSync('src/context/AppContext.jsx', 'utf8');
    
    // First, let's properly analyze the structure
    console.log('Analyzing AppContext structure...');
    
    // Check if actions are defined inside or outside the component
    const hasActionsInside = content.includes('const actions = {') && 
                            content.indexOf('const actions = {') > content.indexOf('export function AppProvider');
    
    if (hasActionsInside) {
        console.log('✓ Actions are defined inside component (good for setState access)');
        
        // Fix the setView action to ensure it's properly defined
        if (content.includes('setView:')) {
            // Remove the broken setView first
            content = content.replace(/setView:\s*\([^)]*\)\s*=>\s*{[^}]*},?/s, '');
        }
        
        // Add setView properly within the actions object
        content = content.replace(
            /const actions = {/,
            `const actions = {
        setView: (view) => {
            setState(prev => ({ ...prev, currentView: view }));
        },`
        );
        
    } else {
        console.log('⚠️  Actions might be defined outside component - need to restructure');
        
        // We need to move actions inside the component
        // This is more complex - let's create a proper structure
        
        // Remove any existing actions definition outside
        content = content.replace(/const actions = {[\s\S]*?};[\s\S]*?export function AppProvider/, 'export function AppProvider');
        
        // Add actions inside the component after state definition
        const statePattern = /const \[state, setState\] = useState\([^)]+\);/;
        const actionsDefinition = `
    
    const actions = {
        setView: (view) => {
            setState(prev => ({ ...prev, currentView: view }));
        },
        
        login: async (credentials, rememberMe = false) => {
            setState(prev => ({ ...prev, isLoading: true }));
            try {
                const response = await authAPI.login(credentials, rememberMe);
                if (response.success) {
                    setState(prev => ({
                        ...prev,
                        user: response.data.user,
                        isAuthenticated: true,
                        isLoading: false,
                        currentView: 'home'
                    }));
                    return { success: true };
                } else {
                    setState(prev => ({ ...prev, isLoading: false }));
                    return response;
                }
            } catch (error) {
                setState(prev => ({ ...prev, isLoading: false }));
                throw error;
            }
        },
        
        logout: () => {
            authAPI.clearAuth();
            setState(prev => ({
                ...prev,
                user: null,
                isAuthenticated: false,
                currentView: 'landing'
            }));
        },
        
        setUser: (user) => {
            setState(prev => ({
                ...prev,
                user,
                isAuthenticated: true
            }));
        },
        
        setInitialized: () => {
            setState(prev => ({ ...prev, isLoading: false }));
        }
    };`;
        
        content = content.replace(statePattern, (match) => `${match}${actionsDefinition}`);
    }
    
    // Ensure currentView is in initial state
    if (!content.includes('currentView:')) {
        content = content.replace(
            /useState\(\s*{/,
            `useState({
        currentView: 'landing',`
        );
    }
    
    // Make sure authAPI is imported
    if (!content.includes('import authAPI')) {
        content = content.replace(
            /import.*from\s+['"]react['"]/,
            `import React, { createContext, useContext, useState, useEffect } from 'react';
import authAPI from '../services/authAPI';`
        );
    }
    
    writeFileSync('src/context/AppContext.jsx', content);
    console.log('✅ AppContext.jsx fixed successfully');
    
} catch (error) {
    console.error('Error:', error.message);
}
