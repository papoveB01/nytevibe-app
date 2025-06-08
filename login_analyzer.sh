#!/bin/bash

# nYtevibe Login Verification Issue Analyzer
# Analyzes login logic vs verification enhancements to find the disconnect

echo "🔍 nYtevibe Login Verification Issue Analyzer"
echo "============================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Project structure detection
echo -e "${BLUE}📁 Detecting project structure...${NC}"
echo ""

# Find Laravel backend directory
BACKEND_DIR=""
if [ -d "." ] && [ -f "artisan" ]; then
    BACKEND_DIR="."
elif [ -d "backend" ] && [ -f "backend/artisan" ]; then
    BACKEND_DIR="backend"
elif [ -d "api" ] && [ -f "api/artisan" ]; then
    BACKEND_DIR="api"
elif [ -d "laravel" ] && [ -f "laravel/artisan" ]; then
    BACKEND_DIR="laravel"
fi

# Find React frontend directory
FRONTEND_DIR=""
if [ -f "package.json" ] && grep -q "react" package.json 2>/dev/null; then
    FRONTEND_DIR="."
elif [ -d "frontend" ] && [ -f "frontend/package.json" ]; then
    FRONTEND_DIR="frontend"
elif [ -d "client" ] && [ -f "client/package.json" ]; then
    FRONTEND_DIR="client"
elif [ -d "react" ] && [ -f "react/package.json" ]; then
    FRONTEND_DIR="react"
fi

echo -e "Backend Directory: ${GREEN}${BACKEND_DIR:-'Not Found'}${NC}"
echo -e "Frontend Directory: ${GREEN}${FRONTEND_DIR:-'Not Found'}${NC}"
echo ""

# Create analysis directory
mkdir -p login_analysis_$(date +%Y%m%d_%H%M%S)
ANALYSIS_DIR="login_analysis_$(date +%Y%m%d_%H%M%S)"
cd "$ANALYSIS_DIR"

echo -e "${PURPLE}📋 Creating comprehensive analysis in: ${ANALYSIS_DIR}${NC}"
echo ""

# Function to search and analyze files
analyze_files() {
    local search_dir="$1"
    local file_pattern="$2"
    local search_terms="$3"
    local output_file="$4"
    local description="$5"
    
    echo -e "${YELLOW}🔍 Analyzing: ${description}${NC}"
    echo "# $description" > "$output_file"
    echo "# Generated: $(date)" >> "$output_file"
    echo "# Search Directory: $search_dir" >> "$output_file"
    echo "# File Pattern: $file_pattern" >> "$output_file"
    echo "# Search Terms: $search_terms" >> "$output_file"
    echo "" >> "$output_file"
    
    if [ -d "../$search_dir" ]; then
        find "../$search_dir" -name "$file_pattern" -type f | while read -r file; do
            if grep -l "$search_terms" "$file" 2>/dev/null; then
                echo "## File: $file" >> "$output_file"
                echo "### Content:" >> "$output_file"
                echo '```' >> "$output_file"
                cat "$file" >> "$output_file"
                echo '```' >> "$output_file"
                echo "" >> "$output_file"
                echo "### Relevant Lines:" >> "$output_file"
                echo '```' >> "$output_file"
                grep -n -i -A 3 -B 3 "$search_terms" "$file" 2>/dev/null >> "$output_file"
                echo '```' >> "$output_file"
                echo "" >> "$output_file"
                echo "---" >> "$output_file"
                echo "" >> "$output_file"
            fi
        done
    else
        echo "Directory $search_dir not found" >> "$output_file"
    fi
}

# 1. Backend Login Controllers and Middleware
echo -e "${BLUE}🔐 Analyzing Backend Login Logic...${NC}"

