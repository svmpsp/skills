# 0003. CI and release workflow

- **Status:** Proposed
- **Date:** 2026-06-11
- **Deciders:** Repository maintainers

## Context

The repository is a Git repo hosted with `main` as the default and integration
branch. There is currently **no** continuous-integration configuration (no
`.github/workflows/`, no `.gitlab-ci.yml`), no tagged releases, and no
versioning scheme. Distribution is by users cloning the repo and running
`make install` to copy skills into `~/.claude/skills/`; there is no published
package or artifact. Because the deliverables are Markdown skill files with no
build step (see [ADR-0002](0002-dev-tools-and-testing.md)), the bar for CI is
low but not zero — broken YAML frontmatter or a malformed `SKILL.md` would ship
silently.

## Decision

Because nothing is in place yet, this records the **recommended** approach,
left as `Proposed` until adopted:

- **Source of truth:** `main` is the integration branch; changes land via pull
  requests, each accompanied by an ADR when it makes a significant decision.
- **CI (recommended):** add a GitHub Actions workflow that, on pull requests
  and pushes to `main`, validates every `skills/*/SKILL.md` has parseable YAML
  frontmatter with required keys (`name`, `description`) and runs a Markdown
  lint. This is a cheap guard given there is no compile/test step.
- **Versioning & release:** adopt semantic version tags (`vMAJOR.MINOR.PATCH`)
  cut from `main` when the skill set changes meaningfully; the Git tag *is* the
  release, since installation is `git clone` + `make install`. No package
  registry is targeted.

## Consequences

- Once adopted, malformed skills are caught before merge instead of by users.
- Tagging releases gives users a stable ref to pin to and a changelog anchor.
- Until the workflow is added, correctness relies entirely on review and manual
  testing — this ADR should move to `Accepted` when the CI workflow lands, or
  be superseded if a different approach is chosen.

## Alternatives considered

- **No CI at all.** Acceptable today given the tiny surface, but it lets
  frontmatter/Markdown errors ship. Rejected as the long-term answer.
- **Publish to a package registry.** Rejected: Claude Code skills are consumed
  as directories under `~/.claude/skills/`, so `git` + `make install` is the
  natural distribution channel.
