// 🔍 NAVIGATION DEBUG - Paste this in browser console

console.log('🔍 NAVIGATION DEBUG STARTED');
console.log('============================');

// Check if React components are accessible
function checkReactContext() {
    console.log('🔍 Checking React Context...');
    
    // Try to find React components in the DOM
    const reactNodes = document.querySelectorAll('[data-reactroot], #root, .app');
    console.log('React root nodes found:', reactNodes.length);
    
    // Check if window has React DevTools
    if (window.__REACT_DEVTOOLS_GLOBAL_HOOK__) {
        console.log('✅ React DevTools available');
    } else {
        console.log('❌ React DevTools not available');
    }
    
    // Try to access React state through DOM
    try {
        const reactFiber = Object.keys(document.querySelector('#root')).find(key => key.startsWith('__reactFiber'));
        if (reactFiber) {
            console.log('✅ React Fiber found');
        }
    } catch (e) {
        console.log('❌ Could not access React internals');
    }
}

// Check navigation functions
function checkNavigationFunctions() {
    console.log('🔍 Checking Navigation Functions...');
    
    // Look for navigation handlers in the DOM
    const buttons = document.querySelectorAll('button');
    console.log('Total buttons found:', buttons.length);
    
    let navigationButtons = 0;
    buttons.forEach((btn, index) => {
        const text = btn.textContent.toLowerCase();
        if (text.includes('create') || text.includes('forgot') || text.includes('register')) {
            navigationButtons++;
            console.log(`Found navigation button ${index}:`, text);
            console.log('Button onclick:', btn.onclick);
            console.log('Button listeners:', getEventListeners ? getEventListeners(btn) : 'DevTools required');
        }
    });
    
    console.log('Navigation buttons found:', navigationButtons);
}

// Check for JavaScript errors
function checkJavaScriptErrors() {
    console.log('🔍 Setting up error monitoring...');
    
    const originalError = window.console.error;
    window.console.error = function(...args) {
        console.log('🚨 JavaScript Error Detected:', ...args);
        originalError.apply(console, args);
    };
    
    // Monitor unhandled promise rejections
    window.addEventListener('unhandledrejection', function(event) {
        console.log('🚨 Unhandled Promise Rejection:', event.reason);
    });
    
    console.log('✅ Error monitoring active');
}

// Test click events
function testClickEvents() {
    console.log('🔍 Testing Click Events...');
    
    const buttons = document.querySelectorAll('button');
    buttons.forEach((btn, index) => {
        const text = btn.textContent.toLowerCase();
        if (text.includes('create account') || text.includes('register')) {
            console.log(`Testing click on: ${text}`);
            
            // Add temporary click listener
            const testHandler = function(e) {
                console.log('🧪 Click detected on:', text);
                console.log('Event:', e);
                console.log('Current target:', e.currentTarget);
            };
            
            btn.addEventListener('click', testHandler, true);
            
            setTimeout(() => {
                btn.removeEventListener('click', testHandler, true);
            }, 30000); // Remove after 30 seconds
        }
    });
}

// Monitor state changes
function monitorStateChanges() {
    console.log('🔍 Setting up state monitoring...');
    
    let lastKnownView = null;
    
    setInterval(() => {
        // Try to detect current view from DOM
        const viewIndicators = [
            document.querySelector('.login-view'),
            document.querySelector('.home-view'),
            document.querySelector('.register-view'),
            document.querySelector('.forgot-password-view')
        ];
        
        let currentView = 'unknown';
        if (document.querySelector('.login-view')) currentView = 'login';
        else if (document.querySelector('.home-view')) currentView = 'home';
        else if (document.querySelector('.register-view')) currentView = 'register';
        else if (document.querySelector('.forgot-password-view')) currentView = 'forgot-password';
        
        if (currentView !== lastKnownView) {
            console.log('🔄 View changed from', lastKnownView, 'to', currentView);
            lastKnownView = currentView;
        }
    }, 1000);
}

// Main debug function
function runNavigationDebug() {
    console.log('🚀 Running complete navigation debug...');
    
    checkReactContext();
    checkNavigationFunctions();
    checkJavaScriptErrors();
    testClickEvents();
    monitorStateChanges();
    
    console.log('✅ Navigation debug setup complete');
    console.log('👀 Watch console for navigation events...');
}

// Auto-run debug
runNavigationDebug();

// Expose global function for manual testing
window.debugNavigation = runNavigationDebug;
window.testNavigationClick = function(buttonText) {
    const buttons = Array.from(document.querySelectorAll('button'));
    const targetButton = buttons.find(btn => 
        btn.textContent.toLowerCase().includes(buttonText.toLowerCase())
    );
    
    if (targetButton) {
        console.log('🧪 Simulating click on:', targetButton.textContent);
        targetButton.click();
    } else {
        console.log('❌ Button not found:', buttonText);
    }
};

console.log('🎯 Test navigation with: testNavigationClick("create account")');
