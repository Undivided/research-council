#!/bin/bash


MODEL="gemma4:31b-cloud"
RUN_MODE="new"
RESUME_RUN_ID=""
QUESTION=""

if [ "$1" = "--resume" ]; then
    RUN_MODE="resume"
    PROJECT="$2"
    RESUME_RUN_ID="$3"

    if [ -z "$PROJECT" ] || [ -z "$RESUME_RUN_ID" ]; then
        echo "Usage:"
        echo "./scripts/run-council.sh --resume project-name run-id"
        exit 1
    fi
else
    PROJECT="$1"
    QUESTION="$2"

    if [ -z "$PROJECT" ] || [ -z "$QUESTION" ]; then
        echo "Usage:"
        echo "./scripts/run-council.sh project-name \"research question\""
        echo "./scripts/run-council.sh --resume project-name run-id"
        exit 1
    fi
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
mkdir -p "$BASE/runs/outcomes"
mkdir -p "$BASE/analysis"
mkdir -p "$BASE/raw"
mkdir -p "$KNOWLEDGE/entries"

# R0.5-004 / R0.5-007: new runs create identity; resumed runs reuse it.
if [ "$RUN_MODE" = "resume" ]; then
    RUN_ID="$RESUME_RUN_ID"
else
    RUN_ID=$(date +%Y%m%d-%H%M%S)
fi

OUTCOME_DIR="$BASE/runs/outcomes"

# R0.5-007: minimal durable execution inputs required for safe resumption.
RUN_QUESTION_FILE="$BASE/runs/question-$RUN_ID.txt"
RUN_MODEL_FILE="$BASE/runs/model-$RUN_ID.txt"

write_agent_outcome() {
    local agent="$1"
    local invocation_status="$2"
    local artifact_status="$3"
    local agent_status="$4"
    local reason="$5"
    local raw_artifact="$6"
    local promoted_artifact="$7"

    local outcome_file="$OUTCOME_DIR/$agent-$RUN_ID.yaml"

    {
        echo "type: agent_outcome"
        echo "run_id: $RUN_ID"
        echo "agent: $agent"
        echo "invocation_status: $invocation_status"
        echo "artifact_status: $artifact_status"
        echo "agent_status: $agent_status"
        echo "reason: $reason"

        if [ -n "$raw_artifact" ]; then
            echo "raw_artifact: ${raw_artifact#"$HOME/research-council/"}"
        else
            echo "raw_artifact: null"
        fi

        if [ -n "$promoted_artifact" ]; then
            echo "promoted_artifact: ${promoted_artifact#"$HOME/research-council/"}"
        else
            echo "promoted_artifact: null"
        fi
    } > "$outcome_file"
}

# R0.5-005: durable whole-run state.
RUN_STATE_FILE="$BASE/runs/state-$RUN_ID.yaml"

# R0.5-008: one live resumer may own a logical run at a time.
#
# The pathname is durable, but ownership is determined by the kernel lock,
# not by lock-file existence. The open descriptor remains held for the
# lifetime of this process and is automatically released on process exit.
RESUME_LOCK_FILE="$BASE/runs/resume-$RUN_ID.lock"
RESUME_LOCK_FD=""

if [ "$RUN_MODE" = "resume" ]; then
    if ! command -v flock >/dev/null 2>&1; then
        echo "ERROR: flock is required for safe run resumption." >&2
        exit 1
    fi

    if ! exec {RESUME_LOCK_FD}>>"$RESUME_LOCK_FILE"; then
        echo "ERROR: Unable to open resume lock:" >&2
        echo "$RESUME_LOCK_FILE" >&2
        exit 1
    fi

    if ! flock -n "$RESUME_LOCK_FD"; then
        echo "ERROR: Another process already owns resumption of this run." >&2
        echo "Project: $PROJECT" >&2
        echo "Run ID:  $RUN_ID" >&2
        exit 75
    fi
fi

