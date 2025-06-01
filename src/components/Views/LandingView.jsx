import React from 'react';
import { 
  ArrowRight, 
  Users, 
  Building2, 
  Star, 
  MapPin, 
  Clock, 
  Heart,
  TrendingUp,
  Shield,
  Zap,
  CheckCircle
} from 'lucide-react';

const LandingView = ({ onSelectUserType }) => {
  const features = [
    {
      icon: MapPin,
      title: "Real-Time Discovery",
      description: "Find venues with live crowd levels and wait times"
    },
    {
      icon: Users,
      title: "Community Driven",
      description: "Reviews and ratings from real nightlife enthusiasts"
    },
    {
      icon: Heart,
      title: "Personal Favorites",
      description: "Follow venues and build your personalized nightlife guide"
    },
    {
      icon: TrendingUp,
      title: "Smart Insights",
      description: "AI-powered recommendations based on your preferences"
    }
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
      {/* Hero Section */}
      <div className="hero-section">
        <div className="hero-background">
          <div className="hero-gradient"></div>
        </div>
        
        <div className="hero-content">
          <div className="hero-text">
            <h1 className="hero-title">
              <span className="title-main">nYtevibe</span>
              <span className="title-subtitle">Houston Nightlife Discovery</span>
            </h1>
            
            <p className="hero-description">
              The ultimate platform connecting Houston's nightlife community. 
              Discover trending venues, share real-time updates, and experience 
              the city's best nightlife like never before.
            </p>
            
            <div className="hero-stats">
              <div className="stat-item">
                <div className="stat-number">500+</div>
                <div className="stat-label">Venues</div>
              </div>
              <div className="stat-item">
                <div className="stat-number">10K+</div>
                <div className="stat-label">Users</div>
              </div>
              <div className="stat-item">
                <div className="stat-number">Real-Time</div>
                <div className="stat-label">Updates</div>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Features Section */}
      <div className="features-section">
        <div className="section-container">
          <h2 className="section-title">Why Choose nYtevibe?</h2>
          <div className="features-grid">
            {features.map((feature, index) => (
              <div key={index} className="feature-card">
                <div className="feature-icon">
                  <feature.icon className="icon" />
                </div>
                <h3 className="feature-title">{feature.title}</h3>
                <p className="feature-description">{feature.description}</p>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* User Type Selection */}
      <div className="selection-section">
        <div className="section-container">
          <h2 className="section-title">Choose Your Experience</h2>
          <p className="section-description">
            Whether you're exploring Houston's nightlife or managing a venue, 
            nYtevibe has the perfect solution for you.
          </p>
          
          <div className="selection-cards">
            {/* User Profile Card */}
            <div className="profile-card user-card">
              <div className="card-header">
                <div className="card-icon user-icon">
                  <Users className="icon" />
                </div>
                <h3 className="card-title">I'm a User</h3>
                <p className="card-subtitle">Discover & Explore</p>
              </div>
              
              <div className="card-content">
                <p className="card-description">
                  Join Houston's nightlife community and discover the best venues, 
                  events, and experiences the city has to offer.
                </p>
                
                <ul className="benefits-list">
                  {userBenefits.map((benefit, index) => (
                    <li key={index} className="benefit-item">
                      <CheckCircle className="benefit-icon" />
                      <span>{benefit}</span>
                    </li>
                  ))}
                </ul>
              </div>
              
              <div className="card-footer">
                <button 
                  className="cta-button user-button"
                  onClick={() => onSelectUserType('user')}
                >
                  <span>Start Exploring</span>
                  <ArrowRight className="button-icon" />
                </button>
                <p className="card-note">Free to join • Instant access</p>
              </div>
            </div>

            {/* Business Profile Card */}
            <div className="profile-card business-card">
              <div className="card-header">
                <div className="card-icon business-icon">
                  <Building2 className="icon" />
                </div>
                <h3 className="card-title">I'm a Business</h3>
                <p className="card-subtitle">Grow & Connect</p>
              </div>
              
              <div className="card-content">
                <p className="card-description">
                  Showcase your venue to Houston's nightlife enthusiasts and 
                  build stronger connections with your community.
                </p>
                
                <ul className="benefits-list">
                  {businessBenefits.map((benefit, index) => (
                    <li key={index} className="benefit-item">
                      <CheckCircle className="benefit-icon" />
                      <span>{benefit}</span>
                    </li>
                  ))}
                </ul>
              </div>
              
              <div className="card-footer">
                <button 
                  className="cta-button business-button"
                  onClick={() => onSelectUserType('business')}
                >
                  <span>Claim Your Venue</span>
                  <ArrowRight className="button-icon" />
                </button>
                <p className="card-note">Boost your visibility • Drive more traffic</p>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Trust Section */}
      <div className="trust-section">
        <div className="section-container">
          <div className="trust-content">
            <div className="trust-badges">
              <div className="trust-badge">
                <Shield className="trust-icon" />
                <span>Secure & Private</span>
              </div>
              <div className="trust-badge">
                <Zap className="trust-icon" />
                <span>Real-Time Updates</span>
              </div>
              <div className="trust-badge">
                <Star className="trust-icon" />
                <span>Community Verified</span>
              </div>
            </div>
            
            <p className="trust-text">
              Trusted by Houston's nightlife community. Join thousands of users 
              and businesses already experiencing the future of nightlife discovery.
            </p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default LandingView;
