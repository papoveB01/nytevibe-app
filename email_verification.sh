#!/bin/bash

# nYtevibe Email Verification Implementation Script
# Adds email verification functionality without username/email availability checking

echo "📧 nYtevibe Email Verification Implementation (No Availability Check)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔄 Implementing email verification flow without availability checks..."
echo ""

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
echo "❌ Error: package.json not found. Please run this script from your React project directory."
exit 1
fi

# Create backups
echo "💾 Creating backups for email verification implementation..."
cp src/services/registrationAPI.js src/services/registrationAPI.js.backup-email-verification 2>/dev/null || true
cp src/components/Registration/RegistrationView.jsx src/components/Registration/RegistrationView.jsx.backup-email-verification 2>/dev/null || true
cp src/components/Views/LoginView.jsx src/components/Views/LoginView.jsx.backup-email-verification 2>/dev/null || true
cp src/context/AppContext.jsx src/context/AppContext.jsx.backup-email-verification 2>/dev/null || true
cp src/App.jsx src/App.jsx.backup-email-verification 2>/dev/null || true

echo "🔧 Creating Registration API Service (without availability checks)..."

# 1. Create Registration API Service without availability checks
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
export { APIError };
EOF

echo "📝 Creating Registration Validation Utilities (without availability checks)..."

# 2. Create Registration Validation Utilities without availability checks
cat > src/utils/registrationValidation.js << 'EOF'
/**
 * Registration Validation Utilities
 * Real-time validation for registration forms (no availability checking)
 */

// US and Canada location data
export const LOCATION_DATA = {
US: {
name: 'United States',
states: {
'AL': { name: 'Alabama', cities: ['Birmingham', 'Montgomery', 'Mobile', 'Huntsville'] },
'AK': { name: 'Alaska', cities: ['Anchorage', 'Fairbanks', 'Juneau'] },
'AZ': { name: 'Arizona', cities: ['Phoenix', 'Tucson', 'Mesa', 'Scottsdale'] },
'AR': { name: 'Arkansas', cities: ['Little Rock', 'Fort Smith', 'Fayetteville'] },
'CA': { name: 'California', cities: ['Los Angeles', 'San Francisco', 'San Diego', 'Sacramento', 'San Jose'] },
'CO': { name: 'Colorado', cities: ['Denver', 'Colorado Springs', 'Aurora', 'Fort Collins'] },
'CT': { name: 'Connecticut', cities: ['Hartford', 'New Haven', 'Stamford', 'Waterbury'] },
'DE': { name: 'Delaware', cities: ['Wilmington', 'Dover', 'Newark'] },
'FL': { name: 'Florida', cities: ['Miami', 'Orlando', 'Tampa', 'Jacksonville', 'Fort Lauderdale'] },
'GA': { name: 'Georgia', cities: ['Atlanta', 'Augusta', 'Columbus', 'Savannah'] },
'HI': { name: 'Hawaii', cities: ['Honolulu', 'Hilo', 'Kailua-Kona'] },
'ID': { name: 'Idaho', cities: ['Boise', 'Nampa', 'Meridian'] },
'IL': { name: 'Illinois', cities: ['Chicago', 'Aurora', 'Rockford', 'Joliet'] },
'IN': { name: 'Indiana', cities: ['Indianapolis', 'Fort Wayne', 'Evansville'] },
'IA': { name: 'Iowa', cities: ['Des Moines', 'Cedar Rapids', 'Davenport'] },
'KS': { name: 'Kansas', cities: ['Wichita', 'Overland Park', 'Kansas City'] },
'KY': { name: 'Kentucky', cities: ['Louisville', 'Lexington', 'Bowling Green'] },
'LA': { name: 'Louisiana', cities: ['New Orleans', 'Baton Rouge', 'Shreveport'] },
'ME': { name: 'Maine', cities: ['Portland', 'Lewiston', 'Bangor'] },
'MD': { name: 'Maryland', cities: ['Baltimore', 'Frederick', 'Rockville'] },
'MA': { name: 'Massachusetts', cities: ['Boston', 'Worcester', 'Springfield', 'Cambridge'] },
'MI': { name: 'Michigan', cities: ['Detroit', 'Grand Rapids', 'Warren', 'Sterling Heights'] },
'MN': { name: 'Minnesota', cities: ['Minneapolis', 'Saint Paul', 'Rochester'] },
'MS': { name: 'Mississippi', cities: ['Jackson', 'Gulfport', 'Southaven'] },
'MO': { name: 'Missouri', cities: ['Kansas City', 'Saint Louis', 'Springfield'] },
'MT': { name: 'Montana', cities: ['Billings', 'Missoula', 'Great Falls'] },
'NE': { name: 'Nebraska', cities: ['Omaha', 'Lincoln', 'Bellevue'] },
'NV': { name: 'Nevada', cities: ['Las Vegas', 'Henderson', 'Reno'] },
'NH': { name: 'New Hampshire', cities: ['Manchester', 'Nashua', 'Concord'] },
'NJ': { name: 'New Jersey', cities: ['Newark', 'Jersey City', 'Paterson'] },
'NM': { name: 'New Mexico', cities: ['Albuquerque', 'Las Cruces', 'Rio Rancho'] },
'NY': { name: 'New York', cities: ['New York City', 'Buffalo', 'Rochester', 'Albany'] },
'NC': { name: 'North Carolina', cities: ['Charlotte', 'Raleigh', 'Greensboro', 'Durham'] },
'ND': { name: 'North Dakota', cities: ['Fargo', 'Bismarck', 'Grand Forks'] },
'OH': { name: 'Ohio', cities: ['Columbus', 'Cleveland', 'Cincinnati', 'Toledo'] },
'OK': { name: 'Oklahoma', cities: ['Oklahoma City', 'Tulsa', 'Norman'] },
'OR': { name: 'Oregon', cities: ['Portland', 'Salem', 'Eugene'] },
'PA': { name: 'Pennsylvania', cities: ['Philadelphia', 'Pittsburgh', 'Allentown'] },
'RI': { name: 'Rhode Island', cities: ['Providence', 'Warwick', 'Cranston'] },
'SC': { name: 'South Carolina', cities: ['Charleston', 'Columbia', 'North Charleston'] },
'SD': { name: 'South Dakota', cities: ['Sioux Falls', 'Rapid City', 'Aberdeen'] },
'TN': { name: 'Tennessee', cities: ['Nashville', 'Memphis', 'Knoxville'] },
'TX': { name: 'Texas', cities: ['Houston', 'San Antonio', 'Dallas', 'Austin', 'Fort Worth'] },
'UT': { name: 'Utah', cities: ['Salt Lake City', 'West Valley City', 'Provo'] },
'VT': { name: 'Vermont', cities: ['Burlington', 'Essex', 'South Burlington'] },
'VA': { name: 'Virginia', cities: ['Virginia Beach', 'Norfolk', 'Chesapeake', 'Richmond'] },
'WA': { name: 'Washington', cities: ['Seattle', 'Spokane', 'Tacoma'] },
'WV': { name: 'West Virginia', cities: ['Charleston', 'Huntington', 'Parkersburg'] },
'WI': { name: 'Wisconsin', cities: ['Milwaukee', 'Madison', 'Green Bay'] },
'WY': { name: 'Wyoming', cities: ['Cheyenne', 'Casper', 'Laramie'] }
}
},
CA: {
name: 'Canada',
states: {
'AB': { name: 'Alberta', cities: ['Calgary', 'Edmonton', 'Red Deer', 'Lethbridge'] },
'BC': { name: 'British Columbia', cities: ['Vancouver', 'Victoria', 'Surrey', 'Burnaby'] },
'MB': { name: 'Manitoba', cities: ['Winnipeg', 'Brandon', 'Steinbach'] },
'NB': { name: 'New Brunswick', cities: ['Saint John', 'Moncton', 'Fredericton'] },
'NL': { name: 'Newfoundland and Labrador', cities: ['St. Johns', 'Mount Pearl', 'Corner Brook'] },
'NS': { name: 'Nova Scotia', cities: ['Halifax', 'Sydney', 'Dartmouth'] },
'NT': { name: 'Northwest Territories', cities: ['Yellowknife', 'Hay River', 'Inuvik'] },
'NU': { name: 'Nunavut', cities: ['Iqaluit', 'Rankin Inlet', 'Arviat'] },
'ON': { name: 'Ontario', cities: ['Toronto', 'Ottawa', 'Mississauga', 'Brampton', 'Hamilton'] },
'PE': { name: 'Prince Edward Island', cities: ['Charlottetown', 'Summerside', 'Stratford'] },
'QC': { name: 'Quebec', cities: ['Montreal', 'Quebec City', 'Laval', 'Gatineau'] },
'SK': { name: 'Saskatchewan', cities: ['Saskatoon', 'Regina', 'Prince Albert'] },
'YT': { name: 'Yukon', cities: ['Whitehorse', 'Dawson City', 'Watson Lake'] }
}
}
};

export const validateUsername = (username) => {
const errors = [];

if (!username || username.length < 3) {
errors.push('Username must be at least 3 characters');
}

if (username && username.length > 50) {
errors.push('Username must be less than 50 characters');
}

if (username && !/^[a-zA-Z0-9_.+-]+$/.test(username)) {
errors.push('Username can only contain letters, numbers, dots, dashes, plus signs, and underscores');
}

return {
isValid: errors.length === 0,
errors
};
};

export const validateEmail = (email) => {
const errors = [];
const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

if (!email) {
errors.push('Email is required');
} else if (!emailRegex.test(email)) {
errors.push('Please enter a valid email address');
}

return {
isValid: errors.length === 0,
errors
};
};

