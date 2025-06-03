#!/bin/bash

# Debug Login Request - Find exact differences between curl and browser
echo "======================================================="
echo "    DEBUG LOGIN REQUEST - FIND THE REAL ISSUE"
echo "======================================================="

echo ">>> 1. VERIFY CHANGES WERE APPLIED"
echo "----------------------------------------"

# Check if changes were actually applied
echo "Checking LoginView.jsx for email field fix..."
if grep -n -A3 -B1 "registrationAPI.login" src/components/Views/LoginView.jsx; then
    if grep -q "email: username" src/components/Views/LoginView.jsx; then
        echo "✅ LoginView.jsx: Field fix applied correctly"
    else
        echo "❌ LoginView.jsx: Still using 'username' field"
        echo "   You need to change 'username,' to 'email: username,' in registrationAPI.login call"
    fi
else
    echo "❌ registrationAPI.login call not found"
fi

echo ""
echo "Checking registrationAPI.js for header fixes..."
if grep -n -A10 -B2 "async login" src/services/registrationAPI.js; then
    if grep -q "X-Requested-With" src/services/registrationAPI.js; then
        echo "❌ registrationAPI.js: Still has X-Requested-With header"
    else
        echo "✅ registrationAPI.js: X-Requested-With header removed"
    fi
    
    if grep -A15 "async login" src/services/registrationAPI.js | grep -q "Origin.*blackaxl"; then
        echo "❌ registrationAPI.js: Still has manual Origin header in login method"
    else
        echo "✅ registrationAPI.js: Manual Origin header removed from login"
    fi
else
    echo "❌ login method not found in registrationAPI.js"
fi

echo ""
echo ">>> 2. CREATE BROWSER DEBUGGING TOOL"
echo "----------------------------------------"

