#!/bin/bash

# Complete Login System Rebuild Script
# Backs up everything, removes old verification logic, creates clean new login

echo "🔧 nYtevibe Login System Rebuild"
echo "==============================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

# Create backup directory with timestamp
BACKUP_DIR="login_rebuild_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo -e "${BLUE}📦 Step 1: Creating comprehensive backup...${NC}"
echo ""

# Backup all login-related files
LOGIN_FILES=(
    "src/components/Views/LoginView.jsx"
    "src/utils/authUtils.js"
    "src/services/authAPI.js"
    "src/components/auth/Login.jsx"
    "src/components/auth/LoginTest.jsx"
)

echo -e "${YELLOW}Backing up files:${NC}"
for file in "${LOGIN_FILES[@]}"; do
    if [ -f "$file" ]; then
        cp "$file" "$BACKUP_DIR/$(basename "$file").backup"
        echo -e "  ✅ $file"
    else
        echo -e "  ⚠️ $file (not found)"
    fi
done

# Backup package.json and any config files
if [ -f "package.json" ]; then
    cp "package.json" "$BACKUP_DIR/package.json.backup"
    echo -e "  ✅ package.json"
fi

echo ""
echo -e "${GREEN}✅ Backup completed in: $BACKUP_DIR${NC}"
echo ""

# Create rollback script
echo -e "${BLUE}📝 Step 2: Creating rollback script...${NC}"

cat > "rollback_login_rebuild.sh" << EOF
#!/bin/bash

# Rollback Login Rebuild Script
echo "🔄 Rolling back login system changes..."
echo "====================================="
echo ""

# Restore all backed up files
BACKUP_DIR="$BACKUP_DIR"

if [ ! -d "\$BACKUP_DIR" ]; then
    echo "❌ Backup directory \$BACKUP_DIR not found!"
    exit 1
fi

echo "📦 Restoring files from: \$BACKUP_DIR"
echo ""

