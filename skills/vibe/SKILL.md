---
name: vibe
description: |
  MANUAL TRIGGER ONLY: invoke only when user types /vibe.
  Adaptive pipeline: auto-detects project size (lite/full) and adjusts stages.
  Lite mode (small projects): brainstorm → build+design → security → QA → ship (5 stages).
  Full mode (large projects): validate → brainstorm → prep → plan → build → QA → roast → ship → monitor (9 stages).
  Always includes frontend-design and security-review. State tracked in VIBE-STATE.md.
---

# /vibe — Adaptive Build Pipeline

## Overview

You are orchestrating an adaptive pipeline that takes an idea from concept to shipped product. The pipeline auto-detects project complexity and runs either **Lite** (5 stages) or **Full** (9 stages) mode. Both modes always include `frontend-design` and `security-review` — the two skills missing from the original pipeline.

State is tracked in `VIBE-STATE.md` at the project root.

Language: Match the user's language.

## Adaptive Sizing

When `/vibe` is invoked on a **fresh project** (no VIBE-STATE.md), determine the mode BEFORE showing the menu:

### Detection Heuristics

Ask the user: **"Quick vibe or full pipeline?"** Then confirm with these signals:

| Signal | Lite | Full |
|--------|------|------|
| User says "quick", "small", "simple", "just build it" | Yes | — |
| User says "full", "proper", "production", "startup" | — | Yes |
| Single page / single feature | Yes | — |
| Multi-page app, auth, database, API | — | Yes |
| Side project / hackathon / class assignment | Yes | — |
| Startup MVP / portfolio piece / deploy to users | — | Yes |

**Default:** If unclear, default to **Lite**. User can always switch to Full from the menu.

### Lite Mode (5 stages)

| Stage | What | Skills |
|-------|------|--------|
| 1. Brainstorm | Explore idea + design spec | `superpowers:brainstorming` |
| 2. Build + Design | TDD build with production UI | `superpowers:test-driven-development` + `frontend-design:frontend-design` + `superpowers:requesting-code-review` |
| 3. Security | Security scan before shipping | `everything-claude-code:security-review` |
| 4. QA | Browser test + visual polish | `qa` + `design-review` |
| 5. Ship | PR + optional deploy | `ship` + `land-and-deploy` |

### Full Mode (9 stages)

Same as original pipeline BUT with these additions:
- **Stage 3 (Vibe Prep):** After scaffold, invoke `frontend-design:frontend-design` for production-quality UI components
- **Stage 5 (Build):** Each cycle's code review includes security checks via `everything-claude-code:security-review`
- **Stage 6 (QA + Design):** `design-review` cross-references against `frontend-design` output

### Switching Modes

User can type `switch to full` or `switch to lite` at any menu. When switching:
- Completed stages carry over using this mapping:
  | Lite Stage | Full Stage |
  |------------|------------|
  | 1. Brainstorm | 2. Brainstorm |
  | 2. Build + Design | 3. Vibe Prep + 5. Build |
  | 3. Security Review | (embedded in 5. Build) |
  | 4. QA + Polish | 6. QA + Design |
  | 5. Ship | 8. Ship |
- Stages without a mapping start as `pending` (e.g. switching lite→full adds Validate, Plan, Roast, Monitor)
- Update VIBE-STATE.md with new stage table preserving completed statuses
- Show updated menu

## Startup Protocol

When `/vibe` is invoked:

1. **Check for VIBE-STATE.md** in the current working directory.
2. **If it exists:** Read it. Parse the stages table. Identify current stage, status, AND mode (lite/full).
3. **If it does NOT exist:** This is a fresh project. Run Adaptive Sizing (above), then initialize state.
4. **Cross-check artifacts** as backup confirmation:

   **Lite mode artifacts:**
   - `docs/superpowers/specs/*-design.md` → Lite stage 1 (Brainstorm) done
   - Source code + test files exist → Lite stage 2 (Build + Design) done
   - No CRITICAL/HIGH in last security review → Lite stage 3 (Security) done
   - QA report or design review commits → Lite stage 4 (QA) done
   - Merged PR → Lite stage 5 (Ship) done

   **Full mode artifacts:**
   - `VALIDATION-REPORT.md` → Full stage 1 done
   - `docs/superpowers/specs/*-design.md` → Full stage 2 done
   - `docs/PRD.md` → Full stage 3 done
   - `docs/superpowers/plans/*.md` → Full stage 4 done
   - `HARNESS-STATE.md` with COMPLETE or user-stopped → Full stage 5 done
   - QA report or design review commits → Full stage 6 done
   - Roast report PDF → Full stage 7 done
   - Merged PR → Full stage 8 done
   - Canary running → Full stage 9 active

