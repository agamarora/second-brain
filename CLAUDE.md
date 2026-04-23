# CLAUDE.md

This file is the schema and the setup wizard for this second brain. Claude Code reads this on every session. Follow it exactly.

---

## What this repository is

A personal second brain. Plain markdown + git. Claude Code is the runtime; Obsidian is an optional reader. The brain compounds: every new source connects to what came before.

Three pillars:

1. **Raw sources** → `raw/` (binaries) and `inbox/` (markdown captures). Immutable.
2. **The wiki** → `wiki/` + `decisions/` + `log.md`. LLM-owned, densely cross-linked markdown. This is the source of truth.
3. **The schema** → this file + `rules/` + `memory/MEMORY.md`.

---

## First-run setup wizard

**If `memory/MEMORY.md` does not exist or contains only a placeholder, run the wizard below before doing anything else.**

The wizard asks 5 questions, one at a time, and writes the foundational files. Budget: under 10 minutes total including ingest.

### Preflight

Run the doctor:

```bash
sh scripts/doctor.sh
```

Fix any `[FAIL]` before continuing. `[WARN]` is OK to proceed.

### Q1 — Name

Ask: "What's your name? How should your brain address you?"

Write the answer to the wizard state. Later used in `memory/MEMORY.md` and `wiki/people/me.md`.

### Q2 — Three current tracks

Ask: "What are the 2-4 things you're actively pushing on right now? One line each. Examples: 'Ship v1 of X', 'Figure out pricing for Y', 'Hire a designer'."

Capture 2-4 track lines.

### Q3 — Five people who matter

Ask: "Name 3-5 humans who show up most in your work this month. **People only** — not companies, partners, products, or concepts (those get their own pages later when /ingest processes your artifacts). Full names, one-word role or relationship. Examples: 'Maya Patel — cofounder', 'Ravi Kumar — design lead', 'Priya Sharma — main customer'."

Capture 3-5 lines. **Do NOT fabricate names** to reach 5. If the user gives 3, seed 3 stubs. If they name a company or partner, politely redirect: "That's an organization — I'll create a page for it when /ingest encounters it. Give me a human name instead."

### Q4 — One decision in flight

Ask: "What's the biggest open decision you're sitting on right now? One-line framing, not the answer."

Capture one line.

### Q5 — Inbox drop

Ask: "Drop 3-5 real artifacts into the `inbox/` folder — a LinkedIn PDF export, a recent Google Doc you exported, a meeting transcript, a weekly review, anything you've written in the last month. Any format. Put them in `inbox/`, then tell me when you're done."

**Wait for user confirmation before proceeding.** Do not fabricate artifacts.

### Seeding — write these files in order

1. `memory/MEMORY.md` — short compaction anchor, see template below
2. `journal/NOW.md` — this week's focus with the 3 tracks and 1 decision
3. `journal/TODO.md` — empty shell with section headers per track
4. `journal/DONE.md` — empty shell
5. `journal/BACKLOG.md` — empty shell
6. `wiki/index.md` — wiki root
7. `wiki/concepts/index.md` — folder index
8. `wiki/people/index.md` — folder index
9. `wiki/concepts/strategy.md` — stub with user's framing of what the brain is for
10. `wiki/people/me.md` — stub (will be enriched by ingest)
11. `wiki/people/<person-slug>.md` — one stub per named person from Q3 (5 files)
12. `decisions/index.md` — decisions folder index with table header
13. `decisions/<YYYY-MM-DD>-<first-decision-slug>.md` — first decision file using the Q4 decision as content; `status: open` if not resolved yet
14. `log.md` — chronological spine with wizard-run event

### Ingest — the whoa moment

After seeding files, call `/ingest` on every file in `inbox/` (one at a time).

- Each call detects entities (including the 5 people stubs already created)
- Writes `[Source: [[...]]]` markers into touched pages
- Appends to `## Sources that shaped this page` tables
- When absorbing into `wiki/people/me.md`, writes a short first-person summary paragraph synthesizing what the sources reveal about the user (see rules in `.claude/skills/absorb/SKILL.md`)

### Finish

Call `/orient`. Show the user their populated brain.

Say to the user:

> Your brain is set up. `memory/MEMORY.md` holds pinned facts, `journal/NOW.md` holds this week's focus, `wiki/people/me.md` has what your ingested artifacts say about you so far.
>
> During work, just say "capture this" or "log this decision" — I'll write files immediately. At session end, run `/quick-sync`. Weekly, run `/deep-sync`.
>
> Your brain is private by default. `inbox/` and `raw/` are gitignored. To publish a read-only view at `<username>.github.io/<repo>/`, uncomment the `on:` trigger in `.github/workflows/publish-brain.yml`.

---

## memory/MEMORY.md template

Write this file during wizard step 1:

