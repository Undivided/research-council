#!/bin/bash

PROJECT=$1
QUESTION=$2
MODEL="gemma4:31b-cloud"

if [ -z "$PROJECT" ] || [ -z "$QUESTION" ]; then
    echo "Usage:"
    echo "./scripts/run-council.sh project-name \"research question\""
    exit 1
fi

BASE="$HOME/research-council/projects/$PROJECT"
KNOWLEDGE="$HOME/research-council/knowledge"

if [ ! -d "$BASE" ]; then
    echo "Project does not exist:"
    echo "$BASE"
    exit 1
fi

mkdir -p "$BASE/runs"
mkdir -p "$BASE/analysis"
mkdir -p "$KNOWLEDGE/entries"

echo "Running Research Council"
echo "Project: $PROJECT"
echo "Model: $MODEL"
echo

#
# Build knowledge context
#

KNOWLEDGE_CONTEXT=""

if [ -d "$KNOWLEDGE/entries" ]; then

    for KNOWLEDGE_FILE in "$KNOWLEDGE"/entries/*.md
    do
        if [ -f "$KNOWLEDGE_FILE" ]; then

            KNOWLEDGE_CONTEXT+="
--- BEGIN KNOWLEDGE: $(basename "$KNOWLEDGE_FILE") ---

$(cat "$KNOWLEDGE_FILE")

--- END KNOWLEDGE: $(basename "$KNOWLEDGE_FILE") ---
"

        fi
    done

fi

#
# Council agents
#

AGENTS=(
researcher
historian
philosopher
strategist
skeptic
red-team
editor
archivist
librarian
)

OUTPUTS=()

#
# Run each agent
#

for AGENT in "${AGENTS[@]}"
do

    TIMESTAMP=$(date +%H%M%S)

    FILE="$BASE/analysis/$AGENT-task-001-$TIMESTAMP.md"

    echo "Processing: $AGENT"

    PROMPT="
You are the $AGENT agent in a research council.

Research question:

$QUESTION

Your role is:

$AGENT

The following is the ACTUAL CONTENT of the council's accumulated
knowledge base.

Use it when relevant.

Do NOT assume that previous knowledge is correct.
Challenge it when appropriate.
Preserve uncertainty.
Do not invent information that is not present.

================ KNOWLEDGE BASE ================

$KNOWLEDGE_CONTEXT

============== END KNOWLEDGE BASE ==============

Produce a complete report.

Requirements:

- Separate facts from interpretations
- Identify unknowns
- Include confidence level
- Explain confidence reasoning
- Do not pretend certainty
- Challenge weak assumptions
- Distinguish previous knowledge from new conclusions

Return only the report content.
"

    ollama run "$MODEL" "$PROMPT" > "$FILE"

    echo "Saved:"
    echo "$FILE"

    #
    # Archivist creates persistent knowledge
    #

    if [ "$AGENT" = "archivist" ]; then

        KNOWLEDGE_TIMESTAMP=$(date +%H%M%S)

        KNOWLEDGE_FILE="$KNOWLEDGE/entries/entry-$KNOWLEDGE_TIMESTAMP.md"

        cp "$FILE" "$KNOWLEDGE_FILE"

        echo "Knowledge entry:"
        echo "$KNOWLEDGE_FILE"

    fi

    OUTPUTS+=("$FILE")

done

#
# Create research run record
#

RUN_ID=$(date +%Y%m%d-%H%M%S)

RUN_FILE="$BASE/runs/run-$RUN_ID.md"

cp "$HOME/research-council/templates/run-template.md" "$RUN_FILE"

sed -i "s/{{RUN_ID}}/$RUN_ID/g" "$RUN_FILE"
sed -i "s/{{PROJECT}}/$PROJECT/g" "$RUN_FILE"
sed -i "s/{{DATE}}/$(date +%Y-%m-%d)/g" "$RUN_FILE"
sed -i "s/{{MODEL}}/$MODEL/g" "$RUN_FILE"
sed -i "s/{{QUESTION}}/$QUESTION/g" "$RUN_FILE"

#
# Populate generated outputs
#

{
    echo
    echo "## Outputs Generated"
    echo
    echo "Analysis files:"
    echo

    for OUTPUT in "${OUTPUTS[@]}"
    do
        echo "- $(basename "$OUTPUT")"
    done

    FINAL_REPORT="${OUTPUTS[${#OUTPUTS[@]}-1]}"

    echo
    echo "Final Report:"
    echo
    echo "- $(basename "$FINAL_REPORT")"

    echo
    echo "## Knowledge"
    echo
    echo "Archivist output:"
    echo

    for OUTPUT in "${OUTPUTS[@]}"
    do
        if [[ "$(basename "$OUTPUT")" == archivist-* ]]; then
            echo "- $(basename "$OUTPUT")"
        fi
    done

    echo
    echo "## Quality Notes"
    echo
    echo "Evidence quality:"
    echo
    echo "Reviewed by multi-agent council."

    echo
    echo "Confidence:"
    echo
    echo "Determined by final council synthesis."

    echo
    echo "Major uncertainties:"
    echo
    echo "- Requires future review and additional evidence."

    echo
    echo "## Future Review"
    echo
    echo "Questions to revisit:"
    echo
    echo "- Update conclusions as new evidence becomes available."

    echo
    echo "Potential updates needed:"
    echo
    echo "- Re-run council with expanded sources."

} >> "$RUN_FILE"

echo
echo "Run record:"
echo "$RUN_FILE"

echo
echo "Council run complete."
