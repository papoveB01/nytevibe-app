import React, { useState, useEffect } from 'react';
import { ChevronLeft, ChevronRight } from 'lucide-react';

const PromotionalBanner = () => {
  const [currentBanner, setCurrentBanner] = useState(0);

  // Static banners for demo
  const banners = [
    {
      id: 1,
      title: "Friday Night Special",
      subtitle: "Happy hour until 8 PM at downtown venues",
      gradient: "linear-gradient(135deg, #667eea 0%, #764ba2 100%)",
      emoji: "🍹"
    },
    {
      id: 2,
      title: "Weekend Warriors",
      subtitle: "Discover the hottest Saturday night spots",
      gradient: "linear-gradient(135deg, #f093fb 0%, #f5576c 100%)",
      emoji: "🎉"
    },
    {
      id: 3,
      title: "Sunday Vibes",
      subtitle: "Chill lounges and rooftop bars",
      gradient: "linear-gradient(135deg, #4facfe 0%, #00f2fe 100%)",
      emoji: "🌅"
    }
  ];

  // Auto-rotate banners
  useEffect(() => {
    const interval = setInterval(() => {
      setCurrentBanner((prev) => (prev + 1) % banners.length);
    }, 5000);

    return () => clearInterval(interval);
  }, [banners.length]);

  const nextBanner = () => {
    setCurrentBanner((prev) => (prev + 1) % banners.length);
  };

  const prevBanner = () => {
    setCurrentBanner((prev) => (prev - 1 + banners.length) % banners.length);
  };

  const banner = banners[currentBanner] || banners[0];

  return (
    <div className="promotional-banner-section">
      <div 
        className="promotional-banner main"
        style={{ background: banner.gradient }}
      >
        <button 
          className="banner-nav prev"
          onClick={prevBanner}
          aria-label="Previous banner"
        >
          <ChevronLeft size={20} />
        </button>

        <div className="banner-content">
          <div className="banner-emoji">{banner.emoji}</div>
          <div className="banner-text">
            <div className="banner-title">{banner.title}</div>
            <div className="banner-subtitle">{banner.subtitle}</div>
          </div>
        </div>

        <button 
          className="banner-nav next"
          onClick={nextBanner}
          aria-label="Next banner"
        >
          <ChevronRight size={20} />
        </button>

        {/* Banner indicators */}
        <div className="banner-indicators">
          {banners.map((_, index) => (
            <button
              key={index}
              className={`banner-indicator ${index === currentBanner ? 'active' : ''}`}
              onClick={() => setCurrentBanner(index)}
              aria-label={`Go to banner ${index + 1}`}
            />
          ))}
        </div>
      </div>
    </div>
  );
};

export default PromotionalBanner;
