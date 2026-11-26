# 0009. Agents ship alongside skills; sdd-make delegates all test work to sdd-qa-tester

- **Status:** Accepted
- **Date:** 2026-11-26
- **Deciders:** Sivam Pasupathipillai

## Context

Until now the repo shipped only skills: instructions loaded into the session
that invokes them. `sdd-make` implemented a change and wrote its tests in the
same context, so the tests were shaped by the implementation they were meant to
check — the classic route to suites that reach full coverage while asserting
that the code does what it does.

Claude Code also supports custom agents: single Markdown files in
`~/.claude/agents/` whose frontmatter (`name`, `description`, `tools`, `model`)
routes delegation and whose body is the agent's system prompt. A delegated
agent runs in a fresh context, sees only the brief it is given, and returns one
report.

## Decision

We will ship agents alongside skills, as single files `agents/<name>.md`,
installed by `make install` into `AGENTS_DIR` (default `$(HOME)/.claude/agents`).

`sdd-qa-tester` owns **all** test work. `sdd-make` never writes or
edits tests; it briefs `sdd-qa-tester` with the goal, acceptance criteria, changed
files and base ref, and test command, and acts on its verdict:

- `fix first` — the reviewer found defects; `sdd-make` fixes them and
  delegates again.
- `rework` — the change is not meaningfully testable; `sdd-make` agrees the
  restructuring with the user, then delegates again.
- `tested` — tests are written; failures that point at the feature are fixed in
  the code, never in the test.

If `sdd-qa-tester` is not installed, `sdd-make` stops rather than falling back to
writing tests itself.

## Consequences

- Tests are written from the acceptance criteria in a context that never saw
  the implementation's reasoning, and by an agent allowed to push back.
- `sdd-make` now depends on an installed agent; installing only the skills
  leaves it unable to finish a task.
- Agents are single files, so they cannot bundle support files the way skills
  do ([ADR-0005](0005-skill-support-files-layout.md)).
- An agent's description and body are prompts, approved rendered like any
  other ([ADR-0008](0008-prompts-are-approved-rendered.md)), which also
  records the second agent, `sdd-prompt-editor`.
- Agents either own a kind of work (`sdd-qa-tester` writes tests,
  `sdd-prompt-editor` writes prompts) or consult: `sdd-architect` only reviews
  and proposes fixes, and the calling skill decides and edits.

## Alternatives considered

- **`sdd-make` writes its own tests.** Rejected: the implementer grading its own
  work produces implementation-mirroring tests.
- **Optional delegation, with `sdd-make` as fallback.** Rejected: two paths to
  the same tests, and the weaker one is taken whenever the agent is missing.
- **An always-on orchestrator agent (`sdd-mind`) as the session's main agent.**
  Deferred: it would require editing users' settings and overlaps `AGENTS.md`
  ([ADR-0004](0004-agents-md-is-a-thin-pointer.md)).
- **`sdd-qa-tester` reproducing suspected defects via `sdd-fix`.** Rejected:
  `sdd-fix` assumes an interactive user, which a subagent does not have.
