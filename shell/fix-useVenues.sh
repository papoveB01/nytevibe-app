#!/bin/bash

# nYtevibe Targeted .includes() Fix Script
# Fixes all identified .includes() usage with defensive programming

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🎯 nYtevibe Targeted .includes() Fix Script${NC}"
echo -e "${BLUE}===========================================${NC}"
echo ""

# Create timestamp for backups
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

echo -e "${YELLOW}📋 Phase 1: Creating Backups${NC}"
echo "----------------------------------------"

# Create backups
echo "🔄 Creating backups..."
cp src/hooks/useVenues.js "src/hooks/useVenues.js.backup-includes-fix-$TIMESTAMP"
cp src/components/Views/VenueDetailsView.jsx "src/components/Views/VenueDetailsView.jsx.backup-includes-fix-$TIMESTAMP"

echo -e "${GREEN}✅ Backups created with timestamp: $TIMESTAMP${NC}"

echo ""
echo -e "${YELLOW}📋 Phase 2: Fixing useVenues.js (MOST LIKELY CULPRIT)${NC}"
echo "----------------------------------------"

# Fix useVenues.js - This is the most likely source of the error
cat > src/hooks/useVenues.js << 'EOF'
import { useApp } from '../context/AppContext';

export const useVenues = () => {
  const { state, actions } = useApp();
  
  // 🛡️ ULTRA-SAFE: Defensive filtering with comprehensive null checks
  const filteredVenues = (state.venues || []).filter(venue => {
    // Early return if venue is invalid
    if (!venue) return false;
    
    // Get search query safely
    const searchQuery = state.searchQuery || '';
    
    // If no search query, include all venues
    if (!searchQuery) return true;
    
    // Safe search query processing
    const safeSearchQuery = searchQuery.toLowerCase();
    
    // Safe venue name check
    const nameMatch = venue.name && typeof venue.name === 'string' 
      ? venue.name.toLowerCase().includes(safeSearchQuery) 
      : false;
    
    // Safe venue type check  
    const typeMatch = venue.type && typeof venue.type === 'string'
      ? venue.type.toLowerCase().includes(safeSearchQuery)
      : false;
    
    // Safe venue vibe check
    const vibeMatch = Array.isArray(venue.vibe) 
      ? venue.vibe.some(v => v && typeof v === 'string' && v.toLowerCase().includes(safeSearchQuery))
      : false;
    
    return nameMatch || typeMatch || vibeMatch;
  });
  
  // 🛡️ ULTRA-SAFE: Safe venue following check
  const isVenueFollowed = (venueId) => {
    // Comprehensive safety checks
    if (!venueId || !state || !state.userProfile) {
      return false;
    }
    
    // Check if favoriteVenues exists and is an array
    const favoriteVenues = state.userProfile.favoriteVenues;
    if (!Array.isArray(favoriteVenues)) {
      return false;
    }
    
    return favoriteVenues.includes(venueId);
  };
  
  // 🛡️ ULTRA-SAFE: Safe venue lookup
  const getVenueById = (venueId) => {
    if (!venueId || !Array.isArray(state.venues)) {
      return null;
    }
    return state.venues.find(venue => venue && venue.id === venueId) || null;
  };
  
  return {
    venues: filteredVenues,
    allVenues: state.venues || [],
    isVenueFollowed,
    getVenueById,
    toggleFollow: actions ? actions.toggleVenueFollow : () => {},
    updateVenueData: actions ? actions.updateVenueData : () => {}
  };
};
EOF

echo -e "${GREEN}✅ Fixed useVenues.js with ultra-safe defensive programming${NC}"

echo ""
echo -e "${YELLOW}📋 Phase 3: Fixing VenueDetailsView.jsx${NC}"
echo "----------------------------------------"

# Fix VenueDetailsView.jsx - Replace the amenities array with safe checks
python3 << 'PYTHON_EOF'
import re

# Read the current VenueDetailsView.jsx
with open('src/components/Views/VenueDetailsView.jsx', 'r') as f:
    content = f.read()

# Find and replace the amenities array with safe version
amenities_pattern = r'(const amenities = \[[\s\S]*?\];)'

safe_amenities = '''const amenities = [
    { icon: Wifi, label: 'Free WiFi', available: true },
    { icon: Car, label: 'Parking', available: true },
    { icon: CreditCard, label: 'Card Accepted', available: true },
    // 🛡️ ULTRA-SAFE: Safe .includes() calls with null checks
    { icon: Music, label: 'Live Music', available: venue && Array.isArray(venue.vibe) && venue.vibe.includes('Live Music') },
    { icon: Utensils, label: 'Food Menu', available: venue && venue.type && (venue.type.includes('Grill') || venue.type.includes('Restaurant')) },
    { icon: Coffee, label: 'Coffee', available: venue && venue.type && (venue.type.includes('Cafe') || venue.type.includes('Coffee')) },
    { icon: Wine, label: 'Full Bar', available: venue && venue.type && (venue.type.includes('Bar') || venue.type.includes('Lounge')) },
    { icon: ShoppingBag, label: 'VIP Service', available: venue && Array.isArray(venue.vibe) && venue.vibe.includes('VIP') }
  ];'''

