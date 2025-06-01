#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

const componentName = process.argv[2];
const componentPath = process.argv[3] || 'UI';

if (!componentName) {
  console.log('Usage: node create-component.js <ComponentName> [path]');
  console.log('Example: node create-component.js Button UI');
  process.exit(1);
}

const componentDir = path.join('src', 'components', componentPath);
const componentFile = path.join(componentDir, `${componentName}.jsx`);

// Create directory if it doesn't exist
if (!fs.existsSync(componentDir)) {
  fs.mkdirSync(componentDir, { recursive: true });
}

// Component template
const template = `import React from 'react';

const ${componentName} = ({ children, className = '', ...props }) => {
  return (
    <div className={\`${componentName.toLowerCase()} \${className}\`} {...props}>
      {children}
    </div>
  );
};

export default ${componentName};
`;

// Write component file
fs.writeFileSync(componentFile, template);

console.log(`✅ Component created: ${componentFile}`);
console.log(`📝 Don't forget to:`);
console.log(`   1. Add CSS styles for .${componentName.toLowerCase()}`);
console.log(`   2. Export from index.js if needed`);
console.log(`   3. Add to Storybook if using`);
