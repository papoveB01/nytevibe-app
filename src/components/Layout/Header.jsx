import React from 'react';
import SearchBar from './SearchBar';
import UserProfile from '../User/UserProfile';

const Header = ({ searchQuery, setSearchQuery, onClearSearch }) => {
  return (
    <div className="header-frame">
      <div className="header-content">
        <div className="flex justify-between items-center mb-4">
          <div>
            <h1 className="app-title">nYtevibe</h1>
            <p className="app-subtitle">Discover real-time venue vibes in Houston</p>
          </div>
          <UserProfile />
        </div>
        
        <SearchBar 
          searchQuery={searchQuery}
          setSearchQuery={setSearchQuery}
          onClearSearch={onClearSearch}
        />
      </div>
    </div>
  );
};

export default Header;
