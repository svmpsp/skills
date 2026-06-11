# specs/

This directory holds the **Spec-Driven Development (SDD)** artifacts for this
repository. It was bootstrapped by the `sdd-init` skill and is consumed by the
downstream SDD skills (`sdd-plan`, `sdd-make`, `sdd-scan`), which read it before
planning, coding, or auditing — and update it afterward (`sdd-scan` only reads,
reporting where the repo and these specs have drifted apart).

## Contents

| Path | What it is |
|------|------------|
| [`content-map.md`](content-map.md) | A high-signal, navigable index of the repository — what it does, its top-level layout, entry points, how it's built/installed, and where to find deeper docs. |
| [`adr/`](adr/) | Architecture Decision Records: the *why* behind significant decisions, plus a [template](adr/template.md) and an [index](adr/README.md). |

## How they relate

- The **content map** answers *"where is everything and how do I run it?"* — it
  is the map you read first to orient yourself.
- The **ADRs** answer *"why is it this way?"* — they record the decisions that
  produced the structure the content map describes.

Together they are the binding context for agent work in this repo: planning is
grounded in them, and implementation honors them.

## Keeping specs in sync

These artifacts are only useful if they stay true. Treat them as part of the
code:

- When you add/rename/remove a skill or top-level file, or change the
  build/install flow, update `content-map.md` in the same change.
- When you make a significant decision, add an ADR (see
  [`adr/README.md`](adr/README.md)).

The `sdd-make` skill builds this update step into its workflow.
