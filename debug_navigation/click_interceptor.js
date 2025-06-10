// Click Event Interceptor - Paste in browser console

console.log('🕵️ CLICK EVENT INTERCEPTOR STARTING...');

// Intercept all clicks on the page
document.addEventListener('click', function(event) {
    const target = event.target;
    const text = target.textContent.toLowerCase();
    
    // Log all button clicks
    if (target.tagName === 'BUTTON') {
        console.log('🖱️ BUTTON CLICKED:', {
            text: target.textContent,
            className: target.className,
            onclick: target.onclick,
            hasEventListeners: !!target.onclick || target.addEventListener.length > 0
        });
        
        // Special handling for navigation buttons
        if (text.includes('create') || text.includes('account')) {
            console.log('🎯 CREATE ACCOUNT BUTTON CLICKED');
            console.log('- Event:', event);
            console.log('- Target:', target);
            console.log('- Parent:', target.parentElement);
        }
        
        if (text.includes('forgot') || text.includes('password')) {
            console.log('🎯 FORGOT PASSWORD BUTTON CLICKED');
            console.log('- Event:', event);
            console.log('- Target:', target);
            console.log('- Parent:', target.parentElement);
        }
    }
    
    // Log all link clicks
    if (target.tagName === 'A' || target.onclick) {
        console.log('🖱️ LINK/CLICKABLE CLICKED:', {
            text: target.textContent,
            href: target.href,
            onclick: target.onclick
        });
    }
}, true); // Use capture phase

console.log('✅ Click interceptor active - all clicks will be logged');

// Test if React context is accessible
setTimeout(() => {
    console.log('🔍 Checking React context access...');
    
    // Try to find React components
    const reactRoot = document.querySelector('#root');
    if (reactRoot) {
        console.log('✅ React root found');
        
        // Try to access React internals
        const reactKeys = Object.keys(reactRoot).filter(key => key.startsWith('__react'));
        console.log('React keys found:', reactKeys);
    }
}, 2000);
