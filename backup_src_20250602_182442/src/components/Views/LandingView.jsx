import React from 'react';
import { MapPin, Users, Heart, TrendingUp } from 'lucide-react';
import { useApp } from '../../context/AppContext';

const LandingView = ({ onSelectUserType }) => {
  const { actions } = useApp();

  const features = [
    { icon: MapPin, title: "Real-Time Discovery", description: "Find venues with live crowd updates" },
    { icon: Users, title: "Community Driven", description: "Reviews and ratings from real users" },
    { icon: Heart, title: "Personal Favorites", description: "Follow venues and create custom lists" },
    { icon: TrendingUp, title: "Smart Insights", description: "Data-driven venue recommendations" }
  ];

  const userBenefits = [
    "Discover trending venues instantly",
    "Get real-time crowd and wait updates",
    "Save and share favorite spots",
    "Earn points for community contributions",
    "Connect with Houston's nightlife community"
  ];

  const businessBenefits = [
    "Attract more customers to your venue",
    "Manage your venue's online presence",
    "Share promotions and special events",
    "Get valuable customer insights",
    "Increase visibility in Houston nightlife"
  ];

  return (
    <div className="landing-page">
      <div className="landing-container">
        <div className="hero-section">
          <h1 className="title-main">nYtevibe</h1>
          <p className="hero-subtitle">Houston's Premier Nightlife Discovery Platform</p>
          
          <div className="features-grid">
            {features.map((feature, index) => (
              <div key={index} className="feature-card">
                <feature.icon className="w-8 h-8 mb-4 text-blue-400" />
                <h3 className="text-xl font-bold mb-2">{feature.title}</h3>
                <p className="text-gray-300">{feature.description}</p>
              </div>
            ))}
          </div>
        </div>

        <div className="selection-cards">
          <div className="profile-card">
            <h2 className="text-2xl font-bold mb-4">I'm a User</h2>
            <p className="text-gray-600 mb-6">Discover Houston's best nightlife venues</p>
            <ul className="text-left mb-8 space-y-2">
              {userBenefits.map((benefit, index) => (
                <li key={index} className="flex items-center">
                  <span className="text-green-500 mr-2">✓</span>
                  {benefit}
                </li>
              ))}
            </ul>
            <button 
              className="cta-button"
              onClick={() => onSelectUserType('user')}
            >
              Get Started as User
            </button>
          </div>

          <div className="profile-card">
            <h2 className="text-2xl font-bold mb-4">I'm a Business</h2>
            <p className="text-gray-600 mb-6">Promote your venue to Houston nightlife enthusiasts</p>
            <ul className="text-left mb-8 space-y-2">
              {businessBenefits.map((benefit, index) => (
                <li key={index} className="flex items-center">
                  <span className="text-green-500 mr-2">✓</span>
                  {benefit}
                </li>
              ))}
            </ul>
            <button 
              className="cta-button"
              onClick={() => onSelectUserType('business')}
            >
              Get Started as Business
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default LandingView;
