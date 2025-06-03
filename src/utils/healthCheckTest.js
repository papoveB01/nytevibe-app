/**
 * Health Check Test Utility - Optional debugging tool
 * Tests the corrected health check endpoint
 */

const testHealthEndpoint = async () => {
  console.log('🧪 Testing nYtevibe health endpoint...');
  
  try {
    const response = await fetch('https://system.nytevibe.com/api/health', {
      method: 'GET',
      headers: {
        'Accept': 'application/json',
        'Origin': 'https://blackaxl.com'
      },
      mode: 'cors'
    });
    
    if (response.ok) {
      const data = await response.json();
      console.log('✅ Health endpoint working:', data);
      return { success: true, data };
    } else {
      console.error('❌ Health endpoint failed:', response.status, response.statusText);
      return { success: false, status: response.status, statusText: response.statusText };
    }
  } catch (error) {
    console.error('❌ Health endpoint error:', error.message);
    return { success: false, error: error.message };
  }
};

// Export for manual testing in console
export { testHealthEndpoint };

// Auto-run in development for debugging (optional)
if (process.env.NODE_ENV === 'development') {
  // Delayed auto-test
  setTimeout(() => {
    console.log('🔧 Auto-testing health endpoint in development...');
    testHealthEndpoint();
  }, 3000);
}
