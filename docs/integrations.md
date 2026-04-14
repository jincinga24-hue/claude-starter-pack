# Integrations: Tools That Work With Claude Code

> Claude Code doesn't live in isolation. Here's how it connects to other tools you probably already use.

## Codex (OpenAI) — Independent Code Review

You can use OpenAI's Codex CLI alongside Claude Code as an **independent reviewer**. Two AI brains are better than one.

### Setup
```bash
npm install -g @openai/codex
```

### Usage via the `/codex` skill (installed with gstack)

**Code Review Mode** — Codex reviews Claude's work:
```
/codex review
```
This runs Codex against your current diff and gives a pass/fail verdict. Great as a second opinion before merging.

**Challenge Mode** — Codex tries to break your code:
```
/codex challenge
```
Adversarial testing — Codex looks for edge cases, security holes, and logic errors.

**Consult Mode** — Ask Codex anything:
```
/codex consult "Is this database schema normalized?"
```

### Why use both?
- Claude builds it, Codex reviews it (or vice versa)
- Different models catch different bugs
- Reduces AI blind spots

---

## Figma — Design to Code

The Figma plugin lets Claude read your Figma designs and implement them with pixel-perfect accuracy.

### Setup
Installed automatically with the starter pack. You'll need to authenticate:
```
You: Connect to my Figma account
```
Claude will walk you through the OAuth flow.

### Key Commands

**Implement a design:**
```
You: Implement this Figma design: [paste Figma URL]
```
Claude reads the Figma file and generates production code matching the design.

**Generate a design FROM code:**
```
You: Push this page to Figma
```
Reverse direction — takes your code and creates Figma components from it.

**Build a design system:**
```
You: Create a Figma design system from our codebase
```
Generates variables, tokens, component library, and theming in Figma.

**Code Connect:**
```
You: Create Code Connect mappings for our Figma components
```
Links Figma components to code snippets so designers and developers stay in sync.

---

## Obsidian — Knowledge Management

Claude Code can read and write Obsidian vault files directly since they're just Markdown. No special plugin needed.

### How to use it

**Point Claude at your vault:**
```
You: Read my notes in ~/Documents/Obsidian/MyVault/Projects/
```

**Generate study notes from lectures:**
```
You: Read this lecture transcript and create Obsidian notes with proper [[wiki links]] and tags
```

**Build a knowledge graph:**
```
You: Read all my notes in the CS101 folder and create a MOC (Map of Content) linking them together
```

### Tips
- Claude understands Obsidian syntax: `[[links]]`, `#tags`, frontmatter, callouts
- Use CLAUDE.md to tell Claude your vault structure and naming conventions
- Claude can create templates, dataview queries, and canvas files

---

## PDF & Document Processing

### Nutrient Document Processing (via everything-claude-code)

