# sdd-skills

A set of Claude Code skills for **Spec-Driven Development (SDD)** — a workflow
where a repository's `specs/` directory (a content map plus Architecture
Decision Records) is treated as a first-class, maintained artifact that guides
and grounds agent work.

## Skills

| Skill | Trigger | Purpose |
|-------|---------|---------|
| `sdd-init` | `/sdd-init` | Bootstrap SDD in a repo: create `specs/` (content map + ADRs) and ensure `AGENTS.md` exists with a `CLAUDE.md` symlink. |
| `sdd-plan` | `/sdd-plan` | Plan a feature grounded in both `specs/` and a structured user interview (one question at a time); no undocumented assumptions, and push back when answers contradict the specs. |
| `sdd-make` | `/sdd-make` | Spec-grounded coding: read `specs/` before planning, honor it while implementing (DRY + KISS), and update `specs/` once the task is done. |
| `sdd-scan` | `/sdd-scan` | Read-only audit: scan the repo against `specs/` and report drift, ADR contradictions, and principle mismatches, ordered by criticality. Hands fixes off to `sdd-make`. |
| `sdd-fix` | `/sdd-fix` | Debug: ground in `specs/` and git history, reproduce the bug, and prove its root cause with material evidence (artifacts kept outside the repo); no code changes without authorization. Hands the proven diagnosis to `sdd-plan`. |

`sdd-init` → `sdd-plan` → `sdd-make` form the core workflow; `sdd-scan` is an
out-of-band conformance check you run any time to catch drift, and `sdd-fix` is
the diagnosis entry point for a bug — it proves a root cause, then feeds it into
`sdd-plan`.

This repo also dogfoods SDD: its own [`specs/`](specs/) directory (a content map
plus ADRs) is the source of truth for how it is structured and built.

## Installation

Skills are plain folders under `skills/`. They install into your Claude Code
skills directory (`~/.claude/skills/`).

```bash
git clone <this-repo-url> sdd-skills
cd sdd-skills

# Install all skills
make install
```

`make install` copies every skill into `~/.claude/skills/`. Override the
destination with `SKILLS_DIR`:

```bash
make install SKILLS_DIR=/custom/path/skills
```

You can also copy folders by hand instead of using `make`:

```bash
# Install all skills
cp -r skills/* ~/.claude/skills/

# ...or install a single skill
cp -r skills/sdd-init ~/.claude/skills/
```

To pick up new versions later, re-run `make install` after `git pull`. The
Makefile also provides:

```bash
make uninstall    # remove the installed skills from SKILLS_DIR
make list         # list the skills in this repo
```

### Verify

In a Claude Code session, the skill becomes available as a slash command:

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
│   └── sdd-fix/
│       └── SKILL.md
└── specs/                # this repo's own SDD artifacts
    ├── content-map.md    # navigable index of the repo
    └── adr/              # Architecture Decision Records
```

Each skill is a directory containing a `SKILL.md` with YAML frontmatter
(`name`, `description`) followed by the instructions Claude follows when the
skill is invoked. A skill may also bundle static support files in standard
subdirectories (`assets/`, `references/`, `scripts/`) — see
[ADR-0005](specs/adr/0005-skill-support-files-layout.md).
