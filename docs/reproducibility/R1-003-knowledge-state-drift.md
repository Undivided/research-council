# R1-003 — Knowledge State Drift

## Status

Identified during reproducibility review.

## Summary

The knowledge state available to Research Council changed between the original benchmark and the reproducibility run.

The code, configured model identifier, and benchmark question were held constant, but the Researcher received different institutional memory and produced materially different reasoning.

## Observation

During the original Experiment 001 run, the Researcher reported that the knowledge base contained no relevant Bronze Age Collapse material.

During the reproducibility run, the Researcher reported that `entry-102422.md` was relevant to the Bronze Age Collapse.

## Contamination Mechanism

Evidence indicates that `entry-102422.md` was created during the first R1 reproducibility attempt.

Because the v0.1 scripts were coupled to `$HOME/research-council/`, the Council wrote this knowledge entry into the original repository rather than the isolated reproducibility worktree.

The benchmark harness performed its cleanup against the reproducibility worktree, so it did not remove the knowledge entry that had been written into the original repository.

The subsequent reproducibility run therefore began with institutional memory that had not existed during the original Experiment 001 baseline.

## Impact

The reproduction was not a valid isolation of the original Experiment 001 cognitive condition because the institutional memory state had changed.

The model identifier, role architecture, and benchmark prompt alone were insufficient to reproduce the original behavior.

Future experiments must treat knowledge state as an experimental variable and preserve:

- code revision
- model identifier
- benchmark prompt
- knowledge database snapshot
- retrieval context

## Interpretation

The Research Council experiments demonstrate that cognition is not solely determined by the underlying model.

Behavior emerges from the interaction between model, roles, memory, retrieval, and environmental constraints.