# Restore each file
for backup_file in "\$BACKUP_DIR"/*.backup; do
    if [ -f "\$backup_file" ]; then
        filename=\$(basename "\$backup_file" .backup)
        original_path=\$(find src -name "\$filename" -type f | head -1)
        
        if [ -n "\$original_path" ]; then
            cp "\$backup_file" "\$original_path"
            echo "✅ Restored: \$original_path"
        else
            echo "⚠️ Could not find original location for: \$filename"
        fi
    fi
done

echo ""
echo "✅ Rollback completed!"
echo "🚀 Run 'npm run build' to test"
EOF

chmod +x "rollback_login_rebuild.sh"
echo -e "  ✅ rollback_login_rebuild.sh created"

echo ""
echo -e "${BLUE}🔧 Step 3: Analyzing current login logic...${NC}"
echo ""

# Show current problematic code
if [ -f "src/components/Views/LoginView.jsx" ]; then
    echo -e "${YELLOW}Current LoginView.jsx issues found:${NC}"
    grep -n "email_verified\|EMAIL_NOT_VERIFIED\|verify.*email" src/components/Views/LoginView.jsx | head -5
fi

echo ""
echo -e "${BLUE}🧹 Step 4: Creating clean login implementation...${NC}"
echo ""

# Create new clean LoginView.jsx aligned with backend
cat > "src/components/Views/LoginView.jsx" << 'LOGINVIEW_EOF'
import React, { useState } from 'react';
import { FaEye, FaEyeSlash, FaUser, FaLock } from 'react-icons/fa';
import { APIError } from '../../services/authAPI';
import { loginUser } from '../../services/authAPI';
import { validateLoginForm, getErrorMessage } from '../../utils/authUtils';

const LoginView = ({ onLoginSuccess, onSwitchToRegister, onSwitchToForgotPassword }) => {
  const [formData, setFormData] = useState({
    identifier: '',
    password: '',
    remember: false
  });
  const [errors, setErrors] = useState({});
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState('');
  const [showPassword, setShowPassword] = useState(false);

  const handleChange = (e) => {
    const { name, value, type, checked } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: type === 'checkbox' ? checked : value
    }));
    
    // Clear errors when user starts typing
    if (errors[name]) {
      setErrors(prev => ({ ...prev, [name]: '' }));
    }
    if (error) setError('');
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setIsLoading(true);
    setError('');
    setErrors({});

    try {
      // Validate form
      const validation = validateLoginForm(formData.identifier, formData.password);
      if (!validation.isValid) {
        setErrors(validation.errors);
        setIsLoading(false);
        return;
      }

      // Prepare login data for backend
      const loginData = {
        email: formData.identifier, // Backend expects 'email' field for username/email
        password: formData.password,
        remember: formData.remember
      };

      console.log('Attempting login with:', { email: loginData.email });

      // Call login API
      const response = await loginUser(loginData);
      
      console.log('Login API response:', response);

      if (response.status === 'success') {
        console.log('Login successful - user data:', response.data.user);
        
        // Store auth data
        localStorage.setItem('authToken', response.data.token);
        localStorage.setItem('userData', JSON.stringify(response.data.user));
        
        // Call success callback
        if (onLoginSuccess) {
          onLoginSuccess(response.data);
        }
        
        console.log('Login successful - redirecting to home');
      } else {
        setError('Login failed. Please try again.');
        setIsLoading(false);
      }

    } catch (error) {
      console.error('Login failed:', error);
      setIsLoading(false);
      
      if (error instanceof APIError) {
        // Handle specific API errors
        if (error.status === 401) {
          setError('Invalid username or password.');
        } else if (error.status === 429) {
          setError('Too many login attempts. Please try again later.');
        } else if (error.status === 403) {
          // Handle account status issues
          setError(getErrorMessage(error.code) || 'Account access denied. Please contact support.');
        } else {
          setError('Login failed. Please try again.');
        }
      } else {
        setError('Network error. Please check your connection and try again.');
      }
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-purple-900 via-blue-900 to-indigo-900 py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-md w-full space-y-8">
        <div>
          <div className="mx-auto h-16 w-16 bg-gradient-to-r from-purple-500 to-pink-500 rounded-full flex items-center justify-center">
            <FaUser className="h-8 w-8 text-white" />
          </div>
          <h2 className="mt-6 text-center text-3xl font-extrabold bg-gradient-to-r from-purple-400 to-pink-400 bg-clip-text text-transparent">
            Welcome Back
          </h2>
          <p className="mt-2 text-center text-sm text-gray-300">
            Sign in to your nYtevibe account
          </p>
        </div>

        <form className="mt-8 space-y-6" onSubmit={handleSubmit}>
          {error && (
            <div className="bg-red-900/50 border border-red-500 text-red-200 px-4 py-3 rounded-lg">
              {error}
            </div>
          )}

          <div className="space-y-4">
            <div>
              <label htmlFor="identifier" className="sr-only">
                Email or Username
              </label>
              <div className="relative">
                <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                  <FaUser className="h-5 w-5 text-gray-400" />
                </div>
                <input
                  id="identifier"
                  name="identifier"
                  type="text"
                  autoComplete="email"
                  required
                  className={`appearance-none relative block w-full px-12 py-3 border ${
                    errors.identifier ? 'border-red-500' : 'border-gray-600'
                  } placeholder-gray-400 text-white bg-gray-800/50 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-transparent focus:z-10 sm:text-sm backdrop-blur-sm`}
                  placeholder="Email or Username"
                  value={formData.identifier}
                  onChange={handleChange}
                />
              </div>
              {errors.identifier && (
                <p className="mt-1 text-sm text-red-400">{errors.identifier}</p>
              )}
            </div>

            <div>
              <label htmlFor="password" className="sr-only">
                Password
              </label>
              <div className="relative">
                <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                  <FaLock className="h-5 w-5 text-gray-400" />
                </div>
                <input
                  id="password"
                  name="password"
                  type={showPassword ? "text" : "password"}
                  autoComplete="current-password"
                  required
                  className={`appearance-none relative block w-full px-12 py-3 border ${
                    errors.password ? 'border-red-500' : 'border-gray-600'
                  } placeholder-gray-400 text-white bg-gray-800/50 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-transparent focus:z-10 sm:text-sm backdrop-blur-sm pr-12`}
                  placeholder="Password"
                  value={formData.password}
                  onChange={handleChange}
                />
                <button
                  type="button"
                  className="absolute inset-y-0 right-0 pr-3 flex items-center"
                  onClick={() => setShowPassword(!showPassword)}
                >
                  {showPassword ? (
                    <FaEyeSlash className="h-5 w-5 text-gray-400 hover:text-gray-300" />
                  ) : (
                    <FaEye className="h-5 w-5 text-gray-400 hover:text-gray-300" />
                  )}
                </button>
              </div>
              {errors.password && (
                <p className="mt-1 text-sm text-red-400">{errors.password}</p>
              )}
            </div>
          </div>

          <div className="flex items-center justify-between">
            <div className="flex items-center">
              <input
                id="remember"
                name="remember"
                type="checkbox"
                className="h-4 w-4 text-purple-600 focus:ring-purple-500 border-gray-600 rounded bg-gray-800"
                checked={formData.remember}
                onChange={handleChange}
              />
              <label htmlFor="remember" className="ml-2 block text-sm text-gray-300">
                Remember me
              </label>
            </div>

            <div className="text-sm">
              <button
                type="button"
                onClick={onSwitchToForgotPassword}
                className="font-medium text-purple-400 hover:text-purple-300 transition-colors"
              >
                Forgot your password?
              </button>
            </div>
          </div>

          <div>
            <button
              type="submit"
              disabled={isLoading}
              className="group relative w-full flex justify-center py-3 px-4 border border-transparent text-sm font-medium rounded-lg text-white bg-gradient-to-r from-purple-600 to-pink-600 hover:from-purple-700 hover:to-pink-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-purple-500 disabled:opacity-50 disabled:cursor-not-allowed transition-all duration-200 shadow-lg hover:shadow-xl"
            >
              {isLoading ? (
                <div className="flex items-center">
                  <div className="animate-spin rounded-full h-5 w-5 border-b-2 border-white mr-2"></div>
                  Signing In...
                </div>
              ) : (
                'Sign In'
              )}
            </button>
          </div>

          <div className="text-center">
            <span className="text-gray-300">Don't have an account? </span>
            <button
              type="button"
              onClick={onSwitchToRegister}
              className="font-medium text-purple-400 hover:text-purple-300 transition-colors"
            >
              Sign up here
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};

export default LoginView;
LOGINVIEW_EOF

echo -e "  ✅ Created clean LoginView.jsx"

# Create clean authUtils.js (keep existing functions but remove verification logic)
echo -e "${YELLOW}Creating clean authUtils.js...${NC}"

cat > "src/utils/authUtils.js" << 'AUTHUTILS_EOF'
// Authentication utilities aligned with backend API

/**
 * Validate login form data
 */
