# Research Council v0.1 — Experimental Manifest

Experiment ID: benchmark-v0.1

## Model Configuration

Provider: Ollama Cloud
Model: `gemma4:31b-cloud`

The same configured model identifier was used for Condition A, Condition B, and every Research Council v0.1 role.

## Architecture and Code Provenance

Council architecture: `v0.1`
Baseline tag: `v0.1`
Results commit: `b3a0abd`
Specimen commit: `03d9f3e`
Branch: `master`

Benchmark harness revision: `9333b16`
Execution repository revision: `9333b16`

## Model Assignment by Condition and Role

Condition A — Single Agent: `gemma4:31b-cloud`
Condition B — Self-Critique: `gemma4:31b-cloud`

Researcher: `gemma4:31b-cloud`
Historian: `gemma4:31b-cloud`
Philosopher: `gemma4:31b-cloud`
Strategist: `gemma4:31b-cloud`
Skeptic: `gemma4:31b-cloud`
Red Team: `gemma4:31b-cloud`
Editor: `gemma4:31b-cloud`
Archivist: `gemma4:31b-cloud`
Librarian: `gemma4:31b-cloud`

## Benchmark Runs

001 — Bronze Age Collapse: `20260908-072414`
002 — Growth vs. Environment: `20260908-075324`
003 — Adversarial Impossible Premise: `20260908-080928`
004 — Strategic Planning: `20260908-084007`
005A — Native Memory Pipeline: `20260908-085009`
005B — Controlled Memory Retrieval: `20260908-090341`

## Platform Context

Hermes Agent served as an early agent-platform testbed during development, but it was not part of the Research Council v0.1 benchmark execution path. The v0.1 Council was orchestrated directly by the Research Council scripts through Ollama.

## Reproducibility Caveat

The recorded model identifier is `gemma4:31b-cloud`. Because this is a cloud-served model alias, the exact underlying provider revision may not be immutable unless Ollama exposes a version or digest. Future experiments should record any available model revision, digest, or provider-side identifier in addition to the model string.

## Controlled Memory Exception — 005B

For Experiment 005B, the valid Session-1 Researcher report was temporarily copied into `knowledge/entries/benchmark-session1-invasive-species.md` before the Session-2 run. This was a deliberate intervention used to isolate memory retrieval from memory ingestion. The temporary entry was removed immediately after the run and was not retained in the live knowledge base.
