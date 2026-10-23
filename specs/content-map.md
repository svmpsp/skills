# Content Map

> A component-level index of this repository — a table of contents, not an
> inventory. Edit it **only** when a component is added or removed, or a
> component's goal or high-level description changes. Never list a component's
> internals here ([ADR-0007](adr/0007-content-map-is-a-component-index.md)).

## What this project is

`sdd-skills` is a collection of [Claude Code](https://docs.claude.com/en/docs/claude-code)
skills implementing a **Spec-Driven Development (SDD)** workflow. In SDD a
repository's `specs/` directory (a content map plus Architecture Decision
Records) is a first-class, maintained artifact that grounds and guides agent
work. Each skill is a directory installed into a user's Claude Code skills
directory.

## Top-level layout

| Path | Purpose |
|------|---------|
| `README.md` | User-facing overview: the skills, installation, and layout. |
| `Makefile` | Install/uninstall/list skills into a Claude Code skills directory. |
| `skills/` | The skills; one directory per skill (see below). |
| `specs/` | SDD artifacts for *this* repo (content map + ADRs). |
| `.gitignore` | Ignores `HANDOUT.md`, the transient session hand-off. |

## Components — the skills

Each skill is a directory under `skills/` whose entry point is `SKILL.md`
([ADR-0005](adr/0005-skill-support-files-layout.md) covers its layout).

| Skill | Purpose |
|-------|---------|
| `skills/sdd-init/` | Bootstrap SDD in a repo: `specs/` plus a thin `AGENTS.md`. |
| `skills/sdd-plan/` | Plan a feature, grounded in `specs/` and a user interview. |
| `skills/sdd-make/` | Spec-grounded coding: read specs, honor them, update them. |
| `skills/sdd-scan/` | Audit the repo against `specs/`; report drift by criticality. |
| `skills/sdd-fix/` | Debug: reproduce a bug and prove its root cause, then hand off to `sdd-plan`. |
| `skills/sdd-handout/` | Carry work across sessions via a transient `HANDOUT.md`. |

The skills form a workflow: `sdd-init` → `sdd-plan` → `sdd-make`, with
`sdd-scan` as an out-of-band conformance check feeding fixes to `sdd-make`, and
`sdd-fix` as the diagnosis entry point feeding `sdd-plan`. `sdd-handout` spans
a session boundary in whichever phase the work is in.

## Build / install

```bash
make install                      # copy skills/* into ~/.claude/skills/
make install SKILLS_DIR=/path     # install to a custom directory
make uninstall                    # remove installed skills
make list                         # list skills in this repo
```

## Tests

No automated suite; validation is manual — see
[ADR-0002](adr/0002-dev-tools-and-testing.md).

## Configuration & environment

The only input is the `SKILLS_DIR` make variable (default
`$(HOME)/.claude/skills`). No environment files, secrets, or services.

## Deeper docs

- `README.md` — installation and usage.
- `specs/README.md` — the SDD layout and how to maintain it.
- `specs/adr/` — Architecture Decision Records (the *why*).
