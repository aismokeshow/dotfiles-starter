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

If this fails, print the box below **verbatim** — do NOT paraphrase, summarize, or reformat it:

```
╔══════════════════════════════════════════════════════════════╗
║  🛑  YOUR TURN — Claude can't do this step for you          ║
╠══════════════════════════════════════════════════════════════╣
║                                                              ║
║  Your Mac needs Apple's developer tools installed            ║
║  (just a standard system component, not the full Xcode app). ║
║                                                              ║
║  1. Copy and paste this into your terminal, then hit Enter:  ║
║                                                              ║
║     xcode-select --install                                   ║
║                                                              ║
║  2. A popup will appear — click "Install" and wait           ║
║  3. Come back here and say "done"                            ║
║                                                              ║
║  ⏎ Come back here and say "done" when finished               ║
╚══════════════════════════════════════════════════════════════╝
```

**MANDATORY GATE — Do not proceed until the user explicitly confirms. Silence or ambiguous responses are NOT confirmation.**

## Step 3: Install Homebrew

**Precondition:** Step 2 passed.
**Goal:** Ensure Homebrew is available. Homebrew requires sudo, which Claude Code cannot provide — the user must install it themselves if it's not already present.

Check if already installed:

```bash
/opt/homebrew/bin/brew --version 2>/dev/null || /usr/local/bin/brew --version 2>/dev/null || echo "missing"
```

If missing, print the box below **verbatim** — do NOT paraphrase, summarize, or reformat it:

```
╔══════════════════════════════════════════════════════════════╗
║  🛑  YOUR TURN — Claude can't do this step for you          ║
╠══════════════════════════════════════════════════════════════╣
║                                                              ║
║  Homebrew (the macOS package manager) needs your password    ║
║  to install, and I can't type passwords for you.             ║
║                                                              ║
║  1. Open a new terminal window next to this one (⌘N)         ║
║  2. Copy and paste this entire line, then hit Enter:         ║
║                                                              ║
║     /bin/bash -c "$(curl -fsSL                               ║
║       https://raw.githubusercontent.com/Homebrew/            ║
║       install/HEAD/install.sh)"                              ║
║                                                              ║
║  3. Type your Mac password when asked                        ║
║     (you won't see it as you type — that's normal)           ║
║  4. Wait for it to finish (1-3 minutes)                      ║
║                                                              ║
║  ⏎ Come back here and say "done" when finished               ║
╚══════════════════════════════════════════════════════════════╝
```

**MANDATORY GATE — Do not proceed until the user explicitly confirms. Silence or ambiguous responses are NOT confirmation.**

After Homebrew is confirmed, verify it's reachable:

```bash
/opt/homebrew/bin/brew --version 2>/dev/null || /usr/local/bin/brew --version 2>/dev/null
```

**Important:** Claude Code's Bash tool does not persist shell state between commands. `eval "$(brew shellenv)"` only affects the current command. For all subsequent `brew` commands in this procedure, **always use the absolute path**: `/opt/homebrew/bin/brew` (Apple Silicon) or `/usr/local/bin/brew` (Intel).

## Step 4: Install CLI Tool Stack

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

## Step 5: Install Nerd Font (for file icons)

**Precondition:** Step 3 completed (Homebrew available).
**Goal:** Install a Nerd Font so `eza --icons` renders file type icons instead of `?` boxes.

