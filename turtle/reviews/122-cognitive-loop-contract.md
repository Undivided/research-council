# Turtle Review 122 — Cognitive Loop Contract

## Context

Previous reviews identified:

- first-class provenance for knowledge entries
- typed knowledge objects
- sandbox lineage discovery

Existing Council components were inspected to determine whether the system already contains a larger cognitive pattern.

---

## Observation

The Research Council is not only an agent pipeline.

It contains recurring cognitive phases:

- exploration
- evaluation
- preservation
- retrieval

These phases already exist through separate system components.

---

## Existing Implementations

### Exploration

Component:

config/sandboxes/fool.md

Purpose:

Generate alternative frames, challenge assumptions, and produce exploratory ideas.

Classification:

EXPLORATORY

---

### Evaluation

Components:

- Editor
- Judge

Purpose:

Refine outputs, test quality, and determine whether artifacts should advance.

---

### Preservation

Component:

Archivist

Purpose:

Convert selected outputs into durable knowledge objects.

---

### Retrieval

Components:

- Librarian
- Knowledge Index

Purpose:

Make preserved knowledge available to future Council activity.

---

## Cognitive Loop

The emerging pattern:

Exploration
↓
Evaluation
↓
Preservation
↓
Retrieval
↓
New Exploration

---

## Principle

The Council should preserve the conditions that generate useful novelty.

Optimizing only for certainty risks removing the exploration mechanisms that create new discoveries.

---

## Design Constraint

Do not merge exploratory output directly into institutional memory.

Maintain:

- provenance
- uncertainty
- human-readable lineage
- promotion boundaries

---

## Future Direction

Future Council evolution should focus on improving the loop:

- better exploration
- better selection
- better memory
- better retrieval
- clearer human understanding

without collapsing the distinctions between these phases.
