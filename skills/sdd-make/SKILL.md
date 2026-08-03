---
name: sdd-make
description: Spec-grounded coding skill for Spec-Driven Development (SDD). Before any planning or implementation, read the repository's specs/ directory (content map + ADRs) and honor it as a binding constraint; write DRY, KISS, self-documenting code with almost no comments; and update specs/ to reflect what changed once the task is done. Use when the user runs /sdd-make or asks to implement, build, change, or fix code in a repo that uses an SDD specs/ directory.
---

# sdd-make

The coding skill of the SDD workflow. It makes the repository's `specs/`
directory (created by `sdd-init` — a content map plus ADRs) a first-class input
and output of every change: you **read** the specs before you plan, **honor**
them while you build, write **DRY and KISS** code that documents itself instead
of being annotated, and **update** the specs once the work lands.

Apply this skill to any non-trivial coding task in an SDD repo — features, bug
fixes, refactors. It wraps your normal implementation process; it does not
replace good judgment.

## The loop

Run these phases in order. Do not jump to editing code before the read phase.

### 1. Read the specs first (always)

Before planning or writing any code:

1. Confirm `specs/` exists. If it does not, this repo is not SDD-bootstrapped —
   tell the user and offer to run `sdd-init` first, or proceed as a plain
   coding task with their go-ahead.
2. Read `specs/content-map.md` to locate the parts of the repo the task
   touches — entry points, relevant modules, test layout, config.
3. Read the relevant ADRs under `specs/adr/`. Pay attention to decisions that
   constrain the task: framework choices, datastore, conventions, testing and
   CI approach. Note the status of each (Proposed vs Accepted).
4. Read `AGENTS.md`/`CLAUDE.md` for project conventions.

Never start planning from a blank slate when a content map exists — use it to
ground yourself in how *this* repo is actually organized.

### 2. Honor the specs while planning

1. Form a plan that is consistent with the recorded decisions. The specs are
   binding: do not contradict an Accepted ADR or the content map's stated
   structure on a whim.
2. If the task **requires** deviating from a recorded decision (the right
   solution conflicts with an ADR, or an ADR is now wrong/outdated):
   - Stop and surface the conflict to the user explicitly.
   - Propose either an adjustment to the plan, or a new/superseding ADR that
     records the changed decision.
   - Do not silently violate the spec. A deviation is itself a decision that
     belongs in `specs/adr/`.
3. If the specs are silent on a choice the task forces, make a sensible
   decision in keeping with existing conventions and note it for the update
   phase (it may warrant a new ADR).

### 3. Implement — DRY and KISS

Write code that fits the existing codebase and holds these three directives:

- **DRY (Don't Repeat Yourself).** Before adding code, look for existing
  helpers, utilities, and patterns (the content map helps you find them).
  Reuse and extend rather than copy-paste. Factor genuine duplication into a
  single well-named place — but don't over-abstract a coincidence.
- **KISS (Keep It Simple).** Prefer the simplest solution that fully solves the
  task. Avoid speculative generality, premature abstraction, and clever
  indirection. Small, single-purpose functions with clear, intention-revealing
  names; readability over cleverness; no dead code.
- **Self-documenting code.** Names and structure carry the meaning. Comments are
  not where documentation lives: the *why* behind a decision belongs in an ADR,
  the *what changed* belongs in the commit message and your report.

#### Comments — write almost none

Never narrate your own changes in the source. Do not write:

- comments that justify, explain, or defend a fix — *"added a null check here
  because the caller can pass an empty list"*, *"guard against the race we saw
  in production"*, or anything referencing a bug, ticket, or this conversation;
- comments that restate the adjacent code in prose;
- change history or before/after notes — *"previously this used X"*, *"kept for
  backwards compatibility with the old path"*. Git is the history;
- banner or section comments used in place of extracting a function.

A comment earns its place only when a competent reader of this codebase would
still be surprised by the code: a non-obvious invariant, a workaround for an
external bug (link it), a deliberate trade-off that looks wrong. Then it is one
line, in the surrounding style — not a paragraph.

Two consequences to hold to:

- **A fix gets zero comments by default.** If the code needs explaining, first
  try to make it explain itself — rename, extract, restructure. Reach for a
  comment only after that fails.
- **If the explanation is longer than a line, it is not a comment.** It is a
  design decision (→ ADR, phase 4), a commit message, or test coverage that
  demonstrates the behavior. Put it there and leave the code clean.

Apply the same restraint to docstrings and to comments already in the file:
match the file's existing comment density, and don't add commentary the
surrounding code would not have had.

Also:

- Match the surrounding code's style, naming, and idioms.
- Handle errors and edge cases deliberately, not as an afterthought.
- Keep changes focused on the task; don't bundle unrelated refactors.
- Follow the testing approach recorded in the ADRs: add or update tests and run
  them (plus lint/format) using the commands the specs document.

Note that DRY and KISS can pull in opposite directions — don't manufacture a
shared abstraction just to remove a little duplication if it makes the code
harder to follow. When they conflict, favor the simpler, clearer code.

### 4. Update the specs once done

After the task is complete and verified, bring `specs/` back in sync so the
next agent inherits an accurate picture:

1. **`content-map.md`** — update it if the change altered the repo's structure:
   new modules/directories/entry points, moved or removed components, new test
   locations or run commands. Keep it a concise index, not a changelog.
2. **ADRs** — if the work made or changed an architectural decision:
   - Add a new ADR (next `NNNN`) using `specs/adr/template.md` for a new
     decision.
   - Mark a superseded ADR as `Superseded by [ADR-XXXX]` and reference it from
     the new one.
   - Update the ADR index in `specs/adr/README.md`.
   Routine bug fixes and small changes usually need no ADR — only record
   genuine decisions.
3. Keep spec edits proportional to the change. A typo fix needs no spec update;
   a new subsystem does.

### 5. Report

Summarize: what changed in the code, which specs you read and relied on, any
spec conflicts you raised, and exactly what you updated in `specs/` (with file
paths). If you deliberately left specs untouched, say so and why.

## Guardrails

- Reading the specs is not optional — do it before planning, every time.
- Explain a change in your report, the commit message, or an ADR — never in code
  comments. Comments that justify a fix are a defect in the change, not a
  courtesy; if you catch yourself writing one, delete it and move the content to
  wherever it belongs.
- Never silently contradict an Accepted ADR; surface the conflict and let the
  decision be recorded.
- Don't let the spec-update phase invent decisions that weren't actually made —
  record what happened, grounded in the real change.
- Spec updates are part of "done"; a task that changed structure or decisions
  is not complete until `specs/` reflects it.
