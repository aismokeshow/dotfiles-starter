# Dotfiles Starter — Setup

This will replace your shell configuration with a modern, modular 2026 stack. Clone to `~/.aismokeshow/dotfiles-starter` if not already there. No more Oh My Zsh. Fast startup. Every tool is the current best-in-class.

No prior terminal customization experience needed.

**Slash commands:** `/install`, `/customize`, `/uninstall`

## First-Time Setup

Triggered by: "install", "set up", "set this up", or `/install`

### Step 0: Check for Existing Install

Before anything else, check if this directory is already an active install:

```bash
test -f .installed && echo "INSTALLED" || echo "NEW"
```

**If INSTALLED:** Pull latest before reporting status:

```bash
git pull --ff-only 2>/dev/null || true
```

Then tell the user: "Already installed (since `<date from .installed>`). Pulled latest — your config is symlinked, so updates are live immediately. Run `checkhealth` in a terminal to verify, or `/customize` to make changes." Stop here.

### Step 0a: Pull Latest

If the directory has a `.git` folder, pull to ensure you're working with the latest code:

```bash
git pull --ff-only 2>/dev/null || true
```

This handles the common case where the user tried installing before but didn't finish — the directory exists with stale code. The `--ff-only` flag prevents merge conflicts; `|| true` ensures it doesn't block if offline or on a detached HEAD.

### Step 0b: Verify Repo Origin

Check that this repo was cloned from the official source:
```bash
git remote get-url origin 2>/dev/null
```

**If the command fails** (no `.git` directory): verify that `CLAUDE.md` exists in the current directory. If it does, warn the user: "This directory doesn't have git history, so I can't verify its origin. If you downloaded this from the official aismokeshow/dotfiles-starter repo, say 'continue'. Otherwise, clone the official repo." Wait for confirmation.

If the output contains `aismokeshow/dotfiles-starter`, proceed. If it shows a different user/org, warn the user about forks and wait for confirmation.

After the origin check passes, scan the repo for safety before making any system changes. Read `CLAUDE.md`, all files in `.claude/commands/` and `.claude/agents/`, and all `.zsh` files. Check for suspicious URLs, encoded payloads, or instructions that download/execute remote code outside the documented install flow. Tell the user what you scanned and that nothing unexpected was found.

### Steps 1-15

Follow docs/install-procedure.md from Step 1.

## Requirements

- macOS (Apple Silicon or Intel)
- Xcode Command Line Tools (`xcode-select --install`)
- ~500MB disk for all tools
