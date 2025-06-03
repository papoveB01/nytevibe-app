#!/usr/bin/env node

// Quick CLI test for the health endpoint
// Usage: node test-health-endpoint.js

const https = require('https');

console.log('🧪 Testing nYtevibe health endpoint from CLI...');

const testHealth = () => {
  const options = {
    hostname: 'system.nytevibe.com',
    path: '/api/health',  // ✅ CORRECT: Using /api/health
    method: 'GET',
    headers: {
      'Accept': 'application/json',
      'Origin': 'https://blackaxl.com'
    }
  };

  const req = https.request(options, (res) => {
    let data = '';
    res.on('data', (chunk) => data += chunk);
    res.on('end', () => {
      if (res.statusCode === 200) {
        console.log('✅ Health endpoint working:');
        console.log(JSON.parse(data));
      } else {
        console.log(`❌ Health endpoint failed: ${res.statusCode}`);
        console.log('Response:', data);
      }
    });
  });

  req.on('error', (error) => {
    console.log('❌ Health endpoint error:', error.message);
  });

  req.setTimeout(10000, () => {
    console.log('❌ Health endpoint timeout');
    req.destroy();
  });

  req.end();
};

testHealth();
