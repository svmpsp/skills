---
name: ship-issue
description: Implements one GitHub issue end to end from a clean session and opens a pull request. Treats the issue as the whole brief. Checks it is ready (open, has Goal and acceptance criteria, no open questions). Branches from the up-to-date default branch, investigates the code from the issue's pointers, reproduces a bug before fixing it, moves the board item to In Progress, and implements strictly within scope following the repo's conventions. Runs the repo's own checks (lint, type-check, tests, build), commits, pushes, and opens a PR that closes the issue and maps each acceptance criterion to its evidence. Refuses epics (and offers their sub-issues), closed issues, issues with open questions, and issues that no longer match the code. Use when the user runs /ship-issue or asks to implement, ship, build, fix, or work on issue #N (or an issue URL) and open a PR.
---

# ship-issue

Takes one GitHub issue and ships it as a pull request. Assume a clean session:
the issue is the whole brief. Its Goal and Context say **what** to change and
**why**, Scope bounds the change, and the acceptance criteria say when it is
done. **How** is yours to work out from the code. Notes, when present, are
hints, not requirements.

Running this skill authorizes you to create a branch, commit, push it, and open
the PR. It does not authorize anything else: no merging, no force-pushing, and
no changes outside the issue's scope.

## 1. Read the issue

1. Run `gh issue view <number-or-url> --json number,title,body,labels,url,state,projectItems,parent,subIssues`.
2. Run `gh repo view --json owner,nameWithOwner,defaultBranchRef`. Keep
   `owner.login` as `<owner>` and note the default branch.

## 2. Check it is ready

Stop at the first check that fails:

- **Epic** (label `epic`, or it has sub-issues): do not implement it. List its
  open sub-issues in order (number and title) and ask which one to ship. If the
  user says "next", take the first open one. Restart from step 1 with the
  chosen issue.
- **Closed**: stop and say so.
- **Open questions**: if the section says anything other than `None`, stop and
  list the questions. They need answers in the issue before it can ship.
- **Not a spec**: if the body has no Goal or no Acceptance criteria section,
  stop and say what is missing.
- **Blocked**: if Notes name a prerequisite issue that is still open, stop and
  name it.

## 3. Prepare the branch

1. If `git status --porcelain` shows any change, stop and ask the user what to
   do with it.
2. Name the branch `<type>/<number>-<short-slug>`:
   - type: `feat` for label `feature`, `fix` for label `bug`. If the issue has
     neither label, use `fix` for a defect and `feat` otherwise, and mention
     the choice in the report.
   - slug: 3–5 lowercase words from the title, joined by hyphens.
   - example: `fix/57-pagination-skips-first-item`.
3. Run `git fetch origin`, then `git switch -c <branch> origin/<default-branch>`.
   If the branch already exists, stop and ask whether to continue on it.

## 4. Investigate

1. Read the repo's own instructions (`AGENTS.md`, `CLAUDE.md`, `CONTRIBUTING.md`,
   and any files they point to).
2. Follow the Context pointers into the code and read enough of it to
   understand the current behaviour.
3. **Bug:** reproduce it before changing anything. Write a failing test where
   the repo has tests; otherwise run the issue's repro steps. Confirm it fails
   the way the issue describes.
   **Feature:** confirm the current behaviour is as the issue describes.
4. If the issue no longer matches the code, do not guess. Examples: the bug
   does not reproduce, it is already fixed, or the code it points to has moved
   or been removed. Discard your changes, switch back to the branch you started
   on, delete the new branch, and report what you found.

## 5. Move the board item

For each entry in `projectItems`, find the board's number by matching its title
in `gh project list --owner <owner>`. Then run
`gh project item-edit <number> --owner <owner> --url <issue-url> --field Status --value "In Progress"`.

If the issue is on no board, skip this step and note it in the report. If the
edit fails because the token lacks the `project` scope, note it, tell the user
to run `gh auth refresh -s project`, and continue.

## 6. Implement

1. Change only what Scope **In** covers. Leave everything under **Out**
   untouched. If the goal cannot be met without going outside Scope, stop and
   ask the user.
2. Match the surrounding code's style, structure, and patterns, and follow the
   repo's instructions over your own defaults.
3. Add or adjust tests, following the repo's conventions, so that every
   acceptance criterion has evidence: a test, a command's output, or a manual
   check you performed.

## 7. Validate

1. Find the checks the repo runs. Look in the CI config (e.g.
   `.github/workflows/`), the contributor docs, and the build files (Makefile,
   package scripts, and similar). Run all of them: lint, type-check, tests,
   build.
2. Check each acceptance criterion against its evidence.
3. When a check fails, fix the code and re-run the full set. Never weaken, skip,
   or delete tests, checks, or lint rules to make them pass.
4. If a check still fails and you cannot fix it within Scope, stop before
   committing. Report the failure, its output, and what you tried.

## 8. Commit, push, open the PR

1. Infer the commit style from `git log --oneline -20` (e.g. Conventional
   Commits `fix(api): subject`) and follow it.
2. Stage only the files you changed (`git add <paths>`), then commit.
3. Push: `git push -u origin <branch>`.
4. Write the PR body to a file in the session scratchpad, or in a directory from
   `mktemp -d` if there is no scratchpad (never in the working tree). Then run
   `gh pr create --base <default-branch> --head <branch> --title "<issue title>" --body-file <file>`.

PR body:

```markdown
Closes #<number>

## Summary
<two or three sentences: what changed and how; for a bug, the root cause>

## Acceptance criteria
- [x] **AC-1** <criterion, shortened> — <evidence: test name and file, command and result, or manual check>
- [ ] **AC-2** <criterion, shortened> — not met: <why>

## Validation
- `<command>` — passed
- Manual: <check> — <what you observed>
```

Tick an acceptance criterion only when its evidence exists. Leave an unmet one
unticked, say why in the PR, and say why again to the user.

## 9. Report

Tell the user:

- the PR URL and the branch;
- each check you ran and its result;
- any unmet acceptance criterion and the reason;
- any skipped step (board not updated, type inferred) and why.

## Guardrails

- One issue per run, and the issue is the whole brief. Never implement an epic
  directly.
- Stop on a closed, blocked, or not-ready issue, or a dirty working tree. Never
  work around them.
- Reproduce a bug before fixing it. Stop when the issue no longer matches the
  code.
- Stay inside Scope **In**. **Out** is off-limits.
- Fix failures in the code, never by weakening tests or checks. Stop before
  committing if a check cannot be made to pass.
- Never merge, force-push, or push to the default branch.