The eza aliases in `zsh/aliases.zsh` use `--icons` by default. This requires a font that includes [Nerd Font](https://www.nerdfonts.com/) glyphs. Without one, icons show as broken boxes.

```bash
/opt/homebrew/bin/brew install --cask font-jetbrains-mono-nerd-font 2>&1
```

If this fails (e.g., the cask tap is missing), try adding the tap first:

```bash
/opt/homebrew/bin/brew tap homebrew/cask-fonts 2>/dev/null; /opt/homebrew/bin/brew install --cask font-jetbrains-mono-nerd-font 2>&1
```

**VERIFY:** Check the font is installed:
```bash
ls ~/Library/Fonts/*JetBrains*Nerd* 2>/dev/null || ls /Library/Fonts/*JetBrains*Nerd* 2>/dev/null || echo "not found"
```

If the font installed successfully, configure the user's terminal to use it. Detect which terminal is running:

```bash
echo "$TERM_PROGRAM"
```

**If `Apple_Terminal` (Terminal.app):**
```bash
osascript -l JavaScript -e 'var t = Application("Terminal"); t.defaultSettings.fontName = "JetBrainsMonoNF-Regular"; t.defaultSettings.fontSize = 14;'
```
Verify: `osascript -l JavaScript -e 'Application("Terminal").defaultSettings.fontName()'` must return `JetBrainsMonoNF-Regular`.

**If `ghostty` (Ghostty):**
```bash
mkdir -p ~/.config/ghostty
grep -q "font-family" ~/.config/ghostty/config 2>/dev/null && sed -i '' 's/^font-family.*/font-family = JetBrainsMono Nerd Font/' ~/.config/ghostty/config || echo "font-family = JetBrainsMono Nerd Font" >> ~/.config/ghostty/config
```
Verify: `grep font-family ~/.config/ghostty/config` shows `font-family = JetBrainsMono Nerd Font`.

**If `iTerm.app` (iTerm2):**
```bash
mkdir -p "$HOME/Library/Application Support/iTerm2/DynamicProfiles"
cat > "$HOME/Library/Application Support/iTerm2/DynamicProfiles/dotfiles-starter.json" << 'ITERM'
{
  "Profiles": [{
    "Name": "Default",
    "Guid": "dotfiles-starter-nerd-font",
    "Normal Font": "JetBrainsMonoNF-Regular 14"
  }]
}
ITERM
```
Tell the user: "I added a Nerd Font profile to iTerm2. Go to **Preferences → Profiles**, select **Default**, and it will use JetBrains Mono Nerd Font."

**Any other terminal:** Tell the user: "Set your terminal font to **JetBrains Mono Nerd Font** in its settings. The font is installed — your terminal just needs to be configured to use it."

The font change takes effect in new terminal windows.

If the font install fails entirely, warn the user: "I couldn't install the Nerd Font. Your `ls` will show `?` instead of file icons. You can install it manually later: `brew install --cask font-jetbrains-mono-nerd-font`"

## Step 6: Configure Sheldon (Plugin Manager)

**Precondition:** Step 4 completed.
**Goal:** Symlink the Sheldon config and download plugins.


```bash
mkdir -p "$HOME/.config/sheldon"
ln -sfn "$(pwd)/zsh/sheldon/plugins.toml" "$HOME/.config/sheldon/plugins.toml"
```

If `sheldon` is installed, lock plugins:

```bash
export PATH="/opt/homebrew/bin:$PATH" && sheldon lock 2>&1
```

If `sheldon lock` fails, warn: "Plugins will download on first shell start."

**VERIFY:** `~/.config/sheldon/plugins.toml` exists and is a symlink: `readlink ~/.config/sheldon/plugins.toml`

## Step 7: Configure Starship Prompt

**Precondition:** Step 4 completed.
**Goal:** Symlink the Starship config.

```bash
mkdir -p "$HOME/.config"
ln -sfn "$(pwd)/zsh/starship.toml" "$HOME/.config/starship.toml"
```

**VERIFY:** `readlink ~/.config/starship.toml` shows a path ending in `zsh/starship.toml`.

## Step 8: Configure mise (Runtime Version Manager)

**Precondition:** Step 4 completed.
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
export PATH="/opt/homebrew/bin:$PATH" && mise install 2>&1
```

This may take several minutes. If it fails, warn: "Run `mise install` manually after shell restart."

## Step 9: Cache Shell Init Scripts

**Precondition:** Steps 4-7 completed.
**Goal:** Pre-cache init scripts so .zshrc loads from cache instead of running `eval` on every startup.

```bash
mkdir -p "$HOME/.cache/zsh"
```

For each tool that is installed, generate its cache file:

| Tool | Command | Output File |
|------|---------|------------|
| starship | `export PATH="/opt/homebrew/bin:$PATH" && starship init zsh` | `~/.cache/zsh/starship.zsh` |
| zoxide | `export PATH="/opt/homebrew/bin:$PATH" && zoxide init zsh` | `~/.cache/zsh/zoxide.zsh` |
| fzf | `export PATH="/opt/homebrew/bin:$PATH" && fzf --zsh` | `~/.cache/zsh/fzf.zsh` |
| atuin | `export PATH="/opt/homebrew/bin:$PATH" && atuin init zsh` | `~/.cache/zsh/atuin.zsh` |
| mise | `export PATH="/opt/homebrew/bin:$PATH" && mise activate zsh` | `~/.cache/zsh/mise.zsh` |

Skip any tool that is not installed.

**VERIFY:** `ls ~/.cache/zsh/` shows `.zsh` files for each installed tool.

## Step 9b: Configure Git to Use Delta

**Precondition:** Step 4 completed (delta installed).
**Goal:** Wire up delta as git's diff pager.

Only run if delta is installed and git's pager is not already configured:

```bash
if export PATH="/opt/homebrew/bin:$PATH" && command -v delta &>/dev/null && [[ -z "$(git config --global core.pager)" ]]; then
    git config --global core.pager delta
    git config --global interactive.diffFilter 'delta --color-only'
    git config --global delta.navigate true
    git config --global delta.side-by-side true
    git config --global merge.conflictstyle diff3
    git config --global diff.colorMoved default
fi
```

**VERIFY:** `git config --global core.pager` returns `delta`.

## Step 10: Set Up Completions Directory

**Precondition:** None.
**Goal:** Ensure the custom completions directory exists.

```bash
mkdir -p "$HOME/.config/zsh/completions" "$HOME/.zsh/cache"
```

## Step 11: Migrate Custom Config and Symlink .zshrc

**Precondition:** Step 10 completed.
**Goal:** Preserve any custom shell configuration, then replace `~/.zshrc` with a symlink to this repo's modular config.

Tell the user:

```
╔══════════════════════════════════════════════════════════════╗
║  ⚠️  CONFIRM — This replaces your shell configuration       ║
╠══════════════════════════════════════════════════════════════╣
║                                                              ║
║  I'm going to make your terminal use the new config instead  ║
║  of the old one. Your old config is saved as a backup.       ║
║                                                              ║
║  • Your existing .zshrc will be backed up first              ║
║  • Any custom aliases, functions, exports, and PATH entries  ║
║    will be automatically migrated into the new modular files ║
║  • Nothing will be lost                                      ║
║                                                              ║
║  Say "continue" to proceed, or "skip" to leave .zshrc as-is ║
╚══════════════════════════════════════════════════════════════╝
```

**MANDATORY GATE — Wait for explicit confirmation. Do not proceed without it.**

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

Back up the existing file (if any):

```bash
[[ -f ~/.zshrc ]] && cp ~/.zshrc ~/.zshrc.pre-dotfiles.$(date +%Y%m%d-%H%M%S)
```

Create the symlink:

```bash
ln -sfn "$(pwd)/zsh/.zshrc" ~/.zshrc
```

**CRITICAL: This MUST be a symlink, not a copy.** The modular config uses `${0:A:h}` to resolve its directory via the symlink. If `.zshrc` is copied instead of symlinked, every `source` call will fail. Do NOT use `cp`, `Write`, or any other method — only `ln -sfn`.

**Verify immediately after:**
```bash
readlink ~/.zshrc
```
The output must show a path ending in `zsh/.zshrc`. If `readlink` returns nothing, the symlink was not created — fix it:
```bash
ln -sfn "$(pwd)/zsh/.zshrc" ~/.zshrc
```

After symlinking, inform the user:

> `~/.zshrc` is now a symlink pointing into this folder. If you move or delete `~/.aismokeshow/dotfiles-starter/`, your shell will fall back to the macOS default config until you fix the link.

## Step 12: Write .zprofile

**Precondition:** Step 11 completed.
**Goal:** Ensure `~/.zprofile` sets up PATH for Homebrew and OrbStack.

Check if the CLI tools PATH block already exists:

```bash
grep -q "CLI tools PATH setup" ~/.zprofile 2>/dev/null && echo "EXISTS" || echo "MISSING"
```

If `MISSING`, append the following block to `~/.zprofile`:

```bash
cat >> ~/.zprofile << 'ZPROFILE'
# CLI tools PATH setup
[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"
[[ -d "/opt/zerobrew/bin" ]] && export PATH="/opt/zerobrew/bin:$PATH"
[[ -d "/opt/zerobrew/prefix/bin" ]] && export PATH="/opt/zerobrew/prefix/bin:$PATH"

# Homebrew shell env (sets HOMEBREW_PREFIX, MANPATH, etc.)
eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null)" || eval "$(/usr/local/bin/brew shellenv 2>/dev/null)" || true

# OrbStack Docker integration (optional — only loads if installed)
source ~/.orbstack/shell/init.zsh 2>/dev/null || true
ZPROFILE
```

If `EXISTS`, skip — the block is already present.

## Step 13: Validate Installation

**Precondition:** All previous steps completed.
**Goal:** Confirm the default shell is zsh, symlinks are correct, and all tools are available.

First, check the default shell:

```bash
echo "$SHELL"
```

If the output does not end in `/zsh`, tell the user:

> Your default shell is not zsh. To change it, run: `chsh -s $(command -v zsh)` (requires your password).

This is informational only — do not run `chsh` automatically.

**Then verify the .zshrc symlink** — this is the most critical check. If .zshrc was copied instead of symlinked, the entire modular config breaks:

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

For each, run `export PATH="/opt/homebrew/bin:$PATH" && command -v <binary>`. Report OK or MISSING.

If any are missing, tell the user: "X tools not found. Run `brew install <pkg>` to install them manually."

Then source the new config and run the health check:

```bash
source ~/.zshrc
checkhealth
```

## Step 14: Switch to Operational Mode

**Precondition:** Step 13 passed (or user acknowledged missing tools).
**Goal:** Replace the install-phase CLAUDE.md with the operational hub version.

```bash
cp .claude/CLAUDE.hub.md CLAUDE.md
```

Write a marker file so future agents can detect this is an active install (even if `.git` was removed in Step 15):

```bash
date -u '+%Y-%m-%dT%H:%M:%SZ' > .installed
```

Tell the user: "CLAUDE.md has been switched to operational mode. Future Claude Code sessions in this folder will see the hub instructions instead of the install flow."

## Step 15: Optional Cleanup

**Precondition:** Step 14 completed.
**Goal:** Remove packaging artifacts if the user wants a clean install.

Tell the user:

```
╔══════════════════════════════════════════════════════════════╗
║  ⚠️  CONFIRM — This removes git history                      ║
╠══════════════════════════════════════════════════════════════╣
║                                                              ║
║  I can remove git history and packaging files to clean up.   ║
║  After this, you won't be able to `git pull` updates —       ║
║  you'd need to re-clone from scratch.                        ║
║                                                              ║
║  Say "continue" to clean up, or "skip" to keep git history   ║
╚══════════════════════════════════════════════════════════════╝
```

**MANDATORY GATE — Wait for explicit confirmation. Default to skip.**

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
> - If anything goes wrong, run `/uninstall` to restore your original config

**Then the sign-off:**

> You're all set. Welcome to the 2026 shell.
>
> **How this works:** `~/.zshrc` is a symlink → `~/.aismokeshow/dotfiles-starter/zsh/.zshrc`. All your shell config lives in this folder. Move or delete it and your shell falls back to macOS defaults until you relink. To undo everything cleanly, run `/uninstall`.
