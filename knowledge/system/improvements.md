# System Improvements

Track proposed and completed upgrades.

---

## 2026-09-07

### Improvement: Add retrieval layer

Problem addressed:

Knowledge exists but agents cannot reliably access previous findings.

Proposed change:

Create a retrieval system that selects relevant knowledge before agent execution.

Expected benefit:

Agents reason from accumulated experience instead of starting from zero.

Status:

Planned.

---

## 2026-09-07

### Improvement: Separate storage from retrieval

Observation:

The knowledge base should remain human-readable while retrieval becomes more intelligent.

Design principle:

Markdown files remain the source of truth.

Additional layers may provide:

- search
- indexing
- embeddings
- relationship mapping

Expected benefit:

The system remains portable while gaining intelligence.

Status:

Planned.

---

## 2026-09-07

### Improvement: Add system self-review capability

Problem addressed:

The council can analyze external problems but does not yet formally analyze itself.

Proposed change:

Create a systems-engineer agent responsible for reviewing:

- architecture
- failures
- performance
- workflow improvements

Expected benefit:

The council can evolve deliberately rather than randomly.

Status:

Planned.

---

## 2026-09-07

### Improvement: Integrate human knowledge navigation

Problem addressed:

AI retrieval and human understanding are different needs.

Proposed change:

Connect the knowledge base to a visual knowledge system such as Obsidian.

Expected benefit:

Human researcher can explore connections while AI handles retrieval.

Status:

Planned.
