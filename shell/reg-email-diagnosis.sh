#!/bin/bash
# React Email Registration Diagnostic Script
# Analyzes React src/ directory to find email registration issues

echo "🔍 REACT EMAIL REGISTRATION DIAGNOSTIC"
echo "======================================"

# Check if src directory exists
if [ ! -d "src" ]; then
    echo "❌ Error: 'src' directory not found. Run this script from your React app root directory."
    exit 1
fi

echo "📁 1. DIRECTORY STRUCTURE ANALYSIS"
echo "================================"
echo "React app structure:"
find src -type f -name "*.js" -o -name "*.jsx" -o -name "*.ts" -o -name "*.tsx" | head -20
echo ""

echo "📊 File count by type:"
echo "JavaScript/TypeScript files: $(find src -name "*.js" -o -name "*.jsx" -o -name "*.ts" -o -name "*.tsx" | wc -l)"
echo "Component files: $(find src -name "*[Cc]omponent*" -o -name "*[Pp]age*" | wc -l)"
echo ""

echo "🔍 2. REGISTRATION-RELATED FILES DETECTION"
echo "========================================"
echo "Files likely related to registration/signup/auth:"

# Find registration related files
REG_FILES=$(find src -type f \( -name "*.js" -o -name "*.jsx" -o -name "*.ts" -o -name "*.tsx" \) -exec grep -l -i "register\|signup\|sign.up\|auth\|login" {} \;)

if [ -z "$REG_FILES" ]; then
    echo "❌ No registration-related files found"
else
    echo "$REG_FILES"
fi
echo ""

echo "📧 3. EMAIL FIELD ANALYSIS"
echo "========================"
echo "Files containing email-related code:"

# Find files with email references
EMAIL_FILES=$(find src -type f \( -name "*.js" -o -name "*.jsx" -o -name "*.ts" -o -name "*.tsx" \) -exec grep -l -i "email\|@" {} \;)

for file in $EMAIL_FILES; do
    echo ""
    echo "📄 File: $file"
    echo "   Email references:"
    grep -n -i "email\|userEmail\|user_email\|emailAddress" "$file" | head -5
done
echo ""

echo "🌐 4. API CALLS ANALYSIS"
echo "======================="
echo "Files with API calls (fetch, axios, api):"

# Find API-related files
API_FILES=$(find src -type f \( -name "*.js" -o -name "*.jsx" -o -name "*.ts" -o -name "*.tsx" \) -exec grep -l -E "fetch\(|axios\.|api\.|\.post\(|\.get\(" {} \;)

for file in $API_FILES; do
    echo ""
    echo "📄 File: $file"
    echo "   API calls:"
    grep -n -E "fetch\(|axios\.|api\.|\.post\(|\.get\(" "$file" | head -3
    
    echo "   Registration endpoints:"
    grep -n -i "register\|signup\|sign.up" "$file" | head -3
done
echo ""

echo "📝 5. FORM HANDLING ANALYSIS"
echo "==========================="
echo "Form-related patterns found:"

# Check for form handling patterns
for file in $(find src -name "*.js" -o -name "*.jsx" -o -name "*.ts" -o -name "*.tsx"); do
    if grep -q -i "useState\|useForm\|formik\|form" "$file"; then
        echo ""
        echo "📄 File: $file"
        
        echo "   State management:"
        grep -n "useState\|useForm\|formik" "$file" | head -3
        
        echo "   Form fields:"
        grep -n -i "name=\|id=.*email\|email.*:" "$file" | head -3
        
        echo "   Submit handlers:"
        grep -n -i "onSubmit\|handleSubmit\|submit" "$file" | head -3
    fi
done
echo ""

echo "🔧 6. SPECIFIC EMAIL ISSUES DETECTION"
echo "===================================="

# Look for potential issues
echo "Checking for common email field issues..."

