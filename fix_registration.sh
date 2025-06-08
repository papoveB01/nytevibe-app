#!/bin/bash

# nYtevibe Registration API Fix Script
# Fixes the camelCase → snake_case field mapping issue

set -e  # Exit on any error

echo "🔧 nYtevibe Registration API Fix Script"
echo "======================================="

# Check if we're in the right directory
if [ ! -f "./src/services/registrationAPI.js" ]; then
    echo "❌ Error: registrationAPI.js not found. Please run this script from the project root."
    exit 1
fi

if [ ! -f "./src/components/Registration/RegistrationView.jsx" ]; then
    echo "❌ Error: RegistrationView.jsx not found. Please run this script from the project root."
    exit 1
fi

# Create backup directory
BACKUP_DIR="./registration_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo "📂 Creating backups in: $BACKUP_DIR"
cp "./src/services/registrationAPI.js" "$BACKUP_DIR/"
cp "./src/components/Registration/RegistrationView.jsx" "$BACKUP_DIR/"

echo "✅ Backup created successfully"

# Fix 1: Update registrationAPI.js
echo ""
echo "🔧 Fixing registrationAPI.js..."

# Fix the login endpoint (line 65 - should be /auth/login not /auth/register)
echo "  - Fixing login endpoint..."
sed -i 's|auth/register\`, {|auth/login\`, {|g' ./src/services/registrationAPI.js

# Move prepareRegistrationData function to the top and enhance it
echo "  - Moving and enhancing prepareRegistrationData function..."

# Create the new registrationAPI.js content
cat > ./src/services/registrationAPI.js << 'EOF'
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
    'Accept': 'application/json',
    'X-Requested-With': 'XMLHttpRequest'
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

// 🔧 FIX: Enhanced prepareRegistrationData function (moved to top)
const prepareRegistrationData = (formData) => {
  const data = {
    username: formData.username?.trim(),
    email: formData.email?.trim().toLowerCase(),
    password: formData.password,
    password_confirmation: formData.passwordConfirmation,  // Fix: camelCase → snake_case
    first_name: formData.firstName,                        // Fix: camelCase → snake_case  
    last_name: formData.lastName,                          // Fix: camelCase → snake_case
    
    // Handle user_type properly - default to 'user' if not specified
    user_type: formData.userType || 'user'
  };

  // Optional fields - only include if they have values
  if (formData.dateOfBirth && formData.dateOfBirth.trim()) {
    data.date_of_birth = formData.dateOfBirth;
  }
  
  if (formData.phone && formData.phone.trim()) {
    data.phone = formData.phone.trim();
  }
  
  if (formData.country && formData.country.trim()) {
    data.country = formData.country;
  }
  
  if (formData.state && formData.state.trim()) {
    data.state = formData.state;
  }
  
  if (formData.city && formData.city.trim()) {
    data.city = formData.city;
  }
  
  if (formData.zipcode && formData.zipcode.trim()) {
    data.zipcode = formData.zipcode.trim();
  }

  return data;
};

class RegistrationAPI {
  constructor() {
    this.baseURL = API_CONFIG.baseURL;
  }

