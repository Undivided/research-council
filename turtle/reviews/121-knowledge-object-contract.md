# Turtle Review 121 — Knowledge Object Contract

## Context

Commit 120 introduced first-class provenance metadata into research entries.

A live Council validation run revealed that the knowledge layer contains multiple object types:

- research_entry
- disposition_record
- agent_outcome
- council_run_state

## Observation

The Research Council does not store a single type of knowledge artifact.

It stores typed memory objects created by different system processes.

## Principle

Knowledge objects require explicit identity and boundaries.

The system should distinguish:

- what an object is
- where it came from
- who created it
- how it entered memory
- how confident the system is

## Initial Object Families

### research_entry

Purpose:
Durable synthesized knowledge.

### disposition_record

Purpose:
Memory admission decisions.

### agent_outcome

Purpose:
Agent execution provenance.

### council_run_state

Purpose:
Runtime continuity.

## Future Direction

The knowledge layer should evolve from a collection of markdown files into a typed memory system while preserving:

- human readability
- provenance
- uncertainty
- explainability

## Design Constraint

Do not create complexity before needed.

The contract should emerge from actual system behavior.