```markdown
# MEMORY — pinned facts

I am {name}. My brain lives in this git repo.

## Current focus
{three tracks from Q2, one line each}

## Open decision
{Q4 answer}

## Key people
{Q3 list, with slugs to wiki/people/<slug>.md}

## Key file locations
- journal/NOW.md — this week's focus, always up to date
- decisions/ — judgment calls, chronological, each with builds-on chain
- wiki/ — entities + concepts, enriched not overwritten
- log.md — chronological event spine
- rules/ — wiki-conventions, decisions-format, inbox-triage

## How this brain compounds
- Every ingest writes 3-layer provenance (see rules/wiki-conventions.md)
- Decisions chain via builds_on (see rules/decisions-format.md)
- Inbox flows through /ingest (see rules/inbox-triage.md)

Last updated: {YYYY-MM-DD}
```

Keep this file under 50 lines. It is loaded on every session start.

---

## Session start (every session)

1. Read `memory/MEMORY.md`
2. Run `/orient` — full briefing in <30 seconds
3. If `journal/NOW.md` `Last updated:` is >5 days ago, flag it

---

## Available skills

Type `/skill-name`. Claude Code also invokes these when you describe what you want.

| Skill | When |
|---|---|
| `/orient` | Session start |
| `/ingest <path>` | New source arrived — inbox note, PDF in raw/, etc. |
| `/query "<question>"` | Ask the brain a question. Synthesized answer with citations. |
| `/extract-entities` | Subskill of `/ingest`; rarely called directly |
| `/absorb <entity> <source>` | Subskill of `/ingest`; rarely called directly |
| `/new-page <kind> <name>` | User says "create a page for X" |
| `/quick-sync` | Session end, daily |
| `/deep-sync` | Session end, weekly (Fridays recommended) |
| `/publish-context` | On demand — dated snapshot for cross-session use |

---

## In-conversation capture

No skill invocation needed. Just say:

- **"capture this"** — Claude writes an `inbox/<date>-<slug>.md` immediately
- **"log this decision"** — Claude writes a `decisions/<date>-<slug>.md` immediately
- **"ingest this"** — Claude runs `/ingest` on the last-mentioned source

---

## Operating loop

```
/orient  →  work  →  /quick-sync
```

Weekly on Fridays: `/deep-sync` instead of `/quick-sync`.

---

## Repository structure

```
CLAUDE.md                 ← this file (schema + wizard)
README.md                 ← human entry point
LICENSE                   ← MIT
log.md                    ← chronological event spine
.gitignore                ← inbox/, raw/, archive/ ignored by default

scripts/
  doctor.sh               ← preflight checks

.github/workflows/
  publish-brain.yml       ← GitHub Pages export (disabled by default)

.claude/skills/
  orient/, ingest/, query/, extract-entities/, absorb/,
  new-page/, quick-sync/, deep-sync/, publish-context/

rules/
  wiki-conventions.md     ← page format, cross-linking, enrichment
  decisions-format.md     ← decision file format, builds-on chain
  inbox-triage.md         ← what goes where

memory/MEMORY.md          ← compaction anchor (≤50 lines)

wiki/                     ← THE WIKI
  index.md
  concepts/ people/ products/ partners/ competitors/ org/ specs/ design/

decisions/                ← one file per decision, chronological

journal/
  NOW.md                  ← this week's focus
  TODO.md DONE.md BACKLOG.md

inbox/                    ← raw markdown captures (gitignored)
raw/                      ← binaries (gitignored)
archive/                  ← snapshots, retired artifacts (gitignored)
```

---

## Compounding rules

These are enforced mechanically by skills, not left to memory:

- **3-layer provenance** on every ingest:
  1. Source frontmatter `touched: [list of pages]` (forward)
  2. Each touched page has inline `[Source: [[...]]]` markers (anchor)
  3. Each touched page's `## Sources that shaped this page` table has a row (reverse)
- **Decisions chain** via `builds_on` + `## Builds on` section. Superseded decisions get `## Superseded by: <new slug>` retroactively.
- **Wiki pages enrich, not overwrite.** New facts append under a new `## YYYY-MM-DD: <summary>` section with source markers.
- **log.md is the spine.** Every ingest, decision, sync run writes a dated row.

---

## Compact instructions (preserved across conversation compaction)

When resuming after a gap:

1. Read `memory/MEMORY.md` — it contains the compaction anchor
2. Read `journal/NOW.md` — this week's focus
3. Run `/orient` for live briefing

If `memory/MEMORY.md` is missing, run the setup wizard above.

---

## For AI coding agents running this setup

If you are reading this file because a user pasted the setup prompt and asked you to set up their second brain, execute the "First-run setup wizard" section above start-to-finish. You are the wizard.

- Ask the 5 questions one at a time. Do not batch them.
- Wait for the user to confirm inbox artifacts are dropped before proceeding to ingest.
- Do not fabricate artifacts. If the user has nothing to drop, create `inbox/README.md` with a note explaining how to add artifacts later and skip the ingest step.
- Use the `Write` or equivalent tool to create files. Do not print file contents for the user to paste manually.
- When done, run `/orient` and show the user their populated brain.

If the user is not using Claude Code (e.g. ChatGPT, Claude Desktop, Cursor), see `SETUP-GUIDE.md` for the plain-text fallback — the wizard still works, you just need to instruct the user to create files manually or use whatever file-editing tool is available.
