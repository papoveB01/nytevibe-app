// Test Handler Functions - Paste in browser console

function testAllNavigationHandlers() {
    console.log('🧪 Testing All Navigation Handlers...');
    
    // Test Create Account button
    console.log('1. Testing Create Account...');
    const createBtn = Array.from(document.querySelectorAll('button')).find(btn => 
        btn.textContent.toLowerCase().includes('create')
    );
    if (createBtn) {
        console.log('Create button found:', createBtn);
        console.log('Create button onclick:', createBtn.onclick);
        createBtn.addEventListener('click', function(e) {
            console.log('🧪 Create Account clicked!');
        }, { once: true });
    }
    
    // Test Forgot Password button
    console.log('2. Testing Forgot Password...');
    const forgotBtn = Array.from(document.querySelectorAll('button')).find(btn => 
        btn.textContent.toLowerCase().includes('forgot')
    );
    if (forgotBtn) {
        console.log('Forgot button found:', forgotBtn);
        console.log('Forgot button onclick:', forgotBtn.onclick);
        forgotBtn.addEventListener('click', function(e) {
            console.log('🧪 Forgot Password clicked!');
        }, { once: true });
    }
    
    // Test any venue links/buttons
    console.log('3. Testing Venue Links...');
    const venueElements = document.querySelectorAll('[class*="venue"], .venue-card, .venue-item');
    console.log('Venue elements found:', venueElements.length);
    
    venueElements.forEach((el, i) => {
        el.addEventListener('click', function(e) {
            console.log(`🧪 Venue element ${i} clicked!`);
        }, { once: true });
    });
    
    console.log('✅ Event listeners attached for testing');
}

// Call the test function
testAllNavigationHandlers();
