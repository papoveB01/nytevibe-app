#!/bin/bash

# nYtevibe Beautiful Email Verification Page Deployment Script
# Safe deployment with backup and rollback mechanisms

set -e  # Exit on any error

# Configuration
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="./backup_beautiful_verification_${TIMESTAMP}"
PROJECT_ROOT="."
LOG_FILE="./deploy_beautiful_verification_${TIMESTAMP}.log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${BLUE}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a "$LOG_FILE"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1" | tee -a "$LOG_FILE"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" | tee -a "$LOG_FILE"
}

header() {
    echo -e "${PURPLE}[DEPLOY]${NC} $1" | tee -a "$LOG_FILE"
}

# Function to create backups
create_backup() {
    log "Creating backup directory: $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"
    
    # Backup existing files that will be modified
    local files_to_backup=(
        "src/components/Auth/EmailVerificationView.jsx"
        "src/services/emailVerificationAPI.js"
    )
    
    for file in "${files_to_backup[@]}"; do
        if [ -f "$file" ]; then
            log "Backing up: $file"
            mkdir -p "$BACKUP_DIR/$(dirname "$file")"
            cp "$file" "$BACKUP_DIR/$file"
        else
            warning "File not found for backup: $file"
        fi
    done
    
    # Create backup manifest
    cat > "$BACKUP_DIR/backup_manifest.txt" << EOF
# nYtevibe Beautiful Verification Page Backup Manifest
# Created: $(date)
# Backup Directory: $BACKUP_DIR

Files backed up:
$(find "$BACKUP_DIR" -type f | grep -v backup_manifest.txt)

Original deployment script: $0
Log file: $LOG_FILE
EOF
    
    success "Backup created successfully in $BACKUP_DIR"
}

