# nYtevibe Development Guide

## 🏗️ Modular Architecture

### Component Structure
```
src/components/
├── Layout/          # Header, SearchBar, PromotionalBanner
├── User/           # UserProfile, UserDropdown
├── Venue/          # VenueCard, StarRating, VenueDetails, Modals
├── Follow/         # FollowButton, FollowStats, FollowNotification
├── Social/         # ShareModal
├── UI/             # Button, Modal, Badge, NotificationContainer
└── Views/          # HomeView, VenueDetailsView
```

### State Management
- **Context API**: Centralized state in `src/context/AppContext.jsx`
- **Custom Hooks**: Business logic in `src/hooks/`
- **Utils**: Helper functions in `src/utils/helpers.js`

### Development Workflow

#### Adding New Components
```bash
# Create new component
mkdir -p src/components/NewCategory
touch src/components/NewCategory/NewComponent.jsx

# Follow the pattern:
import React from 'react';
import { useApp } from '../../context/AppContext';

const NewComponent = ({ props }) => {
  const { state, actions } = useApp();
  
  return (
    <div className="new-component">
      {/* Component JSX */}
    </div>
  );
};

export default NewComponent;
```

#### Adding New Hooks
```bash
# Create custom hook
touch src/hooks/useNewFeature.js

# Follow the pattern:
import { useCallback } from 'react';
import { useApp } from '../context/AppContext';

export const useNewFeature = () => {
  const { state, actions } = useApp();
  
  const newFunction = useCallback(() => {
    // Logic here
  }, []);
  
  return { newFunction };
};
```

### Performance Best Practices

1. **React.memo()** for expensive components
2. **useCallback()** for functions passed as props
3. **useMemo()** for expensive calculations
4. **Lazy loading** for large components

### Testing Strategy

1. **Unit Tests**: Individual components with Jest
2. **Integration Tests**: Component interactions
3. **E2E Tests**: Full user workflows
4. **Performance Tests**: Bundle size and runtime

### Code Style

- **File Naming**: PascalCase for components, camelCase for hooks
- **Imports**: Absolute imports using configured paths
- **Props**: Destructured with defaults
- **State**: Managed through Context API

### Deployment

```bash
# Development
npm run dev

# Production build
npm run build:modular

# Analyze bundle
npm run analyze
```