5. **If VIBE-STATE.md disagrees with artifacts**, trust the artifacts and update VIBE-STATE.md.

## Menu

Present the menu matching the current mode:

### Lite Mode Menu
```
/vibe [lite]

Pipeline: <project-name or "New Project">
Status: <current state summary>

  1. Brainstorm       [<status>]
  2. Build + Design   [<status>]
  3. Security Review  [<status>]
  4. QA + Polish      [<status>]
  5. Ship             [<status>]

Status key: [done] [in progress] [pending]

> Enter stage number, "switch to full", or press Enter to <suggested action>:
```

### Full Mode Menu
```
/vibe [full]

Pipeline: <project-name or "New Project">
Status: <current state summary>

  1. Validate        [<status>]
  2. Brainstorm       [<status>]
  3. Vibe Prep        [<status>]
  4. Plan             [<status>]
  5. Build            [<status>]
  6. QA + Design      [<status>]
  7. Roast            [<status>]
  8. Ship             [<status>]
  9. Monitor          [<status>]

Status key: [done] [in progress] [pending]

> Enter stage number, "switch to lite", or press Enter to <suggested action>:
```

**Suggested action logic:**
- If a stage is `in progress`: "continue stage N"
- If all prior stages done and next is pending: "start stage N"
- If fresh project: "start from stage 1"
- User can always type any number to jump to that stage.

**When user selects a stage**, update VIBE-STATE.md to mark it `in_progress`, then execute that stage's process.

## VIBE-STATE.md Management

### Creating (fresh project)

When no VIBE-STATE.md exists, create it at the project root. Use the template matching the chosen mode:

**Lite Mode:**
```markdown
# Vibe Pipeline State

## Project: <ask user for project name>
## Mode: lite
## Started: <today's date>

## Stages
| Stage | Status | Completed | Notes |
|-------|--------|-----------|-------|
| 1. Brainstorm | pending | — | — |
| 2. Build + Design | pending | — | — |
| 3. Security Review | pending | — | — |
| 4. QA + Polish | pending | — | — |
| 5. Ship | pending | — | — |

## Current Stage: —
## Next Suggested: Start stage 1
```

**Full Mode:**
```markdown
# Vibe Pipeline State

## Project: <ask user for project name>
## Mode: full
## Started: <today's date>

## Stages
| Stage | Status | Completed | Notes |
|-------|--------|-----------|-------|
| 1. Validate | pending | — | — |
| 2. Brainstorm | pending | — | — |
| 3. Vibe Prep | pending | — | — |
| 4. Plan | pending | — | — |
| 5. Build | pending | — | — |
| 6. QA + Design | pending | — | — |
| 7. Roast | pending | — | — |
| 8. Ship | pending | — | — |
| 9. Monitor | pending | — | — |

## Roast Loops: 0

## Current Stage: —
## Next Suggested: Start stage 1
```

### Updating

After each stage transition:
1. Read current VIBE-STATE.md
2. Update the relevant row's Status and Completed date
3. Update "Current Stage" and "Next Suggested"
4. If roast loops back to build, increment "Roast Loops" counter
5. Write the updated file

### Stage statuses
- `pending` — not started
- `in_progress` — currently active
- `completed` — finished
- `skipped` — user chose to skip

---

# Lite Mode Stages

These stages apply when mode is `lite`. For `full` mode, skip to the Full Mode Stages section below.

## Lite Stage 1: Brainstorm

**Purpose:** Quick design exploration — no heavy validation, just clarify what to build.

**Skills used:** `superpowers:brainstorming`

### Process

1. **Invoke `superpowers:brainstorming`** using the Skill tool.
   - Explore the idea with the user
   - Ask clarifying questions one at a time
   - Propose 2-3 approaches with trade-offs
   - Write design spec to `docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md`
   - Get user approval

