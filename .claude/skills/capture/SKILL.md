---
name: capture
description: Drop an in-conversation thought, link, quote, or observation into inbox/ as a timestamped note. Writes the file immediately — no triage, no processing. Use whenever the user says "capture this", "save this", "add to inbox", or describes something they want to keep but not act on right now.
allowed-tools: Write, Bash
---

Turn a conversation fragment into a raw capture in one shot. No editing, no synthesis, no triage. Processing happens later via `/ingest`.

## Trigger phrases

Invoke this skill when the user says any of:

- "capture this"
- "save this"
- "add to inbox"
- "put this in my brain"
- "jot this down"
- "keep this for later"
- "hold onto this"

Or when the user describes something valuable mid-conversation and asks Claude to remember it without acting on it.

## Steps

### 1. Figure out the content

The content is **whatever the user just said or referenced**. Three cases:

- **Direct content** — user pasted a quote, a link, a thought. Use verbatim.
- **Referenced content** — user said "capture that thing Ravi said about pricing." Scroll back in the conversation, lift the exact passage, include attribution.
- **User instruction** — user says "capture this: I want to try usage-based pricing." Use the instruction as the capture body.

If the content is ambiguous, ask one clarifying question: "Capture [A] or [B]?" Do not invent content.

### 2. Build the filename

```
inbox/<YYYY-MM-DD>-<slug>.md
```

Slug rules:
- Lowercase, hyphen-separated, 3-6 words
- Derived from the content itself — not the surrounding conversation
- Examples: `inbox/2026-04-23-ravi-on-hybrid-pricing.md`, `inbox/2026-04-23-karpathy-llm-wiki-gist.md`

If a file with the same name exists, append `-2`, `-3`, etc.

### 3. Write the frontmatter + body

```markdown
---
title: <one-line summary of what's being captured>
date: <YYYY-MM-DD>
status: raw
source: <where this came from — conversation, URL, person, meeting, etc.>
---

# <title>

<the captured content — verbatim where possible>

## Context

<1-2 sentences on why this was captured — what the user said or what triggered it>
```

### 4. Confirm succinctly

Return one line:

```
Captured → inbox/<YYYY-MM-DD>-<slug>.md
```

Do not summarize the content back. Do not suggest next steps. The capture is the whole action.

## What NOT to do

- **Do not `/ingest` the file.** Capture and ingest are separate phases. The user will run `/quick-sync` at session end (or `/ingest` explicitly) to process the inbox.
- **Do not overwrite an existing inbox file.** Append `-2` if collision.
- **Do not write a wiki page directly.** Capture goes to `inbox/` only. Wiki pages get enriched by `/ingest` later.
- **Do not edit the user's phrasing.** Capture verbatim when possible.

## Failure modes

- **No content clear** → ask: "Capture what exactly? Paste the text or point me at the message."
- **File collision with different content** → append `-2` or `-3`. Never overwrite.
- **`inbox/` missing** → create `inbox/.gitkeep` first, then the capture.
