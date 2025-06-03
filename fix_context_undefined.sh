#!/bin/bash

# Fix AppContext Undefined Issues
echo "======================================================="
echo "    FIXING APPCONTEXT UNDEFINED ISSUES"
echo "======================================================="

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="./context_fix_backup_$TIMESTAMP"
mkdir -p "$BACKUP_DIR"

echo "User data is now stored correctly, but React state has undefined issues"
echo "This is happening during React rendering - likely in AppContext"
echo ""

log_change() {
    echo "✅ $1"
}

log_error() {
    echo "❌ $1"
}

echo ">>> STEP 1: EXAMINE APPCONTEXT"
echo "----------------------------------------"

if [ -f "src/context/AppContext.jsx" ]; then
    cp "src/context/AppContext.jsx" "$BACKUP_DIR/"
    
    echo "Current AppContext content:"
    echo "===================="
    cat src/context/AppContext.jsx
    echo "===================="
    echo ""
else
    log_error "AppContext.jsx not found - this is critical!"
    exit 1
fi

echo ">>> STEP 2: CREATE BULLETPROOF APPCONTEXT"
echo "----------------------------------------"

# Create a defensive version of AppContext that handles all undefined cases
cat > src/context/AppContext.fixed.jsx << 'EOF'
import React, { createContext, useContext, useReducer, useEffect } from 'react';

// Initial state with safe defaults
const initialState = {
  // Authentication
  isAuthenticated: false,
  user: null,
  
  // Navigation
  currentView: 'login', // Default to login view
  selectedVenue: null,
  
  // UI State
  searchQuery: '',
  notifications: [], // Always an array
  
  // Modals
  modals: {
    rating: { isOpen: false, venue: null },
    report: { isOpen: false, venue: null },
    share: { isOpen: false, venue: null },
    userProfile: { isOpen: false }
  },
  
  // Registration flow
  verificationMessage: {
    show: false,
    email: '',
    message: ''
  }
};

// Action types
const ActionTypes = {
  // Authentication
  LOGIN_USER: 'LOGIN_USER',
  LOGOUT_USER: 'LOGOUT_USER',
  
  // Navigation
  SET_CURRENT_VIEW: 'SET_CURRENT_VIEW',
  SET_SELECTED_VENUE: 'SET_SELECTED_VENUE',
  
  // UI
  SET_SEARCH_QUERY: 'SET_SEARCH_QUERY',
  ADD_NOTIFICATION: 'ADD_NOTIFICATION',
  REMOVE_NOTIFICATION: 'REMOVE_NOTIFICATION',
  
  // Modals
  OPEN_MODAL: 'OPEN_MODAL',
  CLOSE_MODAL: 'CLOSE_MODAL',
  
  // Registration
  SET_VERIFICATION_MESSAGE: 'SET_VERIFICATION_MESSAGE',
  CLEAR_VERIFICATION_MESSAGE: 'CLEAR_VERIFICATION_MESSAGE'
};

// Reducer with defensive programming
function appReducer(state, action) {
  // Ensure state always has required properties
  const safeState = {
    ...initialState,
    ...state
  };

  console.log('AppContext Reducer:', action.type, action.payload);

  switch (action.type) {
    case ActionTypes.LOGIN_USER:
      return {
        ...safeState,
        isAuthenticated: true,
        user: action.payload || null,
        currentView: 'home' // Redirect to home after login
      };

    case ActionTypes.LOGOUT_USER:
      // Clear localStorage
      localStorage.removeItem('auth_token');
      localStorage.removeItem('user');
      
      return {
        ...initialState, // Reset to initial state
        currentView: 'login'
      };

    case ActionTypes.SET_CURRENT_VIEW:
      const validViews = ['login', 'register', 'email-verification', 'home', 'details'];
      const newView = validViews.includes(action.payload) ? action.payload : 'login';
      
      return {
        ...safeState,
        currentView: newView
      };

    case ActionTypes.SET_SELECTED_VENUE:
      return {
        ...safeState,
        selectedVenue: action.payload
      };

    case ActionTypes.SET_SEARCH_QUERY:
      return {
        ...safeState,
        searchQuery: action.payload || ''
      };

    case ActionTypes.ADD_NOTIFICATION:
      const notification = {
        id: Date.now() + Math.random(),
        ...action.payload,
        timestamp: new Date()
      };
      
      return {
        ...safeState,
        notifications: [...(safeState.notifications || []), notification]
      };

    case ActionTypes.REMOVE_NOTIFICATION:
      return {
        ...safeState,
        notifications: (safeState.notifications || []).filter(n => n.id !== action.payload)
      };

    case ActionTypes.OPEN_MODAL:
      const { modalType, data } = action.payload || {};
      return {
        ...safeState,
        modals: {
          ...safeState.modals,
          [modalType]: {
            isOpen: true,
            ...data
          }
        }
      };

    case ActionTypes.CLOSE_MODAL:
      const modalToClose = action.payload;
      return {
        ...safeState,
        modals: {
          ...safeState.modals,
          [modalToClose]: {
            ...safeState.modals[modalToClose],
            isOpen: false
          }
        }
      };

    case ActionTypes.SET_VERIFICATION_MESSAGE:
      return {
        ...safeState,
        verificationMessage: {
          show: true,
          ...action.payload
        }
      };

    case ActionTypes.CLEAR_VERIFICATION_MESSAGE:
      return {
        ...safeState,
        verificationMessage: {
          show: false,
          email: '',
          message: ''
        }
      };

    default:
      console.warn('Unknown action type:', action.type);
      return safeState;
  }
}