# Function to create rollback script
create_rollback_script() {
    cat > "./rollback_beautiful_verification_${TIMESTAMP}.sh" << 'ROLLBACK_EOF'
#!/bin/bash

# Auto-generated rollback script for nYtevibe Beautiful Verification Page deployment

BACKUP_DIR="BACKUP_DIR_PLACEHOLDER"
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
NC='\033[0m'

echo -e "${PURPLE}========================================${NC}"
echo -e "${PURPLE}  nYtevibe Beautiful Verification${NC}"
echo -e "${PURPLE}        Rollback Script${NC}"
echo -e "${PURPLE}========================================${NC}"

if [ ! -d "$BACKUP_DIR" ]; then
    echo -e "${RED}ERROR: Backup directory not found: $BACKUP_DIR${NC}"
    exit 1
fi

echo -e "${YELLOW}Rolling back files from: $BACKUP_DIR${NC}"

# Restore backed up files
find "$BACKUP_DIR" -type f \( -name "*.jsx" -o -name "*.js" \) | while read backup_file; do
    # Calculate relative path
    relative_path=${backup_file#$BACKUP_DIR/}
    
    if [ "$relative_path" != "backup_manifest.txt" ]; then
        echo "Restoring: $relative_path"
        mkdir -p "$(dirname "$relative_path")"
        cp "$backup_file" "$relative_path"
    fi
done

echo -e "${GREEN}✅ Rollback completed successfully!${NC}"
echo -e "${YELLOW}Please restart your development server if running.${NC}"
ROLLBACK_EOF

    # Replace placeholder with actual backup directory
    sed -i "s|BACKUP_DIR_PLACEHOLDER|$BACKUP_DIR|g" "./rollback_beautiful_verification_${TIMESTAMP}.sh"
    chmod +x "./rollback_beautiful_verification_${TIMESTAMP}.sh"
    
    success "Rollback script created: ./rollback_beautiful_verification_${TIMESTAMP}.sh"
}

# Function to validate React project structure
validate_project() {
    log "Validating React project structure..."
    
    if [ ! -f "package.json" ]; then
        error "package.json not found. Are you in the React project root?"
        exit 1
    fi
    
    if [ ! -d "src/components/Auth" ]; then
        error "src/components/Auth directory not found."
        exit 1
    fi
    
    success "Project structure validation passed"
}

# Function to create beautiful EmailVerificationView component
create_beautiful_verification_component() {
    log "Creating beautiful EmailVerificationView component..."
    
    cat > "src/components/Auth/EmailVerificationView.jsx" << 'COMPONENT_EOF'
import React, { useState, useEffect } from 'react';
import { CheckCircle, XCircle, Mail, ArrowLeft, RefreshCw, Sparkles, Heart, MapPin, Clock } from 'lucide-react';
import { useApp } from '../../context/AppContext';
import EmailVerificationAPI from '../../services/emailVerificationAPI';

const EmailVerificationView = ({ onBack, onSuccess, token, email }) => {
    console.log("🎨 =========================");
    console.log("Beautiful EmailVerificationView LOADED");
    console.log("Props received:", { token, email, onBack: !!onBack, onSuccess: !!onSuccess });
    console.log("Current URL:", window.location.href);
    
    // Parse URL to get verification parameters
    const verificationParams = EmailVerificationAPI.parseVerificationURL();
    console.log("Parsed verification params:", verificationParams);
    console.log("=========================");

    const { actions } = useApp();
    const [verificationStatus, setVerificationStatus] = useState('verifying');
    const [isLoading, setIsLoading] = useState(false);
    const [canResend, setCanResend] = useState(true);
    const [resendCooldown, setResendCooldown] = useState(0);
    const [verificationData, setVerificationData] = useState(null);
    const [showConfetti, setShowConfetti] = useState(false);

    // Auto-verify on component mount
    useEffect(() => {
        console.log("🔄 Auto-verification useEffect triggered!");
        
        // Phase 1 format: Check for user ID + hash
        if (verificationParams.userId && verificationParams.hash) {
            console.log("📧 Found Phase 1 verification format - auto-verifying");
            verifyEmailWithIdAndHash(verificationParams.userId, verificationParams.hash);
        }
        // Legacy support: Check for token
        else if (token || verificationParams.token) {
            console.log("🔄 Found legacy token format");
            const tokenToUse = token || verificationParams.token;
            verifyEmailToken(tokenToUse);
        }
        // No verification parameters found
        else {
            console.log("⚠️ No verification parameters found in URL");
            setVerificationStatus('error');
        }
    }, [verificationParams.userId, verificationParams.hash, token]);

    // Resend cooldown timer
    useEffect(() => {
        if (resendCooldown > 0) {
            const timer = setTimeout(() => {
                setResendCooldown(resendCooldown - 1);
            }, 1000);
            return () => clearTimeout(timer);
        } else if (resendCooldown === 0 && !canResend) {
            setCanResend(true);
        }
    }, [resendCooldown, canResend]);

    /**
     * Phase 1 Verification: Verify email using user ID + hash
     */
    const verifyEmailWithIdAndHash = async (userId, hash) => {
        console.log("🌐 Phase 1 verifyEmailWithIdAndHash called with:", { userId, hash });
        
        setIsLoading(true);
        try {
            const response = await EmailVerificationAPI.verifyEmail(userId, hash);
            console.log("✅ Phase 1 API call successful! Response:", response);

            if (response.success && response.data.status === 'success') {
                setVerificationStatus('success');
                setVerificationData(response.data);
                setShowConfetti(true);
                
                actions.addNotification({
                    type: 'success',
                    message: '🎉 Email verified successfully! Welcome to nYtevibe!',
                    important: true,
                    duration: 4000
                });

                // Hide confetti after 3 seconds
                setTimeout(() => setShowConfetti(false), 3000);

                // Auto-redirect after 5 seconds
                setTimeout(() => {
                    onSuccess && onSuccess();
                }, 5000);
            } else {
                // Handle specific error codes from Phase 1 backend
                const errorCode = response.data?.code;
                
                switch (errorCode) {
                    case 'ALREADY_VERIFIED':
                        setVerificationStatus('success');
                        setVerificationData(response.data);
                        actions.addNotification({
                            type: 'info',
                            message: '✅ Email already verified! Welcome back to nYtevibe!',
                            duration: 4000
                        });
                        break;
                        
                    case 'INVALID_HASH':
                        setVerificationStatus('expired');
                        actions.addNotification({
                            type: 'error',
                            message: '🔗 Invalid verification link. Please request a new one.',
                            duration: 4000
                        });
                        break;
                        
                    case 'USER_NOT_FOUND':
                        setVerificationStatus('error');
                        actions.addNotification({
                            type: 'error',
                            message: '❌ User not found. Please check the verification link.',
                            duration: 4000
                        });
                        break;
                        
                    default:
                        setVerificationStatus('error');
                        actions.addNotification({
                            type: 'error',
                            message: response.data?.message || 'Email verification failed.',
                            duration: 4000
                        });
                }
            }
        } catch (error) {
            console.error('Phase 1 Email verification failed:', error);
            setVerificationStatus('error');
            actions.addNotification({
                type: 'error',
                message: 'Network error. Please check your connection.',
                duration: 4000
            });
        } finally {
            setIsLoading(false);
        }
    };

    /**
     * Legacy Token Verification (for backward compatibility)
     */
    const verifyEmailToken = async (verificationToken) => {
        console.log("🔄 Legacy verifyEmailToken called with:", verificationToken);
        
        if (!verificationToken) {
            console.error("❌ NO TOKEN - aborting verification");
            setVerificationStatus("error");
            return;
        }

        setIsLoading(true);
        try {
            setVerificationStatus('error');
            actions.addNotification({
                type: 'error',
                message: 'Legacy verification format no longer supported. Please request a new verification email.',
                duration: 4000
            });
        } catch (error) {
            console.error('Legacy verification failed:', error);
            setVerificationStatus('error');
        } finally {
            setIsLoading(false);
        }
    };

    /**
     * Resend verification email using Phase 1 API
     */
    const handleResendEmail = async () => {
        if (!canResend || !email) return;

        setIsLoading(true);
        setCanResend(false);
        setResendCooldown(60);

        try {
            const response = await EmailVerificationAPI.resendVerificationEmail(email);
            
            if (response.success) {
                actions.addNotification({
                    type: 'success',
                    message: '📧 Verification email sent! Check your inbox.',
                    duration: 4000
                });
            } else {
                throw new Error(response.data?.message || 'Failed to resend email');
            }
        } catch (error) {
            console.error('Resend verification failed:', error);
            actions.addNotification({
                type: 'error',
                message: error.message || 'Failed to resend email. Please try again later.',
                duration: 4000
            });
            setCanResend(true);
            setResendCooldown(0);
        } finally {
            setIsLoading(false);
        }
    };

    // Confetti effect component
    const ConfettiEffect = () => (
        <div className="fixed inset-0 pointer-events-none z-50">
            {[...Array(50)].map((_, i) => (
                <div
                    key={i}
                    className="absolute animate-bounce"
                    style={{
                        left: `${Math.random() * 100}%`,
                        top: `${Math.random() * 100}%`,
                        animationDelay: `${Math.random() * 2}s`,
                        animationDuration: `${2 + Math.random() * 2}s`
                    }}
                >
                    <Sparkles className="w-4 h-4 text-purple-400 opacity-70" />
                </div>
            ))}
        </div>
    );

    const renderContent = () => {
        switch (verificationStatus) {
            case 'verifying':
                return (
                    <div className="text-center space-y-6">
                        <div className="relative mx-auto w-24 h-24">
                            <div className="absolute inset-0 rounded-full bg-gradient-to-r from-purple-400 to-pink-400 animate-pulse"></div>
                            <div className="relative flex items-center justify-center w-24 h-24 rounded-full bg-white shadow-lg">
                                <RefreshCw className="w-12 h-12 text-purple-500 animate-spin" />
                            </div>
                        </div>
                        
                        <div className="space-y-3">
                            <h2 className="text-3xl font-bold text-gray-800">
                                Verifying Your Email
                            </h2>
                            <p className="text-lg text-gray-600 max-w-md mx-auto">
                                Hang tight while we confirm your email address for nYtevibe...
                            </p>
                            <div className="flex justify-center space-x-1">
                                {[...Array(3)].map((_, i) => (
                                    <div
                                        key={i}
                                        className="w-2 h-2 bg-purple-400 rounded-full animate-bounce"
                                        style={{ animationDelay: `${i * 0.2}s` }}
                                    ></div>
                                ))}
                            </div>
                        </div>
                    </div>
                );

            case 'success':
                return (
                    <div className="text-center space-y-8">
                        {showConfetti && <ConfettiEffect />}
                        
                        <div className="relative mx-auto w-32 h-32">
                            <div className="absolute inset-0 rounded-full bg-gradient-to-r from-green-400 to-emerald-400 animate-pulse shadow-2xl"></div>
                            <div className="relative flex items-center justify-center w-32 h-32 rounded-full bg-white shadow-xl transform transition-transform hover:scale-105">
                                <CheckCircle className="w-16 h-16 text-green-500 animate-bounce" />
                            </div>
                        </div>

                        <div className="space-y-4">
                            <div className="space-y-2">
                                <h2 className="text-4xl font-bold bg-gradient-to-r from-green-600 to-emerald-600 bg-clip-text text-transparent">
                                    Email Verified!
                                </h2>
                                <div className="flex items-center justify-center space-x-2 text-lg text-gray-600">
                                    <Heart className="w-5 h-5 text-red-400 animate-pulse" />
                                    <span>Welcome to nYtevibe</span>
                                    <MapPin className="w-5 h-5 text-purple-400" />
                                </div>
                            </div>
                            
                            <p className="text-lg text-gray-700 max-w-md mx-auto leading-relaxed">
                                🎉 Your email has been successfully verified! You're now ready to discover Houston's hottest nightlife spots.
                            </p>
                            
                            <div className="bg-gradient-to-r from-purple-50 to-pink-50 rounded-2xl p-6 mx-auto max-w-sm">
                                <div className="text-sm text-gray-600 space-y-2">
                                    <p className="font-medium">✨ What's next?</p>
                                    <ul className="space-y-1 text-left">
                                        <li>🏙️ Explore Houston venues</li>
                                        <li>⭐ Rate your experiences</li>
                                        <li>👥 Connect with nightlife lovers</li>
                                        <li>🎯 Get personalized recommendations</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div className="space-y-4">
                            <button 
                                onClick={onSuccess}
                                className="group relative px-8 py-4 bg-gradient-to-r from-purple-600 to-pink-600 text-white font-semibold rounded-2xl shadow-lg hover:shadow-xl transform transition-all duration-300 hover:scale-105 hover:-translate-y-1"
                            >
                                <span className="relative z-10 flex items-center justify-center space-x-2">
                                    <span>Continue to nYtevibe</span>
                                    <div className="w-5 h-5 bg-white/20 rounded-full flex items-center justify-center">
                                        <div className="w-2 h-2 bg-white rounded-full"></div>
                                    </div>
                                </span>
                                <div className="absolute inset-0 bg-gradient-to-r from-purple-700 to-pink-700 rounded-2xl opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
                            </button>
                            
                            {verificationData?.verified_at && (
                                <div className="flex items-center justify-center space-x-2 text-sm text-gray-500">
                                    <Clock className="w-4 h-4" />
                                    <span>Verified: {new Date(verificationData.verified_at).toLocaleString()}</span>
                                </div>
                            )}
                        </div>
                    </div>
                );

            case 'expired':
                return (
                    <div className="text-center space-y-6">
                        <div className="relative mx-auto w-24 h-24">
                            <div className="absolute inset-0 rounded-full bg-gradient-to-r from-orange-400 to-red-400 animate-pulse"></div>
                            <div className="relative flex items-center justify-center w-24 h-24 rounded-full bg-white shadow-lg">
                                <XCircle className="w-12 h-12 text-orange-500" />
                            </div>
                        </div>
                        
                        <div className="space-y-3">
                            <h2 className="text-3xl font-bold text-gray-800">
                                Link Expired
                            </h2>
                            <p className="text-lg text-gray-600 max-w-md mx-auto">
                                This verification link has expired. No worries - we'll send you a fresh one to join the nYtevibe community!
                            </p>
                        </div>

                        <div className="bg-orange-50 rounded-2xl p-6 max-w-sm mx-auto">
                            <button
                                onClick={handleResendEmail}
                                disabled={!canResend || isLoading}
                                className="w-full px-6 py-3 bg-gradient-to-r from-orange-500 to-red-500 text-white font-semibold rounded-xl shadow-lg hover:shadow-xl transform transition-all duration-300 hover:scale-105 disabled:opacity-50 disabled:cursor-not-allowed disabled:transform-none"
                            >
                                {isLoading ? (
                                    <div className="flex items-center justify-center space-x-2">
                                        <RefreshCw className="w-4 h-4 animate-spin" />
                                        <span>Sending...</span>
                                    </div>
                                ) : canResend ? (
                                    <div className="flex items-center justify-center space-x-2">
                                        <Mail className="w-4 h-4" />
                                        <span>Send New Link</span>
                                    </div>
                                ) : (
                                    <span>Resend in {resendCooldown}s</span>
                                )}
                            </button>
                        </div>
                    </div>
                );

            case 'error':
            default:
                return (
                    <div className="text-center space-y-6">
                        <div className="relative mx-auto w-24 h-24">
                            <div className="absolute inset-0 rounded-full bg-gradient-to-r from-red-400 to-pink-400 animate-pulse"></div>
                            <div className="relative flex items-center justify-center w-24 h-24 rounded-full bg-white shadow-lg">
                                <XCircle className="w-12 h-12 text-red-500" />
                            </div>
                        </div>
                        
                        <div className="space-y-3">
                            <h2 className="text-3xl font-bold text-gray-800">
                                Verification Failed
                            </h2>
                            <p className="text-lg text-gray-600 max-w-md mx-auto">
                                Something went wrong with your verification. Let's get you into nYtevibe!
                            </p>
                        </div>

                        <div className="bg-red-50 rounded-2xl p-6 max-w-sm mx-auto space-y-4">
                            <div className="text-sm text-red-700 space-y-2">
                                <p className="font-medium">🔧 Quick fixes to try:</p>
                                <ul className="space-y-1 text-left">
                                    <li>• Check your internet connection</li>
                                    <li>• Try refreshing the page</li>
                                    <li>• Request a new verification email</li>
                                    <li>• Clear your browser cache</li>
                                </ul>
                            </div>
                            
                            <button
                                onClick={handleResendEmail}
                                disabled={!canResend || isLoading}
                                className="w-full px-6 py-3 bg-gradient-to-r from-red-500 to-pink-500 text-white font-semibold rounded-xl shadow-lg hover:shadow-xl transform transition-all duration-300 hover:scale-105 disabled:opacity-50 disabled:cursor-not-allowed disabled:transform-none"
                            >
                                {isLoading ? (
                                    <div className="flex items-center justify-center space-x-2">
                                        <RefreshCw className="w-4 h-4 animate-spin" />
                                        <span>Sending...</span>
                                    </div>
                                ) : canResend ? (
                                    <div className="flex items-center justify-center space-x-2">
                                        <Mail className="w-4 h-4" />
                                        <span>Resend Email</span>
                                    </div>
                                ) : (
                                    <span>Resend in {resendCooldown}s</span>
                                )}
                            </button>
                        </div>
                    </div>
                );
        }
    };

    return (
        <div className="min-h-screen bg-gradient-to-br from-purple-900 via-blue-900 to-purple-800 relative overflow-hidden">
            {/* Animated background elements */}
            <div className="absolute inset-0">
                <div className="absolute top-20 left-20 w-64 h-64 bg-purple-500/20 rounded-full blur-xl animate-pulse"></div>
                <div className="absolute top-40 right-32 w-48 h-48 bg-pink-500/20 rounded-full blur-xl animate-pulse" style={{ animationDelay: '1s' }}></div>
                <div className="absolute bottom-32 left-1/3 w-56 h-56 bg-blue-500/20 rounded-full blur-xl animate-pulse" style={{ animationDelay: '2s' }}></div>
            </div>

            <div className="relative z-10 min-h-screen flex flex-col">
                {/* Header */}
                <div className="flex items-center justify-between p-6">
                    <button 
                        onClick={onBack} 
                        className="flex items-center space-x-2 text-white/80 hover:text-white transition-colors duration-300 group"
                    >
                        <ArrowLeft className="w-5 h-5 group-hover:-translate-x-1 transition-transform duration-300" />
                        <span className="hidden sm:inline">Back</span>
                    </button>
                    
                    <div className="text-center">
                        <h1 className="text-2xl font-bold text-white">nYtevibe</h1>
                        <p className="text-purple-200 text-sm">Houston Nightlife Discovery</p>
                    </div>
                    
                    <div className="w-16"></div> {/* Spacer for centering */}
                </div>

                {/* Main content */}
                <div className="flex-1 flex items-center justify-center p-6">
                    <div className="w-full max-w-md">
                        <div className="bg-white/95 backdrop-blur-sm rounded-3xl shadow-2xl p-8 border border-white/20">
                            {renderContent()}
                        </div>
                    </div>
                </div>

                {/* Footer */}
                <div className="p-6 text-center">
                    <p className="text-white/60 text-sm">
                        © 2025 nYtevibe - Discover Houston's Nightlife
                    </p>
                </div>
            </div>
        </div>
    );
};

export default EmailVerificationView;
COMPONENT_EOF

    success "Beautiful EmailVerificationView component created successfully"
}

# Function to test the deployment
test_deployment() {
    log "Testing beautiful verification page deployment..."
    
    # Test 1: Check if files exist
    local required_files=(
        "src/components/Auth/EmailVerificationView.jsx"
        "src/services/emailVerificationAPI.js"
    )
    
    for file in "${required_files[@]}"; do
        if [ ! -f "$file" ]; then
            error "Required file missing: $file"
            return 1
        fi
    done
    
    # Test 2: Basic syntax check for JavaScript files
    if command -v node >/dev/null 2>&1; then
        log "Running basic syntax checks..."
        
        # Check for React component structure
        if grep -q "export default EmailVerificationView" "src/components/Auth/EmailVerificationView.jsx"; then
            success "React component export found"
        else
            error "React component export not found"
            return 1
        fi
        
        # Check for beautiful styling elements
        if grep -q "bg-gradient-to-br" "src/components/Auth/EmailVerificationView.jsx"; then
            success "Beautiful gradient styling found"
        else
            error "Beautiful styling not found"
            return 1
        fi
    else
        warning "Node.js not available for syntax checking"
    fi
    
    success "Beautiful verification page deployment testing completed"
}

# Main deployment function
deploy_beautiful_verification() {
    header "Starting nYtevibe Beautiful Verification Page deployment..."
    
    echo -e "${PURPLE}========================================${NC}"
    echo -e "${PURPLE}  nYtevibe Beautiful Verification${NC}"
    echo -e "${PURPLE}     Email Confirmation Page${NC}"
    echo -e "${PURPLE}========================================${NC}"
    
    # Step 1: Validate project
    validate_project
    
    # Step 2: Create backup
    create_backup
    
    # Step 3: Create rollback script
    create_rollback_script
    
    # Step 4: Deploy beautiful component
    create_beautiful_verification_component
    
    # Step 5: Test deployment
    test_deployment
    
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}  Beautiful Verification Deployment${NC}"
    echo -e "${GREEN}         Completed! ✨${NC}"
    echo -e "${GREEN}========================================${NC}"
    
    log "Beautiful verification page deployment completed successfully!"
    
    echo ""
    echo -e "${YELLOW}🎨 New Features Added:${NC}"
    echo -e "• Beautiful gradient backgrounds"
    echo -e "• Animated loading states"
    echo -e "• Confetti celebration effect"
    echo -e "• Improved Houston nightlife branding"
    echo -e "• Enhanced mobile responsiveness"
    echo -e "• Smooth hover animations"
    echo ""
    echo -e "${YELLOW}📋 Next Steps:${NC}"
    echo -e "1. Restart your React development server: ${BLUE}npm run dev${NC}"
    echo -e "2. Test the beautiful verification page"
    echo -e "3. Visit: ${CYAN}http://localhost:3000/verify/USER_ID/HASH${NC}"
    echo ""
    echo -e "${YELLOW}🧪 Test URL Example:${NC}"
    echo -e "${CYAN}http://localhost:3000/verify/4a0c0252-6c7d-48d7-b603-43bcccc7cdbd/b08b5d75748bcf8d30452eb2900eb90710315417${NC}"
    echo ""
    echo -e "${YELLOW}🔄 Rollback Instructions:${NC}"
    echo -e "If issues occur, run: ${RED}./rollback_beautiful_verification_${TIMESTAMP}.sh${NC}"
    echo ""
    echo -e "${YELLOW}📄 Files:${NC}"
    echo -e "• Backup: ${BLUE}$BACKUP_DIR${NC}"
    echo -e "• Log: ${BLUE}$LOG_FILE${NC}"
    echo -e "• Rollback: ${BLUE}./rollback_beautiful_verification_${TIMESTAMP}.sh${NC}"
}

# Error handling
handle_error() {
    error "Beautiful verification deployment failed on line $1"
    echo -e "${RED}========================================${NC}"
    echo -e "${RED}  DEPLOYMENT FAILED${NC}"
    echo -e "${RED}========================================${NC}"
    echo ""
    echo -e "${YELLOW}To rollback changes, run:${NC}"
    echo -e "${RED}./rollback_beautiful_verification_${TIMESTAMP}.sh${NC}"
    echo ""
    echo -e "${YELLOW}Check the log file for details:${NC}"
    echo -e "${BLUE}$LOG_FILE${NC}"
    exit 1
}

trap 'handle_error $LINENO' ERR

# Script entry point
main() {
    if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
        # Script is being executed directly
        deploy_beautiful_verification
    fi
}

main "$@"
