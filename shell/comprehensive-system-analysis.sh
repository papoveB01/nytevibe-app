#!/bin/bash

# React App Structure Analyzer
# Generates a comprehensive report of your React application
# Usage: ./analyze_react_app.sh [path_to_react_app]

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Default to current directory if no path provided
APP_PATH=${1:-.}
REPORT_FILE="react_app_analysis_report.md"

# Check if the directory exists
if [ ! -d "$APP_PATH" ]; then
    echo -e "${RED}Error: Directory '$APP_PATH' does not exist${NC}"
    exit 1
fi

cd "$APP_PATH"

echo -e "${BLUE}🔍 Analyzing React App Structure...${NC}"
echo -e "${BLUE}📊 Generating report: $REPORT_FILE${NC}"

# Start report
cat > "$REPORT_FILE" << 'EOF'
# React Application Analysis Report

Generated on: 
EOF

echo "$(date)" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Function to add section header
add_section() {
    echo -e "\n## $1\n" >> "$REPORT_FILE"
}

# Function to add subsection
add_subsection() {
    echo -e "\n### $1\n" >> "$REPORT_FILE"
}

# Function to count files
count_files() {
    find . -name "$1" 2>/dev/null | wc -l
}

# Function to analyze package.json
analyze_package_json() {
    add_section "📦 Project Configuration"
    
    if [ -f "package.json" ]; then
        echo "**Package.json found ✅**" >> "$REPORT_FILE"
        echo "" >> "$REPORT_FILE"
        
        # Extract project name and version
        if command -v jq &> /dev/null; then
            PROJECT_NAME=$(jq -r '.name // "Not specified"' package.json)
            VERSION=$(jq -r '.version // "Not specified"' package.json)
            echo "- **Project Name:** $PROJECT_NAME" >> "$REPORT_FILE"
            echo "- **Version:** $VERSION" >> "$REPORT_FILE"
            echo "" >> "$REPORT_FILE"
            
            # Dependencies analysis
            add_subsection "Dependencies"
            echo "\`\`\`json" >> "$REPORT_FILE"
            jq '.dependencies // {}' package.json >> "$REPORT_FILE"
            echo "\`\`\`" >> "$REPORT_FILE"
            echo "" >> "$REPORT_FILE"
            
            # Dev Dependencies
            add_subsection "Development Dependencies"
            echo "\`\`\`json" >> "$REPORT_FILE"
            jq '.devDependencies // {}' package.json >> "$REPORT_FILE"
            echo "\`\`\`" >> "$REPORT_FILE"
            echo "" >> "$REPORT_FILE"
            
            # Scripts
            add_subsection "Available Scripts"
            echo "\`\`\`json" >> "$REPORT_FILE"
            jq '.scripts // {}' package.json >> "$REPORT_FILE"
            echo "\`\`\`" >> "$REPORT_FILE"
        else
            echo "- **Note:** Install 'jq' for detailed package.json analysis" >> "$REPORT_FILE"
        fi
    else
        echo "**⚠️ No package.json found - This might not be a React project root**" >> "$REPORT_FILE"
    fi
    echo "" >> "$REPORT_FILE"
}

# Function to analyze directory structure
analyze_structure() {
    add_section "📁 Directory Structure"
    
    echo "\`\`\`" >> "$REPORT_FILE"
    tree -I 'node_modules|.git|build|dist|coverage' -L 3 2>/dev/null || {
        echo "Directory structure (tree command not available):" >> "$REPORT_FILE"
        find . -type d -not -path "./node_modules*" -not -path "./.git*" -not -path "./build*" -not -path "./dist*" | head -20 >> "$REPORT_FILE"
    }
    echo "\`\`\`" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
}

