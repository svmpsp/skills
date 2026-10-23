# Architecture Decision Records

This directory holds **Architecture Decision Records (ADRs)** — short documents
that capture the *why* behind significant decisions in this repository, using
the lightweight format from [ADR-0001](0001-record-architecture-decisions.md).

## What an ADR is

An ADR records a single **design decision**: the context and forces at play,
the decision made (in active voice), its consequences, and the alternatives
weighed. The code is the source of truth; an ADR only explains *why* it is
shaped that way ([ADR-0001](0001-record-architecture-decisions.md)).

An ADR is **not**:

- a record of a bug fix, refactor, or routine change — that is the commit
  message;
- a place to pin a version — name the config file that pins it instead;
- permanent — when the system evolves, rewrite the ADR to match the current
  decision, or delete it if the decision no longer applies. Git keeps the
  history.

## Conventions

- **Filename:** `NNNN-kebab-title.md`, where `NNNN` is a zero-padded,
  **monotonically increasing** number (the next free integer; numbers of
  deleted ADRs are not reused).
- **Template:** copy [`template.md`](template.md) for new records.
- **Status:** `Proposed` (not yet in place) or `Accepted` (the system works
  this way). Record it in the header.
- **Index:** keep the list below in sync in the same change.

## How to add a new ADR

1. Confirm with the user that the decision deserves an ADR.
2. Copy `template.md` to `NNNN-your-title.md` using the next number.
3. Fill in Status, Date, Deciders, and the four sections.
4. Add a row to the index below.
5. If it adds or removes a component or changes a component's purpose, also
   update [`../content-map.md`](../content-map.md).

## Index

| ADR | Title | Status |
|-----|-------|--------|
| [0001](0001-record-architecture-decisions.md) | Record architecture decisions | Accepted |
| [0002](0002-dev-tools-and-testing.md) | Development tooling and testing | Accepted |
| [0003](0003-ci-and-release-workflow.md) | CI and release workflow | Proposed |
| [0004](0004-agents-md-is-a-thin-pointer.md) | AGENTS.md is a thin pointer to specs/ | Accepted |
| [0005](0005-skill-support-files-layout.md) | Skill support files live in standard subdirectories | Accepted |
| [0006](0006-handout-is-a-transient-session-bridge.md) | HANDOUT.md is a transient, gitignored session bridge at the repo root | Accepted |
| [0007](0007-content-map-is-a-component-index.md) | The content map is a component-level index | Accepted |
