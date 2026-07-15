---
name: sdd-fix
description: Spec-grounded debugging skill for Spec-Driven Development (SDD). Diagnose a bug by grounding yourself in the repository's specs/ (content map + ADRs) and its git history, then reproduce the problem and pin down its root cause with material evidence (a reproduction script, failing output) — never guessing, never testing an assumption you have not run. Make no code changes and commit nothing without explicit authorization; keep every artifact in a scratchpad outside the repo. Once the root cause is proven, explain it to the user in plain terms and propose handing off to sdd-plan to design a mitigation. Use when the user runs /sdd-fix or asks to debug, diagnose, reproduce, or find the root cause of a bug in an SDD repo.
---

# sdd-fix

The debugging skill of the SDD workflow. Its job is **diagnosis, not repair**:
given a problem the user describes, it grounds itself in the repository's
`specs/` (the content map and ADRs created by `sdd-init`) and its **git
history**, then produces a **reproducible example** and pins down the **root
cause with material evidence**. It ends by handing off to `sdd-plan` to design
the fix — it does not write the fix itself.

Two rules define this skill:

- **Never assume without testing.** Every hypothesis is confirmed or killed by
  running something — a reproduction script, a probe, a log. A claim you have
  not executed is a guess, and guesses do not go in the report.
- **Never change or commit code without authorization.** This skill reads,
  reproduces, and diagnoses. It does not edit repo files or commit. Any code it
  writes to reproduce or probe lives in a scratchpad **outside the codebase**.

## The loop

### 1. Read the specs first (always)

Before investigating anything:

1. Confirm `specs/` exists. If it does not, the repo is not SDD-bootstrapped —
   tell the user and offer to run `sdd-init` first, or proceed as a plain
   debugging task with their go-ahead.
2. Read `specs/content-map.md` to locate the parts of the repo the bug touches —
   entry points, the modules involved, where tests and config live, how the
   project is built and run.
3. Read the relevant ADRs under `specs/adr/`. The *intended* design is your
   baseline for "correct": a bug is a divergence from what the specs say should
   happen. Note each ADR's status (Proposed vs Accepted).
4. Read `AGENTS.md`/`CLAUDE.md` for project conventions.

The specs tell you how the system is *supposed* to behave. You cannot recognize
a root cause without that baseline.

### 2. Understand the report and set up a workspace

1. Restate the problem in your own words and confirm it with the user if the
   description is ambiguous: what is observed, what was expected, and the exact
   steps or inputs that trigger it. Get the concrete failing case, not a
   paraphrase.
2. Create a scratchpad directory **outside the repository** for every artifact
   this skill produces — reproduction scripts, captured logs, probe programs,
   notes. Use the session scratchpad or a `tmp` location; never write these into
   the repo's tree. State the path so the user knows where the artifacts are.

### 3. Mine the git history

The bug entered the codebase at some point; the history often points straight at
it. Ground your investigation in it before theorizing:

- Locate the code paths the content map pointed you to, and read their recent
  history (`git log`, `git log -p`, `git blame` on the suspect lines).
- If the behavior used to work, find **when it changed** — `git bisect` against
  a reliable reproduction is the sharpest tool; a narrowed `git log` over the
  relevant paths is the lighter version.
- Read the commits that touched the suspect code: their messages and diffs often
  reveal the intent (and the mistaken assumption) behind the change.

Cite specific commits (short SHA + subject) when they inform your diagnosis.

### 4. Reproduce it — deterministically

You cannot fix what you cannot reproduce. Produce a **minimal, reproducible
example** before proposing any root cause:

1. Write a reproduction that fails reliably — a script, a failing test, a
   sequence of commands — and keep it in the scratchpad. Prefer the smallest
   input that still triggers the failure.
2. Run it and **capture the actual output** (error, stack trace, wrong result).
   Save that output as evidence alongside the script.
3. Confirm it is deterministic: it should fail every run, and pass in the
   conditions where the software is expected to work, so it can later prove the
   fix. If it is flaky, narrow it until it is reliable, and say so.

If you genuinely cannot reproduce it, stop and report that honestly with what
you tried — do not paper over it with a guessed cause.

### 5. Find the root cause — hypothesize, then test

Work from the reproduction to the underlying cause. Do not stop at the symptom.

1. Form a hypothesis about the cause, grounded in the specs, the history, and
   the reproduction.
2. **Test it.** Add logging or a probe, set a breakpoint, tweak an input, or
   write a smaller experiment in the scratchpad — then run it. Let the result
   confirm or kill the hypothesis. Never advance a cause you have not exercised.
3. Iterate until you reach the **root cause** — the actual defect, not a
   downstream effect — and can point to it at `path:line`. Distinguish the root
   cause from contributing factors and from the symptom.
4. Where it helps, note whether the bug contradicts an Accepted ADR or the
   content map (the code strayed from the design) or whether the spec itself is
   wrong/outdated (the design was flawed) — that distinction shapes the fix.

Every step here is backed by something you ran. Material evidence — a failing
reproduction, captured output, a probe result — is the standard; reasoning
alone is not.

### 6. Report the diagnosis

Produce a single Markdown report. Keep the artifacts in the scratchpad and
reference them by path.

```markdown
# sdd-fix diagnosis: <short title>

**Summary:** <one line — the root cause and its effect>

## Problem
<observed vs expected, and the trigger>

## Reproduction
- Artifact: `<scratchpad path to script/test>`
- How to run: `<command>`
- Observed output: `<captured failure>` (`<scratchpad path to log>`)

## Root cause
<the actual defect> at `path:line`, introduced/affected by `<short SHA> <subject>`.
<evidence that proves it — what you ran and what it showed>

## Grounding
- Specs relied on: <content-map §… / ADR-NNNN>
- Design divergence: <code strayed from spec | spec is outdated | neither>

## Contributing factors / ruled out
<hypotheses tested and killed, so the next agent doesn't re-tread them>
```

Report only what you proved. If a link in the chain is still a hypothesis, label
it as such rather than presenting it as fact.

### 7. Explain to the user, then propose the hand-off

Once the root cause is **proven**, first describe it to the user in **plain,
simple terms** — what is actually going wrong and why the reproduction fails, in
a sentence or two a non-expert can follow, without the diagnostic jargon. The
full evidence lives in the report; this is the human-readable takeaway.

Then **propose** — do not silently start — handing the proven diagnosis to
`sdd-plan` to design a mitigation/fix, grounded in the same specs and a user
interview. Ask the user whether to proceed; only invoke `sdd-plan` once they
agree.

Do not implement, edit, or commit a fix in this skill — not even an "obvious
one-liner" — without explicit user authorization to leave the diagnosis phase.

## Guardrails

- Read the specs first; they are your baseline for correct behavior.
- Never advance a cause you have not tested — material evidence over reasoning,
  every time. A reproduction is required before a root-cause claim.
- Never edit repo files or commit without explicit authorization. This skill
  diagnoses; `sdd-plan` designs the fix and `sdd-make` implements it.
- Every artifact (repro scripts, logs, probes) lives in a scratchpad **outside
  the repo** — leave the working tree untouched.
- Ground the diagnosis in git history: cite the commits that inform it.
- If you cannot reproduce or cannot prove the root cause, say so plainly; do not
  substitute a guess.
