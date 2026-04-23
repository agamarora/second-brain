---
name: ingest
description: First-class ingest of a source into the brain. Extracts entities, updates affected wiki pages, writes 3-layer provenance (forward + reverse + inline), appends to log.md. Fails if no wiki pages are touched. Use when a new source arrives — inbox note, PDF in raw/, article, meeting transcript.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

Ingest a source file into the brain. Source can be a markdown note or a binary (PDF, DOCX, etc.).

## Usage

```
/ingest inbox/2026-04-23-karpathy-note.md
/ingest raw/meeting-2026-04-20.pdf
```

## Compounding gate (non-negotiable)

The skill **fails** if after the run:
- No wiki page was touched (`touched: []` on source frontmatter)
- Any page listed in `touched:` does not contain an inline `[Source: <source-basename>]` marker
- `log.md` does not have a new `ingest` row

If any gate fails, the skill prints the failure and does NOT commit changes. Partial ingests are not allowed.

## Steps

### 1. Read the source

Use Read. For PDFs and DOCX, Claude Code reads them natively. Extract: title, key claims, people mentioned, organizations mentioned, concepts introduced, decisions stated, constraints, dates.

### 2. Call /extract-entities

Pass source content. Receive `[{entity, kind, existing_page}, ...]`. Kinds: `person`, `product`, `partner`, `competitor`, `concept`, `decision`, `organization`.

### 3. Absorb or create per entity

For each entity:
- If `existing_page != null` → call `/absorb <entity> <source>`
- If `existing_page == null` → ask user: `"Entity '<name>' (kind: <kind>) has no page. Create one? [y/n]"`. On yes, call `/new-page <kind> <slug>` then `/absorb`.

### 4. Forward provenance (source frontmatter)

Add or update frontmatter on the source file:

```yaml
---
title: <title>
date: <ISO date>
status: ingested
touched:
  - wiki/people/<Name>.md
  - wiki/concepts/<slug>.md
  - decisions/<date>-<slug>.md
---
```

If source is binary, create a companion `<source>.meta.md` alongside it with the same frontmatter.

### 5. Append to log.md

```
## [YYYY-MM-DD] ingest: <source-basename>
Touched: [list of pages]
Entities: [comma list]
```

### 6. Verify all three gates pass

- Re-read each `touched:` page. Confirm `[Source: <source-basename>]` marker exists inline.
- Confirm each page's `## Sources that shaped this page` section was updated.
- Confirm `log.md` has the new row.

If any gate fails: roll back changes (`git checkout .`) and print the failure.

## Entity path lookup

| Kind | Path |
|---|---|
| person | `wiki/people/<Name>.md` |
| product | `wiki/products/<Name>.md` |
| partner | `wiki/partners/<Name>.md` |
| competitor | `wiki/competitors/<Name>.md` |
| concept | `wiki/concepts/<slug>.md` |
| organization | `wiki/org/<Name>.md` |
| decision | `decisions/<YYYY-MM-DD>-<slug>.md` |
