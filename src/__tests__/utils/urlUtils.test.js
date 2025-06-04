/**
 * URL Utils Tests
 * nYtevibe URL Utilities Testing
 */

import {
  getTokenFromURL,
  getEmailFromURL,
  validateResetURL,
  cleanResetURLParams,
  buildResetURL
} from '../../utils/urlUtils';

describe('URL Utils', () => {
  beforeEach(() => {
    // Mock window.location
    delete window.location;
    window.location = {
      search: '',
      origin: 'https://blackaxl.com'
    };
  });

  describe('getTokenFromURL', () => {
    test('extracts token from URL parameters', () => {
      window.location.search = '?token=test-token&email=test@example.com';
      expect(getTokenFromURL()).toBe('test-token');
    });

    test('returns null when no token parameter', () => {
      window.location.search = '?email=test@example.com';
      expect(getTokenFromURL()).toBeNull();
    });
  });

  describe('getEmailFromURL', () => {
    test('extracts email from URL parameters', () => {
      window.location.search = '?token=test-token&email=test@example.com';
      expect(getEmailFromURL()).toBe('test@example.com');
    });

    test('returns null when no email parameter', () => {
      window.location.search = '?token=test-token';
      expect(getEmailFromURL()).toBeNull();
    });
  });

  describe('validateResetURL', () => {
    test('validates complete reset URL', () => {
      window.location.search = '?token=test-token&email=test@example.com';
      const result = validateResetURL();
      
      expect(result.isValid).toBe(true);
      expect(result.token).toBe('test-token');
      expect(result.email).toBe('test@example.com');
      expect(result.errors).toHaveLength(0);
    });

    test('invalidates URL missing token', () => {
      window.location.search = '?email=test@example.com';
      const result = validateResetURL();
      
      expect(result.isValid).toBe(false);
      expect(result.errors).toContain('Reset token is missing from the URL');
    });

    test('invalidates URL missing email', () => {
      window.location.search = '?token=test-token';
      const result = validateResetURL();
      
      expect(result.isValid).toBe(false);
      expect(result.errors).toContain('Email is missing from the URL');
    });

    test('invalidates URL with invalid email format', () => {
      window.location.search = '?token=test-token&email=invalid-email';
      const result = validateResetURL();
      
      expect(result.isValid).toBe(false);
      expect(result.errors).toContain('Invalid email format in URL');
    });
  });

  describe('buildResetURL', () => {
    test('builds complete reset URL', () => {
      const url = buildResetURL('test-token', 'test@example.com');
      expect(url).toBe('https://blackaxl.com/reset-password?token=test-token&email=test%40example.com');
    });
  });
});
