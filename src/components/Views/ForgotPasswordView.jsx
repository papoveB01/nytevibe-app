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
