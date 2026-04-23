# Contributing

Thanks for looking. This template is small, opinionated, and personal — but issues and PRs are welcome when they sharpen the opinion or fix real friction.

## Before opening a PR

**Open an issue first.** Describe what you want to change and why. Template changes ship to every future brain that instantiates from this repo. Small differences compound. A 15-minute conversation saves a 2-hour "why did you do it that way" exchange.

The one exception: obvious typos and broken links. Send those as PRs directly.

## What "in scope" looks like

Yes:
- Bug fixes — doctor script, wizard flow, skill failures, workflow regressions
- Sharpening existing skills — clearer SKILL.md, better failure messages, tighter step boundaries
- Making the pattern more *extractable* without making it more generic (see [design rationale](https://github.com/agamarora/second-brain/blob/main/README.md#lineage))
- Platform notes — first-class Obsidian configuration, cross-shell compatibility, etc.
- Documentation polish that reduces time-to-first-ingest for new users

No:
- Role packs (PM-brain, designer-brain, researcher-brain). Role-agnostic is the point.
- Configurable frameworks. Extract, don't abstract.
- Vector DBs, embeddings, RAG. Grep + read is enough at personal-brain scale.
- Hosted-service dependencies. The brain must run on Claude Code + Git alone.

If you're not sure, open an issue first. Maybe you'll change my mind.

## Dev setup

There is no build. Everything is plain markdown and shell.

```bash
gh repo clone agamarora/second-brain
cd second-brain
sh scripts/doctor.sh
```

To test a change end-to-end, stamp a burner repo:

```bash
gh repo create --template agamarora/second-brain --public burner-brain-$(date +%s) --clone
cd burner-brain-*
sh scripts/doctor.sh
claude
```

## Style conventions

- **Skills** (`.claude/skills/*/SKILL.md`): follow the existing structure — YAML frontmatter with `name` + `description` + `allowed-tools`, then `## Usage`, `## Steps`, `## Failure modes`. Look at `/ingest` for the gold standard.
- **Rules files** (`rules/*.md`): imperative tone, short sections, show the format before explaining it.
- **Markdown**: GitHub-flavored. No HTML unless GitHub requires it (e.g., `<details>` for collapsibles). Sentence case headings.
- **Voice**: direct, builder-facing. No marketing copy. No filler.

## Pattern lineage

This template implements [Karpathy's LLM Wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) pattern with extensions (wizard, decisions-as-first-class, publish-to-Pages). If you're proposing a change that moves us *away* from that lineage, flag it explicitly in the issue. Lineage is a feature.

## Code of conduct

Be kind. Assume good intent. No gatekeeping, no dunking. If you have the taste and the code, we'll work it out.

## License

MIT. By contributing, you agree your changes ship under the same license.
