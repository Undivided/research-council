# Turtle Review 124 — Knowledge Migration Contract

## Context

First-class provenance introduced a metadata contract for knowledge entries.

A metadata validation pass identified older knowledge artifacts that do not match the current format.

---

## Observation

Not all metadata failures represent corrupted or invalid knowledge.

Some artifacts were created before the current knowledge object contract existed.

Example:

- entry-131239.md

This artifact contains previous Council output but does not contain current metadata headers.

---

## Discovery

Knowledge objects have generations.

A knowledge artifact may represent:

- current contract object
- legacy object
- invalid object

The system must distinguish these cases.

---

## Principle

Migration should preserve historical artifacts while making their relationship to current contracts explicit.

The evolution history of the knowledge system is itself provenance.

---

## Object Categories

### Current Object

Definition:

A knowledge artifact that satisfies the active metadata contract.

Requirements:

- identity
- provenance
- confidence
- creation information

---

### Legacy Object

Definition:

A knowledge artifact created before the current contract.

Characteristics:

- content may still be valuable
- provenance may be incomplete
- migration should preserve original content

---

### Invalid Object

Definition:

An artifact that cannot be interpreted as a valid knowledge object.

Examples:

- corrupted content
- incomplete generation
- missing required information

---

## Migration Principle

Do not erase historical artifacts during migration.

Migration should add understanding, not replace history.

---

## Future Direction

The metadata validation system may evolve from simple format checking toward object classification:

- current object validation
- legacy detection
- invalid artifact reporting

---

## Constraint

The Council should preserve not only knowledge, but the history of how its knowledge representation evolved.
