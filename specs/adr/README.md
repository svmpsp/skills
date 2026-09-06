# Architecture Decision Records

This directory holds **Architecture Decision Records (ADRs)** — short documents
that capture the *why* behind significant decisions in this repository, using
the lightweight format from [ADR-0001](0001-record-architecture-decisions.md).

## What an ADR is

An ADR records a single architecturally significant decision: the context and
forces at play, the decision made (in active voice), its consequences, and the
alternatives weighed. ADRs are append-only history: once a decision is
**Accepted** you don't rewrite it — you add a new ADR that supersedes it.

## Conventions

- **Filename:** `NNNN-kebab-title.md`, where `NNNN` is a zero-padded,
  **monotonically increasing** number (the next free integer).
- **Template:** copy [`template.md`](template.md) for new records.
- **Lifecycle / status:** `Proposed` → `Accepted` → `Deprecated` or
  `Superseded by [ADR-XXXX](...)`. Record the status in the header.
- **Index:** add new ADRs to the list below in the same change.

## How to add a new ADR

1. Copy `template.md` to `NNNN-your-title.md` using the next number.
2. Fill in Status, Date, Deciders, and the four sections.
3. Add a row to the index below.
4. If it changes the repo's structure or workflow, also update
   [`../content-map.md`](../content-map.md).

## Index

| ADR | Title | Status |
|-----|-------|--------|
| [0001](0001-record-architecture-decisions.md) | Record architecture decisions | Accepted |
| [0002](0002-dev-tools-and-testing.md) | Development tooling and testing | Accepted |
| [0003](0003-ci-and-release-workflow.md) | CI and release workflow | Proposed |
| [0004](0004-agents-md-is-a-thin-pointer.md) | AGENTS.md is a thin pointer to specs/ | Accepted |
| [0005](0005-skill-support-files-layout.md) | Skill support files live in standard subdirectories | Accepted |
| [0006](0006-handout-is-a-transient-session-bridge.md) | HANDOUT.md is a transient, gitignored session bridge at the repo root | Accepted |
