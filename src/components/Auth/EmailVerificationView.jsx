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
