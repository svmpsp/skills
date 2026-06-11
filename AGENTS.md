# AGENTS.md

Guidance for agents and contributors working in this repository.

## Project overview

`sdd-skills` is a collection of [Claude Code](https://docs.claude.com/en/docs/claude-code)
skills implementing a **Spec-Driven Development (SDD)** workflow. Each skill is a
Markdown instruction file (`skills/<name>/SKILL.md`) with YAML frontmatter,
installed into a user's `~/.claude/skills/` directory. The three skills —
`sdd-init`, `sdd-plan`, `sdd-make` — form a workflow that treats a repo's
`specs/` directory as a first-class, maintained artifact.

There is no application source code, runtime, or package manager. See
[`specs/content-map.md`](specs/content-map.md) for the full layout.

## Build / test / run

```bash
make install                  # copy skills/* into ~/.claude/skills/
make install SKILLS_DIR=/path # install to a custom directory
make uninstall                # remove installed skills
make list                     # list skills in this repo
```

There is no automated test suite. Validate manually: `make install`, then
exercise each slash command (`/sdd-init`, `/sdd-plan`, `/sdd-make`) in a Claude
Code session and confirm the documented behavior. See
[ADR-0002](specs/adr/0002-dev-tools-and-testing.md).

## Code conventions

- Each skill lives in `skills/<name>/SKILL.md` with YAML frontmatter containing
  `name` and `description`, followed by Markdown instructions.
- Keep the toolchain dependency-free (Make + POSIX shell only).
- Markdown: wrap prose sensibly, use fenced code blocks, prefer relative links.

## Specs (read these first)

This repo practices SDD on itself. Before planning or making changes, read:

- [`specs/content-map.md`](specs/content-map.md) — where everything is and how
  to build/install it.
- [`specs/adr/`](specs/adr/) — the *why* behind significant decisions.

When you change structure or workflow, update `specs/content-map.md` in the same
change; when you make a significant decision, add an ADR
([`specs/adr/README.md`](specs/adr/README.md)).
