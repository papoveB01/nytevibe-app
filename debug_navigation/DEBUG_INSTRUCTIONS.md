# Navigation Debug Instructions

## Issue
After fixing login persistence, navigation links (Create Account, Forgot Password, Venue Details) stopped working.

## Debug Steps

### 1. Browser Console Debug
1. Open browser DevTools (F12)
2. Go to Console tab
3. Paste the contents of `console_debug.js`
4. Watch for error messages and navigation events

### 2. Test Navigation Functions
```javascript
// Test specific navigation
testNavigationClick("create account");
testNavigationClick("forgot password");
```

### 3. Add Navigation Tester Component
Temporarily add `NavigationTester.jsx` to your main app to test navigation:

```jsx
import NavigationTester from './debug_navigation/NavigationTester';

// Add to your main component
<NavigationTester />
```

### 4. Check Component Props
Add `ComponentChecker` to LoginView.jsx:

```jsx
import { ComponentChecker } from './debug_navigation/component_checker';

// Add inside LoginView component
<ComponentChecker componentName="LoginView" />
```

## Common Issues to Look For

1. **Missing Actions**: Check if `actions.setCurrentView` or `actions.setView` are undefined
2. **Event Handler Binding**: Verify onClick handlers are properly bound
3. **Context Provider**: Ensure AppProvider wraps the entire app
4. **State Updates**: Check if state changes are triggering re-renders
5. **JavaScript Errors**: Look for any console errors blocking execution

## Expected Behavior

- Clicking "Create Account" should call `actions.setCurrentView('register')`
- Clicking "Forgot Password" should call `actions.setCurrentView('forgot-password')`
- Venue clicks should call `actions.setCurrentView('details')`

## Quick Fixes to Try

1. Check if `onRegister` prop is passed to LoginView
2. Verify `handleShowRegistration` function exists in ExistingApp
3. Ensure event handlers aren't being prevented by other code
4. Check if loading states are blocking interactions
