#!/bin/bash

MODEL="gemma4:31b-cloud"

QUESTION="$*"

if [ -z "$QUESTION" ]; then
    echo "Usage: ./benchmarks/run-self-critique.sh \"question\""
    exit 1
fi

printf "%s\n\n%s\n" "$QUESTION" "After answering, review your answer. Identify weaknesses, then improve your response." | ollama run "$MODEL"
