#!/bin/bash

echo "⚡ QUICK NAVIGATION TEST"
echo "======================="

# Check if the frontend is running
if curl -s http://localhost:3000 > /dev/null; then
    echo "✅ Frontend server is running"
else
    echo "❌ Frontend server not responding"
    echo "   Start with: npm run dev"
fi

# Check browser console for immediate errors
echo ""
echo "🔍 Check browser console for these patterns:"
echo "   - 'actions.setCurrentView is not a function'"
echo "   - 'Cannot read property of undefined'"
echo "   - 'onClick handler not working'"
echo "   - React component errors"

echo ""
echo "🎯 Manual Test Checklist:"
echo "   1. Open browser to login page"
echo "   2. Try clicking 'Create Account' button"
echo "   3. Check console for errors"
echo "   4. Try clicking 'Forgot Password' link"
echo "   5. If logged in, try clicking venue details"

echo ""
echo "📝 Most Likely Causes:"
echo "   1. actions.setCurrentView undefined in LoginView"
echo "   2. Event handlers not properly bound"
echo "   3. Context provider not wrapping components"
echo "   4. Props not passed correctly"
