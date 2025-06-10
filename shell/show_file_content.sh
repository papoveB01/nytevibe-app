#!/bin/bash
echo "📄 SHOW: File Content"
echo "Showing the files that contain verification logic..."

find src -name "*.jsx" | xargs grep -l "Please verify your email\|email.*verify" | head -2 | while read file; do
    echo ""
    echo "=== $file ==="
    cat "$file"
    echo ""
done
