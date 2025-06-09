#!/bin/bash

# Quick fix for missing comma in registrationAPI.js

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Fixing missing comma in registrationAPI.js...${NC}"

# Fix the missing comma - change line 93 to add comma after zipcode
sed -i '93s/zipcode: formData.zipcode || '\''00000'\'' \/\/ FIXED: Use non-empty default zipcode/zipcode: formData.zipcode || '\''00000'\'', \/\/ FIXED: Use non-empty default zipcode/' /var/www/nytevibe/src/services/registrationAPI.js

# Alternative approach if the above doesn't work - fix it with a more targeted approach
if grep -q "zipcode: formData.zipcode || '00000' // FIXED: Use non-empty default zipcode$" /var/www/nytevibe/src/services/registrationAPI.js; then
    # The line doesn't have a comma, let's add it
    sed -i "/zipcode: formData.zipcode || '00000' \/\/ FIXED: Use non-empty default zipcode$/s/$/,/" /var/www/nytevibe/src/services/registrationAPI.js
fi

echo -e "${GREEN}✓ Fixed missing comma${NC}"

# Show the corrected lines
echo -e "\n${BLUE}Corrected code:${NC}"
sed -n '92,95p' /var/www/nytevibe/src/services/registrationAPI.js

# Build again
echo -e "\n${BLUE}Building project...${NC}"
cd /var/www/nytevibe
npm run build

if [ $? -eq 0 ]; then
    echo -e "\n${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}     Build Successful!${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "✓ Syntax error fixed"
    echo "✓ Project built successfully"
    echo ""
    echo "The Terms and Conditions implementation is now complete!"
    echo "Test the registration flow to ensure everything works."
else
    echo -e "\n${RED}Build still failing. Let me check the exact issue...${NC}"
    
    # Show lines around the error
    echo -e "\n${BLUE}Lines 90-96 of registrationAPI.js:${NC}"
    sed -n '90,96p' /var/www/nytevibe/src/services/registrationAPI.js
fi
