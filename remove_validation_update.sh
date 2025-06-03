#!/bin/bash

# Remove Field Validation Update Script
# Updates existing email verification implementation to remove field validity checks

echo "🔧 Remove Field Validation Update Script"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎯 Target: Remove field validation checks from email verification system"
echo "📂 Updating existing email_verification.sh implementation"
echo ""

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
echo "❌ Error: package.json not found. Please run this script from your React project directory."
exit 1
fi

# Check if email verification files exist
if [ ! -f "src/services/registrationAPI.js" ]; then
echo "❌ Error: Email verification implementation not found. Please run email_verification.sh first."
exit 1
fi

# Create backups for this update
echo "💾 Creating backups for validation removal..."
cp src/utils/registrationValidation.js src/utils/registrationValidation.js.backup-remove-validation
cp src/components/Registration/RegistrationView.jsx src/components/Registration/RegistrationView.jsx.backup-remove-validation

echo "🔧 Updating registration validation to remove field checks..."

# 1. Update registration validation utility to make all validations pass
cat > src/utils/registrationValidation.js << 'EOF'
/**
 * Registration Validation Utilities - Simplified (No Field Validation)
 * All validations return as valid to remove field checking
 */

// US and Canada location data (unchanged)
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

// Simplified validation functions - all return valid
export const validateUsername = (username) => {
return {
isValid: true,
errors: []
};
};

export const validateEmail = (email) => {
return {
isValid: true,
errors: []
};
};

