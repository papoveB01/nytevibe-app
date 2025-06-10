// 🚀 ADVANCED RUNTIME NAVIGATION DEBUG
// Paste this in browser console after the app loads

console.log('🚀 RUNTIME NAVIGATION DEBUG STARTED');
console.log('===================================');

let debugData = {
  errors: [],
  clicks: [],
  navigationAttempts: [],
  contextState: null
};

// 1. Enhanced error monitoring
const originalError = console.error;
const originalWarn = console.warn;

console.error = function(...args) {
  debugData.errors.push({
    time: new Date().toISOString(),
    type: 'error',
    message: args.join(' ')
  });
  console.log('🚨 RUNTIME ERROR:', ...args);
  originalError.apply(console, args);
};

console.warn = function(...args) {
  debugData.errors.push({
    time: new Date().toISOString(),
    type: 'warning', 
    message: args.join(' ')
  });
  originalWarn.apply(console, args);
};

// 2. Monitor unhandled promise rejections
window.addEventListener('unhandledrejection', function(event) {
  debugData.errors.push({
    time: new Date().toISOString(),
    type: 'unhandled_promise',
    message: event.reason
  });
  console.log('🚨 UNHANDLED PROMISE REJECTION:', event.reason);
});

// 3. Enhanced click monitoring with detailed analysis
document.addEventListener('click', function(event) {
  const target = event.target;
  const text = target.textContent.toLowerCase().trim();
  
  // Log ALL clicks for debugging
  const clickData = {
    time: new Date().toISOString(),
    text: target.textContent,
    tagName: target.tagName,
    className: target.className,
    id: target.id,
    onclick: !!target.onclick,
    hasParentHandler: false,
    eventPath: []
  };
  
  // Check event path for handlers
  event.composedPath().forEach((el, i) => {
    if (el.onclick || (el.addEventListener && el.tagName)) {
      clickData.eventPath.push({
        index: i,
        tagName: el.tagName,
        className: el.className,
        hasOnClick: !!el.onclick
      });
    }
  });
  
  debugData.clicks.push(clickData);
  
  // Special handling for navigation buttons
  if (text.includes('create') || text.includes('account')) {
    console.log('🎯 CREATE ACCOUNT BUTTON CLICKED');
    console.log('📊 Click Analysis:', clickData);
    console.log('📍 Event Details:', {
      target: target,
      currentTarget: event.currentTarget,
      eventPhase: event.eventPhase,
      bubbles: event.bubbles,
      cancelable: event.cancelable,
      defaultPrevented: event.defaultPrevented
    });
    
    // Check if event is being prevented
    if (event.defaultPrevented) {
      console.log('⚠️ DEFAULT ACTION WAS PREVENTED!');
    }
    
    // Monitor for navigation attempts
    const startTime = Date.now();
    setTimeout(() => {
      const endTime = Date.now();
      console.log(`🕒 Navigation check after ${endTime - startTime}ms`);
      checkNavigationResult('register', startTime);
    }, 100);
  }
  
  if (text.includes('forgot') || text.includes('password')) {
    console.log('🎯 FORGOT PASSWORD BUTTON CLICKED');
    console.log('📊 Click Analysis:', clickData);
    
    const startTime = Date.now();
    setTimeout(() => {
      checkNavigationResult('forgot-password', startTime);
    }, 100);
  }
}, true); // Use capture phase

// 4. Monitor navigation attempts and results
function checkNavigationResult(expectedView, startTime) {
  console.log(`🔍 Checking navigation result for: ${expectedView}`);
  
  // Try to detect current view from DOM
  const viewElements = {
    login: document.querySelector('.login-view, .login-page, .login-card'),
    register: document.querySelector('.register-view, .registration-view'),
    'forgot-password': document.querySelector('.forgot-password-view'),
    home: document.querySelector('.home-view')
  };
  
  let currentView = 'unknown';
  Object.keys(viewElements).forEach(view => {
    if (viewElements[view]) {
      currentView = view;
    }
  });
  
  const navigationData = {
    time: new Date().toISOString(),
    expectedView: expectedView,
    actualView: currentView,
    navigationSuccessful: currentView === expectedView,
    timeTaken: Date.now() - startTime
  };
  
  debugData.navigationAttempts.push(navigationData);
  
  if (navigationData.navigationSuccessful) {
    console.log('✅ NAVIGATION SUCCESSFUL:', navigationData);
  } else {
    console.log('❌ NAVIGATION FAILED:', navigationData);
    console.log('🔍 Current page elements:');
    Object.keys(viewElements).forEach(view => {
      console.log(`   - ${view}: ${viewElements[view] ? 'FOUND' : 'not found'}`);
    });
  }
}

