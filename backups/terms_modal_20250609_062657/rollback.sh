#!/bin/bash
# Rollback script for terms modal implementation

echo "Rolling back terms modal implementation..."

# Restore original files
cp RegistrationView.jsx.backup /var/www/nytevibe/src/components/Registration/RegistrationView.jsx
cp registrationAPI.js.backup /var/www/nytevibe/src/services/registrationAPI.js

# Remove new components
rm -f /var/www/nytevibe/src/components/modals/TermsAndConditionsModal.jsx
rm -f /var/www/nytevibe/src/components/modals/TermsModal.css
rm -f /var/www/nytevibe/src/components/content/TermsAndConditionsContent.jsx

echo "Rollback completed! Remember to rebuild the project."
