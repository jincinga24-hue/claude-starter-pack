# Good Habits: Things I Wish I Knew Before Using Claude Code

> This guide will save you hours of frustration. Read it before you start building.

## 1. Memory & Context Management (上下文管理)

This is the #1 thing beginners get wrong. Claude Code has a **context window** — it can only "see" a limited amount of conversation history. When the window fills up, older messages get compressed or dropped. This means:

- Claude forgets what you discussed 30 minutes ago
- Claude loses track of complex multi-file changes
- Claude might redo work it already did

### How to manage it:

**Use CLAUDE.md as your project brain.** This file lives at your project root and is loaded into EVERY conversation automatically. Put important decisions, architecture notes, and current status here.

```markdown
# CLAUDE.md

## Project: My Todo App
## Stack: Next.js + Supabase + Tailwind

## Architecture Decisions
- Using server components for data fetching
- Auth via Supabase magic links, no passwords
- All API routes in /app/api/

## Current Status
- Auth: done
- Todo CRUD: done
- Sharing: in progress (see docs/sharing-plan.md)

## Known Issues
- Mobile nav doesn't close on route change
```

**Use a PROGRESS.md for long tasks.** When building something big, maintain a progress file:

```markdown
# Progress

## Phase 1: Auth [DONE]
- [x] Supabase setup
- [x] Login page
- [x] Protected routes

## Phase 2: Core Features [IN PROGRESS]
- [x] Create todo
- [x] Edit todo
- [ ] Delete todo       ← Claude, start here
- [ ] Drag to reorder

## Phase 3: Sharing [NOT STARTED]
- [ ] Share link generation
- [ ] Permission levels
```

When you start a new session, just say: "Read PROGRESS.md and continue where we left off."

**Start new terminal sessions for new tasks.** Don't keep one conversation running for hours. Claude works best with focused sessions:

```
Session 1: "Build the auth system" → done → close
Session 2: "Build the todo CRUD" → done → close  
Session 3: "Fix the mobile nav bug" → done → close
```

Each session starts fresh with full context window. CLAUDE.md and PROGRESS.md carry the state between sessions.

**Use `/compact` when context gets long.** If you've been in one session too long, type `/compact` — Claude will summarize the conversation and free up context space.

---

## 2. Don't Build in One Giant Session

Bad:
```
You: Build me a full e-commerce site with auth, products, cart, checkout, payments, admin dashboard
Claude: *tries to do everything* → *loses context halfway* → *breaks earlier work*
```

Good:
```
Session 1: "Set up the project scaffold and auth"
Session 2: "Build the product listing page"  
Session 3: "Build the cart system"
Session 4: "Add Stripe checkout"
Session 5: "Build admin dashboard"
```

**Rule of thumb:** One feature per session. If a feature takes more than 20 back-and-forth messages, it's probably too big for one session.

---

## 3. The CLAUDE.md File Is Your Best Friend

Every project should have a `CLAUDE.md` at the root. Claude reads it automatically at the start of every conversation. Put in it:

