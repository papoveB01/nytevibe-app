#!/bin/bash

# nYtevibe Phase 2 Health Check & Testing Script
# Validates deployment and tests integration with Phase 1 backend

set -e

# Configuration
BACKEND_URL="https://system.nytevibe.com/api"
LOG_FILE="./health_check_$(date +"%Y%m%d_%H%M%S").log"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Logging functions
log() {
    echo -e "${BLUE}[$(date '+%H:%M:%S')]${NC} $1" | tee -a "$LOG_FILE"
}

success() {
    echo -e "${GREEN}✅ $1${NC}" | tee -a "$LOG_FILE"
}

error() {
    echo -e "${RED}❌ $1${NC}" | tee -a "$LOG_FILE"
}

warning() {
    echo -e "${YELLOW}⚠️  $1${NC}" | tee -a "$LOG_FILE"
}

# Function to check file existence and basic structure
check_files() {
    log "Checking Phase 2 file structure..."
    
    local files_to_check=(
        "src/services/emailVerificationAPI.js"
        "src/components/Auth/EmailVerificationView.jsx"
        "package.json"
        "src/router/AppRouter.jsx"
    )
    
    local missing_files=()
    
    for file in "${files_to_check[@]}"; do
        if [ -f "$file" ]; then
            success "Found: $file"
        else
            error "Missing: $file"
            missing_files+=("$file")
        fi
    done
    
    if [ ${#missing_files[@]} -eq 0 ]; then
        success "All required files present"
        return 0
    else
        error "Missing ${#missing_files[@]} required files"
        return 1
    fi
}

# Function to check JavaScript syntax
check_syntax() {
    log "Checking JavaScript syntax..."
    
    if ! command -v node >/dev/null 2>&1; then
        warning "Node.js not available - skipping syntax check"
        return 0
    fi
    
    local js_files=(
        "src/services/emailVerificationAPI.js"
    )
    
    for file in "${js_files[@]}"; do
        if [ -f "$file" ]; then
            if node -c "$file" 2>/dev/null; then
                success "Syntax OK: $file"
            else
                error "Syntax error in: $file"
                return 1
            fi
        fi
    done
    
    success "All JavaScript files have valid syntax"
}

# Function to check API integration content
check_api_integration() {
    log "Checking API integration configuration..."
    
    local api_file="src/services/emailVerificationAPI.js"
    
    if [ ! -f "$api_file" ]; then
        error "API file not found: $api_file"
        return 1
    fi
    
    # Check for required API methods
    local required_methods=(
        "verifyEmail"
        "checkVerificationStatus"
        "resendVerificationEmail"
        "parseVerificationURL"
    )
    
    for method in "${required_methods[@]}"; do
        if grep -q "$method" "$api_file"; then
            success "API method found: $method"
        else
            error "API method missing: $method"
            return 1
        fi
    done
    
    # Check for correct backend URL
    if grep -q "$BACKEND_URL" "$api_file"; then
        success "Backend URL correctly configured: $BACKEND_URL"
    else
        warning "Backend URL may not be configured correctly"
        return 1
    fi
    
    success "API integration configuration looks good"
}

# Function to test backend connectivity
test_backend_connectivity() {
    log "Testing backend connectivity..."
    
    if ! command -v curl >/dev/null 2>&1; then
        warning "curl not available - skipping backend connectivity test"
        return 0
    fi
    
    # Test basic connectivity to backend
    local test_url="${BACKEND_URL}/email/verify-status/test"
    local response_code
    
    log "Testing: $test_url"
    
    response_code=$(curl -s -o /dev/null -w "%{http_code}" "$test_url" --connect-timeout 10 || echo "000")
    
    case $response_code in
        "200"|"404"|"400")
            success "Backend is responding (HTTP $response_code)"
            ;;
        "000")
            error "Cannot connect to backend - network error"
            return 1
            ;;
        *)
            warning "Backend responded with HTTP $response_code"
            ;;
    esac
    
    success "Backend connectivity test completed"
}

# Function to check React component structure
check_component_structure() {
    log "Checking React component structure..."
    
    local component_file="src/components/Auth/EmailVerificationView.jsx"
    
    if [ ! -f "$component_file" ]; then
        error "Component file not found: $component_file"
        return 1
    fi
    
    # Check for required imports and functions
    local required_elements=(
        "import.*EmailVerificationAPI"
        "verifyEmailWithIdAndHash"
        "parseVerificationURL"
        "useState"
        "useEffect"
    )
    
    for element in "${required_elements[@]}"; do
        if grep -q "$element" "$component_file"; then
            success "Component element found: $element"
        else
            error "Component element missing: $element"
            return 1
        fi
    done
    
    success "React component structure looks good"
}

# Function to check for potential conflicts
check_conflicts() {
    log "Checking for potential conflicts..."
    
    # Check for old API imports that might conflict
    local component_file="src/components/Auth/EmailVerificationView.jsx"
    
    if [ -f "$component_file" ]; then
        if grep -q "registrationAPI" "$component_file"; then
            warning "Found references to old registrationAPI - this might cause conflicts"
            log "Consider updating all API calls to use EmailVerificationAPI"
        else
            success "No conflicting API imports found"
        fi
    fi
    
    # Check for duplicate files
    local duplicate_files=(
        "src/services/emailVerificationAPI.js.bak"
        "src/components/Auth/EmailVerificationView.jsx.old"
    )
    
    for file in "${duplicate_files[@]}"; do
        if [ -f "$file" ]; then
            warning "Found potential duplicate file: $file"
        fi
    done
    
    success "Conflict check completed"
}

