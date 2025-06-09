#!/bin/bash

# Fix the missing comma syntax error

echo "Fixing missing comma on line 61..."

# Add comma after zipcode: ''
sed -i "61s/zipcode: ''/zipcode: '',/" /var/www/nytevibe/src/components/Registration/RegistrationView.jsx

# Show the fixed lines
echo -e "\nFixed code (lines 59-64):"
sed -n '59,64p' /var/www/nytevibe/src/components/Registration/RegistrationView.jsx

# Build again
echo -e "\nBuilding project..."
cd /var/www/nytevibe
npm run build

if [ $? -eq 0 ]; then
    echo -e "\n✅ Build successful! The Terms checkbox implementation is complete!"
    echo ""
    echo "Next steps:"
    echo "1. Test the registration flow"
    echo "2. Check that the checkbox appears on step 5"
    echo "3. Verify terms acceptance is required"
else
    echo -e "\n❌ Build still failing. Let's check the exact issue..."
    # Show more context
    sed -n '55,70p' /var/www/nytevibe/src/components/Registration/RegistrationView.jsx
fi
