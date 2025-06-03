#!/bin/bash

# nYtevibe Registration API Test
# Test with dummy data and specific email

echo "🧪 Testing nYtevibe Registration API"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# API endpoint
API_URL="https://system.nytevibe.com/api/auth/register"

echo "📡 Making registration request to: $API_URL"
echo "📧 Using email: zayaconnect@gmail.com"
echo ""

# Test curl command with verbose output
curl -X POST "$API_URL" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "Origin: https://blackaxl.com" \
  -H "User-Agent: nYtevibe-Registration-Test/1.0" \
  -v \
  --connect-timeout 30 \
  --max-time 60 \
  -d '{
    "username": "pwinner01",
    "email": "zayaconnect20@gmail.com",
    "password": "TestPassword123!",
    "password_confirmation": "TestPassword123!",
    "first_name": "Test",
    "last_name": "User",
    "user_type": "user",
    "date_of_birth": "1995-06-15",
    "phone": "+1-555-123-4567",
    "country": "United States",
    "state": "Texas",
    "city": "Houston",
    "zipcode": "77001"
  }'

echo ""
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Alternative test with minimal required fields only
echo ""
echo "🔄 Testing with minimal required fields only:"
echo ""

curl -X POST "$API_URL" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "Origin: https://blackaxl.com" \
  -v \
  --connect-timeout 30 \
  --max-time 60 \
  -d '{
    "username": "testuser2025min",
    "email": "zayaconnect@gmail.com",
    "password": "TestPassword123!",
    "password_confirmation": "TestPassword123!",
    "first_name": "Test",
    "last_name": "User"
  }'

echo ""
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Test for different potential issues
echo ""
echo "🔍 Testing different scenarios:"
echo ""

# Test 1: Check if email already exists
echo "1️⃣ Testing if email already exists..."
curl -X POST "$API_URL" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "Origin: https://blackaxl.com" \
  -s \
  -d '{
    "username": "differentuser123",
    "email": "zayaconnect@gmail.com",
    "password": "TestPassword123!",
    "password_confirmation": "TestPassword123!",
    "first_name": "Different",
    "last_name": "User"
  }' | jq '.' 2>/dev/null || cat

echo ""
echo ""

# Test 2: Check with different username but same email
echo "2️⃣ Testing with different username..."
curl -X POST "$API_URL" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "Origin: https://blackaxl.com" \
  -s \
  -d '{
    "username": "zayatest2025",
    "email": "zayaconnect@gmail.com",
    "password": "SecurePass456!",
    "password_confirmation": "SecurePass456!",
    "first_name": "Zaya",
    "last_name": "Test"
  }' | jq '.' 2>/dev/null || cat

echo ""
echo ""

# Test 3: Check server connectivity
echo "3️⃣ Testing server connectivity..."
curl -I "$API_URL" -H "Origin: https://blackaxl.com" --connect-timeout 10

echo ""
echo ""

# Test 4: Check if endpoint exists with OPTIONS
echo "4️⃣ Testing CORS preflight..."
curl -X OPTIONS "$API_URL" \
  -H "Origin: https://blackaxl.com" \
  -H "Access-Control-Request-Method: POST" \
  -H "Access-Control-Request-Headers: Content-Type" \
  -v

echo ""
echo ""
echo "✅ API Testing Complete!"
echo ""
echo "📝 Common Error Scenarios to Check:"
echo " • 422 - Validation errors (email already exists, weak password, etc.)"
echo " • 429 - Rate limiting (too many requests)"
echo " • 500 - Server error"
echo " • 404 - Endpoint not found"
echo " • CORS errors - Cross-origin issues"
echo ""
echo "🔍 Look for these in the response:"
echo " • HTTP status code in the first line"
echo " • JSON error message in the body"
echo " • CORS headers in OPTIONS response"
echo " • Connection errors if server is down"
