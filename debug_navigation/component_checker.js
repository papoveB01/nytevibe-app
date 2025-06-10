// Component Checker - Add this to any React component temporarily

import { useApp } from '../context/AppContext';
import { useEffect } from 'react';

export const ComponentChecker = ({ componentName }) => {
  const { state, actions } = useApp();
  
  useEffect(() => {
    console.log(`🔍 ${componentName} - Component Debug Info:`);
    console.log('- State available:', !!state);
    console.log('- Actions available:', !!actions);
    console.log('- Current view:', state?.currentView);
    console.log('- Available actions:', Object.keys(actions || {}));
    
    // Check specific navigation actions
    console.log('- setCurrentView available:', typeof actions?.setCurrentView);
    console.log('- setView available:', typeof actions?.setView);
    
    // Test if actions are callable
    if (actions?.setCurrentView) {
      console.log('✅ setCurrentView is callable');
    } else {
      console.log('❌ setCurrentView is NOT callable');
    }
    
  }, [state, actions, componentName]);
  
  return null; // This component doesn't render anything
};
