#!/bin/bash

# nYtevibe Login Page Mobile Optimization Fix
# Fixes login form overlapping and mobile layout issues

echo "📱 nYtevibe Login Page Mobile Fix"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔧 Fixing login page mobile layout issues..."
echo ""

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    echo "❌ Error: package.json not found. Please run this script from your React project directory."
    exit 1
fi

# Create backup
echo "💾 Creating backup of current CSS..."
cp src/App.css src/App.css.backup-login-mobile-fix

# Apply login page mobile fixes
echo "🎨 Applying login page mobile optimizations..."

cat >> src/App.css << 'EOF'

/* ============================================= */
/* LOGIN PAGE MOBILE FIXES */
/* ============================================= */

/* Override existing login page styles for better mobile support */
.login-page {
  min-height: 100vh;
  background: linear-gradient(180deg, #0f172a 0%, #1e293b 50%, #334155 100%);
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 16px;
  overflow-x: hidden;
  width: 100%;
}

.login-container {
  position: relative;
  z-index: 2;
  width: 100%;
  max-width: 1000px;
  display: grid;
  grid-template-columns: 1fr;
  gap: 40px;
  align-items: start;
  margin: 0 auto;
  padding: 0 16px;
}

.login-card {
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(20px);
  border-radius: 24px;
  padding: 24px;
  color: #1e293b;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
  width: 100%;
  max-width: 100%;
  margin: 0 auto;
  overflow: hidden;
}

.login-features {
  background: rgba(255, 255, 255, 0.05);
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 20px;
  padding: 24px;
  color: white;
  width: 100%;
  max-width: 100%;
  margin: 0 auto;
}

.demo-content {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  flex-direction: column;
  text-align: center;
}

.demo-fill-button {
  background: #92400e;
  color: white;
  border: none;
  padding: 10px 20px;
  border-radius: 6px;
  font-weight: 600;
  cursor: pointer;
  transition: var(--transition-normal);
  min-height: 44px;
  width: 100%;
  margin-top: 8px;
}

.form-input {
  width: 100%;
  padding: 12px 12px 12px 40px;
  border: 2px solid #e5e7eb;
  border-radius: var(--radius-lg);
  background: #ffffff;
  color: #1e293b;
  font-size: 16px; /* Prevents zoom on iOS */
  transition: var(--transition-normal);
  min-height: 48px;
  box-sizing: border-box;
}

.login-button {
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: 16px 20px;
  background: var(--gradient-primary);
  color: white;
  border: none;
  border-radius: var(--radius-lg);
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  transition: var(--transition-normal);
  min-height: 52px;
  box-sizing: border-box;
}

/* Mobile-specific improvements */
@media (max-width: 768px) {
  .login-page {
    padding: 12px;
    align-items: flex-start;
    padding-top: 40px;
  }

  .login-container {
    gap: 24px;
    padding: 0;
    margin-top: 0;
  }

  .login-card {
    padding: 20px;
    border-radius: 20px;
    margin: 0;
    max-width: none;
  }

  .login-features {
    padding: 20px;
    border-radius: 16px;
    margin: 0;
    max-width: none;
  }

  .login-card-header {
    text-align: center;
    margin-bottom: 24px;
  }

  .login-title {
    font-size: 1.375rem;
    line-height: 1.2;
  }

  .login-subtitle {
    font-size: 0.875rem;
    margin-top: 4px;
  }

  .demo-banner {
    margin-bottom: 20px;
    padding: 14px;
    border-radius: 12px;
  }

  .demo-content {
    gap: 8px;
  }

  .demo-info {
    margin-bottom: 8px;
  }

  .demo-title {
    font-size: 0.875rem;
    margin-bottom: 4px;
  }

  .demo-description {
    font-size: 0.75rem;
    line-height: 1.4;
  }

  .login-form {
    gap: 18px;
  }

  .form-group {
    gap: 6px;
  }

  .form-label {
    font-size: 0.875rem;
    font-weight: 600;
  }

  .input-wrapper {
    width: 100%;
  }

  .form-input {
    padding: 14px 12px 14px 40px;
    font-size: 16px;
    border-radius: 12px;
    min-height: 50px;
  }

  .password-toggle {
    right: 12px;
    min-width: 32px;
    min-height: 32px;
  }

  .login-button {
    padding: 16px 20px;
    font-size: 16px;
    min-height: 54px;
    border-radius: 12px;
    margin-top: 4px;
  }

  .login-card-footer {
    margin-top: 20px;
    padding-top: 20px;
  }

  .footer-text {
    font-size: 0.875rem;
    line-height: 1.4;
  }

  .features-title {
    font-size: 1.125rem;
    margin-bottom: 16px;
  }

  .features-list {
    gap: 12px;
  }

  .feature-item {
    font-size: 0.875rem;
    line-height: 1.4;
    align-items: flex-start;
  }

  .error-banner {
    padding: 12px;
    font-size: 0.875rem;
    border-radius: 10px;
    margin-bottom: 4px;
  }

  .back-button {
    padding: 10px 16px;
    font-size: 0.875rem;
    min-height: 44px;
    border-radius: 10px;
  }

  .login-header {
    margin-bottom: 16px;
  }
}

/* Extra small screens */
@media (max-width: 480px) {
  .login-page {
    padding: 8px;
    padding-top: 20px;
  }

  .login-container {
    gap: 20px;
  }

  .login-card {
    padding: 18px;
    border-radius: 18px;
  }

  .login-features {
    padding: 18px;
    border-radius: 14px;
  }

  .demo-banner {
    padding: 12px;
  }

  .demo-content {
    flex-direction: column;
    gap: 12px;
  }

  .demo-fill-button {
    width: 100%;
    padding: 12px 16px;
    font-size: 0.875rem;
  }

  .form-input {
    padding: 12px 12px 12px 38px;
    min-height: 48px;
  }

  .login-button {
    min-height: 52px;
    font-size: 15px;
  }

  .login-title {
    font-size: 1.25rem;
  }

  .back-button {
    padding: 8px 14px;
    font-size: 0.875rem;
    min-height: 42px;
  }
}

/* Very small screens */
@media (max-width: 375px) {
  .login-page {
    padding: 6px;
    padding-top: 16px;
  }

  .login-card {
    padding: 16px;
    border-radius: 16px;
  }

  .login-features {
    padding: 16px;
    border-radius: 12px;
  }

  .demo-banner {
    padding: 10px;
    margin-bottom: 16px;
  }

  .login-form {
    gap: 16px;
  }

  .form-input {
    min-height: 46px;
    padding: 12px 12px 12px 36px;
  }

  .login-button {
    min-height: 50px;
    padding: 14px 18px;
  }

  .login-card-header {
    margin-bottom: 20px;
  }

  .features-list {
    gap: 10px;
  }

  .feature-item {
    font-size: 0.8125rem;
  }
}

/* Landscape mobile orientation */
@media (max-height: 500px) and (orientation: landscape) {
  .login-page {
    padding: 8px;
    padding-top: 16px;
    align-items: flex-start;
  }

  .login-container {
    grid-template-columns: 1fr 1fr;
    gap: 20px;
    max-width: 100%;
    align-items: flex-start;
  }

  .login-card {
    padding: 16px;
  }

  .login-features {
    padding: 16px;
  }

  .login-card-header {
    margin-bottom: 16px;
  }

  .demo-banner {
    margin-bottom: 12px;
    padding: 8px;
  }

  .login-form {
    gap: 12px;
  }

  .form-input {
    min-height: 40px;
    padding: 10px 10px 10px 32px;
  }

  .login-button {
    min-height: 44px;
    padding: 12px 16px;
  }

  .features-list {
    gap: 8px;
  }

  .feature-item {
    font-size: 0.75rem;
  }
}

/* iOS Safari specific fixes */
@supports (-webkit-touch-callout: none) {
  .form-input {
    -webkit-appearance: none;
    border-radius: 12px;
  }

  .login-button {
    -webkit-appearance: none;
    border-radius: 12px;
  }

  .demo-fill-button {
    -webkit-appearance: none;
    border-radius: 6px;
  }

  @media (max-width: 480px) {
    .login-page {
      padding-bottom: max(16px, env(safe-area-inset-bottom));
    }
  }
}

/* High contrast mode support */
@media (prefers-contrast: high) {
  .login-card {
    border: 2px solid #000;
  }

  .form-input {
    border-width: 2px;
  }

  .login-button {
    border: 2px solid transparent;
  }
}

/* Reduced motion preferences */
@media (prefers-reduced-motion: reduce) {
  .login-card,
  .login-features,
  .form-input,
  .login-button,
  .demo-fill-button {
    transition: none;
  }
}

/* Fix for potential overflow issues */
.login-page * {
  box-sizing: border-box;
  max-width: 100%;
}

.login-container > * {
  min-width: 0;
  overflow-wrap: break-word;
}

/* Ensure proper touch targets */
.form-input,
.login-button,
.demo-fill-button,
.back-button,
.password-toggle {
  min-height: 44px;
  touch-action: manipulation;
}

/* Fix for input zoom on iOS */
@media (max-width: 768px) {
  .form-input {
    font-size: 16px !important;
  }
}

EOF

echo ""
echo "✅ Login Page Mobile Fix Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📱 Mobile Login Fixes Applied:"
echo "   ✅ Fixed form overlapping margins"
echo "   ✅ Improved responsive breakpoints"
echo "   ✅ Better mobile padding and spacing"
echo "   ✅ Optimized touch targets (44px minimum)"
echo "   ✅ iOS Safari compatibility improvements"
echo "   ✅ Landscape orientation support"
echo "   ✅ Safe area inset handling"
echo "   ✅ Input zoom prevention on iOS"
echo "   ✅ High contrast and reduced motion support"
echo ""
echo "🔧 Key Improvements:"
echo "   • Login card now fits properly on all screen sizes"
echo "   • Form inputs have proper sizing and spacing"
echo "   • Demo banner responsive layout"
echo "   • Better button sizing for touch devices"
echo "   • Improved text readability on mobile"
echo "   • Fixed overflow issues on small screens"
echo ""
echo "📐 Responsive Breakpoints:"
echo "   • 768px and below: Main mobile optimizations"
echo "   • 480px and below: Small screen adjustments"
echo "   • 375px and below: Very small screen fixes"
echo "   • Landscape mode: Two-column layout when space allows"
echo ""
echo "🚀 To test the fixes:"
echo "   npm run dev"
echo "   Open browser dev tools and test various screen sizes"
echo "   Try on actual mobile devices (iOS/Android)"
echo "   Test both portrait and landscape orientations"
echo ""
echo "Status: 🟢 LOGIN PAGE MOBILE-OPTIMIZED"
