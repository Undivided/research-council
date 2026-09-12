# Outside Influence: Geometric Reasoning in AI

**Captured:** 2026-09-11

## Why This Matters

Geometric reasoning is relevant to Research Council and Full Turtle for two different but related reasons:

1. literal spatial / embodied reasoning about shapes, objects, scenes, motion, and physical relationships;
2. structural reasoning in which models are built to respect relationships, symmetries, invariants, topology, or geometry rather than learning every regularity from raw statistical correlation.

The second point is especially interesting for the project because it mirrors a recurring Research Council principle:

**good structure can reduce the burden placed on raw model capability.**

This note records the outside influence without claiming that Research Council currently implements geometric AI or that epistemic structure is literally geometric in a mathematical sense.

---

## Established Work

### Geometric Deep Learning

Geometric Deep Learning is an established research program concerned with machine learning on structured and non-Euclidean domains such as graphs, manifolds, groups, meshes, and point clouds.

A central idea is to expose known regularities and symmetries in the architecture instead of forcing a generic learner to rediscover them from data.

Reference:

- Bronstein, Bruna, Cohen, and Veličković, *Geometric Deep Learning: Grids, Groups, Graphs, Geodesics, and Gauges* (2021).

This is directly relevant to future model work because it demonstrates a general design principle:

**encode useful structure as an inductive bias when the structure is known.**

### AlphaGeometry / AlphaGeometry 2

Google DeepMind's AlphaGeometry is a neuro-symbolic geometry system that combines a neural language model with a symbolic deduction engine.

The language model proposes useful geometric constructions; the symbolic engine verifies and extends deductions under explicit rules.

The important influence for Research Council is not geometry alone. It is the architecture:

    generative / heuristic proposal
        +
    explicit rule-bound verification
        +
    iterative search

This resembles the broader Council idea that different cognitive functions should not be collapsed into one opaque step.

AlphaGeometry also used very large synthetic training corpora generated from geometric structures and proofs.

AlphaGeometry 2 later improved the symbolic engine, synthetic training scale, and search mechanisms.

References:

- Google DeepMind, *AlphaGeometry: An Olympiad-level AI system for geometry* (2024).
- Google DeepMind, AlphaProof / AlphaGeometry 2 IMO report (2024).

### Geometric Neural Operators

Work by Blaine Quackenbush and Paul Atzberger at UCSB develops Geometric Neural Operators for learning geometric properties from point-cloud / non-Euclidean representations in a way that is less sensitive to sampling and representation details.

The broad influence is again structural:

**represent the underlying object in a form that preserves the relations that matter, rather than overfitting to incidental discretization.**

References:

- Quackenbush and Atzberger, *Geometric neural operators (GNPs) for data-driven deep learning in non-euclidean settings* (2024).
- Quackenbush and Atzberger, *Transferable foundation models for geometric tasks on point cloud representations: geometric neural operators* (2025).

### Geometry-Informed Neural Networks

Geometry-Informed Neural Networks (GINNs) are a real 2025 ICML framework for shape-generative neural fields constrained by geometry and design requirements.

This is narrower than the broad phrase "Geometry-Informed AI," which should not be treated as one single standardized field name.

The relevant principle is the use of explicit objectives and constraints to shape a space of valid outputs.

Reference:

- Berzins et al., *Geometry-Informed Neural Networks* (ICML 2025).

### LLM Geometric Reasoning Gaps and Multi-Agent Correction

A 2024 EMNLP Findings paper, *Beyond Lines and Circles: Unveiling the Geometric Reasoning Gap in Large Language Models*, found that LLMs can struggle with 2D spatial relationships, planning, object placement, and even variable-name biases in constructive geometry.

The authors introduced a multi-agent framework with role-specialized solvers and validators, self-correction, and a Visual Relations Prompt generated from a vision-language model.

This is particularly relevant to Research Council because the improvement comes not only from a better base model but from:

- specialized roles;
- explicit intermediate representation;
- validator / solver separation;
- iterative dialogue and correction.

That is unusually close to the Council's own architectural instincts.

Reference:

- Mouselinos, Michalewski, and Malinowski, *Beyond Lines and Circles: Unveiling the Geometric Reasoning Gap in Large Language Models* (Findings of EMNLP 2024).

### Factored Embodied AI / Semantic Geometry

Helm.ai publicly describes a proprietary autonomous-driving architecture called Factored Embodied AI that separates perception from policy.

Their stated approach converts raw visual input into a cleaner geometric / semantic representation and trains planning in that reduced semantic space.

This should be treated as a company-reported architecture and performance claim, not as equivalent to independently established scientific consensus.

Still, the architectural idea is relevant:

    raw perception
        ↓
    explicit geometric / semantic representation
        ↓
    planning / policy

This suggests a useful general question for embodied Full Turtle systems and future robot training:

**what representation should exist between raw sensing and deliberation?**

Reference:

- Helm.ai, *Factored Embodied AI: Breaking the Data Wall with Geometric Reasoning and Semantic Simulation* (2025).

---

## Claim Requiring Caution: "Tiki" Geometry-Monitoring Chip

A claim about a specialized chip called **Tiki** (or Trinity) monitoring LLM curvature, holonomy, and heat-kernel scores in real time appears to trace to an individual Medium article.

At present this should **not** be treated as an established hardware milestone or verified research result.

The idea itself is interesting as speculation:

- monitor internal representational geometry during inference;
- detect unstable trajectories;
- use telemetry as a control signal.

But until supported by peer-reviewed work, hardware documentation, independent reproduction, or a credible institutional source, the project should record it only as a speculative influence.

This is a useful example of why outside-influence notes should preserve provenance and epistemic status.

---

