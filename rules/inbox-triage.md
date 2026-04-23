# Inbox triage

What goes where. Keep the inbox flowing — nothing accumulates.

## What `inbox/` is for

A single flat folder for raw captures. Drop anything here:
- Meeting notes scribbled mid-call
- Articles / tweets / links you want to digest later
- Voice memos transcribed
- Screenshots with context pasted in
- Half-formed thoughts
- Any markdown you haven't decided what to do with

Format: `inbox/<YYYY-MM-DD>-<short-slug>.md` for markdown captures. Binaries go in `raw/` (PDFs, images, audio, video).

## Frontmatter on inbox notes

```yaml
---
title: <one-line title>
date: <YYYY-MM-DD>
status: raw
source: <where this came from — person, URL, meeting, etc.>
---
```

`status` values:
- `raw` — captured, not yet processed
- `ingested` — processed by `/ingest`, reference copy lives here
- `orphaned` — reviewed and not relevant to keep in the brain (kept for audit trail)

## The flow

```
capture → inbox/ (status: raw)
         ↓ /ingest
         → wiki/ pages touched with [Source: ...] markers
         → inbox note updated to status: ingested
```

## When to capture to inbox

- Immediately, during work. Do not edit-as-you-capture. Capture raw, process later via `/ingest`.
- If you have any doubt whether it matters — capture it. The `orphaned` status exists for a reason.

## When to bypass inbox

- **Decisions** go directly to `decisions/<date>-<slug>.md`, not through inbox.
- **Task items** go directly to `journal/TODO.md`.
- **Binaries** (PDF, DOCX, images) go directly to `raw/` with a companion `<file>.meta.md` if needed.

## Processing cadence

Run `/quick-sync` at the end of every work session. It calls `/ingest` on every inbox note with `status: raw`. Never let the inbox accumulate — a 100-note inbox is a 100-note triage problem.

## Gitignored by default

`inbox/**` is gitignored by default (see `.gitignore`). This is deliberate: raw captures often contain sensitive content you haven't reviewed yet. To track a specific note in git, `git add -f inbox/<note>.md`. Better: let `/ingest` process it, then track the resulting wiki enrichments.
