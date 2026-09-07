#!/bin/bash

KNOWLEDGE="$HOME/research-council/knowledge"

echo "# Available Knowledge"
echo

find "$KNOWLEDGE" -name "*.md" | while read FILE
do
    echo "================================================"
    echo "FILE: $FILE"
    echo "================================================"
    cat "$FILE"
    echo
done
