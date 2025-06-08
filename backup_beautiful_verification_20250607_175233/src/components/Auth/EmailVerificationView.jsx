import React, { useState, useEffect } from 'react';
import { CheckCircle, XCircle, Mail, ArrowLeft, RefreshCw } from 'lucide-react';
import { useApp } from '../../context/AppContext';
import EmailVerificationAPI from '../../services/emailVerificationAPI';

const EmailVerificationView = ({ onBack, onSuccess, token, email }) => {
    console.log("🔍 =========================");
    console.log("EmailVerificationView LOADED - Phase 2");
    console.log("Props received:", { token, email, onBack: !!onBack, onSuccess: !!onSuccess });
    console.log("Current URL:", window.location.href);
    console.log("URL params:", window.location.search);
    
    // Parse URL to get verification parameters
    const verificationParams = EmailVerificationAPI.parseVerificationURL();
    console.log("Parsed verification params:", verificationParams);
    console.log("=========================");

    const { actions } = useApp();
    const [verificationStatus, setVerificationStatus] = useState('verifying');
    const [isLoading, setIsLoading] = useState(false);
    const [canResend, setCanResend] = useState(true);
    const [resendCooldown, setResendCooldown] = useState(0);
    const [verificationData, setVerificationData] = useState(null);

    // Auto-verify on component mount if we have verification parameters
    useEffect(() => {
        console.log("🔄 Auto-verification useEffect triggered!");
        
        // Phase 1 format: Check for user ID + hash
        if (verificationParams.userId && verificationParams.hash) {
            console.log("📧 Found Phase 1 verification format - auto-verifying");
            verifyEmailWithIdAndHash(verificationParams.userId, verificationParams.hash);
        }
        // Legacy support: Check for token (existing functionality)
        else if (token || verificationParams.token) {
            console.log("🔄 Found legacy token format");
            const tokenToUse = token || verificationParams.token;
            verifyEmailToken(tokenToUse);
        }
        // No verification parameters found
        else {
            console.log("⚠️ No verification parameters found in URL");
            setVerificationStatus('error');
        }
    }, [verificationParams.userId, verificationParams.hash, token]);

    // Resend cooldown timer
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

    /**
     * Phase 1 Verification: Verify email using user ID + hash
     */
    const verifyEmailWithIdAndHash = async (userId, hash) => {
        console.log("🌐 Phase 1 verifyEmailWithIdAndHash called with:", { userId, hash });
        
        setIsLoading(true);
        try {
            const response = await EmailVerificationAPI.verifyEmail(userId, hash);
            console.log("✅ Phase 1 API call successful! Response:", response);

            if (response.success && response.data.status === 'success') {
                setVerificationStatus('success');
                setVerificationData(response.data);
                
                actions.addNotification({
                    type: 'success',
                    message: '🎉 Email verified successfully! You can now sign in.',
                    important: true,
                    duration: 4000
                });

                // Auto-redirect after 2 seconds
                setTimeout(() => {
                    onSuccess && onSuccess();
                }, 2000);
            } else {
                // Handle specific error codes from Phase 1 backend
                const errorCode = response.data?.code;
                
                switch (errorCode) {
                    case 'ALREADY_VERIFIED':
                        setVerificationStatus('success');
                        setVerificationData(response.data);
                        actions.addNotification({
                            type: 'info',
                            message: '✅ Email already verified! You can sign in.',
                            duration: 4000
                        });
                        break;
                        
                    case 'INVALID_HASH':
                        setVerificationStatus('expired');
                        actions.addNotification({
                            type: 'error',
                            message: '🔗 Invalid verification link. Please request a new one.',
                            duration: 4000
                        });
                        break;
                        
                    case 'USER_NOT_FOUND':
                        setVerificationStatus('error');
                        actions.addNotification({
                            type: 'error',
                            message: '❌ User not found. Please check the verification link.',
                            duration: 4000
                        });
                        break;
                        
                    default:
                        setVerificationStatus('error');
                        actions.addNotification({
                            type: 'error',
                            message: response.data?.message || 'Email verification failed.',
                            duration: 4000
                        });
                }
            }
        } catch (error) {
            console.error('Phase 1 Email verification failed:', error);
            setVerificationStatus('error');
            actions.addNotification({
                type: 'error',
                message: 'Network error. Please check your connection.',
                duration: 4000
            });
        } finally {
            setIsLoading(false);
        }
    };

    /**
     * Legacy Token Verification (for backward compatibility)
     */
    const verifyEmailToken = async (verificationToken) => {
        console.log("🔄 Legacy verifyEmailToken called with:", verificationToken);
        
        if (!verificationToken) {
            console.error("❌ NO TOKEN - aborting verification");
            setVerificationStatus("error");
            return;
        }

        setIsLoading(true);
        try {
            // Note: This would need to be updated if you still have a legacy registrationAPI
            // For now, we'll show an error directing users to use the new system
            setVerificationStatus('error');
            actions.addNotification({
                type: 'error',
                message: 'Legacy verification format no longer supported. Please request a new verification email.',
                duration: 4000
            });
        } catch (error) {
            console.error('Legacy verification failed:', error);
            setVerificationStatus('error');
        } finally {
            setIsLoading(false);
        }
    };

    /**
     * Resend verification email using Phase 1 API
     */
    const handleResendEmail = async () => {
        if (!canResend || !email) return;

        setIsLoading(true);
        setCanResend(false);
        setResendCooldown(60);

        try {
            const response = await EmailVerificationAPI.resendVerificationEmail(email);
            
            if (response.success) {
                actions.addNotification({
                    type: 'success',
                    message: '📧 Verification email sent! Check your inbox.',
                    duration: 4000
                });
            } else {
                throw new Error(response.data?.message || 'Failed to resend email');
            }
        } catch (error) {
            console.error('Resend verification failed:', error);
            actions.addNotification({
                type: 'error',
                message: error.message || 'Failed to resend email. Please try again later.',
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
                            {verificationData?.code === 'ALREADY_VERIFIED' 
                                ? 'Your email was already verified. You can sign in to your account.'
                                : 'Your email has been successfully verified. You can now sign in to your account.'
                            }
                        </p>
                        {verificationData?.verified_at && (
                            <p className="verification-timestamp">
                                Verified: {new Date(verificationData.verified_at).toLocaleString()}
                            </p>
                        )}
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
                            This verification link has expired or is invalid. Click below to receive a new verification email.
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
                            We couldn't verify your email. The link may be invalid, expired, or malformed.
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
