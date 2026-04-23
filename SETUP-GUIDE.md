# Setup guide — without Claude Code

The canonical flow uses Claude Code, which reads `CLAUDE.md` and runs the wizard for you. Without Claude Code, you drive it manually via ChatGPT, Claude Desktop, Cursor, Copilot, Gemini, or any plain text editor.

**Estimated time: 15 minutes.** (10 min with Claude Code.)

## 1. Create the repo

Use GitHub's "Use this template" button on [github.com/agamarora/second-brain](https://github.com/agamarora/second-brain), or:

```bash
gh repo create --template agamarora/second-brain --public <your-name>-brain --clone
cd <your-name>-brain
```

## 2. Preflight

```bash
sh scripts/doctor.sh
```

Fix any `[FAIL]` before continuing.

## 3. Paste this to your AI tool

```
I'm setting up a second brain using github.com/agamarora/second-brain.
I'm using <your tool>, not Claude Code. Walk me through the 5-question
setup wizard in CLAUDE.md ("First-run setup wizard" section). Ask one
question at a time. For each file, output the full contents in a code
block so I can save it manually.
```

Answer the 5 questions:

1. **Name** — how your brain addresses you
2. **Three tracks** — 2-4 things you're pushing on
3. **Five people** — humans who show up most in your work this month (not companies)
4. **One decision** — biggest open decision you're sitting on
5. **Inbox drop** — add 3-5 real artifacts to `inbox/` (LinkedIn PDF, Doc export, meeting transcript, weekly review)

## 4. Save seeded files

Your AI will output contents for these. Save each manually:

- `memory/MEMORY.md`, `journal/NOW.md`
- `wiki/concepts/strategy.md`, `wiki/people/me.md`
- One `wiki/people/<name>.md` per person from Q3
- `decisions/<YYYY-MM-DD>-<first-decision-slug>.md`

## 5. Ingest each inbox file

Ask your AI per file:

```
Run /ingest on inbox/<filename> per .claude/skills/ingest/SKILL.md.
Touch wiki pages, write [Source: ...] markers + reverse tables +
frontmatter. Append a row to log.md.
```

If your tool can't edit files directly, ask for full updated contents of each touched file and save them manually.

## 6. Run orient

```
Run /orient per .claude/skills/orient/SKILL.md. Read memory/MEMORY.md,
journal/NOW.md, last 5 decisions, tail of log.md. Brief me.
```

## 7. Commit

```bash
git add -A
git commit -m "initial brain setup"
```

Verify `inbox/` and `raw/` are gitignored before pushing (they are by default):

```bash
git push
```

## Ongoing

- **During work:** say "capture this" to your AI → it writes `inbox/<date>-<slug>.md`
- **Session end:** ask your AI to run `/quick-sync` logic from the SKILL.md file
- **Weekly:** `/deep-sync` for drift detection and snapshots

## Why Claude Code is faster

Skills in `.claude/skills/` become one-line commands (`/orient`, `/ingest`). Without Claude Code you paste the SKILL.md logic manually. Same output, more copy-paste. If you use the brain daily, [install Claude Code](https://docs.claude.com/en/docs/claude-code).
