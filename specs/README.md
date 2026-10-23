# specs/

This directory holds the **Spec-Driven Development (SDD)** artifacts for this
repository. It was bootstrapped by the `sdd-init` skill and is consumed by the
downstream SDD skills (`sdd-plan`, `sdd-make`, `sdd-scan`, `sdd-fix`,
`sdd-handout`), which read it before planning, coding, auditing, or resuming —
and update it afterward (`sdd-scan` only reads, reporting where the repo and
these specs have drifted apart).

## Contents

| Path | What it is |
|------|------------|
| [`content-map.md`](content-map.md) | A component-level table of contents — what the project does, its components and their purpose, how it's built/installed, and where to find deeper docs. Never a component's internals. |
| [`adr/`](adr/) | Architecture Decision Records: the *why* behind significant decisions, plus a [template](adr/template.md) and an [index](adr/README.md). |

## How they relate

- The **content map** answers *"where is everything and how do I run it?"* — it
  is the map you read first to orient yourself.
- The **ADRs** answer *"why is it this way?"* — they record the decisions that
  produced the structure the content map describes.

Neither replaces the code, which is the source of truth for what the system
does. The specs are context: they orient an agent and explain the reasoning,
and when they disagree with the code they are usually the thing that is stale.

## Keeping specs in sync

These artifacts are only useful if they stay true. Treat them as part of the
code:

- Update `content-map.md` only when a component is added or removed, or a
  component's goal or high-level description changes — nothing else
  ([ADR-0007](adr/0007-content-map-is-a-component-index.md)).
- When you make a design decision, propose an ADR and write it once the user
  confirms (see [`adr/README.md`](adr/README.md)). Bug fixes and version bumps
  never get one.
- When the system outgrows an ADR, rewrite or delete it.

The `sdd-make` skill builds this update step into its workflow.
