# Install Procedure

Step-by-step manifest for the install agent. Each step is atomic — complete it fully before moving on. If a step fails, stop and report the failure to the user.

---

## Step 1: Verify macOS

**Precondition:** None.
**Goal:** Confirm we are on macOS and identify architecture.

```bash
uname -s
```

Must return `Darwin`. If not, stop — this starter is macOS-only.

```bash
uname -m
```

Record the result: `arm64` (Apple Silicon) or `x86_64` (Intel). This affects Homebrew paths later.

## Step 2: Verify Xcode Command Line Tools

**Precondition:** Step 1 passed.
**Goal:** Ensure the C toolchain and system headers are available.

```bash
xcode-select -p 2>/dev/null
```

If this fails, tell the user:

> **One thing first.** Your Mac needs Apple's developer tools installed (don't worry — it's just a standard system component, not the full Xcode app).
>
> 1. Copy and paste this into your terminal, then hit Enter:
>
> ```
> xcode-select --install
> ```
>
> 2. A popup will appear — click **"Install"** and wait for it to finish
> 3. Come back here and say **"done"**

**Wait for user confirmation before continuing.**

## Step 3: Install Homebrew

**Precondition:** Step 2 passed.
**Goal:** Ensure Homebrew is available. Homebrew requires sudo, which Claude Code cannot provide — the user must install it themselves if it's not already present.

Check if already installed:

```bash
/opt/homebrew/bin/brew --version 2>/dev/null || /usr/local/bin/brew --version 2>/dev/null || echo "missing"
```

If missing, tell the user exactly this (copy-paste friendly, beginner-safe):

> **One quick thing I need your help with.** Homebrew (the macOS package manager) needs your password to install, and I can't type passwords for you. This is the only manual step in the whole process.
>
> **Here's what to do:**
>
> 1. Open a new terminal window next to this one (⌘N)
> 2. Copy and paste this entire line, then hit Enter:
>
> ```
> /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
> ```
>
> 3. Type your Mac password when asked (you won't see it as you type — that's normal)
> 4. Wait for it to finish (1-3 minutes)
> 5. Come back here and say **"done"**
>
> That's it — I'll handle everything else from there.

**Wait for user confirmation before continuing.** Do not proceed on silence or ambiguous responses. Only continue when the user explicitly confirms Homebrew is installed.

After Homebrew is confirmed, verify it's reachable:

```bash
/opt/homebrew/bin/brew --version 2>/dev/null || /usr/local/bin/brew --version 2>/dev/null
```

**Important:** Claude Code's Bash tool does not persist shell state between commands. `eval "$(brew shellenv)"` only affects the current command. For all subsequent `brew` commands in this procedure, **always use the absolute path**: `/opt/homebrew/bin/brew` (Apple Silicon) or `/usr/local/bin/brew` (Intel).

## Step 4: Install Brewfile (if present)

**Precondition:** Step 3 completed (Homebrew available).
**Goal:** Install user-provided Brewfile packages.

Check for a Brewfile in the starter directory:

```bash
test -f Brewfile && echo "found" || echo "none"
```

If found, run:

```bash
/opt/homebrew/bin/brew bundle install --file=Brewfile --no-lock
```

If Brewfile is not found, skip this step entirely.

## Step 5: Install CLI Tool Stack

**Precondition:** Step 3 completed (Homebrew available).
**Goal:** Install all 12 modern CLI tools via Homebrew.

Install all tools in a single command:

```bash
/opt/homebrew/bin/brew install starship sheldon fzf zoxide eza bat ripgrep fd atuin mise git-delta uv
```

This may take 1-3 minutes. Homebrew will skip any already-installed tools.

After completion, verify each binary is reachable:

| Binary | Package |
|--------|---------|
| `starship` | `starship` |
| `sheldon` | `sheldon` |
| `fzf` | `fzf` |
| `zoxide` | `zoxide` |
| `eza` | `eza` |
| `bat` | `bat` |
| `rg` | `ripgrep` |
| `fd` | `fd` |
| `atuin` | `atuin` |
| `mise` | `mise` |
| `delta` | `git-delta` |
| `uv` | `uv` |

Check with: `export PATH="/opt/homebrew/bin:$PATH" && command -v <binary>` for each.

Report results to the user. If any failed, list them and note they can be installed manually later with `brew install <pkg>`.

## Step 6: Configure Sheldon (Plugin Manager)

**Precondition:** Step 5 completed.
**Goal:** Symlink the Sheldon config and download plugins.

```bash
mkdir -p "$HOME/.config/sheldon"
ln -sf "$(pwd)/zsh/sheldon/plugins.toml" "$HOME/.config/sheldon/plugins.toml"
```

If `sheldon` is installed, lock plugins:

```bash
sheldon lock 2>&1
```

If `sheldon lock` fails, warn: "Plugins will download on first shell start."

**Verification:** `~/.config/sheldon/plugins.toml` exists and is a symlink.

## Step 7: Configure Starship Prompt

