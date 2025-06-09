#!/bin/bash

echo "Testing Terms Modal Implementation..."

# Test registration without terms_accepted (should fail)
echo "Test 1: Registration without terms acceptance"
curl -X POST https://system.nytevibe.com/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "test_terms_'$(date +%s)'",
    "email": "test_'$(date +%s)'@example.com",
    "password": "TestPass123!",
    "password_confirmation": "TestPass123!",
    "first_name": "Test",
    "last_name": "User",
    "date_of_birth": "2000-01-01",
    "phone": "555'$(date +%s | tail -c 8)'",
    "country": "United States",
    "state": "Texas",
    "city": "Houston"
  }'

echo -e "\n\nTest 2: Registration with terms acceptance"
curl -X POST https://system.nytevibe.com/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "test_terms_ok_'$(date +%s)'",
    "email": "test_ok_'$(date +%s)'@example.com",
    "password": "TestPass123!",
    "password_confirmation": "TestPass123!",
    "first_name": "Test",
    "last_name": "User",
    "date_of_birth": "2000-01-01",
    "phone": "555'$(date +%s | tail -c 8)'",
    "country": "United States",
    "state": "Texas",
    "city": "Houston",
    "terms_accepted": true
  }'
