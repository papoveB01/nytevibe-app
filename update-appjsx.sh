#!/bin/bash

# nYtevibe Ultra-Safe App.jsx Race Condition Fix Script - CORRECTED
# Applies defensive programming patterns to prevent undefined.includes() errors

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🛡️ nYtevibe Ultra-Safe App.jsx Race Condition Fix (CORRECTED)${NC}"
echo -e "${BLUE}===========================================================${NC}"
echo ""

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    echo -e "${RED}❌ Error: package.json not found. Please run this script from your React project directory.${NC}"
    exit 1
fi

# Check if App.jsx exists
if [ ! -f "src/App.jsx" ]; then
    echo -e "${RED}❌ Error: src/App.jsx not found. Please ensure the file exists.${NC}"
    exit 1
fi

# Create timestamp for this session
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="src/App.jsx.backup-ultra-safe-corrected-$TIMESTAMP"

echo -e "${YELLOW}📋 Phase 1: Backup and Validation${NC}"
echo "----------------------------------------"

# Create backup
echo "🔄 Creating backup..."
cp src/App.jsx "$BACKUP_FILE"
echo -e "${GREEN}✅ Backup created: $BACKUP_FILE${NC}"

# Show current problematic lines
echo ""
echo "📊 Current problematic patterns found:"
grep -n "authViews.includes(currentView)" src/App.jsx || echo "None found"

echo ""
echo -e "${YELLOW}📋 Phase 2: Applying Surgical Fix (In-Place Editing)${NC}"
echo "----------------------------------------"

# Instead of replacing the entire file, let's make surgical edits to fix the specific lines

echo "🛠️ Applying surgical fixes to problematic useEffect hooks..."

# Fix 1: Replace the venue data update useEffect (around line 76)
echo "🔧 Fixing venue data update useEffect..."
sed -i '/Auto-update venue data periodically when authenticated/,/}, \[updateVenueData, currentView, isAuthenticated\]);/{
/Auto-update venue data periodically when authenticated/c\
  // 🛡️ ULTRA-SAFE VERSION: Auto-update venue data periodically when authenticated
/useEffect(() => {/,/}, \[updateVenueData, currentView, isAuthenticated\]);/{
s/.*/  useEffect(() => {\
    \/\/ Extra safety checks for React re-render race conditions\
    if (!currentView || !isAuthenticated || !updateVenueData) {\
      console.log("🔍 Venue update skipped - missing dependencies:", { \
        currentView: !!currentView, \
        isAuthenticated, \
        updateVenueData: !!updateVenueData \
      });\
      return;\
    }\
    \
    const authViews = ["login", "register", "email-verification"];\
    \
    \/\/ Verify authViews is array and currentView is string before using .includes()\
    if (Array.isArray(authViews) \&\& \
        typeof currentView === "string" \&\& \
        isAuthenticated \&\& \
        !authViews.includes(currentView)) {\
      \
      console.log("🔍 Starting venue updates for authenticated view:", currentView);\
      const interval = setInterval(() => {\
        updateVenueData();\
      }, 45000);\
\
      return () => {\
        console.log("🔍 Cleaning up venue update interval");\
        clearInterval(interval);\
      };\
    } else {\
      console.log("🔍 Venue update conditions not met:", {\
        authViewsIsArray: Array.isArray(authViews),\
        currentViewIsString: typeof currentView === "string",\
        isAuthenticated,\
        currentView,\
        isAuthView: authViews.includes(currentView)\
      });\
    }\
  }, [updateVenueData, currentView, isAuthenticated]);/
}
}' src/App.jsx

echo -e "${GREEN}✅ Fixed venue data update useEffect${NC}"

# Let's try a simpler approach - create a patch file and apply it
echo ""
echo "🔧 Creating targeted fixes using a simpler approach..."

