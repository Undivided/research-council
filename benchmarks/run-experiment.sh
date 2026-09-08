#!/bin/bash

QUESTION="$*"

if [ -z "$QUESTION" ]; then
    echo "Usage: ./benchmarks/run-experiment.sh \"question\""
    exit 1
fi

RUN_ID=$(date +%Y%m%d-%H%M%S)
RESULT_DIR="benchmarks/results/$RUN_ID"

mkdir -p "$RESULT_DIR"

echo "Benchmark run: $RUN_ID"
echo "Results: $RESULT_DIR"

echo
echo "Running Condition A — Single Agent"
./benchmarks/run-single.sh "$QUESTION" > "$RESULT_DIR/condition-a-single.md"

echo "Saved: $RESULT_DIR/condition-a-single.md"

echo
echo "Running Condition B — Self-Critique"
./benchmarks/run-self-critique.sh "$QUESTION" > "$RESULT_DIR/condition-b-self-critique.md"

echo "Saved: $RESULT_DIR/condition-b-self-critique.md"

echo
echo "Running Condition C — Research Council v0.1"
touch "$RESULT_DIR/.council-start"
./benchmarks/run-council-v0.1.sh "$QUESTION" > "$RESULT_DIR/condition-c-council.log"

echo "Saved: $RESULT_DIR/condition-c-council.log"
mkdir -p "$RESULT_DIR/condition-c-artifacts"

find projects/benchmark-v0.1 \
    -type f \
    -newer "$RESULT_DIR/.council-start" \
    -exec cp --parents {} "$RESULT_DIR/condition-c-artifacts/" \;
