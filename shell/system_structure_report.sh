#!/bin/bash

# React Source Code & App Structure Analyzer
# Focuses only on application source code, components, and structure

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
REPORT_FILE="react_source_analysis.md"
PROJECT_DIR="${1:-.}"
MAX_FILE_SIZE=100000  # 100KB limit for source files

# Parse command line options
while [[ $# -gt 0 ]]; do
    case $1 in
        --output)
            REPORT_FILE="$2"
            shift 2
            ;;
        --max-size)
            MAX_FILE_SIZE="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [PROJECT_DIR] [OPTIONS]"
            echo "Options:"
            echo "  --output FILE      Output file name (default: react_source_analysis.md)"
            echo "  --max-size SIZE    Maximum file size to include (default: 100000)"
            echo "  -h, --help         Show this help"
            exit 0
            ;;
        *)
            if [ -z "$PROJECT_DIR" ] || [ "$PROJECT_DIR" = "." ]; then
                PROJECT_DIR="$1"
            fi
            shift
            ;;
    esac
done

echo -e "${BLUE}🔍 Starting React Source Code Analysis...${NC}"
echo -e "${BLUE}📁 Analyzing directory: ${PROJECT_DIR}${NC}"
echo -e "${BLUE}📄 Report will be saved to: ${REPORT_FILE}${NC}"

# Check if we're in a React project
if [ ! -f "${PROJECT_DIR}/package.json" ]; then
    echo -e "${RED}❌ Error: package.json not found. Are you in a React project directory?${NC}"
    exit 1
fi

# Function to check file size
check_file_size() {
    local file="$1"
    local size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null || echo "0")
    echo "$size"
}

# Function to safely display file content
display_file_content() {
    local file="$1"
    local title="$2"
    local size=$(check_file_size "$file")
    local relative_path="${file#$PROJECT_DIR/}"
    
    if [ ! -f "$file" ]; then
        return 1
    fi
    
    echo "### $title"
    echo
    echo "**Path:** \`$relative_path\`"
    echo "**Size:** $size bytes"
    echo
    
    if [ "$size" -gt "$MAX_FILE_SIZE" ]; then
        echo "⚠️ **Large file detected. Showing first 100 lines:**"
        echo '```'
        head -100 "$file"
        echo '```'
        echo
        echo "*File truncated due to size. Full file has $(wc -l < "$file") lines.*"
    else
        # Detect file type for syntax highlighting
        case "${file##*.}" in
            js|jsx)
                echo '```javascript'
                ;;
            ts|tsx)
                echo '```typescript'
                ;;
            css)
                echo '```css'
                ;;
            scss|sass)
                echo '```scss'
                ;;
            json)
                echo '```json'
                ;;
            *)
                echo '```'
                ;;
        esac
        cat "$file"
        echo '```'
    fi
    echo
    echo "---"
    echo
}

