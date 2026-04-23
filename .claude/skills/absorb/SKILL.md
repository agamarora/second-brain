---
name: absorb
description: Append a source reference to an existing wiki page. Writes (a) inline [Source: ...] marker in the relevant section and (b) a row in the page's `## Sources that shaped this page` section at the bottom. Subskill of /ingest. Keeps reverse provenance intact. When absorbing into wiki/people/me.md, also writes a short first-person summary paragraph referencing the absorbed source.
allowed-tools: Read, Edit, Write
---

Append a source reference to an existing wiki page. Enrich, never overwrite.

## Usage

```
/absorb <entity-name> <source-path>
```

## Steps

### 1. Read the target page

Resolve entity → page path using `/ingest`'s lookup table. Read current contents.

### 2. Identify the right section

Find the section most relevant to what the source adds. If no section fits, append a new `## YYYY-MM-DD: <one-line summary of what this source adds>` section.

### 3. Write inline source marker

In the relevant section, append a line summarizing the claim, ending with the source marker:

```
- <Claim or insight>. [Source: [[<source-basename>]]]
```

Claim must be ≤1 line, factual, new information (do not duplicate existing claims).

### 4. Append to `## Sources that shaped this page`

If the section doesn't exist, create it at the bottom of the page:

```markdown
## Sources that shaped this page

| Date | Source | What it added |
|------|--------|---------------|
| YYYY-MM-DD | [[<source-basename>]] | <one-line summary> |
```

If the section exists, append a new row.

### 5. Special behavior for wiki/people/me.md

When the target page is `wiki/people/me.md`:
- After completing steps 1-4, re-read the whole page
- Read all absorbed source markers on this page
- Write a short (≤4 sentence) first-person summary paragraph at the top under `## About me` (or create that section) synthesizing what the sources reveal about the user
- Each sentence in the summary must cite at least one absorbed source inline with `[Source: [[...]]]`
- Do not invent facts. Only synthesize what the absorbed sources actually state.

### 6. Never overwrite

If you are updating an existing paragraph, append. Do not edit the existing text. Enrichment is append-only.

### 7. Return

Return the updated page path + list of sections modified.

## Failure modes

- Target page does not exist → fail; `/ingest` should call `/new-page` first
- Source already absorbed into this page (same basename already in the table) → no-op, return "already absorbed"
