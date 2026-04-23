# Wiki conventions

How wiki pages are structured. Follow these so the brain compounds.

## Folder roles

- `wiki/concepts/` — cross-cutting ideas, methods, mental models (slug: lowercase-hyphen)
- `wiki/people/` — one page per person you interact with (slug: Pascal or First-Last)
- `wiki/products/` — your own products / projects
- `wiki/partners/` — organizations you collaborate with
- `wiki/competitors/` — organizations you compete with
- `wiki/org/` — companies, teams, org structure
- `wiki/specs/` — engineering / product specs (if applicable)
- `wiki/design/` — design system, diagrams, wireframes (if applicable)

Create a folder only when you need it. Empty folders with `.gitkeep` are fine until then.

## Page structure

Every page starts with frontmatter:

```yaml
---
kind: <concept|person|product|partner|competitor|organization>
name: <display name>
created: <YYYY-MM-DD>
status: <stub|active|archived>
touched_by: [list of source basenames that shaped this page]
private: false   # set true to exclude from GitHub Pages export
---
```

Body:

```markdown
# <display name>

<one-line description>

## <section>
<content>

## Sources that shaped this page

| Date | Source | What it added |
|------|--------|---------------|
| YYYY-MM-DD | [[<source-basename>]] | <one-line summary> |
```

## Cross-linking

- Use double-bracket wiki-link syntax: `[[page-name]]` or `[[wiki/concepts/slug]]`
- Obsidian renders them; GitHub Pages (v0.1) renders them as literal text
- Link generously — the brain compounds when pages know about each other

## Enrichment

- **Append, never overwrite.** New knowledge goes under a new `## YYYY-MM-DD: <summary>` section.
- Every appended section must cite its source inline: `[Source: [[<source-basename>]]]`
- Mark enrichment sessions: end the new section with `(enriched YYYY-MM-DD from [[<decision-or-source>]])`

## When to create a new page

- A new person shows up in a source → `/new-page person "Name"`
- A concept is referenced ≥2 times across sources → `/new-page concept "slug"`
- A decision is made → `decisions/<date>-<slug>.md`, not a wiki page

## What NOT to do

- Do not rewrite existing paragraphs when new info arrives. Append a dated section.
- Do not duplicate content across pages. Link.
- Do not leave pages with no `## Sources that shaped this page` section — provenance is the whole point.
