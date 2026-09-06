# 0006. HANDOUT.md is a transient, gitignored session bridge at the repo root

- **Status:** Accepted
- **Date:** 2026-09-06
- **Deciders:** Sivam Pasupathipillai

## Context

A long agent session eventually outgrows its context window. The durable
knowledge is already captured — structure in `content-map.md`, decisions in the
ADRs — but the *in-flight* state of a task is not: the goal being pursued, what
the session learned the hard way, and the next concrete step. The `sdd-handout`
skill records exactly that so a fresh session can continue.

Where that document lives determines whether it works. `sdd-fix` keeps its
artifacts in a scratchpad outside the repo ([ADR-0005](0005-skill-support-files-layout.md)
covers bundled files, not outputs), but a scratchpad is session-scoped: the next
session cannot find it. The candidates were the repo root, `specs/`, and a
tracked location.

## Decision

We will write the hand-off to `HANDOUT.md` at the **repository root**, keep it
**untracked** (gitignored), and treat it as **transient** — the skill deletes it
once the work it describes is finished.

It is subordinate to `specs/`: `sdd-handout` re-reads the content map and the
cited ADRs when resuming, and where handout and specs disagree, the specs win.

## Consequences

- A new session finds the hand-off deterministically: `sdd-handout` checks one
  fixed path, and that check alone selects resume-vs-create mode.
- The repo's history stays clean — one developer's in-flight scratch state never
  lands in commits or diffs, and cannot go stale in the tree.
- The flip side: the handout is not shared or backed up. It is a bridge between
  two sessions of the same person on the same checkout, and nothing more.
- `specs/` keeps a single meaning — durable, curated knowledge — uncontaminated
  by transient task state.

## Alternatives considered

- **Inside `specs/`** — discoverable, but it mixes transient task state into the
  curated source of truth and invites the next agent to read a stale handout as
  spec. Rejected.
- **A scratchpad outside the repo** (as `sdd-fix` uses) — right for diagnostic
  artifacts, wrong here: a session-scoped path defeats the entire purpose of a
  cross-session hand-off. Rejected.
- **Tracked and committed** — survives machines and is shareable, but pollutes
  history with scratch state and creates merge conflicts over a file that is
  rewritten constantly. Rejected.