2. **Do NOT let brainstorming auto-transition to writing-plans.** Return to menu.

3. **Update VIBE-STATE.md:** Mark stage 1 as `completed`.

4. **Return to menu** with stage 2 suggested.

## Lite Stage 2: Build + Design

**Purpose:** Build the project with TDD, production-quality UI via frontend-design, and code review per chunk.

**Skills used:** `superpowers:test-driven-development` + `frontend-design:frontend-design` + `superpowers:requesting-code-review`

### Process

1. **Read the design spec** from Lite Stage 1 for context.

2. **Plan the build** mentally (no formal plan doc needed in lite mode). Identify 3-8 implementation chunks from the spec.

3. **For each chunk:**
   a. **RED:** Write a failing test first. Run it. Confirm it fails.
   b. **GREEN:** Write minimal implementation to pass. Run it. Confirm it passes.
   c. **REFACTOR:** Clean up while keeping tests green.
   d. Commit the chunk.

4. **For UI/frontend chunks:** Invoke `frontend-design:frontend-design` using the Skill tool.
   - This generates production-quality, distinctive HTML/CSS — not generic AI slop.
   - Use it for every page/component that the user will see.
   - The skill produces polished, creative designs that avoid the "looks like every other AI-generated site" problem.

5. **After all chunks built:** Dispatch code review via `superpowers:requesting-code-review`.
   - Fix CRITICAL and HIGH issues before moving on.

6. **Update VIBE-STATE.md:** Mark stage 2 as `completed`.

7. **Return to menu** with stage 3 suggested.

## Lite Stage 3: Security Review

**Purpose:** Catch security issues before shipping. Quick but mandatory.

**Skills used:** `everything-claude-code:security-review`

### Process

1. **Invoke `everything-claude-code:security-review`** using the Skill tool.
   This checks:
   - Hardcoded secrets (API keys, passwords, tokens)
   - Input validation gaps
   - SQL injection / XSS / CSRF vulnerabilities
   - Authentication/authorization issues
   - Error messages leaking sensitive data
   - Dependency vulnerabilities

2. **Fix any CRITICAL or HIGH issues immediately.** Commit fixes.

3. **MEDIUM issues:** Fix if quick (<5 min each), otherwise note them for later.

4. **Update VIBE-STATE.md:** Mark stage 3 as `completed`.

5. **Return to menu** with stage 4 suggested.

## Lite Stage 4: QA + Polish

**Purpose:** Browser-based testing and visual polish.

**Skills used:** `qa` + `design-review`

### Process

1. **Start the dev server.** Check `package.json` or project docs for the start command.

2. **Run QA testing.** Invoke `qa` using the Skill tool.
   - Systematically test in headless browser
   - Find and fix bugs with atomic commits
   - Re-verify each fix

3. **Run design review.** Invoke `design-review` using the Skill tool.
   - Find visual inconsistencies, spacing issues, AI slop patterns
   - Fix with atomic commits
   - Before/after screenshots

4. **Update VIBE-STATE.md:** Mark stage 4 as `completed`.

5. **Return to menu** with stage 5 suggested.

## Lite Stage 5: Ship

**Purpose:** Create PR and optionally deploy.

**Skills used:** `ship` + `land-and-deploy`

### Process

1. **Run ship workflow.** Invoke `ship` using the Skill tool.
   - Run tests, review diff, bump VERSION, create PR

2. **Ask user:** "PR created. Deploy? (y/n)"
   - If no: mark completed. Done.
   - If yes: invoke `land-and-deploy`.

3. **Update VIBE-STATE.md:** Mark stage 5 as `completed`.

4. **Pipeline complete.** Show summary:
   ```
   /vibe [lite] complete!

   Project: <name>
   Stages: 5/5
   PR: <url>
   Deploy: <status>
   ```

---

# Full Mode Stages

These stages apply when mode is `full`. They include all original stages PLUS frontend-design and security-review integrations.

## Stage 1: Validate

**Purpose:** Kill bad ideas early by merging YC-style forcing questions with structured validation.

**Skills used:** office-hours + validate-idea

### Process

