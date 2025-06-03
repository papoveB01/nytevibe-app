import React, { useState } from 'react';

const LoginTest = () => {
  const [testResult, setTestResult] = useState('');
  const [loading, setLoading] = useState(false);

  const runTest = async () => {
    setLoading(true);
    setTestResult('Testing...');

    try {
      console.log('=== RUNNING LOGIN TEST ===');
      
      const testData = {
        email: 'iammrpwinner01@gmail.com',
        password: 'Scario@02'
      };

      console.log('Test data:', testData);

      const response = await fetch('https://system.nytevibe.com/api/auth/login', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: JSON.stringify(testData)
      });

      const data = await response.json();
      
      console.log('Test response status:', response.status);
      console.log('Test response data:', data);

      if (response.ok) {
        setTestResult(`✅ SUCCESS (${response.status}): ${JSON.stringify(data, null, 2)}`);
      } else {
        setTestResult(`❌ FAILED (${response.status}): ${JSON.stringify(data, null, 2)}`);
      }
    } catch (error) {
      console.error('Test error:', error);
      setTestResult(`💥 ERROR: ${error.message}`);
    } finally {
      setLoading(false);
    }
  };

  const testCurl = () => {
    const curlCommand = `curl -X POST https://system.nytevibe.com/api/auth/login \\
  -H "Content-Type: application/json" \\
  -H "Accept: application/json" \\
  -d '{"email":"iammrpwinner01@gmail.com","password":"Scario@02"}'`;
    
    console.log('Equivalent curl command:');
    console.log(curlCommand);
    alert('Curl command logged to console');
  };

  return (
    <div style={{ padding: '20px', maxWidth: '800px', margin: '0 auto' }}>
      <h2>🔧 Login API Test</h2>
      <p>Use this to test the login API directly and compare with your working curl command.</p>
      
      <div style={{ marginBottom: '20px' }}>
        <button 
          onClick={runTest} 
          disabled={loading}
          style={{ 
            padding: '10px 20px', 
            marginRight: '10px',
            backgroundColor: '#007bff', 
            color: 'white', 
            border: 'none', 
            borderRadius: '4px',
            cursor: loading ? 'not-allowed' : 'pointer'
          }}
        >
          {loading ? 'Testing...' : '🧪 Run Login Test'}
        </button>
        
        <button 
          onClick={testCurl}
          style={{ 
            padding: '10px 20px', 
            backgroundColor: '#28a745', 
            color: 'white', 
            border: 'none', 
            borderRadius: '4px',
            cursor: 'pointer'
          }}
        >
          📋 Show Curl Command
        </button>
      </div>

      {testResult && (
        <div style={{ 
          padding: '15px', 
          backgroundColor: '#f8f9fa', 
          border: '1px solid #dee2e6', 
          borderRadius: '4px',
          fontFamily: 'monospace',
          whiteSpace: 'pre-wrap',
          overflow: 'auto'
        }}>
          <strong>Test Result:</strong><br/>
          {testResult}
        </div>
      )}

      <div style={{ marginTop: '20px', fontSize: '14px', color: '#666' }}>
        <strong>Instructions:</strong>
        <ol>
          <li>Click "Run Login Test" to test the API call</li>
          <li>Check browser console for detailed logs</li>
          <li>Compare the result with your working curl command</li>
          <li>If test fails, check the error details</li>
        </ol>
      </div>
    </div>
  );
};

export default LoginTest;
