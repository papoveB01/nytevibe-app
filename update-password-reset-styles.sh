#!/bin/bash

# =============================================================================
# nYtevibe Password Reset Styling Update Script
# =============================================================================
# 
# This script updates the forgot password and reset password components
# with proper styling that matches the nYtevibe design theme.
#
# Version: 1.0
# Date: June 4, 2025
# Project: nYtevibe Houston Nightlife Discovery Platform
#
# =============================================================================

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Emojis for better UX
ROCKET="🚀"
CHECK="✅"
FOLDER="📁"
FILE="📄"
CODE="💻"
GEAR="⚙️"
STYLE="🎨"
BACKUP="💾"

# =============================================================================
# Helper Functions
# =============================================================================

print_header() {
    echo ""
    echo -e "${PURPLE}=============================================================================${NC}"
    echo -e "${PURPLE}  $1${NC}"
    echo -e "${PURPLE}=============================================================================${NC}"
    echo ""
}

print_step() {
    echo -e "${BLUE}${ROCKET} $1${NC}"
}

print_success() {
    echo -e "${GREEN}${CHECK} $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${CYAN}ℹ️  $1${NC}"
}

# =============================================================================
# Backup Functions
# =============================================================================

backup_file() {
    if [ -f "$1" ]; then
        cp "$1" "$1.backup-$(date +%Y%m%d-%H%M%S)"
        print_success "Backed up: $1"
    fi
}

# =============================================================================
# Project Validation
# =============================================================================

validate_project() {
    print_header "Project Validation ${GEAR}"
    
    # Check if we're in a React project
    if [ ! -f "package.json" ]; then
        print_error "package.json not found. Please run this script from your React project root."
        exit 1
    fi
    
    # Check required files exist
    if [ ! -f "src/components/Views/ForgotPasswordView.jsx" ]; then
        print_error "ForgotPasswordView.jsx not found. Please run the setup script first."
        exit 1
    fi
    
    if [ ! -f "src/components/Views/ResetPasswordView.jsx" ]; then
        print_error "ResetPasswordView.jsx not found. Please run the setup script first."
        exit 1
    fi
    
    if [ ! -f "src/App.css" ]; then
        print_warning "App.css not found. Creating new file."
        touch "src/App.css"
    fi
    
    print_success "Project validation complete"
}

# =============================================================================
# Component Updates
# =============================================================================

