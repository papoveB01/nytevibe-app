import React from 'react';

const Badge = ({ children, variant = 'primary', className = '' }) => {
  const variantClasses = {
    primary: 'badge badge-blue',
    green: 'badge badge-green',
    yellow: 'badge badge-yellow',
    red: 'badge badge-red'
  };

  return (
    <span className={`${variantClasses[variant]} ${className}`}>
      {children}
    </span>
  );
};

export default Badge;
