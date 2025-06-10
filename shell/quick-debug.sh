#!/bin/bash
# Quick Frontend Verification Debug

echo "🔧 Adding critical debug to verification flow..."

# Add debug to EmailVerificationView.jsx at the very beginning
sed -i '/const EmailVerificationView = ({ onBack, onSuccess, token, email }) => {/a\
    console.log("🔍 =========================");\
    console.log("EmailVerificationView LOADED");\
    console.log("Props received:", { token, email, onBack: !!onBack, onSuccess: !!onSuccess });\
    console.log("Current URL:", window.location.href);\
    console.log("URL params:", window.location.search);\
    \
    // Parse URL directly to see what we get\
    const urlParams = new URLSearchParams(window.location.search);\
    console.log("Token from URL directly:", urlParams.get("token"));\
    console.log("Verify param from URL:", urlParams.get("verify"));\
    console.log("=========================");' src/components/Auth/EmailVerificationView.jsx

# Add debug to the useEffect that triggers verification
sed -i '/useEffect(() => {/a\
        console.log("🔄 useEffect triggered!");\
        console.log("Token value in useEffect:", token);' src/components/Auth/EmailVerificationView.jsx

# Add debug to the verifyEmailToken function
sed -i '/const verifyEmailToken = async (verificationToken) => {/a\
        console.log("🌐 verifyEmailToken called with:", verificationToken);\
        console.log("Token type:", typeof verificationToken);\
        console.log("Token length:", verificationToken?.length);\
        \
        if (!verificationToken) {\
            console.error("❌ NO TOKEN - aborting verification");\
            setVerificationStatus("error");\
            return;\
        }' src/components/Auth/EmailVerificationView.jsx

# Add debug before the API call
sed -i '/const response = await registrationAPI.verifyEmail(verificationToken);/i\
            console.log("📡 About to make API call with token:", verificationToken);' src/components/Auth/EmailVerificationView.jsx

# Add debug after the API call
sed -i '/const response = await registrationAPI.verifyEmail(verificationToken);/a\
            console.log("✅ API call successful! Response:", response);' src/components/Auth/EmailVerificationView.jsx

echo "✅ Debug code added to EmailVerificationView.jsx"
echo ""
echo "🔍 Now test the verification:"
echo "1. Get a new verification email (register again or resend)"
echo "2. Click the verification link"
echo "3. Open DevTools (F12) → Console"
echo "4. Look for the debug messages starting with 🔍, 🔄, 🌐, 📡"
echo ""
echo "📧 If you need a new verification email, register again with:"
echo "   thrifty.choices02@gmail.com (different email)"
