// Add this temporarily to your app to debug state
import React from 'react';
import { useApp } from './context/AppContext';

export function StateDebugger() {
    const { state, actions } = useApp();
    
    return (
        <div style={{
            position: 'fixed',
            bottom: 10,
            right: 10,
            background: '#333',
            color: 'white',
            padding: '10px',
            borderRadius: '5px',
            fontSize: '12px',
            zIndex: 9999
        }}>
            <div>Auth: {state.isAuthenticated ? '✓' : '✗'}</div>
            <div>View: {state.currentView}</div>
            <div>User: {state.user?.username || 'none'}</div>
            <button 
                onClick={() => actions.setView('home')}
                style={{ marginTop: '5px', fontSize: '10px' }}
            >
                Force Home
            </button>
        </div>
    );
}
