import { useEffect } from 'react';
import { useApp } from '../context/AppContext';
export const useNotifications = () => {
  const { state, actions } = useApp();
  useEffect(() => {
    state.notifications.forEach(notification => {
      if (notification.duration && notification.duration > 0) {
        const timer = setTimeout(() => {
          actions.removeNotification(notification.id);
        }, notification.duration);
        return () => clearTimeout(timer);
      }
    });
  }, [state.notifications, actions]);
  const addNotification = (notification) => {
    actions.addNotification(notification);
  };
  const removeNotification = (id) => {
    actions.removeNotification(id);
  };
  return {
    notifications: state.notifications,
    addNotification,
    removeNotification
  };
};
