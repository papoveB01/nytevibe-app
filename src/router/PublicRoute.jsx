import React from 'react';
import { Navigate } from 'react-router-dom';
import { useApp } from '../context/AppContext';

const PublicRoute = ({ children, redirectTo = '/' }) => {
  const { state } = useApp();
  const { isAuthenticated, isLoading } = state;

  if (isLoading) {
    return <div className="loading-spinner">Loading...</div>;
  }

  // If user is already authenticated, redirect to main app
  if (isAuthenticated) {
    return <Navigate to={redirectTo} replace />;
  }

  return children;
};

export default PublicRoute;
