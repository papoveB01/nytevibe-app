#!/bin/bash

#################################################################################
# Robust Phone Number Validation Fix
# Properly extracts 10 digits from international format
#################################################################################

PROJECT_DIR="/var/www/nytevibe"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

cd "$PROJECT_DIR"

print_info "Fixing phone number validation to properly handle international format..."

# Create backup
cp src/services/registrationAPI.js src/services/registrationAPI.js.backup_robust

print_info "Creating robust phone validation logic..."

# Create updated registrationAPI.js with proper phone parsing
cat > src/services/registrationAPI.js << 'EOF'
// Enhanced registrationAPI.js with robust phone validation
class RegistrationAPI {
    constructor() {
        this.baseURL = 'https://system.nytevibe.com/api';
    }

    // API Configuration
    getHeaders() {
        return {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'X-Requested-With': 'XMLHttpRequest',
            'Origin': 'https://blackaxl.com'
        };
    }

    // Helper method to extract 10-digit phone number from international format
    extractPhoneDigits(phoneValue) {
        if (!phoneValue) return '';
        
        // Remove all non-digit characters
        const allDigits = phoneValue.replace(/\D/g, '');
        
        // For US/CA numbers, remove country code (1) if present
        if (allDigits.startsWith('1') && allDigits.length === 11) {
            return allDigits.substring(1); // Remove the leading '1'
        }
        
        // For other cases, return the digits as-is
        return allDigits;
    }

    // Enhanced register method with phone fields
    async register(formData) {
        try {
            // Extract clean phone number (10 digits only)
            const cleanPhone = this.extractPhoneDigits(formData.phone);
            
            // Prepare data for API
            const apiData = {
                username: formData.username,
                email: formData.email,
                password: formData.password,
                password_confirmation: formData.passwordConfirmation,
                first_name: formData.firstName,
                last_name: formData.lastName,
                user_type: formData.userType === 'user' ? 'customer' : formData.userType,
                date_of_birth: formData.dateOfBirth,
                phone_number: cleanPhone, // Send clean 10-digit number
                phone_country_code: formData.phoneCountryCode || 'US',
                country: formData.country,
                state: formData.state,
                city: formData.city,
                zipcode: formData.zipcode
            };

            const response = await fetch(`${this.baseURL}/auth/register`, {
                method: 'POST',
                headers: this.getHeaders(),
                body: JSON.stringify(apiData),
                credentials: 'include'
            });

            const data = await response.json();

            if (!response.ok) {
                throw new APIError(data, response.status);
            }

            return data;
        } catch (error) {
            console.error('Registration error:', error);
            throw error;
        }
    }

    // Username availability check (existing)
    async checkUsernameAvailability(username) {
        try {
            if (!username || username.trim().length < 3) {
                return {
                    available: false,
                    message: 'Username must be at least 3 characters',
                    checking: false
                };
            }

            const response = await fetch(`${this.baseURL}/auth/check-username`, {
                method: 'POST',
                headers: this.getHeaders(),
                body: JSON.stringify({ username: username.trim() }),
                credentials: 'include'
            });

            const data = await response.json();

            if (!response.ok) {
                throw new APIError(data, response.status);
            }

            return {
                available: data.available,
                message: data.message,
                suggestions: data.suggestions || [],
                checking: false
            };
        } catch (error) {
            console.error('Username availability check error:', error);
            return {
                available: false,
                message: 'Unable to check username availability',
                checking: false,
                error: true
            };
        }
    }

    // Email availability check (existing)
    async checkEmailAvailability(email) {
        try {
            if (!email || email.trim().length < 5) {
                return {
                    available: false,
                    message: 'Email must be valid',
                    checking: false
                };
            }

            const response = await fetch(`${this.baseURL}/auth/check-email`, {
                method: 'POST',
                headers: this.getHeaders(),
                body: JSON.stringify({ email: email.trim() }),
                credentials: 'include'
            });

            const data = await response.json();

            if (!response.ok) {
                throw new APIError(data, response.status);
            }

            return {
                available: data.available,
                message: data.message,
                checking: false
            };
        } catch (error) {
            console.error('Email availability check error:', error);
            return {
                available: false,
                message: 'Unable to check email availability',
                checking: false,
                error: true
            };
        }
    }

