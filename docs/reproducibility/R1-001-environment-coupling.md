# R1-001 — Environment Coupling

## Status

Identified during reproducibility review.

## Summary

The v0.1 benchmark execution environment was not fully self-contained across Git worktrees.

## Observation

A fresh worktree checked out at execution revision `9333b16` successfully launched the benchmark, but Research Council artifact output was written to the original repository path.

## Cause

Multiple scripts assume the installation path:

    $HOME/research-council/

Examples include:

    scripts/run-council.sh
    scripts/get-context.sh
    scripts/build-index.sh

## Impact

The original v0.1 results remain valid. However, a fresh clone or alternate worktree does not reproduce a fully isolated institutional environment without recreating the original filesystem path.

## Classification

Information topology / environment topology failure.

## Future Correction

Future versions should derive paths from the active repository root or an explicit configurable workspace path.