1. **Check for existing VALIDATION-REPORT.md.**
   - If exists: read it, show summary, ask: "Use this, re-validate, or skip?"
   - If user says use it: mark stage 1 completed, go to menu.
   - If user says re-validate: continue below.

2. **Run office hours forcing questions.**
   Invoke the `office-hours` skill using the Skill tool in startup/builder mode. This covers:
   - Demand reality: who is desperate for this?
   - Status quo: what do they do today?
   - Desperate specificity: what exact moment triggers the need?
   - Narrowest wedge: what's the smallest version that solves it?
   - Observation: what have you seen firsthand?
   - Future-fit: does this get more relevant over time?

3. **Run structured validation.**
   Invoke the `validate-idea` skill using the Skill tool. This covers:
   - Socratic questioning
   - First principles analysis
   - Business model stress test
   - Risk scanner (legal, tech, platform)
   - Multi-role review panel (CEO, engineer, designer, skeptic)

4. **Produce unified VALIDATION-REPORT.md.**
   Combine outputs from both into a single report at the project root.
   Include: GO / PIVOT / NO-GO verdict.

5. **Gate:** If verdict is NO-GO, warn the user strongly. They can override but the warning is on record.

6. **Update VIBE-STATE.md:** Mark stage 1 as `completed`.

7. **Return to menu** with stage 2 suggested.

## Stage 2: Brainstorm

**Purpose:** Turn the validated idea into a design spec with multiple approaches explored.

**Skills used:** superpowers:brainstorming

### Process

1. **Read VALIDATION-REPORT.md** for context on the validated idea.

2. **Invoke `superpowers:brainstorming`** using the Skill tool.
   This will:
   - Explore project context
   - Ask clarifying questions one at a time
   - Propose 2-3 approaches with trade-offs
   - Present design in sections with approval per section
   - Write design doc to `docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md`
   - Run spec self-review
   - Get user approval on written spec

3. **Update VIBE-STATE.md:** Mark stage 2 as `completed`. Add note with spec file path.

4. **Return to menu** with stage 3 suggested.

**Note:** The brainstorming skill normally transitions to writing-plans. In this pipeline, we return to the menu instead so stage 3 (Vibe Prep) runs before stage 4 (Plan). When invoking brainstorming, after the spec is written and approved, do NOT let it invoke writing-plans. Return to the /vibe menu.

## Stage 3: Vibe Prep

**Purpose:** Create PRD, UI design, architecture docs, and scaffold the project.

**Skills used:** vibe-prep (modified flow)

### Process

1. **Invoke `vibe-prep`** using the Skill tool.

2. **IMPORTANT: Skip vibe-prep's Step 1 (Idea Validation).** Tell vibe-prep that validation is already complete by pointing it to the existing `VALIDATION-REPORT.md`. Start from vibe-prep's Step 2 (Tech Stack Selection).

3. Vibe-prep will handle:
   - Tech stack selection (step 2)
   - PRD writing — `docs/PRD.md` (step 3)
   - UI/UX design — `docs/UI-DESIGN.md` (step 4)
   - Architecture — `docs/ARCHITECTURE.md` (step 5)
   - Project scaffold (step 6)
   - Context documents — `CLAUDE.md` (step 7)
   - Development standards — `docs/REFERENCE.md` (step 8)
   - Git init & quality gates — `docs/QUALITY-GATES.md` (step 9)

4. **ADDED: Invoke `frontend-design:frontend-design`** using the Skill tool for the main UI components/pages scaffolded by vibe-prep. This upgrades the generic scaffold into production-quality, distinctive UI. Apply to every user-facing page.

5. **Do NOT follow vibe-prep's handoff to vibe-harness.** Return to the /vibe menu instead.

6. **Update VIBE-STATE.md:** Mark stage 3 as `completed`.

7. **Return to menu** with stage 4 suggested.

## Stage 4: Plan

**Purpose:** Create a detailed, bite-sized implementation plan with TDD steps.

**Skills used:** superpowers:writing-plans

### Process

1. **Invoke `superpowers:writing-plans`** using the Skill tool.
   Provide context:
   - Design spec from stage 2: `docs/superpowers/specs/*-design.md`
   - PRD from stage 3: `docs/PRD.md`
   - Architecture from stage 3: `docs/ARCHITECTURE.md`
   - Quality gates from stage 3: `docs/QUALITY-GATES.md`

