---
name: help
description: List all available skills with one-line descriptions. Use when the user asks "what can this brain do", "what skills are there", "list commands", or /help.
allowed-tools: Glob, Read
---

Print the skill catalog. Short, scannable.

## Steps

1. Glob `.claude/skills/*/SKILL.md`
2. For each, read the `name:` + `description:` from the frontmatter (first 10 lines is enough)
3. Print the table below, sorted by suggested-workflow order

## Output format

```
Second brain — available skills

SESSION
  /orient              Session-start briefing
  /help                This command

WRITE PATH
  /capture <text>      Drop a thought into inbox/ — no triage
  /ingest <path>       Process a source into the wiki with 3-layer provenance
  /new-page <kind>     Create a new entity or concept page

READ PATH
  /query "<question>"  Ask the brain — synthesized answer with citations

SUBSKILLS  (called by /ingest, rarely directly)
  /extract-entities    Scan a source, return entity list
  /absorb <ent> <src>  Write source reference into a wiki page

SYNC
  /quick-sync          Session end — process inbox, log decisions, commit
  /deep-sync           Weekly — /quick-sync + drift check + snapshot

MAINTENANCE
  /lint                Find orphans, broken links, stale claims, contradictions
  /publish-context     Export a read-only snapshot for cross-session use

IN-CONVERSATION SHORTCUTS (no slash needed)
  "capture this"       → runs /capture
  "log this decision"  → writes decisions/<date>-<slug>.md directly
  "ingest this"        → runs /ingest on the last-mentioned source

Type any command above. See individual .claude/skills/<name>/SKILL.md for details.
```

## Rules

- Keep output ≤ 40 lines total
- Do not paginate or ask questions — just print
- If a skill exists on disk but isn't in the groups above, append it under "OTHER"
- If a skill from the groups above is missing on disk, omit its row silently
