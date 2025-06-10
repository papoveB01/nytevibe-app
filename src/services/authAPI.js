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

    // 🔥 FIXED: Login with better response handling
    async login(credentials, rememberMe = false) {
        try {
            console.log('🔐 AuthAPI: Attempting login...', { 
                username: credentials.username, 
                rememberMe 
            });
            
            const response = await fetch(`${this.baseURL}/auth/login`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json',
                },
                body: JSON.stringify({
                    username: credentials.username || credentials.email,
                    email: credentials.username || credentials.email,
                    password: credentials.password,
                    remember_me: rememberMe
                }),
            });

            // Parse response
            let data;
            try {
                data = await response.json();
            } catch (parseError) {
                console.error('❌ AuthAPI: Failed to parse response JSON:', parseError);
                return {
                    success: false,
                    message: 'Invalid response from server'
                };
            }

            console.log('🔐 AuthAPI: Raw server response:', {
                status: response.status,
                statusText: response.statusText,
                ok: response.ok,
                data: data
            });

            // 🔥 CRITICAL FIX: Better success detection
            // Handle different possible response structures from your backend
            const isSuccess = this.isLoginSuccessful(response, data);
            
            if (isSuccess) {
                console.log('✅ AuthAPI: Login determined successful');
                
                // Store authentication data
                this.setAuthData(data.data || data);
                
                return {
                    success: true,
                    data: data.data || data,
                    message: data.message || 'Login successful'
                };
            } else {
                console.log('❌ AuthAPI: Login determined failed');
                
                const errorMessage = this.extractErrorMessage(data, response);
                return {
                    success: false,
                    message: errorMessage
                };
            }
            
        } catch (error) {
            console.error('❌ AuthAPI: Network error during login:', error);
            return {
                success: false,
                message: `Network error: ${error.message}`
            };
        }
    }

    // 🔥 NEW: Smart success detection for different backend response formats
    isLoginSuccessful(response, data) {
        // Method 1: Check HTTP status and explicit success field
        if (response.ok && data.success === true) {
            console.log('✅ Success detected: HTTP OK + success:true');
            return true;
        }
        
        // Method 2: Check HTTP status and success message
        if (response.ok && data.message && data.message.toLowerCase().includes('success')) {
            console.log('✅ Success detected: HTTP OK + success message');
            return true;
        }
        
        // Method 3: Check for presence of token/user data (even if success field is missing)
        if (response.ok && (data.token || (data.data && data.data.token))) {
            console.log('✅ Success detected: HTTP OK + token present');
            return true;
        }
        
        // Method 4: Check status field (some APIs use 'status' instead of 'success')
        if (response.ok && (data.status === 'success' || data.status === true)) {
            console.log('✅ Success detected: HTTP OK + status success');
            return true;
        }
        
        console.log('❌ No success conditions met');
        return false;
    }

    // 🔥 NEW: Smart error message extraction
    extractErrorMessage(data, response) {
        // Try different error message fields
        if (data.message && !data.message.toLowerCase().includes('success')) {
            return data.message;
        }
        
        if (data.error) {
            return data.error;
        }
        
        if (data.errors && Array.isArray(data.errors) && data.errors.length > 0) {
            return data.errors[0];
        }
        
        if (data.errors && typeof data.errors === 'object') {
            const firstError = Object.values(data.errors)[0];
            return Array.isArray(firstError) ? firstError[0] : firstError;
        }
        
        // Fallback to HTTP status
        return `Login failed (${response.status}: ${response.statusText})`;
    }

    // Validate current token
    async validateToken() {
        const token = this.getToken();
        if (!token) {
            return { valid: false, message: 'No token found' };
        }

        try {
            console.log('🔍 AuthAPI: Validating token...');
            const response = await fetch(`${this.baseURL}/auth/validate-token`, {
                method: 'GET',
                headers: this.getAuthHeaders(),
            });

            const data = await response.json();
            
            if (response.ok && (data.success || data.valid)) {
                // Update user data if validation successful
                if (data.data && data.data.user) {
                    localStorage.setItem(this.userDataKey, JSON.stringify(data.data.user));
                } else if (data.user) {
                    localStorage.setItem(this.userDataKey, JSON.stringify(data.user));
                }
                
                console.log('✅ AuthAPI: Token validation successful');
                return { 
                    valid: true, 
                    user: data.data?.user || data.user,
                    expires_at: data.data?.expires_at || data.expires_at
                };
            } else {
                console.log('❌ AuthAPI: Token validation failed');
                this.clearAuth();
                return { valid: false, message: data.message || 'Token invalid' };
            }
        } catch (error) {
            console.error('❌ AuthAPI: Token validation error:', error);
            this.clearAuth();
            return { valid: false, message: 'Network error' };
        }
    }

    // Refresh authentication token
    async refreshToken() {
        const token = this.getToken();
        if (!token) return null;

        try {
            console.log('🔄 AuthAPI: Refreshing token...');
            const response = await fetch(`${this.baseURL}/auth/refresh-token`, {
                method: 'POST',
                headers: this.getAuthHeaders(),
            });

            const data = await response.json();

            if (response.ok && (data.success || data.token)) {
                // Update token and expiration
                const newToken = data.data?.token || data.token;
                const newExpiry = data.data?.token_expires_at || data.token_expires_at || data.expires_at;
                
                if (newToken) {
                    localStorage.setItem(this.tokenKey, newToken);
                }
                if (newExpiry) {
                    localStorage.setItem(this.tokenExpiryKey, newExpiry);
                }
                
                console.log('✅ AuthAPI: Token refreshed successfully');
                return data.data || data;
            } else {
                console.error('❌ AuthAPI: Token refresh failed:', data.message);
                return null;
            }
        } catch (error) {
            console.error('❌ AuthAPI: Token refresh error:', error);
            return null;
        }
    }

    // Logout
    async logout() {
        try {
            const token = this.getToken();
            if (token) {
                console.log('🚪 AuthAPI: Logging out...');
                await fetch(`${this.baseURL}/auth/logout`, {
                    method: 'POST',
                    headers: this.getAuthHeaders(),
                });
            }
        } catch (error) {
            console.error('❌ AuthAPI: Logout error:', error);
        } finally {
            this.clearAuth();
            console.log('✅ AuthAPI: Logout complete');
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

            if (response.ok && (data.success || data.user)) {
                return data.data || data.user;
            } else {
                return null;
            }
        } catch (error) {
            console.error('❌ AuthAPI: Get user error:', error);
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

    // 🔥 IMPROVED: Set authentication data with better error handling
    setAuthData(authData) {
        console.log('💾 AuthAPI: Storing auth data:', authData);
        
        try {
            // Handle nested data structure (data.data.token vs data.token)
            const token = authData.token || authData.access_token;
            const user = authData.user;
            const expiresAt = authData.token_expires_at || authData.expires_at;
            const rememberMe = authData.remember_me;
            
            if (token) {
                localStorage.setItem(this.tokenKey, token);
                console.log('💾 AuthAPI: Token stored');
            } else {
                console.warn('⚠️ AuthAPI: No token found in auth data');
            }
            
            if (expiresAt) {
                localStorage.setItem(this.tokenExpiryKey, expiresAt);
                console.log('💾 AuthAPI: Token expiry stored');
            }
            
            if (rememberMe !== undefined) {
                localStorage.setItem(this.rememberMeKey, JSON.stringify(rememberMe));
                console.log('💾 AuthAPI: Remember me stored:', rememberMe);
            }
            
            if (user) {
                localStorage.setItem(this.userDataKey, JSON.stringify(user));
                console.log('💾 AuthAPI: User data stored');
            } else {
                console.warn('⚠️ AuthAPI: No user data found in auth data');
            }
        } catch (error) {
            console.error('❌ AuthAPI: Error storing auth data:', error);
        }
    }

    // Get stored auth data
    getStoredAuth() {
        const token = this.getToken();
        const user = this.getStoredUser();
        const expiresAt = localStorage.getItem(this.tokenExpiryKey);
        const rememberMe = this.isRememberMe();

        if (!token) return null;

        return {
            token,
            user,
            token_expires_at: expiresAt,
            remember_me: rememberMe
        };
    }

    // Clear all authentication data
    clearAuth() {
        console.log('🧹 AuthAPI: Clearing all auth data');
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
        try {
            const userData = localStorage.getItem(this.userDataKey);
            return userData ? JSON.parse(userData) : null;
        } catch (error) {
            console.error('Error parsing stored user data:', error);
            return null;
        }
    }

    // Check if user is authenticated
    isAuthenticated() {
        return !!this.getToken();
    }

    // Check if remember me was selected
    isRememberMe() {
        try {
            const rememberMe = localStorage.getItem(this.rememberMeKey);
            return rememberMe ? JSON.parse(rememberMe) : false;
        } catch (error) {
            console.error('Error parsing remember me value:', error);
            return false;
        }
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
            console.error('❌ AuthAPI: Email verification error:', error);
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
            console.error('❌ AuthAPI: Resend verification error:', error);
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
            console.error('❌ AuthAPI: Forgot password error:', error);
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
            console.error('❌ AuthAPI: Reset password error:', error);
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
            console.error('❌ AuthAPI: Verify reset token error:', error);
            return {
                success: false,
                message: 'Network error occurred'
            };
        }
    }
}

export default new AuthAPI();
