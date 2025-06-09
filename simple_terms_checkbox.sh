#!/bin/bash

# Implement a simpler checkbox approach for terms acceptance
# This avoids complex modal state management

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Implementing Simple Terms Checkbox Solution...${NC}"

# Update RegistrationView.jsx with checkbox approach
cat > /tmp/add_terms_checkbox.py << 'EOF'
#!/usr/bin/env python3
import re

# Read the current file
with open('/var/www/nytevibe/src/components/Registration/RegistrationView.jsx', 'r') as f:
    content = f.read()

# 1. Add termsAccepted to formData state
if 'termsAccepted:' not in content:
    # Find formData state and add termsAccepted
    formdata_pattern = r"(const \[formData, setFormData\] = useState\({[^}]+)"
    formdata_match = re.search(formdata_pattern, content, re.DOTALL)
    if formdata_match:
        old_formdata = formdata_match.group(1)
        new_formdata = old_formdata.rstrip() + ",\n    termsAccepted: false"
        content = content.replace(old_formdata, new_formdata)
        print("✓ Added termsAccepted to formData")

# 2. Update handleRegistration to check terms
handle_reg_pattern = r"const handleRegistration = async \(\) => \{[^}]+if \(!validateCurrentStep\(\)\) \{[^}]+\}"
handle_reg_match = re.search(handle_reg_pattern, content, re.DOTALL)

if handle_reg_match and 'termsAccepted' not in handle_reg_match.group(0):
    old_handler = handle_reg_match.group(0)
    new_handler = """const handleRegistration = async () => {
    if (!validateCurrentStep()) {
      return;
    }
    
    // Check if terms are accepted
    if (!formData.termsAccepted) {
      setValidation({ termsAccepted: ['You must accept the terms and conditions to continue'] });
      actions.addNotification({
        type: 'error',
        message: 'Please accept the terms and conditions to continue',
        duration: 4000
      });
      return;
    }"""
    
    content = content.replace(old_handler, new_handler)
    print("✓ Updated handleRegistration to check terms")

# 3. Add the checkbox to step 5 (Location step)
# Find the LocationStep component and add checkbox
location_step_end = content.find('</div>\n);', content.find('const LocationStep = '))
if location_step_end != -1 and 'termsAccepted' not in content[content.find('const LocationStep = '):location_step_end]:
    # Add the checkbox before the closing div
    checkbox_html = """
      
      {/* Terms and Conditions */}
      <div className="form-group terms-group">
        <label className="checkbox-label">
          <input
            type="checkbox"
            checked={formData.termsAccepted}
            onChange={(e) => onChange('termsAccepted', e.target.checked)}
            className="terms-checkbox"
          />
          <span className="checkbox-text">
            I accept the{' '}
            <a 
              href="/terms" 
              target="_blank" 
              rel="noopener noreferrer"
              className="terms-link"
              onClick={(e) => {
                e.preventDefault();
                window.open('/terms', '_blank', 'width=800,height=600,scrollbars=yes');
              }}
            >
              Terms and Conditions
            </a>
          </span>
        </label>
        {validation.termsAccepted && (
          <div className="field-errors">
            {validation.termsAccepted.map((error, idx) => (
              <span key={idx} className="error-message">{error}</span>
            ))}
          </div>
        )}
      </div>
    </div>"""
    
    content = content[:location_step_end] + checkbox_html + content[location_step_end:]
    print("✓ Added terms checkbox to location step")

# Write the updated content
with open('/var/www/nytevibe/src/components/Registration/RegistrationView.jsx', 'w') as f:
    f.write(content)

print("✓ RegistrationView updated with checkbox approach")
EOF

python3 /tmp/add_terms_checkbox.py

# Add checkbox styles
echo -e "\n${BLUE}Adding checkbox styles...${NC}"

cat >> /var/www/nytevibe/src/components/Registration/availability.css << 'EOF'

/* Terms and Conditions Checkbox */
.terms-group {
  margin-top: 2rem;
  padding-top: 1.5rem;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
}

.checkbox-label {
  display: flex;
  align-items: flex-start;
  cursor: pointer;
  user-select: none;
}

.terms-checkbox {
  width: 20px;
  height: 20px;
  margin-right: 12px;
  margin-top: 2px;
  cursor: pointer;
  accent-color: #8b5cf6;
}

.checkbox-text {
  flex: 1;
  font-size: 0.95rem;
  line-height: 1.5;
  color: #e5e7eb;
}

.terms-link {
  color: #8b5cf6;
  text-decoration: underline;
  transition: color 0.2s;
}

.terms-link:hover {
  color: #a78bfa;
}

.terms-group .field-errors {
  margin-top: 0.5rem;
  margin-left: 32px;
}
EOF

# Update registrationAPI.js to ensure terms_accepted is sent
echo -e "\n${BLUE}Ensuring API sends terms_accepted...${NC}"

if ! grep -q "terms_accepted: formData.termsAccepted" /var/www/nytevibe/src/services/registrationAPI.js; then
    sed -i "/zipcode: formData.zipcode || '00000',/a\                terms_accepted: formData.termsAccepted || false," /var/www/nytevibe/src/services/registrationAPI.js
fi

# Create a simple terms page
echo -e "\n${BLUE}Creating terms page...${NC}"

cat > /var/www/nytevibe/public/terms.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>nYtevibe - Terms and Conditions</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            line-height: 1.6;
            color: #333;
            max-width: 800px;
            margin: 0 auto;
            padding: 2rem;
            background: #f5f5f5;
        }
        h1, h2 { color: #8b5cf6; }
        .container {
            background: white;
            padding: 2rem;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>nYtevibe Terms and Conditions</h1>
        <p><strong>Effective Date:</strong> January 1, 2025</p>
        
        <h2>1. Acceptance of Terms</h2>
        <p>By creating an account, you agree to these Terms and Conditions.</p>
        
        <h2>2. Age Requirement</h2>
        <p>You must be at least 18 years old to use nYtevibe.</p>
        
        <h2>3. Account Registration</h2>
        <p>You agree to provide accurate information and keep it updated.</p>
        
        <h2>4. User Conduct</h2>
        <p>You agree to use the platform respectfully and lawfully.</p>
        
        <h2>5. Privacy</h2>
        <p>Your use of nYtevibe is also governed by our Privacy Policy.</p>
        
        <p><em>Full terms and conditions will be provided upon request.</em></p>
    </div>
</body>
</html>
EOF

# Remove modal-related code to prevent errors
echo -e "\n${BLUE}Cleaning up modal references...${NC}"

# Remove modal import if it exists
sed -i '/import TermsAndConditionsModal/d' /var/www/nytevibe/src/components/Registration/RegistrationView.jsx

# Remove modal state if it exists
sed -i '/const \[showTermsModal/d' /var/www/nytevibe/src/components/Registration/RegistrationView.jsx
sed -i '/const \[pendingRegistration/d' /var/www/nytevibe/src/components/Registration/RegistrationView.jsx

# Remove modal component from render
sed -i '/<TermsAndConditionsModal/,/\/>/d' /var/www/nytevibe/src/components/Registration/RegistrationView.jsx

# Build the project
echo -e "\n${BLUE}Building project...${NC}"
cd /var/www/nytevibe
npm run build

echo -e "\n${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}     Simple Terms Checkbox Implementation Complete!${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo "✓ Added terms checkbox to registration form"
echo "✓ Terms validation on submit"
echo "✓ Click link opens terms in popup"
echo "✓ Clean and simple implementation"
echo ""
echo "This approach is much simpler and avoids modal state issues!"

# Cleanup
rm -f /tmp/add_terms_checkbox.py