**Precondition:** Step 5 completed.
**Goal:** Symlink the Starship config.

```bash
mkdir -p "$HOME/.config"
ln -sf "$(pwd)/zsh/starship.toml" "$HOME/.config/starship.toml"
```

**Verification:** `~/.config/starship.toml` exists and is a symlink.

## Step 8: Configure mise (Runtime Version Manager)

**Precondition:** Step 5 completed.
**Goal:** Create a default mise config and install runtimes.

```bash
mkdir -p "$HOME/.config/mise"
```

If `~/.config/mise/config.toml` does NOT already exist, create it:

```toml
[tools]
python = "3.11"
node = "lts"

[settings]
experimental = true
```

If `mise` is installed, install runtimes:

```bash
mise install 2>&1
```

This may take several minutes. If it fails, warn: "Run `mise install` manually after shell restart."

## Step 9: Cache Shell Init Scripts

**Precondition:** Steps 5-7 completed.
**Goal:** Pre-cache init scripts so .zshrc loads from cache instead of running `eval` on every startup.

```bash
mkdir -p "$HOME/.cache/zsh"
```

For each tool that is installed, generate its cache file:

| Tool | Command | Output File |
|------|---------|------------|
| starship | `starship init zsh` | `~/.cache/zsh/starship.zsh` |
| zoxide | `zoxide init zsh` | `~/.cache/zsh/zoxide.zsh` |
| fzf | `fzf --zsh` | `~/.cache/zsh/fzf.zsh` |
| atuin | `atuin init zsh` | `~/.cache/zsh/atuin.zsh` |
| mise | `mise activate zsh` | `~/.cache/zsh/mise.zsh` |

Skip any tool that is not installed.

**Verification:** `ls ~/.cache/zsh/` shows `.zsh` files for each installed tool.

## Step 10: Set Up Completions Directory

**Precondition:** None.
**Goal:** Ensure the custom completions directory exists.

```bash
mkdir -p "$HOME/.config/zsh/completions" "$HOME/.zsh/cache"
```

## Step 11: Migrate Custom Config and Symlink .zshrc

**Precondition:** Step 10 completed.
**Goal:** Preserve any custom shell configuration, then replace `~/.zshrc` with a symlink to this repo's modular config.

> **DESTRUCTIVE BOUNDARY** — This replaces the user's shell configuration.
> Tell the user: "I'm about to replace your `~/.zshrc` with a symlink to this starter's modular config. Your existing `.zshrc` will be backed up, and I'll automatically preserve any custom aliases, functions, exports, or PATH entries I find in it. Proceed?"
> **Wait for explicit confirmation.**

### Step 11a: Extract custom content from existing .zshrc

Read `~/.zshrc`. If it exists and is not empty, compare its contents against `zsh/.zshrc` (the new config). Identify any lines that are custom — aliases, functions, export statements, PATH additions, or source commands that are NOT part of the new modular config.

For each custom line found, automatically append it to the appropriate modular file:

| Content type | Destination |
|---|---|
| `alias ...` | `zsh/aliases.zsh` |
| `export ...` (non-PATH) | `zsh/exports.zsh` |
| `export PATH=...` or PATH modifications | `zsh/paths.zsh` |
| Function definitions | `zsh/functions.zsh` |
| `source ...` or `. ...` commands | `zsh/exports.zsh` (with a comment noting the source) |

Tell the user what was migrated: "I found X custom lines in your existing .zshrc and moved them into the modular config files. Nothing was lost."

If nothing custom is found, skip this substep silently.

### Step 11b: Backup and symlink

Use the **safe-merge-config** skill with:
- **Target file:** `~/.zshrc`
- **Source:** `$(pwd)/zsh/.zshrc`
- **Strategy:** symlink
- **Backup pattern:** `~/.zshrc.pre-dotfiles.YYYYMMDD-HHMMSS`

After symlinking, inform the user:

> `~/.zshrc` is now a symlink to this folder. **Do not move or delete this folder** — your shell config lives here permanently.

## Step 12: Write .zprofile

**Precondition:** Step 11 completed.
**Goal:** Ensure `~/.zprofile` sets up PATH for Homebrew and OrbStack.

Use the **safe-merge-config** skill with:
- **Target file:** `~/.zprofile`
- **Content to ensure is present:**

```bash
# CLI tools PATH setup
[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"
[[ -d "/opt/zerobrew/bin" ]] && export PATH="/opt/zerobrew/bin:$PATH"
[[ -d "/opt/zerobrew/prefix/bin" ]] && export PATH="/opt/zerobrew/prefix/bin:$PATH"

# Homebrew shell env (sets HOMEBREW_PREFIX, MANPATH, etc.)
eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null)" || eval "$(/usr/local/bin/brew shellenv 2>/dev/null)" || true

# OrbStack Docker integration (optional — only loads if installed)
source ~/.orbstack/shell/init.zsh 2>/dev/null || true
```

