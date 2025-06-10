#!/bin/bash

# nYtevibe Registration Error Handling Fix
# Fixes the backend validation error mapping and display

echo "🔧 Fixing Registration Error Handling"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔄 Updating error handling for 422 validation responses..."
echo ""

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    echo "❌ Error: package.json not found. Please run this script from your React project directory."
    exit 1
fi

# Create backup
echo "💾 Creating backup..."
cp src/components/Registration/RegistrationView.jsx src/components/Registration/RegistrationView.jsx.backup-error-fix

echo "🔧 Updating RegistrationView error handling..."

# Update RegistrationView with better error handling
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
    Globe,
    AlertCircle
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
    
    // Validation state
    const [validation, setValidation] = useState({});
    const [availability, setAvailability] = useState({
        username: null,
        email: null,
        checking: {
            username: false,
            email: false
        }
    });
    
    // UI state
    const [showPassword, setShowPassword] = useState(false);
    const [showPasswordConfirm, setShowPasswordConfirm] = useState(false);
    const [generalError, setGeneralError] = useState('');
    
    // Real-time validation debounced functions
    const debouncedUsernameCheck = useCallback(
        debounce(async (username) => {
            if (username && username.length >= 3) {
                try {
                    setAvailability(prev => ({ 
                        ...prev, 
                        checking: { ...prev.checking, username: true } 
                    }));
                    
                    const available = await registrationAPI.checkUsernameAvailability(username);
                    setAvailability(prev => ({ 
                        ...prev, 
                        username: available,
                        checking: { ...prev.checking, username: false }
                    }));
                } catch (error) {
                    console.warn('Username availability check failed:', error);
                    setAvailability(prev => ({ 
                        ...prev, 
                        checking: { ...prev.checking, username: false }
                    }));
                }
            }
        }, 500),
        []
    );
    
    const debouncedEmailCheck = useCallback(
        debounce(async (email) => {
            if (email && validateEmail(email).isValid) {
                try {
                    setAvailability(prev => ({ 
                        ...prev, 
                        checking: { ...prev.checking, email: true } 
                    }));
                    
                    const available = await registrationAPI.checkEmailAvailability(email);
                    setAvailability(prev => ({ 
                        ...prev, 
                        email: available,
                        checking: { ...prev.checking, email: false }
                    }));
                } catch (error) {
                    console.warn('Email availability check failed:', error);
                    setAvailability(prev => ({ 
                        ...prev, 
                        checking: { ...prev.checking, email: false }
                    }));
                }
            }
        }, 500),
        []
    );
    
    // Handle form data changes
    const handleInputChange = (field, value) => {
        setFormData(prev => ({ ...prev, [field]: value }));
        
        // Clear validation for this field
        setValidation(prev => ({ ...prev, [field]: null }));
        setGeneralError('');
        
        // Reset availability when field changes
        if (field === 'username') {
            setAvailability(prev => ({ ...prev, username: null }));
            debouncedUsernameCheck(value);
        }
        
        if (field === 'email') {
            setAvailability(prev => ({ ...prev, email: null }));
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
                } else if (availability.username === false) {
                    errors.username = ['This username is already taken'];
                }
                
                const emailValidation = validateEmail(formData.email);
                if (!emailValidation.isValid) {
                    errors.email = emailValidation.errors;
                } else if (availability.email === false) {
                    errors.email = ['An account with this email already exists'];
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
        setGeneralError('');
        setValidation({});
    };
    
    // Map backend validation errors to frontend fields
    const mapBackendErrors = (backendErrors) => {
        const mappedErrors = {};
        
        // Direct field mappings
        const fieldMappings = {
            'username': 'username',
            'email': 'email', 
            'password': 'password',
            'password_confirmation': 'passwordConfirmation',
            'first_name': 'firstName',
            'last_name': 'lastName',
            'date_of_birth': 'dateOfBirth',
            'phone': 'phone',
            'country': 'country',
            'state': 'state',
            'city': 'city',
            'zipcode': 'zipcode'
        };
        
        Object.entries(backendErrors).forEach(([backendField, messages]) => {
            const frontendField = fieldMappings[backendField] || backendField;
            mappedErrors[frontendField] = Array.isArray(messages) ? messages : [messages];
        });
        
        return mappedErrors;
    };
    
    // Navigate to appropriate step based on error
    const navigateToErrorStep = (errors) => {
        if (errors.username || errors.email) {
            setCurrentStep(2);
        } else if (errors.password || errors.passwordConfirmation) {
            setCurrentStep(3);
        } else if (errors.firstName || errors.lastName || errors.dateOfBirth || errors.phone) {
            setCurrentStep(4);
        } else if (errors.country || errors.state || errors.city || errors.zipcode) {
            setCurrentStep(5);
        }
    };
    
    // Handle registration submission
    const handleRegistration = async () => {
        if (!validateCurrentStep()) {
            return;
        }
        
        setIsLoading(true);
        setGeneralError('');
        setValidation({});
        
        try {
            const registrationData = prepareRegistrationData(formData);
            console.log('Sending registration data:', registrationData);
            
            const response = await registrationAPI.register(registrationData);
            
            if (response.status === 'success') {
                // Store authentication token
                localStorage.setItem('auth_token', response.data.token);
                
                // Update app state
                actions.loginUser(response.data.user);
                
                // Show success notification
                actions.addNotification({
                    type: 'success',
                    message: `🎉 Welcome to nYtevibe, ${response.data.user.first_name}!`,
                    important: true,
                    duration: 4000
                });
                
                // Call success callback
                onSuccess && onSuccess(response.data.user);
            }
        } catch (error) {
            console.error('Registration failed:', error);
            
            if (error instanceof APIError) {
                if (error.status === 422) {
                    // Map backend validation errors to frontend
                    const mappedErrors = mapBackendErrors(error.errors);
                    setValidation(mappedErrors);
                    
                    // Navigate to the step with errors
                    navigateToErrorStep(mappedErrors);
                    
                    // Show general error message
                    setGeneralError('Please check the form for errors and try again.');
                    
                    actions.addNotification({
                        type: 'error',
                        message: 'Registration failed. Please check the form for errors.',
                        duration: 4000
                    });
                } else if (error.status === 429) {
                    setGeneralError('Too many registration attempts. Please try again later.');
                    actions.addNotification({
                        type: 'error',
                        message: 'Too many registration attempts. Please try again later.',
                        duration: 5000
                    });
                } else if (error.status === 500) {
                    setGeneralError('Server error occurred. Please try again later.');
                    actions.addNotification({
                        type: 'error',
                        message: 'Server error. Please try again later.',
                        duration: 4000
                    });
                } else {
                    setGeneralError('Registration failed. Please try again.');
                    actions.addNotification({
                        type: 'error',
                        message: 'Registration failed. Please try again.',
                        duration: 4000
                    });
                }
            } else {
                setGeneralError('Network error. Please check your connection and try again.');
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
                
                {/* General Error Message */}
                {generalError && (
                    <div className="general-error">
                        <AlertCircle className="error-icon" />
                        <span>{generalError}</span>
                    </div>
                )}
                
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
                            disabled={isLoading || availability.checking.username || availability.checking.email}
                        >
                            {availability.checking.username || availability.checking.email ? (
                                <>
                                    <div className="loading-spinner"></div>
                                    Checking...
                                </>
                            ) : (
                                'Continue'
                            )}
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

// Step Components (same as before, but with enhanced error display)
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
                            className={`form-input ${validation.username ? 'error' : ''} ${availability.username === true ? 'success' : ''}`}
                            placeholder="Choose your username"
                        />
                        {availability.checking?.username && (
                            <div className="checking-spinner">
                                <div className="loading-spinner"></div>
                            </div>
                        )}
                        {availability.username === true && !availability.checking?.username && (
                            <Check className="validation-icon success" />
                        )}
                        {availability.username === false && !availability.checking?.username && (
                            <X className="validation-icon error" />
                        )}
                    </div>
                    {validation.username && (
                        <div className="field-errors">
                            {validation.username.map((error, idx) => (
                                <span key={idx} className="error-message">{error}</span>
                            ))}
                        </div>
                    )}
                    {availability.username === true && !availability.checking?.username && (
                        <span className="success-message">Username is available!</span>
                    )}
                    {availability.username === false && !availability.checking?.username && (
                        <span className="error-message">Username is already taken</span>
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
                            className={`form-input ${validation.email ? 'error' : ''} ${availability.email === true ? 'success' : ''}`}
                            placeholder="Enter your email"
                        />
                        {availability.checking?.email && (
                            <div className="checking-spinner">
                                <div className="loading-spinner"></div>
                            </div>
                        )}
                        {availability.email === true && !availability.checking?.email && (
                            <Check className="validation-icon success" />
                        )}
                        {availability.email === false && !availability.checking?.email && (
                            <X className="validation-icon error" />
                        )}
                    </div>
                    {validation.email && (
                        <div className="field-errors">
                            {validation.email.map((error, idx) => (
                                <span key={idx} className="error-message">{error}</span>
                            ))}
                        </div>
                    )}
                    {availability.email === true && !availability.checking?.email && (
                        <span className="success-message">Email is available!</span>
                    )}
                    {availability.email === false && !availability.checking?.email && (
                        <span className="error-message">This email is already registered</span>
                    )}
                </div>
            </div>
        </div>
    </div>
);

// ... (rest of the step components remain the same)
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

echo "🎨 Adding general error styling..."

# Add CSS for general error display
cat >> src/App.css << 'EOF'

/* General Error Display */
.general-error {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 16px;
    background: rgba(239, 68, 68, 0.1);
    border: 1px solid rgba(239, 68, 68, 0.3);
    border-radius: 12px;
    color: #dc2626;
    font-weight: 500;
    margin-bottom: 24px;
    font-size: 0.875rem;
}

.general-error .error-icon {
    width: 20px;
    height: 20px;
    flex-shrink: 0;
}

/* Checking spinner for availability */
.checking-spinner {
    position: absolute;
    right: 16px;
    width: 18px;
    height: 18px;
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 1;
}

.checking-spinner .loading-spinner {
    width: 16px;
    height: 16px;
    border-width: 2px;
}

/* Enhanced error messages */
.field-errors {
    display: flex;
    flex-direction: column;
    gap: 4px;
    margin-top: 8px;
}

.error-message {
    color: #ef4444;
    font-size: 0.875rem;
    font-weight: 500;
    display: flex;
    align-items: center;
    gap: 6px;
}

.error-message::before {
    content: "⚠️";
    font-size: 0.75rem;
}

/* Success message enhancement */
.success-message::before {
    content: "✓";
    font-weight: 700;
    color: #10b981;
}

EOF

echo ""
echo "✅ Registration Error Handling Fix Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🔧 Error Handling Improvements:"
echo " ✅ Proper backend validation error mapping"
echo " ✅ Auto-navigation to step with errors"
echo " ✅ Enhanced visual error feedback"
echo " ✅ General error message display"
echo " ✅ Loading states for availability checking"
echo " ✅ Better error message formatting"
echo ""
echo "🎯 Now handles these specific errors:"
echo " • 422 - Username already taken"
echo " • 422 - Email already registered"
echo " • 422 - All other validation errors"
echo " • 429 - Rate limiting"
echo " • 500 - Server errors"
echo " • Network errors"
echo ""
echo "🧪 Test with fresh data:"
echo "Try registering with:"
echo " • Username: newuser$(date +%s)"
echo " • Email: test$(date +%s)@example.com"
echo " • Password: TestPass123!"
echo ""
echo "🚀 To test the fixes:"
echo " npm run dev"
echo " Try registration with different username/email"
echo " Check that errors display properly"
echo ""
echo "Status: 🟢 ERROR HANDLING FIXED"