// Create context
const AppContext = createContext(undefined);

// Provider component
export function AppProvider({ children }) {
  const [state, dispatch] = useReducer(appReducer, initialState);

  // Initialize from localStorage on mount
  useEffect(() => {
    console.log('AppContext: Initializing from localStorage');
    
    try {
      const authToken = localStorage.getItem('auth_token');
      const userStr = localStorage.getItem('user');
      
      console.log('Found in localStorage:', { 
        hasToken: !!authToken, 
        hasUser: !!userStr 
      });

      if (authToken && userStr) {
        const user = JSON.parse(userStr);
        console.log('Restoring user session:', user);
        
        dispatch({
          type: ActionTypes.LOGIN_USER,
          payload: user
        });
      } else {
        console.log('No valid session found, staying on login');
        dispatch({
          type: ActionTypes.SET_CURRENT_VIEW,
          payload: 'login'
        });
      }
    } catch (error) {
      console.error('Error initializing app context:', error);
      // Clear invalid data
      localStorage.removeItem('auth_token');
      localStorage.removeItem('user');
      
      dispatch({
        type: ActionTypes.SET_CURRENT_VIEW,
        payload: 'login'
      });
    }
  }, []);

  // Action creators
  const actions = {
    // Authentication
    loginUser: (user) => {
      console.log('AppContext: loginUser called with:', user);
      dispatch({ type: ActionTypes.LOGIN_USER, payload: user });
    },
    
    logoutUser: () => {
      console.log('AppContext: logoutUser called');
      dispatch({ type: ActionTypes.LOGOUT_USER });
    },

    // Navigation
    setCurrentView: (view) => {
      console.log('AppContext: setCurrentView called with:', view);
      dispatch({ type: ActionTypes.SET_CURRENT_VIEW, payload: view });
    },
    
    setSelectedVenue: (venue) => {
      dispatch({ type: ActionTypes.SET_SELECTED_VENUE, payload: venue });
    },

    // UI
    setSearchQuery: (query) => {
      dispatch({ type: ActionTypes.SET_SEARCH_QUERY, payload: query });
    },
    
    addNotification: (notification) => {
      dispatch({ type: ActionTypes.ADD_NOTIFICATION, payload: notification });
    },
    
    removeNotification: (id) => {
      dispatch({ type: ActionTypes.REMOVE_NOTIFICATION, payload: id });
    },

    // Modals
    openModal: (modalType, data = {}) => {
      dispatch({ type: ActionTypes.OPEN_MODAL, payload: { modalType, data } });
    },
    
    closeModal: (modalType) => {
      dispatch({ type: ActionTypes.CLOSE_MODAL, payload: modalType });
    },

    // Registration
    setVerificationMessage: (message) => {
      dispatch({ type: ActionTypes.SET_VERIFICATION_MESSAGE, payload: message });
    },
    
    clearVerificationMessage: () => {
      dispatch({ type: ActionTypes.CLEAR_VERIFICATION_MESSAGE });
    }
  };

  // Debug state changes
  useEffect(() => {
    console.log('AppContext State Updated:', {
      currentView: state.currentView,
      isAuthenticated: state.isAuthenticated,
      hasUser: !!state.user
    });
  }, [state.currentView, state.isAuthenticated, state.user]);

  const contextValue = {
    state,
    actions
  };

  return (
    <AppContext.Provider value={contextValue}>
      {children}
    </AppContext.Provider>
  );
}

// Hook to use the context
export function useApp() {
  const context = useContext(AppContext);
  
  if (context === undefined) {
    throw new Error('useApp must be used within an AppProvider');
  }
  
  return context;
}
EOF

log_change "Created bulletproof AppContext with defensive programming"

echo ""
echo ">>> STEP 3: APPLY THE FIXES"
echo "----------------------------------------"

# Replace the current AppContext with the fixed version
if [ -f "src/context/AppContext.jsx" ]; then
    mv src/context/AppContext.jsx "$BACKUP_DIR/AppContext.jsx.broken"
    mv src/context/AppContext.fixed.jsx src/context/AppContext.jsx
    log_change "Applied bulletproof AppContext"
else
    log_error "AppContext.jsx not found!"
fi

echo ""
echo ">>> STEP 4: VERIFY APP.JSX IS DEFENSIVE"
echo "----------------------------------------"