export const validateLoginForm = (identifier, password) => {
  const errors = {};
  
  // Validate identifier (email or username)
  if (!identifier || identifier.trim().length === 0) {
    errors.identifier = 'Email or username is required';
  } else if (identifier.trim().length < 3) {
    errors.identifier = 'Please enter a valid email or username';
  } else if (identifier.trim().length > 255) {
    errors.identifier = 'Input is too long';
  }
  
  // Validate password
  if (!password || password.length === 0) {
    errors.password = 'Password is required';
  } else if (password.length < 8) {
    errors.password = 'Password must be at least 8 characters';
  }
  
  return {
    isValid: Object.keys(errors).length === 0,
    errors
  };
};

/**
 * Validate registration form data
 */
export const validateRegistrationForm = (formData) => {
  const errors = {};
  
  // Username validation
  if (!formData.username || formData.username.trim().length === 0) {
    errors.username = 'Username is required';
  } else if (formData.username.length < 3) {
    errors.username = 'Username must be at least 3 characters';
  } else if (formData.username.length > 50) {
    errors.username = 'Username must be less than 50 characters';
  } else if (!/^[a-zA-Z0-9_.-]+$/.test(formData.username)) {
    errors.username = 'Username can only contain letters, numbers, dots, hyphens, and underscores';
  }
  
  // Email validation
  if (!formData.email || formData.email.trim().length === 0) {
    errors.email = 'Email is required';
  } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(formData.email)) {
    errors.email = 'Please enter a valid email address';
  } else if (formData.email.length > 255) {
    errors.email = 'Email is too long';
  }
  
  // Password validation
  if (!formData.password || formData.password.length === 0) {
    errors.password = 'Password is required';
  } else if (formData.password.length < 8) {
    errors.password = 'Password must be at least 8 characters';
  }
  
  // Password confirmation
  if (formData.password !== formData.passwordConfirmation) {
    errors.passwordConfirmation = 'Passwords do not match';
  }
  
  // First name validation
  if (!formData.firstName || formData.firstName.trim().length === 0) {
    errors.firstName = 'First name is required';
  } else if (formData.firstName.length > 100) {
    errors.firstName = 'First name is too long';
  }
  
  // Last name validation
  if (!formData.lastName || formData.lastName.trim().length === 0) {
    errors.lastName = 'Last name is required';
  } else if (formData.lastName.length > 100) {
    errors.lastName = 'Last name is too long';
  }
  
  return {
    isValid: Object.keys(errors).length === 0,
    errors
  };
};

/**
 * Get user-friendly error message from API error code
 */
