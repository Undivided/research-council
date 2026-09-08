# Institutional Intelligence Results

## Research Council Project

## Experimental Results

Status:

**Research Council v0.1 baseline benchmark completed**

---

# Purpose

This document records experimental outcomes from the Research Council benchmark studies.

Conclusions below are limited to the completed v0.1 benchmark and should be treated as provisional pending reproducibility review.

---

# Research Question

> If the same mind is given a better institution, does it perform better?

---

# Experimental Status

Completed:

- Hypothesis defined
- Benchmark protocol defined
- Council architecture v0.1 operational
- Testing environment established

Benchmark work:

- Baseline single-agent measurements — completed
- Council measurements — completed
- Scoring analysis — completed
- Failure analysis — completed
- Reproducibility review — pending

---

# Results

## Aggregate Benchmark Scores
| Experiment | Single | Self-Critique | Council v0.1 | Winner |
|---|---:|---:|---:|---|
| 001 — Bronze Age Collapse | 7.35 | 7.70 | 3.05 | Self-Critique |
| 002 — Growth vs. Environment | 7.78 | 8.45 | 5.03 | Self-Critique |
| 003 — Adversarial Impossible Premise | 3.35 | 6.00 | 8.55 | Council v0.1 |
| 004 — Strategic Planning | 7.83 | 8.55 | 8.02 | Self-Critique |
| **Mean (001–004)** | **6.58** | **7.68** | **6.16** | **Self-Critique** |

## Experiment 005 — Memory Continuity

### 005A — Native Memory Pipeline

**Result: FAIL at ingestion.**

The Researcher generated substantive new ecology knowledge, but that same-run specialist output did not reach the Editor. The Editor therefore reported a knowledge gap, and the Archivist stored that gap instead of the newly generated research.

Observed chain:

Researcher produces valid domain knowledge → same-run handoff fails → Editor reports knowledge gap → Archivist preserves incomplete memory.

### 005B — Controlled Memory Retrieval

**Result: PASS.**

When the valid Session-1 Researcher report was manually inserted into the institutional knowledge base before Session 2, the later Editor retrieved and used that knowledge coherently in a related invasive-species assessment task.

Interpretation:

Retrieval of valid institutional memory works. The primary v0.1 memory failure is the ingestion path that should convert new specialist work into durable knowledge.

---

# Conclusions

The v0.1 benchmark does not support the simple claim that a multi-agent council is universally better than a single model.

Across Experiments 001–004, the self-critique condition achieved the highest mean score. Research Council v0.1 performed poorly when questions required new domain knowledge to propagate through the same run, but performed strongly when the task aligned with knowledge already present in institutional memory or benefited from adversarial role conditioning.

The central architectural finding is that v0.1 successfully generates differentiated specialist intelligence, but does not reliably transmit that intelligence to later synthesis and archival stages.

In short:

**The components are capable; the information topology is the primary failure.**

---

# Future Work

Research Council v0.1 will remain frozen as the experimental baseline.

The primary v0.2 change should target **information topology**, not model capability. Newly generated specialist reports should be made available to later synthesis and archival stages while holding the underlying model, benchmark questions, role definitions, and scoring procedure as constant as practical.

The v0.1 benchmark battery should then be rerun to test whether improved same-run information flow increases institutional performance.

Additional work:

- Perform a formal reproducibility review of the v0.1 results.
- Separate memory ingestion from memory retrieval in future memory benchmarks.
- Measure whether individual specialist roles contribute unique information or redundant reasoning.
- Evaluate structured disagreement and contradiction resolution.
- Preserve the proposed systems-science Judge as a later experimental condition rather than introducing it into the first topology repair.
- Compare future Council versions against both single-agent and self-critique baselines.

The next experimental question is therefore narrower than the original hypothesis:

> If the same agents are connected by a better information topology, does the institution perform better?
