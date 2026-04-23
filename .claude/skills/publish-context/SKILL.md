---
name: publish-context
description: Export a read-only snapshot of the brain (wiki/, journal/NOW.md, decisions/) to archive/context-export/<date>/ for cross-session or cross-repo use. Does NOT deploy to GitHub Pages — that is handled by .github/workflows/publish-brain.yml. Run on demand or weekly from /deep-sync.
allowed-tools: Read, Write, Glob, Bash
---

Export a dated, read-only snapshot of the brain for portability.

## Usage

```
/publish-context
```

No arguments. Always writes to `archive/context-export/<YYYY-MM-DD>/`.

## Steps

### 1. Compute target path

```
TARGET=archive/context-export/<YYYY-MM-DD>/
```

If the directory already exists, append `-<HHMM>` to make unique.

### 2. Copy public areas

Copy these into TARGET:
- `wiki/` (all of it)
- `journal/NOW.md` (only — skip TODO, DONE, BACKLOG)
- `decisions/` (all of it)

Skip: `inbox/`, `raw/`, `archive/`, `memory/`, `.claude/`, `scripts/`, `rules/`.

### 3. Filter private pages

Any file with frontmatter `private: true` is excluded from the export.

### 4. Write manifest

Write `TARGET/manifest.md`:

```markdown
# Context Export — <YYYY-MM-DD>

Read-only snapshot of the brain.

- Wiki pages: <count>
- Decisions: <count>
- Commit hash: <git rev-parse HEAD>
- Branch: <git branch --show-current>

## How to use

This snapshot is self-contained plain markdown. Open it in Obsidian,
read it in any editor, or hand it to another AI agent as context.
```

### 5. Mark as read-only

Write `TARGET/.READONLY` with a single line:

```
This snapshot is frozen. Do not edit in place. Re-export to refresh.
```

### 6. Append to log.md

```
## [YYYY-MM-DD] publish-context
Snapshot: archive/context-export/<YYYY-MM-DD>/
```

### 7. Return

Print the target path.
