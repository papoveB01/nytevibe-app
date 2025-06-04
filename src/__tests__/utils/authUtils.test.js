/**
 * Auth Utils Tests
 * nYtevibe Authentication Utilities Testing
 */

import {
  validateForgotPasswordForm,
  validatePasswordResetForm,
  validatePasswordStrength,
  getPasswordStrength,
  maskEmail,
  formatRetryCountdown
} from '../../utils/authUtils';

describe('Auth Utils', () => {
  describe('validateForgotPasswordForm', () => {
    test('validates correct email', () => {
      const result = validateForgotPasswordForm('test@example.com');
      expect(result.isValid).toBe(true);
      expect(result.errors).toEqual({});
    });

    test('validates correct username', () => {
      const result = validateForgotPasswordForm('testuser');
      expect(result.isValid).toBe(true);
      expect(result.errors).toEqual({});
    });

    test('invalidates empty input', () => {
      const result = validateForgotPasswordForm('');
      expect(result.isValid).toBe(false);
      expect(result.errors.identifier).toBe('Email or username is required');
    });

    test('invalidates too short input', () => {
      const result = validateForgotPasswordForm('ab');
      expect(result.isValid).toBe(false);
      expect(result.errors.identifier).toBe('Please enter a valid email or username');
    });
  });

  describe('validatePasswordStrength', () => {
    test('validates strong password', () => {
      const errors = validatePasswordStrength('StrongPass123!');
      expect(errors).toHaveLength(0);
    });

    test('invalidates weak password', () => {
      const errors = validatePasswordStrength('weak');
      expect(errors.length).toBeGreaterThan(0);
      expect(errors).toContain('Password must be at least 8 characters long');
    });

    test('requires uppercase letter', () => {
      const errors = validatePasswordStrength('lowercase123!');
      expect(errors).toContain('Password must contain at least one uppercase letter');
    });

    test('requires special character', () => {
      const errors = validatePasswordStrength('NoSpecial123');
      expect(errors).toContain('Password must contain at least one special character');
    });
  });

  describe('getPasswordStrength', () => {
    test('rates strong password correctly', () => {
      const strength = getPasswordStrength('VeryStrongPass123!');
      expect(strength.score).toBeGreaterThanOrEqual(5);
      expect(strength.label).toMatch(/Strong/);
    });

    test('rates weak password correctly', () => {
      const strength = getPasswordStrength('weak');
      expect(strength.score).toBeLessThan(3);
      expect(strength.label).toMatch(/Weak/);
    });
  });

  describe('maskEmail', () => {
    test('masks email correctly', () => {
      expect(maskEmail('test@example.com')).toBe('t**t@example.com');
      expect(maskEmail('a@example.com')).toBe('a@example.com');
      expect(maskEmail('ab@example.com')).toBe('ab@example.com');
    });

    test('handles invalid email', () => {
      expect(maskEmail('invalid')).toBe('');
      expect(maskEmail('')).toBe('');
    });
  });

  describe('formatRetryCountdown', () => {
    test('formats seconds correctly', () => {
      expect(formatRetryCountdown(30)).toBe('30s');
      expect(formatRetryCountdown(5)).toBe('5s');
    });

    test('formats minutes and seconds correctly', () => {
      expect(formatRetryCountdown(90)).toBe('1:30');
      expect(formatRetryCountdown(125)).toBe('2:05');
    });
  });
});
