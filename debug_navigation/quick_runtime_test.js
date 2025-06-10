// 🧪 QUICK RUNTIME TEST - Paste in browser console

console.log('🧪 QUICK RUNTIME TEST');

// Test 1: Find navigation buttons
const createBtn = Array.from(document.querySelectorAll('button')).find(btn => 
  btn.textContent.toLowerCase().includes('create')
);

const forgotBtn = Array.from(document.querySelectorAll('button')).find(btn => 
  btn.textContent.toLowerCase().includes('forgot')
);

console.log('Navigation buttons found:');
console.log('- Create Account:', !!createBtn);
console.log('- Forgot Password:', !!forgotBtn);

// Test 2: Check if buttons are clickable
if (createBtn) {
  const rect = createBtn.getBoundingClientRect();
  const style = window.getComputedStyle(createBtn);
  console.log('Create button analysis:');
  console.log('- Visible:', style.display !== 'none');
  console.log('- Pointer events:', style.pointerEvents);
  console.log('- Position:', rect.width > 0 && rect.height > 0);
  
  // Test click
  console.log('🧪 Testing Create Account click...');
  createBtn.addEventListener('click', () => {
    console.log('✅ Create Account click detected!');
  }, { once: true });
}

// Test 3: Monitor for errors
let errorCount = 0;
const originalError = console.error;
console.error = function(...args) {
  errorCount++;
  console.log(`🚨 Error #${errorCount}:`, ...args);
  originalError.apply(console, args);
};

console.log('✅ Quick test setup complete');
console.log('🎯 Now click the Create Account button!');
