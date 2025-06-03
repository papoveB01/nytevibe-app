// Copy and paste this into your browser console at blackaxl.com
console.log('=== BROWSER LOGIN TEST ===');

// Test the exact same request that should work
async function testLoginAPI() {
  try {
    const response = await fetch('https://system.nytevibe.com/api/auth/login', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: JSON.stringify({
        email: 'iammrpwinner01@gmail.com',
        password: 'Scario@02'
      })
    });

    console.log('Response status:', response.status);
    console.log('Response headers:', Object.fromEntries(response.headers.entries()));
    
    const data = await response.json();
    console.log('Response data:', data);
    
    if (response.ok) {
      console.log('✅ SUCCESS: Login worked in browser!');
      return data;
    } else {
      console.log('❌ FAILED: Login failed in browser');
      return null;
    }
  } catch (error) {
    console.error('💥 ERROR:', error);
    return null;
  }
}

// Run the test
testLoginAPI();
