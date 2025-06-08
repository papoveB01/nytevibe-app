#!/bin/bash

#==============================================================================
# nYtevibe Real-Time Availability - Frontend Implementation Script (Pure Bash)
# Implements real-time username/email checking in React with backup & rollback
# No Python dependencies - pure bash/sed implementation
#==============================================================================

set -e  # Exit on any error

# Configuration - UPDATE THIS PATH
PROJECT_ROOT="/var/www/nytevibe"  # UPDATE THIS PATH!
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$PROJECT_ROOT/backups/frontend_$(date +%Y%m%d_%H%M%S)"
LOG_FILE="$PROJECT_ROOT/frontend_implementation.log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${1}" | tee -a "$LOG_FILE"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ${1//\\033\[[0-9;]*m/}" >> "$LOG_FILE"
}

# Error handling
handle_error() {
    log "${RED}❌ ERROR: $1${NC}"
    log "${YELLOW}🔄 Starting automatic rollback...${NC}"
    rollback
    exit 1
}

# Trap errors
trap 'handle_error "Script failed at line $LINENO"' ERR

# Validate project root
validate_project() {
    if [[ "$PROJECT_ROOT" == "/path/to/your/react/project" ]]; then
        log "${RED}❌ Please update PROJECT_ROOT variable in the script!${NC}"
        log "${YELLOW}Edit this script and set PROJECT_ROOT to your React project path${NC}"
        exit 1
    fi
    
    if [[ ! -d "$PROJECT_ROOT/src" ]]; then
        log "${RED}❌ Invalid React project path: $PROJECT_ROOT${NC}"
        log "${YELLOW}src/ directory not found${NC}"
        exit 1
    fi
    
    if [[ ! -f "$PROJECT_ROOT/package.json" ]]; then
        log "${RED}❌ package.json not found in: $PROJECT_ROOT${NC}"
        exit 1
    fi
    
    log "✅ React project validated: $PROJECT_ROOT"
}

# Backup function
backup_files() {
    log "${BLUE}📦 Creating backup directory: $BACKUP_DIR${NC}"
    mkdir -p "$BACKUP_DIR"
    
    # Files to backup
    local files=(
        "src/services/registrationAPI.js"
        "src/components/Registration/RegistrationView.jsx"
        "src/services/authAPI.js"
        "src/utils/authUtils.js"
        "package.json"
    )
    
    log "${BLUE}📦 Backing up files...${NC}"
    for file in "${files[@]}"; do
        if [[ -f "$PROJECT_ROOT/$file" ]]; then
            mkdir -p "$BACKUP_DIR/$(dirname "$file")"
            cp "$PROJECT_ROOT/$file" "$BACKUP_DIR/$file"
            log "✅ Backed up: $file"
        else
            log "${YELLOW}⚠️  File not found (will be created): $file${NC}"
        fi
    done
    
    # Backup CSS files if they exist
    find "$PROJECT_ROOT/src" -name "*.css" -exec cp {} "$BACKUP_DIR/src/" \; 2>/dev/null || true
}

# Rollback function
rollback() {
    if [[ ! -d "$BACKUP_DIR" ]]; then
        log "${RED}❌ No backup directory found for rollback${NC}"
        return 1
    fi
    
    log "${YELLOW}🔄 Rolling back changes...${NC}"
    
    # Restore files
    find "$BACKUP_DIR" -type f \( -name "*.js" -o -name "*.jsx" -o -name "*.css" -o -name "*.json" \) | while read -r backup_file; do
        relative_path="${backup_file#$BACKUP_DIR/}"
        target_file="$PROJECT_ROOT/$relative_path"
        
        if [[ -f "$backup_file" ]]; then
            mkdir -p "$(dirname "$target_file")"
            cp "$backup_file" "$target_file"
            log "✅ Restored: $relative_path"
        fi
    done
    
    log "${GREEN}✅ Rollback completed${NC}"
}

