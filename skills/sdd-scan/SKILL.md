---
name: sdd-scan
description: Spec-conformance audit skill for Spec-Driven Development (SDD). Reads the repository's specs/ (content map + ADRs) as the source of truth, then scans the actual repo contents for drift, contradictions, and gaps against that recorded knowledge. Produces a read-only report of findings ordered by criticality — it diagnoses, it does not fix. Use when the user runs /sdd-scan or asks to audit, scan, or check a repo against its specs, find spec drift, or flag mismatches between the code and its guiding principles.
---

# sdd-scan

The audit skill of the SDD workflow. It treats `specs/` (the content map and
ADRs created by `sdd-init`) as the source of truth and checks the **actual
repository** against it, surfacing where the two have drifted apart and where
the code violates the principles the specs record.

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
2. Read `specs/content-map.md` — the claimed structure, entry points, build/
   install/test commands, and where things live.
3. Read every ADR under `specs/adr/`, noting each one's **status** (Proposed vs
   Accepted vs Superseded). Accepted ADRs are binding claims about how the repo
   is built; Proposed ones are open questions.
4. Read `AGENTS.md`/`CLAUDE.md` for the conventions the repo claims to hold.

These documents are the *expected* state. The rest of the scan compares the
*actual* repo against them.

### 2. Scan the repo against the specs

Inspect the real contents (file tree, manifests, configs, CI, source) and look
for divergence from what you read in phase 1. Check at least these axes:

- **Structural drift** — does the content map still match the tree? Files,
  directories, modules, or entry points it names that are **missing, moved, or
  renamed**; significant components that **exist but are undocumented**.
- **Command drift** — do the documented build/install/test/run commands still
  exist and work as described (targets in the Makefile, scripts in the
  manifest, CI invocations)?
- **ADR contradictions** — does the code contradict an **Accepted** ADR
  (a different framework/datastore/tool than the one decided, a convention the
  ADR forbids, a structure it rules out)?
- **Stale decisions** — ADRs marked **Proposed** that the repo has since
  actually implemented (they should be Accepted), or **Accepted** ADRs the repo
  has outgrown or now contradicts (they may need superseding).
- **Principle mismatches** — violations of the guiding principles the specs
  state: DRY (genuine duplication that a documented helper/pattern should
  cover), KISS (needless complexity), and any repo-specific rules (e.g.
  "`AGENTS.md` is a thin pointer" — flag it if it has grown into a second copy
  of the overview).
- **Coverage gaps** — architecturally significant decisions or subsystems with
  **no spec coverage** at all (a whole service, datastore, or auth scheme the
  ADRs never mention).

Ground every finding in evidence: cite the spec location (content-map section
or ADR number) and the concrete repo location (`path:line`) that disagree with
it. Do not report a "finding" you cannot point at in both places — and do not
invent problems to pad the report.

### 3. Prioritize by criticality

Assign each finding a severity, judged by how badly it misleads someone relying
on the specs or how directly it breaks a binding decision:

- **Critical** — the spec actively misleads or a binding rule is broken: a
  documented command that fails, content-map pointers to things that no longer
  exist, or code that contradicts an **Accepted** ADR. Acting on the specs here
  produces wrong results.
- **High** — a significant component or decision is undocumented, or a Proposed
  ADR is in fact already decided. The picture is incomplete in a way that will
  bite.
- **Medium** — real but contained drift or a principle smell: minor structural
  mismatch, localized duplication, an `AGENTS.md` drifting past "thin."
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
| … |          |             |                                               |

## Findings

### 1. [Critical] <short title>
- **Spec says:** <claim> (`specs/content-map.md` §… / ADR-NNNN)
- **Repo shows:** <reality> (`path:line`)
- **Why it matters:** <impact on someone trusting the specs>
- **Suggested fix:** update the spec to match reality, or change the code to
  honor the spec, or record a new/superseding ADR — say which.

### 2. [High] …
```

For each finding, name the likely correct resolution but stay neutral on
*which side is wrong*: drift can mean the spec is stale **or** the code has
strayed — the suggested fix should make that choice explicit, not assume the
code is always right.

If the scan finds nothing, say so plainly and report the repo as in sync with
its specs; do not manufacture findings.

### 5. Offer next steps

Close by offering to act on the report — e.g. run `sdd-make` to fix the
high-priority items and bring `specs/` back in sync — but make no changes in
this skill.

## Guardrails

- Read the specs before scanning; the specs define "expected," the repo is
  "actual."
- Read-only: never edit code or specs in this skill. Diagnose and report;
  hand fixes to `sdd-make`.
- Every finding cites both sides — the spec claim and the repo evidence
  (`path:line`). No unsourced findings, no padding.
- Order strictly by criticality, and don't inflate severity; an honest "in
  sync" is a valid result.
- Drift is symmetric: the spec may be stale or the code may have strayed. Make
  the suggested resolution explicit rather than assuming one side.
