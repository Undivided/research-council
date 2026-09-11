#!/usr/bin/env bash

set -euo pipefail

ROOT="$HOME/research-council"
TURTLE="$ROOT/turtle"

echo "🐢 Turtle Backup Check"
echo "====================="
echo

# Verify location

if [ ! -d "$TURTLE" ]; then
    echo "ERROR: Turtle directory missing:"
    echo "$TURTLE"
    exit 1
fi

echo "✓ Turtle directory found"

echo

# Verify core structure

for DIR in commits archive indexes reviews; do
    if [ -d "$TURTLE/$DIR" ]; then
        echo "✓ $DIR/"
    else
        echo "✗ Missing $DIR/"
    fi
done

echo

# Count commits

COUNT=$(find "$TURTLE/commits" -type f -name "*.md" | wc -l)

echo "Turtle commit artifacts:"
echo "$COUNT"

echo

# Git status

echo "Git status:"
echo "-----------"

cd "$ROOT"
git status --short

echo

echo "Backup check complete."
