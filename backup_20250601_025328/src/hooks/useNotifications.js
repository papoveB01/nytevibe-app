import { useApp } from '../context/AppContext';

export const useNotifications = () => {
  const { state, actions } = useApp();

  const addNotification = (notification) => {
    try {
      actions.addNotification(notification);
    } catch (error) {
      console.error('Error adding notification:', error);
    }
  };

  const removeNotification = (id) => {
    try {
      actions.removeNotification(id);
    } catch (error) {
      console.error('Error removing notification:', error);
    }
  };

  const clearAllNotifications = () => {
    try {
      state.notifications.forEach(notification => {
        actions.removeNotification(notification.id);
      });
    } catch (error) {
      console.error('Error clearing notifications:', error);
    }
  };

  return {
    notifications: state.notifications || [],
    addNotification,
    removeNotification,
    clearAllNotifications
  };
};
