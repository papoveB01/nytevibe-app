import React, { useState, useEffect } from 'react';
import { Wifi, WifiOff, AlertTriangle } from 'lucide-react';

const NetworkStatus = () => {
    const [isOnline, setIsOnline] = useState(navigator.onLine);
    const [connectionType, setConnectionType] = useState('unknown');

    useEffect(() => {
        const updateOnlineStatus = () => {
            setIsOnline(navigator.onLine);
            console.log('📶 Network status:', navigator.onLine ? 'Online' : 'Offline');
        };

        const updateConnectionType = () => {
            if ('connection' in navigator) {
                const connection = navigator.connection;
                setConnectionType(connection.effectiveType || 'unknown');
                console.log('📡 Connection info:', {
                    effectiveType: connection.effectiveType,
                    downlink: connection.downlink,
                    rtt: connection.rtt
                });
            }
        };

        // Listen for online/offline events
        window.addEventListener('online', updateOnlineStatus);
        window.addEventListener('offline', updateOnlineStatus);

        // Listen for connection changes
        if ('connection' in navigator) {
            navigator.connection.addEventListener('change', updateConnectionType);
        }

        // Initial check
        updateOnlineStatus();
        updateConnectionType();

        return () => {
            window.removeEventListener('online', updateOnlineStatus);
            window.removeEventListener('offline', updateOnlineStatus);
            if ('connection' in navigator) {
                navigator.connection.removeEventListener('change', updateConnectionType);
            }
        };
    }, []);

    if (!isOnline) {
        return (
            <div className="network-status offline">
                <WifiOff className="w-4 h-4" />
                <span>No internet connection</span>
            </div>
        );
    }

    if (connectionType === 'slow-2g' || connectionType === '2g') {
        return (
            <div className="network-status slow">
                <AlertTriangle className="w-4 h-4" />
                <span>Slow connection detected</span>
            </div>
        );
    }

    return null; // Don't show anything for good connections
};

export default NetworkStatus;
