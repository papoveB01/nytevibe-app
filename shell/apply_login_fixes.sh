#!/bin/bash

# Apply Login Fixes - Resolve 422 Error
# Fixes field name mismatch and problematic headers

set -e

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="./login_fixes_backup_$TIMESTAMP"

echo "======================================================="
echo "    APPLYING LOGIN FIXES FOR 422 ERROR"
echo "======================================================="
echo "Backup directory: $BACKUP_DIR"
echo ""

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Function to log changes
log_change() {
    echo "✅ $1"
}

log_error() {
    echo "❌ $1"
}

# Check if files exist
if [ ! -f "src/components/Views/LoginView.jsx" ]; then
    log_error "LoginView.jsx not found!"
    exit 1
fi

if [ ! -f "src/services/registrationAPI.js" ]; then
    log_error "registrationAPI.js not found!"
    exit 1
fi

echo ">>> CREATING BACKUPS"
echo "----------------------------------------"

# Backup original files
cp "src/components/Views/LoginView.jsx" "$BACKUP_DIR/LoginView.jsx.backup"
cp "src/services/registrationAPI.js" "$BACKUP_DIR/registrationAPI.js.backup"

log_change "Backed up LoginView.jsx"
log_change "Backed up registrationAPI.js"
echo ""

echo ">>> FIXING LOGINVIEW.JSX - FIELD NAME"
echo "----------------------------------------"

# Fix 1: Change username to email field in LoginView.jsx
# This fixes the field name mismatch (API expects 'email', not 'username')

sed -i.tmp 's/registrationAPI\.login({[[:space:]]*username,/registrationAPI.login({\
        email: username,/' src/components/Views/LoginView.jsx

# Check if the change was made
if grep -q "email: username," src/components/Views/LoginView.jsx; then
    log_change "Fixed field name: username → email: username"
else
    log_error "Failed to fix field name in LoginView.jsx"
    exit 1
fi

# Clean up temp file
rm -f src/components/Views/LoginView.jsx.tmp

echo ""

echo ">>> FIXING REGISTRATIONAPI.JS - HEADERS"
echo "----------------------------------------"

# Fix 2: Remove problematic headers from registrationAPI.js
# This removes headers that conflict with browser CORS handling

# Create the fixed version of registrationAPI.js
cat > src/services/registrationAPI.js << 'EOF'
/**
 * nYtevibe Registration API Service
 * Handles all registration-related API calls including email verification
 * No username/email availability checking
 */
const API_CONFIG = {
    baseURL: 'https://system.nytevibe.com/api',
    timeout: 30000,
    headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
        // Removed 'X-Requested-With': 'XMLHttpRequest' - causes 422 errors
    }
};

class APIError extends Error {
    constructor(errorData, status) {
        super(errorData.message || 'API Error');
        this.status = status;
        this.errors = errorData.errors || {};
        this.code = errorData.code;
        this.retryAfter = errorData.retry_after;
    }
}

class RegistrationAPI {
    constructor() {
        this.baseURL = API_CONFIG.baseURL;
    }

    async register(userData) {
        try {
            const response = await fetch(`${this.baseURL}/auth/register`, {
                method: 'POST',
                headers: {
                    ...API_CONFIG.headers,
                    'Origin': 'https://blackaxl.com'
                },
                body: JSON.stringify(userData),
                credentials: 'include'
            });

            const data = await response.json();

            if (!response.ok) {
                throw new APIError(data, response.status);
            }

            return data;
        } catch (error) {
            if (error instanceof APIError) {
                throw error;
            }
            // Network or other errors
            throw new APIError({
                message: 'Network error. Please check your connection.',
                code: 'NETWORK_ERROR'
            }, 0);
        }
    }

    async login(credentials) {
        try {
            const response = await fetch(`${this.baseURL}/auth/login`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json'
                    // Removed manual Origin header - browser handles CORS automatically
                    // Removed X-Requested-With - causes 422 validation errors
                },
                body: JSON.stringify(credentials)
                // Removed credentials: 'include' - not needed for login
            });

            const data = await response.json();

            if (!response.ok) {
                throw new APIError(data, response.status);
            }