if [ -n "$BACKEND_DIR" ]; then
    # Login Controllers
    analyze_files "$BACKEND_DIR" "*.php" "login\|authenticate\|signin\|email.*verify\|verified\|MustVerifyEmail" "01_backend_login_controllers.md" "Backend Login Controllers"
    
    # Authentication Middleware
    analyze_files "$BACKEND_DIR" "*.php" "middleware\|auth\|verified\|email.*verification" "02_backend_auth_middleware.md" "Backend Authentication Middleware"
    
    # User Model
    analyze_files "$BACKEND_DIR" "User.php" "." "03_backend_user_model.md" "Backend User Model"
    
    # Routes
    analyze_files "$BACKEND_DIR" "*.php" "Route\|login\|auth\|verify" "04_backend_routes.md" "Backend Routes"
    
    # Config files
    analyze_files "$BACKEND_DIR" "*.php" "auth\|verification\|email" "05_backend_config.md" "Backend Configuration"
fi

# 2. Frontend Login Components
echo -e "${BLUE}🖥️ Analyzing Frontend Login Logic...${NC}"

if [ -n "$FRONTEND_DIR" ]; then
    # Login Components
    analyze_files "$FRONTEND_DIR" "*.js" "login\|signin\|authenticate\|verify\|verification" "06_frontend_login_components.md" "Frontend Login Components"
    analyze_files "$FRONTEND_DIR" "*.jsx" "login\|signin\|authenticate\|verify\|verification" "07_frontend_login_jsx.md" "Frontend Login JSX Components"
    
    # API Services
    analyze_files "$FRONTEND_DIR" "*.js" "api\|axios\|fetch.*login\|auth" "08_frontend_api_services.md" "Frontend API Services"
    
    # Auth utilities
    analyze_files "$FRONTEND_DIR" "*.js" "auth\|token\|session\|verify" "09_frontend_auth_utils.md" "Frontend Auth Utilities"
fi

# 3. Verification Enhancement Files Analysis
echo -e "${BLUE}📧 Analyzing Email Verification Enhancements...${NC}"

if [ -n "$BACKEND_DIR" ]; then
    # Custom Email Notification
    analyze_files "$BACKEND_DIR" "*CustomVerifyEmail*" "." "10_custom_verify_email.md" "Custom Email Verification Notification"
    
    # Verification API endpoints
    analyze_files "$BACKEND_DIR" "*.php" "email.*verify\|verify.*email" "11_verification_api.md" "Email Verification API Endpoints"
fi

if [ -n "$FRONTEND_DIR" ]; then
    # Email Verification Components
    analyze_files "$FRONTEND_DIR" "*EmailVerification*" "." "12_frontend_verification.md" "Frontend Email Verification Components"
    
    # ExistingApp modifications
    analyze_files "$FRONTEND_DIR" "*ExistingApp*" "." "13_existing_app_modifications.md" "ExistingApp.jsx Modifications"
fi

# 4. Database Schema Analysis
echo -e "${BLUE}🗄️ Analyzing Database Schema...${NC}"

if [ -n "$BACKEND_DIR" ]; then
    # Migration files
    analyze_files "$BACKEND_DIR" "*.php" "email_verified_at\|verified\|verification" "14_database_migrations.md" "Database Migrations"
    
    # Model relationships
    analyze_files "$BACKEND_DIR" "*.php" "HasEmailVerification\|MustVerifyEmail\|email_verified_at" "15_model_verification.md" "Model Email Verification"
fi

# 5. Error Messages and Validation
echo -e "${BLUE}⚠️ Analyzing Error Messages...${NC}"

# Search for the specific error message
if [ -n "$BACKEND_DIR" ]; then
    find "../$BACKEND_DIR" -name "*.php" -type f | xargs grep -l "check your email\|email before signin\|verify.*email.*signin" 2>/dev/null > error_message_files.txt
    
    echo "# Error Message Analysis" > "16_error_messages.md"
    echo "# Files containing 'check your email before signin' or similar" >> "16_error_messages.md"
    echo "" >> "16_error_messages.md"
    
    if [ -s error_message_files.txt ]; then
        while read -r file; do
            echo "## File: $file" >> "16_error_messages.md"
            echo '```php' >> "16_error_messages.md"
            grep -n -i -A 5 -B 5 "check your email\|email before signin\|verify.*email.*signin" "$file" 2>/dev/null >> "16_error_messages.md"
            echo '```' >> "16_error_messages.md"
            echo "" >> "16_error_messages.md"
        done < error_message_files.txt
    else
        echo "No files found with the specific error message" >> "16_error_messages.md"
    fi
