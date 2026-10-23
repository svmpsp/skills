---
name: sdd-make
description: Spec-grounded coding skill for Spec-Driven Development (SDD). Before any planning or implementation, read the repository's specs/ directory (content map + ADRs) for orientation and rationale, treating the code as the source of truth; write DRY, KISS, self-documenting code with almost no comments; and once the task is done, keep specs/ in sync — rewriting or deleting ADRs the change outgrew, and proposing a new ADR only for a genuine design decision, with the user's confirmation. Use when the user runs /sdd-make or asks to implement, build, change, or fix code in a repo that uses an SDD specs/ directory.
---

# sdd-make

The coding skill of the SDD workflow. It makes the repository's `specs/`
directory (created by `sdd-init` — a content map plus ADRs) an input and output
of every change: you **read** the specs before you plan, write **DRY and KISS**
code that documents itself instead of being annotated, and **sync** the specs
once the work lands.

The **code is the first-class citizen.** It is the source of truth for what the
system does, and it should read clearly enough to need no other explanation.
The specs orient you and explain *why*; they are not law. Systems evolve, and an
ADR that no longer matches the code is a stale ADR to rewrite or delete — not a
reason to bend the code.

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
2. Read `specs/content-map.md` to locate the components the task touches, then
   explore inside them in the code itself — the map stops at component level.
3. Read the relevant ADRs under `specs/adr/` for the reasoning behind the
   structure you are about to change: framework choices, datastore,
   conventions. Check each one against the code — an ADR describes intent at
   the time it was written, and the code may have moved on.
4. **Always read the tooling and CI ADRs**, whatever the task touches: the
   dev-tools/testing ADR and the CI/release ADR (`sdd-init` seeds them as
   `0002-dev-tools-and-testing.md` and `0003-ci-and-release-workflow.md`). In a
   repo where components carry their own `specs/`, read the repo-root ones too.
   Read them on every invocation — having read them in an earlier phase (the
   `sdd-plan` that produced this task, or a previous session) does not count.
   They point to how a change is verified — the format/lint/type-check/test/
   build commands CI runs, the test conventions, and how dependencies and
   lockfiles are managed. Confirm the commands in the config they point at (the
   Makefile, the manifest, the CI workflow); where the two differ, the config
   is what CI runs.
5. Read `AGENTS.md`/`CLAUDE.md` for project conventions.

Never start planning from a blank slate when a content map exists — use it to
ground yourself in how *this* repo is actually organized.

### 2. Plan from the code, informed by the specs

1. Form a plan that fits how the code is actually built. Use the ADRs to
   understand why it is built that way, and keep to those reasons unless the
   task gives you a better one.
2. If the right solution changes a recorded design decision, tell the user in
   one or two lines what changes and why, and agree on it before building. The
   affected ADR is then rewritten or deleted in phase 4.
3. If an ADR already disagrees with the code before you change anything, the
   ADR is most likely stale. Note it for phase 4; do not reshape the code to
   match a stale document.
4. If the specs are silent on a choice the task forces, make a sensible
   decision in keeping with the existing code and conventions.

When you explain your plan or your work, point at the code and config — the
function, the Makefile target, the pinned version in its manifest — not at
"what the ADR says".

### 3. Implement — DRY and KISS

Write code that fits the existing codebase and holds these three directives:

