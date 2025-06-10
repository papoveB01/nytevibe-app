#!/bin/bash

# =============================================================================
# Frontend Comprehensive Analysis Script
# =============================================================================
# Complete analysis of React frontend password reset implementation
# =============================================================================

echo "🔍 FRONTEND COMPREHENSIVE ANALYSIS"
echo "=================================="
echo "📅 Analysis Date: $(date)"
echo "📂 Current Directory: $(pwd)"
echo ""

# =============================================================================
# STEP 1: PROJECT STRUCTURE ANALYSIS
# =============================================================================

echo "📋 STEP 1: Project Structure Analysis"
echo "====================================="

echo "🔍 Checking if we're in React project..."
if [[ -f "package.json" ]]; then
    echo "✅ Found package.json - React project confirmed"
    echo "📦 Project details:"
    grep -E '"name"|"version"|"react"|"vite"' package.json | head -6
else
    echo "❌ No package.json found - not in React project root"
    echo "🔍 Looking for React project..."
    find . -name "package.json" -maxdepth 3 | head -3
fi

echo ""
echo "🔍 Frontend file structure:"
echo "📁 Key directories and files:"
ls -la src/ 2>/dev/null | head -10 || echo "❌ src/ directory not found"

echo ""
echo "📁 Components structure:"
find src/components -name "*.jsx" -o -name "*.js" | grep -i "password\|auth\|login\|register" | head -10 2>/dev/null || echo "❌ No components directory or password-related components found"

echo ""
echo "📁 Services/API structure:"
find src -name "*API*" -o -name "*api*" -o -name "*Auth*" -o -name "*auth*" | head -10 2>/dev/null || echo "❌ No API service files found"

# =============================================================================
# STEP 2: PASSWORD RESET COMPONENT ANALYSIS
# =============================================================================

echo ""
echo "📋 STEP 2: Password Reset Component Analysis"
echo "============================================"

echo "🔍 Looking for password reset components..."

# Find password reset related files
FORGOT_PASSWORD_FILES=$(find src -name "*Forgot*" -o -name "*forgot*" -o -name "*Reset*" -o -name "*reset*" | grep -E "\.(jsx?|tsx?)$")

if [[ -n "$FORGOT_PASSWORD_FILES" ]]; then
    echo "✅ Found password reset components:"
    echo "$FORGOT_PASSWORD_FILES"
    
    for file in $FORGOT_PASSWORD_FILES; do
        echo ""
        echo "📄 Analyzing: $file"
        echo "─────────────────────────"
        
        # Check imports
        echo "🔍 Imports:"
        grep -n "^import" "$file" | head -10
        
        echo ""
        echo "🔍 API calls in this component:"
        grep -n -A 3 -B 1 "forgotPassword\|forgot-password\|reset-password" "$file" || echo "   No API calls found"
        
        echo ""
        echo "🔍 Form submission handling:"
        grep -n -A 5 -B 2 "onSubmit\|handleSubmit\|submit" "$file" | head -15 || echo "   No form submission found"
        
        echo ""
        echo "🔍 State management:"
        grep -n "useState\|state\|email\|identifier" "$file" | head -10 || echo "   No state management found"
    done
else
    echo "❌ No password reset components found"
fi

# =============================================================================
# STEP 3: API SERVICE ANALYSIS
# =============================================================================

echo ""
echo "📋 STEP 3: API Service Analysis"
echo "==============================="

echo "🔍 Looking for API service files..."

# Find API service files
API_FILES=$(find src -name "*API*" -o -name "*api*" | grep -E "\.(jsx?|tsx?)$")

if [[ -n "$API_FILES" ]]; then
    echo "✅ Found API service files:"
    echo "$API_FILES"
    
    for file in $API_FILES; do
        echo ""
        echo "📄 Analyzing: $file"
        echo "─────────────────────────"
        
        # Check for forgot password method
        echo "🔍 Password reset methods:"
        grep -n -A 10 -B 2 "forgotPassword\|forgot.*password" "$file" || echo "   No forgotPassword method found"
        
        echo ""
        echo "🔍 Base URL configuration:"
        grep -n -A 2 -B 2 "baseURL\|BASE_URL\|nytevibe" "$file" || echo "   No base URL found"
        
        echo ""
        echo "🔍 Request headers:"
        grep -n -A 5 -B 2 "headers\|Content-Type\|Origin" "$file" | head -15 || echo "   No headers found"
        
        echo ""
        echo "🔍 Request body/data format:"
        grep -n -A 3 -B 3 "JSON.stringify\|identifier\|email" "$file" | head -15 || echo "   No request body formatting found"
    done
else
    echo "❌ No API service files found"
fi

# =============================================================================
# STEP 4: NETWORK REQUEST ANALYSIS
# =============================================================================

echo ""
echo "📋 STEP 4: Network Request Analysis"
echo "==================================="

echo "🔍 Checking for hardcoded API endpoints..."
grep -r -n "system.nytevibe.com\|forgot-password\|reset-password" src/ 2>/dev/null | head -10 || echo "❌ No hardcoded endpoints found"

