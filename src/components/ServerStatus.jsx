import React, { useState, useEffect } from 'react';
import { Server, AlertTriangle, CheckCircle, XCircle } from 'lucide-react';

const ServerStatus = () => {
    const [serverStatus, setServerStatus] = useState('checking');
    const [statusMessage, setStatusMessage] = useState('Checking server status...');

    useEffect(() => {
        const checkServerStatus = async () => {
            try {
                // Test basic connectivity (no-cors to avoid preflight issues)
                const response = await fetch('https://system.nytevibe.com/', {
                    method: 'HEAD',
                    mode: 'no-cors'
                });
                
                setServerStatus('available');
                setStatusMessage('Server is responding');
            } catch (error) {
                console.error('Server status check failed:', error);
                setServerStatus('unavailable');
                setStatusMessage('Server appears to be having issues');
            }
        };

        checkServerStatus();
        
        // Check every 30 seconds
        const interval = setInterval(checkServerStatus, 30000);
        
        return () => clearInterval(interval);
    }, []);

    if (serverStatus === 'checking') {
        return (
            <div className="server-status checking">
                <Server className="w-4 h-4 animate-pulse" />
                <span>{statusMessage}</span>
            </div>
        );
    }

    if (serverStatus === 'unavailable') {
        return (
            <div className="server-status unavailable">
                <XCircle className="w-4 h-4" />
                <span>Server issues detected - Registration may fail</span>
            </div>
        );
    }

    // Don't show anything if server is working normally
    return null;
};

export default ServerStatus;
