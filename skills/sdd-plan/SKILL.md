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
3. Read the relevant ADRs under `specs/adr/` to learn the decisions that
   constrain the feature (framework, datastore, conventions, testing/CI). Note
   each ADR's status (Proposed vs Accepted).
4. Read `AGENTS.md`/`CLAUDE.md` for project conventions.

The specs answer questions you would otherwise have to ask. Mine them first so
the interview covers only what is genuinely undecided.

### 2. Identify the gaps — what is undocumented

Write down what you would need to know to plan the feature confidently, then
sort each item:

- **Answered by the specs** — cite where (content map section or ADR number).
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

### 4. Push back when answers contradict the specs

The user's answers are grounding input, but they are not automatically allowed
to silently break recorded decisions.

- If an answer contradicts an **Accepted ADR** or the content map's stated
  structure, do not just absorb it. Surface the conflict: name the specific ADR
  / spec section, explain the contradiction, and ask the user how to reconcile
  it — either adjust the feature to fit the spec, or consciously change the
  decision (which means a new or superseding ADR, recorded when the work is
  done).
- Push back the same way on answers that are internally inconsistent with
  earlier answers, or that would violate stated non-goals.
- The goal is not to win the argument — it's to make sure any deviation from
  the specs is a deliberate, recorded decision rather than an accident.

### 5. Produce the grounded plan

Once the assumptions are resolved, write the plan. It should include:

- **Goal / user story** — what the feature does and for whom.
- **Grounding** — the specs it relies on (cited ADRs / content-map sections)
  and the key answers from the interview that shaped it.
- **Scope and non-goals** — explicitly in and out.
- **Approach** — the implementation strategy, consistent with the ADRs; note
  any spec deviation agreed during the interview and that it needs a new ADR.
- **Steps** — an ordered, concrete plan a coder (or `sdd-make`) can execute.
- **Open questions / assumed defaults** — anything still unresolved, stated
  plainly rather than buried.
- **Acceptance criteria** — how "done" is judged.

Do not begin implementation here — this skill plans; `sdd-make` builds. Hand the
plan off and let the user confirm it.

## Guardrails

- Read the specs before interviewing; never ask what the specs already answer.
- No undocumented assumptions in the plan — resolve each by spec citation or by
  asking the user.
- Exactly one question per turn, always with context. Never a wall of questions.
- Push back on any answer that contradicts an Accepted ADR or the content map;
  make deviations deliberate and destined for an ADR, not silent.
- Stay in planning — do not write or modify feature code in this skill.
