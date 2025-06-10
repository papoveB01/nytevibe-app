import React from 'react';
import { useApp } from '../src/context/AppContext';

const NavigationTester = () => {
  const { state, actions } = useApp();
  
  const testNavigation = (targetView, testName) => {
    console.log(`🧪 Testing navigation: ${testName}`);
    console.log('Before:', { currentView: state.currentView });
    
    try {
      if (actions.setCurrentView) {
        actions.setCurrentView(targetView);
        console.log('✅ setCurrentView called successfully');
      } else {
        console.error('❌ setCurrentView not available');
      }
      
      if (actions.setView) {
        actions.setView(targetView);
        console.log('✅ setView called successfully');
      } else {
        console.error('❌ setView not available');
      }
      
      setTimeout(() => {
        console.log('After:', { currentView: state.currentView });
        console.log('Navigation test complete for:', testName);
        console.log('---');
      }, 100);
      
    } catch (error) {
      console.error('❌ Navigation test failed:', error);
    }
  };

  return (
    <div style={{
      position: 'fixed',
      bottom: '10px',
      left: '10px',
      background: 'rgba(0,0,0,0.9)',
      color: 'white',
      padding: '15px',
      borderRadius: '8px',
      zIndex: 9999,
      fontSize: '12px',
      maxWidth: '400px'
    }}>
      <h4>🧪 Navigation Tester</h4>
      <p><strong>Current View:</strong> {state.currentView}</p>
      <p><strong>Actions Available:</strong></p>
      <ul>
        <li>setCurrentView: {actions.setCurrentView ? '✅' : '❌'}</li>
        <li>setView: {actions.setView ? '✅' : '❌'}</li>
      </ul>
      
      <div style={{ marginTop: '10px' }}>
        <button onClick={() => testNavigation('register', 'Create Account')} 
                style={{ margin: '2px', padding: '4px 8px', fontSize: '11px' }}>
          Test Register
        </button>
        <button onClick={() => testNavigation('forgot-password', 'Forgot Password')} 
                style={{ margin: '2px', padding: '4px 8px', fontSize: '11px' }}>
          Test Forgot Password
        </button>
        <button onClick={() => testNavigation('details', 'Venue Details')} 
                style={{ margin: '2px', padding: '4px 8px', fontSize: '11px' }}>
          Test Details
        </button>
        <button onClick={() => testNavigation('home', 'Home')} 
                style={{ margin: '2px', padding: '4px 8px', fontSize: '11px' }}>
          Test Home
        </button>
      </div>
    </div>
  );
};

export default NavigationTester;
