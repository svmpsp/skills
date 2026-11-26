# sdd-skills

A set of Claude Code skills and agents for **Spec-Driven Development (SDD)** — a workflow
where a repository's `specs/` directory (a content map plus Architecture
Decision Records) is treated as a first-class, maintained artifact that guides
and grounds agent work.

## Skills

| Skill | Trigger | Purpose |
|-------|---------|---------|
| `sdd-init` | `/sdd-init` | Bootstrap SDD in a repo: create `specs/` (content map + ADRs) and ensure `AGENTS.md` exists with a `CLAUDE.md` symlink. |
| `sdd-plan` | `/sdd-plan` | Plan a feature grounded in both `specs/` and a structured user interview (one question at a time); no undocumented assumptions, push back when answers contradict the specs; and get every LLM prompt approved, rendered with realistic example data. |
| `sdd-make` | `/sdd-make` | Spec-grounded coding: read `specs/` before planning, write self-documenting DRY + KISS code as the source of truth, and keep `specs/` in sync once the task is done — rewriting or deleting outgrown ADRs, and adding one only with your confirmation. Never writes an LLM prompt before you approve it rendered. |
| `sdd-scan` | `/sdd-scan` | Read-only audit: scan the repo against `specs/` and report drift, ADR contradictions, and principle mismatches, ordered by criticality. Hands fixes off to `sdd-make`. |
| `sdd-fix` | `/sdd-fix` | Debug: ground in `specs/` and git history, reproduce the bug, and prove its root cause with material evidence (artifacts kept outside the repo); no code changes without authorization. Hands the proven diagnosis to `sdd-plan`. |
| `sdd-handout` | `/sdd-handout` | Hand work across a context boundary via `HANDOUT.md` (goal, key findings, next steps). If the file exists, resume the work it describes; if not, write one from the current session. |
| `sdd-query` | `/sdd-query` | Read-only research: answer a question grounded in the code and `specs/` (git history and web sources as supporting evidence), optionally via subagents. Answers in chat with cited sources and keeps a report of sources and approach in a scratchpad outside the repo. |

`sdd-init` → `sdd-plan` → `sdd-make` form the core workflow; `sdd-scan` is an
out-of-band conformance check you run any time to catch drift, and `sdd-fix` is
the diagnosis entry point for a bug — it proves a root cause, then feeds it into
`sdd-plan`. `sdd-handout` cuts across all of them: run it when a session grows
too long, then run it again in a fresh session to pick the work back up.
`sdd-query` answers questions about the repo from its code and specs, and points
you to `sdd-scan`, `sdd-fix`, or `sdd-plan` when the answer calls for action.

## Agents

| Agent | Invoked by | Purpose |
|-------|------------|---------|
| `sdd-qa-tester` | `sdd-make` (or by name) | Owns all test work for a change: first reviews it for testability and may send it back (`fix first` / `rework`), otherwise writes meaningful, non-naive tests derived from the acceptance criteria, in the repo's own conventions. Never changes feature code. |
| `sdd-prompt-editor` | `sdd-plan`, `sdd-make` (or by name) | Writes and edits every prompt: plain instructions with only the context the model needs, a precise output format, and positive few-shot examples or step-by-step reasoning where the task calls for them. Returns the prompt plus a rendering for you to approve; never writes files. |

`sdd-make` delegates all test work to `sdd-qa-tester`, and `sdd-plan`/`sdd-make`
delegate all prompt writing to `sdd-prompt-editor`; each stops if its agent is
not installed — see [ADR-0009](specs/adr/0009-agents-ship-alongside-skills.md)
and [ADR-0008](specs/adr/0008-prompts-are-approved-rendered.md). You still
approve every prompt before it is written.

This repo also dogfoods SDD: its own [`specs/`](specs/) directory (a content map
plus ADRs) is the source of truth for how it is structured and built.

## Installation

Skills are plain folders under `skills/`; agents are single files under
`agents/`. They install into your Claude Code skills and agents directories
(`~/.claude/skills/` and `~/.claude/agents/`).

```bash
git clone <this-repo-url> sdd-skills
cd sdd-skills

# Install all skills and agents
make install
```

`make install` copies every skill into `~/.claude/skills/` and every agent into
`~/.claude/agents/`. Override the destinations with `SKILLS_DIR` and
`AGENTS_DIR`:

```bash
make install SKILLS_DIR=/custom/path/skills AGENTS_DIR=/custom/path/agents
```

You can also copy them by hand instead of using `make`:

```bash
# Install all skills and agents
cp -r skills/* ~/.claude/skills/
cp agents/*.md ~/.claude/agents/

# ...or install a single skill
cp -r skills/sdd-init ~/.claude/skills/
```

To pick up new versions later, re-run `make install` after `git pull`. The
Makefile also provides:

```bash
make uninstall    # remove the installed skills and agents (other agents are left alone)
make list         # list the skills and agents in this repo
```

### Verify

Start a new Claude Code session (agents are loaded at session start). Skills
are available as slash commands, and `sdd-qa-tester` appears in `/agents`:

```
/sdd-init
```

## Layout

```
sdd-skills/
├── README.md
├── Makefile              # install / uninstall / list
├── AGENTS.md             # thin pointer to specs/ (CLAUDE.md is a symlink to it)
├── skills/
│   ├── sdd-init/
│   │   ├── SKILL.md
│   │   └── assets/
│   │       └── template.md   # canonical ADR template, copied into target repos
│   ├── sdd-plan/
│   │   └── SKILL.md
│   ├── sdd-make/
│   │   └── SKILL.md
│   ├── sdd-scan/
│   │   └── SKILL.md
│   ├── sdd-fix/
│   │   └── SKILL.md
│   ├── sdd-handout/
│   │   ├── SKILL.md
│   │   └── assets/
│   │       └── template.md   # canonical HANDOUT.md template
│   └── sdd-query/
│       └── SKILL.md
├── agents/
│   ├── sdd-prompt-editor.md  # writes every prompt; sdd-plan/sdd-make delegate here
│   └── sdd-qa-tester.md      # test reviewer/writer; sdd-make delegates all test work here
└── specs/                # this repo's own SDD artifacts
    ├── content-map.md    # navigable index of the repo
    └── adr/              # Architecture Decision Records
```

Each skill is a directory containing a `SKILL.md` with YAML frontmatter
(`name`, `description`) followed by the instructions Claude follows when the
skill is invoked. A skill may also bundle static support files in standard
subdirectories (`assets/`, `references/`, `scripts/`) — see
[ADR-0005](specs/adr/0005-skill-support-files-layout.md).

Each agent is a single Markdown file with YAML frontmatter (`name`,
`description`, `tools`, `model`); its body is the agent's system prompt.
