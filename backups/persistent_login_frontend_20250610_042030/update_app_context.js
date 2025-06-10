const fs = require('fs');

// Read the current AppContext
let content = fs.readFileSync('src/context/AppContext.jsx', 'utf8');

// Check if we need to add setInitialized action
if (!content.includes('setInitialized')) {
    // Add setInitialized to actions
    const actionsPattern = /const actions = {/;
    const setInitializedAction = `
        setInitialized: () => {
            setState(prev => ({ ...prev, isLoading: false }));
        },
        
        setUser: (user) => {
            setState(prev => ({
                ...prev,
                user,
                isAuthenticated: true
            }));
        },`;

    if (!content.includes('setUser:')) {
        content = content.replace(actionsPattern, `const actions = {${setInitializedAction}`);
    } else {
        content = content.replace(actionsPattern, `const actions = {
        setInitialized: () => {
            setState(prev => ({ ...prev, isLoading: false }));
        },`);
    }
}

// Update the login action to support rememberMe
const loginPattern = /login:\s*async\s*\([^)]*\)\s*=>\s*{[^}]+}/s;
const newLoginAction = `login: async (credentials, rememberMe = false) => {
            setState(prev => ({ ...prev, isLoading: true }));
            try {
                const response = await authAPI.login(credentials, rememberMe);
                if (response.success) {
                    setState(prev => ({
                        ...prev,
                        user: response.data.user,
                        isAuthenticated: true,
                        isLoading: false
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
        }`;

content = content.replace(loginPattern, newLoginAction);

// Add initialization effect if not present
if (!content.includes('Initialize auth from localStorage')) {
    const providerPattern = /export function AppProvider\(\{ children \}\) {/;
    const initEffect = `
    // Initialize auth from localStorage
    useEffect(() => {
        const initializeAuth = async () => {
            const token = localStorage.getItem('auth_token');
            if (token) {
                const validation = await authAPI.validateToken();
                if (validation.valid) {
                    setState(prev => ({
                        ...prev,
                        user: validation.user,
                        isAuthenticated: true,
                        isLoading: false
                    }));
                } else {
                    setState(prev => ({
                        ...prev,
                        isLoading: false
                    }));
                }
            } else {
                setState(prev => ({
                    ...prev,
                    isLoading: false
                }));
            }
        };

        initializeAuth();
    }, []);`;

    // Find where to insert the effect
    const statePattern = /const \[state, setState\] = useState\([^)]+\);/;
    content = content.replace(statePattern, (match) => `${match}\n${initEffect}`);
}

// Ensure authAPI is imported
if (!content.includes("import authAPI from")) {
    content = content.replace(
        /import .* from ['"]react['"]/,
        `import React, { createContext, useContext, useState, useEffect } from 'react';\nimport authAPI from '../services/authAPI';`
    );
}

fs.writeFileSync('src/context/AppContext.jsx', content);
console.log('AppContext updated successfully');
