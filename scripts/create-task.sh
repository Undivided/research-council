#!/usr/bin/env bash

# Research Council Task Generator
# Creates a new project workspace from templates.

set -e

PROJECT_NAME="$1"
QUESTION="$2"

if [ -z "$PROJECT_NAME" ] || [ -z "$QUESTION" ]; then
    echo "Usage:"
    echo "./scripts/create-task.sh project-name \"research question\""
    exit 1
fi

BASE="$HOME/research-council"
PROJECT="$BASE/projects/$PROJECT_NAME"

if [ -d "$PROJECT" ]; then
    echo "Error: Project already exists:"
    echo "$PROJECT"
    exit 1
fi

echo "Creating project:"
echo "$PROJECT"

mkdir -p "$PROJECT"/{analysis,sources,notes,debates,reports,tasks}

DATE=$(date +%Y-%m-%d)
TASK_ID="task-001"

cp "$BASE/projects/world-assessment-2026/mission.md" "$PROJECT/mission.md"
cp "$BASE/projects/world-assessment-2026/question.md" "$PROJECT/question.md"

for TEMPLATE in "$BASE"/templates/*-template.md
do
    NAME=$(basename "$TEMPLATE" "-template.md")

    OUTPUT="$PROJECT/analysis/${NAME}-${TASK_ID}.md"

    sed \
        -e "s/{{TASK_ID}}/$TASK_ID/g" \
        -e "s/{{DATE}}/$DATE/g" \
        -e "s/{{QUESTION}}/$QUESTION/g" \
        "$TEMPLATE" > "$OUTPUT"

    echo "Created:"
    echo "$OUTPUT"
done

cat > "$PROJECT/tasks/$TASK_ID.md" <<EOF
# Task 001

## Question

$QUESTION

## Assigned Agents

- Researcher
- Historian
- Philosopher
- Strategist
- Skeptic
- Red Team
- Editor

## Required Output

Each agent must provide:

- Observations
- Evidence
- Analysis
- Unknowns
- Classification
- Confidence level
- Reason for confidence
EOF

echo
echo "Research Council project created successfully."
echo
echo "Location:"
echo "$PROJECT"
