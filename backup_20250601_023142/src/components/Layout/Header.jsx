import React from 'react';
import UserProfile from '../User/UserProfile';
import SearchBar from './SearchBar';

const Header = ({ searchQuery, setSearchQuery, onClearSearch }) => {
  return (
    <div className="header-frame">
      <div className="header-content">
        <div className="header-top">
          <div className="header-branding">
            <h1 className="app-title">nYtevibe</h1>
            <p className="app-subtitle">Houston Nightlife Discovery</p>
          </div>
          <UserProfile />
        </div>
        <SearchBar
          searchQuery={searchQuery}
          setSearchQuery={setSearchQuery}
          onClearSearch={onClearSearch}
          placeholder="Search venues, areas, or vibes..."
        />
      </div>
    </div>
  );
};

export default Header;
