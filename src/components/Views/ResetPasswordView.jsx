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
