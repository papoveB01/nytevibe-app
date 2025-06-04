import React from 'react';
import { Navigate, useLocation } from 'react-router-dom';
import { useApp } from '../context/AppContext'; // Use existing context hook

const ProtectedRoute = ({ children }) => {
  const { state } = useApp(); // Your existing pattern
  const { isAuthenticated, isLoading } = state;
  const location = useLocation();

  if (isLoading) {
    return <div className="loading-spinner">Loading...</div>;
  }

  if (!isAuthenticated) {
    return <Navigate to="/login" state={{ from: location }} replace />;
  }

  return children;
};

export default ProtectedRoute;
