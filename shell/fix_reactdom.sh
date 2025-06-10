#!/bin/bash
# nYtevibe HomeView.jsx isVenueFollowed Fix Script
# Fixes the "TypeError: i.isVenueFollowed is not a function" error in HomeView.jsx

echo "🔧 nYtevibe HomeView.jsx Fix: Adding isVenueFollowed to destructuring"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 Updating src/components/Views/HomeView.jsx..."
echo ""

# Ensure we're in the project directory
if [ ! -f "package.json" ]; then
    echo "❌ Error: package.json not found. Please run this script from the nYtevibe project root directory."
    exit 1
fi

HOME_VIEW_PATH="src/components/Views/HomeView.jsx"

# Check if HomeView.jsx exists
if [ ! -f "$HOME_VIEW_PATH" ]; then
    echo "❌ Error: $HOME_VIEW_PATH not found. Please ensure the file exists."
    exit 1
fi

# Create a backup of the original HomeView.jsx
echo "💾 Creating backup of $HOME_VIEW_PATH to $HOME_VIEW_PATH.bak"
cp "$HOME_VIEW_PATH" "$HOME_VIEW_PATH.bak"

# Use sed to find and replace the line
# The -i.bak creates a backup file for sed on macOS, for Linux it's just -i
# The regex looks for 'const { getFilteredVenues, updateVenueData } = useVenues();'
# and replaces it with the version including 'isVenueFollowed'.
echo "📝 Modifying the useVenues destructuring in $HOME_VIEW_PATH..."
sed -i.tmp 's/const { getFilteredVenues, updateVenueData } = useVenues();/const { getFilteredVenues, updateVenueData, isVenueFollowed } = useVenues();/' "$HOME_VIEW_PATH"

# Remove the temporary file created by sed on some systems (like macOS)
rm -f "$HOME_VIEW_PATH.tmp"

echo "✅ $HOME_VIEW_PATH updated successfully."
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎉 isVenueFollowed function is now correctly destructured in HomeView.jsx."
echo "   You can now try running 'npm run build' or 'npm run dev' again."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
