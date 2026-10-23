---
name: sdd-plan
description: Spec-grounded feature planning skill for Spec-Driven Development (SDD). Plan a feature by grounding it in BOTH the repository's specs/ (content map + ADRs) and a structured interview with the user. Never plan on undocumented assumptions — surface each one, give context, and ask the user one question at a time; push back when an answer contradicts the existing specs. Use when the user runs /sdd-plan or asks to plan, scope, or design a feature before implementation in an SDD repo.
---

# sdd-plan

The planning skill of the SDD workflow. Before any code is written, it produces
a feature plan that is grounded in **two** sources of truth: the repository's
`specs/` (the content map and ADRs created by `sdd-init`) and a structured
**interview** with the user. Its core rule: **do not plan on undocumented
assumptions.** Every gap is either answered by the specs or asked of the user.

Use this skill for any feature large enough to warrant a plan. It precedes
`sdd-make` (the coding skill) — its output is the grounded plan that `sdd-make`
implements.

## The loop

### 1. Read the specs first (always)

Before forming any plan or asking anything:

1. Confirm `specs/` exists. If it does not, the repo is not SDD-bootstrapped —
   tell the user and offer to run `sdd-init` first, or proceed without spec
   grounding only with their go-ahead.
2. Read `specs/content-map.md` to understand how the repo is organized and
   which parts the feature would touch.
3. Read the relevant ADRs under `specs/adr/` to learn the reasoning behind the
   structure the feature touches (framework, datastore, conventions). Then read
   the code those components contain — the code is the source of truth, and an
   ADR that disagrees with it is most likely stale.
4. **Always read the tooling and CI ADRs**, whatever the task touches: the
   dev-tools/testing ADR and the CI/release ADR (`sdd-init` seeds them as
   `0002-dev-tools-and-testing.md` and `0003-ci-and-release-workflow.md`). In a
   repo where components carry their own `specs/`, read the repo-root ones too.
   Read them on every invocation — having read them in an earlier phase (a
   `sdd-fix` that led here, or a previous session) does not count. They point
   to how the work will be verified — the format/lint/type-check/test/build
   commands CI runs, the test conventions, and how dependencies and lockfiles
   are managed. Confirm the commands in the config they point at, so the plan
   names what CI actually runs.
5. Read `AGENTS.md`/`CLAUDE.md` for project conventions.

The code and the specs answer questions you would otherwise have to ask. Mine
them first so the interview covers only what is genuinely undecided.

### 2. Identify the gaps — what is undocumented

Write down what you would need to know to plan the feature confidently, then
sort each item:

- **Answered by the repo** — cite where: the code or config first
  (`path`, a Makefile target, a manifest entry), an ADR only for the *why*.
- **Undocumented assumption** — anything you'd otherwise have to guess: scope
  boundaries, intended behavior, data shape, UX, edge cases, non-goals,
  acceptance criteria, performance/security expectations.

Every undocumented assumption is a question for the user. **Do not bake a guess
into the plan.** If you catch yourself writing "I'll assume…", that is a
question, not a decision.

### 3. Interview the user — one question at a time

Resolve the undocumented assumptions through a structured interview:

1. **Ask exactly one question per turn.** Never batch multiple questions into a
   single message. Wait for the answer before asking the next.
2. **Give context with each question.** State what you already know (from specs
   or prior answers), why the question matters to the plan, and — where useful —
   the options you see and a recommended default. A question should be easy to
   answer because you framed it well, not a blank prompt.
3. Order questions by leverage: resolve the decisions that most shape the plan
   (scope, approach) before details (copy, edge cases).
4. Stop interviewing when the remaining unknowns are small enough to be safe
   defaults — then state those defaults explicitly rather than hiding them.

### 4. Push back when answers clash with the design

The user's answers are grounding input, but a change to a design decision
should be deliberate, not accidental.

- If an answer would change how the system is built — against the existing
  code or a design decision an ADR explains — do not just absorb it. Say in a
  line or two what it changes and what the current design was for, and ask
  whether to adjust the feature or change the decision. If the decision
  changes, the plan includes rewriting or deleting the affected ADR so it
  matches the code.
- Do not defend an ADR the code has already outgrown. If the code and an ADR
  disagree, say so and plan the ADR's rewrite or deletion.
- Push back the same way on answers that are internally inconsistent with
  earlier answers, or that would violate stated non-goals.

### 5. Produce the grounded plan

Once the assumptions are resolved, write the plan. It should include:

- **Goal / user story** — what the feature does and for whom.
- **Grounding** — the code and config it builds on, the ADRs that explain the
  relevant design (if any), and the key answers from the interview that shaped
  it.
- **Scope and non-goals** — explicitly in and out.
- **Approach** — the implementation strategy, in keeping with the existing
  code. List the spec sync it needs: ADRs to rewrite or delete, and any new ADR
  for a genuine design decision — marked as needing the user's confirmation.
  Bug fixes and version bumps never get an ADR; versions are pinned in config,
  not in ADRs.
  Plan a `content-map.md` edit only if the feature adds or removes a component
  or changes a component's goal — never to record its internals.
- **Steps** — an ordered, concrete plan a coder (or `sdd-make`) can execute.
- **Open questions / assumed defaults** — anything still unresolved, stated
  plainly rather than buried.
- **Acceptance criteria** — how "done" is judged, including the verification
  commands CI runs for every touched component.

Do not begin implementation here — this skill plans; `sdd-make` builds. Hand the
plan off and let the user confirm it.

## Guardrails

- Read the specs before interviewing; never ask what the specs already answer.
- Always read the tooling and CI ADRs, every invocation.
- No undocumented assumptions in the plan — resolve each by spec citation or by
  asking the user.
- Exactly one question per turn, always with context. Never a wall of questions.
- Code is the source of truth; ADRs explain it. Cite the code, not "the ADR
  says".
- Push back on an answer that changes a design decision; make the change
  deliberate, and plan to rewrite or delete the ADR it outgrows. A new ADR is
  only ever proposed, never assumed.
- Stay in planning — do not write or modify feature code in this skill.
