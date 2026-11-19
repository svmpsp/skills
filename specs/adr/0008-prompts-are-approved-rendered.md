# 0008. Prompts are approved rendered before they are written

- **Status:** Accepted
- **Date:** 2026-11-19
- **Deciders:** Sivam Pasupathipillai

## Context

Coding agents write poor LLM prompts, and a prompt read only as a template in
source — placeholders unfilled, serialization unseen — hides most of what the
model will actually receive. The SDD skills that put text into a project are
`sdd-plan` (which designs it) and `sdd-make` (which writes it, sometimes with
no plan first). Neither had any rule about prompts.

## Decision

We will require the user's approval of every prompt an SDD skill writes into a
project — system prompts, prompt templates, LLM-call messages, agent or skill
instruction files — before it is written.

- **Where:** `sdd-plan` drafts each prompt and gets it approved; the plan
  carries it verbatim. `sdd-make` writes an approved prompt as-is, and stops for
  approval when there is none or implementation forces a change.
- **What is shown:** every message the model receives, in order and labelled by
  role, with placeholders filled by one realistic example; rendered exactly as
  the model sees it (real JSON formatting, whitespace, escaping); plus the call
  settings that shape the output, where they apply.
- **The loop:** the user approves or edits; edits are applied verbatim, the
  prompt is re-rendered, and nothing is written until approval.
- **Placement:** the rule is written into each of the two `SKILL.md` files.

## Consequences

- The user sees and owns the exact model input before it ships.
- Plans and implementation gain an approval stop whenever a prompt is involved.
- The rule text exists twice and must be kept in sync by review.
- Prompts the agent writes for itself — subagent briefs, scratchpad probes in
  `sdd-fix` — and SDD's own `AGENTS.md`/`HANDOUT.md` are out of scope.

## Alternatives considered

- **Gate only in `sdd-make`.** Simpler, but the prompt is seen only after the
  design is fixed. Rejected.
- **Gate only in `sdd-plan`.** Misses `sdd-make` runs without a plan. Rejected.
- **A shared `references/` file** ([ADR-0005](0005-skill-support-files-layout.md)).
  Skills install as independent directories and `${CLAUDE_SKILL_DIR}` reaches
  only a skill's own files, so one copy cannot be shared reliably; per-skill
  copies still duplicate and add a read the model may skip. Rejected.
- **A placeholder legend or long, messy example inputs.** Rejected as noise; one
  realistic example rendered exactly is what reveals prompt quality.
