# 0004. AGENTS.md is a thin pointer to specs/

- **Status:** Accepted
- **Date:** 2026-06-11
- **Deciders:** sdd-skills maintainers

## Context

`AGENTS.md` (and its `CLAUDE.md` symlink) is loaded into an agent's context on
every session, so it is tempting to make it a complete project briefing: an
overview, build/test/run commands, code conventions. But in an SDD repository
all of that already lives in `specs/` — the project overview, layout, and
build/install/test flow in [`content-map.md`](../content-map.md), and the *why*
behind decisions in the ADRs.

Duplicating that material in `AGENTS.md` creates two copies that drift apart:
the content map is the artifact the SDD skills read and maintain, while a fat
`AGENTS.md` quietly goes stale and starts contradicting it.

## Decision

We will keep `AGENTS.md` as small as possible. It states that the repo is
SDD-governed, points at `specs/content-map.md` and `specs/adr/` as the source of
truth, and instructs the reader to keep it minimal. It does **not** restate the
overview, commands, or conventions that `specs/` already records.

The `sdd-init` skill generates this thin pointer when bootstrapping a repo, and
treats anything more than orientation as belonging in `specs/`.

## Consequences

- There is a single source of truth; the content map and ADRs cannot be
  contradicted by a parallel briefing that no one updates.
- An agent still gets oriented from the always-loaded `AGENTS.md`, then reads
  the specs for detail — the SDD skills already do this.
- Repos that already have a substantial `AGENTS.md` need their content migrated
  into `specs/` rather than left in place; `sdd-init` surfaces this rather than
  overwriting user content.

## Alternatives considered

- **A self-contained `AGENTS.md`** with the full overview and commands inline:
  rejected because it duplicates `content-map.md` and inevitably drifts.
- **No `AGENTS.md` at all**, relying only on `specs/`: rejected because
  `AGENTS.md`/`CLAUDE.md` is the conventional auto-loaded entry point; a thin
  pointer is what guarantees the reader is sent to the specs.