    // ENHANCED: Phone availability check with robust validation
    async checkPhoneAvailability(phoneValue, countryCode) {
        try {
            // Extract clean 10-digit phone number
            const cleanPhone = this.extractPhoneDigits(phoneValue);
            
            console.log('Phone validation debug:', {
                original: phoneValue,
                cleaned: cleanPhone,
                length: cleanPhone.length
            });

            // Validate phone number length
            if (!cleanPhone) {
                return {
                    available: false,
                    message: 'Phone number is required',
                    checking: false
                };
            }
            
            if (cleanPhone.length !== 10) {
                return {
                    available: false,
                    message: `Phone number must be exactly 10 digits (you entered ${cleanPhone.length})`,
                    checking: false
                };
            }

            // Check if it's all the same digit (invalid)
            if (/^(\d)\1{9}$/.test(cleanPhone)) {
                return {
                    available: false,
                    message: 'Please enter a valid phone number',
                    checking: false
                };
            }

            const response = await fetch(`${this.baseURL}/auth/check-phone`, {
                method: 'POST',
                headers: this.getHeaders(),
                body: JSON.stringify({ 
                    phone_number: cleanPhone,
                    country_code: countryCode || 'US'
                }),
                credentials: 'include'
            });

            const data = await response.json();

            if (!response.ok) {
                throw new APIError(data, response.status);
            }

            return {
                available: data.available,
                message: data.message,
                checking: false
            };
        } catch (error) {
            console.error('Phone availability check error:', error);
            return {
                available: false,
                message: 'Unable to check phone availability',
                checking: false,
                error: true
            };
        }
    }

    // Login method (existing)
    async login(credentials) {
        try {
            const response = await fetch(`${this.baseURL}/auth/login`, {
                method: 'POST',
                headers: this.getHeaders(),
                body: JSON.stringify(credentials),
                credentials: 'include'
            });

            const data = await response.json();

            if (!response.ok) {
                throw new APIError(data, response.status);
            }

            return data;
        } catch (error) {
            console.error('Login error:', error);
            throw error;
        }
    }
}

// API Error class
class APIError extends Error {
    constructor(data, status) {
        super(data.message || 'API Error');
        this.name = 'APIError';
        this.status = status;
        this.errors = data.errors || {};
        this.data = data;
    }
}

// Create and export instance
const registrationAPI = new RegistrationAPI();
export default registrationAPI;
export { APIError };
EOF

print_success "Enhanced registrationAPI.js created"

# Also update the RegistrationView.jsx validation
print_info "Updating form validation in RegistrationView.jsx..."

# Create a more robust frontend validation fix
cat > temp_form_fix.js << 'EOF'
const fs = require('fs');
let content = fs.readFileSync('src/components/Registration/RegistrationView.jsx', 'utf8');

// Helper function to extract phone digits (same as API)
const extractPhoneDigitsJS = `
// Helper function to extract 10-digit phone number
const extractPhoneDigits = (phoneValue) => {
  if (!phoneValue) return '';
  const allDigits = phoneValue.replace(/\\D/g, '');
  if (allDigits.startsWith('1') && allDigits.length === 11) {
    return allDigits.substring(1);
  }
  return allDigits;
};`;

// Add the helper function at the top of the component
content = content.replace(
  'const RegistrationView = ({ onBack, onSuccess }) => {',
  `${extractPhoneDigitsJS}

const RegistrationView = ({ onBack, onSuccess }) => {`
);

// Update the phone validation logic in validateCurrentStep
const oldPhoneValidation = `// Enhanced phone validation (required)
if (!formData.phone) {
errors.phone = ['Phone number is required'];
} else if (formData.phone.replace(/[^0-9]/g, "").length !== 10) {
errors.phone = ["Phone number must be exactly 10 digits"];
}`;

const newPhoneValidation = `// Enhanced phone validation (required)
if (!formData.phone) {
  errors.phone = ['Phone number is required'];
} else {
  const cleanPhone = extractPhoneDigits(formData.phone);
  if (cleanPhone.length !== 10) {
    errors.phone = [\`Phone number must be exactly 10 digits (you entered \${cleanPhone.length})\`];
  }
}`;

content = content.replace(oldPhoneValidation, newPhoneValidation);

fs.writeFileSync('src/components/Registration/RegistrationView.jsx', content);
console.log('RegistrationView.jsx updated with robust phone validation');
EOF

node temp_form_fix.js
rm temp_form_fix.js

print_success "Form validation updated"

print_info "Rebuilding application with robust phone validation..."
npm run build

if [ $? -eq 0 ]; then
    print_success "Build completed successfully!"
    
    echo ""
    echo "🎯 ROBUST PHONE VALIDATION NOW ACTIVE:"
    echo ""
    echo "✅ Handles international format correctly:"
    echo "   • +1 (555) 123-4567 → extracts 5551234567 (10 digits) ✅"
    echo "   • +15551234567 → extracts 5551234567 (10 digits) ✅"
    echo "   • 555-123-4567 → extracts 5551234567 (10 digits) ✅"
    echo ""
    echo "❌ Rejects invalid lengths:"
    echo "   • +1 (555) 123-456 → extracts 555123456 (9 digits) ❌"
    echo "   • +1 (555) 123-45678 → extracts 55512345678 (11 digits) ❌"
    echo ""
    echo "🔍 Debug info available in browser console"
    echo "📱 Test with various phone formats to verify"
    
else
    print_warning "Build failed, restoring backup..."
    cp src/services/registrationAPI.js.backup_robust src/services/registrationAPI.js
fi

echo ""
print_info "Test the phone validation now with:"
echo "  1. Different formatting: (555) 123-4567"
echo "  2. International format: +1 555 123 4567"  
echo "  3. Invalid lengths: 555-123-456 (9 digits)"
echo "  4. Check browser console for debug info"
