#!/bin/bash
set -euo pipefail

# Claude Starter Pack Installer
# Install: git clone https://github.com/jincinga24-hue/claude-starter-pack.git && cd claude-starter-pack && ./install.sh
# Safe to re-run — skips anything already installed.

SKILLS_DIR="$HOME/.claude/skills"
RULES_DIR="$HOME/.claude/rules/common"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

ok()   { echo -e "  ${GREEN}✓${NC} $1"; }
warn() { echo -e "  ${YELLOW}!${NC} $1"; }
fail() { echo -e "  ${RED}✗${NC} $1"; }
step() { echo -e "\n${CYAN}${BOLD}$1${NC}"; }

cat << 'BANNER'

   ██████╗██╗      █████╗ ██╗   ██╗██████╗ ███████╗
  ██╔════╝██║     ██╔══██╗██║   ██║██╔══██╗██╔════╝
  ██║     ██║     ███████║██║   ██║██║  ██║█████╗
  ██║     ██║     ██╔══██║██║   ██║██║  ██║██╔══╝
  ╚██████╗███████╗██║  ██║╚██████╔╝██████╔╝███████╗
   ╚═════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚══════╝
              S T A R T E R   P A C K

BANNER

echo -e "  Everything you need to vibe code like a pro."
echo -e "  Plugins + Skills + Rules + /vibe pipeline"
echo ""

# ─── Preflight ─────────────────────────────────────────────────────

step "Preflight checks..."

command -v claude >/dev/null 2>&1 || { fail "Claude Code not found. Get it: https://docs.anthropic.com/en/docs/claude-code"; exit 1; }
ok "Claude Code CLI"

command -v git >/dev/null 2>&1 || { fail "git not found"; exit 1; }
ok "git"

command -v node >/dev/null 2>&1 || warn "node not found — some plugins may need it"
command -v npm >/dev/null 2>&1 || warn "npm not found — needed for openclaw"

mkdir -p "$SKILLS_DIR" "$RULES_DIR"

ERRORS=0

# ─── Step 1: Plugins ──────────────────────────────────────────────

step "Step 1/5: Installing Claude Code plugins..."

add_marketplace() {
    local name="$1"
    local repo="$2"

    if [ -d "$HOME/.claude/plugins/marketplaces/$name" ]; then
        return 0
    fi

    claude plugin marketplace add "$repo" 2>/dev/null || true
}

install_plugin() {
    local display_name="$1"
    local plugin_id="$2"

    if [ -f "$HOME/.claude/plugins/installed_plugins.json" ]; then
        if grep -q "\"$plugin_id\"" "$HOME/.claude/plugins/installed_plugins.json" 2>/dev/null; then
            ok "$display_name (already installed)"
            return 0
        fi
    fi

    warn "Installing $display_name..."
    if claude plugin install "$plugin_id" 2>/dev/null; then
        ok "$display_name"
    else
        fail "$display_name — run manually: claude plugin install $plugin_id"
        ((ERRORS++)) || true
    fi
}

# Register third-party marketplaces first (superpowers + frontend-design are in the default marketplace)
warn "Registering plugin marketplaces..."
add_marketplace "everything-claude-code" "affaan-m/everything-claude-code"
add_marketplace "claude-hud" "jarrodwatts/claude-hud"
add_marketplace "ui-ux-pro-max-skill" "nextlevelbuilder/ui-ux-pro-max-skill"
add_marketplace "andrej-karpathy-skills" "forrestchang/andrej-karpathy-skills"
ok "Marketplaces registered"

# Now install plugins
install_plugin "superpowers (brainstorm, plan, TDD, code review)" \
    "superpowers@claude-plugins-official"

install_plugin "frontend-design (production-quality UI)" \
    "frontend-design@claude-plugins-official"

install_plugin "everything-claude-code (80+ patterns)" \
    "everything-claude-code@everything-claude-code"

install_plugin "ui-ux-pro-max (50+ design styles, 161 palettes)" \
    "ui-ux-pro-max@ui-ux-pro-max-skill"

install_plugin "claude-hud (status line dashboard)" \
    "claude-hud@claude-hud"

install_plugin "andrej-karpathy-skills (think before coding, simplicity)" \
    "andrej-karpathy-skills@andrej-karpathy-skills"

# ─── Step 2: gstack ───────────────────────────────────────────────

step "Step 2/5: Installing gstack (browser QA, ship, deploy)..."

if [ -d "$SKILLS_DIR/gstack/.git" ]; then
    ok "gstack repo exists, updating..."
    (cd "$SKILLS_DIR/gstack" && git pull --quiet 2>/dev/null) || warn "gstack pull failed, using existing"
else
    warn "Cloning gstack..."
    if git clone --quiet https://github.com/garrytan/gstack.git "$SKILLS_DIR/gstack" 2>/dev/null; then
        ok "gstack cloned"
    else
        fail "gstack clone failed — install manually: git clone https://github.com/garrytan/gstack.git ~/.claude/skills/gstack"
        ((ERRORS++)) || true
    fi
