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

To pick up new versions later, re-run `make install` after `git pull`.

### Verify

In a Claude Code session, the skill becomes available as a slash command:

```
/sdd-init
```

## Layout

```
sdd-skills/
├── README.md
└── skills/
    ├── sdd-init/
    │   └── SKILL.md
    ├── sdd-plan/
    │   └── SKILL.md
    └── sdd-make/
        └── SKILL.md
```

Each skill is a directory containing a `SKILL.md` with YAML frontmatter
(`name`, `description`) followed by the instructions Claude follows when the
skill is invoked.