# Check if availability methods already exist
check_api_methods_exist() {
    if grep -q "checkUsernameAvailability\|checkEmailAvailability" "$PROJECT_ROOT/src/services/registrationAPI.js" 2>/dev/null; then
        log "${GREEN}✅ Availability API methods already exist${NC}"
        return 0
    fi
    return 1
}

# Check if real-time checking already exists in component
check_component_updated() {
    if grep -q "availabilityStatus\|checkAvailability" "$PROJECT_ROOT/src/components/Registration/RegistrationView.jsx" 2>/dev/null; then
        log "${GREEN}✅ Real-time checking already exists in component${NC}"
        return 0
    fi
    return 1
}

# Add availability methods to registrationAPI.js
add_api_methods() {
    log "${BLUE}🔌 Adding availability check methods to registrationAPI.js...${NC}"
    
    if check_api_methods_exist; then
        return 0
    fi
    
    local api_file="$PROJECT_ROOT/src/services/registrationAPI.js"
    local temp_file="$(mktemp)"
    
    # Create the new methods to insert
    cat > "$temp_file" << 'EOF'

  /**
   * Check username availability in real-time
   * @param {string} username - Username to check
   * @returns {Promise<{available: boolean, message: string, suggestions?: string[]}>}
   */
  async checkUsernameAvailability(username) {
    try {
      if (!username || username.trim().length < 3) {
        return {
          available: false,
          message: 'Username must be at least 3 characters',
          checking: false
        };
      }

      const response = await fetch(`${this.baseURL}/auth/check-username`, {
        method: 'POST',
        headers: {
          ...API_CONFIG.headers,
          'Origin': 'https://blackaxl.com'
        },
        body: JSON.stringify({ username: username.trim() }),
        credentials: 'include'
      });

      const data = await response.json();

      if (!response.ok) {
        throw new APIError(data, response.status);
      }

      return {
        available: data.available,
        message: data.message,
        suggestions: data.suggestions || [],
        checking: false
      };
    } catch (error) {
      console.error('Username availability check error:', error);
      return {
        available: false,
        message: 'Unable to check username availability',
        checking: false,
        error: true
      };
    }
  }

  /**
   * Check email availability in real-time
   * @param {string} email - Email to check
   * @returns {Promise<{available: boolean, message: string}>}
   */
  async checkEmailAvailability(email) {
    try {
      if (!email || !email.includes('@')) {
        return {
          available: false,
          message: 'Please enter a valid email address',
          checking: false
        };
      }

      const response = await fetch(`${this.baseURL}/auth/check-email`, {
        method: 'POST',
        headers: {
          ...API_CONFIG.headers,
          'Origin': 'https://blackaxl.com'
        },
        body: JSON.stringify({ email: email.trim().toLowerCase() }),
        credentials: 'include'
      });

      const data = await response.json();

      if (!response.ok) {
        throw new APIError(data, response.status);
      }

      return {
        available: data.available,
        message: data.message,
        checking: false
      };
    } catch (error) {
      console.error('Email availability check error:', error);
      return {
        available: false,
        message: 'Unable to check email availability',
        checking: false,
        error: true
      };
    }
  }

EOF
    
    # Find insertion point - before the closing brace of the class or before export
    if grep -n "export default" "$api_file" >/dev/null; then
        # Insert before export default
        local line_number=$(grep -n "export default" "$api_file" | head -1 | cut -d: -f1)
        head -n $((line_number - 1)) "$api_file" > "${api_file}.new"
        cat "$temp_file" >> "${api_file}.new"
        tail -n +$line_number "$api_file" >> "${api_file}.new"
        mv "${api_file}.new" "$api_file"
        log "✅ API methods added before export statement"
    elif grep -n "^}" "$api_file" >/dev/null; then
        # Insert before last closing brace
        local line_number=$(grep -n "^}" "$api_file" | tail -1 | cut -d: -f1)
        head -n $((line_number - 1)) "$api_file" > "${api_file}.new"
        cat "$temp_file" >> "${api_file}.new"
        tail -n +$line_number "$api_file" >> "${api_file}.new"
        mv "${api_file}.new" "$api_file"
        log "✅ API methods added before closing brace"
    else
        # Append to end of file
        cat "$temp_file" >> "$api_file"
        log "✅ API methods appended to end of file"
    fi
    
    rm -f "$temp_file"
}

