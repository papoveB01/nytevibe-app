# Navigation Fix Instructions

## Problem Identified
The `actions` object in AppContext.jsx is missing the navigation functions:
- `setView`
- `setCurrentView`

This is why clicking "Create Account", "Forgot Password", and venue details doesn't work.

## Quick Fix Steps

### Option 1: Manual Fix (Recommended)
1. Open `/var/www/nytevibe/src/context/AppContext.jsx`
2. Find the `const actions = {` section (around line 800+)
3. Make sure these two functions are at the TOP of the actions object:

```javascript
const actions = {
  // 🔥 NAVIGATION ACTIONS - ADD THESE FIRST
  setView: useCallback((view) => {
    console.log('🎯 AppContext: Setting view to:', view);
    dispatch({ type: actionTypes.SET_CURRENT_VIEW, payload: view });
  }, []),
  
  setCurrentView: useCallback((view) => {
    console.log('🎯 AppContext: Setting current view to:', view);
    dispatch({ type: actionTypes.SET_CURRENT_VIEW, payload: view });
  }, []),
  
  // ... rest of your existing actions
};
```

### Option 2: Automatic Fix
1. Copy the complete fixed actions from `fixed_actions_section.js`
2. Replace the entire actions object in AppContext.jsx

## Test After Fix
1. Start frontend: `npm run dev`
2. Open browser to login page
3. Try clicking "Create Account" - should work
4. Try clicking "Forgot Password" - should work
5. Login and try venue details - should work

## Verification
In browser console, you should see:
```
🎯 AppContext: Setting view to: register
```
When clicking Create Account button.
