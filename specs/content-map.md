# Content Map

> A navigable index of this repository. **Keep it in sync as the repo evolves** —
> when you add a skill, a top-level file, or change how things are built/installed,
> update this map in the same change.

## What this project is

`sdd-skills` is a collection of [Claude Code](https://docs.claude.com/en/docs/claude-code)
skills implementing a **Spec-Driven Development (SDD)** workflow. In SDD a
repository's `specs/` directory (a content map plus Architecture Decision
Records) is a first-class, maintained artifact that grounds and guides agent
work. The repo ships six skills — `sdd-init`, `sdd-plan`, `sdd-make`,
`sdd-scan`, `sdd-fix`, and `sdd-handout` — each authored as a `SKILL.md`
instruction file (optionally with bundled support files) and installed into a
user's Claude Code skills directory.

## Top-level layout

| Path | Purpose |
|------|---------|
| `README.md` | User-facing overview: the skills, installation, and layout. |
| `Makefile` | Install/uninstall/list skills into `~/.claude/skills/` (override with `SKILLS_DIR`). |
| `skills/` | The skills themselves; one directory per skill. |
| `skills/sdd-init/SKILL.md` | Bootstrap SDD scaffolding in a repo. |
| `skills/sdd-init/assets/template.md` | Canonical ADR template `sdd-init` copies into `specs/adr/`. |
| `skills/sdd-plan/SKILL.md` | Plan a feature, grounded in `specs/` + a structured user interview. |
| `skills/sdd-make/SKILL.md` | Spec-grounded coding: read specs, honor them, update them. |
| `skills/sdd-scan/SKILL.md` | Audit the repo against `specs/`; report drift/mismatches by criticality. |
| `skills/sdd-fix/SKILL.md` | Debug: ground in `specs/` + git history, reproduce, prove root cause, hand off to `sdd-plan`. |
| `skills/sdd-handout/SKILL.md` | Session hand-off: resume from `HANDOUT.md` if present, otherwise write one. |
| `skills/sdd-handout/assets/template.md` | Canonical `HANDOUT.md` template the skill copies into the target repo root. |
| `specs/` | SDD artifacts for *this* repo (content map + ADRs). |
| `.gitignore` | Ignores `HANDOUT.md` — the transient session hand-off ([ADR-0006](adr/0006-handout-is-a-transient-session-bridge.md)). |

## The skills (entry points)

Each skill is a directory under `skills/` containing a `SKILL.md` with YAML
frontmatter (`name`, `description`) followed by the instructions Claude follows
when the skill is invoked. A skill may also bundle static support files
alongside `SKILL.md` (see [ADR-0005](adr/0005-skill-support-files-layout.md));
there is no executable code.

- **`sdd-init`** — `skills/sdd-init/SKILL.md`: creates `specs/` (content map +
  ADRs) and ensures `AGENTS.md` exists with a `CLAUDE.md` symlink. Bundles the
  canonical ADR template at `assets/template.md`, which it copies into the repo.
- **`sdd-plan`** — `skills/sdd-plan/SKILL.md`: produces a feature plan grounded
  in the specs and a one-question-at-a-time interview.
- **`sdd-make`** — `skills/sdd-make/SKILL.md`: the coding loop — read specs,
  implement DRY/KISS, update specs.
- **`sdd-scan`** — `skills/sdd-scan/SKILL.md`: a read-only audit — read specs,
  scan the repo against them, report drift/mismatches ordered by criticality.
- **`sdd-fix`** — `skills/sdd-fix/SKILL.md`: a debugging skill — ground in specs
  and git history, reproduce the bug, prove the root cause with material
  evidence (artifacts kept in a scratchpad outside the repo), then hand off to
  `sdd-plan`. Changes/commits no code without authorization.
- **`sdd-handout`** — `skills/sdd-handout/SKILL.md`: carries work across a
  context boundary via `HANDOUT.md` at the repo root (goal, key findings, next
  steps). Its presence selects the mode — resume the work it describes, or write
  a new one. Bundles the handout template at `assets/template.md`; the file
  itself is transient and gitignored
  ([ADR-0006](adr/0006-handout-is-a-transient-session-bridge.md)).

The skills form a workflow: `sdd-init` → `sdd-plan` → `sdd-make`, with
`sdd-scan` as an out-of-band conformance check that feeds fixes back to
`sdd-make`, and `sdd-fix` as the diagnosis entry point for a bug — it proves a
root cause and feeds the proven diagnosis into `sdd-plan`. `sdd-handout` is
orthogonal to all of them: it spans a session boundary in whichever phase the
work is in.

## Build / install

There is no compiler or runtime — skills are plain Markdown directories.

```bash
make install                      # copy skills/* into ~/.claude/skills/
make install SKILLS_DIR=/path     # install to a custom directory
make uninstall                    # remove installed skills
make list                         # list skills in this repo
```

See `Makefile:1` for the `SKILLS_DIR` default and targets.

## Tests

There is no automated test suite. Validation is manual: install the skills and
exercise each slash command (`/sdd-init`, `/sdd-plan`, `/sdd-make`, `/sdd-scan`,
`/sdd-fix`, `/sdd-handout`) in a Claude Code session, and confirm each
`SKILL.md` has valid frontmatter. See
[ADR-0002](adr/0002-dev-tools-and-testing.md).

## Configuration & environment

- The only configurable input is the `SKILLS_DIR` make variable (defaults to
  `$(HOME)/.claude/skills`). No environment files, secrets, or services.

## Deeper docs

- `README.md` — installation and usage.
- `specs/README.md` — what the SDD layout is and how to maintain it.
- `specs/adr/` — Architecture Decision Records (the *why* behind decisions).
