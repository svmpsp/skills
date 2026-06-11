# 0001. Record architecture decisions

- **Status:** Accepted
- **Date:** 2026-06-11
- **Deciders:** Repository maintainers

## Context

This repository ships the SDD workflow itself, in which a maintained `specs/`
directory (a content map plus Architecture Decision Records) grounds agent
work. For the repo to practice what it preaches — and to give future
contributors and agents the *why* behind its structure — it needs a durable,
versioned record of significant decisions rather than relying on commit
messages or tribal knowledge.

## Decision

We will record architecture decisions as ADRs stored under `specs/adr/`,
following the lightweight format popularized by Michael Nygard. Each ADR is a
Markdown file named `NNNN-kebab-title.md` with a monotonically increasing
number, captured from `specs/adr/template.md`, and indexed in
`specs/adr/README.md`.

## Consequences

- The rationale behind decisions is preserved next to the code and reviewed
  through the normal pull-request process.
- Contributors must spend a little effort writing an ADR when they make a
  significant decision, and keep the index up to date.
- ADRs are immutable once Accepted; revisiting a decision means adding a new
  ADR that supersedes the old one rather than editing history.

## Alternatives considered

- **No formal record** — relying on commit messages and the README. Rejected:
  decisions get lost and contradicts the SDD philosophy this repo embodies.
- **A single design document** — one growing file. Rejected: harder to review
  per-decision and to express supersession over time.