# Relevance to Research Council

## 1. Relations May Matter More Than Objects

A role, claim, memory entry, or artifact has limited meaning in isolation.

Its important properties often arise from relationships:

- supports;
- contradicts;
- depends on;
- was derived from;
- challenges;
- supersedes;
- retrieves;
- adjudicates;
- is uncertain about.

This suggests that future Council representations may benefit from explicit relational structures such as graphs rather than flat text alone.

This is not yet a claim that epistemology has a literal mathematical geometry.

It is a design hypothesis:

**some epistemic behavior may become easier to reason about when relationships are first-class objects.**

## 2. The Agora as Structured Space

The Agora can be thought of as an interaction space in which claims and perspectives transform one another.

A future formalization might represent:

- claim nodes;
- evidence nodes;
- agent / role nodes;
- support and attack edges;
- provenance paths;
- uncertainty annotations;
- temporal succession;
- adjudication outcomes.

Then questions become possible that are difficult with text alone:

- Which conclusion depends on one fragile assumption?
- Which evidence influences many downstream claims?
- Which perspectives never interact?
- Where does disagreement persist?
- Which memory entries create recurring attractors in later reasoning?

## 3. Neuro-Symbolic Separation

AlphaGeometry reinforces a principle already emerging in Research Council:

**proposal generation and validity checking do not have to be the same cognitive operation.**

Possible future analogues include:

- model proposes a claim;
- provenance system verifies source lineage;
- logical / constraint layer checks explicit consistency;
- Judge evaluates epistemic disposition;
- empirical tools test reality-facing claims.

The goal is not to make all reasoning symbolic.

The goal is to use the right substrate for each function.

## 4. Intermediate Representations

The Visual Relations Prompt work and Helm.ai's semantic-space approach both suggest the value of an intermediate representation between raw input and higher-level reasoning.

For Research Council, possible future intermediate representations could include:

- scene graphs;
- causal graphs;
- claim / evidence graphs;
- timelines;
- dependency graphs;
- geometric maps;
- structured world state;
- simulation state.

Text should remain available, but text need not be the only internal substrate.

## 5. Geometry as a Test of Grounding

Spatial reasoning is useful because a geometry problem can expose whether a system is merely generating plausible language or actually maintaining a coherent model of relationships.

This could become one benchmark family for future Council-trained models:

- spatial consistency;
- object permanence;
- coordinate-free relational reasoning;
- map / scene understanding;
- physical constraints;
- tool-based construction and verification.

---

# Relevance to Full Turtle

## 1. A World Model Should Be More Than Text

A robot companion inhabiting Full Turtle should eventually reason over persistent spatial and physical relationships, not merely descriptions of them.

Potential representations include:

- scene graphs;
- maps;
- object relations;
- meshes / point clouds;
- physics state;
- symbolic affordances;
- learned geometric embeddings.

## 2. Building Can Become Reasoning

If the game world has coherent geometry and physics, construction becomes a form of external reasoning.

A structure can encode a hypothesis.

The world tests it.

Failure becomes evidence.

This directly supports the Full Turtle loop:

    model
        ↓
    construction
        ↓
    consequence
        ↓
    observation
        ↓
    revised model

## 3. Teaching Through Environment

Geometric and embodied systems strengthen the idea that the player can teach the companion without always using language.

Teaching may occur through:

- placing objects;
- constructing examples;
- demonstrating trajectories;
- creating constraints;
- arranging environments;
- exposing the agent to counterexamples;
- building a curriculum spatially.

The environment itself becomes part of instruction.

## 4. Shared Semantic Space

A future human + robot pair may benefit from a shared representation that both can inspect.

For example:

- the robot marks what it believes is traversable;
- the player sees the same map;
- uncertainty is visible;
- the player corrects a relationship;
- the companion updates and acts;
- consequences provide feedback.

This creates a much richer learning relationship than opaque natural-language prompting alone.

---

# Future Model-Training Questions

When Research Council reaches the model-training stage, investigate rather than assume:

1. Which geometric / relational inductive biases matter for our tasks?
2. Do graph or scene representations improve reasoning over purely textual serialization?
3. Can synthetic environments generate useful training curricula as AlphaGeometry generated synthetic proof structures?
4. Which functions should remain neural, which should be symbolic, and which should be externally verified?
5. Can equivariance / symmetry constraints reduce data requirements in embodied tasks?
6. Can a model transfer a learned relation across different visual or spatial representations?
7. Can an agent maintain coherent world state over long horizons?
8. Does multi-agent correction improve spatial reasoning because of diversity, explicit validation, or both?
9. Can provenance and causal structure be represented in a graph that improves retrieval and adjudication?
10. Are there useful measurable "shapes" in the Council's own reasoning trajectories, or is that only metaphor?

The last question should be approached carefully. If a mathematical geometry of epistemic state appears empirically useful, formalize it. Do not assume it in advance.

---

# Research Discipline

This influence fits the project's existing methodology:

**borrow mechanisms, not mythology.**

For each outside idea:

1. identify the concrete mechanism;
2. identify what problem it solved;
3. distinguish established result from marketing or speculation;
4. map only the part that actually corresponds;
5. design a small experiment;
6. observe what falls out;
7. preserve failures and surprises;
8. leave the grand explanation for later.

---

# Current Takeaway

The most important insight from geometric AI is not simply that future models should "learn geometry."

It is that **explicit structure can change what a learner needs to learn.**

That resonates strongly with Research Council:

    better epistemic structure
        →
    less burden on undifferentiated model capability

and with Full Turtle:

    coherent world structure
        →
    meaningful action
        →
    observable consequences
        →
    learnable reality

The project should keep geometric reasoning on the future training and embodiment research map.