if [ "$RUN_MODE" = "resume" ]; then
    if [ ! -f "$RUN_STATE_FILE" ]; then
        echo "ERROR: Resume state does not exist:" >&2
        echo "$RUN_STATE_FILE" >&2
        exit 1
    fi

    if [ ! -s "$RUN_QUESTION_FILE" ] || [ ! -s "$RUN_MODEL_FILE" ]; then
        echo "ERROR: Run predates resumable input snapshots or they are missing." >&2
        echo "Question: $RUN_QUESTION_FILE" >&2
        echo "Model:    $RUN_MODEL_FILE" >&2
        exit 1
    fi

    STATE_RUN_ID=$(sed -n 's/^run_id: //p' "$RUN_STATE_FILE")
    STATE_PROJECT=$(sed -n 's/^project: //p' "$RUN_STATE_FILE")
    STATE_STATUS=$(sed -n 's/^run_status: //p' "$RUN_STATE_FILE")

    if [ "$STATE_RUN_ID" != "$RUN_ID" ]; then
        echo "ERROR: Resume run_id does not match durable state." >&2
        exit 1
    fi

    if [ "$STATE_PROJECT" != "$PROJECT" ]; then
        echo "ERROR: Resume project does not match durable state." >&2
        exit 1
    fi

    if [ "$STATE_STATUS" != "interrupted" ]; then
        echo "ERROR: Only interrupted runs may be resumed." >&2
        echo "Current run_status: $STATE_STATUS" >&2
        exit 1
    fi

    # R0.5-009: a canonical run record may already exist if interruption
    # occurred after run-record publication but before terminal state
    # publication. Durable run state, not run-record existence, determines
    # whether the logical run is resumable.

    QUESTION=$(cat "$RUN_QUESTION_FILE")
    MODEL=$(cat "$RUN_MODEL_FILE")
else
    printf '%s' "$QUESTION" > "$RUN_QUESTION_FILE"
    printf '%s\n' "$MODEL" > "$RUN_MODEL_FILE"
fi

write_run_state() {
    local status="${1-$RUN_STATUS}"
    local reason="${2-$RUN_REASON}"
    local current_agent="${3-$CURRENT_AGENT}"
    local failed_agent="${4-$FAILED_AGENT}"
    local tmp_file="${RUN_STATE_FILE}.tmp"

    {
        echo "type: council_run_state"
        echo "run_id: $RUN_ID"
        echo "project: $PROJECT"
        echo "run_status: $status"
        echo "reason: $reason"

        if [ -n "$current_agent" ]; then
            echo "current_agent: $current_agent"
        else
            echo "current_agent: null"
        fi

        if [ -n "$failed_agent" ]; then
            echo "failed_agent: $failed_agent"
        else
            echo "failed_agent: null"
        fi

        echo "attempted_agents: $ATTEMPTED_AGENTS"
        echo "completed_agents: $COMPLETED_AGENTS"
        echo "total_agents: $TOTAL_AGENTS"
    } > "$tmp_file"

    mv "$tmp_file" "$RUN_STATE_FILE"
}

mark_run_failed() {
    local agent="$1"

    RUN_STATUS="failed"
    RUN_REASON="agent_failure"
    CURRENT_AGENT="$agent"
    FAILED_AGENT="$agent"

    write_run_state
}

# R0.5-006: catchable process interruption.
#
# This updates whole-run state only. It deliberately does not manufacture
# an R0.5-004 agent outcome for work that did not complete through normal
# runtime control flow.
handle_run_interruption() {
    local signal="$1"
    local exit_code

    case "$signal" in
        INT)
            exit_code=130
            ;;
        TERM)
            exit_code=143
            ;;
        HUP)
            exit_code=129
            ;;
        *)
            exit_code=1
            ;;
    esac

    # Prevent recursive signal handling while persisting terminal state.
    trap - INT TERM HUP

    if [ "$RUN_STATUS" = "running" ]; then
        RUN_STATUS="interrupted"
        RUN_REASON="process_interrupted"
        FAILED_AGENT=""

        write_run_state

        echo "Council run interrupted by $signal" >&2
        echo "Run state:" >&2
        echo "$RUN_STATE_FILE" >&2
    fi

    exit "$exit_code"
}

