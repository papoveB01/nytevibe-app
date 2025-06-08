#!/bin/bash

echo "🧪 Testing API Login Directly"
echo "============================"
echo ""

read -p "Enter test email: " TEST_EMAIL
read -p "Enter test password: " TEST_PASSWORD

echo ""
echo -e "\033[0;34mTesting API login...\033[0m"

# Test the API directly
RESPONSE=$(curl -s -X POST "https://system.nytevibe.com/api/auth/login" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d "{
    \"email\": \"$TEST_EMAIL\",
    \"password\": \"$TEST_PASSWORD\"
  }")

echo "API Response:"
echo "$RESPONSE" | jq . 2>/dev/null || echo "$RESPONSE"

echo ""
echo "If this shows 'Please verify your email', the issue is in the backend API."
echo "If this shows successful login, the issue is in the frontend."