echo ""
echo "❓ Issue Check 1: Email field naming inconsistencies"
for file in $(find src -name "*.js" -o -name "*.jsx" -o -name "*.ts" -o -name "*.tsx"); do
    EMAIL_VARIANTS=$(grep -o -i "email[A-Za-z]*\|userEmail\|user_email\|emailAddress\|e_mail" "$file" | sort | uniq)
    if [ ! -z "$EMAIL_VARIANTS" ]; then
        echo "📄 $file uses: $EMAIL_VARIANTS"
    fi
done

echo ""
echo "❓ Issue Check 2: Missing email validation"
for file in $(find src -name "*.js" -o -name "*.jsx" -o -name "*.ts" -o -name "*.tsx"); do
    if grep -q -i "email" "$file" && ! grep -q -i "valid\|@.*\." "$file"; then
        echo "⚠️  $file: Contains email but no validation pattern found"
    fi
done

echo ""
echo "❓ Issue Check 3: API request body structure"
for file in $(find src -name "*.js" -o -name "*.jsx" -o -name "*.ts" -o -name "*.tsx"); do
    if grep -q -E "fetch\(|axios\.|\.post\(" "$file"; then
        echo ""
        echo "📄 $file - Request body analysis:"
        grep -A 10 -B 2 -i "JSON.stringify\|body:\|data:" "$file" | head -15
    fi
done

echo ""
echo "🎯 7. DETAILED CODE ANALYSIS OF KEY FILES"
echo "========================================"

# Analyze the most likely registration files
LIKELY_REG_FILES=$(find src -type f \( -name "*.js" -o -name "*.jsx" -o -name "*.ts" -o -name "*.tsx" \) \( -name "*[Rr]egister*" -o -name "*[Ss]ignup*" -o -name "*[Ss]ign[Uu]p*" -o -name "*[Aa]uth*" \))

for file in $LIKELY_REG_FILES; do
    echo ""
    echo "🔍 DETAILED ANALYSIS: $file"
    echo "================================"
    
    echo "Full file content (first 50 lines):"
    head -50 "$file"
    
    echo ""
    echo "Email-specific lines:"
    grep -n -C 2 -i "email" "$file"
    
    echo ""
    echo "API call context:"
    grep -n -C 5 -E "fetch\(|axios\.|\.post\(" "$file"
done

echo ""
echo "🔍 8. PACKAGE.JSON DEPENDENCIES CHECK"
echo "===================================="
if [ -f "package.json" ]; then
    echo "HTTP client libraries:"
    grep -i "axios\|fetch\|request" package.json || echo "No specific HTTP libraries found"
    
    echo ""
    echo "Form libraries:"
    grep -i "formik\|react-hook-form\|form" package.json || echo "No form libraries found"
else
    echo "❌ package.json not found"
fi

echo ""
echo "🎯 9. POTENTIAL ISSUES SUMMARY"
echo "=============================="

echo "Based on analysis, check these potential issues:"
echo ""
echo "1. 📧 EMAIL FIELD NAMING:"
echo "   - Ensure React uses consistent field names (email vs userEmail vs emailAddress)"
echo "   - Check if backend expects 'email' but frontend sends 'userEmail'"
echo ""

echo "2. 🌐 API REQUEST FORMAT:"
echo "   - Verify JSON.stringify() includes the email field"
echo "   - Check Content-Type header is 'application/json'"
echo "   - Ensure email is not undefined/null before sending"
echo ""

echo "3. 📝 FORM STATE MANAGEMENT:"
echo "   - Check if email value is properly captured from input"
echo "   - Verify useState or form library is managing email state"
echo "   - Ensure form submission includes email in request body"
echo ""

echo "4. 🔧 DEBUGGING RECOMMENDATIONS:"
echo "   - Add console.log() before API calls to see request data"
echo "   - Check browser DevTools Network tab for actual request payload"
echo "   - Verify email field has correct name attribute in HTML"
echo ""

echo "✅ DIAGNOSTIC COMPLETE!"
echo ""
echo "🔍 To debug further:"
echo "1. Look at the detailed file analysis above"
echo "2. Check the email field naming consistency"
echo "3. Add console.log() statements in your registration flow"
echo "4. Verify the API request payload in browser DevTools"
