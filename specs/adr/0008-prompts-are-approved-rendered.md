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

- **Who writes:** the `sdd-prompt-editor` agent writes and edits every prompt;
  the skills never do, and stop if it is not installed. It works from a brief
  (what the prompt must achieve, the code around it) and returns the prompt
  plus its rendering. Its own instructions hold the writing principles: plain
  instructions, only the context the model needs, a precise output format, and
  positive few-shot examples or step-by-step reasoning where the task calls for
  them.
- **Where:** `sdd-plan` delegates each prompt and gets it approved; the plan
  carries it verbatim. `sdd-make` writes an approved prompt as-is, and
  delegates and gets approval when there is none or implementation forces a
  change.
- **What is shown:** every message the model receives, in order and labelled by
  role, with placeholders filled by one realistic example; rendered exactly as
  the model sees it (real JSON formatting, whitespace, escaping); plus the call
  settings that shape the output, where they apply.
- **The loop:** the user approves or edits; exact-text edits are applied
  verbatim and re-rendered, feedback in the user's own words goes back to
  `sdd-prompt-editor`, and nothing is written until approval. A subagent
  cannot talk to the user, so the skill — not the agent — runs this loop.
- **Placement:** the approval rule is written into each of the two `SKILL.md`
  files; the writing principles live once, in `agents/sdd-prompt-editor.md`.

## Consequences

- The user sees and owns the exact model input before it ships.
- Plans and implementation gain an approval stop whenever a prompt is involved.
- The approval rule text exists twice and must be kept in sync by review; the
  writing principles have a single home in the agent.
- Prompts are written in a fresh context that sees only the brief, so they
  carry no incidental detail from the session that asked for them.
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
- **Skills write prompts themselves, with the writing principles inlined.**
  Rejected: the principles would live twice, and the prompt would be drafted
  in a context full of detail the model it addresses does not need.
- **A placeholder legend or long, messy example inputs.** Rejected as noise; one
  realistic example rendered exactly is what reveals prompt quality.