fi

if [ -n "$FRONTEND_DIR" ]; then
    find "../$FRONTEND_DIR" -name "*.js" -o -name "*.jsx" -type f | xargs grep -l "check your email\|email before signin\|verify.*email.*signin" 2>/dev/null >> error_message_files.txt
    
    echo "## Frontend Error Messages" >> "16_error_messages.md"
    if [ -s error_message_files.txt ]; then
        while read -r file; do
            if [[ "$file" == *"$FRONTEND_DIR"* ]]; then
                echo "### File: $file" >> "16_error_messages.md"
                echo '```javascript' >> "16_error_messages.md"
                grep -n -i -A 5 -B 5 "check your email\|email before signin\|verify.*email.*signin" "$file" 2>/dev/null >> "16_error_messages.md"
                echo '```' >> "16_error_messages.md"
                echo "" >> "16_error_messages.md"
            fi
        done < error_message_files.txt
    fi
fi

# 6. Generate Issue Analysis Report
echo -e "${BLUE}📊 Generating Issue Analysis...${NC}"

cat > "00_ISSUE_ANALYSIS_REPORT.md" << 'EOF'
# nYtevibe Login Verification Issue Analysis Report

## Problem Statement
User receives "Please check your email before signin" error after successful email verification.

## Verification Enhancement Summary (From Implementation Report)
- ✅ Custom email notification redirecting to frontend
- ✅ Beautiful UI verification flow
- ✅ API endpoints working (200ms response time)
- ✅ Success confetti celebration
- ✅ Email verification completing successfully

## Potential Root Causes

### 1. Database Field Mismatch
**Issue**: Login logic checking `email_verified_at` field but verification API not updating it properly
**Check**: Compare verification API response vs database update

### 2. Authentication Middleware Conflict
**Issue**: Laravel's built-in `verified` middleware still active
**Check**: Routes, middleware stack, User model implementations

### 3. Frontend Session State
**Issue**: Verification success not updating frontend auth state
**Check**: Login component not recognizing verification status

### 4. API Response Timing
**Issue**: Database update happening but not reflected in next login attempt
**Check**: Transaction timing, cache invalidation

### 5. User Model Configuration
**Issue**: CustomVerifyEmail notification vs built-in Laravel verification
**Check**: User model verification methods, traits

## Investigation Priority
1. Find exact error message location
2. Trace login validation logic
3. Compare verification API database updates
4. Check middleware and route configuration
5. Analyze frontend auth state management

## Files to Review Immediately
- Backend login controllers (authentication logic)
- User model (verification methods)
- Verification API (database update logic)
- Frontend login components
- Authentication middleware

## Next Steps
1. Review generated analysis files
2. Identify the exact location of "check your email" error
3. Compare verification success vs login verification check
4. Create targeted fix based on findings
EOF

# 7. Create Quick Fix Suggestions
echo -e "${BLUE}🛠️ Generating Quick Fix Suggestions...${NC}"

cat > "99_QUICK_FIX_SUGGESTIONS.md" << 'EOF'
# Quick Fix Suggestions

## Most Likely Issues & Solutions

### Issue 1: Middleware Still Checking Verification
**Problem**: Route has `verified` middleware but verification process changed
**Solution**: 
```php
// In routes/web.php or api.php - Remove 'verified' middleware
Route::post('/login', [LoginController::class, 'login']); // Remove ->middleware('verified')
```

