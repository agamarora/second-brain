---
name: new-page
description: Create a new entity or concept page with YAML frontmatter and register it in its folder's index.md. Subskill of /ingest, also callable standalone when user says "create a page for X".
allowed-tools: Read, Write, Edit, Glob
---

Create a new wiki page with proper frontmatter and index registration.

## Usage

```
/new-page <kind> <slug-or-name>
/new-page person "Jane Doe"
/new-page concept "prompt caching"
/new-page competitor "Acme"
```

## Steps

### 1. Resolve path

Use `/ingest`'s entity path lookup:

| Kind | Path pattern |
|---|---|
| person | `wiki/people/<Name>.md` (Pascal or First-Last) |
| product | `wiki/products/<Name>.md` |
| partner | `wiki/partners/<Name>.md` |
| competitor | `wiki/competitors/<Name>.md` |
| concept | `wiki/concepts/<slug>.md` (lowercase hyphen) |
| organization | `wiki/org/<Name>.md` |

### 2. Check it doesn't already exist

If the target path exists, STOP. Return: "Page already exists at <path>. Use /absorb to add a source."

### 3. Write the stub

Frontmatter:

```yaml
---
kind: <kind>
name: <display name>
created: <YYYY-MM-DD>
status: stub
touched_by: []
---
```

Body:

```markdown
# <display name>

<one-line description — if empty, write "(stub — enrich via /absorb or /ingest)">

## Sources that shaped this page

| Date | Source | What it added |
|------|--------|---------------|
```

### 4. Register in folder index

Read the folder's `index.md` (e.g., `wiki/people/index.md`). If it doesn't exist, create it with a table header:

```markdown
# <folder name>

| Name | Created | Status |
|------|---------|--------|
```

Append a row:

```
| [[<Name>]] | <YYYY-MM-DD> | stub |
```

### 5. Log

Append to `log.md`:

```
## [YYYY-MM-DD] new-page: <path> (<kind>)
```

### 6. Return

Return the created path.