echo "Running Research Council"
echo "Project: $PROJECT"
echo "Model: $MODEL"
echo

#
# Build or restore immutable run-start knowledge context
#

# R0.5-007: resumption must preserve the original epistemic starting point.
# Both the full knowledge-base context and get-context.sh retrieval output are
# snapshotted once for a new run and reused verbatim as run inputs on resume.
RUN_KNOWLEDGE_CONTEXT_FILE="$BASE/runs/knowledge-context-$RUN_ID.txt"
RUN_RETRIEVAL_CONTEXT_FILE="$BASE/runs/retrieval-context-$RUN_ID.txt"

if [ "$RUN_MODE" = "resume" ]; then

    if [ ! -f "$RUN_KNOWLEDGE_CONTEXT_FILE" ] ||
       [ ! -f "$RUN_RETRIEVAL_CONTEXT_FILE" ]; then
        echo "ERROR: Run predates resumable context snapshots or they are missing." >&2
        echo "Knowledge context:  $RUN_KNOWLEDGE_CONTEXT_FILE" >&2
        echo "Retrieval context:  $RUN_RETRIEVAL_CONTEXT_FILE" >&2
        exit 1
    fi

else

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

    printf '%s' "$KNOWLEDGE_CONTEXT" > "$RUN_KNOWLEDGE_CONTEXT_FILE"

    RETRIEVAL_TMP="${RUN_RETRIEVAL_CONTEXT_FILE}.tmp"

    if ! "$HOME/research-council/scripts/get-context.sh" "$QUESTION" > "$RETRIEVAL_TMP"; then
        echo "ERROR: Failed to build run-start retrieval context." >&2
        rm -f "$RETRIEVAL_TMP"
        exit 1
    fi

    mv "$RETRIEVAL_TMP" "$RUN_RETRIEVAL_CONTEXT_FILE"
fi

# Load both new and resumed runs from their durable snapshots so both paths use
# identical runtime semantics.
KNOWLEDGE_CONTEXT=$(cat "$RUN_KNOWLEDGE_CONTEXT_FILE")
RUN_RETRIEVAL_CONTEXT=$(cat "$RUN_RETRIEVAL_CONTEXT_FILE")

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

# R0.5-007: agent position defines attempted_agents semantics.
RUN_AGENTS_FILE="$BASE/runs/agents-$RUN_ID.txt"

if [ "$RUN_MODE" = "resume" ]; then
    if [ ! -s "$RUN_AGENTS_FILE" ]; then
        echo "ERROR: Saved Council roster is missing." >&2
        exit 1
    fi

    CURRENT_ROSTER=$(printf '%s\n' "${AGENTS[@]}")
    SAVED_ROSTER=$(cat "$RUN_AGENTS_FILE")

    if [ "$CURRENT_ROSTER" != "$SAVED_ROSTER" ]; then
        echo "ERROR: Council roster changed; refusing unsafe resume." >&2
        exit 1
    fi
else
    printf '%s\n' "${AGENTS[@]}" > "$RUN_AGENTS_FILE"
fi

OUTPUTS=()
EDITOR_OUTPUT=""
JUDGE_OUTPUT=""

# R0.5-002: minimal system-owned state for the Fool specimen.
# Epistemic status is assigned by the runtime, not inferred from model prose.
FOOL_OUTPUT=""
FOOL_ARTIFACT_ID=""
FOOL_EPISTEMIC_STATUS="exploratory"

