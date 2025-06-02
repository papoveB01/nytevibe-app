import React, { useState } from 'react';
import { ChevronDown, Settings, LogOut } from 'lucide-react';

const UserDropdown = ({ user }) => {
  const [isOpen, setIsOpen] = useState(false);

  return (
    <div className="relative">
      <button 
        onClick={() => setIsOpen(!isOpen)}
        className="flex items-center gap-2 p-2 rounded-lg hover:bg-gray-100"
      >
        <span>{user.firstName}</span>
        <ChevronDown className="w-4 h-4" />
      </button>
      
      {isOpen && (
        <div className="absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-lg border z-50">
          <div className="p-2">
            <button className="flex items-center gap-2 w-full p-2 hover:bg-gray-100 rounded">
              <Settings className="w-4 h-4" />
              Settings
            </button>
            <button className="flex items-center gap-2 w-full p-2 hover:bg-gray-100 rounded text-red-600">
              <LogOut className="w-4 h-4" />
              Sign Out
            </button>
          </div>
        </div>
      )}
    </div>
  );
};

export default UserDropdown;