export const validatePassword = (password) => {
const errors = [];
const requirements = {
length: password && password.length >= 8,
uppercase: password && /[A-Z]/.test(password),
lowercase: password && /[a-z]/.test(password),
number: password && /\d/.test(password),
special: password && /[!@#$%^&*(),.?":{}|<>]/.test(password)
};

if (!password) {
errors.push('Password is required');
return { isValid: false, errors, requirements, strength: 'empty' };
}

if (!requirements.length) {
errors.push('Password must be at least 8 characters');
}

const strength = calculatePasswordStrength(requirements);

if (strength === 'weak') {
errors.push('Password is too weak');
}

return {
isValid: errors.length === 0 && strength !== 'weak',
errors,
requirements,
strength
};
};

const calculatePasswordStrength = (requirements) => {
const score = Object.values(requirements).filter(Boolean).length;
if (score < 3) return 'weak';
if (score < 5) return 'medium';
return 'strong';
};

export const validatePasswordMatch = (password, confirmPassword) => {
const errors = [];

if (!confirmPassword) {
errors.push('Please confirm your password');
} else if (password !== confirmPassword) {
errors.push('Passwords do not match');
}

return {
isValid: errors.length === 0,
errors
};
};

export const validatePersonalInfo = (data) => {
const errors = {};

if (!data.firstName || data.firstName.trim().length === 0) {
errors.firstName = ['First name is required'];
} else if (data.firstName.length > 100) {
errors.firstName = ['First name must be less than 100 characters'];
}

if (!data.lastName || data.lastName.trim().length === 0) {
errors.lastName = ['Last name is required'];
} else if (data.lastName.length > 100) {
errors.lastName = ['Last name must be less than 100 characters'];
}

if (data.dateOfBirth) {
const birthDate = new Date(data.dateOfBirth);
const today = new Date();
const age = today.getFullYear() - birthDate.getFullYear();

if (age < 13) {
errors.dateOfBirth = ['You must be at least 13 years old'];
}
}

if (data.phone && !/^\+[1-9]\d{1,14}$/.test(data.phone.replace(/[\s()-]/g, ''))) {
errors.phone = ['Please enter a valid phone number with country code'];
}

return {
isValid: Object.keys(errors).length === 0,
errors
};
};

export const prepareRegistrationData = (formData) => {
const payload = {
// Required fields
username: formData.username.trim(),
email: formData.email.trim().toLowerCase(),
password: formData.password,
password_confirmation: formData.passwordConfirmation,
first_name: formData.firstName.trim(),
last_name: formData.lastName.trim()
};

// Optional fields - only include if provided
if (formData.userType) {
payload.user_type = formData.userType;
}

if (formData.dateOfBirth) {
payload.date_of_birth = formData.dateOfBirth; // YYYY-MM-DD format
}

if (formData.phone) {
payload.phone = formData.phone.trim();
}

if (formData.country) {
payload.country = formData.country;
}

if (formData.state) {
payload.state = formData.state;
}

if (formData.city) {
payload.city = formData.city.trim();
}

if (formData.zipcode) {
payload.zipcode = formData.zipcode.trim();
}

return payload;
};

// Debounce utility for real-time validation
export const debounce = (func, delay) => {
let timeoutId;
return (...args) => {
clearTimeout(timeoutId);
timeoutId = setTimeout(() => func.apply(null, args), delay);
};
};
EOF

echo "📧 Creating Email Verification Component..."

# 3. Create Email Verification Component
mkdir -p src/components/Auth
cat > src/components/Auth/EmailVerificationView.jsx << 'EOF'
import React, { useState, useEffect } from 'react';
import { CheckCircle, XCircle, Mail, ArrowLeft, RefreshCw } from 'lucide-react';
import { useApp } from '../../context/AppContext';
import registrationAPI, { APIError } from '../../services/registrationAPI';

const EmailVerificationView = ({ onBack, onSuccess, token, email }) => {
const { actions } = useApp();
const [verificationStatus, setVerificationStatus] = useState('verifying'); // 'verifying', 'success', 'error', 'expired'
const [isLoading, setIsLoading] = useState(false);
const [canResend, setCanResend] = useState(true);
const [resendCooldown, setResendCooldown] = useState(0);

useEffect(() => {
if (token) {
verifyEmailToken(token);
}
}, [token]);

useEffect(() => {
if (resendCooldown > 0) {
const timer = setTimeout(() => {
setResendCooldown(resendCooldown - 1);
}, 1000);
return () => clearTimeout(timer);
} else if (resendCooldown === 0 && !canResend) {
setCanResend(true);
}
}, [resendCooldown, canResend]);

const verifyEmailToken = async (verificationToken) => {
setIsLoading(true);
try {
const response = await registrationAPI.verifyEmail(verificationToken);

if (response.status === 'success') {
setVerificationStatus('success');
actions.addNotification({
type: 'success',
message: '🎉 Email verified successfully! You can now sign in.',
important: true,
duration: 4000
});
setTimeout(() => {
onSuccess && onSuccess();
}, 2000);
}
} catch (error) {
console.error('Email verification failed:', error);
if (error instanceof APIError) {
if (error.status === 400) {
setVerificationStatus('expired');
} else {
setVerificationStatus('error');
}
actions.addNotification({
type: 'error',
message: error.message || 'Email verification failed. Please try again.',
duration: 4000
});
} else {
setVerificationStatus('error');
actions.addNotification({
type: 'error',
message: 'Network error. Please check your connection.',
duration: 4000
});
}
} finally {
setIsLoading(false);
}
};

const handleResendEmail = async () => {
if (!canResend || !email) return;

setIsLoading(true);
setCanResend(false);
setResendCooldown(60);

try {
await registrationAPI.resendVerificationEmail(email);
actions.addNotification({
type: 'success',
message: '📧 Verification email sent! Check your inbox.',
duration: 4000
});
} catch (error) {
console.error('Resend verification failed:', error);
actions.addNotification({
type: 'error',
message: 'Failed to resend email. Please try again later.',
duration: 4000
});
setCanResend(true);
setResendCooldown(0);
} finally {
setIsLoading(false);
}
};

const renderContent = () => {
switch (verificationStatus) {
case 'verifying':
return (
<div className="verification-content">
<div className="verification-icon verifying">
<RefreshCw className="w-16 h-16 animate-spin text-blue-500" />
</div>
<h2 className="verification-title">Verifying Your Email...</h2>
<p className="verification-description">
Please wait while we verify your email address.
</p>
</div>
);

case 'success':
return (
<div className="verification-content">
<div className="verification-icon success">
<CheckCircle className="w-16 h-16 text-green-500" />
</div>
<h2 className="verification-title">Email Verified!</h2>
<p className="verification-description">
Your email has been successfully verified. You can now sign in to your account.
</p>
<button
onClick={onSuccess}
className="verification-button primary"
>
Continue to Login
</button>
</div>
);

case 'expired':
return (
<div className="verification-content">
<div className="verification-icon error">
<XCircle className="w-16 h-16 text-red-500" />
</div>
<h2 className="verification-title">Link Expired</h2>
<p className="verification-description">
This verification link has expired. Click below to receive a new verification email.
</p>
{email && (
<button
onClick={handleResendEmail}
disabled={!canResend || isLoading}
className="verification-button primary"
>
{isLoading ? (
<>
<div className="loading-spinner"></div>
Sending...
</>
) : canResend ? (
<>
<Mail className="w-4 h-4" />
Send New Link
</>
) : (
`Resend in ${resendCooldown}s`
)}
</button>
)}
</div>
);

case 'error':
default:
return (
<div className="verification-content">
<div className="verification-icon error">
<XCircle className="w-16 h-16 text-red-500" />
</div>
<h2 className="verification-title">Verification Failed</h2>
<p className="verification-description">
We couldn't verify your email. The link may be invalid or expired.
</p>
{email && (
<button
onClick={handleResendEmail}
disabled={!canResend || isLoading}
className="verification-button primary"
>
{isLoading ? (
<>
<div className="loading-spinner"></div>
Sending...
</>
) : canResend ? (
<>
<Mail className="w-4 h-4" />
Resend Email
</>
) : (
`Resend in ${resendCooldown}s`
)}
</button>
)}
</div>
);
}
};

return (
<div className="verification-page">
<div className="verification-background">
<div className="verification-gradient"></div>
</div>
<div className="verification-container">
<div className="verification-header">
<button onClick={onBack} className="verification-back-button">
<ArrowLeft className="w-5 h-5" />
</button>
<div className="verification-brand">
<h1 className="verification-page-title">Email Verification</h1>
<p className="verification-page-subtitle">nYtevibe Account Activation</p>
</div>
</div>

<div className="verification-card">
{renderContent()}
</div>
</div>
</div>
);
};

export default EmailVerificationView;
EOF

echo "📝 Creating Multi-Step Registration Component (without availability checks)..."

# 4. Create Multi-Step Registration Component without availability checks
cat > src/components/Registration/RegistrationView.jsx << 'EOF'
import React, { useState, useEffect } from 'react';
import {
ArrowLeft,
User,
Mail,
Lock,
Eye,
EyeOff,
Check,
X,
ChevronDown,
Calendar,
Phone,
MapPin,
Zap,
Star,
Users,
TrendingUp,
Shield,
Globe
} from 'lucide-react';
import { useApp } from '../../context/AppContext';
import registrationAPI, { APIError } from '../../services/registrationAPI';
import {
validateUsername,
validateEmail,
validatePassword,
validatePasswordMatch,
validatePersonalInfo,
prepareRegistrationData,
LOCATION_DATA
} from '../../utils/registrationValidation';

const RegistrationView = ({ onBack, onSuccess }) => {
const { actions } = useApp();

// Multi-step state
const [currentStep, setCurrentStep] = useState(1);
const [isLoading, setIsLoading] = useState(false);

// Form data state
const [formData, setFormData] = useState({
userType: 'user',
username: '',
email: '',
password: '',
passwordConfirmation: '',
firstName: '',
lastName: '',
dateOfBirth: '',
phone: '',
country: 'US',
state: '',
city: '',
zipcode: ''
});

// Validation state
const [validation, setValidation] = useState({});

// UI state
const [showPassword, setShowPassword] = useState(false);
const [showPasswordConfirm, setShowPasswordConfirm] = useState(false);

// Handle form data changes
const handleInputChange = (field, value) => {
setFormData(prev => ({ ...prev, [field]: value }));

// Clear validation for this field
setValidation(prev => ({ ...prev, [field]: null }));

// Clear dependent location fields
if (field === 'country') {
setFormData(prev => ({ ...prev, state: '', city: '' }));
}
if (field === 'state') {
setFormData(prev => ({ ...prev, city: '' }));
}
};

// Validate current step
const validateCurrentStep = () => {
const errors = {};

switch (currentStep) {
case 1: // Account Type
// No validation needed for account type selection
break;

case 2: // Username & Email
const usernameValidation = validateUsername(formData.username);
if (!usernameValidation.isValid) {
errors.username = usernameValidation.errors;
}

const emailValidation = validateEmail(formData.email);
if (!emailValidation.isValid) {
errors.email = emailValidation.errors;
}
break;

case 3: // Password
const passwordValidation = validatePassword(formData.password);
if (!passwordValidation.isValid) {
errors.password = passwordValidation.errors;
}

const passwordMatchValidation = validatePasswordMatch(
formData.password,
formData.passwordConfirmation
);
if (!passwordMatchValidation.isValid) {
errors.passwordConfirmation = passwordMatchValidation.errors;
}
break;

case 4: // Personal Info
const personalValidation = validatePersonalInfo(formData);
Object.assign(errors, personalValidation.errors);
break;

case 5: // Location
// Location is optional, no validation errors
break;
}

setValidation(errors);
return Object.keys(errors).length === 0;
};

// Handle step navigation
const handleNextStep = () => {
if (validateCurrentStep()) {
setCurrentStep(prev => Math.min(prev + 1, 5));
}
};

const handlePrevStep = () => {
setCurrentStep(prev => Math.max(prev - 1, 1));
};

// Handle registration submission
const handleRegistration = async () => {
if (!validateCurrentStep()) {
return;
}

setIsLoading(true);

try {
const registrationData = prepareRegistrationData(formData);
const response = await registrationAPI.register(registrationData);

if (response.status === 'success') {
// Show success notification
actions.addNotification({
type: 'success',
message: `✅ Registration successful! Check your email for verification link.`,
important: true,
duration: 6000
});

// Store email for potential resend verification
localStorage.setItem('pending_verification_email', formData.email);

// Redirect to login with verification message
actions.setVerificationMessage({
show: true,
email: formData.email,
type: 'registration_success'
});

// Call success callback (should redirect to login)
onSuccess && onSuccess({
requiresVerification: true,
email: formData.email
});
}
} catch (error) {
console.error('Registration failed:', error);
if (error instanceof APIError) {
if (error.status === 422) {
// Validation errors from backend
setValidation(error.errors);
actions.addNotification({
type: 'error',
message: 'Please check the form for errors and try again.',
duration: 4000
});
} else if (error.status === 429) {
actions.addNotification({
type: 'error',
message: 'Too many registration attempts. Please try again later.',
duration: 5000
});
} else {
actions.addNotification({
type: 'error',
message: 'Registration failed. Please try again.',
duration: 4000
});
}
} else {
actions.addNotification({
type: 'error',
message: 'Network error. Please check your connection.',
duration: 4000
});
}
} finally {
setIsLoading(false);
}
};

// Get location options
const getStateOptions = () => {
const countryData = LOCATION_DATA[formData.country];
return countryData ? Object.entries(countryData.states).map(([code, data]) => ({
value: code,
label: data.name
})) : [];
};

const getCityOptions = () => {
const countryData = LOCATION_DATA[formData.country];
const stateData = countryData?.states[formData.state];
return stateData ? stateData.cities.map(city => ({
value: city,
label: city
})) : [];
};

// Render step content
const renderStepContent = () => {
switch (currentStep) {
case 1:
return <AccountTypeStep formData={formData} onChange={handleInputChange} />;
case 2:
return (
<CredentialsStep
formData={formData}
onChange={handleInputChange}
validation={validation}
/>
);
case 3:
return (
<PasswordStep
formData={formData}
onChange={handleInputChange}
validation={validation}
showPassword={showPassword}
setShowPassword={setShowPassword}
showPasswordConfirm={showPasswordConfirm}
setShowPasswordConfirm={setShowPasswordConfirm}
/>
);
case 4:
return (
<PersonalInfoStep
formData={formData}
onChange={handleInputChange}
validation={validation}
/>
);
case 5:
return (
<LocationStep
formData={formData}
onChange={handleInputChange}
validation={validation}
stateOptions={getStateOptions()}
cityOptions={getCityOptions()}
/>
);
default:
return null;
}
};

return (
<div className="registration-page">
<div className="registration-background">
<div className="registration-gradient"></div>
</div>
<div className="registration-container">
{/* Header */}
<div className="registration-header">
<button onClick={onBack} className="registration-back-button">
<ArrowLeft className="w-5 h-5" />
</button>
<div className="registration-brand">
<div className="registration-logo">
<Zap className="w-8 h-8 text-white" />
</div>
<h1 className="registration-title">Join nYtevibe</h1>
<p className="registration-subtitle">Create your nightlife discovery account</p>
</div>
</div>

{/* Progress Bar */}
<div className="registration-progress">
<div className="progress-bar">
<div
className="progress-fill"
style={{ width: `${(currentStep / 5) * 100}%` }}
></div>
</div>
<span className="progress-text">Step {currentStep} of 5</span>
</div>

{/* Step Content */}
<div className="registration-content">
{renderStepContent()}
</div>

{/* Navigation */}
<div className="registration-navigation">
{currentStep > 1 && (
<button
onClick={handlePrevStep}
className="nav-button secondary"
disabled={isLoading}
>
Previous
</button>
)}

{currentStep < 5 ? (
<button
onClick={handleNextStep}
className="nav-button primary"
disabled={isLoading}
>
Continue
</button>
) : (
<button
onClick={handleRegistration}
className="nav-button primary"
disabled={isLoading}
>
{isLoading ? (
<>
<div className="loading-spinner"></div>
Creating Account...
</>
) : (
<>
<User className="w-4 h-4" />
Create Account
</>
)}
</button>
)}
</div>
</div>
</div>
);
};

// Step Components
const AccountTypeStep = ({ formData, onChange }) => (
<div className="step-content">
<h2 className="step-title">Choose Your Account Type</h2>
<p className="step-description">
Select the type of account that best describes how you'll use nYtevibe
</p>

<div className="account-type-options">
<button
className={`account-type-card ${formData.userType === 'user' ? 'selected' : ''}`}
onClick={() => onChange('userType', 'user')}
>
<div className="account-type-icon">
<Users className="w-8 h-8" />
</div>
<h3>Nightlife Explorer</h3>
<p>Discover venues, rate experiences, and connect with the nightlife community</p>
<div className="account-type-features">
<span><Star className="w-4 h-4" /> Rate & Review Venues</span>
<span><TrendingUp className="w-4 h-4" /> Follow Trending Spots</span>
<span><Users className="w-4 h-4" /> Social Features</span>
</div>
</button>

<button
className={`account-type-card ${formData.userType === 'business' ? 'selected' : ''}`}
onClick={() => onChange('userType', 'business')}
>
<div className="account-type-icon">
<Shield className="w-8 h-8" />
</div>
<h3>Business Owner</h3>
<p>Manage your venue, track analytics, and engage with customers</p>
<div className="account-type-features">
<span><MapPin className="w-4 h-4" /> Venue Management</span>
<span><TrendingUp className="w-4 h-4" /> Analytics Dashboard</span>
<span><Star className="w-4 h-4" /> Customer Engagement</span>
</div>
</button>
</div>
</div>
);

const CredentialsStep = ({ formData, onChange, validation }) => (
<div className="step-content">
<h2 className="step-title">Create Your Credentials</h2>
<p className="step-description">
Choose a unique username and enter your email address
</p>

<div className="form-fields">
<div className="form-group">
<label htmlFor="username" className="form-label">Username</label>
<div className="input-with-validation">
<div className="input-wrapper">
<User className="input-icon" />
<input
id="username"
type="text"
value={formData.username}
onChange={(e) => onChange('username', e.target.value)}
className={`form-input ${validation.username ? 'error' : ''}`}
placeholder="Choose your username"
/>
</div>
{validation.username && (
<div className="field-errors">
{validation.username.map((error, idx) => (
<span key={idx} className="error-message">{error}</span>
))}
</div>
)}
</div>
</div>

<div className="form-group">
<label htmlFor="email" className="form-label">Email Address</label>
<div className="input-with-validation">
<div className="input-wrapper">
<Mail className="input-icon" />
<input
id="email"
type="email"
value={formData.email}
onChange={(e) => onChange('email', e.target.value)}
className={`form-input ${validation.email ? 'error' : ''}`}
placeholder="Enter your email"
/>
</div>
{validation.email && (
<div className="field-errors">
{validation.email.map((error, idx) => (
<span key={idx} className="error-message">{error}</span>
))}
</div>
)}
</div>
</div>
</div>
</div>
);

const PasswordStep = ({
formData,
onChange,
validation,
showPassword,
setShowPassword,
showPasswordConfirm,
setShowPasswordConfirm
}) => {
const passwordValidation = validatePassword(formData.password);

return (
<div className="step-content">
<h2 className="step-title">Secure Your Account</h2>
<p className="step-description">
Create a strong password to protect your account
</p>

<div className="form-fields">
<div className="form-group">
<label htmlFor="password" className="form-label">Password</label>
<div className="input-with-validation">
<div className="input-wrapper">
<Lock className="input-icon" />
<input
id="password"
type={showPassword ? 'text' : 'password'}
value={formData.password}
onChange={(e) => onChange('password', e.target.value)}
className={`form-input ${validation.password ? 'error' : ''}`}
placeholder="Create a strong password"
/>
<button
type="button"
onClick={() => setShowPassword(!showPassword)}
className="password-toggle"
>
{showPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
</button>
</div>

{formData.password && (
<div className="password-strength">
<div className="strength-bars">
<div className={`strength-bar ${passwordValidation.strength === 'weak' ? 'weak' : passwordValidation.strength === 'medium' ? 'medium' : 'strong'}`}></div>
<div className={`strength-bar ${passwordValidation.strength === 'medium' || passwordValidation.strength === 'strong' ? passwordValidation.strength === 'medium' ? 'medium' : 'strong' : ''}`}></div>
<div className={`strength-bar ${passwordValidation.strength === 'strong' ? 'strong' : ''}`}></div>
</div>
<span className="strength-text">
{passwordValidation.strength === 'weak' && 'Weak'}
{passwordValidation.strength === 'medium' && 'Medium'}
{passwordValidation.strength === 'strong' && 'Strong'}
</span>
</div>
)}

{formData.password && (
<div className="password-requirements">
<div className={`requirement ${passwordValidation.requirements.length ? 'met' : 'unmet'}`}>
{passwordValidation.requirements.length ? <Check className="w-3 h-3" /> : <X className="w-3 h-3" />}
At least 8 characters
</div>
<div className={`requirement ${passwordValidation.requirements.uppercase ? 'met' : 'unmet'}`}>
{passwordValidation.requirements.uppercase ? <Check className="w-3 h-3" /> : <X className="w-3 h-3" />}
One uppercase letter
</div>
<div className={`requirement ${passwordValidation.requirements.lowercase ? 'met' : 'unmet'}`}>
{passwordValidation.requirements.lowercase ? <Check className="w-3 h-3" /> : <X className="w-3 h-3" />}
One lowercase letter
</div>
<div className={`requirement ${passwordValidation.requirements.number ? 'met' : 'unmet'}`}>
{passwordValidation.requirements.number ? <Check className="w-3 h-3" /> : <X className="w-3 h-3" />}
One number
</div>
</div>
)}

{validation.password && (
<div className="field-errors">
{validation.password.map((error, idx) => (
<span key={idx} className="error-message">{error}</span>
))}
</div>
)}
</div>
</div>

<div className="form-group">
<label htmlFor="passwordConfirmation" className="form-label">Confirm Password</label>
<div className="input-with-validation">
<div className="input-wrapper">
<Lock className="input-icon" />
<input
id="passwordConfirmation"
type={showPasswordConfirm ? 'text' : 'password'}
value={formData.passwordConfirmation}
onChange={(e) => onChange('passwordConfirmation', e.target.value)}
className={`form-input ${validation.passwordConfirmation ? 'error' : ''} ${formData.passwordConfirmation && formData.password === formData.passwordConfirmation ? 'success' : ''}`}
placeholder="Confirm your password"
/>
<button
type="button"
onClick={() => setShowPasswordConfirm(!showPasswordConfirm)}
className="password-toggle"
>
{showPasswordConfirm ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
</button>
{formData.passwordConfirmation && formData.password === formData.passwordConfirmation && (
<Check className="validation-icon success" />
)}
</div>
{validation.passwordConfirmation && (
<div className="field-errors">
{validation.passwordConfirmation.map((error, idx) => (
<span key={idx} className="error-message">{error}</span>
))}
</div>
)}
{formData.passwordConfirmation && formData.password === formData.passwordConfirmation && (
<span className="success-message">Passwords match!</span>
)}
</div>
</div>
</div>
</div>
);
};

const PersonalInfoStep = ({ formData, onChange, validation }) => (
<div className="step-content">
<h2 className="step-title">Personal Information</h2>
<p className="step-description">
Tell us a bit about yourself to personalize your experience
</p>

<div className="form-fields">
<div className="form-row">
<div className="form-group">
<label htmlFor="firstName" className="form-label">First Name</label>
<div className="input-with-validation">
<input
id="firstName"
type="text"
value={formData.firstName}
onChange={(e) => onChange('firstName', e.target.value)}
className={`form-input ${validation.firstName ? 'error' : ''}`}
placeholder="Your first name"
/>
{validation.firstName && (
<div className="field-errors">
{validation.firstName.map((error, idx) => (
<span key={idx} className="error-message">{error}</span>
))}
</div>
)}
</div>
</div>

<div className="form-group">
<label htmlFor="lastName" className="form-label">Last Name</label>
<div className="input-with-validation">
<input
id="lastName"
type="text"
value={formData.lastName}
onChange={(e) => onChange('lastName', e.target.value)}
className={`form-input ${validation.lastName ? 'error' : ''}`}
placeholder="Your last name"
/>
{validation.lastName && (
<div className="field-errors">
{validation.lastName.map((error, idx) => (
<span key={idx} className="error-message">{error}</span>
))}
</div>
)}
</div>
</div>
</div>

<div className="form-group">
<label htmlFor="dateOfBirth" className="form-label">Date of Birth <span className="optional">(Optional)</span></label>
<div className="input-with-validation">
<div className="input-wrapper">
<Calendar className="input-icon" />
<input
id="dateOfBirth"
type="date"
value={formData.dateOfBirth}
onChange={(e) => onChange('dateOfBirth', e.target.value)}
className={`form-input ${validation.dateOfBirth ? 'error' : ''}`}
max={new Date(new Date().setFullYear(new Date().getFullYear() - 13)).toISOString().split('T')[0]}
/>
</div>
{validation.dateOfBirth && (
<div className="field-errors">
{validation.dateOfBirth.map((error, idx) => (
<span key={idx} className="error-message">{error}</span>
))}
</div>
)}
</div>
</div>

<div className="form-group">
<label htmlFor="phone" className="form-label">Phone Number <span className="optional">(Optional)</span></label>
<div className="input-with-validation">
<div className="input-wrapper">
<Phone className="input-icon" />
<input
id="phone"
type="tel"
value={formData.phone}
onChange={(e) => onChange('phone', e.target.value)}
className={`form-input ${validation.phone ? 'error' : ''}`}
placeholder="+1 (555) 123-4567"
/>
</div>
{validation.phone && (
<div className="field-errors">
{validation.phone.map((error, idx) => (
<span key={idx} className="error-message">{error}</span>
))}
</div>
)}
</div>
</div>
</div>
</div>
);

const LocationStep = ({ formData, onChange, validation, stateOptions, cityOptions }) => (
<div className="step-content">
<h2 className="step-title">Location Information</h2>
<p className="step-description">
Help us personalize your nightlife discovery experience <span className="optional">(All Optional)</span>
</p>

<div className="form-fields">
<div className="form-group">
<label htmlFor="country" className="form-label">Country</label>
<div className="input-wrapper">
<Globe className="input-icon" />
<select
id="country"
value={formData.country}
onChange={(e) => onChange('country', e.target.value)}
className="form-select"
>
<option value="US">🇺🇸 United States</option>
<option value="CA">🇨🇦 Canada</option>
</select>
<ChevronDown className="select-icon" />
</div>
</div>

<div className="form-group">
<label htmlFor="state" className="form-label">State/Province</label>
<div className="input-wrapper">
<MapPin className="input-icon" />
<select
id="state"
value={formData.state}
onChange={(e) => onChange('state', e.target.value)}
className="form-select"
disabled={!stateOptions.length}
>
<option value="">Select a state</option>
{stateOptions.map(option => (
<option key={option.value} value={option.value}>
{option.label}
</option>
))}
</select>
<ChevronDown className="select-icon" />
</div>
</div>

<div className="form-row">
<div className="form-group">
<label htmlFor="city" className="form-label">City</label>
<div className="input-wrapper">
<MapPin className="input-icon" />
<select
id="city"
value={formData.city}
onChange={(e) => onChange('city', e.target.value)}
className="form-select"
disabled={!cityOptions.length}
>
<option value="">Select a city</option>
{cityOptions.map(option => (
<option key={option.value} value={option.value}>
{option.label}
</option>
))}
</select>
<ChevronDown className="select-icon" />
</div>
</div>

<div className="form-group">
<label htmlFor="zipcode" className="form-label">ZIP/Postal Code</label>
<input
id="zipcode"
type="text"
value={formData.zipcode}
onChange={(e) => onChange('zipcode', e.target.value)}
className="form-input"
placeholder={formData.country === 'CA' ? 'A1A 1A1' : '12345'}
/>
</div>
</div>
</div>
</div>
);

export default RegistrationView;
EOF

echo "🔄 Updating Login View with email verification support..."

# 5. Update Login View to handle email verification
cat > src/components/Views/LoginView.jsx << 'EOF'
import React, { useState, useEffect } from 'react';
import { Eye, EyeOff, User, Lock, Zap, Star, Clock, Users, MapPin, Mail, RefreshCw } from 'lucide-react';
import { useApp } from '../../context/AppContext';
import registrationAPI, { APIError } from '../../services/registrationAPI';

const LoginView = ({ onRegister }) => {
const { state, actions } = useApp();
const [username, setUsername] = useState('');
const [password, setPassword] = useState('');
const [showPassword, setShowPassword] = useState(false);
const [error, setError] = useState('');
const [isLoading, setIsLoading] = useState(false);
const [canResendVerification, setCanResendVerification] = useState(true);
const [resendCooldown, setResendCooldown] = useState(0);

const demoCredentials = {
username: 'demouser',
password: 'demopass'
};

// Handle verification message from registration
const verificationMessage = state.verificationMessage;

useEffect(() => {
if (resendCooldown > 0) {
const timer = setTimeout(() => {
setResendCooldown(resendCooldown - 1);
}, 1000);
return () => clearTimeout(timer);
} else if (resendCooldown === 0 && !canResendVerification) {
setCanResendVerification(true);
}
}, [resendCooldown, canResendVerification]);

// Clear verification message when component unmounts or user starts typing
useEffect(() => {
if ((username || password) && verificationMessage?.show) {
actions.clearVerificationMessage();
}
}, [username, password, verificationMessage, actions]);

const fillDemoCredentials = () => {
setUsername(demoCredentials.username);
setPassword(demoCredentials.password);
setError('');
};

const handleSubmit = async (e) => {
e.preventDefault();
setError('');
setIsLoading(true);

try {
// Check if demo credentials
if (username === demoCredentials.username && password === demoCredentials.password) {
// Demo login (unchanged)
setTimeout(() => {
actions.loginUser({
id: 'usr_demo',
username: username,
firstName: 'Demo',
lastName: 'User',
email: 'demo@nytevibe.com',
level: 5,
points: 1250,
user_type: 'user',
email_verified: true
});

actions.addNotification({
type: 'success',
message: `🎉 Welcome back, Demo!`,
important: true,
duration: 3000
});
setIsLoading(false);
}, 1000);
return;
}

// Real API login
const response = await registrationAPI.login({
username,
password
});

if (response.status === 'success') {
// Check if email is verified
if (!response.data.user.email_verified) {
setError('Please verify your email before signing in. Check your inbox for the verification link.');
setIsLoading(false);
return;
}

// Store authentication token
localStorage.setItem('auth_token', response.data.token);

// Login user
actions.loginUser(response.data.user);

actions.addNotification({
type: 'success',
message: `🎉 Welcome back, ${response.data.user.first_name}!`,
important: true,
duration: 3000
});
}
} catch (error) {
console.error('Login failed:', error);
if (error instanceof APIError) {
if (error.status === 401) {
setError('Invalid username or password.');
} else if (error.status === 403 && error.code === 'EMAIL_NOT_VERIFIED') {
setError('Please verify your email before signing in. Check your inbox for the verification link.');
} else if (error.status === 429) {
setError('Too many login attempts. Please try again later.');
} else {
setError('Login failed. Please try again.');
}
} else {
setError('Network error. Please check your connection.');
}
} finally {
setIsLoading(false);
}
};

const handleResendVerification = async () => {
if (!canResendVerification || !verificationMessage?.email) return;

setCanResendVerification(false);
setResendCooldown(60);

try {
await registrationAPI.resendVerificationEmail(verificationMessage.email);
actions.addNotification({
type: 'success',
message: '📧 Verification email sent! Check your inbox.',
duration: 4000
});
} catch (error) {
console.error('Resend verification failed:', error);
actions.addNotification({
type: 'error',
message: 'Failed to resend email. Please try again later.',
duration: 4000
});
setCanResendVerification(true);
setResendCooldown(0);
}
};

const features = [
{ icon: Star, text: "Rate and review nightlife venues" },
{ icon: Clock, text: "Get real-time crowd levels and wait times" },
{ icon: Users, text: "Connect with fellow nightlife enthusiasts" },
{ icon: Zap, text: "Discover trending spots before they blow up" }
];

return (
<div className="login-page">
<div className="login-background">
<div className="login-gradient"></div>
</div>
<div className="login-container">
<div className="login-card">
<div className="login-card-header">
<div className="login-logo">
<div className="logo-icon">
<Zap className="w-10 h-10 text-white" />
</div>
<h2 className="login-title">Welcome to nYtevibe</h2>
<p className="login-subtitle">Global Nightlife Discovery Platform</p>
</div>
</div>

{/* Email Verification Banner */}
{verificationMessage?.show && (
<div className="verification-banner">
<div className="verification-content">
<div className="verification-icon">
<Mail className="w-6 h-6 text-blue-500" />
</div>
<div className="verification-text">
<h4 className="verification-title">Check Your Email</h4>
<p className="verification-description">
We sent a verification link to <strong>{verificationMessage.email}</strong>. 
Click the link to activate your account.
</p>
</div>
</div>
{verificationMessage.email && (
<button
onClick={handleResendVerification}
disabled={!canResendVerification}
className="resend-button"
>
{canResendVerification ? (
<>
<RefreshCw className="w-4 h-4" />
Resend
</>
) : (
`${resendCooldown}s`
)}
</button>
)}
</div>
)}

<div className="demo-banner">
<div className="demo-content">
<div className="demo-info">
<h4 className="demo-title">Demo Account Available</h4>
<p className="demo-description">
Try nYtevibe with our demo account. Click below to auto-fill credentials.
</p>
</div>
<button
type="button"
onClick={fillDemoCredentials}
className="demo-fill-button"
>
Fill Demo
</button>
</div>
</div>

<form onSubmit={handleSubmit} className="login-form">
{error && (
<div className="error-banner">
<span className="error-icon">⚠️</span>
<span className="error-text">{error}</span>
</div>
)}

<div className="form-group">
<label htmlFor="username" className="form-label">Username</label>
<div className="input-wrapper">
<User className="input-icon" />
<input
id="username"
type="text"
value={username}
onChange={(e) => setUsername(e.target.value)}
className="form-input"
placeholder="Enter your username"
required
/>
</div>
</div>

<div className="form-group">
<label htmlFor="password" className="form-label">Password</label>
<div className="input-wrapper">
<Lock className="input-icon" />
<input
id="password"
type={showPassword ? 'text' : 'password'}
value={password}
onChange={(e) => setPassword(e.target.value)}
className="form-input"
placeholder="Enter your password"
required
/>
<button
type="button"
onClick={() => setShowPassword(!showPassword)}
className="password-toggle"
>
{showPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
</button>
</div>
</div>

<button
type="submit"
disabled={isLoading}
className={`login-button ${isLoading ? 'loading' : ''}`}
>
{isLoading ? (
<>
<div className="loading-spinner"></div>
Signing In...
</>
) : (
<>
<User className="w-4 h-4" />
Sign In
</>
)}
</button>
</form>

<div className="login-card-footer">
<p className="footer-text">
New to nYtevibe?{' '}
<button
className="footer-link"
onClick={onRegister}
type="button"
>
Create Account
</button>
</p>
</div>
</div>

<div className="login-features">
<h3 className="features-title">Discover Global Nightlife</h3>
<ul className="features-list">
{features.map((feature, index) => (
<li key={index} className="feature-item">
<feature.icon className="w-4 h-4 text-blue-400" />
<span>{feature.text}</span>
</li>
))}
</ul>

<div className="platform-stats">
<div className="stat-highlight">
<span className="stat-number">10K+</span>
<span className="stat-label">Venues</span>
</div>
<div className="stat-highlight">
<span className="stat-number">50K+</span>
<span className="stat-label">Users</span>
</div>
<div className="stat-highlight">
<span className="stat-number">200+</span>
<span className="stat-label">Cities</span>
</div>
</div>
</div>
</div>
</div>
);
};

export default LoginView;
EOF

echo "🔄 Updating App Context for email verification state..."

# 6. Update AppContext to include email verification state
cat > src/context/AppContext.jsx << 'EOF'
import React, { createContext, useContext, useReducer, useCallback } from 'react';

const AppContext = createContext();

// Initial state
const initialState = {
currentView: 'login',
searchQuery: '',
isAuthenticated: false,
userProfile: null,
userType: null,
selectedVenue: null,
followedVenues: new Set(),
notifications: [],

// Modal states
showRatingModal: false,
showReportModal: false,
showShareModal: false,
showUserProfileModal: false,

// Registration state
registrationStep: 1,
registrationData: {},

// Email verification state
verificationMessage: {
show: false,
email: '',
type: '' // 'registration_success', 'resend_verification'
},

// Share modal state
shareVenue: null,

// Demo venue data
venues: [
{
id: 'venue_001',
name: 'Rooftop Lounge',
type: 'Rooftop Bar',
address: '123 Downtown Ave, Houston, TX 77002',
rating: 4.5,
totalRatings: 324,
crowdLevel: 75,
waitTime: 15,
followersCount: 1289,
reports: 45,
lastUpdate: '5 min ago',
confidence: 92,
hasPromotion: true,
promotionText: 'Happy Hour: 50% off cocktails until 8 PM!',
vibe: ['Upscale', 'City Views', 'Cocktails', 'Live Music'],
phone: '+1-713-555-0123',
hours: 'Mon-Thu 5PM-12AM, Fri-Sat 5PM-2AM, Sun 6PM-11PM',
reviews: [
{
id: 'rev_001',
user: 'Sarah M.',
rating: 5,
date: '2 days ago',
comment: 'Amazing views and great cocktails! The rooftop atmosphere is perfect for date night.',
helpful: 12
},
{
id: 'rev_002',
user: 'Mike R.',
rating: 4,
date: '1 week ago',
comment: 'Good vibes and decent drinks. Can get crowded on weekends but worth the wait.',
helpful: 8
}
]
},
{
id: 'venue_002',
name: 'Underground Club',
type: 'Dance Club',
address: '456 Music District, Houston, TX 77004',
rating: 4.2,
totalRatings: 567,
crowdLevel: 90,
waitTime: 30,
followersCount: 2134,
reports: 78,
lastUpdate: '2 min ago',
confidence: 88,
hasPromotion: false,
promotionText: '',
vibe: ['EDM', 'Dancing', 'Late Night', 'Underground'],
phone: '+1-713-555-0124',
hours: 'Thu-Sat 10PM-4AM',
reviews: [
{
id: 'rev_003',
user: 'Alex P.',
rating: 5,
date: '3 days ago',
comment: 'Best EDM club in Houston! Amazing sound system and the crowd is always energetic.',
helpful: 15
}
]
},
{
id: 'venue_003',
name: 'Craft Beer Garden',
type: 'Beer Garden',
address: '789 Brewery Lane, Houston, TX 77006',
rating: 4.7,
totalRatings: 891,
crowdLevel: 45,
waitTime: 0,
followersCount: 3456,
reports: 23,
lastUpdate: '1 min ago',
confidence: 95,
hasPromotion: true,
promotionText: 'Try our new seasonal IPA - 20% off today only!',
vibe: ['Craft Beer', 'Outdoor', 'Relaxed', 'Food Trucks'],
phone: '+1-713-555-0125',
hours: 'Mon-Wed 4PM-11PM, Thu-Sat 2PM-12AM, Sun 2PM-10PM',
reviews: [
{
id: 'rev_004',
user: 'Jennifer L.',
rating: 5,
date: '1 day ago',
comment: 'Love the outdoor setting and amazing beer selection. Food trucks on weekends are a bonus!',
helpful: 20
}
]
},
{
id: 'venue_004',
name: 'Jazz Corner',
type: 'Jazz Club',
address: '321 Heritage St, Houston, TX 77007',
rating: 4.8,
totalRatings: 234,
crowdLevel: 60,
waitTime: 5,
followersCount: 987,
reports: 12,
lastUpdate: '8 min ago',
confidence: 87,
hasPromotion: false,
promotionText: '',
vibe: ['Live Jazz', 'Intimate', 'Classic', 'Wine Bar'],
phone: '+1-713-555-0126',
hours: 'Tue-Sun 7PM-1AM',
reviews: [
{
id: 'rev_005',
user: 'Robert K.',
rating: 5,
date: '4 days ago',
comment: 'Authentic jazz experience with talented local musicians. Intimate setting with excellent acoustics.',
helpful: 9
}
]
},
{
id: 'venue_005',
name: 'Sports Bar Central',
type: 'Sports Bar',
address: '654 Stadium Dr, Houston, TX 77008',
rating: 4.1,
totalRatings: 445,
crowdLevel: 85,
waitTime: 20,
followersCount: 1678,
reports: 34,
lastUpdate: '3 min ago',
confidence: 91,
hasPromotion: true,
promotionText: 'Game Day Special: $2 beers during all Texans games!',
vibe: ['Sports', 'Casual', 'Big Screens', 'Wings'],
phone: '+1-713-555-0127',
hours: 'Daily 11AM-2AM',
reviews: [
{
id: 'rev_006',
user: 'Tom W.',
rating: 4,
date: '5 days ago',
comment: 'Great place to watch the game with friends. Lots of TVs and good bar food.',
helpful: 6
}
]
},
{
id: 'venue_006',
name: 'Mixology Lab',
type: 'Cocktail Lounge',
address: '987 Innovation Blvd, Houston, TX 77009',
rating: 4.6,
totalRatings: 312,
crowdLevel: 55,
waitTime: 10,
followersCount: 2567,
reports: 18,
lastUpdate: '6 min ago',
confidence: 89,
hasPromotion: false,
promotionText: '',
vibe: ['Craft Cocktails', 'Sophisticated', 'Innovation', 'Date Night'],
phone: '+1-713-555-0128',
hours: 'Wed-Sat 6PM-2AM',
reviews: [
{
id: 'rev_007',
user: 'Lisa H.',
rating: 5,
date: '2 days ago',
comment: 'Incredible cocktail creations! Each drink is like a work of art. Definitely worth the premium prices.',
helpful: 14
}
]
}
]
};

// Action types
const actionTypes = {
SET_CURRENT_VIEW: 'SET_CURRENT_VIEW',
SET_SEARCH_QUERY: 'SET_SEARCH_QUERY',
SET_USER_TYPE: 'SET_USER_TYPE',
LOGIN_USER: 'LOGIN_USER',
LOGOUT_USER: 'LOGOUT_USER',
SET_SELECTED_VENUE: 'SET_SELECTED_VENUE',
TOGGLE_VENUE_FOLLOW: 'TOGGLE_VENUE_FOLLOW',
UPDATE_VENUE_DATA: 'UPDATE_VENUE_DATA',
ADD_NOTIFICATION: 'ADD_NOTIFICATION',
REMOVE_NOTIFICATION: 'REMOVE_NOTIFICATION',
SET_SHOW_RATING_MODAL: 'SET_SHOW_RATING_MODAL',
SET_SHOW_REPORT_MODAL: 'SET_SHOW_REPORT_MODAL',
SET_SHOW_SHARE_MODAL: 'SET_SHOW_SHARE_MODAL',
SET_SHOW_USER_PROFILE_MODAL: 'SET_SHOW_USER_PROFILE_MODAL',
SET_SHARE_VENUE: 'SET_SHARE_VENUE',
SUBMIT_VENUE_RATING: 'SUBMIT_VENUE_RATING',
SUBMIT_VENUE_REPORT: 'SUBMIT_VENUE_REPORT',

// Registration actions
SET_REGISTRATION_STEP: 'SET_REGISTRATION_STEP',
UPDATE_REGISTRATION_DATA: 'UPDATE_REGISTRATION_DATA',
CLEAR_REGISTRATION_DATA: 'CLEAR_REGISTRATION_DATA',

// Email verification actions
SET_VERIFICATION_MESSAGE: 'SET_VERIFICATION_MESSAGE',
CLEAR_VERIFICATION_MESSAGE: 'CLEAR_VERIFICATION_MESSAGE'
};

// Reducer
function appReducer(state, action) {
switch (action.type) {
case actionTypes.SET_CURRENT_VIEW:
return { ...state, currentView: action.payload };

case actionTypes.SET_SEARCH_QUERY:
return { ...state, searchQuery: action.payload };

case actionTypes.SET_USER_TYPE:
return { ...state, userType: action.payload };

case actionTypes.LOGIN_USER:
return {
...state,
isAuthenticated: true,
userProfile: action.payload,
currentView: 'home'
};

case actionTypes.LOGOUT_USER:
localStorage.removeItem('auth_token');
return {
...state,
isAuthenticated: false,
userProfile: null,
userType: null,
currentView: 'login',
followedVenues: new Set()
};

case actionTypes.SET_SELECTED_VENUE:
return { ...state, selectedVenue: action.payload };

case actionTypes.TOGGLE_VENUE_FOLLOW:
const newFollowedVenues = new Set(state.followedVenues);
const venueId = action.payload;
if (newFollowedVenues.has(venueId)) {
newFollowedVenues.delete(venueId);
} else {
newFollowedVenues.add(venueId);
}
return {
...state,
followedVenues: newFollowedVenues,
venues: state.venues.map(venue =>
venue.id === venueId
? {
...venue,
followersCount: newFollowedVenues.has(venueId)
? venue.followersCount + 1
: venue.followersCount - 1
}
: venue
)
};

case actionTypes.UPDATE_VENUE_DATA:
return {
...state,
venues: state.venues.map(venue => ({
...venue,
crowdLevel: Math.max(0, Math.min(100, venue.crowdLevel + (Math.random() - 0.5) * 20)),
waitTime: Math.max(0, venue.waitTime + Math.floor((Math.random() - 0.5) * 10)),
lastUpdate: 'Just now',
confidence: Math.max(70, Math.min(100, venue.confidence + (Math.random() - 0.5) * 10))
}))
};

case actionTypes.ADD_NOTIFICATION:
const newNotification = {
id: Date.now() + Math.random(),
timestamp: Date.now(),
...action.payload
};
return {
...state,
notifications: [newNotification, ...state.notifications.slice(0, 4)]
};

case actionTypes.REMOVE_NOTIFICATION:
return {
...state,
notifications: state.notifications.filter(n => n.id !== action.payload)
};

case actionTypes.SET_SHOW_RATING_MODAL:
return { ...state, showRatingModal: action.payload };

case actionTypes.SET_SHOW_REPORT_MODAL:
return { ...state, showReportModal: action.payload };

case actionTypes.SET_SHOW_SHARE_MODAL:
return { ...state, showShareModal: action.payload };

case actionTypes.SET_SHOW_USER_PROFILE_MODAL:
return { ...state, showUserProfileModal: action.payload };

case actionTypes.SET_SHARE_VENUE:
return { ...state, shareVenue: action.payload };

case actionTypes.SUBMIT_VENUE_RATING:
return {
...state,
venues: state.venues.map(venue =>
venue.id === action.payload.venueId
? {
...venue,
rating: ((venue.rating * venue.totalRatings) + action.payload.rating) / (venue.totalRatings + 1),
totalRatings: venue.totalRatings + 1,
reviews: [
{
id: `rev_${Date.now()}`,
user: state.userProfile?.firstName + ' ' + (state.userProfile?.lastName?.charAt(0) || '') + '.',
rating: action.payload.rating,
date: 'Just now',
comment: action.payload.comment,
helpful: 0
},
...venue.reviews
]
}
: venue
),
showRatingModal: false
};

case actionTypes.SUBMIT_VENUE_REPORT:
return {
...state,
venues: state.venues.map(venue =>
venue.id === action.payload.venueId
? {
...venue,
crowdLevel: action.payload.crowdLevel,
waitTime: action.payload.waitTime,
lastUpdate: 'Just now',
confidence: 95,
reports: venue.reports + 1
}
: venue
),
showReportModal: false
};

// Registration actions
case actionTypes.SET_REGISTRATION_STEP:
return { ...state, registrationStep: action.payload };

case actionTypes.UPDATE_REGISTRATION_DATA:
return {
...state,
registrationData: { ...state.registrationData, ...action.payload }
};

case actionTypes.CLEAR_REGISTRATION_DATA:
return {
...state,
registrationData: {},
registrationStep: 1
};

// Email verification actions
case actionTypes.SET_VERIFICATION_MESSAGE:
return {
...state,
verificationMessage: action.payload
};

case actionTypes.CLEAR_VERIFICATION_MESSAGE:
return {
...state,
verificationMessage: {
show: false,
email: '',
type: ''
}
};

default:
return state;
}
}

// Context Provider
export function AppProvider({ children }) {
const [state, dispatch] = useReducer(appReducer, initialState);

// Action creators
const actions = {
setCurrentView: useCallback((view) => {
dispatch({ type: actionTypes.SET_CURRENT_VIEW, payload: view });
}, []),

setSearchQuery: useCallback((query) => {
dispatch({ type: actionTypes.SET_SEARCH_QUERY, payload: query });
}, []),

setUserType: useCallback((userType) => {
dispatch({ type: actionTypes.SET_USER_TYPE, payload: userType });
}, []),

loginUser: useCallback((userData) => {
dispatch({ type: actionTypes.LOGIN_USER, payload: userData });
}, []),

logoutUser: useCallback(() => {
dispatch({ type: actionTypes.LOGOUT_USER });
}, []),

setSelectedVenue: useCallback((venue) => {
dispatch({ type: actionTypes.SET_SELECTED_VENUE, payload: venue });
}, []),

toggleVenueFollow: useCallback((venueId) => {
dispatch({ type: actionTypes.TOGGLE_VENUE_FOLLOW, payload: venueId });
}, []),

updateVenueData: useCallback(() => {
dispatch({ type: actionTypes.UPDATE_VENUE_DATA });
}, []),

addNotification: useCallback((notification) => {
dispatch({ type: actionTypes.ADD_NOTIFICATION, payload: notification });

// Auto-remove notification after duration
if (notification.duration) {
setTimeout(() => {
dispatch({ type: actionTypes.REMOVE_NOTIFICATION, payload: notification.id });
}, notification.duration);
}
}, []),

removeNotification: useCallback((id) => {
dispatch({ type: actionTypes.REMOVE_NOTIFICATION, payload: id });
}, []),

setShowRatingModal: useCallback((show) => {
dispatch({ type: actionTypes.SET_SHOW_RATING_MODAL, payload: show });
}, []),

setShowReportModal: useCallback((show) => {
dispatch({ type: actionTypes.SET_SHOW_REPORT_MODAL, payload: show });
}, []),

setShowShareModal: useCallback((show) => {
dispatch({ type: actionTypes.SET_SHOW_SHARE_MODAL, payload: show });
}, []),

setShowUserProfileModal: useCallback((show) => {
dispatch({ type: actionTypes.SET_SHOW_USER_PROFILE_MODAL, payload: show });
}, []),

setShareVenue: useCallback((venue) => {
dispatch({ type: actionTypes.SET_SHARE_VENUE, payload: venue });
}, []),

submitVenueRating: useCallback((venueId, rating, comment) => {
dispatch({
type: actionTypes.SUBMIT_VENUE_RATING,
payload: { venueId, rating, comment }
});
}, []),

submitVenueReport: useCallback((venueId, crowdLevel, waitTime) => {
dispatch({
type: actionTypes.SUBMIT_VENUE_REPORT,
payload: { venueId, crowdLevel, waitTime }
});
}, []),

// Registration actions
setRegistrationStep: useCallback((step) => {
dispatch({ type: actionTypes.SET_REGISTRATION_STEP, payload: step });
}, []),

updateRegistrationData: useCallback((data) => {
dispatch({ type: actionTypes.UPDATE_REGISTRATION_DATA, payload: data });
}, []),

clearRegistrationData: useCallback(() => {
dispatch({ type: actionTypes.CLEAR_REGISTRATION_DATA });
}, []),

// Email verification actions
setVerificationMessage: useCallback((message) => {
dispatch({ type: actionTypes.SET_VERIFICATION_MESSAGE, payload: message });
}, []),

clearVerificationMessage: useCallback(() => {
dispatch({ type: actionTypes.CLEAR_VERIFICATION_MESSAGE });
}, [])
};

return (
<AppContext.Provider value={{ state, actions }}>
{children}
</AppContext.Provider>
);
}

// Custom hook to use the context
export function useApp() {
const context = useContext(AppContext);
if (!context) {
throw new Error('useApp must be used within an AppProvider');
}
return context;
}
EOF

echo "🔄 Updating App.jsx to handle email verification flow..."

# 7. Update App.jsx to include email verification route
cat > src/App.jsx << 'EOF'
import React, { useState, useEffect } from 'react';
import { AppProvider, useApp } from './context/AppContext';
import { useVenues } from './hooks/useVenues';

// Views
import LoginView from './components/Views/LoginView';
import HomeView from './components/Views/HomeView';
import VenueDetailsView from './components/Views/VenueDetailsView';
import RegistrationView from './components/Registration/RegistrationView';
import EmailVerificationView from './components/Auth/EmailVerificationView';

// Components
import Header from './components/Header';
import Notifications from './components/Notifications';

// Modals
import RatingModal from './components/Modals/RatingModal';
import ReportModal from './components/Modals/ReportModal';
import ShareModal from './components/Modals/ShareModal';
import UserProfileModal from './components/User/UserProfileModal';

import './App.css';

function AppContent() {
const { state, actions } = useApp();
const { updateVenueData } = useVenues();
const [searchQuery, setSearchQuery] = useState('');
const [isMobile, setIsMobile] = useState(false);

// Mobile detection
useEffect(() => {
const checkMobile = () => {
const mobile = window.innerWidth <= 768 ||
/Android|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
setIsMobile(mobile);
};

checkMobile();
window.addEventListener('resize', checkMobile);
return () => window.removeEventListener('resize', checkMobile);
}, []);

// Handle email verification from URL
useEffect(() => {
const urlParams = new URLSearchParams(window.location.search);
const verificationToken = urlParams.get('token');
const verifyEmail = urlParams.get('verify');

if (verificationToken && verifyEmail) {
actions.setCurrentView('email-verification');
// Clean up URL
window.history.replaceState({}, document.title, window.location.pathname);
}
}, [actions]);

// Update search query in context
useEffect(() => {
actions.setSearchQuery(searchQuery);
}, [searchQuery, actions]);

// Auto-update venue data periodically when authenticated
useEffect(() => {
if (state.isAuthenticated && !['login', 'register', 'email-verification'].includes(state.currentView)) {
const interval = setInterval(() => {
updateVenueData();
}, 45000);

return () => clearInterval(interval);
}
}, [updateVenueData, state.currentView, state.isAuthenticated]);

// Initialize app to login view if not authenticated
useEffect(() => {
if (!state.isAuthenticated && !['login', 'register', 'email-verification'].includes(state.currentView)) {
actions.setCurrentView('login');
}
}, [state.isAuthenticated, state.currentView, actions]);

const handleShowRegistration = () => {
actions.setCurrentView('register');
};

const handleBackToLogin = () => {
actions.setCurrentView('login');
};

const handleRegistrationSuccess = (userData) => {
// Registration success should redirect to login with verification message
actions.setCurrentView('login');
};

const handleEmailVerificationSuccess = () => {
actions.setCurrentView('login');
actions.clearVerificationMessage();
};

const handleVenueSelect = (venue) => {
actions.setSelectedVenue(venue);
actions.setCurrentView('details');
};

const handleBackToHome = () => {
actions.setCurrentView('home');
actions.setSelectedVenue(null);
};

const handleClearSearch = () => {
setSearchQuery('');
};

// Get verification token and email from URL or localStorage
const getVerificationData = () => {
const urlParams = new URLSearchParams(window.location.search);
const token = urlParams.get('token');
const email = urlParams.get('email') || localStorage.getItem('pending_verification_email');
return { token, email };
};

// Determine if header should be shown (not on login, register, or verification pages)
const showHeader = !['login', 'register', 'email-verification'].includes(state.currentView);

return (
<div className={`app ${isMobile ? 'mobile' : 'desktop'}`}>
{/* Header */}
{showHeader && (
<Header
searchQuery={searchQuery}
setSearchQuery={setSearchQuery}
onClearSearch={handleClearSearch}
isMobile={isMobile}
/>
)}

{/* Main Content */}
<main className={`main-content ${isMobile ? 'mobile-main' : ''}`}>
{state.currentView === 'login' && (
<LoginView onRegister={handleShowRegistration} />
)}

{state.currentView === 'register' && (
<RegistrationView
onBack={handleBackToLogin}
onSuccess={handleRegistrationSuccess}
/>
)}

{state.currentView === 'email-verification' && (
<EmailVerificationView
onBack={handleBackToLogin}
onSuccess={handleEmailVerificationSuccess}
token={getVerificationData().token}
email={getVerificationData().email}
/>
)}

{state.currentView === 'home' && (
<HomeView onVenueSelect={handleVenueSelect} />
)}

{state.currentView === 'details' && (
<VenueDetailsView onBack={handleBackToHome} />
)}
</main>

{/* Modals */}
<RatingModal />
<ReportModal />
<ShareModal />
<UserProfileModal />

{/* Notifications */}
<Notifications />
</div>
);
}

function App() {
return (
<AppProvider>
<AppContent />
</AppProvider>
);
}

export default App;
EOF

echo "🎨 Adding email verification styling..."

# 8. Add Email Verification CSS Styles
cat >> src/App.css << 'EOF'

/* ============================================= */
/* EMAIL VERIFICATION STYLES */
/* ============================================= */

/* Verification Page Layout */
.verification-page {
min-height: 100vh;
position: relative;
overflow-x: hidden;
background: #0f172a;
}

.verification-background {
position: fixed;
top: 0;
left: 0;
right: 0;
bottom: 0;
z-index: 0;
}

.verification-gradient {
position: absolute;
top: 0;
left: 0;
right: 0;
bottom: 0;
background: linear-gradient(135deg,
#0f172a 0%,
#1e293b 25%,
#334155 50%,
#475569 75%,
#64748b 100%);
}

.verification-container {
position: relative;
z-index: 1;
min-height: 100vh;
display: flex;
flex-direction: column;
max-width: 500px;
margin: 0 auto;
padding: 20px;
}

/* Verification Header */
.verification-header {
display: flex;
align-items: center;
gap: 16px;
margin-bottom: 32px;
padding-top: 20px;
}

.verification-back-button {
width: 48px;
height: 48px;
border-radius: 16px;
background: rgba(255, 255, 255, 0.1);
border: 1px solid rgba(255, 255, 255, 0.2);
color: white;
display: flex;
align-items: center;
justify-content: center;
cursor: pointer;
transition: all 0.2s ease;
backdrop-filter: blur(10px);
flex-shrink: 0;
}

.verification-back-button:hover {
background: rgba(255, 255, 255, 0.2);
transform: translateY(-1px);
}

.verification-brand {
flex: 1;
}

.verification-page-title {
font-size: 1.75rem;
font-weight: 800;
color: white;
margin: 0 0 4px 0;
line-height: 1.1;
}

.verification-page-subtitle {
color: rgba(255, 255, 255, 0.7);
font-size: 0.875rem;
margin: 0;
line-height: 1.4;
}

/* Verification Card */
.verification-card {
flex: 1;
background: white;
border-radius: 24px;
padding: 48px 32px;
box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
display: flex;
align-items: center;
justify-content: center;
min-height: 400px;
}

.verification-content {
text-align: center;
max-width: 400px;
width: 100%;
}

.verification-icon {
margin: 0 auto 24px auto;
display: flex;
align-items: center;
justify-content: center;
}

.verification-icon.verifying {
padding: 16px;
}

.verification-icon.success {
padding: 16px;
}

.verification-icon.error {
padding: 16px;
}

.verification-title {
font-size: 1.5rem;
font-weight: 700;
color: #1e293b;
margin: 0 0 12px 0;
line-height: 1.2;
}

.verification-description {
color: #64748b;
font-size: 1rem;
margin: 0 0 32px 0;
line-height: 1.5;
}

.verification-button {
display: inline-flex;
align-items: center;
gap: 8px;
padding: 14px 24px;
border-radius: 12px;
font-weight: 600;
font-size: 0.875rem;
cursor: pointer;
transition: all 0.2s ease;
border: none;
min-width: 140px;
justify-content: center;
}

.verification-button.primary {
background: var(--gradient-primary);
color: white;
}

.verification-button.primary:hover:not(:disabled) {
transform: translateY(-1px);
box-shadow: 0 8px 20px rgba(59, 130, 246, 0.3);
}

.verification-button:disabled {
opacity: 0.6;
cursor: not-allowed;
transform: none;
}

/* Login Verification Banner */
.verification-banner {
background: linear-gradient(135deg, #dbeafe 0%, #e0f2fe 100%);
border: 1px solid #bfdbfe;
border-radius: 16px;
padding: 20px;
margin-bottom: 24px;
display: flex;
align-items: flex-start;
gap: 16px;
}

.verification-banner .verification-content {
flex: 1;
text-align: left;
}

.verification-banner .verification-icon {
margin: 0;
flex-shrink: 0;
padding: 8px;
background: white;
border-radius: 12px;
border: 1px solid #bfdbfe;
}

.verification-banner .verification-title {
font-size: 1rem;
font-weight: 600;
color: #1e40af;
margin: 0 0 4px 0;
}

.verification-banner .verification-description {
font-size: 0.875rem;
color: #1e40af;
margin: 0;
}

.resend-button {
display: flex;
align-items: center;
gap: 6px;
padding: 8px 16px;
background: #3b82f6;
color: white;
border: none;
border-radius: 8px;
font-size: 0.75rem;
font-weight: 600;
cursor: pointer;
transition: all 0.2s ease;
flex-shrink: 0;
min-width: 70px;
justify-content: center;
}

.resend-button:hover:not(:disabled) {
background: #2563eb;
transform: translateY(-1px);
}

.resend-button:disabled {
background: #9ca3af;
cursor: not-allowed;
transform: none;
}

/* Mobile Responsiveness */
@media (max-width: 768px) {
.verification-container {
padding: 16px;
}

.verification-card {
padding: 32px 24px;
min-height: 350px;
}

.verification-title {
font-size: 1.25rem;
}

.verification-page-title {
font-size: 1.5rem;
}

.verification-banner {
flex-direction: column;
gap: 12px;
}

.verification-banner .verification-content {
text-align: center;
}

.resend-button {
align-self: center;
}
}

@media (max-width: 480px) {
.verification-container {
padding: 12px;
}

.verification-card {
padding: 24px 20px;
}

.verification-header {
margin-bottom: 24px;
}
}

/* Accessibility improvements */
@media (prefers-reduced-motion: reduce) {
.verification-button,
.verification-back-button,
.resend-button {
transition: none;
}
}

/* Focus indicators for keyboard navigation */
.verification-button:focus,
.verification-back-button:focus,
.resend-button:focus {
outline: 2px solid #3b82f6;
outline-offset: 2px;
}

EOF

echo ""
echo "✅ Email Verification Implementation Complete (No Availability Check)!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📧 Email Verification Features Implemented:"
echo "  ✅ Registration redirects to login with verification message"
echo "  ✅ Login blocks unverified users with clear messaging"
echo "  ✅ Email verification link handling (?token=xxx&verify=email)"
echo "  ✅ Resend verification email functionality with cooldown"
echo "  ✅ Dedicated email verification page"
echo "  ✅ API integration for verification endpoints"
echo "  ✅ NO username/email availability checking (removed)"
echo "  ✅ Preserved all existing design and functionality"
echo ""
echo "🔧 API Endpoints Configured:"
echo "  ✅ POST /api/auth/register - User registration"
echo "  ✅ POST /api/auth/login - User authentication with email verification check"
echo "  ✅ POST /api/auth/verify-email - Email verification with token"
echo "  ✅ POST /api/auth/resend-verification - Resend verification email"
echo "  ❌ No username/email availability endpoints (removed)"
echo ""
echo "🎯 User Flow:"
echo "  1. User completes registration → redirected to login"
echo "  2. Login shows verification banner with user's email"
echo "  3. User receives verification email with link"
echo "  4. Clicking link opens verification page"
echo "  5. Successful verification → redirected to login"
echo "  6. User can now login successfully"
echo ""
echo "🚫 Login Restrictions:"
echo "  ✅ Unverified users cannot login"
echo "  ✅ Clear error message: 'Please verify your email before signing in'"
echo "  ✅ Resend verification option with 60-second cooldown"
echo "  ✅ Demo account bypasses verification for testing"
echo ""
echo "📝 Registration Changes:"
echo "  ❌ Removed real-time username availability checking"
echo "  ❌ Removed real-time email availability checking"
echo "  ❌ Removed green checkmark indicators for availability"
echo "  ✅ Standard form validation (length, format, etc.)"
echo "  ✅ Backend will handle duplicate username/email errors"
echo ""
echo "🎨 UI Features:"
echo "  ✅ Verification banner on login page after registration"
echo "  ✅ Resend email button with cooldown timer"
echo "  ✅ Dedicated verification page with status indicators"
echo "  ✅ Success/error states with appropriate icons"
echo "  ✅ Mobile-responsive design"
echo "  ❌ No real-time availability indicators"
echo ""
echo "📱 Email Verification Page States:"
echo "  🔄 Verifying - Shows loading spinner while checking token"
echo "  ✅ Success - Shows success icon, redirects to login"
echo "  ❌ Error - Shows error icon, offers resend option"
echo "  ⏰ Expired - Shows expired message, offers new verification"
echo ""
echo "🔒 Security Features:"
echo "  ✅ Token-based email verification"
echo "  ✅ Expired token handling"
echo "  ✅ Rate limiting for resend requests (60-second cooldown)"
echo "  ✅ Clear separation between verified and unverified users"
echo ""
echo "🧪 Testing the Email Verification Flow:"
echo "  1. Start app: npm run dev"
echo "  2. Register new account → redirected to login with banner"
echo "  3. Try to login → blocked with verification message"
echo "  4. Test resend verification (60s cooldown)"
echo "  5. Simulate email link: add ?token=test123&verify=email to URL"
echo "  6. Test verification success/error states"
echo ""
echo "⚙️ Configuration:"
echo "  • API Base URL: https://system.nytevibe.com/api"
echo "  • Verification endpoints configured"
echo "  • Email stored in localStorage for resend"
echo "  • URL parameter parsing for verification links"
echo ""
echo "🎯 Backend Requirements:"
echo "  1. POST /api/auth/register - Should NOT check username/email uniqueness"
echo "  2. Handle duplicate errors in registration response (422 status)"
echo "  3. POST /api/auth/verify-email - Email verification endpoint"
echo "  4. POST /api/auth/resend-verification - Resend verification endpoint"
echo "  5. Add email_verified field to login response"
echo "  6. Send verification emails after registration"
echo ""
echo "Status: 🟢 EMAIL VERIFICATION READY (NO AVAILABILITY CHECK)"