# Function to analyze React components
analyze_components() {
    add_section "⚛️ React Components Analysis"
    
    # Count different file types
    JSX_COUNT=$(count_files "*.jsx")
    JS_COUNT=$(count_files "*.js")
    TS_COUNT=$(count_files "*.ts")
    TSX_COUNT=$(count_files "*.tsx")
    
    echo "- **JSX Components:** $JSX_COUNT" >> "$REPORT_FILE"
    echo "- **JS Files:** $JS_COUNT" >> "$REPORT_FILE"
    echo "- **TypeScript Files:** $TS_COUNT" >> "$REPORT_FILE"
    echo "- **TSX Components:** $TSX_COUNT" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    
    # List all React components
    add_subsection "Component Files Found"
    echo "\`\`\`" >> "$REPORT_FILE"
    find . -name "*.jsx" -o -name "*.tsx" | grep -v node_modules | sort >> "$REPORT_FILE"
    echo "\`\`\`" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    
    # Analyze component patterns
    add_subsection "Component Patterns Analysis"
    
    # Check for functional vs class components
    FUNCTIONAL_COMPONENTS=$(find . -name "*.jsx" -o -name "*.tsx" | xargs grep -l "const.*=.*(" 2>/dev/null | wc -l)
    CLASS_COMPONENTS=$(find . -name "*.jsx" -o -name "*.tsx" | xargs grep -l "class.*extends.*Component" 2>/dev/null | wc -l)
    HOOKS_USAGE=$(find . -name "*.jsx" -o -name "*.tsx" | xargs grep -l "useState\|useEffect\|useContext" 2>/dev/null | wc -l)
    
    echo "- **Functional Components (estimated):** $FUNCTIONAL_COMPONENTS" >> "$REPORT_FILE"
    echo "- **Class Components:** $CLASS_COMPONENTS" >> "$REPORT_FILE"
    echo "- **Files using React Hooks:** $HOOKS_USAGE" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
}

# Function to analyze styling approach
analyze_styling() {
    add_section "🎨 Styling Analysis"
    
    CSS_COUNT=$(count_files "*.css")
    SCSS_COUNT=$(count_files "*.scss")
    SASS_COUNT=$(count_files "*.sass")
    LESS_COUNT=$(count_files "*.less")
    
    echo "- **CSS Files:** $CSS_COUNT" >> "$REPORT_FILE"
    echo "- **SCSS Files:** $SCSS_COUNT" >> "$REPORT_FILE"
    echo "- **SASS Files:** $SASS_COUNT" >> "$REPORT_FILE"
    echo "- **LESS Files:** $LESS_COUNT" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    
    # Check for CSS-in-JS libraries
    add_subsection "CSS-in-JS Detection"
    if [ -f "package.json" ]; then
        if grep -q "styled-components" package.json; then
            echo "- **Styled Components:** ✅ Found" >> "$REPORT_FILE"
        fi
        if grep -q "emotion" package.json; then
            echo "- **Emotion:** ✅ Found" >> "$REPORT_FILE"
        fi
        if grep -q "material-ui\|@mui" package.json; then
            echo "- **Material-UI:** ✅ Found" >> "$REPORT_FILE"
        fi
        if grep -q "antd" package.json; then
            echo "- **Ant Design:** ✅ Found" >> "$REPORT_FILE"
        fi
        if grep -q "tailwindcss" package.json; then
            echo "- **Tailwind CSS:** ✅ Found" >> "$REPORT_FILE"
        fi
    fi
    echo "" >> "$REPORT_FILE"
}

# Function to analyze routing
analyze_routing() {
    add_section "🗺️ Routing Analysis"
    
    if [ -f "package.json" ] && grep -q "react-router" package.json; then
        echo "- **React Router:** ✅ Found in dependencies" >> "$REPORT_FILE"
        
        # Look for route definitions
        ROUTE_FILES=$(find . -name "*.jsx" -o -name "*.tsx" -o -name "*.js" -o -name "*.ts" | xargs grep -l "Route\|BrowserRouter\|HashRouter" 2>/dev/null)
        if [ ! -z "$ROUTE_FILES" ]; then
            add_subsection "Files with Routing Configuration"
            echo "\`\`\`" >> "$REPORT_FILE"
            echo "$ROUTE_FILES" >> "$REPORT_FILE"
            echo "\`\`\`" >> "$REPORT_FILE"
        fi
    else
        echo "- **React Router:** ❌ Not found" >> "$REPORT_FILE"
    fi
    echo "" >> "$REPORT_FILE"
}

# Function to analyze state management
analyze_state_management() {
    add_section "🔄 State Management Analysis"
    
    if [ -f "package.json" ]; then
        if grep -q "redux" package.json; then
            echo "- **Redux:** ✅ Found" >> "$REPORT_FILE"
        fi
        if grep -q "zustand" package.json; then
            echo "- **Zustand:** ✅ Found" >> "$REPORT_FILE"
        fi
        if grep -q "mobx" package.json; then
            echo "- **MobX:** ✅ Found" >> "$REPORT_FILE"
        fi
        if grep -q "recoil" package.json; then
            echo "- **Recoil:** ✅ Found" >> "$REPORT_FILE"
        fi
        
        # Check for Context API usage
        CONTEXT_USAGE=$(find . -name "*.jsx" -o -name "*.tsx" | xargs grep -l "createContext\|useContext" 2>/dev/null | wc -l)
        echo "- **Files using Context API:** $CONTEXT_USAGE" >> "$REPORT_FILE"
    fi
    echo "" >> "$REPORT_FILE"
}