# R0.5-007: restore already-completed artifacts into the current process
# without invoking those agents again.
register_resumed_output() {
    local agent="$1"
    local outcome_file="$OUTCOME_DIR/$agent-$RUN_ID.yaml"
    local promoted_rel
    local promoted_file

    if [ ! -f "$outcome_file" ]; then
        return 1
    fi

    if ! grep -Fqx "run_id: $RUN_ID" "$outcome_file" ||
       ! grep -Fqx "agent: $agent" "$outcome_file" ||
       ! grep -Fqx "invocation_status: succeeded" "$outcome_file" ||
       ! grep -Fqx "artifact_status: promoted" "$outcome_file" ||
       ! grep -Fqx "agent_status: succeeded" "$outcome_file"; then
        echo "ERROR: Existing outcome is not a resumable successful outcome:" >&2
        echo "$outcome_file" >&2
        exit 1
    fi

    promoted_rel=$(sed -n 's/^promoted_artifact: //p' "$outcome_file")

    if [ -z "$promoted_rel" ] || [ "$promoted_rel" = "null" ]; then
        echo "ERROR: Successful outcome has no promoted artifact." >&2
        exit 1
    fi

    promoted_file="$HOME/research-council/$promoted_rel"

    if [ ! -s "$promoted_file" ]; then
        echo "ERROR: Promoted artifact required for resume is missing:" >&2
        echo "$promoted_file" >&2
        exit 1
    fi

    OUTPUTS+=("$promoted_file")

    if [ "$agent" = "fool" ]; then
        FOOL_OUTPUT="$promoted_file"
        FOOL_ARTIFACT_ID="$PROJECT/analysis/$(basename "$promoted_file")"
        FOOL_RECORD_ID="${PROJECT//\//_}-$(basename "${promoted_file%.md}")"
    fi

    if [ "$agent" = "editor" ]; then
        EDITOR_OUTPUT="$promoted_file"
    fi

    if [ "$agent" = "judge" ]; then
        JUDGE_OUTPUT="$promoted_file"
    fi

    echo "Resume: skipping completed agent: $agent"
    return 0
}

#
# Run each agent
#

TOTAL_AGENTS="${#AGENTS[@]}"
NONFATAL_AGENT_FAILURE=0

if [ "$RUN_MODE" = "resume" ]; then
    ATTEMPTED_AGENTS=$(sed -n 's/^attempted_agents: //p' "$RUN_STATE_FILE")
    STATE_COMPLETED_AGENTS=$(sed -n 's/^completed_agents: //p' "$RUN_STATE_FILE")
    STATE_TOTAL_AGENTS=$(sed -n 's/^total_agents: //p' "$RUN_STATE_FILE")

    if ! [[ "$ATTEMPTED_AGENTS" =~ ^[0-9]+$ ]] ||
       ! [[ "$STATE_COMPLETED_AGENTS" =~ ^[0-9]+$ ]] ||
       ! [[ "$STATE_TOTAL_AGENTS" =~ ^[0-9]+$ ]]; then
        echo "ERROR: Invalid numeric run-state counters." >&2
        exit 1
    fi

    if [ "$STATE_TOTAL_AGENTS" -ne "$TOTAL_AGENTS" ]; then
        echo "ERROR: Saved total_agents does not match current Council." >&2
        exit 1
    fi

    COMPLETED_AGENTS=0
    SEEN_OUTCOME_GAP=0

    for EXISTING_AGENT in "${AGENTS[@]}"
    do
        EXISTING_OUTCOME="$OUTCOME_DIR/$EXISTING_AGENT-$RUN_ID.yaml"

        if [ -f "$EXISTING_OUTCOME" ]; then
            if [ "$SEEN_OUTCOME_GAP" -eq 1 ]; then
                echo "ERROR: Successful outcomes are not a contiguous prefix." >&2
                exit 1
            fi

            if ! grep -Fqx "agent_status: succeeded" "$EXISTING_OUTCOME" ||
               ! grep -Fqx "artifact_status: promoted" "$EXISTING_OUTCOME"; then
                echo "ERROR: Initial R0.5-007 resume does not replay or skip prior failed outcomes." >&2
                echo "$EXISTING_OUTCOME" >&2
                exit 1
            fi

            COMPLETED_AGENTS=$((COMPLETED_AGENTS + 1))
        else
            SEEN_OUTCOME_GAP=1
        fi
    done

    if [ "$COMPLETED_AGENTS" -ne "$STATE_COMPLETED_AGENTS" ]; then
        echo "ERROR: Run state and successful outcome count disagree." >&2
        exit 1
    fi

    if [ "$ATTEMPTED_AGENTS" -lt "$COMPLETED_AGENTS" ] ||
       [ "$ATTEMPTED_AGENTS" -gt "$TOTAL_AGENTS" ]; then
        echo "ERROR: Incoherent attempted/completed counters." >&2
        exit 1
    fi

    RUN_REASON="resumed_execution"
