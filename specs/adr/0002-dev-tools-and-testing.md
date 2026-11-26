# 0002. Development tooling and testing

- **Status:** Accepted
- **Date:** 2026-06-11
- **Deciders:** Repository maintainers

## Context

This repository contains no application source code. Its deliverables are
Claude Code skills and agents authored as Markdown instruction files with YAML
frontmatter, distributed by copying them into a user's `~/.claude/skills/` and
`~/.claude/agents/` directories. There is no programming language runtime,
package manager, compiler, linter, or test framework in the repo today — the
only tooling is GNU Make (`Makefile`) plus standard POSIX shell utilities
(`cp`, `mkdir`, `rm`, `ln`, `ls`).

## Decision

We will keep the toolchain minimal and dependency-free:

- **Authoring format:** each skill is `skills/<name>/SKILL.md` with YAML
  frontmatter (`name`, `description`) followed by Markdown instructions. Each
  agent is `agents/<name>.md` with YAML frontmatter (`name`, `description`,
  `tools` or `disallowedTools`, `model`) followed by its system prompt.
- **Build/install tooling:** GNU Make drives install/uninstall/list against
  `SKILLS_DIR` and `AGENTS_DIR` variables (defaults `$(HOME)/.claude/skills`
  and `$(HOME)/.claude/agents`) — see `Makefile`.
- **No language runtime or package manager** is introduced; there are no
  third-party dependencies to manage.
- **Testing is manual and behavioral:** install (`make install`) and exercise
  each slash command (`/sdd-init`, `/sdd-plan`, `/sdd-make`) in a new Claude
  Code session, verifying the documented "done" state; agents are exercised
  through the skills that delegate to them (`sdd-qa-tester` via `/sdd-make`).
  Frontmatter and Markdown are checked by review.

## Consequences

- Zero setup: a contributor needs only `git`, `make`, and a POSIX shell.
- There is no automated regression safety net; correctness depends on review
  and manual exercise of the skills. If the skill set grows, a lightweight
  check (e.g. a frontmatter/Markdown linter run from `make`) may become
  worthwhile and should be captured as a new ADR.
- Keeping the build in `make` makes install behavior explicit and portable.

## Alternatives considered

- **Add a language toolchain (Node/Python) for linting/tests.** Rejected as
  premature: the repo has no executable code, so it would add dependencies
  without protecting anything real.
- **A shell-based test harness asserting on `SKILL.md` structure.** Deferred:
  reasonable once there are enough skills to justify it; not needed today.
