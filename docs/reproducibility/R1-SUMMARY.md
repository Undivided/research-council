# R1 Reproducibility Review Summary

## Status

Completed.

## Purpose

R1 evaluated whether the Research Council v0.1 benchmark could be reproduced from its recorded execution revision and whether the original experimental conditions were sufficiently preserved.

## Review Scope

The review began from execution revision `9333b16` in a separate Git worktree.

The review examined:

- code and model configuration
- benchmark repeatability
- semantic behavior across repeated cloud-model runs
- filesystem and environment assumptions
- institutional knowledge state
- artifact isolation and preservation

## Findings

### R1-001 — Environment Coupling

The v0.1 runtime was not fully portable because multiple scripts assumed the fixed path `$HOME/research-council/`.

This caused Council outputs launched from the reproducibility worktree to be written into the original repository.

### R1-002 — Semantic Variance

Repeated runs using the same configured cloud model identifier produced different text while preserving recognizable reasoning behavior.

Exact textual identity is therefore not an appropriate reproducibility criterion for this benchmark.

### R1-003 — Knowledge State Drift

The first reproducibility attempt created new institutional memory in the original repository because of the environment coupling.

The subsequent run encountered that new memory, changing the cognitive condition and materially altering the Researcher response.

Institutional knowledge state must therefore be treated as an experimental variable.

## Evidence Preservation

The 22 cross-worktree contamination artifacts produced during R1 were preserved before cleanup.

They are archived under:

    benchmarks/archive/repro-r1/cross-worktree-contamination/

The archive contains the original 22 files plus a manifest recording their paths.

After archival verification, the accidental files were removed from the original repository and the original working tree returned to a clean state.

## Experimental Controls Added

R1 established that future experiments must record or control more than source revision and model identity.

The resulting control framework is documented in:

    docs/reproducibility/EXPERIMENTAL-CONTROLS.md

Important controlled variables now include:

- code revision
- model configuration
- exact benchmark input
- role and institutional structure
- knowledge state
- retrieval context
- runtime environment
- artifact destination and preservation

## Conclusion

Research Council v0.1 is reproducible at the level of architecture and recognizable behavior, but the R1 review identified environment coupling and uncontrolled knowledge-state drift that prevent strict reconstruction of the original cognitive condition from code and model identity alone.

The original benchmark record remains useful as the frozen v0.1 baseline.

Future Research Council experiments should treat memory, retrieval, and runtime environment as first-class components of the experimental condition.