else
    ATTEMPTED_AGENTS=0
    COMPLETED_AGENTS=0
    RUN_REASON="in_progress"
fi

RUN_STATUS="running"
CURRENT_AGENT=""
FAILED_AGENT=""

# The run exists durably before the first model invocation.
write_run_state

# R0.5-006: signals are handled only after durable run state exists.
trap 'handle_run_interruption INT' INT
trap 'handle_run_interruption TERM' TERM
trap 'handle_run_interruption HUP' HUP

AGENT_POSITION=0

for AGENT in "${AGENTS[@]}"
do
    AGENT_POSITION=$((AGENT_POSITION + 1))

    if [ "$RUN_MODE" = "resume" ]; then
        if register_resumed_output "$AGENT"; then
            continue
        fi
    fi

    CURRENT_AGENT="$AGENT"

    # attempted_agents means furthest Council position entered, not number
    # of process invocations. Retrying the interrupted agent does not add one.
    if [ "$AGENT_POSITION" -gt "$ATTEMPTED_AGENTS" ]; then
        ATTEMPTED_AGENTS="$AGENT_POSITION"
    fi

    write_run_state

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
        done
    )
fi

if [ "$AGENT" = "judge" ] && [ -n "$EDITOR_OUTPUT" ]; then
    HANDOFF_CONTEXT=$(
        printf "\n===== EDITOR SYNTHESIS =====\n"
        cat "$EDITOR_OUTPUT"

        if [ -n "$FOOL_OUTPUT" ]; then
            printf "\n===== FOOL ARTIFACT FOR DISPOSITION =====\n"
            cat "$FOOL_OUTPUT"
        fi
    )
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

# R0.5-007: every agent in this logical run uses the original run-start
# retrieval snapshot, including agents executed after a process restart.
CONTEXT="$RUN_RETRIEVAL_CONTEXT"
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

if [ "$AGENT" = "judge" ] && [ -n "$FOOL_OUTPUT" ]; then
    PROMPT="$PROMPT

R0.5-002 disposition requirement:

Adjudicate what the institution should do with the Fool artifact supplied above.

Choose exactly one disposition:

- accepted_into_memory
- rejected
- deferred
- withheld_from_memory

Inside your Council artifact, emit exactly one machine-readable line:

FOOL_DISPOSITION: <disposition>

Make it the final report line immediately before the artifact closing marker.

The disposition line is machine-readable runtime syntax.

Emit it as literal plain text with no Markdown formatting or decoration.

It must be exactly one of:

FOOL_DISPOSITION: accepted_into_memory
FOOL_DISPOSITION: rejected
FOOL_DISPOSITION: deferred
FOOL_DISPOSITION: withheld_from_memory

Do NOT surround the line with:
- bold markers
- italics
- backticks
- bullets
- headings
- quotes
- any leading or trailing characters

For example, this is INVALID:

**FOOL_DISPOSITION: accepted_into_memory**

This is VALID:

FOOL_DISPOSITION: accepted_into_memory