2. The writing-plans skill will:
   - Scope check (decompose if needed)
   - Map file structure
   - Define bite-sized tasks with TDD steps
   - Self-review against spec
   - Save to `docs/superpowers/plans/YYYY-MM-DD-<feature>.md`

3. **Do NOT follow writing-plans' execution handoff.** The plan will be consumed by the enhanced vibe-harness in stage 5, not by subagent-driven-development or executing-plans directly.

4. **Update VIBE-STATE.md:** Mark stage 4 as `completed`. Add note with plan file path.

5. **Return to menu** with stage 5 suggested.

## Stage 5: Build (Enhanced Vibe Harness)

**Purpose:** Autonomous 15+ cycle build loop with TDD and code review injected every cycle.

**Skills used:** vibe-harness + superpowers:test-driven-development + superpowers:requesting-code-review + everything-claude-code:security-review

### Process

1. **Invoke `vibe-harness`** using the Skill tool.

2. **CRITICAL ENHANCEMENT: Modify the Generator phase of EVERY cycle.**
   The standard vibe-harness Generator writes code freely. In this pipeline, the Generator MUST follow TDD discipline:

   **Enhanced Generator Phase (per cycle):**
   a. Read the implementation plan from stage 4 to identify the next task/feature.
   b. **RED:** Write a failing test for the feature first. Run it. Confirm it fails.
   c. **GREEN:** Write the minimal implementation to make the test pass. Run it. Confirm it passes.
   d. **REFACTOR:** Clean up while keeping tests green.
   e. Commit the code.

   **Code Review + Security Phase (per cycle, after Generator):**
   f. Dispatch a code-reviewer subagent using `superpowers:requesting-code-review`.
   g. The reviewer checks the cycle's diff for quality and spec compliance.
   h. **ADDED: Run `everything-claude-code:security-review`** on the cycle's diff. Check for hardcoded secrets, injection vulnerabilities, auth issues, and input validation gaps.
   i. If reviewer or security review raises CRITICAL or HIGH issues: Generator fixes them before the Evaluator runs.
   j. If only MEDIUM or LOW issues: note them, proceed to Evaluator.

   **Evaluator Phase:** Unchanged from standard vibe-harness. Scores on 5 dimensions.

3. **All other vibe-harness behavior remains the same:**
   - 15 cycle minimum, COMPLETE banned before cycle 15
   - HARNESS-STATE.md for persistence
   - FEATURES.json tracking
   - Dashboard at localhost:9999
   - Living docs updated per cycle

4. **On harness completion** (COMPLETE verdict, user stop, or kill metric):
   - Update VIBE-STATE.md: Mark stage 5 as `completed`.
   - Return to menu with stage 6 suggested.

## Stage 6: QA + Design Review

**Purpose:** Browser-based QA testing and visual polish of the built MVP.

**Skills used:** qa + design-review

### Process

1. **Start the dev server.** Check `package.json` or project docs for the start command.

2. **Run QA testing.**
   Invoke `qa` using the Skill tool.
   This will:
   - Systematically test the web application in a headless browser
   - Find bugs (broken links, form errors, console errors, responsive issues)
   - Fix bugs iteratively with atomic commits
   - Re-verify each fix with before/after screenshots

3. **Run design review.**
   Invoke `design-review` using the Skill tool.
   This will:
   - Find visual inconsistencies, spacing issues, hierarchy problems
   - Detect AI slop patterns (generic gradients, over-rounded corners, etc.)
   - Fix issues in source code with atomic commits
   - Re-verify with before/after screenshots

4. **Update VIBE-STATE.md:** Mark stage 6 as `completed`.

5. **Return to menu** with stage 7 suggested.

## Stage 7: Roast MVP

**Purpose:** Stress-test with AI personas. Auto-loop back to build if score is low.

**Skills used:** roast-mvp

### Process

1. **Invoke `roast-mvp`** using the Skill tool.
   Default to gauntlet mode (VC gate → community gate).

2. **roast-mvp will:**
   - Run VC panel (5 personas) — must pass to unlock community
   - Run community testing (10-100 personas)
   - Generate PDF report with scores
   - Collect user feedback on critiques
   - Evolve persona gene pool

