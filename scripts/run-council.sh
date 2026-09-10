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
ROLE_DIR="$HOME/research-council/config/roles"

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
fool
editor
judge
archivist
librarian
)

OUTPUTS=()
EDITOR_OUTPUT=""
JUDGE_OUTPUT=""

#
# Run each agent
#

for AGENT in "${AGENTS[@]}"
do

    TIMESTAMP=$(date +%H%M%S)

    FILE="$BASE/analysis/$AGENT-task-001-$TIMESTAMP.md"

    echo "Processing: $AGENT"

    ROLE_CONTEXT=""

    if [ -f "$ROLE_DIR/$AGENT.md" ]; then
        ROLE_CONTEXT=$(cat "$ROLE_DIR/$AGENT.md")
    fi

HANDOFF_CONTEXT=""

if [ "$AGENT" = "editor" ]; then
    HANDOFF_CONTEXT=$(
        for OUTPUT in "${OUTPUTS[@]}"
        do
            printf "\n===== %s =====\n" "$(basename "$OUTPUT")"
            cat "$OUTPUT"

            PROVENANCE="${OUTPUT%.md}.provenance.yaml"

            if [ -f "$PROVENANCE" ]; then
                printf "\n===== %s =====\n" "$(basename "$PROVENANCE")"
                cat "$PROVENANCE"
            fi
        done
    )
fi

if [ "$AGENT" = "judge" ] && [ -n "$EDITOR_OUTPUT" ]; then
    HANDOFF_CONTEXT=$(printf "\n===== EDITOR SYNTHESIS =====\n"; cat "$EDITOR_OUTPUT")
fi
if [ "$AGENT" = "archivist" ] && [ -n "$EDITOR_OUTPUT" ]; then
    HANDOFF_CONTEXT=$(
        printf "\n===== EDITOR SYNTHESIS =====\n"
        cat "$EDITOR_OUTPUT"

        if [ -n "$JUDGE_OUTPUT" ]; then
            printf "\n===== JUDGE EVALUATION =====\n"
            cat "$JUDGE_OUTPUT"
        fi
    )
fi

CONTEXT=$(~/research-council/scripts/get-context.sh "$QUESTION")
AGENT_KNOWLEDGE_CONTEXT="$KNOWLEDGE_CONTEXT"

if [ "$AGENT" = "fool" ]; then
    CONTEXT=""
    AGENT_KNOWLEDGE_CONTEXT=""
    HANDOFF_CONTEXT=""
fi

PROMPT="
You are the $AGENT agent in a research council.

Research question:

$QUESTION

Previous council knowledge:

$CONTEXT

Use previous knowledge when relevant.

Do not blindly trust previous conclusions.

Challenge outdated, incomplete, or unsupported information.

Your cognitive function definition:

$ROLE_CONTEXT

Apply this function during analysis.

Do not simply imitate a personality.

Act according to the purpose, constraints, and questions defined above.

The following is the ACTUAL CONTENT of the council's accumulated
knowledge base.

Use it when relevant.

Do NOT assume that previous knowledge is correct.
Challenge it when appropriate.
Preserve uncertainty.
Do not invent information that is not present.

================ KNOWLEDGE BASE ================

$AGENT_KNOWLEDGE_CONTEXT

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

if [ -n "$HANDOFF_CONTEXT" ]; then
    PROMPT="$PROMPT

================ CURRENT COUNCIL REPORTS ================

$HANDOFF_CONTEXT

============== END CURRENT COUNCIL REPORTS ==============

Synthesize or preserve this current-run material according to your role. Preserve disagreements, evidence, uncertainty, and unresolved questions."
fi

    echo "$PROMPT" > /tmp/council-prompt.txt

echo "Prompt size:"
wc -c /tmp/council-prompt.txt

if ! echo "$PROMPT" | ollama run "$MODEL" > "$FILE"; then
    echo "ERROR: Model invocation failed for $AGENT" >&2
    rm -f "$FILE"
    exit 1
fi

if [ ! -s "$FILE" ]; then
    echo "ERROR: Model invocation produced an empty artifact for $AGENT" >&2
    rm -f "$FILE"
    exit 1
fi

if [ "$AGENT" = "fool" ]; then

    PROVENANCE_FILE="${FILE%.md}.provenance.yaml"
    ARTIFACT_ID="$(basename "${FILE%.md}")"

    cat > "$PROVENANCE_FILE" <<EOF
artifact_id: "$ARTIFACT_ID"
agent: "$AGENT"
environment: "sandbox"
experiment: "R0.5-001"
context_mode: "clean"
epistemic_status: "exploratory"
report_file: "$(basename "$FILE")"
EOF

    echo "Provenance:"
    echo "$PROVENANCE_FILE"
fi

echo "Saved:"
echo "$FILE"

#
# Archivist creates persistent knowledge
#

if [ "$AGENT" = "archivist" ]; then

    KNOWLEDGE_TIMESTAMP=$(date +%H%M%S)

    KNOWLEDGE_FILE="$KNOWLEDGE/entries/entry-$KNOWLEDGE_TIMESTAMP.md"

    echo "---" > "$KNOWLEDGE_FILE"
    echo "id: $KNOWLEDGE_TIMESTAMP" >> "$KNOWLEDGE_FILE"
    echo "type: research_entry" >> "$KNOWLEDGE_FILE"
    echo "domain:" >> "$KNOWLEDGE_FILE"
    echo "  - scientific_decision_making" >> "$KNOWLEDGE_FILE"
    echo "topics:" >> "$KNOWLEDGE_FILE"
    echo "  - research_quality" >> "$KNOWLEDGE_FILE"
    echo "  - decision_frameworks" >> "$KNOWLEDGE_FILE"
    echo "confidence: medium" >> "$KNOWLEDGE_FILE"
    echo "created: $(date +%Y-%m-%d)" >> "$KNOWLEDGE_FILE"
    echo "---" >> "$KNOWLEDGE_FILE"
    echo "" >> "$KNOWLEDGE_FILE"

if grep -q "ARCHIVAL REPORT" "$FILE"; then

    grep -A 10000 "ARCHIVAL REPORT" "$FILE" >> "$KNOWLEDGE_FILE"
    #
    # Validate knowledge entry
    #

    if [ ! -s "$KNOWLEDGE_FILE" ]; then
        echo "ERROR: Knowledge entry is empty"
        rm "$KNOWLEDGE_FILE"
        exit 1
    fi

    if ! grep -q "ARCHIVAL REPORT" "$KNOWLEDGE_FILE"; then
        echo "ERROR: Knowledge entry missing archival report"
        rm "$KNOWLEDGE_FILE"
        exit 1
    fi

    if [ "$(wc -c < "$KNOWLEDGE_FILE")" -lt 1000 ]; then
        echo "ERROR: Knowledge entry suspiciously small"
        rm "$KNOWLEDGE_FILE"
        exit 1
    fi
else

    rm "$KNOWLEDGE_FILE"
    echo "Archivist failed validation. No knowledge entry created."

fi

    echo "Knowledge entry:"
    echo "$KNOWLEDGE_FILE"

fi

    OUTPUTS+=("$FILE")

    if [ "$AGENT" = "editor" ]; then
        EDITOR_OUTPUT="$FILE"
    fi

    if [ "$AGENT" = "judge" ]; then
        JUDGE_OUTPUT="$FILE"
    fi

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

    FINAL_REPORT="$EDITOR_OUTPUT"

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
