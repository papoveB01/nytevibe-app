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

    // Enhanced register method with phone fields - FIXED WITH STATE MAPPING
    async register(formData) {
        try {
            // Extract clean phone number (10 digits only)
            const cleanPhone = this.extractPhoneDigits(formData.phone);
            
            console.log('🚀 REGISTRATION DEBUG - Clean phone for registration:', cleanPhone);
            
            // Complete US state abbreviation to full name mapping
            const STATE_NAMES = {
                'AL': 'Alabama', 'AK': 'Alaska', 'AZ': 'Arizona', 'AR': 'Arkansas',
                'CA': 'California', 'CO': 'Colorado', 'CT': 'Connecticut', 'DE': 'Delaware',
                'FL': 'Florida', 'GA': 'Georgia', 'HI': 'Hawaii', 'ID': 'Idaho',
                'IL': 'Illinois', 'IN': 'Indiana', 'IA': 'Iowa', 'KS': 'Kansas',
                'KY': 'Kentucky', 'LA': 'Louisiana', 'ME': 'Maine', 'MD': 'Maryland',
                'MA': 'Massachusetts', 'MI': 'Michigan', 'MN': 'Minnesota', 'MS': 'Mississippi',
                'MO': 'Missouri', 'MT': 'Montana', 'NE': 'Nebraska', 'NV': 'Nevada',
                'NH': 'New Hampshire', 'NJ': 'New Jersey', 'NM': 'New Mexico', 'NY': 'New York',
                'NC': 'North Carolina', 'ND': 'North Dakota', 'OH': 'Ohio', 'OK': 'Oklahoma',
                'OR': 'Oregon', 'PA': 'Pennsylvania', 'RI': 'Rhode Island', 'SC': 'South Carolina',
                'SD': 'South Dakota', 'TN': 'Tennessee', 'TX': 'Texas', 'UT': 'Utah',
                'VT': 'Vermont', 'VA': 'Virginia', 'WA': 'Washington', 'WV': 'West Virginia',
                'WI': 'Wisconsin', 'WY': 'Wyoming', 'DC': 'District of Columbia'
            };
            
            // Canadian province mapping
            const PROVINCE_NAMES = {
                'AB': 'Alberta', 'BC': 'British Columbia', 'MB': 'Manitoba',
                'NB': 'New Brunswick', 'NL': 'Newfoundland and Labrador',
                'NS': 'Nova Scotia', 'NT': 'Northwest Territories', 'NU': 'Nunavut',
                'ON': 'Ontario', 'PE': 'Prince Edward Island', 'QC': 'Quebec',
                'SK': 'Saskatchewan', 'YT': 'Yukon'
            };
            
            // Determine which mapping to use based on country
            const stateMapping = formData.country === 'CA' ? PROVINCE_NAMES : STATE_NAMES;
            
            // Prepare data for API - FIXED FIELD NAMES AND STATE MAPPING
            const apiData = {
                username: formData.username,
                email: formData.email,
                password: formData.password,
                password_confirmation: formData.passwordConfirmation,
                first_name: formData.firstName,
                last_name: formData.lastName,
                user_type: formData.userType === 'user' ? 'customer' : formData.userType,
                date_of_birth: formData.dateOfBirth,
                phone: cleanPhone, // FIXED: Changed from phone_number to phone
                country: formData.country === 'US' ? 'United States' : 
                         formData.country === 'CA' ? 'Canada' : formData.country,
                state: stateMapping[formData.state] || formData.state, // Convert abbreviation to full name
                city: formData.city,
                zipcode: formData.zipcode || '00000', // FIXED: Use non-empty default zipcode
                terms_accepted: formData.termsAccepted === true // FIXED: Single line, ensure boolean true
            };

            console.log('📤 Sending registration data:', apiData);
            console.log('📤 State conversion:', formData.state, '→', apiData.state);
            console.log('📤 Zipcode value:', apiData.zipcode);
            console.log('📤 Terms accepted:', apiData.terms_accepted);
            console.log('📤 Terms accepted type:', typeof apiData.terms_accepted);

            const response = await fetch(`${this.baseURL}/auth/register`, {
                method: 'POST',
                headers: this.getHeaders(),
                body: JSON.stringify(apiData),
                credentials: 'include'
            });

            const data = await response.json();

            if (!response.ok) {
                console.log('❌ Registration failed:', data);
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