# Function to test URL parsing functionality
test_url_parsing() {
    log "Testing URL parsing functionality..."
    
    # This would require Node.js to actually test the JavaScript
    if command -v node >/dev/null 2>&1; then
        cat > /tmp/test_url_parsing.js << 'TEST_EOF'
// Test URL parsing functionality
const fs = require('fs');

try {
    // Read the API file
    const apiContent = fs.readFileSync('src/services/emailVerificationAPI.js', 'utf8');
    
    // Basic checks for URL parsing logic
    if (apiContent.includes('parseVerificationURL')) {
        console.log('✅ parseVerificationURL method found');
    } else {
        console.log('❌ parseVerificationURL method not found');
        process.exit(1);
    }
    
    if (apiContent.includes('/verify/([^\/]+)/([^\/]+)')) {
        console.log('✅ Path-based URL parsing regex found');
    } else {
        console.log('❌ Path-based URL parsing regex not found');
        process.exit(1);
    }
    
    console.log('✅ URL parsing functionality appears to be implemented correctly');
} catch (error) {
    console.log('❌ Error testing URL parsing:', error.message);
    process.exit(1);
}
TEST_EOF

        if node /tmp/test_url_parsing.js; then
            success "URL parsing functionality test passed"
        else
            error "URL parsing functionality test failed"
            return 1
        fi
        
        rm -f /tmp/test_url_parsing.js
    else
        warning "Node.js not available - skipping URL parsing functionality test"
    fi
}

# Function to generate test URLs for manual testing
generate_test_info() {
    log "Generating test information..."
    
    echo ""
    echo -e "${YELLOW}========================================${NC}"
    echo -e "${YELLOW}  MANUAL TESTING INFORMATION${NC}"
    echo -e "${YELLOW}========================================${NC}"
    echo ""
    
    echo -e "${BLUE}📧 Test Email Verification URLs:${NC}"
    echo "Format 1 (Phase 1): /verify/USER_ID/HASH"
    echo "Example: /verify/4a0c0252-6c7d-48d7-b603-43bcccc7cdbd/b08b5d75748bcf8d30452eb2900eb90710315417"
    echo ""
    echo "Format 2 (Parameters): /verify?user_id=USER_ID&hash=HASH"
    echo "Example: /verify?user_id=4a0c0252-6c7d-48d7-b603-43bcccc7cdbd&hash=b08b5d75748bcf8d30452eb2900eb90710315417"
    echo ""
    
    echo -e "${BLUE}🔧 Backend API Endpoints:${NC}"
    echo "Verify: $BACKEND_URL/email/verify/{id}/{hash}"
    echo "Status: $BACKEND_URL/email/verify-status/{id}"
    echo "Resend: $BACKEND_URL/email/resend-verification"
    echo ""
    
    echo -e "${BLUE}🧪 Testing Steps:${NC}"
    echo "1. Start your React dev server: npm run dev"
    echo "2. Navigate to verification URL in browser"
    echo "3. Check browser console for detailed logs"
    echo "4. Verify API calls are made to correct endpoints"
    echo "5. Test resend functionality if needed"
    echo ""
    
    echo -e "${BLUE}🔍 Debugging Tips:${NC}"
    echo "• Check browser developer tools console"
    echo "• Look for 'Phase 2' logs in console"
    echo "• Verify network requests in Network tab"
    echo "• Check if CORS is properly configured"
    echo ""
}

# Main health check function
run_health_check() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}  nYtevibe Phase 2 Health Check${NC}"
    echo -e "${BLUE}========================================${NC}"
    
    log "Starting Phase 2 health check..."
    
    local checks_passed=0
    local total_checks=6
    
    # Run all checks
    if check_files; then ((checks_passed++)); fi
    if check_syntax; then ((checks_passed++)); fi
    if check_api_integration; then ((checks_passed++)); fi
    if check_component_structure; then ((checks_passed++)); fi
    if check_conflicts; then ((checks_passed++)); fi
    if test_backend_connectivity; then ((checks_passed++)); fi
    
    echo ""
    echo -e "${BLUE}========================================${NC}"
    
    if [ $checks_passed -eq $total_checks ]; then
        echo -e "${GREEN}  ✅ ALL CHECKS PASSED ($checks_passed/$total_checks)${NC}"
        echo -e "${GREEN}  Phase 2 deployment appears healthy!${NC}"
        
        test_url_parsing
        generate_test_info
        
        echo -e "${GREEN}========================================${NC}"
        success "Health check completed successfully!"
    else
        echo -e "${RED}  ❌ SOME CHECKS FAILED ($checks_passed/$total_checks)${NC}"
        echo -e "${RED}  Please review the issues above${NC}"
        echo -e "${RED}========================================${NC}"
        error "Health check found issues that need attention"
        return 1
    fi
    
    echo ""
    echo -e "${YELLOW}📄 Detailed log saved to: $LOG_FILE${NC}"
}

# Script entry point
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    run_health_check
fi
