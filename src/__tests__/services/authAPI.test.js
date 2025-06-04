/**
 * AuthAPI Service Tests
 * nYtevibe Authentication API Testing
 */

import authAPI from '../../services/authAPI';

// Mock fetch
global.fetch = jest.fn();

describe('AuthAPI Password Reset Methods', () => {
  beforeEach(() => {
    jest.clearAllMocks();
    localStorage.clear();
  });

  describe('forgotPassword', () => {
    test('handles successful password reset request', async () => {
      const mockResponse = {
        ok: true,
        json: () => Promise.resolve({
          success: true,
          data: { email: 't***@example.com' },
          message: 'Reset link sent'
        })
      };
      
      fetch.mockResolvedValue(mockResponse);
      
      const result = await authAPI.forgotPassword('test@example.com');
      
      expect(result.success).toBe(true);
      expect(result.data.email).toBe('t***@example.com');
    });

    test('handles user not found error', async () => {
      const mockResponse = {
        ok: false,
        json: () => Promise.resolve({
          error: {
            code: 'USER_NOT_FOUND',
            message: 'User not found'
          }
        })
      };
      
      fetch.mockResolvedValue(mockResponse);
      
      const result = await authAPI.forgotPassword('nonexistent@example.com');
      
      expect(result.success).toBe(false);
      expect(result.code).toBe('USER_NOT_FOUND');
    });

    test('handles rate limiting', async () => {
      const mockResponse = {
        ok: false,
        json: () => Promise.resolve({
          error: {
            code: 'RATE_LIMIT_EXCEEDED',
            message: 'Too many attempts',
            retry_after: 60
          }
        })
      };
      
      fetch.mockResolvedValue(mockResponse);
      
      const result = await authAPI.forgotPassword('test@example.com');
      
      expect(result.success).toBe(false);
      expect(result.code).toBe('RATE_LIMIT_EXCEEDED');
      expect(result.retryAfter).toBe(60);
    });
  });

  describe('resetPassword', () => {
    test('handles successful password reset', async () => {
      const mockResponse = {
        ok: true,
        json: () => Promise.resolve({
          success: true,
          message: 'Password reset successfully'
        })
      };
      
      fetch.mockResolvedValue(mockResponse);
      
      const result = await authAPI.resetPassword(
        'test-token',
        'test@example.com',
        'NewPass123!',
        'NewPass123!'
      );
      
      expect(result.success).toBe(true);
    });

    test('handles invalid token error', async () => {
      const mockResponse = {
        ok: false,
        json: () => Promise.resolve({
          error: {
            code: 'INVALID_TOKEN',
            message: 'Invalid or expired token'
          }
        })
      };
      
      fetch.mockResolvedValue(mockResponse);
      
      const result = await authAPI.resetPassword(
        'invalid-token',
        'test@example.com',
        'NewPass123!',
        'NewPass123!'
      );
      
      expect(result.success).toBe(false);
      expect(result.code).toBe('INVALID_TOKEN');
    });
  });

  describe('verifyResetToken', () => {
    test('handles valid token', async () => {
      const mockResponse = {
        ok: true,
        json: () => Promise.resolve({
          success: true,
          message: 'Token is valid'
        })
      };
      
      fetch.mockResolvedValue(mockResponse);
      
      const result = await authAPI.verifyResetToken('test-token', 'test@example.com');
      
      expect(result.success).toBe(true);
    });

    test('handles invalid token', async () => {
      const mockResponse = {
        ok: false,
        json: () => Promise.resolve({
          error: {
            code: 'INVALID_TOKEN',
            message: 'Invalid token'
          }
        })
      };
      
      fetch.mockResolvedValue(mockResponse);
      
      const result = await authAPI.verifyResetToken('invalid-token', 'test@example.com');
      
      expect(result.success).toBe(false);
      expect(result.code).toBe('INVALID_TOKEN');
    });
  });
});
