#!/bin/bash

# =============================================================================
# Debug 422 Validation Error for Password Reset
# =============================================================================
# 422 means validation failed - let's see exactly what's wrong
# =============================================================================

echo "🎉 GREAT NEWS: 401 Authentication Issue FIXED!"
echo "=============================================="
echo "✅ Routes are now working (no more auth issues)"
echo "❌ Now we just need to fix the 422 validation error"
echo ""

echo "🔍 DEBUGGING 422 VALIDATION ERROR"
echo "================================="

# Test with different email scenarios
echo "🧪 Testing various email scenarios to identify validation issue..."
echo ""

# Test 1: Valid existing email
echo "🔍 Test 1: Testing with existing email from your database"
echo "📧 Looking for existing user email..."

# Get an existing email from the database
EXISTING_EMAIL=$(php artisan tinker --execute="
\$user = \App\Models\User::first();
if (\$user) {
    echo \$user->email;
} else {
    echo 'test@example.com';
}")

echo "Found email: $EXISTING_EMAIL"

echo "🧪 Testing forgot password with existing email:"
RESPONSE1=$(curl -s -X POST "https://system.nytevibe.com/api/auth/forgot-password" \
     -H "Content-Type: application/json" \
     -H "Accept: application/json" \
     -H "Origin: https://blackaxl.com" \
     -d "{\"email\":\"$EXISTING_EMAIL\"}")

echo "Response: $RESPONSE1"
echo ""

# Test 2: Check what validation rules are expected
echo "🔍 Test 2: Checking controller validation rules"
echo "📄 forgotPassword method validation:"
grep -A 10 -B 2 "validator.*make" app/Http/Controllers/API/AuthController.php | grep -A 10 "forgotPassword" -m 1

echo ""

# Test 3: Test with different request formats
echo "🔍 Test 3: Testing different request formats"

echo "🧪 Format A: Simple email"
RESPONSE2=$(curl -s -X POST "https://system.nytevibe.com/api/auth/forgot-password" \
     -H "Content-Type: application/json" \
     -H "Accept: application/json" \
     -H "Origin: https://blackaxl.com" \
     -d '{"email":"iammrpwinner01@gmail.com"}')
echo "Response: $RESPONSE2"
echo ""

echo "🧪 Format B: With identifier field (in case frontend sends username)"
RESPONSE3=$(curl -s -X POST "https://system.nytevibe.com/api/auth/forgot-password" \
     -H "Content-Type: application/json" \
     -H "Accept: application/json" \
     -H "Origin: https://blackaxl.com" \
     -d '{"identifier":"iammrpwinner01@gmail.com"}')
echo "Response: $RESPONSE3"
echo ""

echo "🧪 Format C: With both email and identifier"
RESPONSE4=$(curl -s -X POST "https://system.nytevibe.com/api/auth/forgot-password" \
     -H "Content-Type: application/json" \
     -H "Accept: application/json" \
     -H "Origin: https://blackaxl.com" \
     -d '{"email":"iammrpwinner01@gmail.com","identifier":"iammrpwinner01@gmail.com"}')
echo "Response: $RESPONSE4"
echo ""

# Test 4: Check frontend request format
echo "🔍 Test 4: Checking frontend code expectations"
echo "📄 Frontend authAPI.js forgot password method:"
if [[ -f "src/services/authAPI.js" ]]; then
    echo "🔍 Looking for forgotPassword method in authAPI.js..."
    grep -A 15 -B 5 "forgotPassword" src/services/authAPI.js 2>/dev/null || echo "❌ File not found in expected location"
elif [[ -f "src/services/registrationAPI.js" ]]; then
    echo "🔍 Looking for forgotPassword method in registrationAPI.js..."
    grep -A 15 -B 5 "forgotPassword" src/services/registrationAPI.js 2>/dev/null || echo "❌ Method not found"
else
    echo "⚠️  Frontend API files not found in expected locations"
fi

echo ""

# Check what the frontend is actually sending
echo "🔍 Test 5: Frontend API call analysis"
echo "📄 What frontend should be sending based on your authUtils:"
if [[ -f "src/utils/authUtils.js" ]]; then
    echo "🔍 Checking authUtils.js for sanitizeIdentifier function..."
    grep -A 10 -B 5 "sanitizeIdentifier" src/utils/authUtils.js 2>/dev/null || echo "❌ Function not found"
else
    echo "⚠️  authUtils.js not found"
fi

echo ""
echo "📋 ANALYSIS SUMMARY"
echo "==================="

echo "🎯 Based on the responses above, the issue is likely:"
echo ""

# Analyze the responses
if echo "$RESPONSE1" | grep -q "success"; then
    echo "✅ SUCCESS with existing email - validation working!"
elif echo "$RESPONSE1" | grep -q "email"; then
    echo "❌ Email validation issue - check validation rules"
elif echo "$RESPONSE1" | grep -q "required"; then
    echo "❌ Missing required field - check field names"
else
    echo "🤔 Unknown validation issue - check response format"
fi

echo ""
echo "🔧 LIKELY FIXES:"
echo "================"

echo "1. 🔍 Field Name Mismatch:"
echo "   Frontend might be sending 'identifier' but backend expects 'email'"
echo ""

echo "2. 📧 Email Validation Rule:"
echo "   Controller might require 'exists:users,email' but user doesn't exist"
echo ""

echo "3. 📝 Request Format:"
echo "   Frontend might be sending extra fields causing validation issues"
echo ""

echo "🔧 QUICK FIXES TO TRY:"
echo "======================"

echo "Fix 1: Update controller validation to accept both email and identifier"
cat << 'CONTROLLER_FIX'

// In forgotPassword method, change validation from:
'email' => 'required|email|exists:users,email'

// To:
'email' => 'required|email'

// Or to accept identifier:
$request->validate([
    'identifier' => 'required|string'
]);
$email = filter_var($request->identifier, FILTER_VALIDATE_EMAIL) 
    ? $request->identifier 
    : User::where('username', $request->identifier)->value('email');

CONTROLLER_FIX

echo ""
echo "Fix 2: Update frontend to send correct field name"
echo "   Change 'identifier' to 'email' in frontend API call"
echo ""

echo "🧪 MANUAL TEST:"
echo "=============="
echo "Try this curl command to test with your actual email:"
echo ""
echo "curl -X POST https://system.nytevibe.com/api/auth/forgot-password \\"
echo "     -H 'Content-Type: application/json' \\"
echo "     -H 'Accept: application/json' \\"
echo "     -H 'Origin: https://blackaxl.com' \\"
echo "     -d '{\"email\":\"iammrpwinner01@gmail.com\"}'"
echo ""

echo "🎉 The hard part (authentication) is DONE!"
echo "🔧 This validation issue should be easy to fix!"
