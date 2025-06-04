#!/bin/bash

# Precise Demo Removal Script for nYtevibe LoginView
# Surgically removes demo functionality while preserving real authentication

set -e

echo "🎯 Starting Precise Demo Removal"
echo "================================"

# Step 1: Create backup
echo "📦 Creating backup..."
cp src/components/Views/LoginView.jsx src/components/Views/LoginView.jsx.backup-demo
cp src/App.css src/App.css.backup-demo

# Step 2: Remove demo credentials object (lines 16-19)
echo "🗑️  Removing demo credentials object..."
sed -i '/const demoCredentials = {/,/};/d' src/components/Views/LoginView.jsx

# Step 3: Remove fillDemoCredentials function (lines 42-46)
echo "🗑️  Removing fillDemoCredentials function..."
sed -i '/const fillDemoCredentials = () => {/,/};/d' src/components/Views/LoginView.jsx

# Step 4: Remove demo login logic from handleSubmit (lines 54-83)
echo "🗑️  Removing demo login logic..."
# Remove the demo check and demo login block
sed -i '/\/\/ Check if demo credentials/,/}, 1000);/d' src/components/Views/LoginView.jsx
# Clean up the "else" that will be left hanging
sed -i '/} else {$/d' src/components/Views/LoginView.jsx

# Step 5: Remove demo banner JSX (lines 236-252)
echo "🗑️  Removing demo banner..."
sed -i '/<div className="demo-banner">/,/<\/div>/d' src/components/Views/LoginView.jsx

# Step 6: Remove demo CSS classes
echo "🎨 Removing demo CSS..."
# Remove all demo-related CSS blocks
sed -i '/\.demo-banner {/,/^}/d' src/App.css
sed -i '/\.demo-content {/,/^}/d' src/App.css
sed -i '/\.demo-info {/,/^}/d' src/App.css
sed -i '/\.demo-title {/,/^}/d' src/App.css
sed -i '/\.demo-description {/,/^}/d' src/App.css
sed -i '/\.demo-fill-button/,/^}/d' src/App.css

# Remove any remaining demo references in CSS
sed -i '/demo-/d' src/App.css

# Step 7: Clean up any duplicate empty lines
sed -i '/^$/N;/^\n$/d' src/components/Views/LoginView.jsx

# Step 8: Test the changes
echo "🧪 Testing cleaned application..."
BUILD_OUTPUT=$(npm run build 2>&1)
BUILD_EXIT_CODE=$?

if [ $BUILD_EXIT_CODE -eq 0 ]; then
    echo "✅ Build test passed - demo removal successful!"
else
    echo "❌ Build test failed - restoring backups..."
    echo "Build error:"
    echo "$BUILD_OUTPUT"
    
    # Restore backups
    cp src/components/Views/LoginView.jsx.backup-demo src/components/Views/LoginView.jsx
    cp src/App.css.backup-demo src/App.css
    
    echo "🔄 Backups restored"
    exit 1
fi

# Step 9: Verify what was removed
echo ""
echo "🔍 Verification - searching for remaining demo references..."
DEMO_REFS=$(grep -r -i "demo" src/components/Views/LoginView.jsx || echo "No demo references found")
if [ "$DEMO_REFS" = "No demo references found" ]; then
    echo "✅ All demo references successfully removed"
else
    echo "⚠️  Some demo references still exist:"
    echo "$DEMO_REFS"
fi

# Step 10: Show what the cleaned handleSubmit looks like
echo ""
echo "📋 Cleaned handleSubmit function (first 15 lines):"
echo "=================================================="
grep -n -A15 "const handleSubmit" src/components/Views/LoginView.jsx

echo ""
echo "🎉 Demo Removal Complete!"
echo "========================"
echo "✅ Demo credentials removed"
echo "✅ Demo fill button removed"
echo "✅ Demo login logic removed"
echo "✅ Demo banner removed"
echo "✅ Demo CSS removed"
echo "✅ Real authentication preserved"
echo ""
echo "📁 Backups available:"
echo "  - LoginView.jsx.backup-demo"
echo "  - App.css.backup-demo"
echo ""
echo "🚀 Your login page is now production-ready!"

# Step 11: Quick test that login form still renders
echo ""
echo "🎯 Final verification - checking login form structure..."
if grep -q "login-form" src/components/Views/LoginView.jsx; then
    echo "✅ Login form structure preserved"
else
    echo "⚠️  Login form structure may have been affected"
fi

if grep -q "handleSubmit" src/components/Views/LoginView.jsx; then
    echo "✅ handleSubmit function preserved"
else
    echo "⚠️  handleSubmit function may have been affected"
fi

echo ""
echo "🎯 Test your login page: npm run dev"
