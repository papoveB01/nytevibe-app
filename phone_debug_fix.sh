#!/bin/bash

#################################################################################
# Phone Availability Debug and Fix
# Add comprehensive debugging to see what's being sent to API
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

print_info "Adding comprehensive debugging to phone availability checking..."

# Create backup
cp src/services/registrationAPI.js src/services/registrationAPI.js.backup_debug

# Create a debug version with extensive logging
cat > src/services/registrationAPI.js << 'EOF'
// Debug version of registrationAPI.js with extensive phone validation logging
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
        console.log('📱 PHONE DEBUG - Input:', phoneValue);
        
        if (!phoneValue) {
            console.log('📱 PHONE DEBUG - Empty phone value');
            return '';
        }
        
        // Remove all non-digit characters
        const allDigits = phoneValue.replace(/\D/g, '');
        console.log('📱 PHONE DEBUG - All digits extracted:', allDigits);
        
        // For US/CA numbers, remove country code (1) if present
        if (allDigits.startsWith('1') && allDigits.length === 11) {
            const result = allDigits.substring(1);
            console.log('📱 PHONE DEBUG - Removed country code 1:', result);
            return result;
        }
        
        console.log('📱 PHONE DEBUG - Using digits as-is:', allDigits);
        return allDigits;
    }

    // Enhanced register method with phone fields
    async register(formData) {
        try {
            // Extract clean phone number (10 digits only)
            const cleanPhone = this.extractPhoneDigits(formData.phone);
            
            console.log('🚀 REGISTRATION DEBUG - Clean phone for registration:', cleanPhone);
            
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

    // ENHANCED: Phone availability check with comprehensive debugging
    async checkPhoneAvailability(phoneValue, countryCode) {
        console.log('🔍 PHONE AVAILABILITY CHECK STARTED');
        console.log('📱 Raw phone value:', phoneValue);
        console.log('🌍 Country code:', countryCode);
        
        try {
            // Extract clean 10-digit phone number
            const cleanPhone = this.extractPhoneDigits(phoneValue);
            
            console.log('🧹 Cleaned phone number:', cleanPhone);
            console.log('📏 Cleaned phone length:', cleanPhone.length);

            // Validate phone number length
            if (!cleanPhone) {
                console.log('❌ Phone validation failed: empty');
                return {
                    available: false,
                    message: 'Phone number is required',
                    checking: false
                };
            }
            
            if (cleanPhone.length !== 10) {
                console.log(`❌ Phone validation failed: length ${cleanPhone.length} !== 10`);
                return {
                    available: false,
                    message: `Phone number must be exactly 10 digits (you entered ${cleanPhone.length})`,
                    checking: false
                };
            }

            // Check if it's all the same digit (invalid)
            if (/^(\d)\1{9}$/.test(cleanPhone)) {
                console.log('❌ Phone validation failed: repeating digits');
                return {
                    available: false,
                    message: 'Please enter a valid phone number',
                    checking: false
                };
            }

            console.log('✅ Phone validation passed, making API call...');

            const requestData = { 
                phone_number: cleanPhone,
                country_code: countryCode || 'US'
            };
            
            console.log('📤 API Request data:', requestData);
            console.log('🌐 API URL:', `${this.baseURL}/auth/check-phone`);

            const response = await fetch(`${this.baseURL}/auth/check-phone`, {
                method: 'POST',
                headers: this.getHeaders(),
                body: JSON.stringify(requestData),
                credentials: 'include'
            });

            console.log('📥 API Response status:', response.status);
            console.log('📥 API Response ok:', response.ok);

            const data = await response.json();
            console.log('📥 API Response data:', data);

            if (!response.ok) {
                console.error('❌ API Response not ok:', data);
                throw new APIError(data, response.status);
            }

            console.log('✅ Phone availability check successful');
            return {
                available: data.available,
                message: data.message,
                checking: false
            };
        } catch (error) {
            console.error('💥 Phone availability check error:', error);
            console.error('💥 Error details:', {
                name: error.name,
                message: error.message,
                stack: error.stack
            });
            
            return {
                available: false,
                message: 'Unable to check phone availability (check console for details)',
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

print_success "Debug version of registrationAPI.js created"

print_info "Rebuilding application with comprehensive debugging..."
npm run build

if [ $? -eq 0 ]; then
    print_success "Build completed successfully!"
    
    echo ""
    print_info "🔍 DEBUG MODE ACTIVE:"
    echo ""
    echo "📱 Now test the phone field and check browser console for:"
    echo "   • Phone input processing details"
    echo "   • API request/response data"
    echo "   • Error details if validation fails"
    echo ""
    echo "🧪 To debug:"
    echo "   1. Open browser Developer Tools (F12)"
    echo "   2. Go to Console tab"
    echo "   3. Enter a phone number in registration Step 4"
    echo "   4. Watch the detailed logs"
    echo ""
    echo "📋 Look for these log messages:"
    echo "   • 📱 PHONE DEBUG - shows input processing"
    echo "   • 🔍 PHONE AVAILABILITY CHECK - shows API calls"
    echo "   • 📤 API Request data - shows what's sent to backend"
    echo "   • 📥 API Response - shows backend response"
    echo "   • 💥 Error details - shows any failures"
    
else
    print_warning "Build failed, restoring backup..."
    cp src/services/registrationAPI.js.backup_debug src/services/registrationAPI.js
fi

echo ""
print_info "Test now and share the console logs to identify the exact issue!"