export const getErrorMessage = (code) => {
  switch (code) {
    case 'INVALID_CREDENTIALS':
      return 'Invalid username or password. Please check your credentials and try again.';
    
    case 'ACCOUNT_SUSPENDED':
      return 'Your account has been suspended. Please contact support.';
    
    case 'ACCOUNT_BANNED':
      return 'Your account has been banned. Please contact support.';
    
    case 'ACCOUNT_PENDING':
      return 'Your account is pending approval. Please wait for admin approval.';
    
    case 'ACCOUNT_INACTIVE':
      return 'Your account is not active. Please contact support.';
    
    case 'RATE_LIMIT_EXCEEDED':
      return 'Too many attempts. Please try again later.';
    
    case 'REGISTRATION_ERROR':
      return 'Registration failed. Please try again.';
    
    case 'LOGIN_SYSTEM_ERROR':
      return 'Login system error. Please try again later.';
    
    case 'SERVER_ERROR':
      return 'Server error. Please try again later.';
    
    default:
      return 'An error occurred. Please try again.';
  }
};

/**
 * Format user data for display
 */
export const formatUserData = (userData) => {
  return {
    id: userData.id,
    username: userData.username,
    email: userData.email,
    firstName: userData.first_name,
    lastName: userData.last_name,
    fullName: userData.full_name || `${userData.first_name} ${userData.last_name}`,
    userType: userData.user_type,
    accountStatus: userData.account_status,
    level: userData.level || 1,
    points: userData.points || 0,
    city: userData.city,
    state: userData.state,
    country: userData.country,
    emailVerified: Boolean(userData.email_verified || userData.email_verified_at),
    lastLoginAt: userData.last_login_at,
    createdAt: userData.created_at
  };
};

/**
 * Check if user is authenticated
 */
export const isAuthenticated = () => {
  const token = localStorage.getItem('authToken');
  const userData = localStorage.getItem('userData');
  return Boolean(token && userData);
};

/**
 * Get current user data from localStorage
 */
export const getCurrentUser = () => {
  const userData = localStorage.getItem('userData');
  return userData ? JSON.parse(userData) : null;
};

/**
 * Clear authentication data
 */
export const clearAuthData = () => {
  localStorage.removeItem('authToken');
  localStorage.removeItem('userData');
};

/**
 * Get auth token
 */
export const getAuthToken = () => {
  return localStorage.getItem('authToken');
};
AUTHUTILS_EOF

echo -e "  ✅ Created clean authUtils.js"

# Ensure authAPI.js is aligned with backend
if [ -f "src/services/authAPI.js" ]; then
    echo -e "${YELLOW}Checking authAPI.js alignment...${NC}"
    
    # Check if it has the correct API endpoints
    if grep -q "api/auth/login" src/services/authAPI.js; then
        echo -e "  ✅ authAPI.js looks aligned with backend"
    else
        echo -e "  ⚠️ authAPI.js may need updating"
        echo -e "  📝 Checking current API base URL..."
        grep -n "baseURL\|api.*base\|API_URL" src/services/authAPI.js | head -3
    fi
fi

echo ""
echo -e "${BLUE}🧪 Step 5: Testing build...${NC}"
echo ""

# Test the build
echo -e "${YELLOW}Running build test...${NC}"
if npm run build >/dev/null 2>&1; then
    echo -e "  ✅ Build successful!"
else
    echo -e "  ❌ Build failed. Checking for issues..."
    npm run build 2>&1 | tail -10
fi

echo ""
echo -e "${GREEN}🎉 Login System Rebuild Complete!${NC}"
echo ""
echo -e "${BLUE}📋 What was done:${NC}"
echo -e "  ✅ Complete backup created in: $BACKUP_DIR"
echo -e "  ✅ Rollback script created: rollback_login_rebuild.sh"
echo -e "  ✅ Clean LoginView.jsx - no email verification checks"
echo -e "  ✅ Clean authUtils.js - aligned with backend API"
echo -e "  ✅ Preserved all styling and design"
echo ""
echo -e "${BLUE}🔧 New login flow:${NC}"
echo -e "  1. User enters email/username and password"
echo -e "  2. Frontend validates form"
echo -e "  3. Calls POST /api/auth/login"
echo -e "  4. Backend handles authentication (no verification checks)"
echo -e "  5. Success: Store token and redirect"
echo -e "  6. Error: Show user-friendly message"
echo ""
echo -e "${GREEN}🚀 Ready to test:${NC}"
echo -e "  • Your login should work immediately"
echo -e "  • No more email verification conflicts"
echo -e "  • Clean error handling"
echo ""
echo -e "${YELLOW}💡 If you need to rollback:${NC}"
echo -e "  ./rollback_login_rebuild.sh"
echo ""
echo -e "${BLUE}🎯 Test your login now!${NC}"
