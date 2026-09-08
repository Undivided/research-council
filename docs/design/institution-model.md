# Research Council Institution Model

## Purpose

This document describes how Research Council organizes specialized cognition into a durable institutional structure.

The institution model sits above the cognition model.

The cognition model describes the components that shape behavior. The institution model describes how those components are organized, coordinated, and preserved across time.

## Core Idea

Research Council is not defined by any single agent.

Agents are specialized cognitive roles operating inside a larger institution.

The institution provides:

- role structure
- coordination
- critique
- adjudication
- memory
- provenance
- continuity

## Institutional Layers

The institution can be organized in layers.

### Core Council

The Core Council provides general-purpose cognitive functions such as research, historical context, philosophical analysis, strategy, skepticism, adversarial review, synthesis, archival memory, and retrieval.

### Domain Councils

Domain Councils are persistent collections of specialized expertise built on top of the Core Council.

Examples may include health, engineering, law, philosophy, finance, or education.

### Project Councils

Project Councils are temporary assemblies created around a specific goal or decision.

A project may draw roles from multiple domains depending on the problem being solved.

## Baseline and Future Design

Research Council v0.1 implements the Core Council role structure only.

Domain Councils, Project Councils, formal adjudication, and dynamic role assembly are future architectural directions and should not be treated as capabilities of the v0.1 baseline.

## Target Institutional Flow

The intended institutional workflow is:

    Human objective
        ↓
    Appropriate council or project assembly
        ↓
    Specialist analysis
        ↓
    Skeptical and adversarial challenge
        ↓
    Synthesis
        ↓
    Adjudication when required
        ↓
    Human decision or action
        ↓
    Archival review
        ↓
    Durable institutional memory

This is a target architecture rather than a description of the complete v0.1 implementation.

Research Council v0.1 invokes specialist roles sequentially but does not reliably transfer their current-run outputs into later synthesis or archival stages.

## Human Authority

The institution is intended to support human judgment rather than replace it.

Council outputs may inform, challenge, or structure a decision, but final authority remains with the human operator unless explicitly delegated for a bounded task.

## Role Assembly

Roles should be selected according to the problem rather than invoked universally.

The Core Council provides reusable cognitive functions, while domain and project councils may add specialized expertise only when relevant.

This allows the institution to grow by composition rather than by forcing every available role into every task.

Example:

    Engineering project
        + Systems Engineer
        + Regulatory or Zoning Specialist
        + Financial Analyst
        + Safety Reviewer
        + Core skeptical and synthesis functions

## Memory Ownership

Institutional memory should be durable but scoped.

General knowledge may belong to the Core Council, while domain-specific and project-specific knowledge may remain within their respective domains or projects.

The Librarian and retrieval systems should provide access across those boundaries without requiring every agent to receive the entire knowledge base.

Memory boundaries are therefore part of institutional architecture, not merely file organization.

## Adjudication

Specialist disagreement should not be erased during synthesis.

When meaningful conflicts remain, the institution should preserve the competing claims, evidence, assumptions, and uncertainties before reaching a decision.

A future Judge role may provide formal adjudication after synthesis.

The Judge should evaluate the proposed answer as a system, including:

- interactions between components
- dependencies
- feedback loops
- tradeoffs
- uncertainty
- second-order effects
- local versus system-level consequences

The Judge should be permitted to return an insufficient-evidence verdict rather than forcing a conclusion.

Formal Judge-based adjudication is a future architectural stage and is not part of the Research Council v0.1 baseline.

## Governance Principles

The institution should preserve the following principles:

- evidence should outweigh authority
- uncertainty should remain visible
- disagreement should not be silently erased
- causal claims should require stronger support than correlation
- system boundaries should be stated when relevant
- important second-order effects and feedback loops should be considered
- insufficient evidence should remain a valid institutional conclusion
- human authority should remain explicit

## Evolution Strategy

Institutional capabilities should be added experimentally rather than all at once.

The first post-v0.1 architectural change should improve information topology so that specialist outputs can reliably reach later synthesis and archival stages.

Formal Judge-based adjudication should be evaluated only after that communication layer is functioning, allowing its contribution to be measured separately.

Richer environments such as simulations, structured world models, graphs, geometric reasoning, and specialized tools may then be introduced as later experimental layers.

The institution should grow by preserving a stable core while adding new councils, roles, tools, and environments as composable layers.
