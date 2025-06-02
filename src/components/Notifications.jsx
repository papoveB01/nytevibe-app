import React, { useEffect } from 'react';
import { X, CheckCircle, AlertCircle, Info, AlertTriangle } from 'lucide-react';
import { useApp } from '../context/AppContext';

const Notifications = () => {
  const { state, actions } = useApp();
  const { notifications } = state;

  useEffect(() => {
    // Auto-remove notifications after their duration
    notifications.forEach(notification => {
      if (notification.duration) {
        setTimeout(() => {
          actions.removeNotification(notification.id);
        }, notification.duration);
      }
    });
  }, [notifications, actions]);

  const getNotificationIcon = (type) => {
    switch (type) {
      case 'success':
        return CheckCircle;
      case 'error':
        return AlertTriangle;
      case 'warning':
        return AlertCircle;
      default:
        return Info;
    }
  };

  const getNotificationColor = (type) => {
    switch (type) {
      case 'success':
        return 'border-green-500 bg-green-50';
      case 'error':
        return 'border-red-500 bg-red-50';
      case 'warning':
        return 'border-yellow-500 bg-yellow-50';
      default:
        return 'border-blue-500 bg-blue-50';
    }
  };

  if (notifications.length === 0) return null;

  return (
    <div className="notification-container">
      {notifications.map((notification) => {
        const Icon = getNotificationIcon(notification.type);
        const colorClass = getNotificationColor(notification.type);
        
        return (
          <div
            key={notification.id}
            className={`notification ${colorClass}`}
          >
            <div className="notification-content">
              <div className="notification-icon">
                <Icon className="w-4 h-4" />
              </div>
              <span className="notification-message">
                {notification.message}
              </span>
              <button
                onClick={() => actions.removeNotification(notification.id)}
                className="notification-close"
              >
                <X className="w-4 h-4" />
              </button>
            </div>
          </div>
        );
      })}
    </div>
  );
};

export default Notifications;
