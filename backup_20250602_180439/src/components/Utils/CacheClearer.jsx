import React, { useEffect } from 'react';

const CacheClearer = () => {
  useEffect(() => {
    // Clear all localStorage
    try {
      localStorage.clear();
      sessionStorage.clear();
      console.log('🧹 Cache and storage cleared');
    } catch (error) {
      console.log('🧹 Cache clearing completed (some items may be protected)');
    }
  }, []);

  return null;
};

export default CacheClearer;
