# sdd-skills

A set of Claude Code skills for **Spec-Driven Development (SDD)** — a workflow
where a repository's `specs/` directory (a content map plus Architecture
Decision Records) is treated as a first-class, maintained artifact that guides
and grounds agent work.

## Skills

| Skill | Trigger | Purpose |
|-------|---------|---------|
| `sdd-init` | `/sdd-init` | Bootstrap SDD in a repo: create `specs/` (content map + ADRs) and ensure `AGENTS.md` exists with a `CLAUDE.md` symlink. |
| `sdd-make` | `/sdd-make` | *(planned)* Author a new spec/feature on top of the SDD scaffolding. |

## Installation

Skills are plain folders under `skills/`. Install by copying the folders you
want into your Claude Code skills directory (`~/.claude/skills/`):

```bash
git clone <this-repo-url> sdd-skills
cd sdd-skills

# Install all skills
cp -r skills/* ~/.claude/skills/

# ...or install a single skill
cp -r skills/sdd-init ~/.claude/skills/
```

To pick up new versions later, re-run the copy after `git pull`.

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
    └── sdd-init/
        └── SKILL.md
```

Each skill is a directory containing a `SKILL.md` with YAML frontmatter
(`name`, `description`) followed by the instructions Claude follows when the
skill is invoked.