  async register(userData) {
    try {
      // 🔧 FIX: Use prepareRegistrationData to map camelCase → snake_case
      const registrationData = prepareRegistrationData(userData);
      
      console.log('📤 Original form data:', userData);
      console.log('📤 Mapped registration data:', registrationData);
      
      const response = await fetch(`${this.baseURL}/auth/register`, {
        method: 'POST',
        headers: {
          ...API_CONFIG.headers,
          'Origin': 'https://blackaxl.com'
        },
        body: JSON.stringify(registrationData), // 🔧 FIX: Use mapped data
        credentials: 'include'
      });

      const data = await response.json();
      console.log('📥 Registration response:', data);

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
      // 🔧 FIX: Use correct login endpoint
      const response = await fetch(`${this.baseURL}/auth/login`, {
        method: 'POST',
        headers: {
          ...API_CONFIG.headers,
          'Origin': 'https://blackaxl.com'
        },
        body: JSON.stringify(credentials),
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
export { APIError, prepareRegistrationData };
EOF

echo "✅ registrationAPI.js updated successfully"

# Fix 2: Update RegistrationView.jsx
echo ""
echo "🔧 Fixing RegistrationView.jsx..."

# Remove prepareRegistrationData from imports
echo "  - Removing prepareRegistrationData from imports..."
sed -i '/prepareRegistrationData,/d' ./src/components/Registration/RegistrationView.jsx

# Update the registration submission to pass raw formData
echo "  - Updating registration submission logic..."
sed -i 's/const registrationData = prepareRegistrationData(formData);/\/\/ Pass raw formData - API handles field mapping/g' ./src/components/Registration/RegistrationView.jsx
sed -i 's/const response = await registrationAPI.register(registrationData);/const response = await registrationAPI.register(formData);/g' ./src/components/Registration/RegistrationView.jsx

# Add better error handling for validation errors
echo "  - Improving error handling..."

# Create a temporary file with the improved handleRegistration function
cat > /tmp/registration_fix.js << 'EOF'
      if (error.status === 422) {
        // 🔧 IMPROVED: Better error handling for validation errors
        console.log('422 Validation errors:', error.errors);
        
        // Map backend snake_case errors back to frontend camelCase
        const mappedErrors = {};
        Object.entries(error.errors).forEach(([key, value]) => {
          // Convert snake_case to camelCase for frontend display
          const camelKey = key.replace(/_([a-z])/g, (match, letter) => letter.toUpperCase());
          mappedErrors[camelKey] = value;
        });
        
        setValidation(mappedErrors);
        actions.addNotification({
          type: 'error',
          message: 'Please check the form for errors and try again.',
          duration: 4000
        });
EOF

# Replace the validation error handling section
sed -i '/if (error.status === 422) {/,/duration: 4000/ {
  /if (error.status === 422) {/r /tmp/registration_fix.js
  d
}' ./src/components/Registration/RegistrationView.jsx

# Clean up temp file
rm -f /tmp/registration_fix.js

echo "✅ RegistrationView.jsx updated successfully"

# Fix 3: Verify the changes
echo ""
echo "🔍 Verifying fixes..."

# Check if prepareRegistrationData is properly placed in API
if grep -q "const prepareRegistrationData" ./src/services/registrationAPI.js; then
    echo "✅ prepareRegistrationData function found in API"
else
    echo "❌ prepareRegistrationData function not found in API"
fi

# Check if login endpoint is fixed
if grep -q "auth/login" ./src/services/registrationAPI.js; then
    echo "✅ Login endpoint fixed"
else
    echo "❌ Login endpoint not fixed"
fi

# Check if RegistrationView no longer imports prepareRegistrationData
if ! grep -q "prepareRegistrationData" ./src/components/Registration/RegistrationView.jsx; then
    echo "✅ prepareRegistrationData import removed from RegistrationView"
else
    echo "⚠️  prepareRegistrationData still found in RegistrationView (check manually)"
fi

echo ""
echo "🎉 Registration Fix Complete!"
echo "=============================="
echo ""
echo "✅ Changes Applied:"
echo "  1. Fixed field mapping (camelCase → snake_case) in API"
echo "  2. Fixed login endpoint (/auth/login instead of /auth/register)"
echo "  3. Updated RegistrationView to pass raw form data"
echo "  4. Improved error handling for validation errors"
echo ""
echo "📂 Backup Location: $BACKUP_DIR"
echo ""
echo "🧪 Test the fix:"
echo "  1. Start your development server"
echo "  2. Try registering a new account"
echo "  3. Check browser console for debug logs"
echo ""
echo "🔍 Expected behavior:"
echo "  - Form data should be mapped correctly"
echo "  - Registration should succeed with 201 response"
echo "  - Validation errors should show field-specific messages"
echo ""
echo "⚠️  If issues persist:"
echo "  1. Restore from backup: cp $BACKUP_DIR/* ./src/services/ && cp $BACKUP_DIR/* ./src/components/Registration/"
echo "  2. Check browser console for detailed error logs"
echo "  3. Verify API endpoint responses"
echo ""
echo "🚀 Your registration should now work correctly!"