- **DRY (Don't Repeat Yourself).** Before adding code, look for existing
  helpers, utilities, and patterns in the components the content map points
  you to.
  Reuse and extend rather than copy-paste. Factor genuine duplication into a
  single well-named place — but don't over-abstract a coincidence.
- **KISS (Keep It Simple).** Prefer the simplest solution that fully solves the
  task. Avoid speculative generality, premature abstraction, and clever
  indirection. Small, single-purpose functions with clear, intention-revealing
  names; readability over cleverness; no dead code.
- **Self-documenting code.** Names and structure carry the meaning: a reader
  should understand the code from the code. Comments are not where
  documentation lives: the *what changed* and *why it was fixed* belong in the
  commit message and your report; only a genuine design decision earns an ADR.

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
  commit message, test coverage that demonstrates the behavior, or — only if
  it is a genuine design decision — an ADR (phase 4). Put it there and leave
  the code clean.

Apply the same restraint to docstrings and to comments already in the file:
match the file's existing comment density, and don't add commentary the
surrounding code would not have had.

Also:

- Match the surrounding code's style, naming, and idioms.
- Handle errors and edge cases deliberately, not as an afterthought.
- Keep changes focused on the task; don't bundle unrelated refactors.
- Follow the repo's testing approach (the tooling ADR points to it): add or
  update tests in the existing conventions, then verify every touched
  component with the same commands CI runs — not a bare test run. If a build
  step rewrites a generated file such as a lockfile, keep the change and
  regenerate it the documented way; never revert it or wave it off as
  pre-existing.

Note that DRY and KISS can pull in opposite directions — don't manufacture a
shared abstraction just to remove a little duplication if it makes the code
harder to follow. When they conflict, favor the simpler, clearer code.

### 4. Update the specs once done

After the task is complete and verified, bring `specs/` back in sync so the
next agent inherits an accurate picture:

1. **`content-map.md`** — it is a table of contents of the repo's
   **components**, not of their contents. Edit it **only** if the change added
   or removed a component, or changed a component's goal or high-level
   description. New modules, files, helpers, or tests inside an existing
   component, refactors, and bug fixes leave it untouched. Never add
   submodules, subpackages, file lists, `path:line` references, or
   implementation details to it; if you find any there, remove them rather
   than extend them.
2. **ADRs** — record design decisions only, and keep them current:
   - **Bug fixes, refactors, and routine changes never touch an ADR.** A fix
     restores intended behavior; it decides nothing. Its story is the commit
     message.
   - **An ADR the change outgrew is rewritten or deleted**, in the same change.
     Rewrite it to describe the decision as it now stands; delete it if the
     decision no longer applies. `specs/adr/` always matches the code; git is
     the history.
   - **A new ADR needs the user's confirmation.** If the work made a genuine
     design decision (a new component, framework, datastore, or cross-cutting
     convention), propose it in one or two lines and ask whether to record it.
     Write it from `specs/adr/template.md` with the next `NNNN` only on a yes.
   - **An ADR never pins a version.** Name the config file where the version is
     pinned (`.tool-versions`, `pyproject.toml`, the CI workflow); the pin
     lives there. If you find a pinned version in an ADR, replace it with that
     pointer.
   - Keep the index in `specs/adr/README.md` in sync with every add, rewrite,
     or delete.
3. Keep spec edits proportional to the change. Most changes need none.

### 5. Report

Summarize: what changed in the code and how it was verified, any stale spec
you found, and exactly what you changed in `specs/` (with file paths) —
including ADRs rewritten or deleted and any new ADR the user approved. If you
left specs untouched, say so in a line.

## Guardrails

- Reading the specs is not optional — do it before planning, every time.
- Always read the tooling and CI ADRs, every invocation, and verify with the
  commands CI runs before calling the work done.
- The code is the source of truth. Specs explain it; they do not overrule it.
  Cite code and config, not ADRs, as evidence.
- Explain a change in your report, the commit message, or an ADR — never in code
  comments. Comments that justify a fix are a defect in the change, not a
  courtesy; if you catch yourself writing one, delete it and move the content to
  wherever it belongs.
- Never write a new ADR without the user's confirmation, never record a bug fix
  in one, and never pin a version in one.
- ADRs stay in sync with the code: when a change outgrows one, rewrite or
  delete it in the same change.
- The content map is a component-level index: touch it only when a component
  is added or removed or its purpose changes, and never put internals in it.
- Don't let the spec-update phase invent decisions that weren't actually made —
  record what happened, grounded in the real change.
- Spec sync is part of "done": a task that changed a component or a design
  decision is not complete until `specs/` matches the code.