update_forgot_password_view() {
    print_step "Updating ForgotPasswordView with nYtevibe styling ${STYLE}"
    
    backup_file "src/components/Views/ForgotPasswordView.jsx"
    
    cat > "src/components/Views/ForgotPasswordView.jsx" << 'EOF'
/**
 * Styled Forgot Password View Component
 * Matches nYtevibe design theme and LoginView styling
 */

import React, { useState, useEffect } from 'react';
import { ArrowLeft, Mail, Zap, CheckCircle, Clock, AlertCircle } from 'lucide-react';
import authAPI from '../../services/authAPI';
import { 
  validateForgotPasswordForm, 
  sanitizeIdentifier, 
  getPasswordResetErrorMessage,
  maskEmail,
  formatRetryCountdown 
} from '../../utils/authUtils';

const ForgotPasswordView = ({ onBack, onSuccess }) => {
  // Form state
  const [identifier, setIdentifier] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [validationErrors, setValidationErrors] = useState({});

  // Success state
  const [emailSent, setEmailSent] = useState(false);
  const [maskedEmail, setMaskedEmail] = useState('');

  // Rate limiting state
  const [isRateLimited, setIsRateLimited] = useState(false);
  const [retryCountdown, setRetryCountdown] = useState(0);

  // Error state
  const [error, setError] = useState('');

  // Rate limiting countdown effect
  useEffect(() => {
    let interval = null;
    if (isRateLimited && retryCountdown > 0) {
      interval = setInterval(() => {
        setRetryCountdown(prev => {
          if (prev <= 1) {
            setIsRateLimited(false);
            return 0;
          }
          return prev - 1;
        });
      }, 1000);
    }
    return () => clearInterval(interval);
  }, [isRateLimited, retryCountdown]);

  // Clear errors when user types
  useEffect(() => {
    if (identifier) {
      setError('');
      setValidationErrors({});
    }
  }, [identifier]);

  const handleIdentifierChange = (e) => {
    setIdentifier(e.target.value);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    // Clear previous states
    setError('');
    setValidationErrors({});

    // Sanitize and validate input
    const sanitizedIdentifier = sanitizeIdentifier(identifier);
    const validation = validateForgotPasswordForm(sanitizedIdentifier);

    if (!validation.isValid) {
      setValidationErrors(validation.errors);
      return;
    }

    setIsLoading(true);

    try {
      const result = await authAPI.forgotPassword(sanitizedIdentifier);

      if (result.success) {
        setEmailSent(true);
        setMaskedEmail(result.data?.email || maskEmail(sanitizedIdentifier));
        setIdentifier(''); // Clear form
      } else {
        handleError(result);
      }
    } catch (error) {
      console.error('Forgot password error:', error);
      setError('An unexpected error occurred. Please try again.');
    } finally {
      setIsLoading(false);
    }
  };

  const handleError = (result) => {
    const { error, code, retryAfter } = result;

    switch (code) {
      case 'RATE_LIMIT_EXCEEDED':
        setIsRateLimited(true);
        setRetryCountdown(retryAfter || 60);
        break;
      
      default:
        setError(getPasswordResetErrorMessage(error, code, result.data));
        break;
    }
  };

  const handleRetry = () => {
    setError('');
    setValidationErrors({});
    setEmailSent(false);
    setMaskedEmail('');
  };

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
              <h2 className="login-title">Reset Your Password</h2>
              <p className="login-subtitle">Enter your email or username to receive a reset link</p>
            </div>
          </div>

          {/* Success Banner */}
          {emailSent && (
            <div className="success-banner">
              <div className="success-content">
                <CheckCircle className="w-6 h-6 text-green-500" />
                <div className="success-text">
                  <h4 className="success-title">Reset link sent!</h4>
                  <p className="success-description">
                    We've sent a password reset link to <strong>{maskedEmail}</strong>
                  </p>
                  <p className="success-note">
                    Check your email and follow the instructions. If you don't see it, check your spam folder.
                  </p>
                </div>
              </div>
              <button 
                onClick={handleRetry}
                className="retry-button"
                type="button"
              >
                Send another link
              </button>
            </div>
          )}

          {/* Rate Limiting Banner */}
          {isRateLimited && (
            <div className="rate-limit-banner">
              <div className="rate-limit-content">
                <Clock className="w-6 h-6 text-yellow-500" />
                <div className="rate-limit-text">
                  <h4 className="rate-limit-title">Too many attempts</h4>
                  <p className="rate-limit-description">
                    Please wait <strong>{formatRetryCountdown(retryCountdown)}</strong> before trying again
                  </p>
                </div>
              </div>
            </div>
          )}

          {/* Error Banner */}
          {error && (
            <div className="error-banner">
              <AlertCircle className="w-5 h-5 text-red-500" />
              <span className="error-text">{error}</span>
            </div>
          )}

          {/* Form Section */}
          {!emailSent && (
            <form onSubmit={handleSubmit} className="login-form" noValidate>
              <div className="form-group">
                <label htmlFor="identifier" className="form-label">Email or Username</label>
                <div className="input-wrapper">
                  <Mail className="input-icon" />
                  <input
                    id="identifier"
                    type="text"
                    value={identifier}
                    onChange={handleIdentifierChange}
                    placeholder="Enter your email or username"
                    disabled={isLoading || isRateLimited}
                    className={`form-input ${validationErrors.identifier ? 'error' : ''}`}
                    autoComplete="username"
                    autoFocus
                  />
                </div>
                {validationErrors.identifier && (
                  <span className="field-error">{validationErrors.identifier}</span>
                )}
              </div>

              <button
                type="submit"
                disabled={isLoading || isRateLimited || !identifier.trim()}
                className={`login-button ${isLoading ? 'loading' : ''}`}
              >
                {isLoading ? (
                  <>
                    <div className="loading-spinner"></div>
                    Sending Reset Link...
                  </>
                ) : (
                  <>
                    <Mail className="w-4 h-4" />
                    Send Reset Link
                  </>
                )}
              </button>
            </form>
          )}

          {/* Navigation Links */}
          <div className="login-card-footer">
            <button
              onClick={onBack}
              className="back-link"
              type="button"
            >
              <ArrowLeft className="w-4 h-4" />
              Back to Login
            </button>
          </div>

          {/* Help Text */}
          {!emailSent && (
            <div className="help-section">
              <h4 className="help-title">Need help?</h4>
              <p className="help-text">
                If you're having trouble resetting your password, please contact our support team.
              </p>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

export default ForgotPasswordView;
EOF

    print_success "Updated ForgotPasswordView.jsx with nYtevibe styling"
}

update_reset_password_view() {
    print_step "Updating ResetPasswordView with nYtevibe styling ${STYLE}"
    
    backup_file "src/components/Views/ResetPasswordView.jsx"
    
    cat > "src/components/Views/ResetPasswordView.jsx" << 'EOF'
/**
 * Styled Reset Password View Component
 * Matches nYtevibe design theme and LoginView styling
 */

import React, { useState, useEffect } from 'react';
import { ArrowLeft, Eye, EyeOff, Lock, Zap, CheckCircle, Clock, AlertCircle, XCircle, Shield } from 'lucide-react';
import authAPI from '../../services/authAPI';
import { 
  validatePasswordResetForm, 
  getPasswordStrength,
  getPasswordResetErrorMessage,
  formatRetryCountdown 
} from '../../utils/authUtils';
import { 
  getTokenFromURL, 
  getEmailFromURL, 
  validateResetURL, 
  cleanResetURLParams 
} from '../../utils/urlUtils';

const ResetPasswordView = ({ onBack, onSuccess, token: propToken, email: propEmail }) => {
  // URL parameters (use props if available, otherwise extract from URL)
  const [token, setToken] = useState(propToken || '');
  const [email, setEmail] = useState(propEmail || '');

  // Form state
  const [password, setPassword] = useState('');
  const [passwordConfirmation, setPasswordConfirmation] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);

  // UI state
  const [isLoading, setIsLoading] = useState(false);
  const [validationErrors, setValidationErrors] = useState({});
  const [tokenValidated, setTokenValidated] = useState(false);
  const [tokenValidating, setTokenValidating] = useState(true);

  // Success state
  const [resetSuccess, setResetSuccess] = useState(false);
  const [redirectCountdown, setRedirectCountdown] = useState(5);

  // Rate limiting state
  const [isRateLimited, setIsRateLimited] = useState(false);
  const [retryCountdown, setRetryCountdown] = useState(0);

  // Error state
  const [error, setError] = useState('');

  // Initialize token validation on mount
  useEffect(() => {
    const initializeReset = async () => {
      let resetToken = token;
      let resetEmail = email;

      // If no props provided, get from URL
      if (!resetToken || !resetEmail) {
        const urlValidation = validateResetURL();
        
        if (!urlValidation.isValid) {
          setError('Invalid reset link. Please request a new password reset.');
          setTokenValidating(false);
          return;
        }

        resetToken = urlValidation.token;
        resetEmail = urlValidation.email;
        setToken(resetToken);
        setEmail(resetEmail);
      }

      // Validate token with backend
      try {
        const result = await authAPI.verifyResetToken(resetToken, resetEmail);
        
        if (result.success) {
          setTokenValidated(true);
        } else {
          setError(getPasswordResetErrorMessage(result.error, result.code));
        }
      } catch (error) {
        console.error('Token validation error:', error);
        setError('Failed to validate reset link. Please try again.');
      }
      
      setTokenValidating(false);
    };

    initializeReset();
  }, [token, email]);

  // Rate limiting countdown effect
  useEffect(() => {
    let interval = null;
    if (isRateLimited && retryCountdown > 0) {
      interval = setInterval(() => {
        setRetryCountdown(prev => {
          if (prev <= 1) {
            setIsRateLimited(false);
            return 0;
          }
          return prev - 1;
        });
      }, 1000);
    }
    return () => clearInterval(interval);
  }, [isRateLimited, retryCountdown]);

  // Success redirect countdown effect
  useEffect(() => {
    let interval = null;
    if (resetSuccess && redirectCountdown > 0) {
      interval = setInterval(() => {
        setRedirectCountdown(prev => {
          if (prev <= 1) {
            cleanResetURLParams();
            if (onSuccess) {
              onSuccess();
            }
            return 0;
          }
          return prev - 1;
        });
      }, 1000);
    }
    return () => clearInterval(interval);
  }, [resetSuccess, redirectCountdown, onSuccess]);

  // Clear errors when user types
  useEffect(() => {
    if (password || passwordConfirmation) {
      setError('');
      setValidationErrors({});
    }
  }, [password, passwordConfirmation]);

  const handlePasswordChange = (e) => {
    setPassword(e.target.value);
  };

  const handlePasswordConfirmationChange = (e) => {
    setPasswordConfirmation(e.target.value);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    // Clear previous states
    setError('');
    setValidationErrors({});

    // Validate form
    const validation = validatePasswordResetForm(password, passwordConfirmation);

    if (!validation.isValid) {
      setValidationErrors(validation.errors);
      return;
    }

    setIsLoading(true);

    try {
      const result = await authAPI.resetPassword(token, email, password, passwordConfirmation);

      if (result.success) {
        setResetSuccess(true);
        setPassword('');
        setPasswordConfirmation('');
      } else {
        handleError(result);
      }
    } catch (error) {
      console.error('Reset password error:', error);
      setError('An unexpected error occurred. Please try again.');
    } finally {
      setIsLoading(false);
    }
  };

  const handleError = (result) => {
    const { error, code, retryAfter, details } = result;

    switch (code) {
      case 'RATE_LIMIT_EXCEEDED':
        setIsRateLimited(true);
        setRetryCountdown(retryAfter || 60);
        break;
      
      case 'VALIDATION_ERROR':
        if (details) {
          setValidationErrors(details);
        } else {
          setError(getPasswordResetErrorMessage(error, code, result.data));
        }
        break;
      
      case 'INVALID_TOKEN':
        setError(getPasswordResetErrorMessage(error, code));
        setTimeout(() => {
          if (onBack) onBack();
        }, 3000);
        break;
      
      default:
        setError(getPasswordResetErrorMessage(error, code, result.data));
        break;
    }
  };

  const getPasswordStrengthInfo = () => {
    if (!password) return null;
    return getPasswordStrength(password);
  };

  const isFormValid = () => {
    return password && 
           passwordConfirmation && 
           password === passwordConfirmation && 
           getPasswordStrength(password).score >= 4;
  };

  if (tokenValidating) {
    return (
      <div className="login-page">
        <div className="login-background">
          <div className="login-gradient"></div>
        </div>
        <div className="login-container">
          <div className="login-card">
            <div className="loading-state">
              <div className="loading-spinner"></div>
              <p className="loading-text">Validating reset link...</p>
            </div>
          </div>
        </div>
      </div>
    );
  }

  if (!tokenValidated) {
    return (
      <div className="login-page">
        <div className="login-background">
          <div className="login-gradient"></div>
        </div>
        <div className="login-container">
          <div className="login-card">
            <div className="invalid-token-state">
              <XCircle className="w-16 h-16 text-red-500 mx-auto mb-4" />
              <h2 className="login-title text-red-500">Invalid Reset Link</h2>
              <p className="login-subtitle">{error}</p>
              <button
                onClick={onBack}
                className="login-button mt-6"
              >
                Request New Reset Link
              </button>
            </div>
          </div>
        </div>
      </div>
    );
  }

  if (resetSuccess) {
    return (
      <div className="login-page">
        <div className="login-background">
          <div className="login-gradient"></div>
        </div>
        <div className="login-container">
          <div className="login-card">
            <div className="success-state">
              <CheckCircle className="w-16 h-16 text-green-500 mx-auto mb-4" />
              <h2 className="login-title text-green-600">Password Reset Successful</h2>
              <p className="login-subtitle">Your password has been updated successfully.</p>
              <p className="redirect-countdown">
                Redirecting to login in <strong>{redirectCountdown}</strong> seconds...
              </p>
              <button
                onClick={onSuccess || onBack}
                className="login-button mt-6"
              >
                Login Now
              </button>
            </div>
          </div>
        </div>
      </div>
    );
  }

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
              <h2 className="login-title">Set New Password</h2>
              <p className="login-subtitle">Create a strong, secure password for your account</p>
            </div>
          </div>

          {/* Rate Limiting Banner */}
          {isRateLimited && (
            <div className="rate-limit-banner">
              <div className="rate-limit-content">
                <Clock className="w-6 h-6 text-yellow-500" />
                <div className="rate-limit-text">
                  <h4 className="rate-limit-title">Too many attempts</h4>
                  <p className="rate-limit-description">
                    Please wait <strong>{formatRetryCountdown(retryCountdown)}</strong> before trying again
                  </p>
                </div>
              </div>
            </div>
          )}

          {/* Error Banner */}
          {error && (
            <div className="error-banner">
              <AlertCircle className="w-5 h-5 text-red-500" />
              <span className="error-text">{error}</span>
            </div>
          )}

          {/* Form Section */}
          <form onSubmit={handleSubmit} className="login-form" noValidate>
            {/* New Password Field */}
            <div className="form-group">
              <label htmlFor="password" className="form-label">New Password</label>
              <div className="input-wrapper">
                <Lock className="input-icon" />
                <input
                  id="password"
                  type={showPassword ? 'text' : 'password'}
                  value={password}
                  onChange={handlePasswordChange}
                  placeholder="Enter new password"
                  disabled={isLoading || isRateLimited}
                  className={`form-input ${validationErrors.password ? 'error' : ''}`}
                  autoComplete="new-password"
                />
                <button
                  type="button"
                  onClick={() => setShowPassword(!showPassword)}
                  className="password-toggle"
                  disabled={isLoading || isRateLimited}
                >
                  {showPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                </button>
              </div>
              
              {/* Password Strength Indicator */}
              {password && (
                <div className="password-strength">
                  <div className="strength-bar">
                    <div 
                      className="strength-fill" 
                      style={{ 
                        width: `${(getPasswordStrengthInfo()?.score || 0) * 16.67}%`,
                        backgroundColor: getPasswordStrengthInfo()?.color 
                      }}
                    ></div>
                  </div>
                  <span 
                    className="strength-label"
                    style={{ color: getPasswordStrengthInfo()?.color }}
                  >
                    {getPasswordStrengthInfo()?.label}
                  </span>
                </div>
              )}
              
              {validationErrors.password && (
                <div className="field-errors">
                  {Array.isArray(validationErrors.password) 
                    ? validationErrors.password.map((error, index) => (
                        <span key={index} className="field-error">{error}</span>
                      ))
                    : <span className="field-error">{validationErrors.password}</span>
                  }
                </div>
              )}
            </div>

            {/* Confirm Password Field */}
            <div className="form-group">
              <label htmlFor="passwordConfirmation" className="form-label">Confirm Password</label>
              <div className="input-wrapper">
                <Lock className="input-icon" />
                <input
                  id="passwordConfirmation"
                  type={showConfirmPassword ? 'text' : 'password'}
                  value={passwordConfirmation}
                  onChange={handlePasswordConfirmationChange}
                  placeholder="Confirm new password"
                  disabled={isLoading || isRateLimited}
                  className={`form-input ${validationErrors.passwordConfirmation ? 'error' : ''}`}
                  autoComplete="new-password"
                />
                <button
                  type="button"
                  onClick={() => setShowConfirmPassword(!showConfirmPassword)}
                  className="password-toggle"
                  disabled={isLoading || isRateLimited}
                >
                  {showConfirmPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                </button>
              </div>
              {validationErrors.passwordConfirmation && (
                <span className="field-error">{validationErrors.passwordConfirmation}</span>
              )}
            </div>

            <button
              type="submit"
              disabled={isLoading || isRateLimited || !isFormValid()}
              className={`login-button ${isLoading ? 'loading' : ''}`}
            >
              {isLoading ? (
                <>
                  <div className="loading-spinner"></div>
                  Resetting Password...
                </>
              ) : (
                <>
                  <Shield className="w-4 h-4" />
                  Reset Password
                </>
              )}
            </button>
          </form>

          {/* Navigation Links */}
          <div className="login-card-footer">
            <button
              onClick={onBack}
              className="back-link"
              type="button"
            >
              <ArrowLeft className="w-4 h-4" />
              Back to Login
            </button>
          </div>

          {/* Security Tips */}
          <div className="security-tips">
            <h4 className="tips-title">Password Requirements:</h4>
            <ul className="tips-list">
              <li>At least 8 characters long</li>
              <li>Contains uppercase and lowercase letters</li>
              <li>Includes at least one number</li>
              <li>Has at least one special character</li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  );
};

export default ResetPasswordView;
EOF

    print_success "Updated ResetPasswordView.jsx with nYtevibe styling"
}

# =============================================================================
# CSS Updates
# =============================================================================

update_app_css() {
    print_step "Adding password reset styles to App.css ${STYLE}"
    
    backup_file "src/App.css"
    
    cat >> "src/App.css" << 'EOF'

/* =============================================================================
   Password Reset Styles - nYtevibe Design Theme
   Added by update-password-reset-styles.sh
   ============================================================================= */

/* Success Banner Styles */
.success-banner {
  background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%);
  border: 1px solid #22c55e;
  border-radius: 16px;
  padding: 20px;
  margin-bottom: 24px;
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
  animation: fadeInUp 0.3s ease-out;
}

.success-content {
  display: flex;
  align-items: flex-start;
  gap: 12px;
  flex: 1;
}

.success-text h4.success-title {
  margin: 0 0 4px 0;
  color: #065f46;
  font-weight: 600;
  font-size: 16px;
}

.success-text p.success-description {
  margin: 0 0 4px 0;
  color: #047857;
  font-weight: 500;
  font-size: 14px;
}

.success-text p.success-note {
  margin: 0;
  color: #047857;
  font-size: 13px;
  line-height: 1.4;
}

.retry-button {
  background: none;
  border: 1px solid #22c55e;
  color: #047857;
  padding: 8px 16px;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;
  white-space: nowrap;
}

.retry-button:hover {
  background: #22c55e;
  color: white;
}

/* Rate Limiting Banner Styles */
.rate-limit-banner {
  background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
  border: 1px solid #f59e0b;
  border-radius: 16px;
  padding: 20px;
  margin-bottom: 24px;
  display: flex;
  align-items: center;
  gap: 16px;
  animation: shake 0.5s ease-in-out;
}

.rate-limit-content {
  display: flex;
  align-items: center;
  gap: 12px;
}

.rate-limit-text h4.rate-limit-title {
  margin: 0 0 4px 0;
  color: #92400e;
  font-weight: 600;
  font-size: 16px;
}

.rate-limit-text p.rate-limit-description {
  margin: 0;
  color: #92400e;
  font-size: 14px;
}

.rate-limit-text strong {
  font-family: 'SF Mono', 'Monaco', monospace;
  font-weight: 600;
}

/* Enhanced Error Banner */
.error-banner {
  background: linear-gradient(135deg, #fecaca 0%, #fca5a5 100%);
  border: 1px solid #ef4444;
  border-radius: 12px;
  padding: 16px;
  margin-bottom: 20px;
  display: flex;
  align-items: center;
  gap: 12px;
  animation: fadeInUp 0.3s ease-out;
}

.error-banner .error-text {
  color: #991b1b;
  font-weight: 500;
  margin: 0;
  flex: 1;
}

/* Password Strength Indicator */
.password-strength {
  margin-top: 8px;
  display: flex;
  align-items: center;
  gap: 12px;
}

.strength-bar {
  flex: 1;
  height: 4px;
  background-color: #e5e7eb;
  border-radius: 2px;
  overflow: hidden;
}

.strength-fill {
  height: 100%;
  transition: width 0.3s ease, background-color 0.3s ease;
  border-radius: 2px;
}

.strength-label {
  font-size: 12px;
  font-weight: 600;
  transition: color 0.3s ease;
  min-width: 80px;
  text-align: right;
}

/* Field Error Styles */
.field-errors {
  margin-top: 8px;
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.field-error {
  font-size: 13px;
  color: #ef4444;
  line-height: 1.4;
  display: block;
}

.form-input.error {
  border-color: #ef4444;
  box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.1);
}

/* Loading States */
.loading-state {
  text-align: center;
  padding: 60px 20px;
}

.loading-state .loading-spinner {
  display: inline-block;
  margin-bottom: 16px;
  width: 32px;
  height: 32px;
  border: 3px solid #e5e7eb;
  border-top: 3px solid #6366f1;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

.loading-text {
  color: #6b7280;
  font-size: 16px;
  margin: 0;
}

/* Invalid Token State */
.invalid-token-state {
  text-align: center;
  padding: 40px 20px;
}

.invalid-token-state .login-title {
  margin: 16px 0 8px 0;
}

.invalid-token-state .login-subtitle {
  margin-bottom: 0;
  color: #6b7280;
}

/* Success State */
.success-state {
  text-align: center;
  padding: 40px 20px;
}

.success-state .login-title {
  margin: 16px 0 8px 0;
}

.success-state .login-subtitle {
  margin-bottom: 16px;
  color: #6b7280;
}

.redirect-countdown {
  color: #6b7280;
  font-size: 14px;
  margin: 0 0 16px 0;
}

.redirect-countdown strong {
  color: #374151;
}

/* Back Link Styles */
.back-link {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  font-size: 14px;
  color: #6366f1;
  text-decoration: none;
  background: none;
  border: none;
  cursor: pointer;
  transition: color 0.2s ease;
  padding: 0;
}

.back-link:hover {
  color: #4f46e5;
  text-decoration: underline;
}

/* Help Section */
.help-section {
  margin-top: 24px;
  padding: 16px;
  background: rgba(99, 102, 241, 0.05);
  border-radius: 12px;
  border: 1px solid rgba(99, 102, 241, 0.1);
}

.help-title {
  margin: 0 0 8px 0;
  font-size: 14px;
  font-weight: 600;
  color: #374151;
}

.help-text {
  margin: 0;
  font-size: 14px;
  color: #6b7280;
  line-height: 1.5;
}

/* Security Tips */
.security-tips {
  margin-top: 24px;
  padding: 16px;
  background: rgba(99, 102, 241, 0.05);
  border-radius: 12px;
  border: 1px solid rgba(99, 102, 241, 0.1);
}

.tips-title {
  margin: 0 0 12px 0;
  font-size: 14px;
  font-weight: 600;
  color: #374151;
}

.tips-list {
  margin: 0;
  padding-left: 20px;
  list-style-type: disc;
}

.tips-list li {
  font-size: 13px;
  color: #6b7280;
  line-height: 1.4;
  margin-bottom: 4px;
}

.tips-list li:last-child {
  margin-bottom: 0;
}

/* Enhanced Forgot Password Link */
.forgot-password-section {
  text-align: right;
  margin-bottom: 20px;
  margin-top: -10px;
}

.forgot-password-link {
  background: none;
  border: none;
  color: #6366f1;
  font-size: 14px;
  cursor: pointer;
  text-decoration: none;
  transition: color 0.2s ease;
  padding: 4px 0;
  font-weight: 400;
}

.forgot-password-link:hover {
  color: #4f46e5;
  text-decoration: underline;
}

.forgot-password-link:focus {
  outline: 2px solid #6366f1;
  outline-offset: 2px;
  border-radius: 4px;
}

/* Animation Keyframes */
@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes shake {
  0%, 100% { transform: translateX(0); }
  25% { transform: translateX(-5px); }
  75% { transform: translateX(5px); }
}

@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

/* Responsive Design */
@media (max-width: 768px) {
  .success-banner,
  .rate-limit-banner,
  .error-banner {
    padding: 16px;
    border-radius: 12px;
    flex-direction: column;
    align-items: stretch;
  }
  
  .success-content,
  .rate-limit-content {
    gap: 8px;
  }
  
  .retry-button {
    align-self: center;
    margin-top: 12px;
  }
  
  .forgot-password-section {
    text-align: center;
    margin-bottom: 16px;
  }
  
  .forgot-password-link {
    font-size: 13px;
  }
  
  .strength-label {
    min-width: 60px;
    font-size: 11px;
  }
  
  .help-section,
  .security-tips {
    margin-top: 20px;
    padding: 14px;
  }
}

/* Dark Mode Support (if applicable) */
@media (prefers-color-scheme: dark) {
  .help-section,
  .security-tips {
    background: rgba(99, 102, 241, 0.1);
    border-color: rgba(99, 102, 241, 0.2);
  }
  
  .tips-title,
  .help-title {
    color: #f9fafb;
  }
  
  .tips-list li,
  .help-text {
    color: #d1d5db;
  }
  
  .loading-text {
    color: #d1d5db;
  }
  
  .redirect-countdown {
    color: #d1d5db;
  }
  
  .redirect-countdown strong {
    color: #f9fafb;
  }
}

/* End of Password Reset Styles */
EOF

    print_success "Added password reset styles to App.css"
}

# =============================================================================
# Final Status and Testing
# =============================================================================

show_completion_status() {
    print_header "Update Complete! ${CHECK}"
    
    print_success "All password reset components have been styled successfully!"
    echo ""
    print_info "📋 What was updated:"
    echo "  • ForgotPasswordView.jsx - Added nYtevibe design theme"
    echo "  • ResetPasswordView.jsx - Added nYtevibe design theme"  
    echo "  • App.css - Added comprehensive password reset styles"
    echo ""
    print_info "🎨 New features:"
    echo "  • Success banners with animations"
    echo "  • Rate limiting indicators" 
    echo "  • Password strength meter"
    echo "  • Error handling with styled banners"
    echo "  • Loading states with spinners"
    echo "  • Mobile responsive design"
    echo "  • Back navigation buttons"
    echo ""
    print_info "🚀 Test the styled components:"
    echo "  1. npm start                    # Start development server"
    echo "  2. Navigate to login page"
    echo "  3. Click 'Forgot your password?'"
    echo "  4. Test the forgot password form"
    echo "  5. Test reset URL: /?token=test&email=test@example.com"
    echo ""
    print_warning "💡 Backup files created with timestamp suffixes"
    echo "     You can restore from backups if needed"
    echo ""
    print_success "🎉 Your nYtevibe password reset pages now match your design theme!"
}

# =============================================================================
# Main Execution
# =============================================================================

main() {
    print_header "nYtevibe Password Reset Styling Update ${ROCKET}"
    
    print_info "This script will update your password reset components with nYtevibe styling"
    print_info "All files will be backed up before modification"
    echo ""
    
    # Project validation
    validate_project
    
    # Component updates
    update_forgot_password_view
    update_reset_password_view
    
    # CSS updates
    update_app_css
    
    # Final status
    show_completion_status
}

# Execute main function
main "$@"
EOF
