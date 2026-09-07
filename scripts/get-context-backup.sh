#!/bin/bash

QUESTION="$1"
KNOWLEDGE="$HOME/research-council/knowledge"

if [ -z "$QUESTION" ]; then
    echo "Usage:"
    echo "./get-context.sh \"research question\""
    exit 1
fi

echo "Previous knowledge relevant to:"
echo "$QUESTION"
echo
echo "=============================="
echo

# Extract possible matching terms
TERMS=$(echo "$QUESTION" | tr ' ' '\n' | grep -v -E '^.{0,3}$')

for TERM in $TERMS
do
    grep -ril "$TERM" "$KNOWLEDGE" 2>/dev/null
done | sort -u | while read FILE
do
    echo
    echo "SOURCE:"
    echo "$FILE"
    echo
    cat "$FILE"
    echo
    echo "=============================="
done
