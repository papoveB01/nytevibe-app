#!/bin/bash

echo "Applying simple fix to AppContext.jsx..."

# Create a backup
cp src/context/AppContext.jsx src/context/AppContext.jsx.broken

# Use sed to fix the scope issue
# This removes any setView definition and adds it properly inside the component

# First, remove any broken setView
sed -i '/setView:/,/},/d' src/context/AppContext.jsx

# Then add it properly after 'const actions = {'
sed -i '/const actions = {/a\        setView: (view) => {\
            setState(prev => ({ ...prev, currentView: view }));\
        },' src/context/AppContext.jsx

echo "✅ Simple fix applied"
echo ""
echo "If this doesn't work, you can use the reference file:"
echo "cp $BACKUP_DIR/AppContext.reference.jsx src/context/AppContext.jsx"
