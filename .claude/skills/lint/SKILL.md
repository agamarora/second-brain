---
name: lint
description: Health check for the brain. Detects orphan pages, broken wiki-links, stale claims, contradictions, and index hygiene issues. Reports structured findings; does not auto-fix unless run with --fix. Karpathy's 3rd core operation alongside /ingest and /query.
allowed-tools: Read, Glob, Grep, Edit, Bash
---

Audit the brain for rot. Run weekly, after `/deep-sync`, or on demand when something feels off.

## Usage

```
/lint               # report only
/lint --fix         # attempt auto-fixes where unambiguous (orphan index entries, broken wiki-links with single candidate)
/lint --scope wiki  # only check wiki/, skip decisions/
```

## Checks

### 1. Orphan pages — wiki pages no source has touched

A page is orphaned if:
- It exists under `wiki/` or `decisions/`
- Its `## Sources that shaped this page` table is empty or absent
- No other wiki page links to it via `[[name]]` markers
- Its `touched_by` frontmatter field is `[]` or missing

Orphans are not automatically wrong — you might be documenting something the brain hasn't ingested yet. But an unlinked, unsourced page six months after creation is usually dead weight.

### 2. Broken wiki-links — `[[name]]` with no target

Grep all markdown files for `[[...]]` patterns. For each match, check if:
- A file exists at the referenced path (try: `wiki/**/<name>.md`, `decisions/<name>.md`, and the direct path if it has slashes)
- OR it's a `[[Source: basename]]` marker pointing to an `inbox/` or `raw/` file (those can be gitignored, so only flag if the basename clearly won't resolve)

Report each broken link with: source file, line number, the broken `[[...]]` text, and candidates (if any close matches exist).

### 3. Stale claims — pages enriched ≥5 times, none recent

For each `wiki/` page:
- Count rows in `## Sources that shaped this page`
- Find the most recent row's date
- If count ≥ 5 AND most recent is > 90 days old → flag as `STALE_CANDIDATE`

These are high-value pages that haven't absorbed anything new — worth manually reviewing.

### 4. Contradictions — conflicting facts

For each `wiki/` page with multiple enrichment sections:
- Look for negation patterns: one section says "X is Y", another says "X is not Y" or "X is Z"
- Look for decision chains: a decision marked `status: decided` with a later decision touching the same topic but no `## Superseded by:` link
- Flag for human review — never auto-resolve

This check is necessarily heuristic. False positives are OK; false negatives silently rot the brain.

### 5. Index hygiene — pages missing from folder `index.md`

For each folder in `wiki/`:
- Read `wiki/<folder>/index.md`
- List all non-`index.md` pages in that folder
- Every page should have a row in the index table
- Flag missing rows

With `--fix`, auto-append missing rows using the page's frontmatter name + created date.

### 6. Global `wiki/index.md` completeness

Read `wiki/index.md`. If it has a page catalog section (added in v0.2), verify every page under `wiki/` appears. Flag missing entries. With `--fix`, append.

## Output format

```
/lint report — 2026-05-01

ORPHANS (2)
  wiki/concepts/cold-start.md — created 2026-03-15, no sources, not linked
  wiki/people/old-contact.md — created 2025-11-02, 1 source 5 months ago, not linked

BROKEN LINKS (3)
  wiki/people/me.md:42    [[Priya-Sharma]] — no target; close match: wiki/people/Priya-S.md
  decisions/2026-03-12-...  [[pricing-strategy]] — no target; no close matches
  wiki/concepts/tool-vs-platform.md:18  [[2026-04-18-offsite]] — target missing

STALE CANDIDATES (1)
  wiki/concepts/strategy.md — 7 sources, last absorbed 2026-01-10 (112 days)

CONTRADICTIONS (1)
  wiki/people/ravi.md
    2026-02-01: "Ravi prefers seat-based pricing" [[2026-02-01-pricing-call]]
    2026-04-18: "Ravi pushed for platform-shaped product" [[2026-04-18-offsite]]
    — no explicit reconciliation. Review.

INDEX HYGIENE (2)
  wiki/partners/index.md missing: meridian.md
  wiki/concepts/index.md missing: first-five-minutes.md

GLOBAL INDEX (0)
  (clean)

SUMMARY: 9 findings, 2 auto-fixable (re-run with --fix)
```

With `--fix`:

```
/lint --fix — 2026-05-01

AUTO-FIXED (2)
  wiki/partners/index.md  + meridian.md row
  wiki/concepts/index.md  + first-five-minutes.md row

STILL MANUAL (7)
  [orphans, broken links, stale, contradictions per above]
```

## Log

Append to `log.md`:

```
## [YYYY-MM-DD] lint
Findings: N (orphans: O, broken: B, stale: S, contradictions: C, index: I)
Auto-fixed: F
```

## Failure modes

- **Empty brain** (no wiki pages yet) → print "Brain has no wiki pages to lint. Run /ingest first."
- **Huge brain** (>500 pages) → lint runs in scope-limited mode by default. Warn if total pages > 500 and suggest `--scope <folder>`.
- **Broken link with multiple candidates** → under `--fix`, do NOT auto-rewrite. Report and let the user choose.

## Non-goals

- `/lint` does NOT rewrite prose. It flags, it hygiene-fixes, it reports. Semantic merging of contradictions is a human call.
- `/lint` is not RAG or semantic search. It uses grep + file structure.
- `/lint` is not CI. It is an on-demand or weekly-cadence tool.

## Relationship to other skills

- `/deep-sync` calls `/lint` internally (v0.2+) before the retro step
- `/new-page` should fail-safe into the folder index, so `index hygiene` findings should be rare
- `/ingest` compounding gate already prevents the worst orphan-creation cases
