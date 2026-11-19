---
name: sdd-query
description: Spec-grounded research skill for Spec-Driven Development (SDD). Answers a user's question about the repository — or about something external, as it applies to the repository — by grounding the answer in the actual code and the specs/ (content map + ADRs), with git history and web sources as supporting evidence. May delegate the search to subagents when the question is broad. Read-only: answers in chat with cited sources, and keeps a research report (sources + approach) in a scratchpad outside the repo. Use when the user runs /sdd-query or asks a question that should be answered from the repo's code and specs in an SDD repo.
---

# sdd-query

The research skill of the SDD workflow. It answers one question, and the answer
is only as good as its grounding: every claim traces back to the **code** (the
source of truth), the **specs/** (the content map and ADRs, for the *why*), git
history, or — when the repo cannot answer — a cited web source, applied to this
repo's context.

This skill is **read-only**. It answers; it does not change code, specs, or
commit anything.

## The loop

### 1. Read the specs first (always)

1. Confirm `specs/` exists. If it does not, the repo is not SDD-bootstrapped —
   tell the user and offer to run `sdd-init` first, or answer without spec
   grounding only with their go-ahead.
2. Read `specs/content-map.md` to locate the components the question touches.
3. Read the ADRs relevant to the question, then the code of those components.
   The code is the source of truth; an ADR that disagrees with it is most
   likely stale.
4. Read `AGENTS.md`/`CLAUDE.md` for project conventions.

### 2. Research

Pin down what the question actually asks, then gather evidence in this order:

1. **Code and config** — what the system does.
2. **ADRs** — why it is shaped that way.
3. **Git history** (`git log`, `git blame`) — when and why it changed.
4. **Web** — only for what the repo cannot answer (external tools, libraries,
   practices). Apply what you find to this repo's constraints, as the code and
   ADRs state them, and say which constraints shaped the answer.

For a broad question, you may split the search across subagents (e.g. one per
component, or one for web sources). Brief each with the relevant specs and
paths, and verify what they report against the code before using it.

Never answer from memory or assumption when the repo can be checked. If the
evidence is missing or conflicting, say so rather than filling the gap.

### 3. Write the research report

Write a report to a scratchpad **outside the repo** (never in the working tree):

```markdown
# Query: <the question>

## Answer
<the answer, as given in chat>

## Sources
- `path:line` — <what it shows>
- ADR-NNNN — <the rationale it gives>
- `<short SHA> <subject>` — <what it shows>
- <URL> — <what it shows>

## Approach
<what was searched, in what order, which subagents ran and on what, dead
ends ruled out>

## Gaps and drift
<unanswered parts, conflicting evidence, code/spec drift noticed — or "none">
```

### 4. Answer in chat

Give the user a concise answer, citing the sources behind each claim, and the
path to the report. If you noticed code/spec drift or a likely bug, say so and
suggest the right skill (`sdd-scan`, `sdd-fix`, or `sdd-plan`) — do not run it.

## Guardrails

- Read the specs before researching; ground every claim in code, ADRs, git
  history, or a cited web source.
- Code is the source of truth; ADRs explain it. Cite the code, not "the ADR
  says".
- Web findings are applied to this repo's context, never answered generically.
- Never edit repo files or commit. The report lives outside the repo.
- State gaps and conflicts plainly; never substitute a guess.
