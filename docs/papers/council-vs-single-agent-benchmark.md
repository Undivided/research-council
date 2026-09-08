Research Council Benchmark Study
Comparing Single-Agent AI Reasoning Against Multi-Agent Deliberation

Research Council Project
Experimental Proposal v0.1

Abstract

Large language models demonstrate significant reasoning capabilities, but their performance is affected by limitations including hallucination, premature conclusions, insufficient self-critique, and lack of persistent institutional memory.

This study investigates whether a structured multi-agent deliberation framework can improve practical reasoning performance when compared against the same underlying model operating as a single agent.

The hypothesis:

A model embedded within a structured reasoning process may outperform the same model operating without that process.

The experiment compares identical AI models under different architectural conditions:

Single-agent response generation
Single-agent self-critique prompting
Multi-agent Research Council deliberation

The objective is not to measure raw model capability, but the effect of reasoning architecture.

Research Question

Does structured cognitive division improve AI reliability, reasoning quality, and decision-making?

Hypothesis

A multi-agent council architecture will improve:

error detection
assumption identification
uncertainty calibration
strategic planning
response completeness

without requiring changes to model weights or additional training.

Experimental Setup
Model Control

The same AI model will be used in all conditions.

Initial test model:

Gemma 4 31B Cloud

Future tests may include:

local models
other cloud models
smaller parameter models
Experimental Conditions
Condition A — Single Agent

The model receives:

Answer the user's question.

No additional structure.

Condition B — Self-Critique Agent

The model receives:

Answer the question.

Then review your answer.
Identify weaknesses.
Improve your response.

This measures the effect of simple reflection.

Condition C — Research Council

The model operates through specialized roles:

Researcher
     |
Historian
     |
Philosopher
     |
Strategist
     |
Skeptic
     |
Red Team
     |
Editor
     |
Archivist
     |
Librarian

Each role contributes a specialized perspective.

Evaluation Categories
1. Accuracy

Does the response contain correct information?

Measures:

factual correctness
unsupported claims
hallucinations

Weight:

25%

2. Reasoning Quality

Does the system demonstrate sound reasoning?

Measures:

assumptions identified
alternatives considered
logical consistency

Weight:

20%

3. Error Detection

Can the system identify weaknesses?

Measures:

self-correction
uncertainty awareness
adversarial thinking

Weight:

20%

4. Completeness

Does the answer address the full problem?

Measures:

missing considerations
depth
context

Weight:

15%

5. Actionability

Can the output guide decisions?

Measures:

practicality
prioritization
implementation value

Weight:

10%

6. Communication Quality

Is the final output understandable?

Measures:

clarity
organization
usefulness

Weight:

10%

Test Categories
Category 1 — Knowledge

Purpose:

Measure factual reliability.

Example:

Explain the causes of the Bronze Age Collapse and distinguish established facts from theories.

Expected council advantage:

historian provides context
skeptic challenges certainty
philosopher examines assumptions
Category 2 — Complex Reasoning

Purpose:

Measure decision quality.

Example:

Should a country prioritize economic growth or environmental protection?

Expected council advantage:

multiple perspectives
tradeoff analysis
value examination
Category 3 — Adversarial Problems

Purpose:

Measure resistance to flawed premises.

Example:

Design a system that guarantees perfect scientific discovery.

Expected council behavior:

Identify:

impossible assumptions
limitations
alternative approaches
Category 4 — Strategic Planning

Purpose:

Measure long-term usefulness.

Example:

Create a five-year plan for establishing an independent research organization.

Expected council advantage:

strategy
risk analysis
historical precedent
implementation planning
Category 5 — Memory Continuity

Purpose:

Measure institutional learning.

Experiment:

Session 1:

Council researches a topic.

Session 2:

A related question is presented.

Comparison:

no memory
stored knowledge retrieval

Measure:

Does accumulated knowledge improve future reasoning?

Additional Architectural Tests
Role Ablation Testing

Remove individual council members.

Examples:

Without philosopher:

Does the system lose conceptual questioning?

Without skeptic:

Does confidence increase incorrectly?

Without archivist:

Does knowledge continuity decline?

Additional Proposed Role
The Judge

Potential future council member.

Purpose:

Resolution.

Responsibilities:

evaluate conflicting conclusions
weigh evidence
assign confidence
identify unresolved disagreement

The Judge should not generate ideas.

The Judge evaluates.

Research Log Format

Each experiment records:

Date:

Model:

Condition:

Question:

Output:

Score:

Observed Strengths:

Observed Failures:

Recommended Improvements:
Expected Outcome

The expected result is not that the council creates a more intelligent model.

The expected result is:

A structured reasoning environment produces more reliable intelligence from the same underlying model.

Broader Implication

Human intelligence does not exist only inside individual brains.

It is amplified through:

scientific institutions
peer review
documentation
debate
accumulated knowledge

Research Council attempts to reproduce these structures within artificial intelligence systems.

The goal is not artificial intelligence alone.

The goal is artificial institution.

Status

Research Council v0.1

First benchmark proposal.
