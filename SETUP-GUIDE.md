# Setup guide — without Claude Code

The canonical setup flow uses Claude Code, which reads `CLAUDE.md` and runs the wizard for you. If you are using another tool, the flow is the same — you just drive it manually.

Estimated time: 15 minutes.

## Supported alternatives

- ChatGPT (with file upload or canvas)
- Claude Desktop
- Cursor
- GitHub Copilot
- Gemini
- Manual (any plain text editor)

## Step 0 — Create the repo

Use GitHub's "Use this template" button on [github.com/agamarora/second-brain](https://github.com/agamarora/second-brain), or run:

```bash
gh repo create --template agamarora/second-brain --public <your-name>-brain --clone
cd <your-name>-brain
```

## Step 1 — Preflight

```bash
sh scripts/doctor.sh
```

Fix any `[FAIL]` before continuing.

## Step 2 — Answer the 5 wizard questions

Open a chat with your AI tool of choice. Paste this:

```
I'm setting up a second brain using the template at github.com/agamarora/second-brain.
I'm using <your tool>, not Claude Code. Walk me through the 5-question setup wizard
described in CLAUDE.md (the "First-run setup wizard" section). Ask me one question
at a time. For each file that needs to be written, output the full file contents in
a code block so I can save it manually.
```

Then answer:

1. **Name** — how should your brain address you?
2. **Three tracks** — 2-4 things you're actively pushing on right now
3. **Five people** — names who show up most in your work this month
4. **One decision** — biggest open decision you're sitting on
5. **Inbox drop** — add 3-5 real artifacts to `inbox/` (LinkedIn PDF, Google Doc export, meeting transcript, weekly review, any markdown you have lying around)

## Step 3 — Create the seeded files

Your AI tool will output contents for these files. Save each one:

- `memory/MEMORY.md`
- `journal/NOW.md`
- `wiki/concepts/strategy.md`
- `wiki/people/me.md`
- 5 × `wiki/people/<name>.md` (one per person from Q3)
- `decisions/<YYYY-MM-DD>-<first-decision-slug>.md`

## Step 4 — Run ingest manually

For each file in `inbox/`, ask your AI tool:

```
Run the /ingest logic described in .claude/skills/ingest/SKILL.md on the file
at inbox/<filename>. For each entity detected, update the appropriate wiki page
with a [Source: ...] marker and add a row to the page's "Sources that shaped
this page" table. Write the provenance frontmatter on the source file. Append
a row to log.md.
```

If your tool can't edit files directly, ask it to output the full updated contents of each touched file and save them manually.

## Step 5 — Run orient

Ask your AI tool:

```
Run the /orient logic described in .claude/skills/orient/SKILL.md. Read memory/MEMORY.md,
journal/NOW.md, the last 5 files in decisions/, and the tail of log.md. Give me
the briefing.
```

## Step 6 — Commit

```bash
git add -A
git commit -m "initial brain setup"
```

Don't push yet — review that `inbox/` and `raw/` are gitignored (they are by default). When ready:

```bash
git push
```

## Ongoing

- **During work:** capture notes into `inbox/` manually, or ask your AI tool to create an `inbox/<date>-<slug>.md` when you say "capture this."
- **Session end:** ask your AI tool to run the `/quick-sync` logic from `.claude/skills/quick-sync/SKILL.md`.
- **Weekly:** run `/deep-sync` logic for drift detection and snapshots.

## Why Claude Code is easier

The template ships with skills in `.claude/skills/` that Claude Code invokes with a single `/skill-name` command. Without Claude Code, you are manually invoking the logic described in each SKILL.md. Same output, more copy-paste.

If you end up using the brain daily, consider installing Claude Code — the skills become one-line commands.
