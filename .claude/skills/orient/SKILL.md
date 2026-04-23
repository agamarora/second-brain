---
name: orient
description: Session-start briefing. Derives current tracks, recent decisions, and open items directly from journal/NOW.md + decisions/ + log.md tail. Counts unprocessed inbox notes. Run at the start of every session.
allowed-tools: Read, Glob, Bash
---

Produce a session-start briefing. Short. Factual. No padding.

## Steps

1. Read `memory/MEMORY.md` — thin compaction anchor. Confirms name, current focus, key file locations.
2. Read `journal/NOW.md` — this week's tracks, focus, open decisions, blockers. Note the `Last updated:` date; flag if >5 days old.
3. Glob `decisions/*.md`, sort by filename descending, read the last 5. Use their `# Decision:` title + first line of `## Decision` for the recent-decisions list.
4. Glob `inbox/*.md`. Count files with frontmatter `status: raw` (or no status frontmatter at all). Do not read contents.
5. Read `log.md` tail (last 10 rows) — recent ingests, decisions, session markers. Skip if empty.
6. Survey `wiki/` subfolders — list non-empty ones. One line.

## Output format

```
Second brain — orient

Focus: [from NOW.md ## This week's focus, 1-2 lines]

Tracks:
- [track name] — [status] — [next action]
- ...

Open decisions:
- [from NOW.md ## Open decisions]
- ...

Last 5 decisions:
- YYYY-MM-DD — [title]
- ...

Inbox: [N] unprocessed notes
Wiki: [N] populated folders ([list])

Last updated: [date from NOW.md]
```

Keep the output ≤25 lines. If NOW.md is stale (>5 days), prefix output with: **"NOW.md last updated [date] — consider running /quick-sync."**

## Failure modes

- `memory/MEMORY.md` missing → "Run the setup wizard in CLAUDE.md first."
- `journal/NOW.md` missing → "Run the setup wizard in CLAUDE.md first."
- No decisions yet → list shows "(none yet)".
- Empty inbox → "Inbox clear."
