#!/bin/bash

# React App Level Error Analysis Script
# This script analyzes the codebase to find the source of "Cannot read properties of null (reading 'level')" error
# No modifications will be made - analysis only

echo "================================================"
echo "React App Level Error Analysis Script"
echo "Searching for the source of '.level' null error"
echo "Analysis started at: $(date)"
echo "================================================"
echo ""

# Define colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Create analysis results directory
RESULTS_DIR="analysis_results_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$RESULTS_DIR"

echo -e "${BLUE}Results will be saved to: $RESULTS_DIR${NC}"
echo ""

# Function to write to both console and file
log_result() {
    echo -e "$1" | tee -a "$RESULTS_DIR/analysis_report.txt"
}

# 1. Search for all .level property access
log_result "${YELLOW}=== SEARCHING FOR .level PROPERTY ACCESS ===${NC}"
log_result "Files containing '.level':"
echo "" >> "$RESULTS_DIR/level_access.txt"

find src -type f \( -name "*.js" -o -name "*.jsx" -o -name "*.ts" -o -name "*.tsx" \) -exec grep -Hn "\.level" {} \; 2>/dev/null | while read -r line; do
    echo "$line" >> "$RESULTS_DIR/level_access.txt"
    log_result "  $line"
done

# 2. Search for user object patterns
log_result ""
log_result "${YELLOW}=== SEARCHING FOR USER OBJECT ACCESS PATTERNS ===${NC}"
echo "" >> "$RESULTS_DIR/user_patterns.txt"

# Common user object access patterns
patterns=("user\.level" "user\[" "state\.user" "currentUser" "auth\.user" "profile\.level" "member\.level")

for pattern in "${patterns[@]}"; do
    log_result "Pattern: $pattern"
    find src -type f \( -name "*.js" -o -name "*.jsx" -o -name "*.ts" -o -name "*.tsx" \) -exec grep -Hn "$pattern" {} \; 2>/dev/null | while read -r line; do
        echo "$line" >> "$RESULTS_DIR/user_patterns.txt"
        log_result "  $line"
    done
done

# 3. Analyze Terms-related files
log_result ""
log_result "${YELLOW}=== ANALYZING TERMS-RELATED FILES ===${NC}"
echo "" >> "$RESULTS_DIR/terms_analysis.txt"

# Check TermsAndConditions component
if [ -f "src/components/TermsAndConditions.jsx" ]; then
    log_result "TermsAndConditions.jsx found"
    echo "=== TermsAndConditions.jsx imports ===" >> "$RESULTS_DIR/terms_analysis.txt"
    grep -E "^import|^const.*=.*require" src/components/TermsAndConditions.jsx >> "$RESULTS_DIR/terms_analysis.txt"
    
    # Check for context usage
    if grep -q "useApp\|useAuth\|useContext" src/components/TermsAndConditions.jsx; then
        log_result "  ${RED}WARNING: TermsAndConditions uses context hooks${NC}"
    else
        log_result "  ${GREEN}OK: TermsAndConditions doesn't use context hooks${NC}"
    fi
fi

# 4. Check ExistingApp.jsx for terms view handling
log_result ""
log_result "${YELLOW}=== CHECKING EXISTINGAPP.JSX ===${NC}"
echo "" >> "$RESULTS_DIR/app_analysis.txt"

if [ -f "src/ExistingApp.jsx" ]; then
    # Check terms view rendering
    grep -n "currentView === 'terms'" src/ExistingApp.jsx >> "$RESULTS_DIR/app_analysis.txt"
    
    # Check what components are always rendered
    log_result "Components that might render on terms page:"
    grep -E "<(Header|Notifications|.*Modal)" src/ExistingApp.jsx | grep -v "^\s*//" >> "$RESULTS_DIR/app_analysis.txt"
fi

# 5. Search for components that might access user.level
log_result ""
log_result "${YELLOW}=== SEARCHING COMPONENTS THAT MIGHT USE USER.LEVEL ===${NC}"
echo "" >> "$RESULTS_DIR/component_analysis.txt"

components=("Header" "UserProfileModal" "UserProfile" "Notifications" "Badge" "LevelIcon")

for comp in "${components[@]}"; do
    log_result "Analyzing $comp component:"
    find src -name "*${comp}*" -type f \( -name "*.js" -o -name "*.jsx" \) -exec bash -c '
        file="$1"
        echo "File: $file" >> "$2/component_analysis.txt"
        grep -n "level\|user\." "$file" 2>/dev/null >> "$2/component_analysis.txt"
        echo "" >> "$2/component_analysis.txt"
    ' _ {} "$RESULTS_DIR" \;
done

