import React, { useState, useEffect, useCallback, useRef } from 'react';
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
import './availability.css';

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

// Real-time availability state
const [availabilityStatus, setAvailabilityStatus] = useState({
username: { checking: false, available: null, message: '', suggestions: [] },
email: { checking: false, available: null, message: '' }
});

// UI state
const [showPassword, setShowPassword] = useState(false);
const [showPasswordConfirm, setShowPasswordConfirm] = useState(false);

// Debounce refs
const debounceTimeouts = useRef({});

// Debounced availability checking
const checkAvailability = useCallback(async (field, value) => {
  if (!value || value.trim().length < 3) {
    setAvailabilityStatus(prev => ({
      ...prev,
      [field]: { checking: false, available: null, message: '', suggestions: [] }
    }));
    return;
  }

  // Clear existing timeout
  if (debounceTimeouts.current[field]) {
    clearTimeout(debounceTimeouts.current[field]);
  }

  // Set checking state
  setAvailabilityStatus(prev => ({
    ...prev,
    [field]: { ...prev[field], checking: true, message: 'Checking availability...' }
  }));

  // Debounce the actual check
  debounceTimeouts.current[field] = setTimeout(async () => {
    try {
      let result;
      if (field === 'username') {
        result = await registrationAPI.checkUsernameAvailability(value);
      } else if (field === 'email') {
        result = await registrationAPI.checkEmailAvailability(value);
      }

      setAvailabilityStatus(prev => ({
        ...prev,
        [field]: {
          checking: false,
          available: result.available,
          message: result.message,
          suggestions: result.suggestions || []
        }
      }));
    } catch (error) {
      console.error(`${field} availability check failed:`, error);
      setAvailabilityStatus(prev => ({
        ...prev,
        [field]: {
          checking: false,
          available: null,
          message: 'Unable to check availability',
          suggestions: []
        }
      }));
    }
  }, 500);
}, []);

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

// Trigger real-time availability checking for username/email
if (field === 'username' || field === 'email') {
  checkAvailability(field, value);
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
// API handles field mapping
const response = await registrationAPI.register(formData);

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
availabilityStatus={availabilityStatus}
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

const CredentialsStep = ({ formData, onChange, validation, availabilityStatus }) => (
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
{availabilityStatus.username.checking && (
<div className="availability-indicator checking">
<div className="loading-spinner-sm"></div>
</div>
)}
{!availabilityStatus.username.checking && availabilityStatus.username.available === true && (
<Check className="availability-indicator success" />
)}
{!availabilityStatus.username.checking && availabilityStatus.username.available === false && (
<X className="availability-indicator error" />
)}
</div>

{validation.username && (
<div className="field-errors">
{validation.username.map((error, idx) => (
<span key={idx} className="error-message">{error}</span>
))}
</div>
)}

{availabilityStatus.username.message && (
<div className={`availability-status ${
availabilityStatus.username.checking ? 'checking' : 
availabilityStatus.username.available ? 'success' : 'error'
}`}>
{availabilityStatus.username.message}
</div>
)}

{availabilityStatus.username.suggestions && availabilityStatus.username.suggestions.length > 0 && (
<div className="username-suggestions">
<div style={{fontSize: '0.75rem', color: '#6b7280', marginBottom: '4px'}}>
Try these instead:
</div>
{availabilityStatus.username.suggestions.map((suggestion, idx) => (
<button
key={idx}
type="button"
className="suggestion-button"
onClick={() => onChange('username', suggestion)}
>
{suggestion}
</button>
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
{availabilityStatus.email.checking && (
<div className="availability-indicator checking">
<div className="loading-spinner-sm"></div>
</div>
)}
{!availabilityStatus.email.checking && availabilityStatus.email.available === true && (
<Check className="availability-indicator success" />
)}
{!availabilityStatus.email.checking && availabilityStatus.email.available === false && (
<X className="availability-indicator error" />
)}
</div>

{validation.email && (
<div className="field-errors">
{validation.email.map((error, idx) => (
<span key={idx} className="error-message">{error}</span>
))}
</div>
)}

{availabilityStatus.email.message && (
<div className={`availability-status ${
availabilityStatus.email.checking ? 'checking' : 
availabilityStatus.email.available ? 'success' : 'error'
}`}>
{availabilityStatus.email.message}
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
