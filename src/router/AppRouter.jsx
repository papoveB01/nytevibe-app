import ForgotPasswordView from "../components/Views/ForgotPasswordView";
import ResetPasswordView from "../components/Views/ResetPasswordView";
import EmailVerificationView from "../components/Auth/EmailVerificationView";
import TermsAndConditions from "../components/TermsAndConditions";
import React from 'react';
import { Routes, Route } from 'react-router-dom';
import ProtectedRoute from './ProtectedRoute';
import PublicRoute from './PublicRoute';

const AppRouter = () => {
  return (
    <Routes>
      {/* Public routes */}
      <Route path="/login" element={
        <PublicRoute>
          {/* Your existing login component will go here */}
          <div>Login will be routed here in future</div>
        </PublicRoute>
      } />
      
      {/* Terms and Conditions Routes - PUBLIC */}
      <Route path="/terms" element={
        <PublicRoute>
          <TermsAndConditions />
        </PublicRoute>
      } />
      <Route path="/terms-and-conditions" element={
        <PublicRoute>
          <TermsAndConditions />
        </PublicRoute>
      } />
      
      {/* Email Verification Route - PUBLIC (users aren't logged in yet) */}
      <Route path="/verify/:userId/:hash" element={
        <PublicRoute>
          <EmailVerificationView 
            onSuccess={() => window.location.href = '/login'} 
            onBack={() => window.location.href = '/login'}
          />
        </PublicRoute>
      } />
      
      {/* Password Reset Routes */}
      <Route path="/forgot-password" element={
        <PublicRoute>
          <ForgotPasswordView />
        </PublicRoute>
      } />
      <Route path="/reset-password" element={
        <PublicRoute>
          <ResetPasswordView />
        </PublicRoute>
      } />
      
      {/* Protected routes */}
      <Route path="/" element={
        <ProtectedRoute>
          {/* Your existing home component will go here */}
          <div>Main app will be routed here in future</div>
        </ProtectedRoute>
      } />
      
      {/* Add more routes as needed */}
    </Routes>
  );
};

export default AppRouter;
