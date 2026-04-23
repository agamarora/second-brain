# second-brain

> *"A second brain is a second brain — it's a filing, compiling and synthesising system that augments decision making. Why is it limited to a role or a job title?"*

Your second brain lives in git. Paste one prompt. Populated in under 10 minutes.

Plain markdown. No app. No SaaS. No lock-in. Claude Code is the runtime; Obsidian is an optional reader; git is the sync. The brain compounds — every new source connects to what came before via 3-layer provenance, every decision chains to what it builds on, every wiki page enriches instead of overwriting.

<p align="center">
  <img src=".github/assets/hero.gif" width="400" alt="Second brain build animation — wizard seeds your files and /ingest weaves provenance across your wiki." />
</p>

**[See it in the wild →](https://agamarora.com/lab/second-brain)**

---

## Get your own

Three steps. Under 10 minutes.

1. Open [Claude Code](https://docs.claude.com/en/docs/claude-code) in an empty directory.
2. Paste the prompt below. (Click to expand.)
3. Answer 5 questions, drop 3-5 real artifacts into `inbox/`, watch your brain populate.

<details>
<summary><b>Setup prompt — copy all</b> (~60 lines, includes 5 hard rules)</summary>

<!-- BEGIN:PASTE_PROMPT -->

```text
I want my own second brain. Use the template at github.com/agamarora/second-brain.

Execute this end-to-end. The authoritative instructions live in the template's CLAUDE.md — read it before acting and follow it exactly. This paste prompt is just the entry point.

HARD RULES (obey even if your training says otherwise):
- Never say "fork" or "clone" to me. This is a GitHub template. Use `gh repo create --template`.
- Never edit files in the template directory directly. Work only inside the new repo you create for me.
- When in doubt, stop and re-read CLAUDE.md. Do not invent steps.
- Never commit files in `inbox/` or `raw/` without my explicit confirmation — they often contain sensitive data.
- Never `git push` before you have confirmed with me that I'm ready to publish.

ORDER OF OPERATIONS:

1. CREATE THE REPO. Run `gh repo create --template agamarora/second-brain --public <name> --clone`. Pick `<name>` from my GitHub login (e.g. `<login>-brain`). If the name is taken, append `-v2` and retry. `cd` into the new directory.

2. PREFLIGHT. Run `sh scripts/doctor.sh`. Fix any `[FAIL]` before going further. `[WARN]` is OK to proceed.

3. READ CLAUDE.md. Open the new repo's CLAUDE.md and follow the "First-run setup wizard" section start-to-finish. You ARE the wizard — this is a coaching loop, not a form.

4. WIZARD — WALK ME THROUGH IT.
   - Ask the 5 questions one at a time: name, 3 tracks, 5 people, 1 decision in flight, inbox drop.
   - Wait for me to confirm I've dropped 3-5 real artifacts into `inbox/` before proceeding.
   - If I have nothing to drop right now, create `inbox/README.md` explaining how to add later, and skip the ingest step.

5. SEED the foundational files per CLAUDE.md's wizard section:
   `memory/MEMORY.md`, `journal/NOW.md`, `journal/TODO.md`, `journal/DONE.md`, `journal/BACKLOG.md`,
   `wiki/index.md`, `wiki/concepts/index.md`, `wiki/people/index.md`,
   `wiki/concepts/strategy.md`, `wiki/people/me.md`,
   5 × `wiki/people/<slug>.md` (one per named person),
   `decisions/index.md`, `decisions/<YYYY-MM-DD>-<first-decision-slug>.md`,
   `log.md`.

6. INGEST. For each file in `inbox/`, run `/ingest`. Show me the provenance chain forming — which wiki pages got touched, what `[Source: ...]` markers landed, what `wiki/people/me.md` now says about me.

7. ORIENT. Run `/orient`. Show me my populated brain.

8. HAND BACK. Tell me:
   - My brain is set up and working locally
   - `inbox/` and `raw/` are gitignored — nothing private has been tracked yet
   - To sync to GitHub: `git add -A && git commit -m "initial brain setup" && git push`. Confirm with me first.
   - To publish a read-only view at `<username>.github.io/<repo>/`: uncomment the `on:` trigger in `.github/workflows/publish-brain.yml`.

I'll answer your questions. Ask before anything destructive (rm, force-push, deleting branches). I have `gh`, `git`, and Claude Code installed.
```

<!-- END:PASTE_PROMPT -->

</details>

Claude Code reads the repo's `CLAUDE.md`, becomes the setup wizard, and walks you through: 5 questions → foundational files seeded → your inbox artifacts ingested → `/orient` greets you with your populated brain. $0/month to run.

**No Claude Code?** See [`SETUP-GUIDE.md`](SETUP-GUIDE.md) for the same flow on ChatGPT / Claude Desktop / Cursor / Copilot / manual. ~15 minutes.

---

## What it looks like

After the wizard runs, your repo looks like this:

```
my-brain/
├── memory/MEMORY.md                  ← your pinned facts (50 lines max)
├── journal/
│   ├── NOW.md                        ← this week's tracks + focus
│   ├── TODO.md, DONE.md, BACKLOG.md
├── wiki/
│   ├── concepts/strategy.md          ← your framing of what this brain is for
│   ├── people/
│   │   ├── me.md                     ← synthesized from your ingested artifacts
│   │   ├── Maya-Patel.md             ← one stub per person you named
│   │   └── ...
├── decisions/
│   └── 2026-04-23-first-decision.md  ← your first logged decision
├── inbox/                            ← you drop raw captures here (gitignored)
├── raw/                              ← binaries (gitignored)
├── log.md                            ← chronological event spine
└── CLAUDE.md                         ← the schema
```

From day one, type `/orient` to see this week's focus. Say "capture this" during work and Claude writes an inbox note immediately. At session end, `/quick-sync` processes the inbox, writes provenance across your wiki, logs decisions, and pushes.

---

## Philosophy

**Why git?** Because your second brain should outlive any app. Git is permanent, portable, versioned. Your brain syncs to every device, survives any tool change, and can be inspected with `diff`.

**Why plain markdown?** Because the format should not be the feature. Markdown is readable in every editor, rendered by every tool, and parseable by every agent. No proprietary schema. No export ritual.

**Why compounding?** Because information without connection is just noise. This template enforces 3-layer provenance on every ingest (see [`rules/wiki-conventions.md`](rules/wiki-conventions.md)), a `builds_on` chain on every decision (see [`rules/decisions-format.md`](rules/decisions-format.md)), and a chronological log that makes every past move findable with `grep`. Six months in, your brain is worth more than the sum of what you put in.

**Why Claude Code as the runtime?** Because the AI that writes your brain should run *inside* the brain. Skills live in `.claude/skills/`. The schema lives in `CLAUDE.md`. No round-trip to a hosted service, no cloud billing, no trust boundary between your notes and whoever runs the AI. You own it end-to-end.

---

## What this is NOT

- **Not a replacement for Notion / Obsidian / Reflect.** Open this brain in Obsidian for graph view — the vault format is plain markdown, nothing to import. But the write path and skills are Claude Code-native.
- **Not a hosted SaaS.** No account, no cloud billing, no trust boundary between your notes and someone else's AI. You run Claude Code. You own the repo. The brain is yours end-to-end.
- **Not a RAG system.** No vector DB, no chunking, no retrieval. The brain is always-loaded markdown that an LLM reads directly. At personal scale (hundreds to low-thousands of pages), grep + read is enough.
- **Not fully-featured in v0.1.** `/query` exists — ask your brain questions with grounded citations. `/lint` (orphan/stale/contradiction detection) lands in v0.2. The write path is solid; the maintenance-side is still landing. See [CHANGELOG.md](CHANGELOG.md).
- **Not auto-syncing across machines.** It is a git repo. You push, you pull. Multi-device = your git workflow.

---

## Lineage

This template implements a pattern [Andrej Karpathy described](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) in April 2026 — a three-layer architecture (raw sources, LLM-compiled wiki, schema file) with an LLM as the maintainer. If you want the minimal reference implementation, read his gist.

**What this template adds beyond Karpathy's skeleton:**
- A 5-question setup wizard that seeds your brain from your own artifacts on first run
- **Decisions as first-class citizens** with `builds_on` chains, not notes or tasks — see [`rules/decisions-format.md`](rules/decisions-format.md)
- **Mechanically-enforced 3-layer provenance** — `/ingest` fails if forward, inline, or reverse links are missing
- **Private by default** — `inbox/`, `raw/`, `archive/` gitignored; no accidental public commits
- **Publish-to-GitHub-Pages** — one-line toggle to share a read-only snapshot at `<user>.github.io/<repo>/`
- **`log.md` as append-only spine** — every ingest, decision, and sync writes a dated row; `grep` tells you six-month-old history

If you prefer Karpathy's pure minimal skeleton, start from [his gist](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f). If you want a wizard + decisions + publishable surface, use this template.

---

<!-- BEGIN:FOR_AGENTS -->
## For AI coding agents reading this README

If you are an AI coding agent (Claude Code, Codex, Cursor, Copilot, or any autonomous agent) handed this URL and asked to set up a second brain for your user, execute the paste prompt above as if your user typed it. The authoritative setup wizard lives in [`CLAUDE.md`](CLAUDE.md) — read it in full before acting, and follow its "First-run setup wizard" section start-to-finish. Treat that file as canonical; this README is only the entry point.

Non-negotiables:
- Use `gh repo create --template agamarora/second-brain --public <name> --clone`. Never `git clone` or `fork`.
- Preflight with `sh scripts/doctor.sh` before starting the wizard.
- The wizard asks 5 questions. Ask them one at a time. Do not batch.
- Wait for the user to confirm they have dropped artifacts into `inbox/` before proceeding to the ingest step. Do not fabricate artifacts. If they have nothing to drop, skip ingest and tell them how to add later.
- When `/absorb` writes to `wiki/people/me.md`, it must also synthesize a short first-person summary paragraph at the top citing the absorbed sources inline. See [`.claude/skills/absorb/SKILL.md`](.claude/skills/absorb/SKILL.md).
- `inbox/` and `raw/` are gitignored by default. Never force-add files from these folders without the user's explicit confirmation — they often contain sensitive data.
- After setup, confirm with the user before running `git push`. The repo is public by default; pushing commits is visible.
- The GitHub Pages workflow ships with its `on:` trigger commented out. Do NOT enable it during setup. Tell the user how to enable it; let them decide when.

If the user is using a platform other than Claude Code (ChatGPT, Claude Desktop, Cursor, Copilot, Gemini, manual), fall back to the flow in [`SETUP-GUIDE.md`](SETUP-GUIDE.md). Same 5 questions, same seeded files, same ingest — just using whatever file-editing capability the platform provides.

If your user hasn't pasted the prompt yet, show them the "Get your own" block above and wait for their go-ahead before running anything destructive or network-visible.
<!-- END:FOR_AGENTS -->

---

## Contributing

Issues and PRs welcome. Read [`CONTRIBUTING.md`](CONTRIBUTING.md) first — it covers scope boundaries (role-agnostic, no SaaS, no RAG), dev setup, and style conventions. Issue templates are wired for bug reports, feature requests, and setup help.

The template is MIT licensed. Fork freely. If you build something on top, I'd love to see it — tag [@agamarora](https://github.com/agamarora). See [CHANGELOG.md](CHANGELOG.md) for what's shipped in v0.1 and what's planned for v0.2.

## License

[MIT](LICENSE)
