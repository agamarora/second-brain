# Decisions format

How decisions are captured. The chain is the product.

## File location

```
decisions/YYYY-MM-DD-<slug>.md
```

- Date in ISO format
- Slug lowercase, hyphen-separated, 2-5 words
- Flat folder. No subfolders.

## Frontmatter

```yaml
---
title: <one-line title>
date: <YYYY-MM-DD>
status: <decided|superseded|reversed>
builds_on: [<prior decision slugs>]
touched: [<wiki pages this decision affects>]
---
```

## Body

```markdown
# Decision: <title>

## Context
<what prompted this decision — 1-3 sentences>

## Decision
<what was decided — plain prose>

## Alternatives considered
<bullets of options evaluated, with one-line reason each was rejected>

## Consequences
<what changes as a result — code, process, scope, relationships>

## Builds on
- [[<prior-decision-slug>]] — <one-line relationship>

## Superseded by: <new slug>
(Only if this decision is later reversed or replaced. Added retroactively.)
```

## The chain

- Every decision links forward to what it builds on via `builds_on` + `## Builds on` section
- When a decision supersedes a prior one, the prior decision gets `## Superseded by: <new slug>` appended to it (reverse link)
- Never delete a superseded decision. The trail matters.

## Capture triggers

Create a decision file whenever:
- You picked one option over others and the tradeoff is non-obvious
- You changed direction (reversed, pivoted)
- You set a constraint or scope boundary
- You committed to a deadline, deliverable, or stakeholder promise

Do NOT create a decision file for:
- Routine code choices with no tradeoff
- Things that are already obvious from the git log
- Ongoing tasks (those belong in `journal/TODO.md`)

## Why this matters

`decisions/` is the brain's memory of judgment calls. Six months from now, `grep -l <topic> decisions/*.md` tells you every choice you made that touches that topic, why, and what you chose against. That is the compounding value.
