#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

console.log('🔍 Verifying nYtevibe Modular Implementation...\n');

const requiredFiles = [
  'src/constants/index.js',
  'src/utils/helpers.js',
  'src/context/AppContext.jsx',
  'src/hooks/useVenues.js',
  'src/hooks/useNotifications.js',
  'src/hooks/useSearch.js',
  'src/components/UI/Button.jsx',
  'src/components/UI/Modal.jsx',
  'src/components/UI/Badge.jsx',
  'src/components/Follow/FollowButton.jsx',
  'src/components/Follow/FollowStats.jsx',
  'src/components/Venue/VenueCard.jsx',
  'src/components/Venue/StarRating.jsx',
  'src/components/Layout/SearchBar.jsx',
  'src/components/Layout/PromotionalBanner.jsx',
  'src/components/User/UserProfile.jsx',
  'src/components/Views/HomeView.jsx',
  'src/components/Views/VenueDetailsView.jsx',
  'src/App.jsx'
];

let missingFiles = [];
let existingFiles = [];

requiredFiles.forEach(file => {
  if (fs.existsSync(file)) {
    existingFiles.push(file);
    console.log(`✅ ${file}`);
  } else {
    missingFiles.push(file);
    console.log(`❌ ${file} - MISSING`);
  }
});

console.log(`\n📊 Implementation Status:`);
console.log(`✅ Created: ${existingFiles.length}/${requiredFiles.length} files`);
console.log(`❌ Missing: ${missingFiles.length} files`);

if (missingFiles.length === 0) {
  console.log('\n🎉 All files created successfully!');
  console.log('\n🚀 Next steps:');
  console.log('   1. Run: npm install');
  console.log('   2. Run: npm run dev');
  console.log('   3. Test all functionality');
  console.log('   4. Build for production: npm run build');
} else {
  console.log('\n⚠️  Some files are missing. Please check the implementation.');
  console.log('\nMissing files:');
  missingFiles.forEach(file => console.log(`   - ${file}`));
}

console.log('\n📚 Documentation created:');
console.log('   - DEVELOPMENT.md - Development guide');
console.log('   - create-component.js - Component generator');
console.log('   - verify-implementation.js - This verification script');
