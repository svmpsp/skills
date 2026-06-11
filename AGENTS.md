# AGENTS.md

This repository practices **Spec-Driven Development (SDD)**: its
[`specs/`](specs/) directory is the single source of truth for what this project
is, how it is built, and why it is structured the way it is. Read it before
planning or changing anything, and keep it in sync when you do.

- [`specs/content-map.md`](specs/content-map.md) — what the project is, its
  layout, entry points, and how to build/install/test it.
- [`specs/adr/`](specs/adr/) — the decisions behind the structure (the *why*).

Keep this file minimal. Anything that belongs in the content map or an ADR lives
there, not here — see [ADR-0004](specs/adr/0004-agents-md-is-a-thin-pointer.md).
