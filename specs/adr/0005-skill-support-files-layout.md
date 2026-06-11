# 0005. Skill support files live in standard subdirectories

- **Status:** Accepted
- **Date:** 2026-06-12
- **Deciders:** Sivam Pasupathipillai

## Context

A skill is a directory whose only required file is `SKILL.md`. Some skills need
static support files too — for example, `sdd-init` ships a canonical ADR
template that it copies into a target repo's `specs/adr/template.md`. Until now
that template was inlined inside `SKILL.md`, which meant the instructions told
the agent to *retype* it from memory on every run, risking drift between repos
and bloating the always-loaded skill body.

The [Agent Skills](https://agentskills.io) open standard that Claude Code
follows defines conventional subdirectories for bundled files:

- `references/` — documentation loaded into the model's context as knowledge.
- `assets/` — templates and binary files used to produce output.
- `scripts/` — executable scripts the agent runs.

Claude Code exposes the skill's directory to instructions as
`${CLAUDE_SKILL_DIR}`.

## Decision

We will keep static support files in the standard subdirectories rather than
inlining them in `SKILL.md`, choosing the bucket by how the file is used:
`references/` for knowledge the model reads, `assets/` for templates/files
copied into output, `scripts/` for executables. A file the skill **copies
verbatim into a project** is an `assets/` file. `SKILL.md` references bundled
files via `${CLAUDE_SKILL_DIR}/...` and instructs the agent to copy them rather
than reproduce them.

Concretely, `sdd-init`'s ADR template lives only at
`skills/sdd-init/assets/template.md` and is copied into target repos; `SKILL.md`
points to it rather than reproducing it, so there is a single source of truth.

## Consequences

- Every repo bootstrapped by `sdd-init` gets the identical, canonical template;
  no per-run retyping or drift.
- The skill body stays smaller (lower recurring token cost once loaded) and the
  template has a single source of truth — `SKILL.md` points at the asset instead
  of duplicating it, so there is nothing to keep in sync.
- `make install` already copies whole skill directories, so bundled
  subdirectories ship with no install changes.

## Alternatives considered

- **Inline everything in `SKILL.md`** — simplest to read in one place, but
  forces retyping, invites drift, and grows the always-loaded body. Rejected.
- **Put the template at the skill root** (as one Claude Code docs example
  shows) — works, but doesn't scale once a skill has several support files of
  different kinds; the standard subdirectories self-document intent. Rejected in
  favor of the open-standard layout.
- **Use `references/` for the template** — `references/` is for knowledge the
  model internalizes, not artifacts copied into output; the template is copied
  verbatim, so `assets/` is the accurate bucket. Rejected.
