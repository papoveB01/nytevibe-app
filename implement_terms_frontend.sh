#!/bin/bash

# nYtevibe Terms and Conditions Frontend Implementation Script
# This script implements the terms modal for the registration process
# Version: 1.0
# Date: June 9, 2025

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PROJECT_ROOT="/var/www/nytevibe"
BACKUP_DIR="$PROJECT_ROOT/backups/terms_modal_$(date +%Y%m%d_%H%M%S)"
COMPONENTS_DIR="$PROJECT_ROOT/src/components"
SERVICES_DIR="$PROJECT_ROOT/src/services"
STYLES_DIR="$PROJECT_ROOT/src/styles"

# Functions
print_status() {
    echo -e "${BLUE}[$(date +%H:%M:%S)]${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Create backup directory
create_backups() {
    print_status "Creating backup directory..."
    mkdir -p "$BACKUP_DIR"
    
    # Backup existing files
    if [ -f "$COMPONENTS_DIR/Registration/RegistrationView.jsx" ]; then
        cp "$COMPONENTS_DIR/Registration/RegistrationView.jsx" "$BACKUP_DIR/RegistrationView.jsx.backup"
        print_success "Backed up RegistrationView.jsx"
    fi
    
    if [ -f "$SERVICES_DIR/registrationAPI.js" ]; then
        cp "$SERVICES_DIR/registrationAPI.js" "$BACKUP_DIR/registrationAPI.js.backup"
        print_success "Backed up registrationAPI.js"
    fi
    
    print_success "Backups created in: $BACKUP_DIR"
}

# Create modal directories
create_directories() {
    print_status "Creating component directories..."
    
    mkdir -p "$COMPONENTS_DIR/modals"
    mkdir -p "$COMPONENTS_DIR/content"
    
    print_success "Directories created"
}

# Create the Terms and Conditions Modal component
create_terms_modal() {
    print_status "Creating Terms and Conditions Modal component..."
    
    cat > "$COMPONENTS_DIR/modals/TermsAndConditionsModal.jsx" << 'EOF'
import React, { useState, useEffect, useRef } from 'react';
import { X, ChevronDown, FileText, Shield, AlertCircle } from 'lucide-react';
import TermsAndConditionsContent from '../content/TermsAndConditionsContent';
import './TermsModal.css';

const TermsAndConditionsModal = ({ isOpen, onAccept, onDecline }) => {
  const [hasScrolledToBottom, setHasScrolledToBottom] = useState(false);
  const [isScrollable, setIsScrollable] = useState(false);
  const contentRef = useRef(null);
  const modalRef = useRef(null);

  useEffect(() => {
    if (isOpen && contentRef.current) {
      // Check if content is scrollable
      const element = contentRef.current;
      const isContentScrollable = element.scrollHeight > element.clientHeight;
      setIsScrollable(isContentScrollable);
      
      // If not scrollable, enable accept button immediately
      if (!isContentScrollable) {
        setHasScrolledToBottom(true);
      } else {
        // Reset scroll position and button state
        element.scrollTop = 0;
        setHasScrolledToBottom(false);
      }
    }
  }, [isOpen]);

  // Handle scroll to check if user reached bottom
  const handleScroll = (e) => {
    if (!isScrollable) return;
    
    const element = e.target;
    const scrolledToBottom = Math.abs(element.scrollHeight - element.clientHeight - element.scrollTop) < 5;
    
    if (scrolledToBottom && !hasScrolledToBottom) {
      setHasScrolledToBottom(true);
    }
  };

  // Prevent closing on escape
  useEffect(() => {
    const handleEscape = (e) => {
      if (e.key === 'Escape' && isOpen) {
        e.preventDefault();
      }
    };

    if (isOpen) {
      document.addEventListener('keydown', handleEscape);
      document.body.style.overflow = 'hidden';
    }

    return () => {
      document.removeEventListener('keydown', handleEscape);
      document.body.style.overflow = 'unset';
    };
  }, [isOpen]);

  if (!isOpen) return null;

  return (
    <div className="terms-modal-overlay" onClick={(e) => e.preventDefault()}>
      <div className="terms-modal" ref={modalRef} role="dialog" aria-modal="true" aria-labelledby="terms-title">
        {/* Header */}
        <div className="terms-modal-header">
          <div className="terms-header-content">
            <Shield className="terms-icon" />
            <h2 id="terms-title" className="terms-title">Terms and Conditions</h2>
          </div>
          <p className="terms-subtitle">Please read and accept our terms to continue</p>
        </div>

        {/* Scroll indicator */}
        {isScrollable && !hasScrolledToBottom && (
          <div className="terms-scroll-indicator">
            <ChevronDown className="scroll-icon" />
            <span>Scroll to read all terms</span>
          </div>
        )}

        {/* Content */}
        <div 
          className="terms-modal-content" 
          ref={contentRef}
          onScroll={handleScroll}
        >
          <TermsAndConditionsContent />
        </div>

        {/* Footer */}
        <div className="terms-modal-footer">
          <div className="terms-footer-info">
            <AlertCircle className="info-icon" />
            <span>By accepting, you agree to be bound by these terms</span>
          </div>
          
          <div className="terms-actions">
            <button
              onClick={onDecline}
              className="terms-button decline"
              type="button"
            >
              Decline
            </button>
            
            <button
              onClick={onAccept}
              className={`terms-button accept ${!hasScrolledToBottom && isScrollable ? 'disabled' : ''}`}
              disabled={!hasScrolledToBottom && isScrollable}
              type="button"
            >
              <FileText className="button-icon" />
              I Accept the Terms
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default TermsAndConditionsModal;
EOF
    
    print_success "Terms Modal component created"
}

# Create the Terms Content component
create_terms_content() {
    print_status "Creating Terms Content component..."
    
    # Create the component with the full terms text
    cat > "$COMPONENTS_DIR/content/TermsAndConditionsContent.jsx" << 'EOF'
import React from 'react';

const TermsAndConditionsContent = () => {
  return (
    <div className="terms-content">
      <div className="terms-header-info">
        <p><strong>Effective Date:</strong> January 1, 2025</p>
        <p><strong>Last Updated:</strong> January 1, 2025</p>
      </div>

      <section className="terms-section">
        <h3>1. Acceptance of Terms</h3>
        <p><strong>1.1</strong> Welcome to nYtevibe! These Terms and Conditions ("Terms") form a legally binding agreement between you and nYtevibe, Inc. ("Company," "we," "us," or "our") regarding your use of our nightlife discovery platform, website, mobile application, and related services (collectively, the "Platform").</p>
        <p><strong>1.2</strong> By creating an account, accessing, or using our Platform, you acknowledge that you have read, understood, and agree to be bound by these Terms and our Privacy Policy, which is incorporated herein by reference.</p>
        <p><strong>1.3</strong> If you do not agree to these Terms, you must not use our Platform.</p>
        <p><strong>1.4</strong> We may update these Terms from time to time. Your continued use of the Platform after changes are posted constitutes acceptance of the revised Terms.</p>
      </section>

      <section className="terms-section">
        <h3>2. Eligibility and Account Requirements</h3>
        <p><strong>2.1 Age Requirement:</strong> You must be at least 18 years old to use our Platform. By using our Platform, you represent that you are at least 18 years old and have the legal capacity to enter into binding agreements.</p>
        <p><strong>2.2 Geographic Restrictions:</strong> Our Platform is intended for users in jurisdictions where nightlife discovery services are legal. You are responsible for compliance with local laws.</p>
        <p><strong>2.3 Account Registration:</strong> To access certain features, you must:</p>
        <ul>
          <li>Provide accurate, complete, and current information</li>
          <li>Maintain and update your account information</li>
          <li>Keep your login credentials confidential</li>
          <li>Accept responsibility for all activities under your account</li>
        </ul>
        <p><strong>2.4 One Account Per Person:</strong> You may maintain only one personal account. Creating multiple accounts may result in termination of all accounts.</p>
      </section>

      <section className="terms-section">
        <h3>3. Platform Services</h3>
        <p><strong>3.1 Core Services:</strong> nYtevibe provides:</p>
        <ul>
          <li>Venue discovery and search functionality</li>
          <li>User-generated reviews and ratings</li>
          <li>Event listings and information</li>
          <li>Social networking features</li>
          <li>Venue booking and reservation services (where available)</li>
          <li>Premium subscription features</li>
        </ul>
        <p><strong>3.2 Third-Party Services:</strong> Our Platform may integrate with third-party services. Your use of such services is subject to their respective terms and conditions.</p>
        <p><strong>3.3 Service Availability:</strong> We strive to maintain continuous service availability but do not guarantee uninterrupted access.</p>
      </section>

      <section className="terms-section">
        <h3>4. User Conduct and Community Guidelines</h3>
        <p><strong>4.1 General Conduct:</strong> You agree to use the Platform lawfully and respectfully.</p>
        <p><strong>4.2 Prohibited Activities:</strong> You may not:</p>
        <ul>
          <li>Create fake accounts or impersonate others</li>
          <li>Submit false, misleading, or fraudulent reviews</li>
          <li>Post spam or unauthorized advertising</li>
          <li>Upload harmful code or malicious software</li>
          <li>Harass, threaten, or abuse other users</li>
          <li>Violate intellectual property rights</li>
          <li>Use automated systems to access our Platform</li>
          <li>Engage in illegal activities</li>
        </ul>
      </section>

      <section className="terms-section">
        <h3>5. Privacy and Data Protection</h3>
        <p><strong>5.1</strong> We collect and process personal information as described in our Privacy Policy.</p>
        <p><strong>5.2</strong> Our Platform may access location information to provide relevant venue recommendations.</p>
        <p><strong>5.3</strong> By using our Platform, you consent to receive communications from us.</p>
        <p><strong>5.4</strong> We implement reasonable security measures to protect your information.</p>
      </section>

      <section className="terms-section">
        <h3>6. Disclaimers and Limitations</h3>
        <p><strong>6.1</strong> Our Platform is provided "as is" and "as available."</p>
        <p><strong>6.2</strong> We do not endorse or guarantee the accuracy of user content.</p>
        <p><strong>6.3</strong> We are not responsible for the quality, safety, or legality of venues.</p>
        <p><strong>6.4</strong> Our liability is limited to the maximum extent permitted by law.</p>
      </section>

      <section className="terms-section">
        <h3>7. Contact Information</h3>
        <p>For questions about these Terms, please contact us:</p>
        <p><strong>nYtevibe, Inc.</strong><br />
        Email: legal@nytevibe.com<br />
        Customer Support: support@nytevibe.com</p>
      </section>

      <div className="terms-footer-text">
        <p><em>By using nYtevibe, you acknowledge that you have read, understood, and agree to be bound by these Terms and Conditions.</em></p>
      </div>
    </div>
  );
};

export default TermsAndConditionsContent;
EOF
    
    print_success "Terms Content component created"
}

# Create CSS for the modal
create_modal_styles() {
    print_status "Creating modal styles..."
    
    cat > "$COMPONENTS_DIR/modals/TermsModal.css" << 'EOF'
/* Terms and Conditions Modal Styles */
.terms-modal-overlay {
  position: fixed;
  inset: 0;
  background-color: rgba(0, 0, 0, 0.75);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 10000;
  padding: 1rem;
  animation: fadeIn 0.2s ease-out;
}

@keyframes fadeIn {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}

.terms-modal {
  background: #ffffff;
  border-radius: 16px;
  box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
  max-width: 800px;
  width: 100%;
  max-height: 90vh;
  display: flex;
  flex-direction: column;
  animation: slideUp 0.3s ease-out;
}

@keyframes slideUp {
  from {
    transform: translateY(20px);
    opacity: 0;
  }
  to {
    transform: translateY(0);
    opacity: 1;
  }
}

/* Header */
.terms-modal-header {
  padding: 2rem 2rem 1.5rem;
  border-bottom: 1px solid #e5e7eb;
}

.terms-header-content {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  margin-bottom: 0.5rem;
}

.terms-icon {
  width: 28px;
  height: 28px;
  color: #8b5cf6;
}

.terms-title {
  font-size: 1.875rem;
  font-weight: 700;
  color: #111827;
  margin: 0;
}

.terms-subtitle {
  color: #6b7280;
  font-size: 1rem;
  margin: 0;
}

/* Scroll Indicator */
.terms-scroll-indicator {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  padding: 0.75rem;
  background: #f3f4f6;
  color: #6b7280;
  font-size: 0.875rem;
  animation: pulse 2s infinite;
}

@keyframes pulse {
  0%, 100% {
    opacity: 1;
  }
  50% {
    opacity: 0.6;
  }
}

.scroll-icon {
  width: 16px;
  height: 16px;
  animation: bounce 1s infinite;
}

@keyframes bounce {
  0%, 100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(3px);
  }
}

/* Content */
.terms-modal-content {
  flex: 1;
  overflow-y: auto;
  padding: 2rem;
  max-height: 500px;
}

/* Terms Content Styling */
.terms-content {
  color: #374151;
  line-height: 1.7;
}

.terms-header-info {
  margin-bottom: 2rem;
  padding: 1rem;
  background: #f9fafb;
  border-radius: 8px;
}

.terms-header-info p {
  margin: 0.25rem 0;
  font-size: 0.875rem;
}

.terms-section {
  margin-bottom: 2rem;
}

.terms-section h3 {
  color: #111827;
  font-size: 1.25rem;
  font-weight: 600;
  margin-bottom: 1rem;
}

.terms-section p {
  margin-bottom: 0.75rem;
}

.terms-section ul {
  margin: 0.75rem 0 0.75rem 1.5rem;
  padding-left: 1rem;
}

.terms-section li {
  margin-bottom: 0.5rem;
}

.terms-footer-text {
  margin-top: 2rem;
  padding-top: 2rem;
  border-top: 1px solid #e5e7eb;
  text-align: center;
  font-style: italic;
  color: #6b7280;
}

/* Footer */
.terms-modal-footer {
  padding: 1.5rem 2rem;
  border-top: 1px solid #e5e7eb;
  background: #f9fafb;
  border-radius: 0 0 16px 16px;
}

.terms-footer-info {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin-bottom: 1rem;
  color: #6b7280;
  font-size: 0.875rem;
}

.info-icon {
  width: 16px;
  height: 16px;
  color: #3b82f6;
}

.terms-actions {
  display: flex;
  gap: 1rem;
  justify-content: flex-end;
}

/* Buttons */
.terms-button {
  padding: 0.75rem 1.5rem;
  border-radius: 8px;
  font-weight: 600;
  font-size: 1rem;
  transition: all 0.2s;
  cursor: pointer;
  border: none;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.terms-button.decline {
  background: #ffffff;
  color: #6b7280;
  border: 2px solid #e5e7eb;
}

.terms-button.decline:hover {
  background: #f3f4f6;
  border-color: #d1d5db;
}

.terms-button.accept {
  background: #8b5cf6;
  color: white;
}

.terms-button.accept:hover:not(.disabled) {
  background: #7c3aed;
  transform: translateY(-1px);
  box-shadow: 0 4px 6px -1px rgba(139, 92, 246, 0.3);
}

.terms-button.accept.disabled {
  background: #d1d5db;
  cursor: not-allowed;
  opacity: 0.6;
}

.button-icon {
  width: 18px;
  height: 18px;
}

/* Responsive */
@media (max-width: 640px) {
  .terms-modal {
    max-height: 100vh;
    height: 100vh;
    max-width: 100%;
    border-radius: 0;
    margin: 0;
  }
  
  .terms-modal-overlay {
    padding: 0;
  }
  
  .terms-modal-header {
    padding: 1.5rem 1rem 1rem;
  }
  
  .terms-title {
    font-size: 1.5rem;
  }
  
  .terms-modal-content {
    padding: 1rem;
  }
  
  .terms-modal-footer {
    padding: 1rem;
    border-radius: 0;
  }
  
  .terms-actions {
    flex-direction: column-reverse;
    width: 100%;
  }
  
  .terms-button {
    width: 100%;
    justify-content: center;
  }
}

/* Scrollbar styling */
.terms-modal-content::-webkit-scrollbar {
  width: 8px;
}

.terms-modal-content::-webkit-scrollbar-track {
  background: #f3f4f6;
  border-radius: 4px;
}

.terms-modal-content::-webkit-scrollbar-thumb {
  background: #d1d5db;
  border-radius: 4px;
}

.terms-modal-content::-webkit-scrollbar-thumb:hover {
  background: #9ca3af;
}
EOF
    
    print_success "Modal styles created"
}

# Update RegistrationView to include modal
update_registration_view() {
    print_status "Updating RegistrationView component..."
    
    # Create a temporary file with the updated component
    cp "$COMPONENTS_DIR/Registration/RegistrationView.jsx" "$COMPONENTS_DIR/Registration/RegistrationView.jsx.tmp"
    
    # Add import for the modal at the top of the file
    sed -i "/import registrationAPI/a\\import TermsAndConditionsModal from '../modals/TermsAndConditionsModal';" "$COMPONENTS_DIR/Registration/RegistrationView.jsx.tmp"
    
    # Add state for modal after other states (find the line with const [isLoading and add after it)
    sed -i "/const \[isLoading, setIsLoading\] = useState(false);/a\\  \\
  // Terms modal state\\
  const [showTermsModal, setShowTermsModal] = useState(false);\\
  const [pendingRegistration, setPendingRegistration] = useState(false);" "$COMPONENTS_DIR/Registration/RegistrationView.jsx.tmp"
    
    # Replace handleRegistration function with new version that shows modal first
    cat > /tmp/new_handle_registration.txt << 'EOF'
  // Handle registration submission
  const handleRegistration = async () => {
    if (!validateCurrentStep()) {
      return;
    }
    
    // Show terms modal instead of immediate registration
    setShowTermsModal(true);
  };
  
  // Handle terms acceptance
  const handleTermsAccept = async () => {
    setShowTermsModal(false);
    setPendingRegistration(true);
    setIsLoading(true);
    
    try {
      // Prepare data for API with terms acceptance
      const registrationData = {
        ...formData,
        // Convert country code to full name for API
        country: formData.country === 'US' ? 'United States' : 
                 formData.country === 'CA' ? 'Canada' : formData.country,
        terms_accepted: true // Add terms acceptance
      };
      
      // API handles field mapping including phone
      const response = await registrationAPI.register(registrationData);
      
      if (response.status === 'success') {
        // Show success notification
        actions.addNotification({
          type: 'success',
          message: `✅ Registration successful! Check your email for verification link.`,
          important: true,
          duration: 6000
        });
        
        // Store email for potential resend verification
        localStorage.setItem('pending_verification_email', formData.email);
        
        // Redirect to login with verification message
        actions.setVerificationMessage({
          show: true,
          email: formData.email,
          type: 'registration_success'
        });
        
        // Call success callback (should redirect to login)
        onSuccess && onSuccess({
          requiresVerification: true,
          email: formData.email
        });
      }
    } catch (error) {
      console.error('Registration failed:', error);
      if (error instanceof APIError) {
        if (error.status === 422) {
          // Validation errors from backend
          setValidation(error.errors);
          actions.addNotification({
            type: 'error',
            message: 'Please check the form for errors and try again.',
            duration: 4000
          });
        } else if (error.status === 429) {
          actions.addNotification({
            type: 'error',
            message: 'Too many registration attempts. Please try again later.',
            duration: 5000
          });
        } else {
          actions.addNotification({
            type: 'error',
            message: 'Registration failed. Please try again.',
            duration: 4000
          });
        }
      } else {
        actions.addNotification({
          type: 'error',
          message: 'Network error. Please check your connection.',
          duration: 4000
        });
      }
    } finally {
      setIsLoading(false);
      setPendingRegistration(false);
    }
  };
  
  // Handle terms decline
  const handleTermsDecline = () => {
    setShowTermsModal(false);
    
    // Show notification
    actions.addNotification({
      type: 'info',
      message: 'You must accept the terms and conditions to create an account.',
      duration: 4000
    });
    
    // Redirect to login after a short delay
    setTimeout(() => {
      onBack && onBack();
    }, 1500);
  };
EOF

    # Find and replace the handleRegistration function
    perl -i -pe 'BEGIN{$/=undef} s/\/\/ Handle registration submission.*?^\s*\};/`cat /tmp/new_handle_registration.txt`/sme' "$COMPONENTS_DIR/Registration/RegistrationView.jsx.tmp"
    
    # Add the modal component before the closing div of the registration-page
    sed -i '/<\/div>$/i\      {/* Terms and Conditions Modal */}\
      <TermsAndConditionsModal\
        isOpen={showTermsModal}\
        onAccept={handleTermsAccept}\
        onDecline={handleTermsDecline}\
      />' "$COMPONENTS_DIR/Registration/RegistrationView.jsx.tmp"
    
    # Move the temporary file to the original
    mv "$COMPONENTS_DIR/Registration/RegistrationView.jsx.tmp" "$COMPONENTS_DIR/Registration/RegistrationView.jsx"
    
    print_success "RegistrationView updated"
}

# Update registrationAPI to ensure terms_accepted is sent
update_registration_api() {
    print_status "Updating registrationAPI..."
    
    # The API already handles all fields properly, but let's ensure terms_accepted is included
    cp "$SERVICES_DIR/registrationAPI.js" "$SERVICES_DIR/registrationAPI.js.tmp"
    
    # Add terms_accepted to the apiData object in the register method
    sed -i "/zipcode: formData.zipcode || '00000'/a\\                terms_accepted: formData.terms_accepted || false // Add terms acceptance field" "$SERVICES_DIR/registrationAPI.js.tmp"
    
    # Move the temporary file to the original
    mv "$SERVICES_DIR/registrationAPI.js.tmp" "$SERVICES_DIR/registrationAPI.js"
    
    print_success "registrationAPI updated"
}

# Build the project
build_project() {
    print_status "Building the project..."
    
    cd "$PROJECT_ROOT"
    
    # Clear cache
    npm run build || yarn build
    
    if [ $? -eq 0 ]; then
        print_success "Project built successfully"
    else
        print_warning "Build failed. Please check for errors and build manually"
    fi
}

# Generate test script
generate_test_script() {
    print_status "Generating test script..."
    
    cat > "$BACKUP_DIR/test_terms_modal.sh" << 'EOF'
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
EOF
    
    chmod +x "$BACKUP_DIR/test_terms_modal.sh"
    print_success "Test script created: $BACKUP_DIR/test_terms_modal.sh"
}

# Generate rollback script
generate_rollback_script() {
    print_status "Generating rollback script..."
    
    cat > "$BACKUP_DIR/rollback.sh" << 'EOF'
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
EOF
    
    chmod +x "$BACKUP_DIR/rollback.sh"
    print_success "Rollback script created: $BACKUP_DIR/rollback.sh"
}

# Main execution
main() {
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}     nYtevibe Terms Modal Frontend Implementation${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    # Check if running as appropriate user
    if [ "$EUID" -eq 0 ]; then 
        print_warning "Running as root. Consider running as the web server user."
    fi
    
    # Create backups
    create_backups
    
    # Create directories
    create_directories
    
    # Create components
    create_terms_modal
    create_terms_content
    create_modal_styles
    
    # Update existing components
    update_registration_view
    update_registration_api
    
    # Generate scripts
    generate_test_script
    generate_rollback_script
    
    echo ""
    read -p "Ready to build the project. Continue? (y/n): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        build_project
    else
        print_warning "Build skipped. Run manually with: npm run build"
    fi
    
    echo ""
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}     Frontend Implementation Complete!${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "What's been implemented:"
    echo "✓ Terms and Conditions Modal component"
    echo "✓ Modal shows before registration submission"
    echo "✓ Accept button enables after scrolling (if needed)"
    echo "✓ Decline redirects to login page"
    echo "✓ terms_accepted field sent to API"
    echo ""
    echo "Important Files:"
    echo "- Backup Directory: $BACKUP_DIR"
    echo "- Modal Component: $COMPONENTS_DIR/modals/TermsAndConditionsModal.jsx"
    echo "- Terms Content: $COMPONENTS_DIR/content/TermsAndConditionsContent.jsx"
    echo "- Test Script: $BACKUP_DIR/test_terms_modal.sh"
    echo "- Rollback Script: $BACKUP_DIR/rollback.sh"
    echo ""
    echo "Next Steps:"
    echo "1. Test the registration flow in browser"
    echo "2. Verify modal appears before submission"
    echo "3. Test both Accept and Decline flows"
    echo "4. Monitor console for any errors"
    echo ""
    print_success "Terms modal is now required for all registrations!"
}

# Cleanup
rm -f /tmp/new_handle_registration.txt

# Run main function
main
