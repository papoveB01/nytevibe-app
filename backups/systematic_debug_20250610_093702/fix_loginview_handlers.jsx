// Fix for LoginView.jsx - Ensure onClick handlers are present

// In your button JSX:
<button
  onClick={onRegister}
  className="footer-link"
  type="button"
>
  Create Account
</button>

<button
  type="button"
  onClick={onForgotPassword}
  className="forgot-password-link"
>
  Forgot your password?
</button>
