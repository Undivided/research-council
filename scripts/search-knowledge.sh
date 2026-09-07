#!/bin/bash

QUERY="$1"

if [ -z "$QUERY" ]; then
    echo "Usage:"
    echo "./scripts/search-knowledge.sh \"search term\""
    exit 1
fi

echo "Searching knowledge base for:"
echo "$QUERY"
echo

grep -ril "$QUERY" "$HOME/research-council/knowledge" | while read FILE
do
    echo "Found:"
    echo "$FILE"
    echo
done
