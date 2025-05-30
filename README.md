# nYtevibe - Houston Venue Tracker 🏢🎵

A modern, real-time venue tracking application for Houston's nightlife scene. Built with React 18, Vite, and featuring stunning glassmorphism design.

## 🌟 Features

### 🏢 Houston Venues
- **NYC Vibes** (Lounge) - Lively Hip-Hop atmosphere
- **Rumors** (Nightclub) - Chill R&B vibes  
- **Classic** (Bar & Grill) - Packed sports venue
- **Best Regards** (Cocktail Bar) - Perfect for date nights

### ⚡ Real-Time Features
- 📊 Live crowd level tracking (1-5 scale)
- ⏱️ Real-time wait time updates
- 🎯 Confidence ratings based on user reports
- 📈 Trending indicators (up/down/stable)
- 🔄 Smart controlled updates every 45 seconds
- 👁️ Page visibility detection (pauses when hidden)

### 🎮 User Experience
- 🏆 Points system (earn 5 points per venue report)
- 👤 User levels (Silver Reporter, etc.)
- 📝 Comprehensive venue reporting
- 🗺️ Google Maps integration
- 📱 Mobile-first responsive design

### 🎨 Modern Design
- ✨ Glassmorphism UI with backdrop blur effects
- 🌈 Beautiful gradient backgrounds
- 💫 Smooth animations and transitions
- 🎭 Modern Inter typography
- 📱 Touch-friendly mobile interface

## 🚀 Technology Stack

- **Frontend**: React 18.2.0 + Vite 5.0
- **Icons**: Lucide React 0.263.1
- **Styling**: Modern CSS with glassmorphism
- **Server**: Apache2 with SSL (Let's Encrypt)
- **Domain**: blackaxl.com

## 📱 Live Demo

🌐 **Visit**: [https://blackaxl.com](https://blackaxl.com)

## 🛠️ Installation & Setup

### Prerequisites
- Node.js 18.0.0 or higher
- npm 8.0.0 or higher
- Git

### Quick Start

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/nytevibe-houston-tracker.git
cd nytevibe-houston-tracker

# Install dependencies
npm install

# Start development server
npm run dev

# Build for production
npm run build
```

### 📁 Project Structure

```
nytevibe/
├── src/
│   ├── App.jsx              # Main application component
│   ├── App.css              # Glassmorphism styles
│   ├── index.css            # Global styles
│   └── main.jsx             # Application entry point
├── public/
│   ├── index.html           # HTML template
│   └── vite.svg             # Favicon
├── dist/                    # Production build (generated)
├── package.json             # Dependencies and scripts
├── vite.config.js           # Vite configuration
└── README.md                # This file
```

## 🎯 Key Features

### Real-Time Updates
- Updates every 45 seconds with smart probability (30% chance per venue)
- Pauses updates when browser tab is hidden (battery optimization)
- Manual refresh button for instant updates
- Real-time status indicators

### Venue Tracking
- Live crowd levels (Empty → Packed scale)
- Wait time tracking
- Venue vibes and atmosphere tags
- Confidence ratings based on report volume
- Trending direction indicators

### User Engagement
- Points system: +5 points per venue report
- User levels and gamification
- Community-driven data accuracy
- Comprehensive reporting modal

### Google Maps Integration
- Direct venue location viewing
- Turn-by-turn directions
- Complete address information
- Phone number integration

## 🏗️ Development

### Available Scripts

```bash
# Development
npm run dev              # Start dev server
npm run build           # Production build
npm run preview         # Preview production build

# Code Quality
npm run lint            # ESLint check
npm run lint:fix        # Fix ESLint issues
npm run format          # Prettier formatting
```

### Environment Variables

Create a `.env.local` file for local development:

```env
VITE_APP_NAME=nYtevibe
VITE_APP_VERSION=1.0.0
VITE_DEFAULT_LOCATION=Houston, TX
VITE_UPDATE_INTERVAL=45000
VITE_GOOGLE_MAPS_API_KEY=your_api_key_here
```

## 🚀 Deployment

### Apache Configuration

The project includes comprehensive Apache virtual host configuration with:
- SSL/HTTPS setup with Let's Encrypt
- Modern security headers (HSTS, CSP, etc.)
- GZIP compression
- Static asset caching
- React SPA routing support

### Production Deployment Scripts

```bash
# Deploy with SSL
./ssl_production_fixed.sh

# Setup with controlled updates
./nytevibe_controlled_updates.sh
```

## 🎨 Design System

### Glassmorphism UI
- Transparent glass effects with backdrop blur
- Modern gradient color schemes (purple to blue)
- Subtle shadow systems and depth
- Smooth micro-animations

### CSS Variables
```css
:root {
  --gradient-primary: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  --shadow-card: 0 8px 32px rgba(0, 0, 0, 0.12);
  --radius-xl: 1rem;
  --transition-normal: all 0.3s ease;
}
```

### Typography
- **Primary Font**: Inter (300-900 weights)
- **Features**: Modern OpenType features enabled
- **Accessibility**: High contrast and screen reader optimized

## 📊 Performance Optimizations

- **Smart Updates**: Controlled intervals with probability-based changes
- **Memory Management**: Proper cleanup and useCallback optimization
- **Battery Optimization**: Page visibility API integration
- **Mobile Performance**: Optimized for touch devices
- **Bundle Size**: Code splitting and modern build optimization

## 🔧 Browser Support

- ✅ Chrome 88+
- ✅ Firefox 85+
- ✅ Safari 14+
- ✅ Edge 88+
- ✅ Mobile browsers (iOS Safari, Chrome Mobile)

## 🎯 API Integration (Future)

Ready for backend integration:

```javascript
// API endpoints structure (planned)
GET /api/venues          # Get all venues
POST /api/venues/:id/report  # Submit venue report
GET /api/user/profile    # User profile and points
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines
- Follow React best practices
- Use functional components with hooks
- Maintain TypeScript-ready code structure
- Write semantic HTML with accessibility in mind
- Follow the established CSS naming conventions

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Team

- **Lead Developer**: nYtevibe Team
- **Design**: Modern glassmorphism UI/UX
- **Backend**: Ready for integration

## 🎉 Acknowledgments

- **Houston Venues**: For inspiring this nightlife tracking solution
- **React Community**: For the amazing ecosystem
- **Lucide Icons**: For beautiful, modern icons
- **Vite**: For lightning-fast development experience

## 📞 Support

For support and questions:
- 📧 Email: support@nytevibe.com
- 🌐 Website: [https://blackaxl.com](https://blackaxl.com)
- 📱 Mobile: Optimized for all devices

---

**Made with ❤️ for Houston's nightlife community**

*Experience the vibe, track the crowd, discover Houston! 🌆✨*