3. **Auto-loop gate:**
   - **If overall roast score < 6/10:** Automatically return to Stage 5 (Build).
     - Increment "Roast Loops" counter in VIBE-STATE.md.
     - Pass roast feedback as context to the next vibe-harness run.
     - The harness will use the roast critiques to guide its next cycles.
     - Mark stage 7 as `looped_back`, stage 5 as `in_progress`.
   - **If overall roast score >= 6/10:** Proceed.
     - Mark stage 7 as `completed`.

4. **Return to menu** with stage 8 suggested (or stage 5 if looping back).

## Stage 8: Ship

**Purpose:** Create PR and deploy to production.

**Skills used:** ship + land-and-deploy

### Process

1. **Run ship workflow.**
   Invoke `ship` using the Skill tool.
   This will:
   - Detect and merge base branch
   - Run tests
   - Review diff
   - Bump VERSION
   - Update CHANGELOG
   - Commit, push, create PR

2. **Ask user to confirm deploy.**
   Show the PR link. Ask: "PR created. Ready to deploy? (y/n)"
   - If no: mark stage 8 as `completed` (PR created but not deployed). User can deploy later.
   - If yes: continue.

3. **Run deploy workflow.**
   Invoke `land-and-deploy` using the Skill tool.
   This will:
   - Merge the PR
   - Wait for CI and deploy
   - Verify production health via canary checks
   - If deploy platform not configured: invoke `setup-deploy` first.

4. **Update VIBE-STATE.md:** Mark stage 8 as `completed`. Add note with PR URL and deploy status.

5. **Return to menu** with stage 9 suggested.

## Stage 9: Monitor

**Purpose:** Continuous post-deploy health monitoring until manually stopped.

**Skills used:** canary + /loop

### Process

1. **Launch continuous canary monitoring.**
   Invoke `canary` using the Skill tool, wrapped in a `/loop` for continuous execution.

   Use the Skill tool to invoke `loop` with args: `5m canary`

   This will:
   - Run canary checks every 5 minutes
   - Watch for: console errors, performance regressions, page failures
   - Take periodic screenshots compared against pre-deploy baselines
   - Alert on anomalies

2. **Inform the user:**
   > "Canary monitoring is running continuously every 5 minutes. You'll be alerted if any issues are detected. To stop monitoring, use `/loop stop`."

3. **Update VIBE-STATE.md:** Mark stage 9 as `active` (not completed — it runs until stopped).

4. **Pipeline complete.** Show summary:
   ```
   /vibe pipeline complete!
   
   Project: <name>
   Stages completed: 9/9
   Roast loops: <N>
   Final roast score: <score>
   PR: <url>
   Deploy: <status>
   Monitoring: active (stop with /loop stop)
   ```

## Key Principles

1. **Orchestrate, don't reimplement.** This skill invokes existing skills. Do not duplicate their logic. If a skill's behavior needs to change (e.g., vibe-prep skipping validation), instruct the deviation explicitly but let the skill do its job.

2. **VIBE-STATE.md is source of truth.** Always read it before acting. Always update it after acting. If it disagrees with artifacts on disk, trust the artifacts and fix the state file.

3. **Return to menu after every stage.** Never auto-chain stages without showing the menu. The user must always have the option to jump, skip, or stop.

4. **Respect skill boundaries.** When invoking brainstorming, do NOT let it auto-transition to writing-plans. When invoking vibe-prep, do NOT let it auto-transition to vibe-harness. This skill controls the flow.

5. **Roast auto-loop is mandatory.** If roast score < 6, loop back to build. Do not ask. Do not skip. The user can override by jumping to stage 8 from the menu, but the default behavior is to loop.

## Anti-Patterns

1. **Skipping stages without asking.** Always show the menu. Even if artifacts exist, confirm with the user.
2. **Running stages out of order silently.** If a user jumps to stage 5 without a plan (stage 4), warn them.
3. **Ignoring VIBE-STATE.md.** Every stage transition must be reflected in the state file.
4. **Letting sub-skills chain to their default next step.** This skill is the orchestrator. Sub-skills return here.
5. **Losing roast feedback.** When looping from stage 7 back to stage 5, the roast critiques MUST be passed as context to the harness. Otherwise the loop is pointless.
