#!/bin/bash

KNOWLEDGE="$HOME/research-council/knowledge/entries"

echo "Checking knowledge metadata..."
echo

for FILE in "$KNOWLEDGE"/*.md
do
    NAME=$(basename "$FILE")

    if head -1 "$FILE" | grep -q "^---$"; then
        echo "✓ $NAME"
    else
        echo "✗ $NAME missing metadata"
    fi
done
