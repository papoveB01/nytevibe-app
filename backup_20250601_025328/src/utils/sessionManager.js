const SESSION_KEYS = {
  USER_SESSION: 'nytevibe_user_session',
  LOGIN_TIMESTAMP: 'nytevibe_login_time', 
  USER_DATA: 'nytevibe_user_data'
};

export class SessionManager {
  static SESSION_DURATION = 24 * 60 * 60 * 1000; // 24 hours

  static createSession(userData) {
    try {
      const sessionData = {
        user: userData,
        timestamp: Date.now(),
        expiresAt: Date.now() + this.SESSION_DURATION,
        sessionId: this.generateSessionId(),
        version: '2.1.2'
      };

      localStorage.setItem(SESSION_KEYS.USER_SESSION, JSON.stringify(sessionData));
      console.log('✅ Session created successfully:', {
        user: userData.username,
        expiresAt: new Date(sessionData.expiresAt).toLocaleString()
      });
      return sessionData;
    } catch (error) {
      console.error('❌ Failed to create session:', error);
      return null;
    }
  }

  static getValidSession() {
    try {
      const sessionDataStr = localStorage.getItem(SESSION_KEYS.USER_SESSION);
      if (!sessionDataStr) {
        console.log('🔍 No session found');
        return null;
      }

      const sessionData = JSON.parse(sessionDataStr);
      const currentTime = Date.now();

      if (currentTime > sessionData.expiresAt) {
        console.log('⏰ Session expired, clearing...');
        this.clearSession();
        return null;
      }

      if (!this.validateSessionData(sessionData)) {
        console.log('🔧 Corrupted session detected, clearing...');
        this.clearSession();
        return null;
      }

      return sessionData;
    } catch (error) {
      console.error('❌ Error checking session:', error);
      this.clearSession();
      return null;
    }
  }

  static validateSessionData(sessionData) {
    const requiredFields = ['user', 'timestamp', 'expiresAt', 'sessionId'];
    return requiredFields.every(field => sessionData[field] !== undefined);
  }

  static clearSession() {
    try {
      localStorage.removeItem(SESSION_KEYS.USER_SESSION);
      localStorage.removeItem(SESSION_KEYS.LOGIN_TIMESTAMP);
      localStorage.removeItem(SESSION_KEYS.USER_DATA);
      console.log('🗑️ Session cleared successfully');
    } catch (error) {
      console.error('❌ Error clearing session:', error);
    }
  }

  static cleanupExpiredSessions() {
    const session = this.getValidSession();
    if (!session) {
      this.clearSession();
    }
  }

  static generateSessionId() {
    return 'session_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9);
  }

  static getSessionInfo() {
    const session = this.getValidSession();
    if (!session) return null;

    const now = Date.now();
    const remainingTime = session.expiresAt - now;
    const remainingHours = Math.floor(remainingTime / (1000 * 60 * 60));
    const remainingMinutes = Math.floor((remainingTime % (1000 * 60 * 60)) / (1000 * 60));

    return {
      user: session.user.username,
      remainingTime: `${remainingHours}h ${remainingMinutes}m`,
      expiresAt: new Date(session.expiresAt).toLocaleString()
    };
  }
}