// 5. React context monitoring
function monitorReactContext() {
  console.log('🔍 Monitoring React context...');
  
  const root = document.querySelector('#root');
  if (!root) {
    console.log('❌ React root not found');
    return;
  }
  
  // Try to access React DevTools
  if (window.__REACT_DEVTOOLS_GLOBAL_HOOK__) {
    console.log('✅ React DevTools available');
    
    // Monitor React state changes
    const hook = window.__REACT_DEVTOOLS_GLOBAL_HOOK__;
    if (hook.onCommitFiberRoot) {
      const originalOnCommit = hook.onCommitFiberRoot;
      hook.onCommitFiberRoot = function(id, root) {
        console.log('🔄 React commit detected');
        originalOnCommit.call(this, id, root);
      };
    }
  }
  
  // Monitor for React errors
  if (window.addEventListener) {
    window.addEventListener('error', function(event) {
      if (event.error && event.error.stack && event.error.stack.includes('React')) {
        console.log('🚨 React error detected:', event.error);
        debugData.errors.push({
          time: new Date().toISOString(),
          type: 'react_error',
          message: event.error.message,
          stack: event.error.stack
        });
      }
    });
  }
}

// 6. CSS and styling checks
function checkStylingIssues() {
  console.log('🎨 Checking for styling issues...');
  
  const buttons = document.querySelectorAll('button');
  buttons.forEach((btn, i) => {
    const text = btn.textContent.toLowerCase();
    if (text.includes('create') || text.includes('account') || text.includes('forgot')) {
      const computedStyle = window.getComputedStyle(btn);
      const rect = btn.getBoundingClientRect();
      
      console.log(`🔍 Button ${i} (${text.substring(0, 20)}...):`);
      console.log('   - Visible:', computedStyle.display !== 'none' && computedStyle.visibility !== 'hidden');
      console.log('   - Pointer events:', computedStyle.pointerEvents);
      console.log('   - Z-index:', computedStyle.zIndex);
      console.log('   - Position:', rect);
      console.log('   - Opacity:', computedStyle.opacity);
      
      // Check if element is covered by others
      const elementAtPoint = document.elementFromPoint(rect.left + rect.width/2, rect.top + rect.height/2);
      if (elementAtPoint !== btn) {
        console.log('⚠️ Button may be covered by:', elementAtPoint);
      }
    }
  });
}

// 7. Form and event delegation checks
function checkEventDelegation() {
  console.log('📝 Checking event delegation...');
  
  const forms = document.querySelectorAll('form');
  forms.forEach((form, i) => {
    console.log(`Form ${i}:`, {
      onsubmit: !!form.onsubmit,
      action: form.action,
      method: form.method
    });
    
    // Check if form submission might interfere
    form.addEventListener('submit', function(e) {
      console.log('📝 FORM SUBMISSION DETECTED:', e);
      if (e.defaultPrevented) {
        console.log('✅ Form submission prevented (good for SPA)');
      } else {
        console.log('⚠️ Form submission NOT prevented (might cause page reload)');
      }
    });
  });
}

// 8. Initialize all monitoring
function initializeDebug() {
  console.log('🚀 Initializing comprehensive runtime debug...');
  
  monitorReactContext();
  checkStylingIssues();
  checkEventDelegation();
  
  // Log initial state
  console.log('📊 Initial page state:');
  console.log('   - URL:', window.location.href);
  console.log('   - Total buttons:', document.querySelectorAll('button').length);
  console.log('   - Forms:', document.querySelectorAll('form').length);
  console.log('   - React root:', !!document.querySelector('#root'));
  
  // Set up periodic reporting
  setInterval(() => {
    if (debugData.errors.length > 0 || debugData.navigationAttempts.length > 0) {
      console.log('📊 DEBUG SUMMARY:');
      console.log('   - Errors:', debugData.errors.length);
      console.log('   - Clicks:', debugData.clicks.length);
      console.log('   - Navigation attempts:', debugData.navigationAttempts.length);
      
      if (debugData.errors.length > 0) {
        console.log('🚨 Recent errors:', debugData.errors.slice(-3));
      }
    }
  }, 10000); // Every 10 seconds
}

// Start the debug
initializeDebug();

console.log('✅ RUNTIME DEBUG FULLY ACTIVE');
console.log('🎯 Now click the navigation buttons and watch for detailed analysis!');

// Expose debug data globally for manual inspection
window.navigationDebugData = debugData;
console.log('💡 Access debug data with: window.navigationDebugData');
