#!/bin/bash

# React Frontend Configuration Checker for nYtevibe
# Searches React codebase for API configurations and endpoint issues

echo "🔍 React Frontend Configuration Checker"
echo "======================================="
echo "Searching for API configurations and endpoint issues..."
echo "Date: $(date)"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Function to print colored output
print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_found() {
    echo -e "${PURPLE}🔍 $1${NC}"
}

# Check if we're in the right directory
if [ ! -d "src" ] && [ ! -f "package.json" ]; then
    print_error "This doesn't appear to be a React project directory."
    echo "Please run this script from your React project root (where package.json is located)."
    echo "Current directory: $(pwd)"
    echo ""
    echo "Looking for React project indicators..."
    find . -name "package.json" -type f 2>/dev/null | head -5
    echo ""
    exit 1
fi

print_success "Found React project structure"
echo ""

# 1. Project Structure Analysis
echo "1. 📁 Project Structure Analysis"
echo "-------------------------------"

if [ -f "package.json" ]; then
    print_success "package.json found"
    echo "Project name: $(cat package.json | grep '"name"' | head -1 | sed 's/.*"name": *"\([^"]*\)".*/\1/')"
    
    # Check for React
    if grep -q "react" package.json; then
        print_success "React dependency confirmed"
    else
        print_warning "React dependency not found in package.json"
    fi
else
    print_warning "package.json not found"
fi

if [ -d "src" ]; then
    print_success "src/ directory found"
    echo "Source files count: $(find src -name "*.js" -o -name "*.jsx" -o -name "*.ts" -o -name "*.tsx" | wc -l)"
else
    print_warning "src/ directory not found"
fi

echo ""

# 2. Environment Configuration Check
echo "2. 🌍 Environment Configuration Check"
echo "------------------------------------"

ENV_FILES=(".env" ".env.local" ".env.development" ".env.production" ".env.development.local" ".env.production.local")

for env_file in "${ENV_FILES[@]}"; do
    if [ -f "$env_file" ]; then
        print_found "Found $env_file"
        
        # Check for API URLs
        if grep -q -E "(API_URL|REACT_APP_API|BASE_URL|API_BASE)" "$env_file"; then
            echo "  API configurations:"
            grep -E "(API_URL|REACT_APP_API|BASE_URL|API_BASE)" "$env_file" | sed 's/^/    /'
        fi
        
        # Check for specific endpoints
        if grep -q -E "(login|register|auth)" "$env_file"; then
            echo "  Auth-related configurations:"
            grep -i -E "(login|register|auth)" "$env_file" | sed 's/^/    /'
        fi
        echo ""
    fi
done

if [ ${#ENV_FILES[@]} -eq 0 ] || ! ls .env* 1> /dev/null 2>&1; then
    print_warning "No environment files found"
fi

echo ""

# 3. API Configuration Files Search
echo "3. 🔧 API Configuration Files Search"
echo "-----------------------------------"

# Common API configuration file patterns
API_FILE_PATTERNS=(
    "api.js" "api.ts" "api.jsx" "api.tsx"
    "apiService.js" "apiService.ts" 
    "apiClient.js" "apiClient.ts"
    "auth.js" "auth.ts" "auth.jsx" "auth.tsx"
    "authService.js" "authService.ts"
    "config.js" "config.ts" "config.jsx" "config.tsx"
    "constants.js" "constants.ts"
    "endpoints.js" "endpoints.ts"
    "services.js" "services.ts"
)

echo "Searching for API configuration files..."

for pattern in "${API_FILE_PATTERNS[@]}"; do
    found_files=$(find . -name "$pattern" -type f 2>/dev/null)
    if [ ! -z "$found_files" ]; then
        print_found "Found: $pattern"
        echo "$found_files" | while read file; do
            echo "  📁 $file"
            
            # Check file contents for API URLs
            if grep -q -E "(system\.nytevibe\.com|blackaxl\.com|localhost|api)" "$file"; then
                echo "    🌐 Contains API references:"
                grep -n -E "(system\.nytevibe\.com|blackaxl\.com|localhost|api)" "$file" | head -5 | sed 's/^/      /'
            fi
            
            # Check for auth endpoints
            if grep -q -E "(auth/login|auth/register|/login|/register)" "$file"; then
                echo "    🔐 Contains auth endpoints:"
                grep -n -E "(auth/login|auth/register|/login|/register)" "$file" | sed 's/^/      /'
            fi
            echo ""
        done
    fi
done

echo ""

# 4. Endpoint Configuration Analysis
echo "4. 🎯 Endpoint Configuration Analysis"
echo "------------------------------------"

echo "Searching for authentication endpoints..."

# Search for login endpoints (potential problem)
LOGIN_REFS=$(find . -name "*.js" -o -name "*.jsx" -o -name "*.ts" -o -name "*.tsx" | xargs grep -l "auth/login\|/login" 2>/dev/null)
if [ ! -z "$LOGIN_REFS" ]; then
    print_error "Found references to login endpoints (potential issue):"
    echo "$LOGIN_REFS" | while read file; do
        echo "  📁 $file"
        grep -n -E "(auth/login|/login)" "$file" | sed 's/^/    /'
        echo ""
    done
else
    print_success "No problematic login endpoint references found"
fi

# Search for register endpoints (should be correct)
REGISTER_REFS=$(find . -name "*.js" -o -name "*.jsx" -o -name "*.ts" -o -name "*.tsx" | xargs grep -l "auth/register\|/register" 2>/dev/null)
if [ ! -z "$REGISTER_REFS" ]; then
    print_success "Found references to register endpoints:"
    echo "$REGISTER_REFS" | while read file; do
        echo "  📁 $file"
        grep -n -E "(auth/register|/register)" "$file" | sed 's/^/    /'
        echo ""
    done
else
    print_warning "No register endpoint references found"
fi

echo ""

# 5. Fetch/Axios API Calls Analysis
echo "5. 📡 Fetch/Axios API Calls Analysis"
echo "-----------------------------------"

echo "Searching for HTTP API calls..."

# Search for fetch calls
FETCH_FILES=$(find . -name "*.js" -o -name "*.jsx" -o -name "*.ts" -o -name "*.tsx" | xargs grep -l "fetch\|axios" 2>/dev/null)
if [ ! -z "$FETCH_FILES" ]; then
    print_found "Files with HTTP calls:"
    echo "$FETCH_FILES" | while read file; do
        echo "  📁 $file"
        
        # Show fetch/axios calls with URLs
        grep -n -A 2 -B 1 -E "(fetch\(|axios\.|post\(|get\()" "$file" | grep -E "(fetch|axios|http|https|/api)" | head -10 | sed 's/^/    /'
        echo ""
    done
else
    print_warning "No HTTP API calls found"
fi

echo ""

# 6. Registration Form Components
echo "6. 📝 Registration Form Components"
echo "---------------------------------"

echo "Searching for registration-related components..."

# Search for registration components
REG_COMPONENTS=$(find . -name "*.js" -o -name "*.jsx" -o -name "*.ts" -o -name "*.tsx" | xargs grep -l -i "register\|signup\|createaccount" 2>/dev/null)
if [ ! -z "$REG_COMPONENTS" ]; then
    print_found "Registration-related components:"
    echo "$REG_COMPONENTS" | while read file; do
        echo "  📁 $file"
        
        # Show registration-related functions
        grep -n -i -E "(register|signup|createaccount|handleregist|submitregist)" "$file" | head -5 | sed 's/^/    /'
        echo ""
    done
else
    print_warning "No registration components found"
fi

echo ""

# 7. Configuration Objects and Constants
echo "7. 📋 Configuration Objects and Constants"
echo "----------------------------------------"

echo "Searching for configuration objects..."

# Search for API configuration objects
CONFIG_REFS=$(find . -name "*.js" -o -name "*.jsx" -o -name "*.ts" -o -name "*.tsx" | xargs grep -l -E "(API_CONFIG|baseURL|BASE_URL|apiUrl|endpoints)" 2>/dev/null)
if [ ! -z "$CONFIG_REFS" ]; then
    print_found "Configuration objects found:"
    echo "$CONFIG_REFS" | while read file; do
        echo "  📁 $file"
        
        # Show configuration definitions
        grep -n -A 5 -B 2 -E "(API_CONFIG|baseURL|BASE_URL|apiUrl|endpoints)" "$file" | head -15 | sed 's/^/    /'
        echo ""
    done
else
    print_warning "No configuration objects found"
fi

echo ""

# 8. Problem Detection Summary
echo "8. 🚨 Problem Detection Summary"
echo "------------------------------"

PROBLEMS_FOUND=0

# Check for login endpoint usage in registration context
LOGIN_IN_REG=$(find . -name "*.js" -o -name "*.jsx" -o -name "*.ts" -o -name "*.tsx" | xargs grep -l "register\|signup" 2>/dev/null | xargs grep -l "auth/login\|/login" 2>/dev/null)
if [ ! -z "$LOGIN_IN_REG" ]; then
    print_error "PROBLEM DETECTED: Files with registration logic using login endpoints!"
    echo "$LOGIN_IN_REG" | while read file; do
        echo "  ❌ $file"
    done
    PROBLEMS_FOUND=$((PROBLEMS_FOUND + 1))
    echo ""
fi

# Check for missing register endpoints
if [ -z "$REGISTER_REFS" ]; then
    print_error "PROBLEM DETECTED: No register endpoint references found!"
    PROBLEMS_FOUND=$((PROBLEMS_FOUND + 1))
fi

# Check for hardcoded wrong URLs
WRONG_URLS=$(find . -name "*.js" -o -name "*.jsx" -o -name "*.ts" -o -name "*.tsx" | xargs grep -n "system\.nytevibe\.com.*login" 2>/dev/null)
if [ ! -z "$WRONG_URLS" ]; then
    print_error "PROBLEM DETECTED: Hardcoded login URLs found!"
    echo "$WRONG_URLS" | sed 's/^/  ❌ /'
    PROBLEMS_FOUND=$((PROBLEMS_FOUND + 1))
    echo ""
fi

if [ $PROBLEMS_FOUND -eq 0 ]; then
    print_success "No obvious configuration problems detected"
else
    print_error "Found $PROBLEMS_FOUND potential problem(s)"
fi

echo ""

# 9. Recommendations
echo "9. 💡 Recommendations"
echo "--------------------"

echo "Based on the analysis above:"
echo ""

if [ ! -z "$LOGIN_IN_REG" ]; then
    echo "🔧 IMMEDIATE ACTION NEEDED:"
    echo "  - Files using 'auth/login' for registration must be changed to 'auth/register'"
    echo "  - Check the files listed in the Problem Detection section"
    echo ""
fi

echo "🔍 Manual Review Needed:"
echo "  - Review all files with HTTP calls (section 5)"
echo "  - Check configuration objects (section 7)"
echo "  - Verify registration components are using correct endpoints (section 6)"
echo ""

echo "✅ Correct Configuration Should Be:"
echo "  - Endpoint: https://system.nytevibe.com/api/auth/register"
echo "  - Method: POST"
echo "  - Headers: Content-Type: application/json, Accept: application/json"
echo ""

echo "🧪 Next Steps:"
echo "  1. Fix any files showing login endpoints for registration"
echo "  2. Run the browser debugging script on blackaxl.com"
echo "  3. Test registration with correct endpoint"

echo ""
echo "🏁 Configuration Check Complete!"
echo "================================"

# Create a summary file
SUMMARY_FILE="frontend-config-analysis.txt"
echo "Configuration analysis saved to: $SUMMARY_FILE"

{
    echo "nYtevibe Frontend Configuration Analysis"
    echo "======================================="
    echo "Generated: $(date)"
    echo ""
    echo "Problems Found: $PROBLEMS_FOUND"
    echo ""
    if [ ! -z "$LOGIN_IN_REG" ]; then
        echo "Files with login endpoints in registration context:"
        echo "$LOGIN_IN_REG"
        echo ""
    fi
    echo "All configuration files found:"
    for pattern in "${API_FILE_PATTERNS[@]}"; do
        find . -name "$pattern" -type f 2>/dev/null
    done
} > "$SUMMARY_FILE"

echo "Run with: bash react_config_check.sh"
