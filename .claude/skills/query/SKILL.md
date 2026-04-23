---
name: query
description: Ask a natural-language question of the brain. Reads wiki/, decisions/, and log.md, synthesizes an answer grounded in accumulated knowledge, cites every claim. Optionally files the synthesis as a new wiki concept page. Use when the user asks a question that should be answered from what they've already ingested.
allowed-tools: Read, Glob, Grep, Write
---

Answer questions from the brain. Cite everything. Never hallucinate.

## Usage

```
/query "<question>"
```

Examples:

```
/query "what did I decide about pricing?"
/query "what does Ravi think about platform vs tool?"
/query "who has the most unresolved threads right now?"
/query "summarize everything I know about Meridian"
```

## Steps

### 1. Parse the question

Identify:
- **Keywords** — content terms for grep
- **Named entities** — people, products, partners, concepts with existing pages
- **Intent** — retrieve facts, summarize, compare, trace a decision chain

### 2. Search the brain

Grep in order of priority:
1. `decisions/*.md` — explicit judgment calls with context
2. `wiki/people/*.md` — if question mentions a person
3. `wiki/concepts/*.md` — for topic questions
4. `wiki/{products,partners,competitors,org}/*.md` — entity-specific
5. `journal/NOW.md` + last 10 rows of `log.md` — for "right now" questions

Rank hits by:
- Named-entity match > keyword match
- Recency of last enrichment (newer wins on ties)
- Frequency across sources

### 3. Read top 3-8 pages in full

Never answer from page titles or grep snippets alone. Read full pages before synthesizing.

### 4. Synthesize

Write an answer of **≤6 sentences** (shorter is better). Every factual claim cites its source inline:

```
Ravi favors platform-shaped architecture [[2026-04-18-strategy-offsite-notes]], but agreed
to tool-first at the offsite [[decisions/2026-04-18-tool-first-platform-at-18-months]].
```

Rules:
- **Do not hallucinate.** If no source supports a claim, omit it or say "brain has no record of X."
- **Quote exactly where useful.** Short verbatim quotes from sources are fine, marked with quotes.
- **Preserve disagreement.** If sources contradict, say so — don't pick one.
- **Link, don't summarize at length.** Point the user at the page for depth.

### 5. Output format

```
Answer: <≤6 sentences with inline [[source]] citations>

Sources consulted:
- wiki/people/ravi.md — <one-line why relevant>
- decisions/2026-04-18-<slug>.md — <one-line why relevant>
- ... (up to 8)

Pages searched but not used: N
```

### 6. Offer to file (opt-in)

If the synthesis produces a novel connection not present in any single source:

```
This answer synthesizes knowledge from N sources into a new framing: "<one-line>".
File this as wiki/concepts/<slug>.md? [y/n]
```

On yes:
1. Call `/new-page concept <slug>`
2. Write the synthesized answer as the page body
3. Call `/absorb` on each source used
4. Append to `log.md`: `## [YYYY-MM-DD] query-filed: <slug>`

On no: return to prompt. Nothing written.

## Failure modes

- **No matching sources** → Return: "Brain has no knowledge about <topic>. Ingest sources first, then re-query."
- **Question too vague** → Return: "Question is ambiguous. Narrow it: are you asking about [option A] or [option B]?"
- **Grep returns >50 files** → Too broad. Ask user to constrain to a time range, entity, or folder.
- **Conflicting sources** → Surface both claims in the answer. Do not silently pick one.

## Non-goals

- `/query` does not modify wiki pages unless the user opts in at step 6.
- `/query` does not replace human judgment. It retrieves and synthesizes; the user decides.
- `/query` is not RAG. No embeddings, no vector DB. Grep + read is enough at personal-brain scale (hundreds to low-thousands of pages).