Requires a free API key from [nutrient.io](https://nutrient.io).

```bash
export NUTRIENT_API_KEY=your_key_here
```

**What it can do:**
```
You: Convert this PDF to DOCX
You: Extract all tables from this PDF as Excel
You: OCR this scanned document
You: Redact all email addresses and phone numbers from this PDF
You: Add a watermark to every page
You: Fill out this PDF form
```

Supports: PDF, DOCX, XLSX, PPTX, HTML, images (JPG, PNG, TIFF, HEIC, SVG)

### Without Nutrient (built-in)

Claude Code can natively:
- **Read PDFs** — `Read` tool supports `.pdf` files directly (up to 20 pages per request)
- **Read images** — Claude is multimodal, it can see screenshots and photos
- **Read Excel/CSV** — Via the `Read` tool or by running Python/Node scripts

```
You: Read invoice.pdf pages 1-5 and extract the line items into a CSV
You: Look at this screenshot and tell me what's wrong with the layout
```

---

## Web Scraping & Research

### opencli — Turn Any Website Into a CLI (487 commands, 60+ sites)

This is the killer scraping tool. opencli has pre-built adapters for 60+ websites, so you don't need to write scrapers yourself.

**Install:**
```bash
npm install -g @jackwener/opencli
```

**Example commands:**
```bash
# Social media
opencli twitter search "claude code"
opencli reddit hot --subreddit programming
opencli xiaohongshu search "留学"
opencli bilibili hot
opencli weibo hot

# Research
opencli arxiv search "transformer architecture"
opencli hackernews top
opencli stackoverflow search "react hooks"
opencli wikipedia search "machine learning"

# Finance
opencli bloomberg markets
opencli yahoo-finance quote AAPL
opencli barchart options TSLA
opencli xueqiu search "茅台"

# Shopping
opencli jd search "keyboard"
opencli coupang search "laptop"
opencli smzdm hot

# Media
opencli youtube search "claude code tutorial"
opencli apple-podcasts search "tech"
opencli medium search "AI engineering"

# Jobs
opencli linkedin search "software engineer"
opencli boss joblist

# Turn ANY website into a CLI (AI-powered)
opencli explore https://some-website.com    # Discover APIs
opencli generate https://some-website.com   # Generate CLI adapter
```

**Full list of supported sites:**
arxiv, bbc, bilibili, bloomberg, boss (BOSS直聘), chatgpt, coupang, ctrip (携程), cursor, devto, discord, douban, douyin (抖音), facebook, google, grok, hackernews, huggingface, instagram, jd (京东), jike, linkedin, lobsters, medium, notion, pixiv, reddit, reuters, sinablog, sinafinance, smzdm (什么值得买), stackoverflow, steam, substack, tiktok, twitter/X, v2ex, web, weibo, weixin (微信), weread (微信读书), wikipedia, xiaohongshu (小红书), xiaoyuzhou (小宇宙), xueqiu (雪球), yahoo-finance, youtube, zhihu (知乎)

**Use with Claude Code:**
```
You: Run opencli arxiv search "LLM agents" and summarize the top 5 papers
You: Run opencli twitter search "vibe coding" and analyze the sentiment
You: Run opencli xiaohongshu search "墨尔本美食" and list the top recommendations
```

### Built-in Tools

```
You: Search the web for "best React form libraries 2026"
You: Fetch the content from https://example.com/docs
```

Claude has `WebSearch` and `WebFetch` tools built in. These work for general searches but don't access site-specific APIs like opencli does.

### With gstack /browse

```
/browse https://competitor.com
```

Opens a headless browser, navigates pages, takes screenshots, extracts content. More powerful than simple fetch — it renders JavaScript, handles SPAs, and can interact with elements.

### When to use what

| Tool | Best For | Limitations |
|------|----------|------------|
| opencli | Structured data from known sites (tweets, papers, prices) | Only works with supported sites |
| WebSearch | General web searches | No site-specific API access |
| WebFetch | Reading a specific URL | No JavaScript rendering |
| /browse | Interactive sites, SPAs, screenshots | Slower, uses more tokens |
```

---

## Excel / CSV / Data Processing

Claude can process data files using Python or Node:

```
You: Read sales-data.csv, group by month, and create a summary with totals
You: Read this Excel file and find all rows where revenue > $10,000
You: Convert this JSON API response to a formatted CSV
```

For complex data work:
```
You: Write a Python script that reads all .xlsx files in this folder, 
     merges them, removes duplicates by email, and exports a clean CSV
```

---

## Desktop Automation (Stitch / Automation MCP)

If you have the automation MCP server configured, Claude can control your desktop:

```
You: Take a screenshot of my current screen
You: Click the submit button in the browser
You: Type "hello world" in the active text field
```

This is useful for:
- Testing native desktop apps
- Automating repetitive GUI tasks
- Taking screenshots for documentation

### Setup
```json
// In ~/.claude/settings.json under mcpServers
{
  "automation": {
    "command": "bun",
    "args": ["run", "~/.automation-mcp/index.ts", "--stdio"]
  }
}
```

---

## Multica — AI Agents as Teammates (Level Up)

> This is NOT installed by default. It's for when you've outgrown single-agent Claude Code and want to run multiple agents in parallel.

[Multica](https://github.com/multica-ai/multica) (11k stars) is a project board where AI agents show up as teammates. Think Jira/Linear, but some of the assignees are Claude Code, Codex, or OpenClaw agents.

**What it does:**
- Create agent profiles on a shared board
- Assign issues to agents — they pick them up, write code, report progress
- Solutions become reusable skills for the whole team
- Multi-workspace isolation

**Install:**
```bash
brew install multica-ai/tap/multica
multica setup
```

**When to use it:** When you're comfortable with Claude Code and want to:
- Run 3 agents in parallel on different features
- Have one agent review another agent's work
- Build a persistent "AI team" that compounds knowledge over time

**When NOT to use it:** If you're still learning Claude Code basics. Master single-agent first.

---

## Summary: What Connects to What

```
┌─────────────┐     ┌──────────────┐     ┌─────────────┐
│   Figma     │────▶│  Claude Code  │◀────│   Codex     │
│  (design)   │     │   (builds)    │     │  (reviews)  │
└─────────────┘     └──────┬───────┘     └─────────────┘
                           │
              ┌────────────┼────────────┐
              ▼            ▼            ▼
        ┌──────────┐ ┌──────────┐ ┌──────────┐
        │ Obsidian │ │   PDF/   │ │   Web    │
        │ (notes)  │ │  Excel   │ │ (scrape) │
        └──────────┘ └──────────┘ └──────────┘
```

| Integration | How | Setup |
|------------|-----|-------|
| opencli | `opencli twitter search "x"` | Auto-installed (60+ sites) |
| Codex | `/codex review` | `npm i -g @openai/codex` |
| Figma | Figma plugin | Auto-installed, needs auth |
| Obsidian | Direct file read/write | Just point Claude at your vault |
| PDF | Built-in Read tool or Nutrient | Native or `NUTRIENT_API_KEY` |
| Excel/CSV | Python/Node scripts | Native |
| Web scraping | WebSearch, WebFetch, /browse | Native |
| Desktop automation | Automation MCP | MCP server config |
| Multica | `multica setup` | `brew install multica-ai/tap/multica` (advanced) |
