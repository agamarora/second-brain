# Decisions

Chronological log of judgment calls. One file per decision. Never rewrite the past.

| Date | Title | Status |
|------|-------|--------|
| (empty — wizard will seed your first decision) | | |

## Format

See [`rules/decisions-format.md`](../rules/decisions-format.md).

## Discovery

```bash
# Every decision touching a topic:
grep -l "<topic>" decisions/*.md

# Last 5 decisions:
ls -t decisions/*.md | head -5

# Decisions that build on a specific prior decision:
grep -l "builds_on.*<slug>" decisions/*.md
```

The chain is the product. Six months from now, you will care which past decision this one builds on.
