# Knowledge Metadata Standard

This file defines the labels placed at the top of knowledge files.

These labels help future tools organize and retrieve information.

---

## Required Fields

id:

A unique identifier for the knowledge file.

Example:
112516


type:

The kind of knowledge stored.

Examples:

- research_entry
- system_memory
- decision
- failure
- improvement


domain:

The broad subject area.

Example:

- scientific_decision_making
- AI
- history


topics:

Important concepts contained in the file.

Example:

- bias
- peer_review
- open_science


confidence:

How reliable the information is.

Options:

- low
- medium
- high


created:

Date the file was created.

Example:

2026-09-07

---

## Purpose

Metadata allows the Research Council to organize knowledge by meaning instead of only file names or keywords.

Markdown files remain the source of truth.