# Check if App.jsx has defensive checks
if grep -q "currentView.*||" src/App.jsx; then
    log_change "App.jsx already has defensive checks"
else
    echo "Adding additional safety to App.jsx..."
    
    # Create an even more defensive App.jsx
    cp src/App.jsx "$BACKUP_DIR/App.jsx.current"
    
    # Add a safety wrapper around the includes() calls
    sed -i.bak 's/\[\([^]]*\)\]\.includes(\([^)]*\))/[\1].includes(\2 || "")/g' src/App.jsx
    
    if [ -f src/App.jsx.bak ]; then
        rm src/App.jsx.bak
    fi
    
    log_change "Added defensive checks to App.jsx includes() calls"
fi

echo ""
echo ">>> STEP 5: CREATE EMERGENCY DEBUG COMPONENT"
echo "----------------------------------------"

# Create a debug component to help identify issues
cat > src/components/DebugApp.jsx << 'EOF'
import React from 'react';
import { useApp } from '../context/AppContext';

const DebugApp = () => {
  const { state, actions } = useApp();
  
  const debugInfo = {
    state: state || {},
    stateKeys: Object.keys(state || {}),
    currentView: state?.currentView,
    isAuthenticated: state?.isAuthenticated,
    user: state?.user,
    localStorage: {
      user: localStorage.getItem('user'),
      token: localStorage.getItem('auth_token')
    }
  };
  
  return (
    <div style={{ padding: '20px', fontFamily: 'monospace', background: '#f5f5f5' }}>
      <h2>🔍 Debug Information</h2>
      <pre style={{ background: 'white', padding: '15px', borderRadius: '4px', overflow: 'auto' }}>
        {JSON.stringify(debugInfo, null, 2)}
      </pre>
      
      <div style={{ marginTop: '20px' }}>
        <h3>Quick Actions</h3>
        <button onClick={() => actions?.setCurrentView('home')} style={{ margin: '5px', padding: '10px' }}>
          Go to Home
        </button>
        <button onClick={() => actions?.setCurrentView('login')} style={{ margin: '5px', padding: '10px' }}>
          Go to Login
        </button>
        <button onClick={() => localStorage.clear()} style={{ margin: '5px', padding: '10px' }}>
          Clear localStorage
        </button>
      </div>
    </div>
  );
};

export default DebugApp;
EOF

log_change "Created emergency debug component"

echo ""
echo ">>> STEP 6: CREATE TEMPORARY DEBUG APP"
echo "----------------------------------------"

# Create a temporary App that shows debug info instead of crashing
cat > src/App.debug.jsx << 'EOF'
import React from 'react';
import { AppProvider } from './context/AppContext';
import DebugApp from './components/DebugApp';

function App() {
  return (
    <AppProvider>
      <div style={{ padding: '20px' }}>
        <h1>🚨 Debug Mode - Identifying the undefined.includes() Error</h1>
        <DebugApp />
      </div>
    </AppProvider>
  );
}

export default App;
EOF

log_change "Created debug App version"

echo ""
echo ">>> IMMEDIATE ACTIONS"
echo "----------------------------------------"

echo "1. Clear everything and restart fresh:"
echo "   localStorage.clear() // Run in browser console"
echo "   npm run dev"
echo ""

echo "2. If still getting error, temporarily use debug mode:"
echo "   mv src/App.jsx src/App.main.jsx"
echo "   mv src/App.debug.jsx src/App.jsx"
echo "   # This will show debug info instead of crashing"
echo ""

echo "3. Check browser console for detailed logs from new AppContext"
echo ""

echo "4. Once working, switch back:"
echo "   mv src/App.jsx src/App.debug.jsx"
echo "   mv src/App.main.jsx src/App.jsx"
echo ""

echo ">>> WHAT THE NEW APPCONTEXT FIXES"
echo "----------------------------------------"

echo "🛡️ BULLETPROOF FEATURES:"
echo "✅ Safe defaults for all state properties"
echo "✅ currentView always has a valid string value"
echo "✅ notifications always initialized as empty array"
echo "✅ Defensive checks in all reducers"
echo "✅ Extensive logging to identify issues"
echo "✅ Graceful error handling for localStorage"
echo "✅ View validation to prevent invalid states"
echo ""

echo "🎯 SPECIFIC FIXES FOR .includes() ERROR:"
echo "✅ currentView defaults to 'login' (never undefined)"
echo "✅ All arrays initialized properly"
echo "✅ Safe state merging in reducer"
echo "✅ View validation before setting"
echo ""

echo "======================================================="
echo "🎯 THIS SHOULD ELIMINATE THE undefined.includes() ERROR!"
echo "======================================================="
echo ""
echo "The new AppContext ensures:"
echo "• currentView is never undefined"
echo "• All arrays are properly initialized"
echo "• State is always safe to access"
echo "• Detailed logging for debugging"
echo ""
echo "Run: npm run dev and clear localStorage to test!"
echo "======================================================="
