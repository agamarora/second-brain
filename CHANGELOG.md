# Changelog

All notable changes to this template. Dates in ISO format. Semantic version.

## v0.1 — 2026-04-23

Initial public release.

### Added
- **Setup wizard** — 5-question CLAUDE.md wizard seeds a working brain in under 10 minutes (name, 3 tracks, 5 people, 1 open decision, inbox drop)
- **9 skills** in `.claude/skills/`: orient, ingest, query, extract-entities, absorb, new-page, quick-sync, deep-sync, publish-context
- **3 rules files** in `rules/`: wiki-conventions, decisions-format, inbox-triage
- **3-layer provenance** mechanically enforced by `/ingest` — the skill fails if forward frontmatter, inline markers, or reverse tables are missing
- **Decisions-as-first-class** with `builds_on` chain and retroactive `## Superseded by:` links
- **Query skill** — natural-language questions against the brain with grounded citations
- **GitHub Pages publish workflow** (private-by-default, one-line toggle to enable)
- **Private-by-default `.gitignore`** — `inbox/`, `raw/`, `archive/` not tracked without `git add -f`
- **Wiki-link rewrite** in published Pages output — `[[name]]` → `<a href="name.html">` (same-folder heuristic; cross-folder deferred to v0.2)
- **Doctor preflight** — `sh scripts/doctor.sh` checks `gh` presence, `gh auth status`, git config, Claude Code detection, cwd writable, inbox readiness
- **SETUP-GUIDE.md** — fallback for non-Claude-Code tools (ChatGPT, Claude Desktop, Cursor, Copilot, manual)

### Design decisions
- **Extract, don't abstract** — shipped the opinionated skeleton verbatim, not a "configurable framework"
- **Runtime is Claude Code + Git** — no SaaS, no hosted infra, no eval loop
- **Auto-create entities on ingest** — `/ingest` no longer prompts y/n per new entity; sources with 10+ entities flow without interruption. Use `/ingest --ask <path>` for interactive mode.
- **MIT license** — matches ai-resume, permissive, fork freely
- **Subpath PRFAQ URL** — `agamarora.com/lab/second-brain`, not a subdomain

### Not in v0.1 (planned for v0.2)
- `/lint` skill — orphan page detection, broken-link detection, stale-claim flagging, contradiction detection, index hygiene
- Global `wiki/index.md` auto-maintenance — Karpathy-style content catalog with one-line summaries, updated on every ingest
- `/capture` skill as explicit SKILL.md — currently convention-only (`say "capture this"`)
- CI wizard-dry-run — a GitHub Action that stamps the template + runs the wizard on every PR to catch schema regressions
- Full wiki-link path resolution in Pages build — current heuristic assumes same-folder targets
- Obsidian vault config stub — a commented `.obsidian/` scaffold for first-time Obsidian users

### Credits
Pattern inspired by [Andrej Karpathy's LLM Wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) (April 2026). Extensions listed under "What this template adds" in README.
