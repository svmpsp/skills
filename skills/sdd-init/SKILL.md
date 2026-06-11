---
name: sdd-init
description: Initialize Spec-Driven Development (SDD) in the current repository. Creates a specs/ directory containing a content map of the repo and Architecture Decision Records (ADRs), and ensures an AGENTS.md exists with a CLAUDE.md symlink pointing to it. Use when the user runs /sdd-init or asks to bootstrap spec-driven development, set up a specs directory, create a repo content map, or scaffold ADRs.
---

# sdd-init

Bootstrap Spec-Driven Development (SDD) scaffolding in the current repository. This is the entry point of the SDD workflow; later skills (e.g. `sdd-make`) build on the artifacts created here.

## What "done" looks like

After this skill runs, the repository contains:

```
specs/
├── README.md            # Explains the SDD layout and how to maintain it
├── content-map.md       # A navigable map of the repository
└── adr/
    ├── README.md        # ADR index + how to add a new ADR
    ├── template.md      # ADR template for future decisions
    ├── 0001-record-architecture-decisions.md
    ├── 0002-dev-tools-and-testing.md
    └── 0003-ci-and-release-workflow.md
AGENTS.md                # Thin pointer to specs/ (not a duplicate of it)
CLAUDE.md -> AGENTS.md   # Symlink (not a copy)
```

## Procedure

Work through these steps in order. Do not skip the inspection step — the generated artifacts must reflect the *actual* repository, not a generic template.

### 1. Confirm context and inspect the repo

1. Verify you are at the root of the intended repository (look for `.git`, a manifest like `package.json`/`pyproject.toml`/`go.mod`/`Cargo.toml`, or ask the user if ambiguous).
2. Build an accurate picture of the repo before writing anything:
   - Top-level directories and their purpose.
   - Primary language(s), build system, and entry points.
   - How the code is organized (services, packages, modules, apps).
   - Existing docs (`README.md`, `docs/`, existing `AGENTS.md`/`CLAUDE.md`).
   - Test layout and how tests are run.
3. If a `specs/` directory already exists, do **not** clobber it. Report what is present and offer to update or extend it instead of overwriting.

### 2. Create `specs/content-map.md`

A content map is a high-signal index that lets a human or agent navigate the repo quickly. Generate it from your actual inspection. Include:

- A one-paragraph description of what the project does.
- A table or annotated tree of top-level directories with a one-line purpose each.
- Key entry points (main files, CLI commands, server bootstrap) with `path:line` references where useful.
- Where tests live and the command to run them.
- Where configuration and environment setup live.
- Pointers to deeper docs (including `specs/adr/`).

Keep it concise and maintainable — it is an index, not a duplicate of the code. Note at the top that it should be updated as the repo evolves.

### 3. Create the ADR structure under `specs/adr/`

ADRs (Architecture Decision Records) capture *why* significant decisions were made.

1. Write `specs/adr/template.md` by copying this skill's bundled template
   verbatim from `${CLAUDE_SKILL_DIR}/assets/template.md`. Read that file and
   copy it; do not retype it from memory, so every repo gets the same canonical
   template.
2. Write the three seed ADRs, each grounded in what you observed during inspection (do not invent decisions the repo does not reflect; where a decision is genuinely undecided, record it as `Proposed` and note the open question):
   - **`0001-record-architecture-decisions.md`** — records the decision to use ADRs (status: Accepted). Fill in real context from this repo.
   - **`0002-dev-tools-and-testing.md`** — records the development tooling and testing approach: language/runtime versions, package/dependency manager, formatter and linter, the test framework, how tests are organized, and the commands to run lint/format/tests. Pull these from the manifest, config files, and CI you found during inspection.
   - **`0003-ci-and-release-workflow.md`** — records the continuous integration and release approach: CI provider and pipeline stages (build/test/lint), branch and merge policy, versioning scheme, how artifacts are published or deployed, and how releases are cut/tagged. Base this on existing CI config (e.g. `.github/workflows/`, `.gitlab-ci.yml`) and release tooling; where nothing exists yet, record the recommended approach as `Proposed`.
