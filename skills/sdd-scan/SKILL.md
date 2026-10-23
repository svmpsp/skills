---
name: sdd-scan
description: Spec-conformance audit skill for Spec-Driven Development (SDD). Reads the repository's specs/ (content map + ADRs), then scans the actual repo — the source of truth — for drift, contradictions, and gaps between the code and that recorded knowledge, including stale or misused ADRs. Produces a read-only report of findings ordered by criticality — it diagnoses, it does not fix. Use when the user runs /sdd-scan or asks to audit, scan, or check a repo against its specs, find spec drift, or flag mismatches between the code and its guiding principles.
---

# sdd-scan

The audit skill of the SDD workflow. It compares `specs/` (the content map and
ADRs created by `sdd-init`) with the **actual repository**, surfacing where the
two have drifted apart and where the code violates the principles the specs
record.

The **code is the source of truth.** The specs are only useful while they
describe it, so most drift is resolved by rewriting or deleting the spec — not
by bending the code. Code that genuinely strayed from a still-valid design is
the exception, and the user decides it.

This skill is **read-only**: it diagnoses and reports, it does not edit code or
specs. Its output is a prioritized report. When the user wants the findings
fixed, hand off to `sdd-make` (which reads the same specs and updates them as it
changes code).

Use it for periodic health checks, before a release, after a burst of changes,
or whenever you suspect the specs no longer describe reality.

## The loop

### 1. Read the specs first (always)

Before inspecting any code:

1. Confirm `specs/` exists. If it does not, there is nothing to scan against —
   tell the user and offer to run `sdd-init` first.
2. Read `specs/content-map.md` — the claimed components and their purposes,
   and the top-level build/install/test commands.
3. Read every ADR under `specs/adr/`, noting each one's **status**. Accepted
   ADRs claim "the system works this way, for this reason"; Proposed ones
   describe intent not yet in place.
4. Read `AGENTS.md`/`CLAUDE.md` for the conventions the repo claims to hold.

These documents are claims about the repo. The rest of the scan checks each
claim against the code and config.

### 2. Scan the repo against the specs

Inspect the real contents (file tree, manifests, configs, CI, source) and look
for divergence from what you read in phase 1. Check at least these axes:

- **Structural drift** — does the content map still match the tree at
  **component level**? Components it names that are **missing, moved, or
  renamed**; components that **exist but are not indexed**; component purposes
  that no longer match what the component does. A submodule, file, or helper
  absent from the map is **not** drift — the map is a table of contents and
  must not list a component's internals.
- **Over-detailed content map** — the map lists submodules, subpackages, files
  inside a component, `path:line` references, or implementation details. Flag
  it; the fix is always to remove that detail, never to keep it current.
- **Command drift** — do the documented build/install/test/run commands still
  exist and work as described (targets in the Makefile, scripts in the
  manifest, CI invocations)?
- **Stale ADRs** — an **Accepted** ADR the code contradicts (a different
  framework/datastore/tool, a convention it no longer follows, a structure it
  has moved past); a **Proposed** ADR the repo has since implemented; an ADR
  for a decision that no longer applies. The fix is to rewrite or delete the
  ADR so it matches the code.
- **Misused ADRs** — an ADR that records a bug fix, refactor, or routine
  change instead of a design decision (delete it; its story belongs in git),
  or that pins a software version instead of naming the config file that pins
  it (replace the version with that pointer).
- **Principle mismatches** — violations of the guiding principles the specs
  state: DRY (genuine duplication that a documented helper/pattern should
  cover), KISS (needless complexity), and any repo-specific rules (e.g.
  "`AGENTS.md` is a thin pointer" — flag it if it has grown into a second copy
  of the overview).
- **Coverage gaps** — architecturally significant decisions or subsystems with
  **no spec coverage** at all (a whole service, datastore, or auth scheme the
  ADRs never mention).

Ground every finding in evidence: cite the concrete repo location
(`path:line`) and the spec location (content-map section or ADR number) that
disagree with it. Lead with the code; the spec is the claim being tested. Do not report a "finding" you cannot point at in both places — and do not
invent problems to pad the report.

### 3. Prioritize by criticality

Assign each finding a severity, judged by how badly it misleads someone reading
the specs:

- **Critical** — acting on the specs produces wrong results: a documented
  command that fails, content-map pointers to things that no longer exist, an
  Accepted ADR describing a design the code has abandoned.
- **High** — a significant component or design decision is undocumented, or a
  Proposed ADR is in fact already in place. The picture is incomplete in a way
  that will bite.
- **Medium** — real but contained drift or a principle smell: minor structural
  mismatch, localized duplication, an `AGENTS.md` drifting past "thin," a
  content map carrying component internals, an ADR that records a bug fix or
  pins a version.
- **Low** — nits and polish: stale wording, a slightly outdated reference, small
  inconsistencies.

When unsure between two levels, state the uncertainty rather than inflating it.

### 4. Produce the report

Output a single Markdown report, **ordered by severity (Critical first)**. Lead
with a one-line summary and a count per severity, then a table for scanning,
then the details.

```markdown
# SDD scan report

<one-line health summary>. Findings: N critical, N high, N medium, N low.

| # | Severity | Area | Finding |
|---|----------|------|---------|
| 1 | Critical | content-map | `make test` documented but no such target |
| 2 | High     | ADR-0003    | CI workflow exists; ADR still marked Proposed |
| 3 | Medium   | ADR-0002    | Pins Python 3.11; `.tool-versions` pins 3.12  |
| … |          |             |                                               |

## Findings

### 1. [Critical] <short title>
- **Repo shows:** <reality> (`path:line`)
- **Spec says:** <claim> (`specs/content-map.md` §… / ADR-NNNN)
- **Why it matters:** <impact on someone trusting the specs>
- **Suggested fix:** rewrite or delete the spec to match the code, or — if
  the code strayed from a design that still holds — change the code. Say
  which.

### 2. [High] …
```

For each finding, name the likely resolution explicitly. Default to the code:
specs that lag behind the system get rewritten or deleted. Suggest changing
the code only when it clearly strayed from a design that still holds, and let
the user decide. Never suggest a new ADR for a bug fix, and mark any new ADR as
needing the user's confirmation.

If the scan finds nothing, say so plainly and report the repo as in sync with
its specs; do not manufacture findings.

### 5. Offer next steps

Close by offering to act on the report — e.g. run `sdd-make` to fix the
high-priority items and bring `specs/` back in sync — but make no changes in
this skill.

## Guardrails

- Read the specs before scanning, then test each of their claims against the
  repo. The code is the source of truth.
- Read-only: never edit code or specs in this skill. Diagnose and report;
  hand fixes to `sdd-make`.
- Every finding cites both sides — the repo evidence (`path:line`) and the
  spec claim. No unsourced findings, no padding.
- Order strictly by criticality, and don't inflate severity; an honest "in
  sync" is a valid result.
- Drift usually means the spec is stale: suggest rewriting or deleting it.
  Suggest changing the code only when it strayed from a design that still
  holds, and say so explicitly.
