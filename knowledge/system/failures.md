# Failed Approaches

Record mistakes, limitations, and lessons learned.

---

## 2026-09-07

### Failure: Knowledge existed but was not usable

Problem:

The council generated knowledge entries, but later agents could only see file names and paths rather than the actual content.

Observed during:

Librarian agent testing.

Cause:

The system had storage but no retrieval layer.

Lesson:

A knowledge base requires both memory storage and memory access.

Correction:

Develop retrieval mechanisms before expanding the number of stored entries.

---

## 2026-09-07

### Failure: Keyword retrieval is insufficient

Problem:

Searching filenames or simple text matches does not reliably identify relevant knowledge.

Cause:

Meaning is not always represented by identical words.

Lesson:

Future retrieval should understand concepts, not just keywords.

Correction:

Plan for semantic search, embeddings, or knowledge graph approaches.

---

## 2026-09-07

### Failure: Agent roles require explicit context

Problem:

Agents may correctly identify missing information but cannot access information that exists outside their prompt.

Cause:

File existence does not equal available knowledge.

Lesson:

Context injection is a core system function.

Correction:

Build a librarian/retrieval layer between storage and reasoning agents.