Do not emit or alter artifact_id or epistemic_status.
Those values are system-owned."
fi

PROMPT="$PROMPT

R0.5-003 artifact contract:

Your raw generation may contain model-specific preamble outside the artifact
boundary.

The only content eligible for downstream Council use must appear between
exactly one pair of marker lines:

<<<COUNCIL_ARTIFACT>>>

<your complete report content>

<<<END_COUNCIL_ARTIFACT>>>

Requirements:

- Emit each delimiter marker as a standalone line exactly once.
- The opening marker must occur before the closing marker.
- Put all report content intended for downstream Council use inside the markers.
- Do not place canonical report content outside the markers.
- Inline discussion of marker text is allowed.
- Do not emit either marker as an additional standalone delimiter line.

The runtime, not the model, decides whether the boundary is valid."

    echo "$PROMPT" > /tmp/council-prompt.txt

echo "Prompt size:"
wc -c /tmp/council-prompt.txt

RAW_FILE="$BASE/raw/$(basename "${FILE%.md}").raw.txt"

if ! echo "$PROMPT" | ollama run "$MODEL" > "$RAW_FILE"; then
    echo "ERROR: Model invocation failed for $AGENT" >&2
    echo "Raw output preserved:" >&2
    echo "$RAW_FILE" >&2

    if [ -s "$RAW_FILE" ]; then
        OUTCOME_RAW="$RAW_FILE"
    else
        OUTCOME_RAW=""
    fi

    write_agent_outcome         "$AGENT" failed not_created failed model_invocation_failed         "$OUTCOME_RAW" ""

    rm -f "$FILE"
    mark_run_failed "$AGENT"

    exit 1
fi

if [ ! -s "$RAW_FILE" ]; then
    echo "ERROR: Model invocation produced empty raw output for $AGENT" >&2
    echo "Raw output preserved:" >&2
    echo "$RAW_FILE" >&2

    write_agent_outcome         "$AGENT" succeeded rejected_at_boundary failed empty_raw_output         "$RAW_FILE" ""

    rm -f "$FILE"
    mark_run_failed "$AGENT"

    exit 1
fi

OPEN_COUNT=$(
    grep -Fxc '<<<COUNCIL_ARTIFACT>>>' "$RAW_FILE" || true
)

CLOSE_COUNT=$(
    grep -Fxc '<<<END_COUNCIL_ARTIFACT>>>' "$RAW_FILE" || true
)

if [ "$OPEN_COUNT" -ne 1 ] || [ "$CLOSE_COUNT" -ne 1 ]; then
    echo "ERROR: Invalid artifact boundary for $AGENT" >&2
    echo "Opening markers: $OPEN_COUNT" >&2
    echo "Closing markers: $CLOSE_COUNT" >&2
    echo "Raw output preserved:" >&2
    echo "$RAW_FILE" >&2

    write_agent_outcome         "$AGENT" succeeded rejected_at_boundary failed invalid_boundary_count         "$RAW_FILE" ""

    rm -f "$FILE"
    mark_run_failed "$AGENT"

    exit 1
fi

OPEN_LINE=$(
    grep -Fnx '<<<COUNCIL_ARTIFACT>>>' "$RAW_FILE" |
    cut -d: -f1
)

CLOSE_LINE=$(
    grep -Fnx '<<<END_COUNCIL_ARTIFACT>>>' "$RAW_FILE" |
    cut -d: -f1
)

if [ "$OPEN_LINE" -ge "$CLOSE_LINE" ]; then
    echo "ERROR: Artifact markers out of order for $AGENT" >&2
    echo "Raw output preserved:" >&2
    echo "$RAW_FILE" >&2

    write_agent_outcome         "$AGENT" succeeded rejected_at_boundary failed boundary_order_invalid         "$RAW_FILE" ""

    rm -f "$FILE"
    mark_run_failed "$AGENT"

    exit 1
fi

TMP_FILE="${FILE}.tmp"