# Add real-time checking to RegistrationView.jsx
add_realtime_checking() {
    log "${BLUE}⚛️  Adding real-time checking to RegistrationView.jsx...${NC}"
    
    if check_component_updated; then
        return 0
    fi
    
    local component_file="$PROJECT_ROOT/src/components/Registration/RegistrationView.jsx"
    local temp_file="$(mktemp)"
    
    # Step 1: Add useCallback and useRef to React imports
    log "  📝 Adding React hooks to imports..."
    sed -i 's/import React, { useState, useEffect }/import React, { useState, useEffect, useCallback, useRef }/' "$component_file"
    
    # Step 2: Add availability state after validation state
    log "  📝 Adding availability state..."
    if grep -n "const \[validation, setValidation\]" "$component_file" >/dev/null; then
        local line_number=$(grep -n "const \[validation, setValidation\]" "$component_file" | head -1 | cut -d: -f1)
        
        cat > "$temp_file" << 'EOF'

  // Real-time availability state
  const [availabilityStatus, setAvailabilityStatus] = useState({
    username: { checking: false, available: null, message: '', suggestions: [] },
    email: { checking: false, available: null, message: '' }
  });
  
  // Debounce refs
  const debounceTimeouts = useRef({});
EOF
        
        head -n $line_number "$component_file" > "${component_file}.new"
        cat "$temp_file" >> "${component_file}.new"
        tail -n +$((line_number + 1)) "$component_file" >> "${component_file}.new"
        mv "${component_file}.new" "$component_file"
        log "  ✅ Availability state added"
    fi
    
    # Step 3: Add debounced checking function after UI state
    log "  📝 Adding debounced checking function..."
    if grep -n "const \[showPasswordConfirm, setShowPasswordConfirm\]" "$component_file" >/dev/null; then
        local line_number=$(grep -n "const \[showPasswordConfirm, setShowPasswordConfirm\]" "$component_file" | head -1 | cut -d: -f1)
        
        cat > "$temp_file" << 'EOF'

  // Debounced availability checking
  const checkAvailability = useCallback(async (field, value) => {
    if (!value || value.trim().length < 3) {
      setAvailabilityStatus(prev => ({
        ...prev,
        [field]: { checking: false, available: null, message: '', suggestions: [] }
      }));
      return;
    }

    // Clear existing timeout
    if (debounceTimeouts.current[field]) {
      clearTimeout(debounceTimeouts.current[field]);
    }

    // Set checking state
    setAvailabilityStatus(prev => ({
      ...prev,
      [field]: { ...prev[field], checking: true }
    }));

    // Debounce the actual check
    debounceTimeouts.current[field] = setTimeout(async () => {
      try {
        let result;
        if (field === 'username') {
          result = await registrationAPI.checkUsernameAvailability(value);
        } else if (field === 'email') {
          result = await registrationAPI.checkEmailAvailability(value);
        }

        setAvailabilityStatus(prev => ({
          ...prev,
          [field]: {
            checking: false,
            available: result.available,
            message: result.message,
            suggestions: result.suggestions || [],
            error: result.error || false
          }
        }));
      } catch (error) {
        console.error(`${field} availability check failed:`, error);
        setAvailabilityStatus(prev => ({
          ...prev,
          [field]: {
            checking: false,
            available: null,
            message: 'Unable to check availability',
            suggestions: [],
            error: true
          }
        }));
      }
    }, 500); // 500ms debounce
  }, []);
EOF
        
        head -n $line_number "$component_file" > "${component_file}.new"
        cat "$temp_file" >> "${component_file}.new"
        tail -n +$((line_number + 1)) "$component_file" >> "${component_file}.new"
        mv "${component_file}.new" "$component_file"
        log "  ✅ Debounced checking function added"
    fi
    
    # Step 4: Update handleInputChange to trigger availability checking
    log "  📝 Updating handleInputChange..."
    if grep -n "setValidation(prev => ({ ...prev, \[field\]: null }));" "$component_file" >/dev/null; then
        local line_number=$(grep -n "setValidation(prev => ({ ...prev, \[field\]: null }));" "$component_file" | head -1 | cut -d: -f1)
        
        cat > "$temp_file" << 'EOF'
    // Trigger real-time availability checking for username/email
    if (field === 'username' || field === 'email') {
      checkAvailability(field, value);
    }
EOF
        
        head -n $line_number "$component_file" > "${component_file}.new"
        cat "$temp_file" >> "${component_file}.new"
        tail -n +$((line_number + 1)) "$component_file" >> "${component_file}.new"
        mv "${component_file}.new" "$component_file"
        log "  ✅ Input change handler updated"
    fi
    
    # Step 5: Update CredentialsStep to accept availabilityStatus
    log "  📝 Updating CredentialsStep component..."
    sed -i 's/const CredentialsStep = ({ formData, onChange, validation }) =>/const CredentialsStep = ({ formData, onChange, validation, availabilityStatus }) =>/' "$component_file"
    
    # Step 6: Update renderStepContent to pass availabilityStatus
    log "  📝 Updating renderStepContent..."
    if grep -n "validation={validation}" "$component_file" | grep "CredentialsStep" >/dev/null; then
        sed -i '/CredentialsStep/,/\/>/s/validation={validation}/validation={validation}\n            availabilityStatus={availabilityStatus}/' "$component_file"
        log "  ✅ CredentialsStep props updated"
    fi
    
    rm -f "$temp_file"
}

