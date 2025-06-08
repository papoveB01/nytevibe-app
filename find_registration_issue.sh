#!/bin/bash

# Find the actual registration component that's calling the wrong endpoint

echo "🔍 Finding Registration Component with Wrong Endpoint"
echo "===================================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

# 1. Find all registration-related files
echo "1. 🔍 Finding Registration Components"
echo "-----------------------------------"

REGISTRATION_FILES=$(find . -type f \( -name "*.js" -o -name "*.jsx" -o -name "*.ts" -o -name "*.tsx" \) | xargs grep -l -i -E "(register|signup|createaccount)" 2>/dev/null | grep -v node_modules)

if [ ! -z "$REGISTRATION_FILES" ]; then
    print_success "Found registration-related files:"
    echo "$REGISTRATION_FILES" | while read file; do
        echo "  📁 $file"
        
        # Check if this file contains any auth endpoints
        if grep -q -E "(auth/login|auth/register|/login|/register)" "$file"; then
            echo "    🔗 Contains auth endpoints:"
            grep -n -E "(auth/login|auth/register|/login|/register)" "$file" | sed 's/^/      /'
        fi
        echo ""
    done
else
    print_warning "No registration-related files found"
fi

echo ""

# 2. Search for the problematic pattern: registration logic using login endpoint
echo "2. 🚨 Finding Registration Code Using Login Endpoint"
echo "--------------------------------------------------"

# Look for files that have both registration terms AND login endpoints
PROBLEMATIC_FILES=""

echo "$REGISTRATION_FILES" | while read file; do
    if [ ! -z "$file" ] && grep -q -E "(auth/login|/login)" "$file"; then
        echo -e "${RED}❌ FOUND PROBLEM: $file${NC}"
        echo "   Contains registration logic but uses login endpoint:"
        
        # Show the problematic lines
        grep -n -C 2 -E "(auth/login|/login)" "$file" | sed 's/^/     /'
        echo ""
        
        # Show registration-related lines for context
        echo "   Registration context in same file:"
        grep -n -i -E "(register|signup|createaccount)" "$file" | head -3 | sed 's/^/     /'
        echo ""
        echo "   🔧 FIX NEEDED: Change 'auth/login' to 'auth/register' in this file"
        echo ""
    fi
done

echo ""

# 3. Look for forms that might be misconfigured
echo "3. 📝 Checking Form Components"
echo "-----------------------------"

FORM_FILES=$(find . -type f \( -name "*.js" -o -name "*.jsx" -o -name "*.ts" -o -name "*.tsx" \) | xargs grep -l -i -E "(form|submit)" 2>/dev/null | grep -v node_modules)

echo "Checking form components for endpoint issues..."

echo "$FORM_FILES" | while read file; do
    # Check if form has registration context but wrong endpoint
    if grep -q -i -E "(register|signup)" "$file" && grep -q -E "(auth/login|/login)" "$file"; then
        echo -e "${RED}❌ PROBLEMATIC FORM: $file${NC}"
        echo "   Has registration context but uses login endpoint:"
        grep -n -C 1 -E "(auth/login|/login)" "$file" | sed 's/^/     /'
        echo ""
    fi
done

echo ""

# 4. Check for API service files that might have wrong configuration
echo "4. 🔧 Checking API Service Files"
echo "-------------------------------"

API_FILES=$(find . -type f \( -name "*api*" -o -name "*service*" -o -name "*auth*" \) \( -name "*.js" -o -name "*.jsx" -o -name "*.ts" -o -name "*.tsx" \) | grep -v node_modules)

if [ ! -z "$API_FILES" ]; then
    echo "$API_FILES" | while read file; do
        echo "📁 Checking: $file"
        
        # Look for registration functions using wrong endpoint
        if grep -q -i -E "(register|signup)" "$file"; then
            echo "  Contains registration logic:"
            grep -n -i -E "(register|signup)" "$file" | sed 's/^/    /'
            
            # Check what endpoint it uses
            if grep -q -E "(auth/login|/login)" "$file"; then
                echo -e "  ${RED}❌ USES LOGIN ENDPOINT - WRONG!${NC}"
                grep -n -E "(auth/login|/login)" "$file" | sed 's/^/    /'
            elif grep -q -E "(auth/register|/register)" "$file"; then
                echo -e "  ${GREEN}✅ Uses register endpoint - CORRECT${NC}"
                grep -n -E "(auth/register|/register)" "$file" | sed 's/^/    /'
            else
                echo -e "  ${YELLOW}⚠️  No clear endpoint found${NC}"
            fi
        fi
        echo ""
    done
else
    print_warning "No API service files found"
fi

echo ""

# 5. Search for fetch/axios calls in registration context
echo "5. 📡 Registration HTTP Calls Analysis"
echo "------------------------------------"

# Find files with registration terms that also have fetch/axios
REG_HTTP_FILES=$(echo "$REGISTRATION_FILES" | xargs grep -l -E "(fetch|axios)" 2>/dev/null)

if [ ! -z "$REG_HTTP_FILES" ]; then
    echo "$REG_HTTP_FILES" | while read file; do
        echo "📁 $file - Has registration logic with HTTP calls:"
        
        # Show fetch/axios calls with context
        grep -n -B 2 -A 4 -E "(fetch\(|axios\.)" "$file" | sed 's/^/  /'
        echo ""
    done
else
    print_warning "No registration files with HTTP calls found"
fi

echo ""

# 6. Quick fix suggestions
echo "6. 🔧 Quick Fix Suggestions"
echo "--------------------------"

print_info "Based on the analysis above, here's what to fix:"
echo ""

echo "📝 Files that need fixing:"
echo "$REGISTRATION_FILES" | while read file; do
    if [ ! -z "$file" ] && grep -q -E "(auth/login|/login)" "$file"; then
        echo "  ❌ $file"
        echo "     Change: auth/login → auth/register"
        echo "     Lines to fix:"
        grep -n -E "(auth/login|/login)" "$file" | sed 's/^/       /'
        echo ""
    fi
done

echo ""
print_success "Search complete!"

echo ""
echo "🎯 SUMMARY:"
echo "=========="
echo "1. Login.jsx and LoginTest.jsx using auth/login is CORRECT"
echo "2. Look for registration components above that incorrectly use auth/login"
echo "3. Fix any registration files to use auth/register instead"
echo "4. The registration form is calling the wrong endpoint"

echo ""
echo "💡 Next step: Fix the files identified above, then test registration again"