# Replace the amenities array
content = re.sub(amenities_pattern, safe_amenities, content, flags=re.MULTILINE | re.DOTALL)

# Write the fixed content
with open('src/components/Views/VenueDetailsView.jsx', 'w') as f:
    f.write(content)

print("✅ Applied safe .includes() checks to VenueDetailsView.jsx")
PYTHON_EOF

echo -e "${GREEN}✅ Fixed VenueDetailsView.jsx with safe venue property checks${NC}"

echo ""
echo -e "${YELLOW}📋 Phase 4: Validation${NC}"
echo "----------------------------------------"

# Validate the fixed files
echo "🔍 Validating fixed files..."

# Check useVenues.js syntax
if node -c src/hooks/useVenues.js 2>/dev/null; then
    echo -e "${GREEN}✅ useVenues.js syntax validation passed${NC}"
else
    echo -e "${RED}❌ useVenues.js syntax validation failed${NC}"
    echo "Restoring backup..."
    cp "src/hooks/useVenues.js.backup-includes-fix-$TIMESTAMP" src/hooks/useVenues.js
    exit 1
fi

# Check VenueDetailsView.jsx syntax
if node -c src/components/Views/VenueDetailsView.jsx 2>/dev/null; then
    echo -e "${GREEN}✅ VenueDetailsView.jsx syntax validation passed${NC}"
else
    echo -e "${RED}❌ VenueDetailsView.jsx syntax validation failed${NC}"
    echo "Restoring backup..."
    cp "src/components/Views/VenueDetailsView.jsx.backup-includes-fix-$TIMESTAMP" src/components/Views/VenueDetailsView.jsx
    exit 1
fi

echo ""
echo -e "${YELLOW}📋 Phase 5: Applied Fixes Summary${NC}"
echo "----------------------------------------"

echo "🛡️ useVenues.js Fixes:"
echo "  ✅ Safe search query handling (fallback to empty string)"
echo "  ✅ Safe venue property checks (name, type, vibe)"
echo "  ✅ Safe array validation before .includes() calls"
echo "  ✅ Safe userProfile.favoriteVenues access"
echo "  ✅ Comprehensive null checking throughout"
echo ""
echo "🛡️ VenueDetailsView.jsx Fixes:"
echo "  ✅ Safe venue object validation"
echo "  ✅ Safe venue.vibe array checking before .includes()"
echo "  ✅ Safe venue.type string checking before .includes()"
echo "  ✅ Comprehensive null checking for venue properties"

echo ""
echo -e "${YELLOW}📋 Phase 6: Testing Instructions${NC}"
echo "----------------------------------------"

echo "🧪 Critical Test Sequence:"
echo ""
echo "1. Start development server:"
echo "   npm run dev"
echo ""
echo "2. Test login flow:"
echo "   - Navigate to login page"
echo "   - Attempt login with credentials"
echo "   - ✅ Should redirect to HomeView WITHOUT white screen"
echo "   - ✅ Should see venues list"
echo ""
echo "3. Test venue details:"
echo "   - Click on a venue to view details"
echo "   - ✅ Should load venue details without errors"
echo ""
echo "4. Monitor browser console:"
echo "   - ✅ Should see no undefined.includes() errors"
echo "   - ✅ Should see no JavaScript errors"

echo ""
echo -e "${YELLOW}📋 Phase 7: Rollback Instructions${NC}"
echo "----------------------------------------"

echo "🔄 If issues occur, rollback with:"
echo "   cp src/hooks/useVenues.js.backup-includes-fix-$TIMESTAMP src/hooks/useVenues.js"
echo "   cp src/components/Views/VenueDetailsView.jsx.backup-includes-fix-$TIMESTAMP src/components/Views/VenueDetailsView.jsx"

echo ""
echo -e "${GREEN}✅ Targeted .includes() Fix Complete!${NC}"
echo -e "${GREEN}====================================${NC}"
echo ""
echo -e "${BLUE}🎯 What Was Fixed:${NC}"
echo "   🛡️ useVenues.js: Safe venue filtering and search"
echo "   🛡️ VenueDetailsView.jsx: Safe venue property checking"
echo "   🛡️ All .includes() calls now have proper validation"
echo ""
echo -e "${BLUE}🚀 Expected Result:${NC}"
echo "   ✅ Login should work without white screen"
echo "   ✅ HomeView should load and show venues"
echo "   ✅ Search functionality should work safely"
echo "   ✅ Venue details should load without errors"
echo ""
echo -e "${YELLOW}⚡ Test your login flow now - this should resolve the undefined.includes() error!${NC}"
echo ""
echo "Status: 🟢 ALL .includes() USAGE SECURED WITH DEFENSIVE PROGRAMMING"
