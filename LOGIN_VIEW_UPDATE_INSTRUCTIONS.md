# LoginView Update Instructions

Please manually add the following forgot password link to your LoginView component:

## Add this import at the top:
```javascript
import { Link } from 'react-router-dom';
```

## Add this link after the password field (before the submit button):
```javascript
<div className="auth-links">
  <Link to="/forgot-password" className="forgot-password-link">
    Forgot your password?
  </Link>
</div>
```

## Or add it after the submit button:
```javascript
{/* Navigation Links */}
<div className="auth-links">
  <Link to="/forgot-password" className="link-button">
    Forgot your password?
  </Link>
</div>
```

The exact placement depends on your current LoginView structure.