awk '
    /^<<<COUNCIL_ARTIFACT>>>$/ {
        capture=1
        next
    }

    /^<<<END_COUNCIL_ARTIFACT>>>$/ {
        exit
    }

    capture {
        print
    }
' "$RAW_FILE" > "$TMP_FILE"

if ! grep -q '[^[:space:]]' "$TMP_FILE"; then
    echo "ERROR: Extracted artifact is empty for $AGENT" >&2
    echo "Raw output preserved:" >&2
    echo "$RAW_FILE" >&2

    write_agent_outcome         "$AGENT" succeeded rejected_at_boundary failed empty_extracted_artifact         "$RAW_FILE" ""

    rm -f "$TMP_FILE" "$FILE"
    mark_run_failed "$AGENT"

    exit 1
fi

mv "$TMP_FILE" "$FILE"

AGENT_STATUS="succeeded"
AGENT_REASON="success"

echo "Raw saved:"
echo "$RAW_FILE"

if [ "$AGENT" = "fool" ]; then
    FOOL_OUTPUT="$FILE"
    FOOL_ARTIFACT_ID="$PROJECT/analysis/$(basename "$FILE")"
    FOOL_RECORD_ID="${PROJECT//\//_}-$(basename "${FILE%.md}")"
fi

echo "Saved:"
echo "$FILE"

#
# R0.5-002 durable epistemic disposition
#
# The Judge supplies only the institutional adjudication.
# Artifact identity and epistemic status remain runtime-owned.
#
if [ "$AGENT" = "judge" ] && [ -n "$FOOL_OUTPUT" ]; then

    FOOL_DISPOSITION_COUNT=$(
        grep -Ec '^FOOL_DISPOSITION: (accepted_into_memory|rejected|deferred|withheld_from_memory)$' "$FILE" || true
    )

    if [ "$FOOL_DISPOSITION_COUNT" -ne 1 ]; then
        echo "ERROR: Judge must provide exactly one valid Fool disposition" >&2
        echo "Found: $FOOL_DISPOSITION_COUNT" >&2
        echo "Expected one of:" >&2
        echo "  accepted_into_memory" >&2
        echo "  rejected" >&2
        echo "  deferred" >&2
        echo "  withheld_from_memory" >&2

        write_agent_outcome             "$AGENT" succeeded promoted failed invalid_judge_disposition             "$RAW_FILE" "$FILE"

        mark_run_failed "$AGENT"

        exit 1
    fi

    FOOL_DISPOSITION_DECISION=$(
        grep -E '^FOOL_DISPOSITION: (accepted_into_memory|rejected|deferred|withheld_from_memory)$' "$FILE" |
        sed 's/^FOOL_DISPOSITION: //'
    )

    DISPOSITION_FILE="$KNOWLEDGE/entries/disposition-$FOOL_RECORD_ID.md"

    {
        echo "---"
        echo "type: disposition_record"
        echo "artifact_id: $FOOL_ARTIFACT_ID"
        echo "epistemic_status: $FOOL_EPISTEMIC_STATUS"
        echo "disposition: $FOOL_DISPOSITION_DECISION"
        echo "created: $(date +%Y-%m-%d)"
        echo "---"
        echo

        if [ "$FOOL_DISPOSITION_DECISION" = "accepted_into_memory" ]; then
            echo "## Artifact Snapshot"
            echo
            cat "$FOOL_OUTPUT"
        fi
    } > "$DISPOSITION_FILE"

    echo "Disposition record:"
    echo "$DISPOSITION_FILE"
