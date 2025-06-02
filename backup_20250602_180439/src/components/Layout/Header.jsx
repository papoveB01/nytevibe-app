import React, { useState } from 'react';
import { Search, X, Filter, Menu, LogOut } from 'lucide-react';
import { useApp } from '../../context/AppContext';
import SearchBar from './SearchBar';
import UserProfile from '../User/UserProfile';

const Header = ({ onLogout }) => {
  const { state, actions } = useApp();
  const [showMobileMenu, setShowMobileMenu] = useState(false);

  const handleClearSearch = () => {
    actions.setSearchQuery('');
    actions.addNotification({
      type: 'default',
      message: '🔍 Search cleared'
    });
  };

  const handleLogout = () => {
    if (onLogout) {
      onLogout();
    }
  };

  return (
    <header className="header">
      <div className="header-content">
        {/* Header Top */}
        <div className="header-top">
          {/* Left Side - App Title */}
          <div className="app-branding">
            <h1 className="app-title">nYtevibe</h1>
            <p className="app-subtitle">Houston's Nightlife Discovery</p>
          </div>

          {/* Right Side - User Profile & Logout */}
          <div className="header-actions">
            <UserProfile />
            <button
              className="logout-button"
              onClick={handleLogout}
              title="Logout"
            >
              <LogOut size={16} />
              <span className="logout-text">Logout</span>
            </button>
            
            {/* Mobile Menu Toggle */}
            <button
              className="mobile-menu-toggle"
              onClick={() => setShowMobileMenu(!showMobileMenu)}
            >
              <Menu size={20} />
            </button>
          </div>
        </div>

        {/* Search Bar */}
        <div className={`header-search ${showMobileMenu ? 'mobile-visible' : ''}`}>
          <SearchBar
            searchQuery={state.searchQuery}
            setSearchQuery={actions.setSearchQuery}
            onClearSearch={handleClearSearch}
          />
        </div>

        {/* Filter Bar */}
        <div className={`header-filters ${showMobileMenu ? 'mobile-visible' : ''}`}>
          <div className="filter-options">
            {['all', 'bars', 'clubs', 'lounges', 'promotions'].map((filter) => (
              <button
                key={filter}
                className={`filter-option ${state.activeFilter === filter ? 'active' : ''}`}
                onClick={() => {
                  actions.setActiveFilter(filter);
                  setShowMobileMenu(false);
                }}
              >
                <Filter size={14} />
                <span>{filter.charAt(0).toUpperCase() + filter.slice(1)}</span>
              </button>
            ))}
          </div>
        </div>
      </div>
    </header>
  );
};

export default Header;