# Add CSS styles for availability indicators
add_css_styles() {
    log "${BLUE}🎨 Adding CSS styles for availability indicators...${NC}"
    
    local css_file="$PROJECT_ROOT/src/App.css"
    
    # Check if styles already exist
    if grep -q "availability-indicator" "$css_file" 2>/dev/null; then
        log "✅ CSS styles already exist"
        return 0
    fi
    
    # Create CSS styles
    cat >> "$css_file" << 'EOF'

/* Real-time Availability Checking Styles */
.availability-indicator {
  position: absolute;
  right: 12px;
  top: 50%;
  transform: translateY(-50%);
  width: 16px;
  height: 16px;
}

.availability-indicator.checking {
  display: flex;
  align-items: center;
  justify-content: center;
}

.availability-indicator.success {
  color: #10b981;
}

.availability-indicator.error {
  color: #ef4444;
}

.loading-spinner-sm {
  width: 14px;
  height: 14px;
  border: 2px solid #e5e7eb;
  border-top: 2px solid #3b82f6;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

.availability-message {
  margin-top: 4px;
  font-size: 0.875rem;
  font-weight: 500;
}

.availability-message.success {
  color: #10b981;
}

.availability-message.error {
  color: #ef4444;
}

.username-suggestions {
  margin-top: 8px;
  padding: 12px;
  background-color: #f9fafb;
  border-radius: 8px;
  border: 1px solid #e5e7eb;
}

.suggestions-label {
  display: block;
  font-size: 0.75rem;
  color: #6b7280;
  margin-bottom: 6px;
  font-weight: 500;
}

.suggestion-button {
  display: inline-block;
  margin: 2px 4px 2px 0;
  padding: 4px 8px;
  background-color: #3b82f6;
  color: white;
  border: none;
  border-radius: 4px;
  font-size: 0.75rem;
  cursor: pointer;
  transition: background-color 0.2s;
}

.suggestion-button:hover {
  background-color: #2563eb;
}

.input-wrapper {
  position: relative;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}
EOF
    
    log "✅ CSS styles added to App.css"
}

# Add availability indicators to username/email inputs
add_visual_indicators() {
    log "${BLUE}👁️  Adding visual indicators to input fields...${NC}"
    
    local component_file="$PROJECT_ROOT/src/components/Registration/RegistrationView.jsx"
    local temp_file="$(mktemp)"
    
    # Find username input and add indicators after it
    if grep -n 'id="username"' "$component_file" >/dev/null; then
        local line_number=$(grep -n 'id="username"' "$component_file" | head -1 | cut -d: -f1)
        local end_line=$(tail -n +$line_number "$component_file" | grep -n "/>" | head -1 | cut -d: -f1)
        end_line=$((line_number + end_line - 1))
        
        cat > "$temp_file" << 'EOF'
                {availabilityStatus.username.checking && (
                  <div className="availability-indicator checking">
                    <div className="loading-spinner-sm"></div>
                  </div>
                )}
                {!availabilityStatus.username.checking && availabilityStatus.username.available === true && (
                  <Check className="availability-indicator success" />
                )}
                {!availabilityStatus.username.checking && availabilityStatus.username.available === false && (
                  <X className="availability-indicator error" />
                )}
EOF
        
        head -n $end_line "$component_file" > "${component_file}.new"
        cat "$temp_file" >> "${component_file}.new"
        tail -n +$((end_line + 1)) "$component_file" >> "${component_file}.new"
        mv "${component_file}.new" "$component_file"
        log "  ✅ Username indicators added"
    fi
    
    # Add availability messages after username validation
    if grep -n "validation.username &&" "$component_file" >/dev/null; then
        local line_number=$(grep -n "validation.username &&" "$component_file" | tail -1 | cut -d: -f1)
        # Find the end of this validation block
        local end_line=$(tail -n +$line_number "$component_file" | grep -n ")}" | head -1 | cut -d: -f1)
        end_line=$((line_number + end_line - 1))
        
        cat > "$temp_file" << 'EOF'
              {availabilityStatus.username.message && !availabilityStatus.username.checking && (
                <div className={`availability-message ${availabilityStatus.username.available ? 'success' : 'error'}`}>
                  {availabilityStatus.username.message}
                </div>
              )}
              {availabilityStatus.username.suggestions && availabilityStatus.username.suggestions.length > 0 && (
                <div className="username-suggestions">
                  <span className="suggestions-label">Try these instead:</span>
                  {availabilityStatus.username.suggestions.map((suggestion, idx) => (
                    <button
                      key={idx}
                      type="button"
                      className="suggestion-button"
                      onClick={() => onChange('username', suggestion)}
                    >
                      {suggestion}
                    </button>
                  ))}
                </div>
              )}
EOF
        
        head -n $end_line "$component_file" > "${component_file}.new"
        cat "$temp_file" >> "${component_file}.new"
        tail -n +$((end_line + 1)) "$component_file" >> "${component_file}.new"
        mv "${component_file}.new" "$component_file"
        log "  ✅ Username messages added"
    fi
    
    rm -f "$temp_file"
}

# Verification function
verify_implementation() {
    log "${BLUE}🔍 Verifying implementation...${NC}"
    
    cd "$PROJECT_ROOT"
    
    # Check if npm is available
    if ! command -v npm &> /dev/null; then
        log "${YELLOW}⚠️  npm not found, skipping build verification${NC}"
        return 0
    fi
    
    # Check if API methods were added
    if check_api_methods_exist; then
        log "✅ API methods added to registrationAPI.js"
    else
        handle_error "API methods not found in registrationAPI.js"
    fi
    
    # Check if component was updated
    if check_component_updated; then
        log "✅ Real-time checking added to RegistrationView"
    else
        handle_error "Real-time checking not found in RegistrationView"
    fi
    
    # Check syntax by attempting to build
    log "${BLUE}🔨 Testing React build...${NC}"
    if npm run build --silent 2>&1 | grep -i -E "error|failed" >/dev/null; then
        handle_error "React build failed - syntax errors detected"
    else
        log "✅ React build successful"
    fi
}

# Main implementation
main() {
    log "${GREEN}🚀 Starting nYtevibe Frontend Real-Time Availability Implementation${NC}"
    log "${BLUE}📅 $(date)${NC}"
    
    # Validate project
    validate_project
    
    # Change to project directory
    cd "$PROJECT_ROOT" || handle_error "Cannot access project directory: $PROJECT_ROOT"
    
    # Create backup
    backup_files
    
    # Add API methods
    add_api_methods
    
    # Add real-time checking to component
    add_realtime_checking
    
    # Add visual indicators
    add_visual_indicators
    
    # Add CSS styles
    add_css_styles
    
    # Install dependencies if needed
    if [[ -f "package.json" ]] && command -v npm &> /dev/null; then
        log "${BLUE}📦 Installing dependencies...${NC}"
        npm install --silent || log "${YELLOW}⚠️  npm install had warnings${NC}"
    fi
    
    # Verify implementation
    verify_implementation
    
    # Success
    log "${GREEN}🎉 Frontend implementation completed successfully!${NC}"
    log "${GREEN}✅ Real-time availability checking is now active in registration form${NC}"
    log "${BLUE}📋 Features added:${NC}"
    log "   • Debounced username availability checking (500ms delay)"
    log "   • Debounced email availability checking (500ms delay)"
    log "   • Visual loading indicators"
    log "   • Success/error status indicators"
    log "   • Username suggestions when taken"
    log "   • CSS styles for all indicators"
    log "${BLUE}📦 Backup location: $BACKUP_DIR${NC}"
    log ""
    log "${CYAN}🧪 Test your implementation:${NC}"
    log "1. Navigate to your registration page"
    log "2. Start typing in username field"
    log "3. After 500ms pause, see loading indicator"
    log "4. See availability status (Available/Taken)"
    log "5. Try taken username to see suggestions"
    log "6. Test email field the same way"
    
    return 0
}

# Show usage
show_usage() {
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  (no args)     - Run full implementation"
    echo "  rollback      - Rollback latest changes"
    echo "  rollback PATH - Rollback from specific backup"
    echo "  check         - Check if implementation exists"
    echo ""
    echo "Examples:"
    echo "  $0                    # Deploy real-time checking"
    echo "  $0 rollback          # Rollback latest deployment"
    echo "  $0 check             # Check current status"
    echo ""
    echo "IMPORTANT: Update PROJECT_ROOT variable in this script first!"
}

# Check current implementation status
check_status() {
    log "${BLUE}🔍 Checking current implementation status...${NC}"
    
    if check_api_methods_exist && check_component_updated; then
        log "${GREEN}✅ Real-time availability checking is already implemented${NC}"
        log "${BLUE}📋 Existing features:${NC}"
        log "   • API methods in registrationAPI.js"
        log "   • Real-time checking in RegistrationView.jsx"
    else
        log "${YELLOW}⚠️  Real-time availability checking is not implemented${NC}"
        log "${BLUE}📋 Missing components:${NC}"
        if ! check_api_methods_exist; then
            log "   ❌ API methods not found"
        fi
        if ! check_component_updated; then
            log "   ❌ Component updates not found"
        fi
    fi
}

# Handle command line arguments
case "${1:-}" in
    "rollback")
        if [[ -n "$2" ]]; then
            BACKUP_DIR="$2"
        else
            # Find latest backup
            BACKUP_DIR=$(find "$PROJECT_ROOT/backups" -name "frontend_*" -type d 2>/dev/null | sort -r | head -n1)
            if [[ -z "$BACKUP_DIR" ]]; then
                log "${RED}❌ No backup found for rollback${NC}"
                exit 1
            fi
        fi
        log "${YELLOW}🔄 Rolling back from: $BACKUP_DIR${NC}"
        rollback
        exit $?
        ;;
    "check")
        validate_project
        check_status
        exit 0
        ;;
    "help"|"-h"|"--help")
        show_usage
        exit 0
        ;;
    "")
        main
        ;;
    *)
        echo "Unknown option: $1"
        show_usage
        exit 1
        ;;
esac