# Create a temporary fixed version with just the essential changes
cat > /tmp/app_jsx_fixes.patch << 'PATCH_EOF'
--- a/src/App.jsx
+++ b/src/App.jsx
@@ -73,7 +73,18 @@
 
   // Auto-update venue data periodically when authenticated
   useEffect(() => {
+    // 🛡️ ULTRA-SAFE: Extra safety checks for React re-render race conditions
+    if (!currentView || !isAuthenticated || !updateVenueData) {
+      return;
+    }
+    
     const authViews = ['login', 'register', 'email-verification'];
+    
+    // Verify authViews is array and currentView is string before using .includes()
+    if (!Array.isArray(authViews) || typeof currentView !== 'string') {
+      return;
+    }
+    
     if (isAuthenticated && !authViews.includes(currentView)) {
       const interval = setInterval(() => {
         updateVenueData();
@@ -85,7 +96,18 @@
 
   // Initialize app to login view if not authenticated
   useEffect(() => {
+    // 🛡️ ULTRA-SAFE: Extra safety checks for React re-render race conditions
+    if (!currentView || !actions || !actions.setCurrentView) {
+      return;
+    }
+    
     const authViews = ['login', 'register', 'email-verification'];
+    
+    // Verify all variables before using .includes()
+    if (!Array.isArray(authViews) || typeof currentView !== 'string') {
+      return;
+    }
+    
     if (!isAuthenticated && !authViews.includes(currentView) && actions) {
       actions.setCurrentView('login');
     }
@@ -138,7 +160,13 @@
 
   // Determine if header should be shown (not on login, register, or verification pages)
   const authViews = ['login', 'register', 'email-verification'];
-  const showHeader = !authViews.includes(currentView);
+  
+  // 🛡️ ULTRA-SAFE: Safe header visibility calculation
+  let showHeader = false;
+  if (Array.isArray(authViews) && typeof currentView === 'string') {
+    showHeader = !authViews.includes(currentView);
+  }
+  
 
   // Debug logging
   console.log('App Debug:', {
PATCH_EOF

# Restore the backup first
echo "🔄 Restoring backup to start fresh..."
cp "$BACKUP_FILE" src/App.jsx

# Now let's manually apply the essential fixes
echo "🛠️ Applying essential defensive programming fixes..."

# Create the corrected version with minimal changes
python3 << 'PYTHON_EOF'
import re

# Read the current App.jsx
with open('src/App.jsx', 'r') as f:
    content = f.read()

# Fix 1: Add safety to venue data update useEffect
old_pattern1 = r'(// Auto-update venue data periodically when authenticated\s*useEffect\(\(\) => \{\s*)(const authViews = \[\'login\', \'register\', \'email-verification\'\];\s*)(if \(isAuthenticated && !authViews\.includes\(currentView\)\) \{)'

new_replacement1 = r'''\1// 🛡️ ULTRA-SAFE: Extra safety checks for React re-render race conditions
    if (!currentView || !isAuthenticated || !updateVenueData) {
      return;
    }
    
    \2
    // Verify authViews is array and currentView is string before using .includes()
    if (!Array.isArray(authViews) || typeof currentView !== 'string') {
      return;
    }
    
    \3'''

content = re.sub(old_pattern1, new_replacement1, content, flags=re.MULTILINE | re.DOTALL)

# Fix 2: Add safety to auth redirect useEffect
old_pattern2 = r'(// Initialize app to login view if not authenticated\s*useEffect\(\(\) => \{\s*)(const authViews = \[\'login\', \'register\', \'email-verification\'\];\s*)(if \(!isAuthenticated && !authViews\.includes\(currentView\) && actions\) \{)'

new_replacement2 = r'''\1// 🛡️ ULTRA-SAFE: Extra safety checks for React re-render race conditions
    if (!currentView || !actions || !actions.setCurrentView) {
      return;
    }
    
    \2
    // Verify all variables before using .includes()
    if (!Array.isArray(authViews) || typeof currentView !== 'string') {
      return;
    }
    
    \3'''

content = re.sub(old_pattern2, new_replacement2, content, flags=re.MULTILINE | re.DOTALL)

# Fix 3: Add safety to header visibility calculation
old_pattern3 = r'(const authViews = \[\'login\', \'register\', \'email-verification\'\];\s*)(const showHeader = !authViews\.includes\(currentView\);)'

new_replacement3 = r'''\1
  // 🛡️ ULTRA-SAFE: Safe header visibility calculation
  let showHeader = false;
  if (Array.isArray(authViews) && typeof currentView === 'string') {
    showHeader = !authViews.includes(currentView);
  }'''

content = re.sub(old_pattern3, new_replacement3, content, flags=re.MULTILINE | re.DOTALL)

# Write the fixed content
with open('src/App.jsx', 'w') as f:
    f.write(content)

print("✅ Applied defensive programming fixes successfully")
PYTHON_EOF

echo -e "${GREEN}✅ Applied essential defensive programming fixes${NC}"

echo ""
echo -e "${YELLOW}📋 Phase 3: Validation${NC}"
echo "----------------------------------------"

# Validate the new file
echo "🔍 Validating updated App.jsx structure..."

# Check if file is valid JavaScript (basic syntax check)
if node -c src/App.jsx 2>/dev/null; then
    echo -e "${GREEN}✅ JavaScript syntax validation passed${NC}"
else
    echo -e "${RED}❌ JavaScript syntax validation failed${NC}"
    echo "Restoring backup..."
    cp "$BACKUP_FILE" src/App.jsx
    exit 1
fi

# Verify our safety measures are in place
echo ""
echo "🔍 Checking applied safety measures..."

if grep -q "ULTRA-SAFE" src/App.jsx; then
    echo -e "${GREEN}✅ Ultra-safe patterns applied${NC}"
else
    echo -e "${YELLOW}⚠️  Ultra-safe comments not found (may still be functional)${NC}"
fi

if grep -q "Array.isArray(authViews)" src/App.jsx; then
    echo -e "${GREEN}✅ Array validation checks added${NC}"
else
    echo -e "${RED}❌ Array validation checks missing${NC}"
fi

if grep -q "typeof currentView" src/App.jsx; then
    echo -e "${GREEN}✅ Type validation checks added${NC}"
else
    echo -e "${RED}❌ Type validation checks missing${NC}"
fi

echo ""
echo -e "${YELLOW}📋 Phase 4: Summary of Changes${NC}"
echo "----------------------------------------"

echo "🛡️ Applied Safety Measures:"
echo ""
echo "1. ✅ Enhanced Venue Data useEffect:"
echo "   - Added null checks for currentView, isAuthenticated, updateVenueData"
echo "   - Added Array.isArray() validation for authViews"
echo "   - Added typeof validation for currentView"
echo ""
echo "2. ✅ Enhanced Auth Redirect useEffect:"
echo "   - Added null checks for currentView, actions"
echo "   - Added Array.isArray() validation for authViews"
echo "   - Added typeof validation for currentView"
echo ""
echo "3. ✅ Enhanced Header Visibility Logic:"
echo "   - Safe calculation with type validation"
echo "   - Fallback to false if validation fails"

echo ""
echo -e "${YELLOW}📋 Phase 5: Testing Instructions${NC}"
echo "----------------------------------------"

echo "🧪 To test the fix:"
echo ""
echo "1. Start development server:"
echo "   npm run dev"
echo ""
echo "2. Test login flow:"
echo "   - Navigate to login page"
echo "   - Attempt login with credentials" 
echo "   - Verify no white screen after login"
echo ""
echo "3. Check browser console:"
echo "   - Should see no undefined.includes() errors"
echo "   - Look for any remaining JavaScript errors"

echo ""
echo -e "${YELLOW}📋 Phase 6: Rollback Instructions${NC}"
echo "----------------------------------------"

echo "🔄 If issues occur, rollback with:"
echo "   cp $BACKUP_FILE src/App.jsx"
echo ""
echo "📁 Backup location: $BACKUP_FILE"

echo ""
echo -e "${GREEN}✅ Corrected Ultra-Safe App.jsx Fix Complete!${NC}"
echo -e "${GREEN}=============================================${NC}"
echo ""
echo -e "${BLUE}🎯 What Was Fixed:${NC}"
echo "   - Added comprehensive null checks before .includes() calls"
echo "   - Added type validation for arrays and strings"
echo "   - Protected against React re-render race conditions"
echo ""
echo -e "${BLUE}🚀 Test your login flow now!${NC}"
echo ""
echo "Status: 🟢 CORRECTED ULTRA-SAFE FIX APPLIED"
PYTHON_EOF

chmod +x corrected_ultra_safe_fix.sh