# 6. Check for conditional rendering issues
log_result ""
log_result "${YELLOW}=== CHECKING CONDITIONAL RENDERING ===${NC}"
echo "" >> "$RESULTS_DIR/conditional_rendering.txt"

# Look for components that should be conditionally rendered
find src -type f \( -name "*.jsx" -o -name "*.js" \) -exec grep -Hn "isAuthenticated\|currentView\|user &&\|user \?" {} \; 2>/dev/null >> "$RESULTS_DIR/conditional_rendering.txt"

# 7. Analyze context providers
log_result ""
log_result "${YELLOW}=== ANALYZING CONTEXT PROVIDERS ===${NC}"
echo "" >> "$RESULTS_DIR/context_analysis.txt"

find src -path "*/context/*" -type f -name "*.js*" -exec bash -c '
    file="$1"
    echo "=== Context file: $file ===" >> "$2/context_analysis.txt"
    grep -n "level\|user\|state\." "$file" 2>/dev/null >> "$2/context_analysis.txt"
    echo "" >> "$2/context_analysis.txt"
' _ {} "$RESULTS_DIR" \;

# 8. Check for missing null checks
log_result ""
log_result "${YELLOW}=== POTENTIAL MISSING NULL CHECKS ===${NC}"
echo "" >> "$RESULTS_DIR/null_checks.txt"

# Find direct property access without optional chaining
find src -type f \( -name "*.js" -o -name "*.jsx" \) -exec grep -Hn "[^?]\.level\|user\.[a-zA-Z]" {} \; 2>/dev/null | grep -v "user\?." >> "$RESULTS_DIR/null_checks.txt"

# 9. Create summary
log_result ""
log_result "${YELLOW}=== ANALYSIS SUMMARY ===${NC}"

# Count occurrences
level_count=$(grep -r "\.level" src --include="*.js" --include="*.jsx" 2>/dev/null | wc -l)
user_access_count=$(grep -r "user\." src --include="*.js" --include="*.jsx" 2>/dev/null | wc -l)

log_result "Total .level occurrences: $level_count"
log_result "Total user. occurrences: $user_access_count"

# List most likely culprits
log_result ""
log_result "${RED}=== MOST LIKELY CULPRITS ===${NC}"

# Check specific files that commonly cause this issue
suspects=("UserProfileModal" "Header" "Badge" "LevelIcon" "Notifications")

for suspect in "${suspects[@]}"; do
    count=$(find src -name "*${suspect}*" -exec grep -l "\.level" {} \; 2>/dev/null | wc -l)
    if [ $count -gt 0 ]; then
        log_result "  ${RED}⚠️  $suspect components contain .level access${NC}"
        find src -name "*${suspect}*" -exec grep -Hn "\.level" {} \; 2>/dev/null | head -5
    fi
done

# 10. Generate recommendations
log_result ""
log_result "${GREEN}=== RECOMMENDATIONS ===${NC}"
cat << EOF >> "$RESULTS_DIR/recommendations.txt"
Based on the analysis, here are the recommended actions:

1. Add null checks to all user.level access:
   Change: user.level
   To: user?.level || 0

2. Conditionally render user-dependent components:
   {isAuthenticated && <UserProfileModal />}

3. Check these specific files (most likely sources):
EOF

# List files that need checking
find src -type f \( -name "*.js" -o -name "*.jsx" \) -exec grep -l "\.level" {} \; 2>/dev/null | sort | uniq >> "$RESULTS_DIR/recommendations.txt"

# Final report
log_result ""
log_result "${BLUE}=== ANALYSIS COMPLETE ===${NC}"
log_result "Full results saved in: $RESULTS_DIR/"
log_result ""
log_result "Files generated:"
ls -la "$RESULTS_DIR/" | grep -v "^total\|^d"

# Create a quick fix script (but don't run it)
cat << 'EOF' > "$RESULTS_DIR/suggested_quick_test.sh"
#!/bin/bash
# Quick test to isolate the issue

echo "To quickly test if modals are the issue, try adding this to ExistingApp.jsx:"
echo ""
echo "{/* Conditionally render modals */"
echo "{currentView !== 'terms' && currentView !== 'login' && currentView !== 'register' && ("
echo "  <>"
echo "    <RatingModal />"
echo "    <ReportModal />"
echo "    <ShareModal />"
echo "    <UserProfileModal />"
echo "    <Notifications />"
echo "  </>"
echo ")}"
EOF

chmod +x "$RESULTS_DIR/suggested_quick_test.sh"

log_result ""
log_result "${GREEN}Run this command to see the most likely issue:${NC}"
log_result "grep -r '\.level' src --include='*.jsx' --include='*.js' | grep -v 'user?' | grep -v '?.level'"

echo ""
echo "Analysis completed at: $(date)"
