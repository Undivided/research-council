# Research Council Architecture Review — v0.1

## Purpose

This document records the architecture that Research Council v0.1 actually implements.

It distinguishes:

1. Intended architecture
2. Implemented architecture
3. Observed agent behavior
4. Architectural gaps
5. Risks and failure modes

This is an architectural baseline, not a redesign proposal.

The purpose is to understand the existing system before modifying it.

---

# 1. Intended Architecture

The documented architecture describes the Council as an institutional reasoning system.

Human Question
→ Research Agents
→ Analysis Reports
→ Editor Synthesis
→ Archivist Extraction
→ Knowledge Base
→ Librarian Retrieval
→ Future Research

---

# 2. Implemented Architecture

The v0.1 runner invokes the Council agents sequentially.

However, sequential execution does not currently mean deliberation.

Each agent receives:

- The research question
- Retrieved context
- The accumulated knowledge base
- Its assigned role

The output produced by one analysis agent is not explicitly passed to the next analysis agent.

Therefore, the current implementation is better described as a panel of independent specialist analyses than as a conversational multi-agent deliberation system.

---

# 3. Observed Agent Behavior

The agents currently operate with substantial independence.

This has both strengths and limitations.

Strengths:

- Reduces direct anchoring between agents
- Reduces conformity pressure
- Preserves genuinely different role-based analyses
- Creates a useful baseline for future deliberative architectures

Limitations:

- Agents cannot directly challenge another agent's specific claims
- The Skeptic critiques the problem independently rather than interrogating peer reports
- The Red Team cannot directly attack conclusions produced earlier in the run
- The Editor does not yet receive a structured debate produced by the preceding agents

The current architecture therefore provides diversity of analysis, but not yet true inter-agent deliberation.

---

# 4. Architectural Gaps

The largest gap between the documented architecture and the implementation is the absence of an explicit deliberation stage.

The intended flow implies that analysis is progressively examined, challenged, and synthesized.

The current runner instead produces largely independent reports.

Additional gaps include:

- No structured exchange between agents
- No explicit mechanism for resolving contradictions
- No formal comparison of competing conclusions
- No dedicated judging or adjudication stage
- No systematic measurement of agent contribution
- No mechanism for determining whether additional agents improve the final result

These gaps should be treated as experimental questions rather than assumed defects.

The benchmark should determine whether adding institutional structure actually improves reasoning quality.

---

# 5. Risks and Failure Modes

## Context Overload

The current system can inject large amounts of accumulated knowledge into agent prompts.

As the knowledge base grows, this may increase cost, dilute relevant evidence, and reduce reasoning quality.

## Institutional Error Propagation

Archived conclusions can influence future investigations.

If weak or incorrect conclusions enter institutional memory, the Council may repeatedly reinforce them.

## False Consensus

The Editor may produce a coherent synthesis even when the underlying reports genuinely disagree.

Coherence must not be mistaken for consensus or truth.

## Redundant Reasoning

Multiple agents do not automatically produce multiple independent insights.

Different roles may generate substantially overlapping reasoning while increasing computational cost.

## Weak Adversarial Pressure

The Skeptic and Red Team cannot fully challenge Council conclusions until they can inspect claims produced by other agents.

## Memory Gatekeeping

The Archivist determines which temporary conclusions become durable institutional knowledge.

This makes archival behavior an important epistemic control point in the system.

---

# 6. v0.1 Baseline

Research Council v0.1 should be preserved as an experimental baseline.

Its defining characteristics are:

- One shared underlying model
- Multiple specialized agent roles
- Largely independent analysis
- Shared access to institutional knowledge
- Separate skeptical and adversarial roles
- Editor synthesis
- Archivist extraction into durable memory
- Librarian participation in the Council
- No explicit inter-agent deliberation stage

This baseline is scientifically useful because future architectural changes can be compared against it.

The central question is not whether a more complicated Council can be built.

The central question is whether additional institutional structure measurably improves the quality, reliability, and durability of reasoning.

Changes to the architecture should therefore be evaluated experimentally rather than assumed to be improvements.