# Create a comprehensive browser debugging script
cat > debug_browser_request.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Login Request Debugger</title>
    <style>
        body { font-family: monospace; padding: 20px; background: #f5f5f5; }
        .container { max-width: 1200px; margin: 0 auto; }
        .section { background: white; margin: 20px 0; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .code { background: #f8f9fa; padding: 15px; border-radius: 4px; white-space: pre-wrap; font-size: 12px; overflow: auto; }
        .success { color: #28a745; font-weight: bold; }
        .error { color: #dc3545; font-weight: bold; }
        .warning { color: #ffc107; font-weight: bold; }
        button { padding: 10px 20px; margin: 5px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; }
        .btn-primary { background: #007bff; color: white; }
        .btn-success { background: #28a745; color: white; }
        .btn-warning { background: #ffc107; color: black; }
        .comparison { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .comparison > div { background: #f8f9fa; padding: 15px; border-radius: 4px; }
        @media (max-width: 768px) { .comparison { grid-template-columns: 1fr; } }
    </style>
</head>
<body>
    <div class="container">
        <h1>🔍 Login Request Debugger</h1>
        <p>This tool will help us find exactly why your frontend gets 422 while curl works.</p>
        
        <div class="section">
            <h2>📋 Step 1: Copy Your Working Curl Command</h2>
            <p>Paste your working curl command here to extract the exact parameters:</p>
            <textarea id="curlCommand" style="width: 100%; height: 100px; font-family: monospace;" placeholder="Paste your working curl command here..."></textarea>
            <button class="btn-primary" onclick="parseCurl()">Parse Curl Command</button>
            <div id="curlResult" class="code" style="margin-top: 10px;"></div>
        </div>

        <div class="section">
            <h2>🧪 Step 2: Test Frontend API Call</h2>
            <p>Enter the same credentials to test the frontend request:</p>
            <input type="email" id="testEmail" placeholder="Email" style="width: 200px; padding: 8px; margin: 5px;">
            <input type="password" id="testPassword" placeholder="Password" style="width: 200px; padding: 8px; margin: 5px;">
            <br>
            <button class="btn-primary" onclick="testFrontendRequest()">Test Frontend Request</button>
            <button class="btn-success" onclick="testMinimalRequest()">Test Minimal Request (like curl)</button>
            <div id="frontendResult" class="code" style="margin-top: 10px;"></div>
        </div>

        <div class="section">
            <h2>📊 Step 3: Request Comparison</h2>
            <div id="comparison" class="comparison" style="display: none;">
                <div>
                    <h3>🟢 Working Curl Request</h3>
                    <div id="curlDetails" class="code"></div>
                </div>
                <div>
                    <h3>🔴 Failing Frontend Request</h3>
                    <div id="frontendDetails" class="code"></div>
                </div>
            </div>
        </div>

        <div class="section">
            <h2>🔧 Step 4: Diagnostics</h2>
            <div id="diagnostics"></div>
        </div>
    </div>

    <script>
        let curlData = null;
        let frontendData = null;

        function parseCurl() {
            const curl = document.getElementById('curlCommand').value.trim();
            const result = document.getElementById('curlResult');
            
            try {
                // Extract URL
                const urlMatch = curl.match(/https?:\/\/[^\s]+/);
                const url = urlMatch ? urlMatch[0] : 'URL not found';
                
                // Extract headers
                const headers = {};
                const headerMatches = curl.match(/-H\s+['"](.*?)['"]/g) || [];
                headerMatches.forEach(h => {
                    const headerContent = h.match(/-H\s+['"](.*?)['"]/)[1];
                    const [key, value] = headerContent.split(': ');
                    if (key && value) headers[key] = value;
                });
                
                // Extract data
                const dataMatch = curl.match(/-d\s+['"](.*?)['"]/s);
                let data = {};
                if (dataMatch) {
                    try {
                        data = JSON.parse(dataMatch[1]);
                    } catch(e) {
                        data = { raw: dataMatch[1] };
                    }
                }
                
                curlData = { url, headers, data };
                
                result.innerHTML = `<span class="success">✅ Curl Parsed Successfully</span>
URL: ${url}
Headers: ${JSON.stringify(headers, null, 2)}
Data: ${JSON.stringify(data, null, 2)}`;
                
            } catch (error) {
                result.innerHTML = `<span class="error">❌ Error parsing curl: ${error.message}</span>`;
            }
        }

        async function testFrontendRequest() {
            const email = document.getElementById('testEmail').value;
            const password = document.getElementById('testPassword').value;
            const result = document.getElementById('frontendResult');
            
            if (!email || !password) {
                result.innerHTML = '<span class="error">❌ Please enter email and password</span>';
                return;
            }
            
            result.innerHTML = 'Testing frontend request...';
            
            try {
                // Simulate what your registrationAPI would do
                const requestData = {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Accept': 'application/json'
                    },
                    body: JSON.stringify({ email, password })
                };
                
                console.log('=== FRONTEND REQUEST DEBUG ===');
                console.log('URL:', 'https://system.nytevibe.com/api/auth/login');
                console.log('Headers:', requestData.headers);
                console.log('Body:', requestData.body);
                
                const response = await fetch('https://system.nytevibe.com/api/auth/login', requestData);
                const data = await response.json();
                
                console.log('Response Status:', response.status);
                console.log('Response Headers:', Object.fromEntries(response.headers.entries()));
                console.log('Response Data:', data);
                
                frontendData = {
                    request: requestData,
                    response: { status: response.status, data }
                };
                
                if (response.ok) {
                    result.innerHTML = `<span class="success">✅ Frontend Request Successful (${response.status})</span>
Response: ${JSON.stringify(data, null, 2)}`;
                } else {
                    result.innerHTML = `<span class="error">❌ Frontend Request Failed (${response.status})</span>
Error: ${JSON.stringify(data, null, 2)}`;
                }
                
                updateComparison();
                
            } catch (error) {
                console.error('Frontend request error:', error);
                result.innerHTML = `<span class="error">❌ Frontend Request Error: ${error.message}</span>`;
            }
        }

        async function testMinimalRequest() {
            const email = document.getElementById('testEmail').value;
            const password = document.getElementById('testPassword').value;
            const result = document.getElementById('frontendResult');
            
            if (!email || !password) {
                result.innerHTML = '<span class="error">❌ Please enter email and password</span>';
                return;
            }
            
            result.innerHTML = 'Testing minimal request (like curl)...';
            
            try {
                // Exact same as curl - minimal headers
                const requestData = {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({ email, password })
                };
                
                console.log('=== MINIMAL REQUEST DEBUG ===');
                console.log('URL:', 'https://system.nytevibe.com/api/auth/login');
                console.log('Headers:', requestData.headers);
                console.log('Body:', requestData.body);
                
                const response = await fetch('https://system.nytevibe.com/api/auth/login', requestData);
                const data = await response.json();
                
                console.log('Response Status:', response.status);
                console.log('Response Headers:', Object.fromEntries(response.headers.entries()));
                console.log('Response Data:', data);
                
                if (response.ok) {
                    result.innerHTML = `<span class="success">✅ Minimal Request Successful (${response.status})</span>
Response: ${JSON.stringify(data, null, 2)}
<span class="success">🎉 This means the issue is extra headers in your registrationAPI!</span>`;
                } else {
                    result.innerHTML = `<span class="error">❌ Minimal Request Failed (${response.status})</span>
Error: ${JSON.stringify(data, null, 2)}
<span class="warning">⚠️ This suggests the issue is not just headers</span>`;
                }
                
            } catch (error) {
                console.error('Minimal request error:', error);
                result.innerHTML = `<span class="error">❌ Minimal Request Error: ${error.message}</span>`;
            }
        }

        function updateComparison() {
            if (!curlData && !frontendData) return;
            
            document.getElementById('comparison').style.display = 'grid';
            
            if (curlData) {
                document.getElementById('curlDetails').innerHTML = `URL: ${curlData.url}
Headers: ${JSON.stringify(curlData.headers, null, 2)}
Body: ${JSON.stringify(curlData.data, null, 2)}`;
            }
            
            if (frontendData) {
                document.getElementById('frontendDetails').innerHTML = `URL: https://system.nytevibe.com/api/auth/login
Headers: ${JSON.stringify(frontendData.request.headers, null, 2)}
Body: ${frontendData.request.body}
Status: ${frontendData.response.status}
Response: ${JSON.stringify(frontendData.response.data, null, 2)}`;
            }
            
            // Generate diagnostics
            generateDiagnostics();
        }

        function generateDiagnostics() {
            const diagnostics = document.getElementById('diagnostics');
            let html = '<h3>🔍 Diagnostic Analysis</h3>';
            
            if (frontendData) {
                const status = frontendData.response.status;
                if (status === 422) {
                    html += '<p><span class="error">❌ 422 Unprocessable Content</span> - Server rejected the request format</p>';
                    html += '<p><span class="warning">🔍 Possible causes:</span></p>';
                    html += '<ul>';
                    html += '<li>Wrong field names (email vs username)</li>';
                    html += '<li>Extra headers server doesn\'t expect</li>';
                    html += '<li>Missing required fields</li>';
                    html += '<li>Wrong Content-Type</li>';
                    html += '<li>CORS issues</li>';
                    html += '</ul>';
                } else if (status === 200 || status === 201) {
                    html += '<p><span class="success">✅ Request successful!</span></p>';
                } else {
                    html += `<p><span class="error">❌ HTTP ${status}</span></p>';
                }
            }
            
            diagnostics.innerHTML = html;
        }

        // Auto-fill common curl for testing
        document.getElementById('curlCommand').value = `curl -X POST https://system.nytevibe.com/api/auth/login \\
  -H "Content-Type: application/json" \\
  -d '{"email":"iammrpwinner01@gmail.com","password":"Scario@02"}'`;
    </script>
</body>
</html>
EOF

echo "✅ Created browser debugging tool: debug_browser_request.html"

echo ""
echo ">>> 3. IMMEDIATE DEBUGGING STEPS"
echo "----------------------------------------"

echo "Step 1: Restart your dev server to ensure changes are applied:"
echo "  npm run dev  # or yarn dev"
echo ""

echo "Step 2: Clear browser cache:"
echo "  - Press Ctrl+Shift+R (or Cmd+Shift+R on Mac)"
echo "  - Or open DevTools > Network tab > right-click > 'Clear browser cache'"
echo ""

echo "Step 3: Open debug_browser_request.html in your browser:"
echo "  open debug_browser_request.html"
echo "  # or manually open the file in your browser"
echo ""

echo "Step 4: Use browser DevTools Network tab:"
echo "  1. Open DevTools (F12)"
echo "  2. Go to Network tab"
echo "  3. Try to login on your site"
echo "  4. Click on the failed POST request"
echo "  5. Look at Request Headers and Request Payload"
echo ""

echo ">>> 4. QUICK VERIFICATION COMMANDS"
echo "----------------------------------------"

echo "Check what your browser actually sends:"
echo "1. Go to your site (blackaxl.com)"
echo "2. Open browser console (F12)"
echo "3. Paste this and run it:"
echo ""

cat << 'EOF'
// Test exact request your app should make
fetch('https://system.nytevibe.com/api/auth/login', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    email: 'iammrpwinner01@gmail.com',
    password: 'Scario@02'
  })
})
.then(response => {
  console.log('Status:', response.status);
  console.log('Headers:', Object.fromEntries(response.headers.entries()));
  return response.json();
})
.then(data => console.log('Data:', data))
.catch(error => console.error('Error:', error));
EOF

echo ""
echo ">>> 5. WHAT TO LOOK FOR"
echo "----------------------------------------"
echo "🔍 In Browser DevTools Network tab, check the failing request for:"
echo "  - Request URL (should be: https://system.nytevibe.com/api/auth/login)"
echo "  - Request Method (should be: POST)"
echo "  - Request Headers (look for unexpected headers)"
echo "  - Request Payload (should be: {\"email\":\"...\",\"password\":\"...\"})"
echo ""
echo "🎯 Common issues that cause 422:"
echo "  ❌ Still sending 'username' instead of 'email'"
echo "  ❌ Extra headers like X-Requested-With"
echo "  ❌ Browser cache serving old JavaScript"
echo "  ❌ Dev server not restarted after changes"
echo ""

echo "======================================================="
echo "🎯 NEXT: Use the debugging tools above to find the exact difference!"
echo "======================================================="
