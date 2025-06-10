#!/bin/bash

echo "🧪 Testing Forgot Password Flow"
echo "==============================="

read -p "Enter test email: " TEST_EMAIL

echo ""
echo "📧 Testing forgot password API call..."

# Test the forgot password API
RESPONSE=$(curl -s -X POST "https://system.nytevibe.com/api/auth/forgot-password" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d "{\"email\": \"$TEST_EMAIL\"}")

echo "API Response:"
echo "$RESPONSE" | jq . 2>/dev/null || echo "$RESPONSE"

echo ""
echo "If successful, check $TEST_EMAIL for password reset email."