# Function to analyze testing setup
analyze_testing() {
    add_section "🧪 Testing Analysis"
    
    TEST_FILES=$(find . -name "*.test.js" -o -name "*.test.jsx" -o -name "*.test.ts" -o -name "*.test.tsx" -o -name "*.spec.js" -o -name "*.spec.jsx" -o -name "*.spec.ts" -o -name "*.spec.tsx" | wc -l)
    echo "- **Test Files Found:** $TEST_FILES" >> "$REPORT_FILE"
    
    if [ -f "package.json" ]; then
        if grep -q "jest" package.json; then
            echo "- **Jest:** ✅ Found" >> "$REPORT_FILE"
        fi
        if grep -q "testing-library" package.json; then
            echo "- **React Testing Library:** ✅ Found" >> "$REPORT_FILE"
        fi
        if grep -q "enzyme" package.json; then
            echo "- **Enzyme:** ✅ Found" >> "$REPORT_FILE"
        fi
        if grep -q "cypress" package.json; then
            echo "- **Cypress:** ✅ Found" >> "$REPORT_FILE"
        fi
    fi
    
    if [ $TEST_FILES -gt 0 ]; then
        add_subsection "Test Files"
        echo "\`\`\`" >> "$REPORT_FILE"
        find . -name "*.test.*" -o -name "*.spec.*" | grep -v node_modules >> "$REPORT_FILE"
        echo "\`\`\`" >> "$REPORT_FILE"
    fi
    echo "" >> "$REPORT_FILE"
}

# Function to analyze build and config files
analyze_build_config() {
    add_section "⚙️ Build & Configuration Analysis"
    
    echo "**Configuration Files Found:**" >> "$REPORT_FILE"
    
    # Check for various config files
    [ -f "webpack.config.js" ] && echo "- ✅ webpack.config.js" >> "$REPORT_FILE"
    [ -f "vite.config.js" ] && echo "- ✅ vite.config.js" >> "$REPORT_FILE"
    [ -f "vite.config.ts" ] && echo "- ✅ vite.config.ts" >> "$REPORT_FILE"
    [ -f ".env" ] && echo "- ✅ .env" >> "$REPORT_FILE"
    [ -f ".env.local" ] && echo "- ✅ .env.local" >> "$REPORT_FILE"
    [ -f "tsconfig.json" ] && echo "- ✅ tsconfig.json (TypeScript)" >> "$REPORT_FILE"
    [ -f ".eslintrc.js" ] || [ -f ".eslintrc.json" ] && echo "- ✅ ESLint configuration" >> "$REPORT_FILE"
    [ -f ".prettierrc" ] || [ -f "prettier.config.js" ] && echo "- ✅ Prettier configuration" >> "$REPORT_FILE"
    [ -f "tailwind.config.js" ] && echo "- ✅ Tailwind CSS configuration" >> "$REPORT_FILE"
    
    echo "" >> "$REPORT_FILE"
}

# Function to analyze code quality metrics
analyze_code_quality() {
    add_section "📊 Code Quality Metrics"
    
    # Line count analysis
    TOTAL_LINES=$(find . -name "*.js" -o -name "*.jsx" -o -name "*.ts" -o -name "*.tsx" | xargs wc -l 2>/dev/null | tail -1 | awk '{print $1}')
    
    echo "- **Total Lines of Code:** $TOTAL_LINES" >> "$REPORT_FILE"
    
    # TODO comments
    TODO_COUNT=$(find . -name "*.js" -o -name "*.jsx" -o -name "*.ts" -o -name "*.tsx" | xargs grep -i "todo\|fixme\|hack" 2>/dev/null | wc -l)
    echo "- **TODO/FIXME Comments:** $TODO_COUNT" >> "$REPORT_FILE"
    
    # Console.log statements (potential debug code)
    CONSOLE_COUNT=$(find . -name "*.js" -o -name "*.jsx" -o -name "*.ts" -o -name "*.tsx" | xargs grep "console\." 2>/dev/null | wc -l)
    echo "- **Console Statements:** $CONSOLE_COUNT" >> "$REPORT_FILE"
    
    echo "" >> "$REPORT_FILE"
}