fi

# Symlink gstack skills to top-level
if [ -d "$SKILLS_DIR/gstack" ]; then
    GSTACK_SKILLS=(
        qa qa-only design-review ship land-and-deploy canary
        office-hours browse setup-deploy setup-browser-cookies
        connect-chrome review benchmark autoplan checkpoint
        design-consultation design-html design-shotgun
        document-release freeze unfreeze guard health
        investigate learn plan-ceo-review plan-design-review
        plan-eng-review retro careful cso skill-vetter
    )
    linked=0
    for skill in "${GSTACK_SKILLS[@]}"; do
        if [ -d "$SKILLS_DIR/gstack/$skill" ] && [ ! -e "$SKILLS_DIR/$skill" ]; then
            ln -s "gstack/$skill" "$SKILLS_DIR/$skill"
            ((linked++))
        fi
    done
    if [ "$linked" -gt 0 ]; then
        ok "Linked $linked gstack skills"
    else
        ok "All gstack skills already linked"
    fi
fi

# ─── Step 3: Vibe skills ──────────────────────────────────────────

step "Step 3/5: Installing /vibe pipeline..."

VIBE_SKILLS=(vibe vibe-prep vibe-harness roast-mvp validate-idea)
for skill in "${VIBE_SKILLS[@]}"; do
    src="$SCRIPT_DIR/skills/$skill"
    dest="$SKILLS_DIR/$skill"

    if [ ! -d "$src" ]; then
        fail "$skill not found in repo"
        ((ERRORS++)) || true
        continue
    fi

    if [ -d "$dest" ] && [ ! -L "$dest" ]; then
        mv "$dest" "${dest}.bak.$(date +%s)"
    fi

    rm -rf "$dest"
    cp -r "$src" "$dest"
    ok "$skill"
done

# ─── Step 4: Rules ────────────────────────────────────────────────

step "Step 4/5: Installing coding rules..."

if [ -d "$SCRIPT_DIR/rules" ]; then
    for rule_file in "$SCRIPT_DIR"/rules/*.md; do
        [ -f "$rule_file" ] || continue
        filename=$(basename "$rule_file")
        if [ -f "$RULES_DIR/$filename" ]; then
            ok "$filename (already exists, skipping)"
        else
            cp "$rule_file" "$RULES_DIR/$filename"
            ok "$filename"
        fi
    done
else
    warn "No rules directory found in repo"
fi

# ─── Step 5: Optional CLI tools ───────────────────────────────────

step "Step 5/5: CLI tools..."

if command -v npm >/dev/null 2>&1; then
    # opencli — recommended (scraping 60+ websites)
    if command -v opencli >/dev/null 2>&1; then
        ok "opencli already installed (60+ site scrapers)"
    else
        warn "Installing opencli (scrape Twitter, Reddit, arXiv, Bloomberg, 小红书, B站, and 55+ more)..."
        if npm install -g @jackwener/opencli 2>/dev/null; then
            ok "opencli installed"
        else
            fail "opencli failed — install manually: npm i -g @jackwener/opencli"
            ((ERRORS++)) || true
        fi
    fi

    # openclaw — optional (persistent AI agents)
    if command -v openclaw >/dev/null 2>&1; then
        ok "openclaw already installed"
    else
        echo -e "  ${YELLOW}?${NC} Install openclaw? (persistent AI agents — study buddy, gym tracker, etc.) [y/N] "
        read -r -n 1 answer </dev/tty 2>/dev/null || answer="n"
        echo ""
        if [[ "$answer" =~ ^[Yy]$ ]]; then
            npm install -g openclaw 2>/dev/null && ok "openclaw installed" || warn "openclaw install failed"
        else
            ok "Skipped openclaw"
        fi
    fi
else
    warn "npm not found — skipping CLI tools (install Node.js to get opencli scraping)"
fi

# ─── Summary ───────────────────────────────────────────────────────

echo ""
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

if [ "$ERRORS" -gt 0 ]; then
    warn "Installed with $ERRORS warning(s) — check above"
else
    ok "Claude Starter Pack installed successfully!"
fi

cat << 'USAGE'

  Quick Start:
  ────────────
    /vibe              Build anything (asks: quick or full?)
    /brainstorm        Explore an idea before building
    /qa                Test your web app in a browser
    /ship              Create a PR and deploy

  Full Pipeline:
  ──────────────
    /vibe → "quick"    5 stages: brainstorm → build → security → QA → ship
    /vibe → "full"     9 stages: validate → brainstorm → prep → plan → build → QA → roast → ship → monitor

  Learn More:
  ───────────
    Read docs/vibe-engineering-methods.md for a guide on
    different AI coding approaches (agentic, harness, loops, etc.)

USAGE
