# System Decisions

Record important architectural choices.

---

## 2026-09-07

### Decision: Create separate system knowledge layer

Decision:

The Research Council requires a separate memory area for knowledge about itself.

Reason:

Research findings and system evolution are different types of knowledge.

Research answers:
"What did we learn about the world?"

System memory answers:
"How did we improve the way we learn?"

Expected benefit:

Future improvements can be based on previous experience instead of starting over.

---

## 2026-09-07

### Decision: Use specialized agents instead of one general agent

Decision:

The council uses multiple roles:

- Researcher
- Historian
- Philosopher
- Strategist
- Skeptic
- Red Team
- Editor
- Archivist
- Librarian

Reason:

Different cognitive roles expose different weaknesses.

Expected benefit:

Reduce blind spots and improve confidence calibration.

---

## 2026-09-07

### Decision: Preserve raw reports

Decision:

Original agent outputs are stored rather than discarded.

Reason:

Future agents may extract information that was missed initially.

Expected benefit:

The knowledge base can improve as retrieval and reasoning improve.

---

## 2026-09-07

### Decision: Add librarian role

Decision:

A librarian agent was added after discovering that knowledge existed but was not automatically available to agents.

Reason:

Accumulating files is not the same as having usable memory.

Expected benefit:

Future systems will retrieve relevant knowledge before reasoning.