export const validatePassword = (password) => {
// Keep password requirements for UI display but always return valid
const requirements = {
length: password && password.length >= 8,
uppercase: password && /[A-Z]/.test(password),
lowercase: password && /[a-z]/.test(password),
number: password && /\d/.test(password),
special: password && /[!@#$%^&*(),.?":{}|<>]/.test(password)
};

const strength = calculatePasswordStrength(requirements);

return {
isValid: true, // Always valid
errors: [],
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
return {
isValid: true,
errors: []
};
};

export const validatePersonalInfo = (data) => {
return {
isValid: true,
errors: {}
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

echo "🔧 Updating Registration View to remove validation logic..."

# 2. Update Registration View to skip validation
cat > src/components/Registration/RegistrationView.jsx << 'EOF'
import React, { useState, useEffect, useCallback } from 'react';
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
debounce,
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

// Validation state (kept for UI but not used for blocking)
const [validation, setValidation] = useState({});
const [availability, setAvailability] = useState({
username: true, // Always show as available
email: true      // Always show as available
});

// UI state
const [showPassword, setShowPassword] = useState(false);
const [showPasswordConfirm, setShowPasswordConfirm] = useState(false);

// Simplified availability checks - always return true
const debouncedUsernameCheck = useCallback(
debounce(async (username) => {
if (username && username.length >= 1) {
setAvailability(prev => ({ ...prev, username: true }));
}
}, 300),
[]
);

const debouncedEmailCheck = useCallback(
debounce(async (email) => {
if (email && email.length >= 1) {
setAvailability(prev => ({ ...prev, email: true }));
}
}, 300),
[]
);

// Handle form data changes
const handleInputChange = (field, value) => {
setFormData(prev => ({ ...prev, [field]: value }));

// Clear validation for this field
setValidation(prev => ({ ...prev, [field]: null }));

// Always show as available
if (field === 'username') {
setAvailability(prev => ({ ...prev, username: true }));
debouncedUsernameCheck(value);
}
if (field === 'email') {
setAvailability(prev => ({ ...prev, email: true }));
debouncedEmailCheck(value);
}

// Clear dependent location fields
if (field === 'country') {
setFormData(prev => ({ ...prev, state: '', city: '' }));
}
if (field === 'state') {
setFormData(prev => ({ ...prev, city: '' }));
}
};

// Validate current step - simplified to only check required fields are not empty
const validateCurrentStep = () => {
switch (currentStep) {
case 1: // Account Type
return true;

case 2: // Username & Email
return formData.username.trim() !== '' && formData.email.trim() !== '';

case 3: // Password
return formData.password !== '' && formData.passwordConfirmation !== '';

case 4: // Personal Info
return formData.firstName.trim() !== '' && formData.lastName.trim() !== '';

case 5: // Location
return true; // Location is optional

default:
return true;
}
};

// Handle step navigation
const handleNextStep = () => {
if (validateCurrentStep()) {
setCurrentStep(prev => Math.min(prev + 1, 5));
} else {
// Simple notification for empty required fields
actions.addNotification({
type: 'error',
message: 'Please fill in the required fields.',
duration: 3000
});
}
};

const handlePrevStep = () => {
setCurrentStep(prev => Math.max(prev - 1, 1));
};

// Handle registration submission
const handleRegistration = async () => {
if (!validateCurrentStep()) {
actions.addNotification({
type: 'error',
message: 'Please fill in the required fields.',
duration: 3000
});
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
// Validation errors from backend - show general message
actions.addNotification({
type: 'error',
message: 'Registration failed. Please check your information and try again.',
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
availability={availability}
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

// Step Components (unchanged except validation removed)
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

const CredentialsStep = ({ formData, onChange, validation, availability }) => (
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
className={`form-input ${availability.username === true ? 'success' : ''}`}
placeholder="Choose your username"
/>
{availability.username === true && formData.username && (
<Check className="validation-icon success" />
)}
</div>
{availability.username === true && formData.username && (
<span className="success-message">Username looks good!</span>
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
className={`form-input ${availability.email === true ? 'success' : ''}`}
placeholder="Enter your email"
/>
{availability.email === true && formData.email && (
<Check className="validation-icon success" />
)}
</div>
{availability.email === true && formData.email && (
<span className="success-message">Email looks good!</span>
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
className="form-input"
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
className={`form-input ${formData.passwordConfirmation && formData.password === formData.passwordConfirmation ? 'success' : ''}`}
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
className="form-input"
placeholder="Your first name"
/>
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
className="form-input"
placeholder="Your last name"
/>
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
className="form-input"
max={new Date(new Date().setFullYear(new Date().getFullYear() - 13)).toISOString().split('T')[0]}
/>
</div>
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
className="form-input"
placeholder="+1 (555) 123-4567"
/>
</div>
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

echo ""
echo "✅ Field Validation Removal Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🎯 Changes Made:"
echo "  ✅ Removed all field validation checks"
echo "  ✅ Username/email always show as available" 
echo "  ✅ Password requirements kept for UI but don't block registration"
echo "  ✅ Only checks that required fields are not empty"
echo "  ✅ Simplified error messages"
echo "  ✅ Preserved all existing design and functionality"
echo ""
echo "📋 Validation Changes:"
echo "  • validateUsername() → Always returns valid"
echo "  • validateEmail() → Always returns valid"
echo "  • validatePassword() → Always returns valid (UI preserved)"
echo "  • validatePasswordMatch() → Always returns valid"
echo "  • validatePersonalInfo() → Always returns valid"
echo ""
echo "🔄 Registration Flow Now:"
echo "  1. Fill any text in required fields"
echo "  2. Username/email always show green checkmarks"
echo "  3. Password strength indicator still works (visual only)"
echo "  4. Step navigation only checks fields are not empty"
echo "  5. Registration submits without field validation"
echo "  6. Backend validation errors show generic message"
echo ""
echo "⚠️  What's Preserved:"
echo "  ✅ Email verification flow unchanged"
echo "  ✅ All styling and design intact"
echo "  ✅ Password strength indicator (visual only)"
echo "  ✅ Real-time availability indicators (always green)"
echo "  ✅ All navigation and step logic"
echo "  ✅ API integration and error handling"
echo ""
echo "🚀 Testing the Updated Flow:"
echo "  npm run dev"
echo "  1. Enter any text in required fields"
echo "  2. See immediate green checkmarks"
echo "  3. Password requirements show but don't block"
echo "  4. Registration proceeds with minimal validation"
echo ""
echo "Status: 🟢 FIELD VALIDATION SUCCESSFULLY REMOVED"
