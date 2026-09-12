# Turtle Review 125 — Metadata Retrieval Boundary

## Context

Previous reviews established:

- first-class provenance
- knowledge object contracts
- cognitive phase boundaries
- migration rules

The knowledge metadata standard and retrieval scripts were inspected.

---

## Observation

The Research Council already defines metadata intended to organize knowledge by meaning:

- type
- domain
- topics
- confidence
- creation date

However, current retrieval primarily operates through text matching.

Current retrieval flow:

Question
↓
Term extraction
↓
Keyword matching
↓
Context injection

---

## Discovery

The knowledge model and retrieval implementation are at different maturity levels.

The metadata contract describes a semantic organization layer, while current retrieval remains primarily lexical.

---

## Principle

Knowledge retrieval should evolve from locating documents toward understanding knowledge objects.

Future retrieval may consider:

- object type
- domain
- topics
- confidence
- provenance
- relationships
- uncertainty

---

## Constraint

Do not replace human-readable knowledge files with opaque retrieval systems.

Markdown remains the source of truth.

Retrieval systems should enhance access to knowledge, not hide the knowledge itself.

---

## Future Direction

The Librarian role may evolve from index maintenance toward knowledge relationship management.

The next retrieval layer should build on the existing metadata contract rather than create a separate knowledge representation.
# Turtle Review 125 — Metadata Retrieval Boundary

## Context

Previous reviews established:

- first-class provenance for knowledge entries
- typed knowledge objects
- cognitive phase boundaries
- knowledge migration rules

The knowledge metadata standard and retrieval scripts were inspected to understand the current relationship between stored knowledge and retrieved context.

---

## Observation

The Research Council already defines metadata intended to organize knowledge beyond filenames.

Current metadata fields include:

- id
- type
- domain
- topics
- confidence
- created

The metadata standard states that these labels help future tools organize and retrieve information.

---

## Current Retrieval Behavior

The current retrieval process operates primarily through keyword matching.

Current flow:

Question
↓
Term extraction
↓
Text matching
↓
Context injection

This allows relevant files to be located, but does not yet explicitly use knowledge metadata.

---

## Discovery

The knowledge representation layer and retrieval layer are at different stages of development.

The system has a metadata contract describing knowledge objects, while retrieval currently relies primarily on textual matching.

---

## Principle

Retrieval should build on the existing knowledge object contract.

Knowledge objects should remain the source of truth.

Retrieval mechanisms should improve access to knowledge without replacing or obscuring the underlying objects.

---

## Design Constraint

Do not optimize retrieval independently from the knowledge model.

Improved retrieval over poorly defined knowledge objects does not necessarily produce improved understanding.

---

## Future Direction

Future retrieval improvements should consider existing knowledge structure:

- object type
- domain
- topics
- confidence
- provenance

while preserving:

- human readability
- explainability
- uncertainty
- lineage
