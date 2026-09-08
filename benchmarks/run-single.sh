#!/bin/bash

MODEL="gemma4:31b-cloud"

QUESTION="$*"

if [ -z "$QUESTION" ]; then
    echo "Usage: ./benchmarks/run-single.sh \"question\""
    exit 1
fi

echo "$QUESTION" | ollama run "$MODEL"