- **Strategy:** merge — preserve existing user content, add missing blocks
- **Detect existing:** check for `"CLI tools PATH setup"` marker string
- **Backup pattern:** `~/.zprofile.pre-dotfiles.YYYYMMDD-HHMMSS`

## Step 13: Verify Default Shell

**Precondition:** Step 12 completed.
**Goal:** Ensure the user's login shell is zsh.

```bash
echo "$SHELL"
```

If the output does not end in `/zsh`, tell the user:

> Your default shell is not zsh. To change it, run: `chsh -s $(command -v zsh)` (requires your password).

This is informational only — do not run `chsh` automatically.

## Step 14: Validate Installation

**Precondition:** All previous steps completed.
**Goal:** Confirm symlinks are correct and all tools are available.

**First, verify the .zshrc symlink** — this is the most critical check. If .zshrc was copied instead of symlinked, the entire modular config breaks:

```bash
readlink ~/.zshrc
```

The output must contain the path to this repo's `zsh/.zshrc`. If `readlink` returns nothing (not a symlink), **stop and fix it**:

```bash
ln -sfn "$(pwd)/zsh/.zshrc" ~/.zshrc
```

Then verify the other symlinks:
```bash
readlink ~/.config/starship.toml
readlink ~/.config/sheldon/plugins.toml
```

**Then check each binary:**

| Binary |
|--------|
| `starship` |
| `sheldon` |
| `fzf` |
| `zoxide` |
| `eza` |
| `bat` |
| `rg` |
| `fd` |
| `atuin` |
| `mise` |
| `delta` |
| `uv` |

For each, run `command -v <binary>`. Report OK or MISSING.

If any are missing, tell the user: "X tools not found. Run `brew install <pkg>` to install them manually."

Then source the new config and run the health check:

```bash
source ~/.zshrc
checkhealth
```

## Step 15: Switch to Operational Mode

**Precondition:** Step 14 passed (or user acknowledged missing tools).
**Goal:** Replace the install-phase CLAUDE.md with the operational hub version.

```bash
cp .claude/CLAUDE.hub.md CLAUDE.md
```

Write a marker file so future agents can detect this is an active install (even if `.git` was removed in Step 16):

```bash
date -u '+%Y-%m-%dT%H:%M:%SZ' > .installed
```

Tell the user: "CLAUDE.md has been switched to operational mode. Future Claude Code sessions in this folder will see the hub instructions instead of the install flow."

## Step 16: Optional Cleanup

**Precondition:** Step 15 completed.
**Goal:** Remove packaging artifacts if the user wants a clean install.

> **DESTRUCTIVE BOUNDARY** — This removes git history and the ability to pull updates.
> Tell the user: "I can remove git history and packaging files to clean up. You won't be able to `git pull` updates afterward. Say 'continue' to clean up, or 'skip' to keep the ability to pull updates."
> **Wait for explicit confirmation. Default to skip.**

If the user says continue:

```bash
rm -f LICENSE .gitignore
rm -rf .git
```

Replace README.md with:

```markdown
# Dotfiles

Your shell config lives here. Open Claude Code in this folder to manage it.

`/customize` · `/install` · `/uninstall`

MIT — [aismokeshow](https://www.aismokeshow.com/) · [dotfiles-starter](https://github.com/aismokeshow/dotfiles-starter)
```

## Post-Install: Tell the User

After all steps, print this completion message. Use the exact structure and ASCII art below — do NOT improvise, rearrange, or add extra suggestions.

---

**First, the activation instruction (lead with this):**

> **One last thing.** Open a new terminal window (⌘N) and you'll see a clean new prompt with a `>` character — that's [Starship](https://starship.rs). Everything is working.
>
> (You're inside Claude Code right now, so your new config won't load here. Just open a fresh terminal window next to this one to see it.)

**Then the VIBE-GUIDE callout:**

> Open `VIBE-GUIDE.md` in this folder to learn what you just installed — every tool explained in plain English with examples you can try right away.

**Then a quick primer (keep it short):**

> Here are three things to try in your new shell:
>
> - Type `ls` — you'll see file icons and git status (that's [eza](https://github.com/eza-community/eza))
> - Type `z <folder>` — jump to any directory you've visited before (that's [zoxide](https://github.com/ajeetdsouza/zoxide))
> - Type `checkhealth` — verify all 12 tools are installed and working

**Then optional next steps:**

> **Optional next steps** (do these whenever you're ready):
>
> - `atuin register` — sync your shell history across machines (encrypted)
> - `git config --global user.name "Your Name"` — if not already set
> - `~/.env.secrets` — put API keys here, then `chmod 600 ~/.env.secrets`

**Then the branded sign-off (print this ASCII art exactly):**

```
    🔥
   /||\
  / || \
 /  ||  \
/___||___\

 AISMOKESHOW
 aismokeshow.com

 You're all set. Welcome to the 2026 shell.
```

**Important:** `~/.zshrc` is now a symlink to this folder. Don't move or delete it — your shell config lives here permanently.
