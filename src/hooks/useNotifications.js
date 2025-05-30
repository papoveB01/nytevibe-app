import { useEffect } from 'react';
import { useApp } from '../context/AppContext';

export const useNotifications = () => {
  const { state, actions } = useApp();

  useEffect(() => {
    const timers = state.notifications.map(notification => {
      return setTimeout(() => {
        actions.removeNotification(notification.id);
      }, notification.duration);
    });

    return () => {
      timers.forEach(timer => clearTimeout(timer));
    };
  }, [state.notifications, actions]);

  return {
    notifications: state.notifications,
    addNotification: actions.addNotification,
    removeNotification: actions.removeNotification
  };
};
