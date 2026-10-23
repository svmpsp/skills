# 0001. Record architecture decisions

- **Status:** Accepted
- **Date:** 2026-10-23
- **Deciders:** Sivam Pasupathipillai

## Context

This repository ships the SDD workflow itself, in which a maintained `specs/`
directory (a content map plus Architecture Decision Records) gives agents the
*why* behind a repo's structure. For the repo to practice what it preaches it
needs a record of its significant design decisions rather than relying on
commit messages or tribal knowledge.

In practice, treating ADRs as an immutable, authoritative history backfired:
agents cited ADRs as law ("ADR-0002 says…") even after the system had moved on,
logged bug fixes as decisions, and pinned tool versions that went stale on the
next upgrade. The code and its configuration already state *what* the system
is; an ADR that restates it, or outlives it, only adds a second, drifting copy.

## Decision

We will record design decisions as ADRs under `specs/adr/`, in the lightweight
Michael Nygard format: `NNNN-kebab-title.md`, numbered monotonically, created
from `specs/adr/template.md`, and indexed in `specs/adr/README.md`.

The code is the source of truth; ADRs only explain *why* it is shaped the way it
is. Concretely:

- An ADR records a **design decision** — never a bug fix, a refactor, or a
  routine change. Those belong in the code, its tests, and the commit message.
- An ADR **never pins a version**. It names the config file where the version
  is pinned (e.g. `.tool-versions`, `pyproject.toml`), so the pin has one home.
- ADRs are **living** and always in sync with the code: they are created and
  deleted as needed, and when the system evolves past a decision the ADR is
  rewritten to describe the current decision, or deleted if it no longer
  applies. Git keeps the history.
- A new ADR is written **only after the user confirms** the decision deserves
  one.

## Consequences

- `specs/adr/` describes the system as it is now, not an archaeology of what it
  once was, so an agent can read it without filtering out dead decisions.
- When code and an ADR disagree, the default reading is that the ADR is stale;
  the fix is to rewrite or delete it, unless the user decides the code strayed.
- Agents cite code and config as evidence, and use ADRs for rationale only.
- Fewer ADRs get written, and the user stays in control of which decisions are
  worth recording.

## Alternatives considered

- **Append-only, immutable ADRs**, where a changed decision gets a new record
  and the old one stays. Rejected: the directory fills with obsolete records
  that agents keep treating as binding.
- **No formal record**, relying on commit messages and the README. Rejected:
  the rationale behind structural choices gets lost.
- **A single design document.** Rejected: harder to review per decision and to
  delete one decision cleanly.
