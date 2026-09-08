#!/bin/bash

PROJECT="benchmark-v0.1"

QUESTION="$*"

if [ -z "$QUESTION" ]; then
    echo "Usage: ./benchmarks/run-council-v0.1.sh \"question\""
    exit 1
fi

./scripts/run-council.sh "$PROJECT" "$QUESTION"