3. Write `specs/adr/README.md` explaining: what an ADR is, the numbering convention (`NNNN-kebab-title.md`, monotonically increasing), the lifecycle statuses (Proposed → Accepted → Deprecated/Superseded), and an index list of existing ADRs (0001–0003 plus any others).
4. If you identified further clear, already-made architectural decisions during inspection (framework choice, monorepo vs polyrepo, datastore, etc.), offer to capture them as additional ADRs (0004+) — but only with the user's go-ahead, and only when the rationale is genuinely known rather than guessed.

### 4. Write `specs/README.md`

Explain the SDD layout: what `content-map.md` is for, what `adr/` is for, how the two relate, and the expectation that these are kept in sync with the code. Mention that this directory was bootstrapped by `sdd-init` and is consumed by downstream SDD skills.

### 5. Ensure `AGENTS.md` exists with a `CLAUDE.md` symlink

   `AGENTS.md`/`CLAUDE.md` is loaded into context on every session, so keep it **as thin as possible**: it should orient the reader and point at `specs/` as the source of truth, **not** restate the project overview, commands, or conventions that the content map and ADRs already record. Anything more than orientation belongs in `specs/`, not here (see the ADR you wrote on this if the repo has one).

1. Check for `AGENTS.md` at the repo root.
   - If it does not exist, create a minimal `AGENTS.md` — a few lines stating that the repo practices SDD and that `specs/content-map.md` (what/how) and `specs/adr/` (why) are the source of truth to read first and keep in sync. Do not duplicate their contents. For example:

     ```markdown
     # AGENTS.md

     This repository practices **Spec-Driven Development (SDD)**: its `specs/`
     directory is the single source of truth for what this project is, how it is
     built, and why it is structured the way it is. Read it before planning or
     changing anything, and keep it in sync when you do.

     - `specs/content-map.md` — what the project is, its layout, and how to
       build/install/test it.
     - `specs/adr/` — the decisions behind the structure (the *why*).

     Keep this file minimal: anything that belongs in the content map or an ADR
     lives there, not here.
     ```
   - If it already exists, leave the user's content intact, but check whether it duplicates what `specs/` now records (overview, build/test commands, conventions). If it does, point that out: recommend slimming it to a thin pointer and migrating the substantive content into `content-map.md` or an ADR so there is a single source of truth. Make the change only with the user's go-ahead; at minimum, ensure it links to `specs/content-map.md` and `specs/adr/`.
2. Ensure `CLAUDE.md` is a **symlink** to `AGENTS.md` (not a copy):
   - If `CLAUDE.md` does not exist: create the symlink — `ln -s AGENTS.md CLAUDE.md`.
   - If `CLAUDE.md` exists as a symlink already pointing to `AGENTS.md`: leave it.
   - If `CLAUDE.md` exists as a **regular file**: do not silently overwrite. Show its contents, explain that SDD expects `CLAUDE.md` to be a symlink to `AGENTS.md`, and ask the user how to proceed (e.g. merge its content into `AGENTS.md`, then replace with a symlink).
3. Verify the link resolves: `readlink CLAUDE.md` should print `AGENTS.md` and `cat CLAUDE.md` should show the `AGENTS.md` content.

### 6. Report

Summarize what was created or changed, list the new files, and confirm the `CLAUDE.md -> AGENTS.md` symlink resolves. Suggest the natural next step (e.g. running `sdd-make` to author a spec).

## Guardrails

- Never overwrite existing user content (`specs/`, `AGENTS.md`, a real `CLAUDE.md` file) without confirmation.
- Keep `AGENTS.md` minimal — a thin pointer to `specs/`, never a second copy of the overview, commands, or conventions that the content map and ADRs hold. `specs/` is the single source of truth.
- Generated content must be grounded in the real repository — inspect first, write second.
- Prefer creating a symlink over copying for `CLAUDE.md`; if the filesystem cannot create symlinks, surface that to the user rather than falling back to a copy silently.
