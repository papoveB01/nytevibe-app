import React, { useState, useEffect, useRef } from 'react';
import { useApp } from '../../context/AppContext';
import { getUserInitials, getLevelIcon } from '../../utils/helpers';
import './UserProfile.css';

const UserProfile = () => {
  const { state, actions } = useApp();
  const { userProfile } = state;
  const [isDropdownOpen, setIsDropdownOpen] = useState(false);
  const dropdownRef = useRef(null);

  // Close dropdown when clicking outside
  useEffect(() => {
    const handleClickOutside = (event) => {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target)) {
        setIsDropdownOpen(false);
      }
    };

    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  // Close dropdown on escape key
  useEffect(() => {
    const handleEscape = (event) => {
      if (event.key === 'Escape') {
        setIsDropdownOpen(false);
      }
    };

    document.addEventListener('keydown', handleEscape);
    return () => document.removeEventListener('keydown', handleEscape);
  }, []);

  const toggleDropdown = () => {
    setIsDropdownOpen(!isDropdownOpen);
  };

  const handleMenuAction = (action) => {
    setIsDropdownOpen(false);
    
    switch (action) {
      case 'profile':
        actions.addNotification({
          type: 'default',
          message: '🔍 Opening Full Profile View...'
        });
        break;
      case 'edit':
        actions.addNotification({
          type: 'default',
          message: '✏️ Opening Profile Editor...'
        });
        break;
      case 'lists':
        actions.addNotification({
          type: 'default',
          message: '💕 Opening Venue Lists...'
        });
        break;
      case 'activity':
        actions.addNotification({
          type: 'default',
          message: '📊 Opening Activity History...'
        });
        break;
      case 'settings':
        actions.addNotification({
          type: 'default',
          message: '⚙️ Opening Settings...'
        });
        break;
      case 'help':
        actions.addNotification({
          type: 'default',
          message: '🆘 Opening Help & Support...'
        });
        break;
      case 'signout':
        if (window.confirm('🚪 Are you sure you want to sign out?')) {
          actions.addNotification({
            type: 'default',
            message: '👋 Signing out... See you next time!'
          });
          // Add actual sign out logic here
        }
        break;
      default:
        break;
    }
  };

  const initials = getUserInitials(userProfile.firstName, userProfile.lastName);
  const levelIcon = getLevelIcon(userProfile.levelTier);

  return (
    <div className="user-badge-container" ref={dropdownRef}>
      <div 
        className={`user-badge ${isDropdownOpen ? 'open' : ''}`}
        onClick={toggleDropdown}
      >
        <div className="user-avatar-badge">{initials}</div>
        <div className="user-info-badge">
          <div className="user-name-badge">
            {userProfile.firstName} {userProfile.lastName}
          </div>
          <div className="user-level-badge">
            {levelIcon} {userProfile.level}
            <span className="points-badge">{userProfile.points.toLocaleString()}</span>
          </div>
        </div>
        <svg className="dropdown-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M19 9l-7 7-7-7"/>
        </svg>
      </div>

      <div className={`user-dropdown ${isDropdownOpen ? 'open' : ''}`}>
        {/* Profile Details Header */}
        <div className="dropdown-header">
          <div className="dropdown-profile">
            <div className="dropdown-avatar">{initials}</div>
            <div className="dropdown-user-info">
              <div className="dropdown-name">
                {userProfile.firstName} {userProfile.lastName}
              </div>
              <div className="dropdown-username">@{userProfile.username}</div>
              <div className="dropdown-level">
                <span className="level-badge-dropdown">
                  {levelIcon} {userProfile.level}
                </span>
              </div>
            </div>
          </div>

          {/* User Stats */}
          <div className="dropdown-stats">
            <div className="dropdown-stat">
              <div className="dropdown-stat-number">{userProfile.points.toLocaleString()}</div>
              <div className="dropdown-stat-label">Points</div>
            </div>
            <div className="dropdown-stat">
              <div className="dropdown-stat-number">{userProfile.totalReports}</div>
              <div className="dropdown-stat-label">Reports</div>
            </div>
            <div className="dropdown-stat">
              <div className="dropdown-stat-number">{userProfile.totalRatings}</div>
              <div className="dropdown-stat-label">Ratings</div>
            </div>
            <div className="dropdown-stat">
              <div className="dropdown-stat-number">{userProfile.totalFollows}</div>
              <div className="dropdown-stat-label">Following</div>
            </div>
          </div>
        </div>

        {/* Menu Items */}
        <div className="dropdown-menu">
          <button className="dropdown-item" onClick={() => handleMenuAction('profile')}>
            <svg className="dropdown-item-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
            </svg>
            View Full Profile
          </button>
          
          <button className="dropdown-item" onClick={() => handleMenuAction('edit')}>
            <svg className="dropdown-item-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
            </svg>
            Update Profile
          </button>

          <button className="dropdown-item" onClick={() => handleMenuAction('lists')}>
            <svg className="dropdown-item-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"/>
            </svg>
            My Venue Lists
          </button>

          <button className="dropdown-item" onClick={() => handleMenuAction('activity')}>
            <svg className="dropdown-item-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/>
            </svg>
            Activity History
          </button>

          <div className="dropdown-divider"></div>

          <button className="dropdown-item" onClick={() => handleMenuAction('settings')}>
            <svg className="dropdown-item-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"/>
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
            </svg>
            Settings
          </button>

          <button className="dropdown-item" onClick={() => handleMenuAction('help')}>
            <svg className="dropdown-item-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M8.228 9c.549-1.165 2.03-2 3.772-2 2.21 0 4 1.343 4 3 0 1.4-1.278 2.575-3.006 2.907-.542.104-.994.54-.994 1.093m0 3h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
            </svg>
            Help & Support
          </button>

          <div className="dropdown-divider"></div>

          <button className="dropdown-item danger" onClick={() => handleMenuAction('signout')}>
            <svg className="dropdown-item-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"/>
            </svg>
            Sign Out
          </button>
        </div>
      </div>

      {/* Overlay */}
      {isDropdownOpen && <div className="dropdown-overlay" onClick={() => setIsDropdownOpen(false)} />}
    </div>
  );
};

export default UserProfile;
