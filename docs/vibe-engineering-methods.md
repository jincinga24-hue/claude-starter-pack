# Vibe Engineering Methods: A Guide for Beginners

> You just downloaded Claude Code. People online are talking about "agentic engineering", "harness loops", and "spec-driven development". What do they actually mean, and which one should you use?

> **First time using Claude Code?** You don't need to read this yet. Just type `/vibe`, pick "quick", and build something. Come back here when you're curious about the different approaches.

## The 5 Approaches

### 1. Agentic Engineering

**What it is:** You treat Claude as a junior developer. You give it a task, it figures out the approach, writes code, runs tests, and iterates. You review and steer.

**How it works:**
```
You: "Build me a todo app with auth"
Claude: *reads codebase* → *plans* → *writes code* → *runs tests* → *fixes errors* → *commits*
```

**When to use it:** Day-to-day coding. Bug fixes. Adding features. Refactoring. This is the default — just talk to Claude and let it work.

**Tools:** Claude Code out of the box. No special setup needed.

**Pros:** Simple. Fast. Low overhead.
**Cons:** No quality gates. Claude might build the wrong thing if the task is ambiguous. Works great for small-medium tasks, gets messy for large ones.

---

### 2. Harness Engineering (Vibe Harness)

**What it is:** An autonomous loop where Claude generates code in cycles, and an evaluator scores each cycle. It runs 15+ cycles without you touching anything. Think of it as putting Claude in a gym — it reps until the code is good.

**How it works:**
```
Cycle 1:  Generator writes code → Evaluator scores (3/10) → "needs routing, no tests"
Cycle 2:  Generator fixes → Evaluator scores (5/10) → "routing works, UI rough"
Cycle 3:  Generator polishes → Evaluator scores (7/10) → "looking good, edge cases missing"
...
Cycle 15: Evaluator scores (9/10) → COMPLETE
```

**When to use it:** When you want to go make dinner and come back to a working app. Best for brand-new projects (starting from scratch) where you have a clear spec.

**Tools:** `/vibe-harness` (included in this starter pack)

**Pros:** Hands-off. Self-correcting. Produces surprisingly complete results.
**Cons:** Burns tokens. Can go in circles if the spec is vague. 15 cycles minimum means it takes time.

---

### 3. Ralph Wiggum Loop (Continuous Agent Loop)

**What it is:** Named after the meme, not the Simpsons character (well, kind of). It's a pattern where Claude runs in a continuous loop — checking status, taking action, checking again. Unlike the harness which has generate/evaluate phases, this is a single agent that just keeps going.

**How it works:**
```
Loop: Check state → Decide action → Execute → Check state → Decide → Execute → ...
```

**Real examples:**
- PR babysitter: checks CI status every 5 min, fixes failures, re-pushes
- Deploy watcher: monitors canary metrics, rolls back if errors spike
- Code reviewer: watches for new PRs, reviews them automatically

**When to use it:** Ongoing tasks that need monitoring and reaction. Not for building — for maintaining.

**Tools:** `/loop` command in Claude Code

**Pros:** Set-and-forget automation. Great for DevOps-style tasks.
**Cons:** Runs up your token bill if the interval is too short. Not suitable for creative work.

---

### 4. BMAD Method — Breakthrough Method for Agentic Development (Spec-Driven with Personas)

**What it is:** A structured approach where different AI "personas" handle different phases. A Product Manager writes the PRD, a Tech Lead designs the architecture, a Developer implements, a QA Engineer tests. Each persona has specific expertise and constraints.

**How it works:**
```
Phase 1: PM Persona → writes PRD with user stories
Phase 2: Architect Persona → designs system, picks tech stack
Phase 3: Developer Persona → implements with TDD
Phase 4: QA Persona → tests and files bugs
Phase 5: DevOps Persona → deploys and monitors
```

**When to use it:** Larger projects where you want structured thinking from multiple angles. Startup MVPs where you want the "full team" experience.

**Tools:** Custom persona prompts or multi-agent orchestration. Our `/vibe` full mode is inspired by this — validate, brainstorm, prep, plan, build, QA, roast, ship, monitor.

**Pros:** Forces thoroughness. Catches issues that a single perspective misses. Great for learning how real teams work.
**Cons:** Heavyweight. Lots of context switching. Overkill for small tasks.

---

### 5. Spec-Driven Development (SDD)

**What it is:** You write a detailed specification FIRST, get it reviewed and approved, THEN hand it to Claude for implementation. The spec is the source of truth. Claude follows the spec, not its own judgment.

**How it works:**
```
Step 1: Write spec (PRD, design doc, architecture doc)
Step 2: Review spec (CEO review, eng review, design review)
Step 3: Create implementation plan from spec
Step 4: Execute plan task-by-task with TDD
Step 5: Verify output matches spec
```

**When to use it:** When correctness matters more than speed. When multiple people need to agree on what to build. When you want to review the plan before burning tokens on implementation.

**Tools:** `/brainstorm` → `/plan` → `/execute` (superpowers plugin)

**Pros:** Predictable output. Clear acceptance criteria. Easy to course-correct before wasting time building the wrong thing.
**Cons:** Slow to start. Spec can become stale if requirements change. Feels bureaucratic for small tasks.

---

## Which One Should I Use?

```
                    ┌─────────────────┐
                    │ What are you     │
                    │ building?        │
                    └────────┬────────┘
                             │
              ┌──────────────┼──────────────┐
              ▼              ▼              ▼
         Quick fix      Small app      Big project
         or feature     or tool        or startup
              │              │              │
              ▼              ▼              ▼
         Agentic        /vibe lite     /vibe full
         (just talk     (5 stages)     (9 stages,
          to Claude)                    spec-driven)
              
         ─────────────────────────────────────────
         
         Need it to     Need ongoing
         run on its     monitoring?
         own?                │
              │              ▼
              ▼         Ralph Wiggum
         Vibe Harness   Loop (/loop)
         (/vibe-harness)
```

## The TL;DR

| Method | Speed | Quality | Effort | Best For |
|--------|-------|---------|--------|----------|
| Agentic | Fast | Medium | Low | Daily coding |
| Harness | Slow (auto) | High | Low | New projects from scratch |
| Ralph Loop | Continuous | N/A | Low | Monitoring, DevOps |
| BMAD | Slow | Very High | High | Team simulation |
| Spec-Driven | Medium | High | Medium | Planned features |

## How This Starter Pack Maps to Methods

| Installed Tool | Method | Command |
|---------------|--------|---------|
| Claude Code (default) | Agentic | Just talk |
| superpowers | Spec-Driven | `/brainstorm`, `/plan` |
| /vibe lite | Agentic + Quality Gates | `/vibe` → "quick" |
| /vibe full | BMAD-inspired | `/vibe` → "full" |
| /vibe-harness | Harness Engineering | `/vibe-harness` |
| /loop | Ralph Wiggum Loop | `/loop 5m /some-command` |
| gstack (QA, ship) | Quality Gates | `/qa`, `/ship` |

You don't have to pick one. Most people use **agentic for small stuff** and **escalate to /vibe when it matters**.
