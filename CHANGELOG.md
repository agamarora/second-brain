# Changelog

All notable changes to this template. Dates in ISO format. Semantic version.

## v0.1 — 2026-04-23

Initial public release.

### Added
- **Setup wizard** — 5-question CLAUDE.md wizard seeds a working brain in under 10 minutes (name, 3 tracks, 5 people, 1 open decision, inbox drop)
- **12 skills** in `.claude/skills/`: orient, help, capture, ingest, query, lint, extract-entities, absorb, new-page, quick-sync, deep-sync, publish-context
- **3 rules files** in `rules/`: wiki-conventions, decisions-format, inbox-triage
- **3-layer provenance** mechanically enforced by `/ingest` — the skill fails if forward frontmatter, inline markers, reverse tables, or the global catalog row is missing
- **Decisions-as-first-class** with `builds_on` chain and retroactive `## Superseded by:` links
- **/query skill** — natural-language questions against the brain with grounded citations, no hallucination
- **/lint skill** — Karpathy's 3rd core operation. Orphan pages, broken wiki-links, stale claims, contradictions, index hygiene. Optional `--fix` for unambiguous repairs.
- **/capture skill** — explicit SKILL.md for the "capture this" shortcut. Writes `inbox/<date>-<slug>.md` with frontmatter. No triage.
- **/help skill** — lists all available skills with one-line descriptions
- **Global `wiki/index.md` page catalog** — auto-maintained by `/ingest` and `/new-page`. Karpathy's content catalog with one-line summaries. `/deep-sync` keeps it fresh via `/lint`.
- **Binary ingest support** — `/ingest` walks through PDF/DOCX/image/audio cases with companion `.meta.md` pattern
- **GitHub Pages publish workflow** (private-by-default, one-line toggle to enable)
- **Private-by-default `.gitignore`** — `inbox/`, `raw/`, `archive/` not tracked without `git add -f`
- **Wiki-link rewrite** in published Pages output — `[[name]]` → `<a href="name.html">` (same-folder heuristic; cross-folder deferred to v0.2)
- **Doctor preflight** — `sh scripts/doctor.sh` checks `gh` presence, `gh auth status`, git config, Claude Code detection, cwd writable, inbox readiness
- **CI sanity workflow** — `.github/workflows/sanity.yml` runs on every push/PR, catches regressions (doctor exits clean, SKILL.md frontmatter valid, required files present, `.gitignore` protects private areas, publish-brain.yml ships disabled)
- **SETUP-GUIDE.md** — fallback for non-Claude-Code tools (ChatGPT, Claude Desktop, Cursor, Copilot, manual)
- **Issue templates** — bug report, feature request, setup help
- **CONTRIBUTING.md** — scope boundaries, dev setup, style conventions
- **Hero gif** in README above the fold

### Design decisions
- **Extract, don't abstract** — shipped the opinionated skeleton verbatim, not a "configurable framework"
- **Runtime is Claude Code + Git** — no SaaS, no hosted infra, no eval loop
- **Auto-create entities on ingest** — `/ingest` no longer prompts y/n per new entity; sources with 10+ entities flow without interruption. Use `/ingest --ask <path>` for interactive mode.
- **MIT license** — matches ai-resume, permissive, fork freely
- **Subpath PRFAQ URL** — `agamarora.com/lab/second-brain`, not a subdomain

### Deferred to v0.2
- Full wiki-link path resolution in published Pages output — current heuristic assumes same-folder targets
- Obsidian vault config stub — a commented `.obsidian/` scaffold for first-time Obsidian users
- Full wizard-dry-run in CI — requires a Claude Code CI image that doesn't exist yet. Current sanity.yml catches structural regressions but not behavior regressions.
- `/absorb` me.md synthesis caching — avoid re-reading the whole page on every absorb

### Credits
Pattern inspired by [Andrej Karpathy's LLM Wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) (April 2026). Extensions listed under "What this template adds" in README.
