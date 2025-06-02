import React from 'react';
import { X } from 'lucide-react';
const Modal = ({
  isOpen,
  onClose,
  title,
  children,
  className = '',
  ...props
}) => {
  if (!isOpen) return null;
  return (
    <div className="modal-overlay" onClick={onClose}>
      <div
        className={`modal-content ${className}`}
        onClick={(e) => e.stopPropagation()}
        {...props}
      >
        <div className="modal-header">
          <h3 className="modal-title">{title}</h3>
          <button onClick={onClose} className="modal-close">
            <X className="w-4 h-4" />
          </button>
        </div>
        <div className="modal-body">
          {children}
        </div>
      </div>
    </div>
  );
};
export default Modal;
