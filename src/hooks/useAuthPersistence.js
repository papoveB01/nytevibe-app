import { useEffect, useCallback, useRef } from 'react';
import { useApp } from '../context/AppContext';
import authAPI from '../services/authAPI';

/**
 * Custom hook to manage persistent authentication
 * Handles token validation, refresh, and automatic logout
 * 🔥 IMPORTANT: This hook does NOT interfere with the login flow
 */
export function useAuthPersistence() {
    const { state, actions } = useApp();
    const checkIntervalRef = useRef(null);
    const isCheckingRef = useRef(false);
    const isInitializedRef = useRef(false);

    const checkAndRefreshToken = useCallback(async () => {
        // Prevent concurrent checks
        if (isCheckingRef.current) return false;
        
        // Don't interfere during loading/initialization
        if (state.isLoading && !isInitializedRef.current) {
            console.log('🔄 AuthPersistence: Skipping check during initialization');
            return false;
        }
        
        try {
            isCheckingRef.current = true;

            // If not authenticated, nothing to check
            if (!authAPI.isAuthenticated()) {
                console.log('🔄 AuthPersistence: No auth token found');
                return false;
            }

            // Check if token needs refresh (expires in less than 24 hours)
            if (authAPI.isTokenExpired()) {
                console.log('🔄 AuthPersistence: Token expiring soon, attempting refresh...');
                const refreshResult = await authAPI.refreshToken();
                
                if (!refreshResult) {
                    console.log('❌ AuthPersistence: Token refresh failed, logging out...');
                    actions.logout();
                    return false;
                }
                
                console.log('✅ AuthPersistence: Token refreshed successfully');
            }

            // Validate token and get latest user data
            const validation = await authAPI.validateToken();
            
            if (!validation.valid) {
                console.log('❌ AuthPersistence: Token validation failed, logging out...');
                actions.logout();
                return false;
            }

            // Update user state if needed (but don't force view changes)
            if (validation.user && (!state.user || state.user.id !== validation.user.id)) {
                console.log('🔄 AuthPersistence: Updating user data');
                actions.setUser(validation.user);
            }

            return true;
        } catch (error) {
            console.error('❌ AuthPersistence: Error during token check:', error);
            return false;
        } finally {
            isCheckingRef.current = false;
        }
    }, [actions, state.user, state.isLoading]);

    // 🔥 REMOVE: Initialize auth on mount (let AppContext handle this)
    // This was causing interference with the login flow
    // useEffect(() => {
    //     const initializeAuth = async () => {
    //         // Check for stored authentication
    //         if (authAPI.isAuthenticated()) {
    //             console.log('🔐 Found stored authentication, validating...');
    //             const isValid = await checkAndRefreshToken();
    //             
    //             if (isValid) {
    //                 console.log('✅ Authentication restored successfully');
    //             } else {
    //                 console.log('❌ Stored authentication invalid');
    //             }
    //         }
    //         
    //         // Mark app as initialized
    //         if (actions.setInitialized) {
    //             actions.setInitialized();
    //         }
    //     };

    //     initializeAuth();
    // }, []); // Only run on mount

    // Mark as initialized when loading completes
    useEffect(() => {
        if (!state.isLoading && !isInitializedRef.current) {
            console.log('🏁 AuthPersistence: App initialization complete');
            isInitializedRef.current = true;
        }
    }, [state.isLoading]);

    // Set up periodic token check - only after initialization
    useEffect(() => {
        // Only set up interval if authenticated and initialized
        if (state.isAuthenticated && isInitializedRef.current) {
            console.log('⏰ AuthPersistence: Setting up periodic token checks');
            
            // Check every hour
            checkIntervalRef.current = setInterval(() => {
                console.log('⏰ AuthPersistence: Periodic auth check...');
                checkAndRefreshToken();
            }, 60 * 60 * 1000); // 1 hour
        }

        return () => {
            if (checkIntervalRef.current) {
                clearInterval(checkIntervalRef.current);
                checkIntervalRef.current = null;
            }
        };
    }, [state.isAuthenticated, checkAndRefreshToken]);

    // Check auth on window focus - only after initialization
    useEffect(() => {
        const handleFocus = () => {
            if (state.isAuthenticated && isInitializedRef.current) {
                console.log('👀 AuthPersistence: Window focused, checking auth...');
                checkAndRefreshToken();
            }
        };

        window.addEventListener('focus', handleFocus);

        return () => {
            window.removeEventListener('focus', handleFocus);
        };
    }, [state.isAuthenticated, checkAndRefreshToken]);

    // Check auth on visibility change (mobile support) - only after initialization
    useEffect(() => {
        const handleVisibilityChange = () => {
            if (!document.hidden && state.isAuthenticated && isInitializedRef.current) {
                console.log('📱 AuthPersistence: App visible, checking auth...');
                checkAndRefreshToken();
            }
        };

        document.addEventListener('visibilitychange', handleVisibilityChange);

        return () => {
            document.removeEventListener('visibilitychange', handleVisibilityChange);
        };
    }, [state.isAuthenticated, checkAndRefreshToken]);

    return {
        checkAndRefreshToken,
        isTokenExpired: authAPI.isTokenExpired(),
        isRememberMe: authAPI.isRememberMe(),
        isInitialized: isInitializedRef.current
    };
}
