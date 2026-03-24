---
name: codebase-context
description: Use when finishing a large multi-file implementation plan to update the project map, OR when searching for where a function/class/module lives in the codebase. Prevents re-grepping the same codebase across sessions by maintaining a rolling CODEBASE_CONTEXT.md.
---

# Codebase Context Map

## Overview

Maintain a rolling CODEBASE_CONTEXT.md at the project root: a token-efficient map of every module, key symbol, and architectural decision. Read it before searching; update it after large changes.

## Two Modes

**Mode A - Update** (trigger: just finished a large plan touching 3+ files)
1. Glob all source files
2. For each module: read symbols overview, extract purpose + key classes/functions
3. Write/overwrite CODEBASE_CONTEXT.md using the template below

**Mode B - Lookup** (trigger: need to find where something lives)
1. Read CODEBASE_CONTEXT.md first
2. Found the answer? Use it. Done.
3. Not found? Grep/glob for specifics, then add the missing entry to the map.

Token savings: One 200-line context file = ~1,500 tokens. A grep+read cycle = 3,000-8,000 tokens per query. Break even after 1 lookup per session.

## CODEBASE_CONTEXT.md Template

Use this structure when writing the context map:

- Architecture Overview: 2-3 sentences on what the system does and data flow
- Module Map: one section per file with Purpose, Key classes, Key functions, Config fields consumed, Depends on
- Config Fields Quick Reference: table of field, type, default, effect
- Data Flow: ASCII diagram or bullet list
- Known Issues / Dead Code: list of functions that exist but are never called

## Common Mistakes

- Skipping the update step - context goes stale, future sessions re-grep everything
- Writing prose instead of structured entries - make it scannable
- Documenting every private helper - public API surface only
- Omitting file paths - always include relative path
