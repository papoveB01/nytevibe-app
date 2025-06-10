#!/bin/bash

# Fix Email Verification Field Check
echo "======================================================="
echo "    FIXING EMAIL VERIFICATION FIELD CHECK"
echo "======================================================="

# Backup the file
cp src/components/Views/LoginView.jsx src/components/Views/LoginView.jsx.backup_verification

echo "✅ Backed up LoginView.jsx"

# Fix the email verification check
sed -i 's/!response\.data\.user\.email_verified/!response.data.user.email_verified_at/g' src/components/Views/LoginView.jsx

# Verify the change
if grep -q "email_verified_at" src/components/Views/LoginView.jsx; then
    echo "✅ Fixed email verification check: email_verified → email_verified_at"
    echo ""
    echo "Changed line:"
    grep -n "email_verified_at" src/components/Views/LoginView.jsx
else
    echo "❌ Failed to automatically fix. Manual edit needed:"
    echo "In LoginView.jsx, change:"
    echo "  !response.data.user.email_verified"
    echo "to:"
    echo "  !response.data.user.email_verified_at"
fi

echo ""
echo "======================================================="
echo "🎉 LOGIN SHOULD NOW WORK!"
echo "======================================================="
echo "The API was working all along - it was just checking"
echo "the wrong field for email verification status!"
echo ""
echo "API returns: email_verified_at (timestamp)"
echo "Frontend was checking: email_verified (boolean)"
echo "======================================================="
