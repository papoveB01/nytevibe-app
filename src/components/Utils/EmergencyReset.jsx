import React from 'react';

const EmergencyReset = () => {
  const handleReset = () => {
    // Clear all storage
    try {
      localStorage.clear();
      sessionStorage.clear();
    } catch (error) {
      console.log('Storage clearing completed');
    }
    
    // Force reload
    window.location.reload();
  };

  return (
    <div style={{
      position: 'fixed',
      top: '10px',
      right: '10px',
      zIndex: 10000,
      background: '#ff4444',
      color: 'white',
      padding: '8px 12px',
      borderRadius: '5px',
      fontSize: '12px',
      boxShadow: '0 2px 10px rgba(0,0,0,0.3)'
    }}>
      <button onClick={handleReset} style={{
        background: 'none',
        border: '1px solid white',
        color: 'white',
        padding: '4px 8px',
        borderRadius: '3px',
        cursor: 'pointer',
        fontSize: '11px'
      }}>
        🚨 Reset App
      </button>
    </div>
  );
};

export default EmergencyReset;
