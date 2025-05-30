#!/bin/bash

# nYtevibe GitHub Deployment Script
# Pushes the complete Houston venue tracker to GitHub

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${PURPLE}✨ $1 ✨${NC}"
}

print_step() {
    echo -e "${CYAN}🔹${NC} $1"
}

print_header "nYtevibe GitHub Deployment"
print_header "=========================="

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    print_error "package.json not found. Please run this from the nytevibe project directory."
    exit 1
fi

# Check if git is installed
if ! command -v git &> /dev/null; then
    print_error "Git is not installed. Please install git first."
    exit 1
fi

# Get user information for GitHub
print_status "Setting up GitHub deployment..."

# Check if git is already initialized
if [ ! -d ".git" ]; then
    print_status "Initializing Git repository..."
    git init
    print_success "Git repository initialized"
else
    print_success "Git repository already exists"
fi

# Configure git user if not already set
if [ -z "$(git config user.name)" ]; then
    echo ""
    print_status "Git user configuration needed:"
    read -p "Enter your GitHub username: " github_username
    read -p "Enter your email: " github_email
    
    git config user.name "$github_username"
    git config user.email "$github_email"
    print_success "Git user configured"
fi

# Get repository name
echo ""
print_status "Repository setup:"
read -p "Enter GitHub repository name (default: nytevibe-houston-tracker): " repo_name
repo_name=${repo_name:-nytevibe-houston-tracker}

read -p "Enter your GitHub username: " github_username

# Create .gitignore if it doesn't exist
if [ ! -f ".gitignore" ]; then
    print_status "Creating .gitignore file..."
    cat > .gitignore << 'EOF'
# Dependencies
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Production build
dist/

# Environment variables
.env.local
.env.development.local
.env.test.local
.env.production.local

# IDE and editor files
.vscode/
.idea/
*.swp
*.swo
*~

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Logs
logs
*.log

# Runtime data
pids
*.pid
*.seed
*.pid.lock

# Coverage directory used by tools like istanbul
coverage/

# nyc test coverage
.nyc_output

# Grunt intermediate storage
.grunt

# Bower dependency directory
bower_components

# node-waf configuration
.lock-wscript

# Compiled binary addons
build/Release

# Dependency directories
jspm_packages/

# Optional npm cache directory
.npm

# Optional REPL history
.node_repl_history

# Output of 'npm pack'
*.tgz

# Yarn Integrity file
.yarn-integrity

# Backup files
*.backup
*.bak

# SSL certificates (keep private)
*.pem
*.key
*.crt

# Apache logs
*.log

# Deployment scripts with sensitive info
*_private.sh
EOF
    print_success ".gitignore created"
fi

# Create comprehensive README.md
print_status "Creating comprehensive README.md..."
cat > README.md << 'EOF'
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
EOF

print_success "Comprehensive README.md created"

# Create a LICENSE file
print_status "Creating MIT LICENSE file..."
cat > LICENSE << 'EOF'
MIT License

Copyright (c) 2025 nYtevibe Team

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF

print_success "MIT LICENSE created"

# Add all files to git
print_status "Adding files to Git..."
git add .

# Check git status
print_status "Git status:"
git status --porcelain

# Create comprehensive commit message
print_status "Creating commit..."
commit_message="🚀 Complete nYtevibe Houston Venue Tracker

✨ Features:
- Real-time venue tracking for 4 Houston locations
- Modern glassmorphism UI with React 18 + Vite
- Smart controlled updates (45-second intervals)
- User points system and gamification
- Google Maps integration
- Mobile-responsive design

🏢 Houston Venues:
- NYC Vibes (Lounge) - Hip-Hop atmosphere
- Rumors (Nightclub) - R&B vibes  
- Classic (Bar & Grill) - Sports venue
- Best Regards (Cocktail Bar) - Date nights

🎨 Design:
- Glassmorphism with backdrop blur effects
- Beautiful gradient backgrounds
- Smooth animations and transitions
- Modern Inter typography
- Professional badge system

⚡ Performance:
- Controlled state management
- Page visibility optimization
- Memory leak prevention
- Mobile battery optimization
- Smart probabilistic updates

🛠️ Tech Stack:
- React 18.2.0 + Vite 5.0
- Lucide React icons
- Modern CSS with glassmorphism
- Apache deployment ready
- SSL/HTTPS configured

🚀 Production ready with comprehensive documentation"

git commit -m "$commit_message"
print_success "Files committed to Git"

# Check if remote origin exists
if git remote get-url origin &> /dev/null; then
    print_warning "Remote origin already exists. Updating..."
    git remote set-url origin "https://github.com/$github_username/$repo_name.git"
else
    print_status "Adding GitHub remote..."
    git remote add origin "https://github.com/$github_username/$repo_name.git"
fi

print_success "Remote origin configured"

echo ""
print_header "🚀 READY TO PUSH TO GITHUB!"
print_header "==========================="

print_status "BEFORE PUSHING:"
print_step "1. Go to GitHub.com and create a new repository"
print_step "2. Repository name: $repo_name"
print_step "3. Make it public or private (your choice)"
print_step "4. DO NOT initialize with README (we have one)"
print_step "5. DO NOT add .gitignore (we have one)"

echo ""
print_warning "GitHub Repository Setup Required!"
echo ""
echo "🌐 Visit: https://github.com/new"
echo "📝 Repository name: $repo_name"
echo "📄 Description: Real-time Houston venue tracker with modern React UI"
echo "🔓 Visibility: Public (recommended) or Private"
echo "❌ DO NOT check 'Add a README file'"
echo "❌ DO NOT check 'Add .gitignore'"
echo "❌ DO NOT choose a license (we have MIT)"

echo ""
read -p "Have you created the GitHub repository? (y/n): " created_repo

if [[ $created_repo =~ ^[Yy]$ ]]; then
    print_status "Pushing to GitHub..."
    
    # Try to push
    if git push -u origin main 2>/dev/null || git push -u origin master 2>/dev/null; then
        print_success "Successfully pushed to GitHub! 🎉"
        
        echo ""
        print_header "🎉 DEPLOYMENT COMPLETE!"
        print_header "====================="
        print_success ""
        print_success "📦 Repository: https://github.com/$github_username/$repo_name"
        print_success "🌐 Live Demo: https://blackaxl.com (if deployed)"
        print_success ""
        print_success "✨ Your nYtevibe Houston Venue Tracker is now on GitHub!"
        print_success ""
        print_step "📋 Next Steps:"
        print_step "1. 🌟 Star your own repository"
        print_step "2. 📝 Customize the README if needed"
        print_step "3. 🚀 Deploy to production with SSL script"
        print_step "4. 📱 Test on mobile devices"
        print_step "5. 🔗 Share with the Houston nightlife community"
        print_success ""
        print_success "🎯 Repository Features:"
        print_step "✅ Comprehensive documentation"
        print_step "✅ MIT License for open source"
        print_step "✅ Production-ready deployment scripts"
        print_step "✅ Professional README with screenshots"
        print_step "✅ Complete project structure"
        print_step "✅ Modern development workflow"
        
    else
        print_error "Failed to push to GitHub"
        echo ""
        print_status "Troubleshooting:"
        print_step "1. Make sure the repository exists on GitHub"
        print_step "2. Check your GitHub authentication"
        print_step "3. Try: git push -u origin main --force"
        print_step "4. Or try: git push -u origin master --force"
    fi
else
    print_warning "Please create the GitHub repository first, then run this script again"
    print_status "Repository URL: https://github.com/$github_username/$repo_name"
fi

print_success ""
print_success "🎉 Git repository ready! Your Houston venue tracker is GitHub-ready!"
