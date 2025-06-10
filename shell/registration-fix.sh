#!/bin/bash

echo "🔍 Searching for Registration Form Component..."
echo "================================================"

# Search for files containing registration-related terms
echo "📁 Files containing 'register' or 'registration':"
find . -name "*.js" -o -name "*.jsx" -o -name "*.ts" -o -name "*.tsx" | \
  grep -v node_modules | \
  xargs grep -l -i "register" 2>/dev/null | \
  head -20

echo ""
echo "📁 Files containing 'signup' or 'sign up':"
find . -name "*.js" -o -name "*.jsx" -o -name "*.ts" -o -name "*.tsx" | \
  grep -v node_modules | \
  xargs grep -l -i "signup\|sign.up" 2>/dev/null | \
  head -10

echo ""
echo "📁 Searching for form components with common registration fields:"
find . -name "*.js" -o -name "*.jsx" -o -name "*.ts" -o -name "*.tsx" | \
  grep -v node_modules | \
  xargs grep -l "firstName\|lastName\|email.*password" 2>/dev/null | \
  head -10

echo ""
echo "📁 Looking for components with 'Form' in the name:"
find . -name "*[Ff]orm*" -type f | grep -v node_modules | head -10

echo ""
echo "📁 Searching for components in common directories:"
echo "--- src/components ---"
find ./src/components -name "*.js" -o -name "*.jsx" -o -name "*.ts" -o -name "*.tsx" 2>/dev/null | head -10

echo ""
echo "--- src/pages ---"
find ./src/pages -name "*.js" -o -name "*.jsx" -o -name "*.ts" -o -name "*.tsx" 2>/dev/null | head -10

echo ""
echo "--- src/views ---"
find ./src/views -name "*.js" -o -name "*.jsx" -o -name "*.ts" -o -name "*.tsx" 2>/dev/null | head -10

echo ""
echo "🔍 Quick grep for registration-related text in components:"
echo "================================================"
find . -name "*.js" -o -name "*.jsx" | \
  grep -v node_modules | \
  xargs grep -l "register\|signup" 2>/dev/null | \
  while read file; do
    echo "📄 $file:"
    grep -n -i "register\|signup\|firstName\|lastName" "$file" 2>/dev/null | head -3
    echo ""
  done
