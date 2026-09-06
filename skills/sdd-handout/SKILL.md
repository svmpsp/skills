---
name: sdd-handout
description: Session hand-off skill for Spec-Driven Development (SDD). Carries work across a context boundary by writing HANDOUT.md at the repo root — a short document stating the session's goal, the key findings so far, and the concrete next steps. Twofold on invocation: if HANDOUT.md exists, resume the spec-grounded work it describes; if it does not, write one from the current session. Use when the user runs /sdd-handout, when a session has grown too long/bloated to continue, or when asked to hand off, save, resume, or continue context between sessions in an SDD repo.
---

# sdd-handout

The hand-off skill of the SDD workflow. A long session accumulates context that
does not survive it: what we were actually trying to do, what we learned the
hard way, and what was about to happen next. This skill writes that — and only
that — into `HANDOUT.md` at the repository root, so a fresh session can pick the
work up without re-deriving it.

The handout is a **bridge, not a source of truth**. `specs/` (the content map
and ADRs) remains binding; the handout records the *in-flight* state of one task
against those specs.

`HANDOUT.md` is transient and should not be committed. Delete it once its work is done.

## On invocation: check for the file first

The first action, always, is to look for `HANDOUT.md` at the repository root.
Its presence selects the mode:

- **Present → resume.** Continue the spec-grounded work it describes (§ Resume).
- **Absent → create.** Write one from the current session (§ Create).

If it exists but the user clearly asked to write a fresh hand-off, ask them directly what to do — never
silently discard an unfinished handout.

## Resume (HANDOUT.md exists)

1. Read `HANDOUT.md` in full.
2. Read the specs it is grounded in: `specs/content-map.md` and the ADRs the
   handout cites, plus `AGENTS.md`/`CLAUDE.md`. Do this even though the handout
   summarizes them — the handout is a bridge, and the specs are the authority.
3. Verify the handout against reality before acting on it. It was written by an
   earlier session and the tree may have moved: confirm the files it names still
   exist, check `git log`/`git status` for changes since it was written, and
   re-run any check it recorded as failing. Report anything that no longer
   holds instead of building on it.
4. Restate to the user, in two or three lines, what you understand the goal and
   the next step to be, then ASK CONFIRMATION to proceed with that next step under the skill the
   work calls for — `sdd-make` to implement, `sdd-plan` to design, `sdd-fix` to
   diagnose, `sdd-scan` to audit.
5. Once the work it describes is finished, delete
   `HANDOUT.md` and say so.

## Create (HANDOUT.md is absent)

Write the handout from what the current session actually established. Copy the template
at `${CLAUDE_SKILL_DIR}/assets/template.md` to `HANDOUT.md` in the repository
root and fill it in — do not retype it from memory.

Fill each section with what a fresh session needs and nothing else:

- **Goal** — what this session is trying to achieve, in one or two sentences,
  plus the definition of done. Not a transcript of what was discussed.
- **Grounding** — the specs this work is bound by: the content-map sections and
  the ADRs (by number and title) that constrain it, and any conflict already
  surfaced with the user.
- **Key findings** — what was learned that a new session cannot cheaply
  rediscover: the root cause found, the approach chosen and the ones rejected
  (with why), decisions the user made, constraints hit. Anchor each to
  `path:line`, a short SHA, or a command with its output. A finding that is
  still a hypothesis is labeled as one.
- **State** — what has already changed in the tree (files touched, whether
  committed), what is verified, and what is not. This must be grounded in reality, not memory.
- **Next steps** — ordered, concrete, and actionable, starting with the single
  immediate next action and the command or file it starts from.
- **Open questions** — anything awaiting a user decision, phrased as a question.

Then tell the user the handout is written and that a new session can be started
with `/sdd-handout` to resume from it.

### Keep it short

The handout exists because context ran out; it must not recreate the problem.
Aim for one screen — a page at most. Rules of thumb:

- Write only what does not survive elsewhere. Anything already in `specs/`, the
  code, or the git history gets a **pointer**, not a copy.
- Prefer file paths, line anchors, commit SHAs and commands over prose.
- No narrative of the session, no restated user messages, no code dumps — a
  handful of lines of code at most, and only when the anchor is not enough.

## Guardrails

- Check for `HANDOUT.md` before anything else; its presence, not the phrasing of
  the request, selects the mode.
- The handout never replaces the specs. Resume mode reads `specs/` too, and a
  handout that contradicts an Accepted ADR is wrong — surface it.
- Record only what the session actually established. Do not invent next steps,
  and label unproven claims as hypotheses.
- Never write the handout into `specs/` or commit it; it is a transient root
  file.
- Delete `HANDOUT.md` once its work is done.