fi

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

        write_agent_outcome             "$AGENT" succeeded promoted failed archivist_entry_empty             "$RAW_FILE" "$FILE"

        mark_run_failed "$AGENT"

        exit 1
    fi

    if ! grep -q "ARCHIVAL REPORT" "$KNOWLEDGE_FILE"; then
        echo "ERROR: Knowledge entry missing archival report"
        rm "$KNOWLEDGE_FILE"

        write_agent_outcome             "$AGENT" succeeded promoted failed archivist_report_missing             "$RAW_FILE" "$FILE"

        mark_run_failed "$AGENT"

        exit 1
    fi

    if [ "$(wc -c < "$KNOWLEDGE_FILE")" -lt 1000 ]; then
        echo "ERROR: Knowledge entry suspiciously small"
        rm "$KNOWLEDGE_FILE"

        write_agent_outcome             "$AGENT" succeeded promoted failed archivist_entry_too_small             "$RAW_FILE" "$FILE"

        mark_run_failed "$AGENT"

        exit 1
    fi
else

    rm "$KNOWLEDGE_FILE"
    echo "Archivist failed validation. No knowledge entry created."

    AGENT_STATUS="failed"
    AGENT_REASON="archivist_report_missing"

fi

    echo "Knowledge entry:"
    echo "$KNOWLEDGE_FILE"

fi

    write_agent_outcome         "$AGENT" succeeded promoted "$AGENT_STATUS" "$AGENT_REASON"         "$RAW_FILE" "$FILE"

    if [ "$AGENT_STATUS" = "succeeded" ]; then
        COMPLETED_AGENTS=$((COMPLETED_AGENTS + 1))
    else
        NONFATAL_AGENT_FAILURE=1
    fi

    CURRENT_AGENT=""
    write_run_state

    OUTPUTS+=("$FILE")

    if [ "$AGENT" = "editor" ]; then
        EDITOR_OUTPUT="$FILE"
    fi

    if [ "$AGENT" = "judge" ]; then
        JUDGE_OUTPUT="$FILE"
    fi

done

#
# R0.5-009 terminal publication integrity
#
# All successful per-agent outcomes are already durable here.
#
# The final run record is prepared in a noncanonical temporary path and
# atomically published first. The canonical completed whole-run state is
# published last.
#
# Until that final state publication succeeds, RUN_STATUS deliberately
# remains "running" so R0.5-006 interruption handling remains active.
#

if [ "$NONFATAL_AGENT_FAILURE" -eq 1 ]; then
    TERMINAL_RUN_REASON="completed_with_agent_failure"
else
    TERMINAL_RUN_REASON="success"
fi

#
# Prepare research run record in a noncanonical temporary file.
#
RUN_FILE="$BASE/runs/run-$RUN_ID.md"
RUN_FILE_TMP="${RUN_FILE}.tmp"

cp "$HOME/research-council/templates/run-template.md" "$RUN_FILE_TMP"

sed -i "s/{{RUN_ID}}/$RUN_ID/g" "$RUN_FILE_TMP"
sed -i "s/{{PROJECT}}/$PROJECT/g" "$RUN_FILE_TMP"
sed -i "s/{{DATE}}/$(date +%Y-%m-%d)/g" "$RUN_FILE_TMP"
sed -i "s/{{MODEL}}/$MODEL/g" "$RUN_FILE_TMP"
sed -i "s/{{QUESTION}}/$QUESTION/g" "$RUN_FILE_TMP"

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

} >> "$RUN_FILE_TMP"

# Atomic same-filesystem publication of the complete run record.
mv "$RUN_FILE_TMP" "$RUN_FILE"

#
# Publish terminal whole-run state LAST.
#
# Explicit values are supplied so global RUN_STATUS remains "running"
# until the atomic state replacement has successfully returned. If a
# catchable signal arrives before that point, R0.5-006 may still publish
# interrupted state.
#
write_run_state "completed" "$TERMINAL_RUN_REASON" "" ""

# The durable terminal representation is now complete.
RUN_STATUS="completed"
RUN_REASON="$TERMINAL_RUN_REASON"
CURRENT_AGENT=""
FAILED_AGENT=""

trap - INT TERM HUP

echo
echo "Run record:"
echo "$RUN_FILE"

echo
echo "Council run complete."
