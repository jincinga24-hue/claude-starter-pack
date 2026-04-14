# Claude Starter Pack

![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)
![Claude Code](https://img.shields.io/badge/Claude%20Code-compatible-blue)
![Platform](https://img.shields.io/badge/Platform-macOS%20%7C%20Linux%20%7C%20WSL-lightgrey)

> You just downloaded Claude Code. Now what?

One command installs **7 plugins, 30+ skills, 9 coding rules, and a build pipeline** that takes you from idea to deployed app. Type `/vibe` and start building.

## Prerequisites

You need these before running the installer:

| Requirement | How to get it |
|-------------|--------------|
| **Claude Code** | [Install guide](https://docs.anthropic.com/en/docs/claude-code) — requires an Anthropic account (free tier available, paid for heavy use) |
| **git** | Mac: `xcode-select --install`. Windows: [git-scm.com](https://git-scm.com) |
| **Node.js 18+** | [nodejs.org](https://nodejs.org) (needed for opencli scraping tool) |
| **A terminal** | Mac: Terminal.app or iTerm. Windows: WSL required (PowerShell won't work). VS Code terminal works too. |

## Install

```bash
git clone https://github.com/YOUR_USER/claude-starter-pack.git
cd claude-starter-pack
./install.sh
```

That's it. Open Claude Code and type `/vibe`.

> The script is safe to re-run — it skips anything already installed.

## First 10 Minutes

Just installed? Do this:

1. **Read [Good Habits](docs/good-habits.md)** first — saves you hours of confusion later
2. Open a terminal, `cd` into any folder, type `claude` to start Claude Code
3. Type `/vibe` — pick "quick" — describe what you want to build
4. Claude does the rest. You review and approve.

## Glossary

New to this? Here's what the jargon means:

| Term | What it means |
|------|--------------|
| **Plugin** | A third-party extension that adds capabilities to Claude Code (like browser extensions for Chrome) |
| **Skill** | A slash command you type in Claude Code, like `/vibe` or `/qa` — each one triggers a specific workflow |
| **Rule** | A `.md` file that tells Claude how to write code (style, testing, security). Claude reads these automatically. |
| **MCP** | Model Context Protocol — a way to connect Claude to external tools (Figma, databases, etc.) |
| **TDD** | Test-Driven Development — write a test first, then write the code to pass it. Claude does this for you. |
| **Context window** | How much conversation Claude can "remember" at once. When it fills up, older messages get compressed. |
| **Tokens** | The unit Claude charges by. More conversation = more tokens = more cost. |

## Guides

| Guide | For Who | What You'll Learn |
|-------|---------|-------------------|
| **[Good Habits](docs/good-habits.md)** | Everyone (read first!) | Memory management, CLAUDE.md, auto-accept, git safety, tokens |
| [Engineering Methods](docs/vibe-engineering-methods.md) | Curious builders | 5 approaches to AI coding — when to use each |
| [Integrations](docs/integrations.md) | Power users | Codex, Figma, Obsidian, PDF, Excel, web scraping |

## What Gets Installed

### Plugins (auto-installed)

| Plugin | What It Does |
|--------|-------------|
| superpowers | Brainstorming, implementation plans, TDD, code review, debugging |
| frontend-design | Generates production-quality UI that doesn't look like AI slop |
| everything-claude-code | 80+ skill patterns — security, testing, deployment, API design, etc. |
| [ui-ux-pro-max](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) | 50+ design styles, 161 color palettes, 57 font pairings |
| [claude-hud](https://github.com/jarrodwatts/claude-hud) | Status line showing model, tokens, cost |
| [andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills) | Think before coding, simplicity first, surgical changes |

### Skills (auto-installed)

| Skill | Command | What It Does |
|-------|---------|-------------|
| **gstack** | `/qa`, `/ship`, `/browse`, `/design-review` | Browser QA, shipping, deploy, visual polish |
| **/vibe** | `/vibe` | Adaptive pipeline — asks "quick or full?" then runs 5 or 9 stages |
| **/vibe-harness** | `/vibe-harness` | Autonomous 15-cycle build loop |
| **/roast-mvp** | `/roast-mvp` | AI personas stress-test your app |
| **/validate-idea** | `/validate-idea` | Kill bad ideas before you build them |

### Coding Rules (auto-installed)

> These are instructions for Claude, not for you. Claude reads them automatically and follows them when writing code. You don't need to memorize or understand them.

Pre-configured rules for: git workflow, testing, security checks, coding style, error handling, performance, and common patterns.

### CLI Tools

| Tool | Install | What It Does |
|------|---------|-------------|
| [opencli](https://github.com/jackwener/opencli) | Auto | Scrape 60+ sites: Twitter, Reddit, arXiv, Bloomberg, 小红书, B站, YouTube, LinkedIn, and more. 487 commands. |
| [openclaw](https://github.com/openclaw) | Optional | Persistent AI agents — study buddy, gym tracker, personal assistant |

## The /vibe Pipeline

The main feature. Type `/vibe` and it asks: **"Quick vibe or full pipeline?"**

### Lite Mode (small projects, side projects, hackathons)

```
1. Brainstorm       → Explore the idea, write a design spec
2. Build + Design   → TDD code + production UI via frontend-design
3. Security Review  → Catch vulnerabilities before shipping
4. QA + Polish      → Browser testing + visual polish
5. Ship             → Create PR + optional deploy
```

### Full Mode (startups, portfolio pieces, production apps)

```
1. Validate         → YC-style forcing questions + risk analysis
2. Brainstorm       → Design spec with multiple approaches
3. Vibe Prep        → PRD, architecture, scaffold + frontend-design
4. Plan             → Bite-sized implementation plan with TDD steps
5. Build            → 15+ autonomous cycles with code review + security per cycle
6. QA + Design      → Browser testing + AI slop detection
7. Roast            → AI personas roast your MVP (auto-loops if score < 6/10)
8. Ship             → PR, deploy, version bump
9. Monitor          → Continuous canary health checks
```

You can switch between modes anytime. Completed stages carry over.

## AI Engineering Methods — A Beginner's Guide

Not sure what approach to use? Here's the cheat sheet:

| Method | What | When | This Pack's Tool |
|--------|------|------|-----------------|
| **Agentic** | Just talk to Claude, it figures it out | Bug fixes, small features | Claude Code (default) |
| **Harness** | 15+ autonomous generate/evaluate cycles | Greenfield apps, hands-off builds | `/vibe-harness` |
| **Loop** | Continuous check → act → check cycle | Monitoring, PR babysitting, DevOps | `/loop` |
| **BMAD/Persona** | Different AI personas per phase (PM, dev, QA) | Larger projects, team simulation | `/vibe` full mode |
| **Spec-Driven** | Write spec first, then implement to spec | Planned features, correctness matters | `/brainstorm` → `/plan` |

Read the full guide: **[docs/vibe-engineering-methods.md](docs/vibe-engineering-methods.md)**

```
Quick fix?          → Just talk to Claude (agentic)
Small app?          → /vibe → "quick" (lite mode)
Serious project?    → /vibe → "full" (spec-driven + harness)
Need monitoring?    → /loop 5m /canary (continuous loop)
Just exploring?     → /validate-idea or /brainstorm
```

## File Structure

```
claude-starter-pack/
├── install.sh                          # One-command installer
├── README.md                           # You are here
├── docs/
│   ├── good-habits.md                  # Context management, auto-accept, beginner tips
│   ├── vibe-engineering-methods.md     # AI engineering approaches explained
│   └── integrations.md                # Codex, Figma, Obsidian, PDF, scraping
├── skills/
│   ├── vibe/SKILL.md                   # Adaptive /vibe pipeline
│   ├── vibe-prep/SKILL.md              # Project scaffolding
│   ├── vibe-harness/                   # Autonomous build loop + dashboard
│   ├── roast-mvp/SKILL.md              # AI persona stress testing
│   └── validate-idea/SKILL.md          # Idea validation framework
└── rules/
    ├── coding-style.md                 # Immutability, small files, naming
    ├── git-workflow.md                 # Conventional commits, PR process
    ├── testing.md                      # 80%+ coverage, TDD workflow
    ├── security.md                     # OWASP checks, secret management
    ├── performance.md                  # Model selection, context management
    ├── patterns.md                     # Repository pattern, API responses
    ├── development-workflow.md         # Research → plan → TDD → review → commit
    ├── hooks.md                        # Pre/post tool hooks
    └── agents.md                       # Agent orchestration guide
```

## Uninstall

```bash
# Remove vibe skills
rm -rf ~/.claude/skills/{vibe,vibe-prep,vibe-harness,roast-mvp,validate-idea}

# Remove gstack
rm -rf ~/.claude/skills/gstack
# Remove gstack symlinks (only those pointing to gstack/)
cd ~/.claude/skills && find . -maxdepth 1 -type l -lname 'gstack/*' -exec rm {} \;

# Plugins — remove via Claude Code
claude plugin remove superpowers@claude-plugins-official
claude plugin remove frontend-design@claude-plugins-official
claude plugin remove everything-claude-code@everything-claude-code
claude plugin remove ui-ux-pro-max@ui-ux-pro-max-skill
claude plugin remove claude-hud@claude-hud
```

## Credits

- [superpowers](https://github.com/anthropics/claude-code-plugins) by Anthropic
- [frontend-design](https://github.com/anthropics/claude-code-plugins) by Anthropic
- [everything-claude-code](https://github.com/anthropics/everything-claude-code) by the ECC community
- [gstack](https://github.com/garrytan/gstack) by Garry Tan
- [ui-ux-pro-max](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) by nextlevelbuilder
- [claude-hud](https://github.com/jarrodwatts/claude-hud) by Jarrod Watts
- [openclaw](https://github.com/openclaw) & [opencli](https://github.com/jackwener/opencli) by their respective authors
- /vibe adaptive pipeline by Henry

## License

MIT