echo ""
echo "🔍 Checking for environment variables..."
if [[ -f ".env" ]]; then
    echo "✅ Found .env file:"
    grep -E "API|URL|BASE" .env | head -5 || echo "   No API-related env vars"
elif [[ -f ".env.local" ]]; then
    echo "✅ Found .env.local file:"
    grep -E "API|URL|BASE" .env.local | head -5 || echo "   No API-related env vars"
else
    echo "❌ No .env files found"
fi

echo ""
echo "🔍 Checking for fetch/axios configuration..."
grep -r -n -A 5 "fetch\|axios" src/ | grep -E "(forgot|password|auth)" | head -10 2>/dev/null || echo "❌ No fetch/axios calls found for password reset"

# =============================================================================
# STEP 5: BUILD AND RUNTIME ANALYSIS
# =============================================================================

echo ""
echo "📋 STEP 5: Build and Runtime Analysis"
echo "====================================="

echo "🔍 Checking build configuration..."
if [[ -f "vite.config.js" ]]; then
    echo "✅ Found Vite config:"
    grep -A 10 -B 5 "proxy\|server\|base" vite.config.js 2>/dev/null || echo "   No relevant config found"
elif [[ -f "webpack.config.js" ]]; then
    echo "✅ Found Webpack config:"
    grep -A 10 -B 5 "proxy\|devServer" webpack.config.js 2>/dev/null || echo "   No relevant config found"
else
    echo "⚠️  No build config found"
fi

echo ""
echo "🔍 Checking package.json scripts..."
if [[ -f "package.json" ]]; then
    echo "📦 Available scripts:"
    grep -A 10 '"scripts"' package.json | head -15
fi

echo ""
echo "🔍 Checking for build errors..."
if [[ -f "dist/index.html" ]] || [[ -f "build/index.html" ]]; then
    echo "✅ Build files exist"
else
    echo "⚠️  No build files found - try: npm run build"
fi

# =============================================================================
# STEP 6: TESTING SIMULATION
# =============================================================================

echo ""
echo "📋 STEP 6: Frontend Testing Simulation"
echo "======================================"

echo "🧪 Simulating password reset flow..."

echo "📝 Expected frontend flow:"
echo "1. User enters email/username in form"
echo "2. Form calls forgotPassword function"
echo "3. Function makes API request to system.nytevibe.com/api/auth/forgot-password"
echo "4. Request includes { 'identifier': 'user@email.com' }"
echo "5. Headers include Content-Type: application/json, Origin: https://blackaxl.com"

echo ""
echo "🔍 Checking what frontend would actually send..."

# Try to extract the actual request format from the code
echo "📄 Request format based on code analysis:"
if [[ -n "$API_FILES" ]]; then
    for file in $API_FILES; do
        echo "   From $file:"
        grep -A 15 "forgotPassword" "$file" | grep -E "fetch|request|JSON|stringify|identifier|email" | head -5
    done
fi

# =============================================================================
# STEP 7: SUMMARY AND RECOMMENDATIONS
# =============================================================================

echo ""
echo "📋 STEP 7: Frontend Analysis Summary"
echo "==================================="

echo "📊 FRONTEND HEALTH CHECK:"

# Component check
if [[ -n "$FORGOT_PASSWORD_FILES" ]]; then
    echo "✅ Password reset components: FOUND"
else
    echo "❌ Password reset components: MISSING"
fi

# API service check
if [[ -n "$API_FILES" ]]; then
    echo "✅ API service files: FOUND"
else
    echo "❌ API service files: MISSING"
fi

# Configuration check
if [[ -f ".env" ]] || [[ -f ".env.local" ]]; then
    echo "✅ Environment configuration: FOUND"
else
    echo "⚠️  Environment configuration: MISSING"
fi

echo ""
echo "🎯 EXPECTED vs ACTUAL REQUEST FORMAT:"
echo "════════════════════════════════════"

echo "Expected by backend:"
echo "  URL: POST https://system.nytevibe.com/api/auth/forgot-password"
echo "  Headers: Content-Type: application/json, Origin: https://blackaxl.com"
echo "  Body: { \"identifier\": \"user@email.com\" }"

echo ""
echo "What frontend appears to send (based on code analysis):"
if [[ -n "$API_FILES" ]]; then
    echo "  Analyzing request format from API files..."
    for file in $API_FILES; do
        if grep -q "forgotPassword" "$file"; then
            echo "  File: $file"
            grep -A 20 "forgotPassword" "$file" | grep -E "fetch|POST|identifier|email|JSON" | head -5 | sed 's/^/    /'
        fi
    done
else
    echo "  ❌ Cannot determine - no API files found"
fi

echo ""
echo "🔧 NEXT STEPS:"
echo "============="
echo "1. ✅ Run backend analysis script: ./backend_analysis.sh"
echo "2. 🔍 Compare frontend request format with backend expectations"
echo "3. 🧪 Test actual network request in browser dev tools"
echo "4. 🔧 Fix any mismatches found"

echo ""
echo "📁 FRONTEND ANALYSIS COMPLETE"
echo "============================"
echo "📅 Completed: $(date)"
