# Content Map

> A component-level index of this repository — a table of contents, not an
> inventory. Edit it **only** when a component is added or removed, or a
> component's goal or high-level description changes. Never list a component's
> internals here ([ADR-0007](adr/0007-content-map-is-a-component-index.md)).

## What this project is

`sdd-skills` is a collection of [Claude Code](https://docs.claude.com/en/docs/claude-code)
skills and agents implementing a **Spec-Driven Development (SDD)** workflow. In
SDD a repository's `specs/` directory (a content map plus Architecture Decision
Records) is a first-class, maintained artifact that grounds and guides agent
work. Each skill is a directory installed into a user's Claude Code skills
directory; each agent is a file installed into their agents directory
([ADR-0009](adr/0009-agents-ship-alongside-skills.md)).

## Top-level layout

| Path | Purpose |
|------|---------|
| `README.md` | User-facing overview: the skills and agents, installation, and layout. |
| `Makefile` | Install/uninstall/list skills and agents into the Claude Code directories. |
| `skills/` | The skills; one directory per skill (see below). |
| `agents/` | The agents; one file per agent (see below). |
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
| `skills/sdd-fix/` | Debug: reproduce a bug and prove its root cause, then hand off to `sdd-plan` (or straight to `sdd-make` for a small fix). |
| `skills/sdd-handout/` | Carry work across sessions via a transient `HANDOUT.md`. |
| `skills/sdd-query/` | Answer a question grounded in the code and `specs/`; read-only. |

The skills form a workflow: `sdd-init` → `sdd-plan` → `sdd-make`, with
`sdd-scan` as an out-of-band conformance check feeding fixes to `sdd-make`, and
`sdd-fix` as the diagnosis entry point feeding `sdd-plan` (or `sdd-make` for a
small fix). `sdd-handout` spans
a session boundary in whichever phase the work is in. `sdd-query` is an
out-of-band research entry point that can point to `sdd-scan`, `sdd-fix`, or
`sdd-plan`.

## Components — the agents

Each agent is a single file `agents/<name>.md`: frontmatter for routing and
tools, and a body that is the agent's system prompt.

| Agent | Purpose |
|-------|---------|
| `agents/sdd-qa-tester.md` | Own all test work for a change: review it for testability, then write meaningful, non-naive tests. |
| `agents/sdd-prompt-editor.md` | Write and edit every prompt: plain instructions, only relevant context, positive few-shot examples. |
| `agents/sdd-architect.md` | Review code for design and readability and propose fixes; a consultant that never edits. |
| `agents/sdd-ux-designer.md` | Review user-facing changes (GUI in the running app, CLI) for usability, consistency, and accessibility; a consultant that never edits. |

`sdd-make` delegates all test work to `sdd-qa-tester`; `sdd-plan` and `sdd-make`
delegate all prompt writing to `sdd-prompt-editor`; `sdd-make` and `sdd-fix`
consult `sdd-architect` when code feels overcomplicated or a bug may be
structural; `sdd-make` consults `sdd-ux-designer` on every GUI or CLI change.

## Build / install

```bash
make install                      # copy skills/* into ~/.claude/skills/ and agents/*.md into ~/.claude/agents/
make install SKILLS_DIR=/path AGENTS_DIR=/path   # install to custom directories
make uninstall                    # remove installed skills and agents
make list                         # list skills and agents in this repo
```

## Tests

No automated suite; validation is manual — see
[ADR-0002](adr/0002-dev-tools-and-testing.md).

## Configuration & environment

The only inputs are the `SKILLS_DIR` and `AGENTS_DIR` make variables (defaults
`$(HOME)/.claude/skills` and `$(HOME)/.claude/agents`). No environment files,
secrets, or services.

## Deeper docs

- `README.md` — installation and usage.
- `specs/README.md` — the SDD layout and how to maintain it.
- `specs/adr/` — Architecture Decision Records (the *why*).
