import React, { useState } from 'react';
import { ArrowLeft, Eye, EyeOff } from 'lucide-react';

const LoginView = ({ onBack, onLogin }) => {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [error, setError] = useState('');
  const [isLoading, setIsLoading] = useState(false);

  const demoCredentials = {
    username: 'demouser',
    password: 'demopass'
  };

  const fillDemoCredentials = () => {
    setUsername(demoCredentials.username);
    setPassword(demoCredentials.password);
    setError('');
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setIsLoading(true);

    setTimeout(() => {
      if (username === demoCredentials.username && password === demoCredentials.password) {
        onLogin({
          id: 'usr_demo',
          username: username,
          firstName: 'Demo',
          lastName: 'User'
        });
      } else {
        setError('Invalid username or password. Try: demouser / demopass');
      }
      setIsLoading(false);
    }, 1000);
  };

  return (
    <div className="login-page">
      <div className="login-container">
        <div className="login-card">
          <div className="login-header">
            <button onClick={onBack} className="back-to-landing">
              <ArrowLeft className="w-4 h-4 mr-2" />
              Back to Landing
            </button>
          </div>

          <div className="text-center mb-6">
            <h1 className="text-2xl font-bold mb-2">Welcome to nYtevibe</h1>
            <p className="text-gray-600">Sign in to discover Houston's nightlife</p>
          </div>

          <div className="demo-banner">
            <div className="text-center">
              <h3 className="font-bold text-amber-800 mb-2">Demo Account</h3>
              <p className="text-amber-700 mb-3">Use demo credentials to explore the app</p>
              <button 
                type="button"
                onClick={fillDemoCredentials}
                className="demo-fill-button"
              >
                Fill Demo Credentials
              </button>
            </div>
          </div>

          {error && (
            <div className="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded mb-4">
              {error}
            </div>
          )}

          <form onSubmit={handleSubmit}>
            <div className="mb-4">
              <input
                type="text"
                value={username}
                onChange={(e) => setUsername(e.target.value)}
                placeholder="Username"
                className="form-input"
                required
              />
            </div>

            <div className="mb-6 relative">
              <input
                type={showPassword ? 'text' : 'password'}
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                placeholder="Password"
                className="form-input pr-10"
                required
              />
              <button
                type="button"
                onClick={() => setShowPassword(!showPassword)}
                className="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-500"
              >
                {showPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
              </button>
            </div>

            <button
              type="submit"
              disabled={isLoading}
              className="login-button"
            >
              {isLoading ? (
                <>
                  <div className="loading-spinner"></div>
                  Signing In...
                </>
              ) : (
                'Sign In'
              )}
            </button>
          </form>

          <div className="text-center mt-6 text-gray-600">
            Don't have an account? <a href="#" className="text-blue-600 hover:underline">Sign up</a>
          </div>
        </div>
      </div>
    </div>
  );
};

export default LoginView;
