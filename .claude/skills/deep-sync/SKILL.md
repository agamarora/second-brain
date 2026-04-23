---
name: deep-sync
description: Weekly session-end synthesis. Everything in /quick-sync plus drift detection, wiki snapshot via /publish-context, and retrospective notes. Run once a week (Friday recommended).
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

Weekly deep synthesis. Run after `/quick-sync` once per week.

## Steps

### 1. Run /quick-sync

Delegate to `/quick-sync` first. Inbox processed, decisions logged, pages enriched, journal updated. Do NOT push yet — this skill will push at the end.

### 2. Drift detection

For every page in `wiki/` and every file in `decisions/`:
- Read frontmatter + `## Sources that shaped this page` table
- Compute: how many decisions reference this page but this page was not enriched in the last 30 days?
- If 5+ unabsorbed decisions for a single page → flag as `DRIFT`

Output a drift list:

```
Drift check:
- wiki/concepts/<slug>.md — N unabsorbed decisions (most recent: <date>)
- ...
```

If drift list is non-empty and ≤3 pages → enrich each one inline before finishing. Append a new dated section per page synthesizing the drifting decisions.

If drift list is >3 pages → enrich the top 2 by unabsorbed count. Log the rest for next session.

### 3. Lint the brain

Call `/lint` (report-only, no `--fix`). Include the findings summary in the retro note (step 4). High-value findings — broken links, contradictions — should surface into next week's tracks rather than being silently filed.

### 4. Wiki snapshot

Call `/publish-context` to export a dated snapshot of `wiki/` + `journal/NOW.md` + `decisions/` to `archive/context-export/<YYYY-MM-DD>/` for cross-session portability.

### 5. Retrospective note

Append to `journal/retro-<YYYY-ww>.md` (ISO week number):

```markdown
# Retrospective: week <ww> of <YYYY>

## What shipped
<list, drawn from journal/DONE.md entries this week>

## Decisions this week
<list, from decisions/ filenames matching this week's dates>

## Drift detected
<list from step 2>

## Lint findings
<summary from step 3 — orphans, broken links, contradictions>

## Pages enriched
<list>

## What to do next week
<1-3 items>
```

### 6. Append to log.md

```
## [YYYY-MM-DD] deep-sync
- Drift pages: N
- Lint findings: N (O orphans, B broken links, S stale, C contradictions)
- Snapshot: archive/context-export/<date>/
- Retro: journal/retro-<YYYY-ww>.md
```

### 7. Commit and push

```bash
git add -A
git commit -m "deep-sync: week <ww>"
git push
```
