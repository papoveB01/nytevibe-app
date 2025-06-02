import React, { useState, useEffect } from 'react';
import { Wifi, WifiOff, CheckCircle, XCircle, AlertCircle, RefreshCw } from 'lucide-react';
import apiService from '../../services/apiService';

const ApiTester = () => {
  const [diagnostics, setDiagnostics] = useState(null);
  const [isLoading, setIsLoading] = useState(false);
  const [connectionHistory, setConnectionHistory] = useState([]);

  const runDiagnostics = async () => {
    setIsLoading(true);
    try {
      const result = await apiService.diagnose();
      setDiagnostics(result);
      
      // Add to history
      setConnectionHistory(prev => [
        { timestamp: new Date(), result, success: result.connectionTest?.success },
        ...prev.slice(0, 4) // Keep last 5 results
      ]);
    } catch (error) {
      console.error('Diagnostics failed:', error);
      setDiagnostics({ error: error.message });
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    runDiagnostics();
  }, []);

  const getStatusIcon = (success) => {
    if (success === true) return <CheckCircle className="w-5 h-5 text-green-500" />;
    if (success === false) return <XCircle className="w-5 h-5 text-red-500" />;
    return <AlertCircle className="w-5 h-5 text-yellow-500" />;
  };

  const getStatusColor = (success) => {
    if (success === true) return 'text-green-600 bg-green-50 border-green-200';
    if (success === false) return 'text-red-600 bg-red-50 border-red-200';
    return 'text-yellow-600 bg-yellow-50 border-yellow-200';
  };

  return (
    <div className="api-tester">
      <div className="tester-header">
        <h3>API Connection Diagnostics</h3>
        <button 
          onClick={runDiagnostics} 
          disabled={isLoading}
          className="test-button"
        >
          <RefreshCw className={`w-4 h-4 ${isLoading ? 'animate-spin' : ''}`} />
          {isLoading ? 'Testing...' : 'Test Connection'}
        </button>
      </div>

      {diagnostics && (
        <div className="diagnostics-results">
          <div className="diagnostic-item">
            <div className="diagnostic-label">Network Status:</div>
            <div className={`diagnostic-value ${diagnostics.networkStatus === 'Online' ? 'online' : 'offline'}`}>
              {diagnostics.networkStatus === 'Online' ? 
                <Wifi className="w-4 h-4" /> : 
                <WifiOff className="w-4 h-4" />
              }
              {diagnostics.networkStatus}
            </div>
          </div>

          <div className="diagnostic-item">
            <div className="diagnostic-label">API URL:</div>
            <div className="diagnostic-value">
              <code>{diagnostics.apiUrl}</code>
            </div>
          </div>

          <div className="diagnostic-item">
            <div className="diagnostic-label">Authentication Token:</div>
            <div className="diagnostic-value">
              {diagnostics.hasToken ? '✅ Present' : '❌ Missing'}
            </div>
          </div>

          <div className="diagnostic-item">
            <div className="diagnostic-label">Connection Test:</div>
            <div className={`diagnostic-value ${getStatusColor(diagnostics.connectionTest?.success)}`}>
              {getStatusIcon(diagnostics.connectionTest?.success)}
              {diagnostics.connectionTest?.success ? 'Success' : 
               diagnostics.connectionTest?.error || 'Failed'}
            </div>
          </div>

          {diagnostics.connectionTest?.data && (
            <div className="diagnostic-item">
              <div className="diagnostic-label">API Response:</div>
              <div className="diagnostic-value">
                <pre>{JSON.stringify(diagnostics.connectionTest.data, null, 2)}</pre>
              </div>
            </div>
          )}
        </div>
      )}

      {connectionHistory.length > 0 && (
        <div className="connection-history">
          <h4>Recent Connection Tests</h4>
          {connectionHistory.map((test, index) => (
            <div key={index} className="history-item">
              <span className="history-time">
                {test.timestamp.toLocaleTimeString()}
              </span>
              <span className={`history-status ${test.success ? 'success' : 'failed'}`}>
                {getStatusIcon(test.success)}
                {test.success ? 'Connected' : 'Failed'}
              </span>
            </div>
          ))}
        </div>
      )}
    </div>
  );
};

export default ApiTester;
