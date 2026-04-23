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
- If `existing_page == null` → **auto-create**: call `/new-page <kind> <slug>`, then `/absorb`. Do NOT prompt per entity — the source explicitly mentions this entity, that is sufficient signal to create a stub. Pages are cheap; orphans are easy to clean up later with `/lint`.

**Interactive mode** (opt-in): if the user invoked `/ingest --ask <path>`, prompt `"Entity '<name>' (kind: <kind>) has no page. Create one? [y/n]"` per new entity. Default is auto-create.

**Low-confidence guard**: if `extract-entities` returned an entity with kind=`concept` AND the surrounding context gives < 10 words of signal about it, skip creation. Orphan stubs dilute the brain.

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

### 6. Update global wiki/index.md catalog

Read `wiki/index.md`. If it has a `## Page catalog` section, for each page touched:
- If the page has an existing row: update the "Last enriched" column to today's date
- If the page is new (just created by `/new-page` in this ingest): append a new row

Row format:

```
| [[<page-slug>]] | <kind> | <created-date> | <YYYY-MM-DD today> | <one-line from page's first body paragraph> |
```

If `## Page catalog` section doesn't exist (template prior to v0.1.1), append it at the end of `wiki/index.md`:

```markdown
## Page catalog

Auto-maintained by /ingest and /new-page. One row per wiki page with a one-line summary.

| Page | Kind | Created | Last enriched | One-line |
|------|------|---------|---------------|----------|
```

Then append the rows. This catalog is Karpathy's navigation spine — the grep target when someone asks "what do I know about X?".

### 7. Verify all three gates pass

- Re-read each `touched:` page. Confirm `[Source: <source-basename>]` marker exists inline.
- Confirm each page's `## Sources that shaped this page` section was updated.
- Confirm `log.md` has the new row.

If any gate fails: roll back changes (`git checkout .`) and print the failure using this template:

```
/ingest FAILED — <source-basename>

Gate: <forward|inline|reverse|catalog|log>
Missing: <specific file and what was expected>
State: rolled back via `git checkout .`

Fix: <concrete next action, e.g., "The source mentioned no existing entities.
Either add a narrative claim that links to an existing wiki page, or call
/new-page first to create the target.">
```

Never leave a partial ingest. Never silently skip a gate.

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

## Binary sources (PDF, DOCX, images, audio, video)

When the source is a binary in `raw/` (or dropped into `inbox/` as a binary):

1. **Read natively** — Claude Code reads PDFs, DOCX, images natively. For audio/video, transcribe first into a sibling `.txt` and ingest that. Don't attempt to embed binary bytes.
2. **Create a companion `.meta.md`** — for the source file at `raw/<name>.pdf`, write `raw/<name>.pdf.meta.md` with the same frontmatter template used in step 4 of /ingest. The `.meta.md` carries the `touched:` list. Binaries themselves can't carry frontmatter.
3. **Inline source marker references the binary** — use `[Source: [[<basename>.pdf]]]` or the binary's filename. The `.meta.md` is metadata; the binary is canonical.
4. **Never commit binaries by default** — `raw/**` is gitignored. The `.meta.md` can be tracked with `git add -f` if the provenance chain is worth preserving without the source.

If the binary is large (>5 MB), ingest a human-written summary note in `inbox/` that references the binary rather than ingesting the binary directly. This reduces context usage on every future ingest that touches an overlapping page.
