/**
 * ForgotPasswordView Component Tests
 * nYtevibe Password Reset Testing
 */

import React from 'react';
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import { BrowserRouter } from 'react-router-dom';
import ForgotPasswordView from '../../../components/Views/ForgotPasswordView';
import authAPI from '../../../services/authAPI';

// Mock the authAPI
jest.mock('../../../services/authAPI', () => ({
  forgotPassword: jest.fn()
}));

const MockedForgotPasswordView = () => (
  <BrowserRouter>
    <ForgotPasswordView />
  </BrowserRouter>
);

describe('ForgotPasswordView', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  test('renders forgot password form correctly', () => {
    render(<MockedForgotPasswordView />);
    
    expect(screen.getByText('Reset Your Password')).toBeInTheDocument();
    expect(screen.getByLabelText('Email or Username')).toBeInTheDocument();
    expect(screen.getByRole('button', { name: 'Send Reset Link' })).toBeInTheDocument();
    expect(screen.getByText('Back to Login')).toBeInTheDocument();
  });

  test('validates empty input', async () => {
    render(<MockedForgotPasswordView />);
    
    const submitButton = screen.getByRole('button', { name: 'Send Reset Link' });
    expect(submitButton).toBeDisabled();
  });

  test('validates email input correctly', async () => {
    render(<MockedForgotPasswordView />);
    
    const input = screen.getByLabelText('Email or Username');
    const submitButton = screen.getByRole('button', { name: 'Send Reset Link' });
    
    // Test valid email
    fireEvent.change(input, { target: { value: 'test@example.com' } });
    expect(submitButton).not.toBeDisabled();
    
    // Test valid username
    fireEvent.change(input, { target: { value: 'testuser' } });
    expect(submitButton).not.toBeDisabled();
  });

  test('handles successful email submission', async () => {
    authAPI.forgotPassword.mockResolvedValue({
      success: true,
      data: { email: 't***@example.com' }
    });

    render(<MockedForgotPasswordView />);
    
    const input = screen.getByLabelText('Email or Username');
    const submitButton = screen.getByRole('button', { name: 'Send Reset Link' });
    
    fireEvent.change(input, { target: { value: 'test@example.com' } });
    fireEvent.click(submitButton);

    await waitFor(() => {
      expect(screen.getByText(/Reset link sent!/)).toBeInTheDocument();
      expect(screen.getByText(/t\*\*\*@example\.com/)).toBeInTheDocument();
    });
  });

  test('handles rate limiting correctly', async () => {
    authAPI.forgotPassword.mockResolvedValue({
      success: false,
      code: 'RATE_LIMIT_EXCEEDED',
      retryAfter: 60
    });

    render(<MockedForgotPasswordView />);
    
    const input = screen.getByLabelText('Email or Username');
    const submitButton = screen.getByRole('button', { name: 'Send Reset Link' });
    
    fireEvent.change(input, { target: { value: 'test@example.com' } });
    fireEvent.click(submitButton);

    await waitFor(() => {
      expect(screen.getByText(/Too many attempts/)).toBeInTheDocument();
    });
  });

  test('handles user not found gracefully', async () => {
    authAPI.forgotPassword.mockResolvedValue({
      success: false,
      code: 'USER_NOT_FOUND'
    });

    render(<MockedForgotPasswordView />);
    
    const input = screen.getByLabelText('Email or Username');
    const submitButton = screen.getByRole('button', { name: 'Send Reset Link' });
    
    fireEvent.change(input, { target: { value: 'nonexistent@example.com' } });
    fireEvent.click(submitButton);

    await waitFor(() => {
      expect(screen.getByText(/If an account with that email exists/)).toBeInTheDocument();
    });
  });
});
