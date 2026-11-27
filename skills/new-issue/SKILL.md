---
name: new-issue
description: Records work as self-contained GitHub issues so it can be shipped later, in any order, from a fresh session with no access to this one. Creates one standalone issue per item of work the user lists or the session found (or an epic with sub-issues when the items only make sense together), each stating what and why completely and concisely, with repro steps, evidence, path:line pointers and Given/When/Then acceptance criteria. Applies a type label and adds each issue to a GitHub Projects board with Status Todo, without touching the working tree or the current branch. Use when the user runs /new-issue or asks to file, record, capture, create, or open an issue, ticket, bug report, feature request, or epic on GitHub, including "an issue for each of these" or "file this bug for later".
---

# new-issue

Writes work down as GitHub issues so it can be done later, in any order, from a
fresh session. Two typical uses:

- A session turned up several items of work. The user wants an issue for each,
  to ship one at a time later.
- The user spotted a bug while doing something else. They want it recorded
  without breaking off from what they are doing.

Each issue is the whole brief for whoever ships it. That may be a person or an
agent session, and it has **no access to this conversation**. The issue states
**what** to change and **why**, completely and concisely. **How** is worked out
when the issue is shipped.

The work is already settled, so do not interview the user about it. Write only
what the user's instructions and the session established. Do not disturb the
user's current work: no branch switch, no stash, no edits to the working tree.
Reading code to get accurate pointers is fine.

## 1. Check prerequisites

Run these first. If any fails, stop and tell the user what is wrong and how to
fix it:

1. `gh auth status` — gh is authenticated and the token's scopes include
   `project`. If `project` is missing, tell the user to run
   `gh auth refresh -s project`.
2. `gh repo view --json owner,nameWithOwner,url` — the repo has a GitHub remote.
   Keep `owner.login` as `<owner>` and `nameWithOwner` as `<owner/repo>`.
3. `gh --version` — 2.97 or later; 2.99 or later when an image will be attached.

## 2. Decide the issues

- **Default: one standalone issue per item of work** the user listed or the
  session found. "An issue for each" means N standalone issues.
- **Epic** only when the user asks for one, or when the items are parts of one
  goal that only makes sense once all of them ship. The parts become
  sub-issues.
- Type each standalone issue and sub-issue `bug` when it fixes behaviour that
  is wrong today, `feature` otherwise.
- Make each issue small, shippable as one PR, and testable on its own. Keep the
  issues independent so they can ship in any order. If one truly needs another
  first, create the prerequisite first. Then name it by number in the
  dependent issue's Notes.

## 3. Write each issue

Read the template and fill it in. Never retype it from memory:

- standalone issue or sub-issue: `${CLAUDE_SKILL_DIR}/assets/issue.md`
- epic: `${CLAUDE_SKILL_DIR}/assets/epic.md`

Write for a reader who has none of this session:

- Name things the way the code and the product name them: files, functions,
  commands, `path:line`. Never write "as discussed", "the bug above", or names
  coined during this session.
- Carry over everything the session learned that the reader would otherwise
  have to rediscover. That means repro steps, observed versus expected
  behaviour, error output, the command that showed it, `path:line` pointers,
  links, and constraints the user stated.
- Keep it concise. Leave out how the session found the problem, and don't write
  an implementation plan.

For each section:

- **Title** (passed to `--title`): short and specific, e.g. `Fix pagination
  skipping the first item on page 2 and later`.
- **Goal**: what changes and why, in 1–3 sentences.
- **Context**: the current behaviour and why it is a problem. For a bug, give
  steps to reproduce and expected versus actual behaviour, with the evidence.
- **Scope**: what is in and what is explicitly out.
- **Acceptance criteria**: number them `AC-1`, `AC-2`, … and write each as
  *Given … when … then …* with an outcome someone can observe from outside the
  code.