# Function to analyze component structure
analyze_component_structure() {
    local file="$1"
    local component_name=$(basename "$file" | sed 's/\.[^.]*$//')
    
    echo "#### Component Analysis: $component_name"
    echo
    
    # Check for hooks usage
    local hooks_used=()
    if grep -q "useState" "$file"; then hooks_used+=("useState"); fi
    if grep -q "useEffect" "$file"; then hooks_used+=("useEffect"); fi
    if grep -q "useContext" "$file"; then hooks_used+=("useContext"); fi
    if grep -q "useReducer" "$file"; then hooks_used+=("useReducer"); fi
    if grep -q "useMemo" "$file"; then hooks_used+=("useMemo"); fi
    if grep -q "useCallback" "$file"; then hooks_used+=("useCallback"); fi
    if grep -q "useRef" "$file"; then hooks_used+=("useRef"); fi
    if grep -q "use[A-Z]" "$file"; then 
        custom_hooks=$(grep -o "use[A-Z][a-zA-Z]*" "$file" | sort -u | grep -v -E "useState|useEffect|useContext|useReducer|useMemo|useCallback|useRef")
        if [ -n "$custom_hooks" ]; then
            hooks_used+=($custom_hooks)
        fi
    fi
    
    if [ ${#hooks_used[@]} -gt 0 ]; then
        echo "**Hooks Used:** ${hooks_used[*]}"
    else
        echo "**Hooks Used:** None detected"
    fi
    
    # Check for props
    if grep -q "props\." "$file" || grep -q "({.*})" "$file"; then
        echo "**Props:** Uses props"
    else
        echo "**Props:** No props detected"
    fi
    
    # Check for state management
    if grep -q "dispatch\|store\|selector" "$file"; then
        echo "**State Management:** External state detected"
    elif [ ${#hooks_used[@]} -gt 0 ]; then
        echo "**State Management:** Local state with hooks"
    else
        echo "**State Management:** Stateless component"
    fi
    
    # Check imports
    local imports=$(grep "^import" "$file" | head -5)
    if [ -n "$imports" ]; then
        echo
        echo "**Key Imports:**"
        echo '```javascript'
        echo "$imports"
        echo '```'
    fi
    
    echo
}

# Create comprehensive report
cat > "$REPORT_FILE" << EOF
# React Application Source Code Analysis

**Generated on:** $(date)  
**Project Directory:** \`$PROJECT_DIR\`  
**Focus:** Application source code and structure only  

## Table of Contents
1. [Application Structure Overview](#application-structure-overview)
2. [Main Entry Points](#main-entry-points)
3. [React Components](#react-components)
4. [Pages & Views](#pages--views)
5. [Custom Hooks](#custom-hooks)
6. [Utilities & Helpers](#utilities--helpers)
7. [Services & API](#services--api)
8. [State Management](#state-management)
9. [Styles & UI](#styles--ui)
10. [Assets & Resources](#assets--resources)
11. [Application Architecture Summary](#application-architecture-summary)

---

EOF

echo -e "${YELLOW}📊 Analyzing Application Structure...${NC}"

{
    echo "## Application Structure Overview"
    echo
    echo "Complete source code structure of the React application."
    echo
    
    # Find main source directories
    SOURCE_DIRS=()
    if [ -d "${PROJECT_DIR}/src" ]; then SOURCE_DIRS+=("src"); fi
    if [ -d "${PROJECT_DIR}/app" ]; then SOURCE_DIRS+=("app"); fi
    if [ -d "${PROJECT_DIR}/components" ]; then SOURCE_DIRS+=("components"); fi
    if [ -d "${PROJECT_DIR}/pages" ]; then SOURCE_DIRS+=("pages"); fi
    
    echo "### Source Directory Structure"
    echo
    for dir in "${SOURCE_DIRS[@]}"; do
        if [ -d "${PROJECT_DIR}/$dir" ]; then
            echo "**$dir/ directory:**"
            echo '```'
            find "${PROJECT_DIR}/$dir" -type f \( -name "*.js" -o -name "*.jsx" -o -name "*.ts" -o -name "*.tsx" -o -name "*.css" -o -name "*.scss" \) | sort | sed "s|${PROJECT_DIR}/||"
            echo '```'
            echo
        fi
    done
    
    # Count files by type
    JS_COUNT=$(find "${PROJECT_DIR}" -path "*/node_modules" -prune -o -path "*/.git" -prune -o -name "*.js" -type f -print | grep -E "(src/|app/|components/|pages/)" | wc -l)
    JSX_COUNT=$(find "${PROJECT_DIR}" -path "*/node_modules" -prune -o -path "*/.git" -prune -o -name "*.jsx" -type f -print | grep -E "(src/|app/|components/|pages/)" | wc -l)
    TS_COUNT=$(find "${PROJECT_DIR}" -path "*/node_modules" -prune -o -path "*/.git" -prune -o -name "*.ts" -type f -print | grep -E "(src/|app/|components/|pages/)" | wc -l)
    TSX_COUNT=$(find "${PROJECT_DIR}" -path "*/node_modules" -prune -o -path "*/.git" -prune -o -name "*.tsx" -type f -print | grep -E "(src/|app/|components/|pages/)" | wc -l)
    CSS_COUNT=$(find "${PROJECT_DIR}" -path "*/node_modules" -prune -o -path "*/.git" -prune -o -name "*.css" -type f -print | grep -E "(src/|app/|components/|pages/|styles/)" | wc -l)
    SCSS_COUNT=$(find "${PROJECT_DIR}" -path "*/node_modules" -prune -o -path "*/.git" -prune -o -name "*.scss" -type f -print | grep -E "(src/|app/|components/|pages/|styles/)" | wc -l)
    
    echo "### File Statistics"
    echo "| File Type | Count |"
    echo "|-----------|-------|"
    echo "| JavaScript (.js) | $JS_COUNT |"
    echo "| JSX (.jsx) | $JSX_COUNT |"
    echo "| TypeScript (.ts) | $TS_COUNT |"
    echo "| TSX (.tsx) | $TSX_COUNT |"
    echo "| CSS (.css) | $CSS_COUNT |"
    echo "| SCSS (.scss) | $SCSS_COUNT |"
    echo "| **Total Source Files** | **$((JS_COUNT + JSX_COUNT + TS_COUNT + TSX_COUNT + CSS_COUNT + SCSS_COUNT))** |"
    echo
} >> "$REPORT_FILE"

echo -e "${YELLOW}🏠 Analyzing Main Entry Points...${NC}"

{
    echo "## Main Entry Points"
    echo
    echo "Application entry points and main files."
    echo
} >> "$REPORT_FILE"

# Find and display main entry files
ENTRY_FILES=(
    "src/index.js"
    "src/index.jsx"
    "src/index.ts"
    "src/index.tsx"
    "src/main.js"
    "src/main.jsx"
    "src/main.ts"
    "src/main.tsx"
    "src/App.js"
    "src/App.jsx"
    "src/App.ts"
    "src/App.tsx"
    "app/page.js"
    "app/page.jsx"
    "app/page.ts"
    "app/page.tsx"
    "app/layout.js"
    "app/layout.jsx"
    "app/layout.ts"
    "app/layout.tsx"
)

for entry_file in "${ENTRY_FILES[@]}"; do
    if [ -f "${PROJECT_DIR}/$entry_file" ]; then
        {
            display_file_content "${PROJECT_DIR}/$entry_file" "Entry Point: $(basename "$entry_file")"
        } >> "$REPORT_FILE"
    fi
done

echo -e "${YELLOW}⚛️ Analyzing React Components...${NC}"

{
    echo "## React Components"
    echo
    echo "All React components with complete source code and analysis."
    echo
} >> "$REPORT_FILE"

# Find and analyze React components
find "${PROJECT_DIR}" -path "*/node_modules" -prune -o -path "*/.git" -prune -o \( -name "*.jsx" -o -name "*.tsx" \) -type f -print | grep -E "(src/|app/|components/)" | sort | while read -r component_file; do
    if [ -f "$component_file" ]; then
        {
            display_file_content "$component_file" "Component: $(basename "$component_file")"
            analyze_component_structure "$component_file"
        } >> "$REPORT_FILE"
    fi
done

echo -e "${YELLOW}📄 Analyzing Pages & Views...${NC}"

{
    echo "## Pages & Views"
    echo
    echo "Page components and view files."
    echo
} >> "$REPORT_FILE"

# Find page/view files
find "${PROJECT_DIR}" -path "*/node_modules" -prune -o -path "*/.git" -prune -o \( -name "*.js" -o -name "*.jsx" -o -name "*.ts" -o -name "*.tsx" \) -type f -print | grep -E "(pages/|views/|screens/)" | sort | while read -r page_file; do
    if [ -f "$page_file" ]; then
        {
            display_file_content "$page_file" "Page/View: $(basename "$page_file")"
            if [[ "$page_file" == *.jsx ]] || [[ "$page_file" == *.tsx ]]; then
                analyze_component_structure "$page_file"
            fi
        } >> "$REPORT_FILE"
    fi
done

echo -e "${YELLOW}🪝 Analyzing Custom Hooks...${NC}"

{
    echo "## Custom Hooks"
    echo
    echo "Custom React hooks and their implementations."
    echo
} >> "$REPORT_FILE"

# Find custom hooks
find "${PROJECT_DIR}" -path "*/node_modules" -prune -o -path "*/.git" -prune -o \( -name "use*.js" -o -name "use*.jsx" -o -name "use*.ts" -o -name "use*.tsx" \) -type f -print | grep -E "(src/|app/|hooks/)" | sort | while read -r hook_file; do
    if [ -f "$hook_file" ]; then
        {
            display_file_content "$hook_file" "Custom Hook: $(basename "$hook_file")"
        } >> "$REPORT_FILE"
    fi
done

echo -e "${YELLOW}🛠️ Analyzing Utilities & Helpers...${NC}"

{
    echo "## Utilities & Helpers"
    echo
    echo "Utility functions and helper modules."
    echo
} >> "$REPORT_FILE"

# Find utility files
find "${PROJECT_DIR}" -path "*/node_modules" -prune -o -path "*/.git" -prune -o \( -name "*util*" -o -name "*helper*" -o -name "*lib*" \) -type f \( -name "*.js" -o -name "*.ts" -o -name "*.jsx" -o -name "*.tsx" \) -print | grep -E "(src/|app/|utils/|lib/|helpers/)" | sort | while read -r util_file; do
    if [ -f "$util_file" ]; then
        {
            display_file_content "$util_file" "Utility: $(basename "$util_file")"
        } >> "$REPORT_FILE"
    fi
done

echo -e "${YELLOW}🌐 Analyzing Services & API...${NC}"

{
    echo "## Services & API"
    echo
    echo "API services, HTTP clients, and data fetching logic."
    echo
} >> "$REPORT_FILE"

# Find service and API files
find "${PROJECT_DIR}" -path "*/node_modules" -prune -o -path "*/.git" -prune -o \( -name "*service*" -o -name "*api*" -o -name "*client*" -o -name "*fetch*" \) -type f \( -name "*.js" -o -name "*.ts" -o -name "*.jsx" -o -name "*.tsx" \) -print | grep -E "(src/|app/|api/|services/)" | sort | while read -r service_file; do
    if [ -f "$service_file" ]; then
        {
            display_file_content "$service_file" "Service/API: $(basename "$service_file")"
        } >> "$REPORT_FILE"
    fi
done

echo -e "${YELLOW}🏪 Analyzing State Management...${NC}"

{
    echo "## State Management"
    echo
    echo "State management files including stores, reducers, and context providers."
    echo
} >> "$REPORT_FILE"

# Find state management files
find "${PROJECT_DIR}" -path "*/node_modules" -prune -o -path "*/.git" -prune -o \( -name "*store*" -o -name "*reducer*" -o -name "*context*" -o -name "*state*" -o -name "*slice*" \) -type f \( -name "*.js" -o -name "*.ts" -o -name "*.jsx" -o -name "*.tsx" \) -print | grep -E "(src/|app/|store/|context/|redux/)" | sort | while read -r state_file; do
    if [ -f "$state_file" ]; then
        {
            display_file_content "$state_file" "State Management: $(basename "$state_file")"
        } >> "$REPORT_FILE"
    fi
done

echo -e "${YELLOW}🎨 Analyzing Styles & UI...${NC}"

{
    echo "## Styles & UI"
    echo
    echo "Styling files and UI-related code."
    echo
} >> "$REPORT_FILE"

# Find style files in source directories
find "${PROJECT_DIR}" -path "*/node_modules" -prune -o -path "*/.git" -prune -o \( -name "*.css" -o -name "*.scss" -o -name "*.sass" -o -name "*.module.css" -o -name "*.module.scss" \) -type f -print | grep -E "(src/|app/|styles/|components/)" | sort | while read -r style_file; do
    if [ -f "$style_file" ]; then
        {
            display_file_content "$style_file" "Style: $(basename "$style_file")"
        } >> "$REPORT_FILE"
    fi
done

echo -e "${YELLOW}📦 Analyzing Assets & Resources...${NC}"

{
    echo "## Assets & Resources"
    echo
    echo "Static assets and resource files within the source code."
    echo
    
    # List image and asset files
    echo "### Image Assets"
    echo '```'
    find "${PROJECT_DIR}" -path "*/node_modules" -prune -o -path "*/.git" -prune -o \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" -o -name "*.svg" -o -name "*.webp" -o -name "*.ico" \) -type f -print | grep -E "(src/|app/|assets/|images/|public/)" | sort | sed "s|${PROJECT_DIR}/||"
    echo '```'
    echo
    
    # List other asset files
    echo "### Other Assets"
    echo '```'
    find "${PROJECT_DIR}" -path "*/node_modules" -prune -o -path "*/.git" -prune -o \( -name "*.json" -o -name "*.xml" -o -name "*.txt" -o -name "*.md" \) -type f -print | grep -E "(src/|app/|assets/|public/)" | sort | sed "s|${PROJECT_DIR}/||"
    echo '```'
    echo
} >> "$REPORT_FILE"

echo -e "${YELLOW}📊 Generating Architecture Summary...${NC}"

{
    echo "## Application Architecture Summary"
    echo
    
    echo "### Component Hierarchy"
    echo
    echo "Based on import analysis and file structure:"
    echo '```'
    # Simple component hierarchy based on imports
    find "${PROJECT_DIR}" -path "*/node_modules" -prune -o -path "*/.git" -prune -o \( -name "*.jsx" -o -name "*.tsx" \) -type f -print | grep -E "(src/|app/|components/)" | while read -r comp; do
        comp_name=$(basename "$comp" | sed 's/\.[^.]*$//')
        echo "├── $comp_name"
        # Find files that import this component
        grep -l "import.*$comp_name" "${PROJECT_DIR}"/src/**/*.{js,jsx,ts,tsx} 2>/dev/null | head -3 | while read -r importer; do
            echo "│   └── used by $(basename "$importer")"
        done
    done
    echo '```'
    echo
    
    echo "### Key Patterns Detected"
    echo
    
    # Analyze patterns
    TOTAL_COMPONENTS=$((JSX_COUNT + TSX_COUNT))
    TOTAL_JS_FILES=$((JS_COUNT + TS_COUNT))
    
    if [ "$TSX_COUNT" -gt "$JSX_COUNT" ] || [ "$TS_COUNT" -gt "$JS_COUNT" ]; then
        echo "- 📝 **TypeScript-first project** - Majority of files use TypeScript"
    else
        echo "- 📄 **JavaScript-based project** - Primarily using JavaScript"
    fi
    
    # Check for common patterns
    if find "${PROJECT_DIR}" -name "*.tsx" -o -name "*.jsx" | xargs grep -l "useState\|useEffect" >/dev/null 2>&1; then
        echo "- 🪝 **Hooks-based components** - Modern functional components with hooks"
    fi
    
    if find "${PROJECT_DIR}" -name "*.js" -o -name "*.ts" | xargs grep -l "createContext\|useContext" >/dev/null 2>&1; then
        echo "- 🔄 **Context API usage** - React Context for state management"
    fi
    
    if find "${PROJECT_DIR}" -name "*.js" -o -name "*.ts" | xargs grep -l "redux\|dispatch\|store" >/dev/null 2>&1; then
        echo "- 🏪 **Redux pattern** - Centralized state management"
    fi
    
    if find "${PROJECT_DIR}" -name "*.module.css" -o -name "*.module.scss" >/dev/null 2>&1; then
        echo "- 🎨 **CSS Modules** - Scoped CSS styling"
    fi
    
    if find "${PROJECT_DIR}" -name "*.js" -o -name "*.ts" | xargs grep -l "styled-components\|emotion" >/dev/null 2>&1; then
        echo "- 💅 **CSS-in-JS** - Styled components approach"
    fi
    
    echo
    echo "### File Organization"
    echo
    if [ -d "${PROJECT_DIR}/src/components" ]; then
        COMP_COUNT=$(find "${PROJECT_DIR}/src/components" -name "*.jsx" -o -name "*.tsx" | wc -l)
        echo "- 📦 **Component-based structure** - $COMP_COUNT components in dedicated folder"
    fi
    
    if [ -d "${PROJECT_DIR}/src/pages" ] || [ -d "${PROJECT_DIR}/pages" ]; then
        echo "- 📄 **Page-based routing** - Dedicated pages directory"
    fi
    
    if [ -d "${PROJECT_DIR}/src/hooks" ]; then
        HOOK_COUNT=$(find "${PROJECT_DIR}/src/hooks" -name "use*.js" -o -name "use*.ts" | wc -l)
        echo "- 🪝 **Custom hooks organization** - $HOOK_COUNT custom hooks"
    fi
    
    if [ -d "${PROJECT_DIR}/src/utils" ] || [ -d "${PROJECT_DIR}/src/lib" ]; then
        echo "- 🛠️ **Utility organization** - Separated utility functions"
    fi
    
    echo
    echo "### Development Recommendations"
    echo
    
    if [ "$TOTAL_COMPONENTS" -gt 20 ]; then
        echo "- 📚 **Consider component documentation** - Large number of components ($TOTAL_COMPONENTS)"
    fi
    
    if [ ! -d "${PROJECT_DIR}/src/hooks" ] && [ "$TOTAL_COMPONENTS" -gt 10 ]; then
        echo "- 🪝 **Extract custom hooks** - Reusable logic in $TOTAL_COMPONENTS components"
    fi
    
    if [ "$CSS_COUNT" -gt 10 ] && [ "$SCSS_COUNT" -eq 0 ]; then
        echo "- 🎨 **Consider SCSS** - Many CSS files could benefit from preprocessing"
    fi
    
    if [ "$TOTAL_JS_FILES" -gt "$TOTAL_COMPONENTS" ]; then
        echo "- 🧹 **Good separation of concerns** - Logic separated from components"
    fi
    
    echo
    echo "---"
    echo
    echo "**Source Code Analysis Complete!**"
    echo
    echo "*This report contains the complete source code and structure of your React application.*"
    echo "*Total files analyzed: $((TOTAL_COMPONENTS + TOTAL_JS_FILES + CSS_COUNT + SCSS_COUNT))*"
    echo "*Focus: Application logic, components, and user interface code only.*"
    
} >> "$REPORT_FILE"

# Calculate final statistics
REPORT_SIZE=$(check_file_size "$REPORT_FILE")
TOTAL_FILES=$((JS_COUNT + JSX_COUNT + TS_COUNT + TSX_COUNT + CSS_COUNT + SCSS_COUNT))

echo
echo -e "${GREEN}✅ React Source Code Analysis Complete!${NC}"
echo -e "${GREEN}📄 Report generated: ${REPORT_FILE}${NC}"
echo -e "${GREEN}📏 Report size: ${REPORT_SIZE} bytes${NC}"
echo
echo -e "${CYAN}📊 Analysis Summary:${NC}"
echo -e "${CYAN}   - React Components (.jsx/.tsx): $((JSX_COUNT + TSX_COUNT))${NC}"
echo -e "${CYAN}   - JavaScript/TypeScript: $((JS_COUNT + TS_COUNT))${NC}"
echo -e "${CYAN}   - Style files: $((CSS_COUNT + SCSS_COUNT))${NC}"
echo -e "${CYAN}   - Total source files: ${TOTAL_FILES}${NC}"
echo
echo -e "${BLUE}✨ Report includes:${NC}"
echo -e "${BLUE}   ✅ Complete React component source code${NC}"
echo -e "${BLUE}   ✅ Application entry points${NC}"
echo -e "${BLUE}   ✅ Custom hooks and utilities${NC}"
echo -e "${BLUE}   ✅ State management logic${NC}"
echo -e "${BLUE}   ✅ Service/API layers${NC}"
echo -e "${BLUE}   ✅ Styling and UI code${NC}"
echo -e "${BLUE}   ✅ Component analysis and patterns${NC}"
echo -e "${BLUE}   ✅ Architecture insights${NC}"
echo
echo -e "${YELLOW}🎯 Focus: Application source code only (no config files)${NC}"

# Optional: Open the report if possible
if command -v open &> /dev/null; then
    echo -e "${YELLOW}Opening report...${NC}"
    open "$REPORT_FILE"
elif command -v xdg-open &> /dev/null; then
    echo -e "${YELLOW}Opening report...${NC}"
    xdg-open "$REPORT_FILE"
fi
