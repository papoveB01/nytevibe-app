/**
 * ResetPasswordView Component Tests
 * nYtevibe Password Reset Testing
 */

import React from 'react';
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import { BrowserRouter } from 'react-router-dom';
import ResetPasswordView from '../../../components/Views/ResetPasswordView';
import authAPI from '../../../services/authAPI';

// Mock the authAPI
jest.mock('../../../services/authAPI', () => ({
  verifyResetToken: jest.fn(),
  resetPassword: jest.fn()
}));

// Mock URL search params
const mockSearchParams = new URLSearchParams();
mockSearchParams.set('token', 'test-token');
mockSearchParams.set('email', 'test@example.com');

Object.defineProperty(window, 'location', {
  value: {
    search: mockSearchParams.toString()
  },
  writable: true
});

const MockedResetPasswordView = () => (
  <BrowserRouter>
    <ResetPasswordView />
  </BrowserRouter>
);

describe('ResetPasswordView', () => {
  beforeEach(() => {
    jest.clearAllMocks();
    window.location.search = mockSearchParams.toString();
  });

  test('validates token on component mount', async () => {
    authAPI.verifyResetToken.mockResolvedValue({ success: true });
    
    render(<MockedResetPasswordView />);
    
    await waitFor(() => {
      expect(authAPI.verifyResetToken).toHaveBeenCalledWith('test-token', 'test@example.com');
    });
  });

  test('shows invalid token message for expired tokens', async () => {
    authAPI.verifyResetToken.mockResolvedValue({
      success: false,
      code: 'INVALID_TOKEN'
    });
    
    render(<MockedResetPasswordView />);
    
    await waitFor(() => {
      expect(screen.getByText('Invalid Reset Link')).toBeInTheDocument();
      expect(screen.getByText('Request New Reset Link')).toBeInTheDocument();
    });
  });

  test('validates password strength correctly', async () => {
    authAPI.verifyResetToken.mockResolvedValue({ success: true });
    
    render(<MockedResetPasswordView />);
    
    await waitFor(() => {
      expect(screen.getByLabelText('New Password')).toBeInTheDocument();
    });
    
    const passwordInput = screen.getByLabelText('New Password');
    
    // Test weak password
    fireEvent.change(passwordInput, { target: { value: 'weak' } });
    
    await waitFor(() => {
      expect(screen.getByText('Very Weak')).toBeInTheDocument();
    });
    
    // Test strong password
    fireEvent.change(passwordInput, { target: { value: 'StrongPass123!' } });
    
    await waitFor(() => {
      expect(screen.getByText('Strong')).toBeInTheDocument();
    });
  });

  test('validates password confirmation matching', async () => {
    authAPI.verifyResetToken.mockResolvedValue({ success: true });
    
    render(<MockedResetPasswordView />);
    
    await waitFor(() => {
      expect(screen.getByLabelText('New Password')).toBeInTheDocument();
    });
    
    const passwordInput = screen.getByLabelText('New Password');
    const confirmInput = screen.getByLabelText('Confirm Password');
    
    fireEvent.change(passwordInput, { target: { value: 'StrongPass123!' } });
    fireEvent.change(confirmInput, { target: { value: 'DifferentPass123!' } });
    
    const submitButton = screen.getByRole('button', { name: 'Reset Password' });
    fireEvent.click(submitButton);
    
    await waitFor(() => {
      expect(screen.getByText('Passwords do not match')).toBeInTheDocument();
    });
  });

  test('successfully resets password', async () => {
    authAPI.verifyResetToken.mockResolvedValue({ success: true });
    authAPI.resetPassword.mockResolvedValue({ success: true });
    
    render(<MockedResetPasswordView />);
    
    await waitFor(() => {
      expect(screen.getByLabelText('New Password')).toBeInTheDocument();
    });
    
    const passwordInput = screen.getByLabelText('New Password');
    const confirmInput = screen.getByLabelText('Confirm Password');
    const submitButton = screen.getByRole('button', { name: 'Reset Password' });
    
    fireEvent.change(passwordInput, { target: { value: 'StrongPass123!' } });
    fireEvent.change(confirmInput, { target: { value: 'StrongPass123!' } });
    fireEvent.click(submitButton);
    
    await waitFor(() => {
      expect(screen.getByText('Password Reset Successful')).toBeInTheDocument();
    });
  });
});
