#!/bin/bash

KNOWLEDGE="$HOME/research-council/knowledge"
INDEX="$KNOWLEDGE/index.md"

echo "# Research Council Knowledge Index" > "$INDEX"
echo "" >> "$INDEX"
echo "Generated: $(date)" >> "$INDEX"
echo "" >> "$INDEX"

for FILE in "$KNOWLEDGE"/entries/*.md
do
    echo "## $(basename "$FILE")" >> "$INDEX"
    echo "" >> "$INDEX"

    echo "**Metadata:**" >> "$INDEX"
    echo "" >> "$INDEX"

    sed -n '/^---$/,/^---$/p' "$FILE" | sed '1d;$d' >> "$INDEX"

    echo "" >> "$INDEX"
    echo "---" >> "$INDEX"
    echo "" >> "$INDEX"

done

echo "Index created:"
echo "$INDEX"
