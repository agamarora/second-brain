---
name: extract-entities
description: Scan a source document and return the list of entities it mentions, classified by kind (person, product, partner, competitor, concept, organization, decision), with pointers to existing wiki pages. Subskill of /ingest. Does not write; returns structured data.
allowed-tools: Read, Glob, Grep
---

Scan the source content you are given. Return a structured list of entities.

## Output format

Return a JSON array. No prose, no padding.

```json
[
  {"entity": "Jane Doe", "kind": "person", "existing_page": "wiki/people/Jane-Doe.md"},
  {"entity": "Acme Corp", "kind": "organization", "existing_page": null},
  {"entity": "cold-start problem", "kind": "concept", "existing_page": "wiki/concepts/cold-start-problem.md"}
]
```

## Rules

- **Only real entities.** Skip generic nouns, stop-words, and boilerplate.
- **Deduplicate.** One entry per unique entity. Merge variants (e.g., "J. Doe" → "Jane Doe" if context makes it clear).
- **Resolve existing pages.** For each entity, glob the relevant wiki path and check if a page exists. If yes, return the path. If no, return `null`.
- **Kinds:** `person`, `product` (your own products), `partner`, `competitor`, `concept`, `organization`, `decision`. If unsure, use `concept`.
- **Decisions** are only entities if the source explicitly states a decision in first person ("we decided X", "agreed to Y"). Otherwise, they are concepts.
- **Slugify** entity names for path lookup: lowercase, hyphen-separated for concepts; PascalCase or "First-Last" for people, products, partners, competitors, organizations.

## Steps

1. Read source (already passed in).
2. Scan for entities across 7 kinds. Aim for coverage without inflation.
3. For each, build path using the lookup table in `/ingest`.
4. Glob the path. Set `existing_page` to the path if match, else `null`.
5. Return the JSON array.
