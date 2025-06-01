# Emergency React Error #310 Fix Instructions

## 🚨 IMMEDIATE STEPS

### 1. **Clear Browser Completely**
```bash
# Close ALL browser tabs
# Press Ctrl+Shift+Delete (or Cmd+Shift+Delete on Mac)
# Select "All time" and check:
- Browsing history
- Cookies and other site data
- Cached images and files
- Hosted app data
```

### 2. **Run Development Mode**
```bash
# Stop the current server (Ctrl+C)
npm run dev

# If that doesn't work, try:
rm -rf node_modules
npm install
npm run dev
```

### 3. **Check for Detailed Error**
- Open browser console (F12)
- Look for the ACTUAL error message (not minified)
- Should show the exact line causing the loop

### 4. **Emergency Reset Button**
- Look for red "🚨 Emergency Reset" button in top-right
- Click it to clear all cache and reload

## 🔍 DEBUGGING STEPS

### Check Console Output
Look for these patterns:
```
✅ Good: "🔍 Checking for existing session..."
✅ Good: "💡 No valid session found, showing landing page"
❌ Bad: Repeated session messages
❌ Bad: Multiple useEffect calls
❌ Bad: React Error #310
```

### Identify the Source
The error might be in:
1. **AppContext** - Session initialization
2. **App.jsx** - Component re-renders
3. **Hooks** - useVenues or useNotifications
4. **Cached state** - Old data causing conflicts

## 🛠️ MANUAL FIXES

### If Error Persists:

#### Option 1: Nuclear Reset
```bash
# Complete reset
rm -rf node_modules
rm -rf dist
rm -rf .vite
npm install
npm run dev
```

#### Option 2: Disable Session Management Temporarily
```javascript
// In AppContext.jsx, comment out session initialization:
// if (!isInitialized.current) {
//   setTimeout(initializeSession, 100);
// }
```

#### Option 3: Switch to Basic Mode
```javascript
// In App.jsx, use this simple version:
function App() {
  return (
    <div className="app-layout">
      <WelcomeLandingPage />
    </div>
  );
}
```

## 🎯 ROOT CAUSE ANALYSIS

Common causes of Error #310:
1. **useEffect with changing dependencies**
2. **State updates inside render**
3. **Recursive component updates**
4. **Cached corrupted state**
5. **Multiple event listeners**

## ✅ VERIFICATION

Once fixed, you should see:
```
🔍 Checking for existing session...
🗑️ Session cleared successfully
💡 No valid session found, showing landing page
[NO MORE ERRORS]
```

## 📞 IF ALL ELSE FAILS

1. **Take screenshot** of the actual error (not minified)
2. **Check browser DevTools** → Components tab
3. **Note which component** is re-rendering infinitely
4. **Report the exact error message** from development mode