- **Notes**: optional hints about how. Examples: a suspected cause (labelled as
  a suspicion), a lead, a constraint the fix must respect, a dependency
  (`Depends on #57`). Write `None` if there are none.
- **Open questions**: only an unsettled *what* or *why*, such as unclear
  intended behaviour. An unknown *how*, such as a root cause not yet found, is
  not an open question; record what is known about it in Notes. Write `None`
  when nothing is open.
- **Done when** (epic): outcomes for the whole epic. Do not list the
  sub-issues; they are linked as sub-issues.

Remove every HTML comment and keep every heading.

Example: the user, mid-task, says "file that off-by-one we saw in the paginator
for later". The issue's Context and Notes read:

```markdown
## Context
`paginate()` (`src/api/pagination.py:48`) skips the first item of every page
after page 1.

Steps to reproduce, with 25 items seeded:
1. `curl 'localhost:8000/items?page=2&per_page=10'`
2. The response holds 9 items, ids 12–20.

Expected: 10 items, ids 11–20. Actual: 9 items; id 11 is never returned on any
page.

## Notes
Suspected cause (not confirmed): the offset is computed as
`page * per_page + 1` at `src/api/pagination.py:52`.
```

Images: if the session holds a local image that belongs in an issue, reference
it in the body as `![alt](./path/to/image.png)`. Pass the same path to
`--attach` at creation.

Write each body to its own file in the session scratchpad, or in a directory
from `mktemp -d` if there is no scratchpad. Never write it in the working tree.

## 4. Pick the project board

Every issue goes on a GitHub Projects board. List the boards with
`gh project list --owner <owner>`, then:

1. **The user named a board:** use it. If no board has that title, create it:
   `gh project create --owner <owner> --title "<name>"`.
2. **A board has the repo's name** (`<repo-name>`): use it.
3. **Otherwise:** show the boards and ask which one to use, or what to name a
   new one. Create a new one as above.
4. Link the board to the repo:
   `gh project link <number> --owner <owner> --repo <owner/repo>`. A board that
   is already linked counts as success.

## 5. Create the issues

1. For each issue, run `gh issue list --state open --search "<2–3 key terms>"`;
   if an open issue already covers it, skip it and name the existing issue in
   the report.
2. Make sure each type label you use exists:
   `gh label create <epic|feature|bug> --force`.
3. Create prerequisites before the issues that depend on them, and an epic
   before its sub-issues.
   - Standalone issue:
     `gh issue create --title "<title>" --body-file <file> --label <type> [--attach <path> ...]`
   - Sub-issue: the same command, plus `--parent <epic-number>`.
4. For every created issue, add it to the board and set its status:
   - `gh project item-add <number> --owner <owner> --url <issue-url>`
   - `gh project item-edit <number> --owner <owner> --url <issue-url> --field Status --value Todo`

If a command fails partway through, stop. Report what was created (with URLs)
and what was not. Do not re-run creation in a way that would duplicate issues.

## 6. Report briefly

The user is probably in the middle of other work. Give one line per issue and
nothing more:

```
#57 bug — Fix pagination skipping the first item on page 2 and later — https://github.com/acme/shop/issues/57 — Personal: Todo
```

Then name any issue whose Open questions section is not `None`; it is not ready
to ship until they are answered.

## Guardrails

- Each issue stands alone: a reader with no access to this session learns the
  what and the why from the issue itself.
- Never invent content. Only an unsettled what or why is an open question; an
  unknown how goes in Notes.
- Default to one standalone issue per item of work. Create an epic only when
  asked for, or when the parts only make sense together.
- Never touch the working tree or the current branch.
- Do not interview the user about the work. The only questions allowed concern
  the board.
- Fill the bundled templates; never retype them. Remove the HTML comments.
- Exactly one type label per issue: `epic`, `feature`, or `bug`. Every issue is
  on a board with Status `Todo`.
- Use the repo's owner for `--owner`. Pass bodies with `--body-file` from a
  temp file outside the working tree.
