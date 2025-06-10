import React from 'react';
import { useApp } from '../src/context/AppContext';

const PropFlowTester = () => {
  const { state, actions } = useApp();
  
  // Test navigation functions directly
  const testDirectNavigation = () => {
    console.log('🧪 Testing direct navigation...');
    console.log('Available actions:', Object.keys(actions));
    
    if (actions.setCurrentView) {
      console.log('✅ setCurrentView available');
      actions.setCurrentView('register');
    } else {
      console.error('❌ setCurrentView not available');
    }
    
    if (actions.setView) {
      console.log('✅ setView available');
      actions.setView('register');
    } else {
      console.error('❌ setView not available');
    }
  };
  
  // Test prop-based navigation
  const testPropNavigation = () => {
    console.log('🧪 Testing prop-based navigation...');
    
    // Simulate what ExistingApp should do
    const handleShowRegistration = () => {
      console.log('🔄 handleShowRegistration called');
      if (actions.setCurrentView) {
        actions.setCurrentView('register');
      }
    };
    
    const handleShowForgotPassword = () => {
      console.log('🔄 handleShowForgotPassword called');
      if (actions.setCurrentView) {
        actions.setCurrentView('forgot-password');
      }
    };
    
    // Test the handlers
    handleShowRegistration();
    setTimeout(() => handleShowForgotPassword(), 1000);
  };
  
  return (
    <div style={{
      position: 'fixed',
      top: '50px',
      right: '10px',
      background: 'rgba(0,0,0,0.9)',
      color: 'white',
      padding: '15px',
      borderRadius: '8px',
      zIndex: 9999,
      fontSize: '12px',
      maxWidth: '300px'
    }}>
      <h4>🧪 Prop Flow Tester</h4>
      <p><strong>Current View:</strong> {state.currentView}</p>
      
      <div style={{ marginTop: '10px' }}>
        <button 
          onClick={testDirectNavigation}
          style={{ margin: '2px', padding: '4px 8px', fontSize: '11px', display: 'block', width: '100%' }}
        >
          Test Direct Navigation
        </button>
        <button 
          onClick={testPropNavigation}
          style={{ margin: '2px', padding: '4px 8px', fontSize: '11px', display: 'block', width: '100%' }}
        >
          Test Prop Navigation
        </button>
      </div>
      
      <div style={{ marginTop: '10px', fontSize: '10px' }}>
        <strong>Actions Available:</strong>
        <ul style={{ margin: '5px 0', paddingLeft: '15px' }}>
          {Object.keys(actions).filter(key => key.includes('View')).map(key => (
            <li key={key}>{key}</li>
          ))}
        </ul>
      </div>
    </div>
  );
};

export default PropFlowTester;
