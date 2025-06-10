// Authentication API Service
// Handles all authentication-related API calls

class AuthAPI {
    constructor() {
        this.baseURL = 'https://system.nytevibe.com/api';
        this.tokenKey = 'auth_token';
        this.tokenExpiryKey = 'token_expires_at';
        this.rememberMeKey = 'remember_me';
        this.userDataKey = 'user_data';
    }

    // Helper method to get headers with auth token
    getAuthHeaders() {
        const token = this.getToken();
        return {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            ...(token && { 'Authorization': `Bearer ${token}` })
        };
    }

    // Login with remember me support
    async login(credentials, rememberMe = false) {
        try {
            console.log('🔐 Attempting login...');
            
            const response = await fetch(`${this.baseURL}/auth/login`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json',
                },
                body: JSON.stringify({
                    ...credentials,
                    remember_me: rememberMe
                }),
            });

            const data = await response.json();

            if (response.ok && data.success) {
                // Store authentication data
                this.setAuthData(data.data);
                console.log('✅ Login successful');
                return data;
            } else {
                console.error('❌ Login failed:', data.message);
                return data;
            }
        } catch (error) {
            console.error('❌ Login error:', error);
            return {
                success: false,
                message: error.message || 'Network error occurred'
            };
        }
    }

    // Validate current token
    async validateToken() {
        const token = this.getToken();
        if (!token) {
            return { valid: false, message: 'No token found' };
        }

        try {
            const response = await fetch(`${this.baseURL}/auth/validate-token`, {
                method: 'GET',
                headers: this.getAuthHeaders(),
            });

            const data = await response.json();
            
            if (response.ok && data.success) {
                // Update user data if validation successful
                if (data.data.user) {
                    localStorage.setItem(this.userDataKey, JSON.stringify(data.data.user));
                }
                return { 
                    valid: true, 
                    user: data.data.user,
                    expires_at: data.data.expires_at 
                };
            } else {
                this.clearAuth();
                return { valid: false, message: data.message };
            }
        } catch (error) {
            console.error('Token validation error:', error);
            this.clearAuth();
            return { valid: false, message: 'Network error' };
        }
    }

    // Refresh authentication token
    async refreshToken() {
        const token = this.getToken();
        if (!token) return null;

        try {
            const response = await fetch(`${this.baseURL}/auth/refresh-token`, {
                method: 'POST',
                headers: this.getAuthHeaders(),
            });

            const data = await response.json();

            if (response.ok && data.success) {
                // Update token and expiration
                localStorage.setItem(this.tokenKey, data.data.token);
                localStorage.setItem(this.tokenExpiryKey, data.data.token_expires_at);
                console.log('✅ Token refreshed successfully');
                return data.data;
            } else {
                console.error('Token refresh failed:', data.message);
                return null;
            }
        } catch (error) {
            console.error('Token refresh error:', error);
            return null;
        }
    }

    // Logout
    async logout() {
        try {
            const token = this.getToken();
            if (token) {
                await fetch(`${this.baseURL}/auth/logout`, {
                    method: 'POST',
                    headers: this.getAuthHeaders(),
                });
            }
        } catch (error) {
            console.error('Logout error:', error);
        } finally {
            this.clearAuth();
        }
    }

    // Get current user
    async getUser() {
        try {
            const response = await fetch(`${this.baseURL}/auth/user`, {
                method: 'GET',
                headers: this.getAuthHeaders(),
            });

            const data = await response.json();

            if (response.ok && data.success) {
                return data.data;
            } else {
                return null;
            }
        } catch (error) {
            console.error('Get user error:', error);
            return null;
        }
    }

    // Check if token is expired or near expiration
    isTokenExpired() {
        const expiresAt = localStorage.getItem(this.tokenExpiryKey);
        if (!expiresAt) return true;

        const expirationDate = new Date(expiresAt);
        const now = new Date();
        
        // Check if token expires in less than 24 hours
        const hoursUntilExpiry = (expirationDate - now) / (1000 * 60 * 60);
        return hoursUntilExpiry < 24;
    }

    // Set authentication data in localStorage
    setAuthData(authData) {
        if (authData.token) {
            localStorage.setItem(this.tokenKey, authData.token);
        }
        if (authData.token_expires_at) {
            localStorage.setItem(this.tokenExpiryKey, authData.token_expires_at);
        }
        if (authData.remember_me !== undefined) {
            localStorage.setItem(this.rememberMeKey, JSON.stringify(authData.remember_me));
        }
        if (authData.user) {
            localStorage.setItem(this.userDataKey, JSON.stringify(authData.user));
        }
    }

    // Clear all authentication data
    clearAuth() {
        localStorage.removeItem(this.tokenKey);
        localStorage.removeItem(this.tokenExpiryKey);
        localStorage.removeItem(this.rememberMeKey);
        localStorage.removeItem(this.userDataKey);
    }

    // Get stored token
    getToken() {
        return localStorage.getItem(this.tokenKey);
    }

    // Get stored user data
    getStoredUser() {
        const userData = localStorage.getItem(this.userDataKey);
        return userData ? JSON.parse(userData) : null;
    }

    // Check if user is authenticated
    isAuthenticated() {
        return !!this.getToken();
    }

    // Check if remember me was selected
    isRememberMe() {
        const rememberMe = localStorage.getItem(this.rememberMeKey);
        return rememberMe ? JSON.parse(rememberMe) : false;
    }

    // Email verification
    async verifyEmail(userId, hash, expires, signature) {
        try {
            const params = new URLSearchParams({
                expires,
                signature
            });

            const response = await fetch(
                `${this.baseURL}/email/verify/${userId}/${hash}?${params}`,
                {
                    method: 'GET',
                    headers: this.getAuthHeaders(),
                }
            );

            return await response.json();
        } catch (error) {
            console.error('Email verification error:', error);
            return {
                success: false,
                message: 'Network error occurred'
            };
        }
    }

    // Resend verification email
    async resendVerificationEmail() {
        try {
            const response = await fetch(`${this.baseURL}/auth/resend-verification`, {
                method: 'POST',
                headers: this.getAuthHeaders(),
            });

            return await response.json();
        } catch (error) {
            console.error('Resend verification error:', error);
            return {
                success: false,
                message: 'Network error occurred'
            };
        }
    }

    // Forgot password
    async forgotPassword(email) {
        try {
            const response = await fetch(`${this.baseURL}/auth/forgot-password`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json',
                },
                body: JSON.stringify({ email }),
            });

            return await response.json();
        } catch (error) {
            console.error('Forgot password error:', error);
            return {
                success: false,
                message: 'Network error occurred'
            };
        }
    }

    // Reset password
    async resetPassword(data) {
        try {
            const response = await fetch(`${this.baseURL}/auth/reset-password`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json',
                },
                body: JSON.stringify(data),
            });

            return await response.json();
        } catch (error) {
            console.error('Reset password error:', error);
            return {
                success: false,
                message: 'Network error occurred'
            };
        }
    }

    // Verify reset token
    async verifyResetToken(token) {
        try {
            const response = await fetch(`${this.baseURL}/auth/verify-reset-token`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json',
                },
                body: JSON.stringify({ token }),
            });

            return await response.json();
        } catch (error) {
            console.error('Verify reset token error:', error);
            return {
                success: false,
                message: 'Network error occurred'
            };
        }
    }
}

export default new AuthAPI();
