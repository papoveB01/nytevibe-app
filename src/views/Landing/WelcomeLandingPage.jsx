import React, { useState } from 'react';
import { useApp } from '../../context/AppContext';
import './WelcomeLandingPage.css';

const WelcomeLandingPage = () => {
  const { actions } = useApp();
  const [isTransitioning, setIsTransitioning] = useState(false);

  const selectProfile = (mode) => {
    setIsTransitioning(true);
    
    setTimeout(() => {
      actions.setCurrentMode(mode);
      actions.setCurrentView('home');
      setIsTransitioning(false);
    }, 500);
  };

  return (
    <div className={`landing-page ${isTransitioning ? 'transitioning' : ''}`}>
      <div className="landing-hero">
        <h1 className="landing-title">nYtevibe</h1>
        <h2 className="landing-subtitle">Houston Nightlife Discovery</h2>
        <p className="landing-description">
          Discover real-time venue vibes, connect with your community, and experience Houston's nightlife like never before.
        </p>
      </div>
      
      <div className="profile-selection">
        <div className="profile-card customer-card" onClick={() => selectProfile('user')}>
          <div className="profile-icon">🎉</div>
          <h3 className="profile-title">Customer Experience</h3>
          <ul className="profile-features">
            <li>Discover venues with real-time data</li>
            <li>Follow your favorite spots</li>
            <li>Rate and review experiences</li>
            <li>Earn points and badges</li>
            <li>Share with friends</li>
            <li>Get personalized recommendations</li>
          </ul>
        </div>
        
        <div className="profile-card business-card" onClick={() => selectProfile('venue_owner')}>
          <div className="profile-icon">📊</div>
          <h3 className="profile-title">Business Dashboard</h3>
          <ul className="profile-features">
            <li>Real-time venue analytics</li>
            <li>Manage staff and operations</li>
            <li>Monitor customer feedback</li>
            <li>Track crowd levels and trends</li>
            <li>Promote events and specials</li>
            <li>Build community engagement</li>
          </ul>
        </div>
      </div>
    </div>
  );
};

export default WelcomeLandingPage;