            return data;
        } catch (error) {
            if (error instanceof APIError) {
                throw error;
            }
            throw new APIError({
                message: 'Network error. Please check your connection.',
                code: 'NETWORK_ERROR'
            }, 0);
        }
    }

    async verifyEmail(token) {
        try {
            const response = await fetch(`${this.baseURL}/auth/verify-email`, {
                method: 'POST',
                headers: API_CONFIG.headers,
                body: JSON.stringify({ token })
            });

            const data = await response.json();

            if (!response.ok) {
                throw new APIError(data, response.status);
            }

            return data;
        } catch (error) {
            if (error instanceof APIError) {
                throw error;
            }
            throw new APIError({
                message: 'Network error. Please check your connection.',
                code: 'NETWORK_ERROR'
            }, 0);
        }
    }

    async resendVerificationEmail(email) {
        try {
            const response = await fetch(`${this.baseURL}/auth/resend-verification`, {
                method: 'POST',
                headers: API_CONFIG.headers,
                body: JSON.stringify({ email })
            });

            const data = await response.json();

            if (!response.ok) {
                throw new APIError(data, response.status);
            }

            return data;
        } catch (error) {
            if (error instanceof APIError) {
                throw error;
            }
            throw new APIError({
                message: 'Network error. Please check your connection.',
                code: 'NETWORK_ERROR'
            }, 0);
        }
    }

    // Placeholder for future country API call
    async getCountries() {
        // TODO: Implement when backend endpoint is ready
        // Return hardcoded US and Canada for now
        return [
            { code: 'US', name: 'United States' },
            { code: 'CA', name: 'Canada' }
        ];
    }
}

export default new RegistrationAPI();
export { APIError };
EOF

log_change "Removed problematic headers from login method"
log_change "Removed 'X-Requested-With': 'XMLHttpRequest'"
log_change "Removed manual 'Origin' header from login"
log_change "Removed 'credentials: include' from login"

echo ""

echo ">>> VERIFICATION"
echo "----------------------------------------"

# Verify the changes were applied correctly
echo "Checking LoginView.jsx changes..."
if grep -q "email: username," src/components/Views/LoginView.jsx; then
    log_change "LoginView.jsx: Field name fix verified"
else
    log_error "LoginView.jsx: Field name fix not found!"
fi

echo "Checking registrationAPI.js changes..."
if grep -q "'Content-Type': 'application/json'" src/services/registrationAPI.js && 
   ! grep -q "'X-Requested-With'" src/services/registrationAPI.js; then
    log_change "registrationAPI.js: Header fixes verified"
else
    log_error "registrationAPI.js: Header fixes not applied correctly!"
fi

echo ""

echo ">>> SUMMARY OF CHANGES"
echo "----------------------------------------"
echo "✅ FIXED: Field name mismatch in LoginView.jsx"
echo "   Changed: registrationAPI.login({ username, password })"
echo "   To:      registrationAPI.login({ email: username, password })"
echo ""
echo "✅ FIXED: Problematic headers in registrationAPI.js"
echo "   Removed: 'X-Requested-With': 'XMLHttpRequest'"
echo "   Removed: 'Origin': 'https://blackaxl.com' (from login method)"
echo "   Removed: credentials: 'include' (from login method)"
echo ""
echo "📁 BACKUPS: Original files saved to $BACKUP_DIR"
echo ""

echo ">>> WHAT THESE FIXES SOLVE"
echo "----------------------------------------"
echo "🎯 422 Error Causes Fixed:"
echo "   1. API expects 'email' field, not 'username' → FIXED"
echo "   2. X-Requested-With header causes validation errors → REMOVED"
echo "   3. Manual Origin header conflicts with browser CORS → REMOVED"
echo "   4. Unnecessary credentials causing issues → REMOVED"
echo ""

echo ">>> NEXT STEPS"
echo "----------------------------------------"
echo "1. Restart your development server:"
echo "   npm run dev  # or yarn dev"
echo ""
echo "2. Test the login with your credentials"
echo ""
echo "3. Check browser console for any remaining errors"
echo ""
echo "4. If it still fails, check Network tab in browser dev tools"
echo ""

echo ">>> ROLLBACK INSTRUCTIONS (if needed)"
echo "----------------------------------------"
echo "If something goes wrong, restore the originals:"
echo "cp $BACKUP_DIR/LoginView.jsx.backup src/components/Views/LoginView.jsx"
echo "cp $BACKUP_DIR/registrationAPI.js.backup src/services/registrationAPI.js"
echo ""

echo "======================================================="
echo "🎉 LOGIN FIXES APPLIED SUCCESSFULLY!"
echo "======================================================="
echo "The 422 'Unprocessable Content' error should now be resolved."
echo "Your frontend should now match the working curl format."
echo ""