- **What the project is** (1-2 sentences)
- **Tech stack** (so Claude doesn't guess wrong)
- **File structure conventions** (where components go, where API routes go)
- **Rules** ("don't use CSS modules, use Tailwind", "always use TypeScript")
- **Current status** (what's done, what's in progress)

This is NOT documentation for humans. It's instructions for Claude. Be direct:

```markdown
# CLAUDE.md

This is a Next.js 14 app with App Router, Supabase, and Tailwind CSS.

## Rules
- Always use TypeScript, never JavaScript
- Components go in src/components/<feature>/
- Server actions go in src/actions/
- Use Supabase client from src/lib/supabase.ts, don't create new clients
- Run `npm run lint` before committing

## Do NOT
- Don't install new dependencies without asking
- Don't modify the auth system, it's working
- Don't use `any` type
```

---

## 4. Auto-Accept Mode (Stop Pressing Yes)

By default, Claude asks permission for every file edit and command. For trusted projects, you can auto-accept:

**Option A: Accept edits only (recommended for beginners)**
- Press `Shift+Tab` in Claude Code to cycle permission modes
- Or set in `~/.claude/settings.json`:
```json
{
  "permissions": {
    "defaultMode": "acceptEdits"
  }
}
```

**Option B: Full auto-accept (for experienced users)**
```json
{
  "permissions": {
    "defaultMode": "auto"
  }
}
```

**Option C: Allow specific tools**
```json
{
  "permissions": {
    "allow": ["Read", "Glob", "Grep", "Write", "Edit", "Bash(npm run *)"]
  }
}
```

**Never use `--dangerously-skip-permissions` unless you know exactly what you're doing.** It bypasses ALL safety checks.

---

## 5. Git Is Your Safety Net

Before starting ANY big change:
```
You: Create a new branch called feat/auth before we start
```

If Claude messes something up:
```bash
git diff              # See what changed
git checkout -- .     # Undo everything
git stash             # Save changes for later
```

**Commit after each working feature**, not at the end. Small commits = easy rollbacks.

---

## 6. Read Before You Write

Before asking Claude to modify a file:
```
Bad:  "Add a login button to the header"
Good: "Read src/components/Header.tsx, then add a login button"
```

Claude makes better edits when it reads the file first. This seems obvious but beginners often forget.

---

## 7. Be Specific About What You Want

```
Bad:  "Make it look better"
Good: "Add 16px padding, change the background to #f5f5f5, and make the title 24px bold"

Bad:  "Fix the bug"  
Good: "When I click submit with an empty form, it should show a validation error but instead it crashes. Check src/components/Form.tsx"

Bad:  "Build a dashboard"
Good: "Build a dashboard with 3 cards showing: total users, active sessions, revenue this month. Use data from /api/stats endpoint."
```

---

## 8. Use Plan Mode for Complex Tasks

Before building something complex, enter plan mode:
```
You: /plan
You: I want to add real-time notifications. Users should get notified when someone shares a todo with them.
```

Claude will create a plan WITHOUT writing code. Review the plan, adjust it, THEN execute. This prevents Claude from going down the wrong path.

---

## 9. Check the Dev Server

If you're building a web app, **always start the dev server** and check the browser:
```
You: Start the dev server and open the app. Click through the main flow and tell me if anything is broken.
```

Claude can use `/browse` or `/qa` to actually test your app in a headless browser. Type-checking passes don't mean the feature works.

---

## 10. The Token Budget Reality

Claude Code uses tokens (API credits). Some operations are expensive:

| Action | Token Cost |
|--------|-----------|
| Reading a small file | Low |
| Reading a 1000-line file | Medium |
| Writing code | Medium |
| Running tests | Low (command), Medium (reading output) |
| `/vibe` full pipeline | High (many stages) |
| `/vibe-harness` 15 cycles | Very High |
| Long conversation (50+ messages) | High (context re-reads) |

**Save tokens by:**
- Starting fresh sessions for new tasks (avoids re-reading old context)
- Using `/vibe` lite mode for small projects
- Being specific (less back-and-forth = fewer tokens)
- Using `haiku` model for simple tasks: `/model haiku`

---

## Quick Reference

| Situation | What To Do |
|-----------|-----------|
| Starting a new project | Create CLAUDE.md first |
| Long task, multiple sessions | Use PROGRESS.md |
| Context getting long | `/compact` or start new session |
| Before big changes | Create a git branch |
| Tired of pressing yes | Set auto-accept in settings |
| Claude forgot something | Check if it's in CLAUDE.md |
| Something broke | `git diff` then `git checkout -- .` |
| Want to test the UI | `/qa` or `/browse` |
| Complex feature | `/plan` first, then build |
| Quick fix | Just talk to Claude directly |
