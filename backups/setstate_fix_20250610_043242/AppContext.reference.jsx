// AppContext.jsx - Reference Implementation
import React, { createContext, useContext, useState, useEffect } from 'react';
import authAPI from '../services/authAPI';

const AppContext = createContext();

export function AppProvider({ children }) {
    const [state, setState] = useState({
        currentView: 'landing',
        user: null,
        isAuthenticated: false,
        isLoading: true,
        messages: [],
        notifications: []
    });

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
    }, []);

    // Define actions with access to setState
    const actions = {
        setView: (view) => {
            console.log('Setting view to:', view);
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
                        currentView: 'home'  // Navigate to home after login
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
        },
        
        addMessage: (message) => {
            setState(prev => ({
                ...prev,
                messages: [...prev.messages, { id: Date.now(), ...message }]
            }));
        },
        
        removeMessage: (id) => {
            setState(prev => ({
                ...prev,
                messages: prev.messages.filter(msg => msg.id !== id)
            }));
        }
    };

    return (
        <AppContext.Provider value={{ state, actions }}>
            {children}
        </AppContext.Provider>
    );
}

export function useApp() {
    const context = useContext(AppContext);
    if (!context) {
        throw new Error('useApp must be used within an AppProvider');
    }
    return context;
}
