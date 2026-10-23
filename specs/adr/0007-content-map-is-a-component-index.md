# 0007. The content map is a component-level index

- **Status:** Accepted
- **Date:** 2026-10-23
- **Deciders:** Sivam Pasupathipillai

## Context

`content-map.md` is the first thing every SDD skill reads, so its value depends
on staying short and true. In practice the skills kept growing it: `sdd-make`
added an entry for every new module, file, or test location; `sdd-init` seeded
it with `path:line` references and internal organization; `sdd-scan` reported
any unlisted module as drift. The map drifted into an inventory of submodules
and implementation details — the very things that change most often and that
the code itself already documents — so it was both bloated and constantly stale.

## Decision

We will keep `content-map.md` a **table of contents**: one entry per
**component** (a top-level unit with its own purpose — an app, service,
package, or top-level directory; in this repo, a skill), each with its path and
a one-line statement of what it is for, plus the project's one-paragraph
description and how to build/install/test it at the top level.

It **never** contains a component's internals: submodules or subpackages,
lists of files inside a component, `path:line` references, implementation
details, or behavior a component's own entry point already explains.

It is **edited only** when:

- a component is added (or removed, so the index never points at nothing); or
- a component's goal or high-level description changes.

Any other change — new modules, files, helpers, or tests inside an existing
component, refactors, bug fixes — leaves the content map untouched. Decisions go
to ADRs; detail stays in the code.

## Consequences

- The map stays small enough to read in full on every invocation and rarely
  goes stale, because it only names things that rarely change.
- Agents must navigate *within* a component by reading its code, not the map.
- `sdd-init` seeds the map at this granularity, `sdd-make` and `sdd-plan`
  touch it only on the triggers above, and `sdd-scan` reports both a missing
  component and an over-detailed map as drift — but never an unlisted
  submodule.

## Alternatives considered

- **A detailed map of modules and files.** Rejected: it duplicates the code,
  goes stale on every change, and buries the orientation it exists to give.
- **No content map, rely on the tree and `README.md`.** Rejected: the SDD
  skills need one fixed, curated entry point stating each component's purpose.