### Issue 2: Login Controller Manually Checking Verification
**Problem**: Login logic manually checking `email_verified_at`
**Solution**:
```php
// In LoginController - Remove or update verification check
// Look for: if (!$user->hasVerifiedEmail())
// Replace with verification from your API
```

### Issue 3: User Model Method Override Needed
**Problem**: Login using built-in `hasVerifiedEmail()` method
**Solution**:
```php
// In User.php model
public function hasVerifiedEmail()
{
    return !is_null($this->email_verified_at);
}
```

### Issue 4: Database Field Not Updated
**Problem**: Verification API not updating `email_verified_at` field
**Solution**:
```php
// In verification API endpoint - Add database update
$user->markEmailAsVerified(); // or
$user->email_verified_at = now();
$user->save();
```

### Issue 5: Frontend Auth State Not Updated
**Problem**: Frontend login component caching old verification state
**Solution**:
```javascript
// Clear auth state after verification
localStorage.removeItem('authToken');
// Or refresh user data before login
```

## Immediate Action Plan
1. Check routes for `verified` middleware
2. Find login controller verification logic
3. Verify API endpoint updates database
4. Test with fresh browser session
5. Check User model verification methods
EOF

# 8. Create targeted search for common Laravel verification patterns
echo -e "${BLUE}🎯 Searching for Common Laravel Verification Patterns...${NC}"

if [ -n "$BACKEND_DIR" ]; then
    echo "# Laravel Verification Pattern Analysis" > "17_laravel_patterns.md"
    echo "" >> "17_laravel_patterns.md"
    
    echo "## Searching for HasEmailVerification trait usage..." >> "17_laravel_patterns.md"
    find "../$BACKEND_DIR" -name "*.php" -exec grep -l "HasEmailVerification\|MustVerifyEmail" {} \; >> "17_laravel_patterns.md"
    
    echo "" >> "17_laravel_patterns.md"
    echo "## Searching for verified middleware..." >> "17_laravel_patterns.md"
    find "../$BACKEND_DIR" -name "*.php" -exec grep -n "verified\|VerifyCsrfToken" {} \; >> "17_laravel_patterns.md"
    
    echo "" >> "17_laravel_patterns.md"
    echo "## Searching for hasVerifiedEmail() usage..." >> "17_laravel_patterns.md"
    find "../$BACKEND_DIR" -name "*.php" -exec grep -n -A 3 -B 3 "hasVerifiedEmail\|email_verified_at" {} \; >> "17_laravel_patterns.md"
fi

# Final summary
echo ""
echo -e "${GREEN}✅ Analysis Complete!${NC}"
echo ""
echo -e "${YELLOW}📁 Analysis files created in: ${ANALYSIS_DIR}${NC}"
echo ""
echo -e "${PURPLE}🔍 Key files to review:${NC}"
echo -e "  📋 ${BLUE}00_ISSUE_ANALYSIS_REPORT.md${NC} - Start here"
echo -e "  🛠️ ${BLUE}99_QUICK_FIX_SUGGESTIONS.md${NC} - Immediate solutions"
echo -e "  ⚠️ ${BLUE}16_error_messages.md${NC} - Error message locations"
echo -e "  🔐 ${BLUE}01_backend_login_controllers.md${NC} - Login logic"
echo -e "  👤 ${BLUE}03_backend_user_model.md${NC} - User verification methods"
echo ""
echo -e "${RED}🎯 Most Likely Issue:${NC}"
echo -e "  Login controller or middleware still checking built-in Laravel"
echo -e "  email verification while you've implemented custom verification"
echo ""
echo -e "${GREEN}🚀 Next Steps:${NC}"
echo -e "  1. Review the analysis files"
echo -e "  2. Find the exact error message location"
echo -e "  3. Apply suggested fixes"
echo -e "  4. Test with fresh browser session"
echo ""

# Return to original directory
cd ..

echo -e "${BLUE}Analysis saved in: ${ANALYSIS_DIR}/${NC}"
EOF