# Function to provide recommendations
provide_recommendations() {
    add_section "💡 Development Recommendations"
    
    echo "Based on the analysis, here are some recommendations:" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    
    # TypeScript recommendation
    if [ $TS_COUNT -eq 0 ] && [ $TSX_COUNT -eq 0 ]; then
        echo "- **Consider TypeScript:** No TypeScript files detected. TypeScript can improve code quality and developer experience." >> "$REPORT_FILE"
    fi
    
    # Testing recommendation
    if [ $TEST_FILES -eq 0 ]; then
        echo "- **Add Testing:** No test files found. Consider adding unit tests with Jest and React Testing Library." >> "$REPORT_FILE"
    fi
    
    # Code quality tools
    if [ ! -f ".eslintrc.js" ] && [ ! -f ".eslintrc.json" ]; then
        echo "- **ESLint Setup:** Consider adding ESLint for code quality and consistency." >> "$REPORT_FILE"
    fi
    
    if [ ! -f ".prettierrc" ] && [ ! -f "prettier.config.js" ]; then
        echo "- **Prettier Setup:** Consider adding Prettier for code formatting." >> "$REPORT_FILE"
    fi
    
    # Performance considerations
    echo "- **Performance:** Consider implementing React.memo, useMemo, and useCallback for optimization." >> "$REPORT_FILE"
    echo "- **Bundle Analysis:** Use tools like webpack-bundle-analyzer to optimize bundle size." >> "$REPORT_FILE"
    echo "- **Component Organization:** Ensure components follow single responsibility principle." >> "$REPORT_FILE"
    
    echo "" >> "$REPORT_FILE"
}

# Function to analyze specific patterns
analyze_patterns() {
    add_section "🔍 Code Patterns Analysis"
    
    # Custom hooks
    CUSTOM_HOOKS=$(find . -name "*.js" -o -name "*.jsx" -o -name "*.ts" -o -name "*.tsx" | xargs grep -l "const use[A-Z]" 2>/dev/null | wc -l)
    echo "- **Custom Hooks:** $CUSTOM_HOOKS files contain custom hooks" >> "$REPORT_FILE"
    
    # Higher-Order Components
    HOC_USAGE=$(find . -name "*.js" -o -name "*.jsx" -o -name "*.ts" -o -name "*.tsx" | xargs grep -l "withComponent\|withRouter\|with[A-Z]" 2>/dev/null | wc -l)
    echo "- **HOC Pattern:** $HOC_USAGE files potentially using Higher-Order Components" >> "$REPORT_FILE"
    
    # PropTypes usage (for JavaScript projects)
    PROPTYPES_USAGE=$(find . -name "*.js" -o -name "*.jsx" | xargs grep -l "PropTypes" 2>/dev/null | wc -l)
    echo "- **PropTypes Usage:** $PROPTYPES_USAGE files using PropTypes" >> "$REPORT_FILE"
    
    echo "" >> "$REPORT_FILE"
}

# Main execution
echo -e "${YELLOW}Starting React App Analysis...${NC}"

analyze_package_json
echo -e "${GREEN}✓ Package analysis complete${NC}"

analyze_structure
echo -e "${GREEN}✓ Structure analysis complete${NC}"

analyze_components
echo -e "${GREEN}✓ Component analysis complete${NC}"

analyze_styling
echo -e "${GREEN}✓ Styling analysis complete${NC}"

analyze_routing
echo -e "${GREEN}✓ Routing analysis complete${NC}"

analyze_state_management
echo -e "${GREEN}✓ State management analysis complete${NC}"

analyze_testing
echo -e "${GREEN}✓ Testing analysis complete${NC}"

analyze_build_config
echo -e "${GREEN}✓ Build configuration analysis complete${NC}"

analyze_code_quality
echo -e "${GREEN}✓ Code quality analysis complete${NC}"

analyze_patterns
echo -e "${GREEN}✓ Pattern analysis complete${NC}"

provide_recommendations
echo -e "${GREEN}✓ Recommendations generated${NC}"

# Add footer
echo "" >> "$REPORT_FILE"
echo "---" >> "$REPORT_FILE"
echo "*Report generated by React App Analyzer*" >> "$REPORT_FILE"
echo "*Analysis completed on $(date)*" >> "$REPORT_FILE"

echo -e "${BLUE}📋 Analysis complete! Report saved to: ${CYAN}$REPORT_FILE${NC}"
echo -e "${YELLOW}💡 Use this report to get assistance with your React development!${NC}"

# Optional: Open the report if on macOS
if [[ "$OSTYPE" == "darwin"* ]]; then
    read -p "Do you want to open the report? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        open "$REPORT_FILE"
    fi
fi
