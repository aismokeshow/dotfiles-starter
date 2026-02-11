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

> Xcode Command Line Tools are required. Run `xcode-select --install`, complete the GUI dialog, then say "done".

**Wait for user confirmation before continuing.**

## Step 3: Install Homebrew

**Precondition:** Step 2 passed.
**Goal:** Ensure Homebrew is available. Homebrew requires sudo, which Claude Code cannot provide — the user must install it themselves if it's not already present.

Check if already installed:

```bash
/opt/homebrew/bin/brew --version 2>/dev/null || /usr/local/bin/brew --version 2>/dev/null || echo "missing"
```

If missing, tell the user:

> Homebrew is required but not installed. It needs sudo access, so I can't install it for you. Please run this command in a separate terminal:
>
> ```
> /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
> ```
>
> After it finishes, say "done" and I'll continue.

**Wait for user confirmation before continuing.**

After Homebrew is confirmed, ensure it's in PATH:

```bash
eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null)" || eval "$(/usr/local/bin/brew shellenv 2>/dev/null)"
```

## Step 4: Install Zerobrew

**Precondition:** Step 3 completed.
**Goal:** Install Zerobrew as a faster alternative to Homebrew for CLI tools.

Check if already installed:

```bash
command -v zb &>/dev/null && echo "installed" || echo "missing"
```

If missing, install:

```bash
curl -sSL https://raw.githubusercontent.com/lucasgelfond/zerobrew/main/install.sh | bash
export PATH="$HOME/.local/bin:/opt/zerobrew/bin:/opt/zerobrew/prefix/bin:$PATH"
```

**Verification:** Run `zb --version 2>&1`. If it fails with a library error (e.g., `liblzma` not found), install the dependency:

```bash
brew install xz
```

Then verify again. If `zb` still fails, warn the user that Zerobrew is not working — Homebrew will be used as the sole fallback. Continue either way.

## Step 5: Install Brewfile (if present)

**Precondition:** Step 3 completed (Homebrew available).
**Goal:** Install user-provided Brewfile packages.

Check for a Brewfile in the starter directory:

```bash
test -f Brewfile && echo "found" || echo "none"
```

If found, this requires Homebrew. Use the **ensure-tool-installed** skill to ensure `brew` is available (binary: `brew`, package: `homebrew`), then run:

```bash
brew bundle install --file=Brewfile --no-lock
```

If Brewfile is not found, skip this step entirely.

## Step 6: Install CLI Tool Stack

**Precondition:** Step 3 completed.
**Goal:** Install all 12 modern CLI tools.

| Tool | Binary | Package Name |
|------|--------|-------------|
| Starship | `starship` | `starship` |
| Sheldon | `sheldon` | `sheldon` |
| fzf | `fzf` | `fzf` |
| zoxide | `zoxide` | `zoxide` |
| eza | `eza` | `eza` |
| bat | `bat` | `bat` |
| ripgrep | `rg` | `ripgrep` |
| fd | `fd` | `fd` |
| Atuin | `atuin` | `atuin` |
| mise | `mise` | `mise` |
| delta | `delta` | `git-delta` |
| uv | `uv` | `uv` |

For each tool, use the **ensure-tool-installed** skill with the binary and package name from this table. The skill handles the zb-then-brew fallback logic.

Track any failures. After all 12 are attempted, report results to the user. If any failed, list them and note they can be installed manually later with `zb install <pkg>` or `brew install <pkg>`.

## Step 7: Configure Sheldon (Plugin Manager)

**Precondition:** Step 6 completed.
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

## Step 8: Configure Starship Prompt

**Precondition:** Step 6 completed.
**Goal:** Symlink the Starship config.

```bash
mkdir -p "$HOME/.config"
ln -sf "$(pwd)/zsh/starship.toml" "$HOME/.config/starship.toml"
```

**Verification:** `~/.config/starship.toml` exists and is a symlink.

## Step 9: Configure mise (Runtime Version Manager)

**Precondition:** Step 6 completed.
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

## Step 10: Cache Shell Init Scripts

**Precondition:** Steps 6-8 completed.
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

## Step 11: Set Up Completions Directory

**Precondition:** None.
**Goal:** Ensure the custom completions directory exists.

```bash
mkdir -p "$HOME/.config/zsh/completions"
```

## Step 12: Cross-Project Check

**Precondition:** Steps 6-10 completed.
**Goal:** Detect and handle interactions with other aismokeshow starters.

Read `docs/cross-project-awareness.md` and follow its instructions before modifying any shell config files in Steps 13-14.

## Step 13: Symlink .zshrc

**Precondition:** Step 12 completed.
**Goal:** Point `~/.zshrc` at the modular config in this repo.

> **DESTRUCTIVE BOUNDARY** — This replaces the user's shell configuration.
> Tell the user: "I'm about to replace your `~/.zshrc` with a symlink to this starter's modular config. Your existing `.zshrc` will be backed up. Proceed?"
> **Wait for explicit confirmation.**

Use the **safe-merge-config** skill with:
- **Target file:** `~/.zshrc`
- **Source:** `$(pwd)/zsh/.zshrc`
- **Strategy:** symlink (not merge) — the .zshrc is a complete replacement
- **Backup pattern:** `~/.zshrc.pre-dotfiles.YYYYMMDD-HHMMSS`

After symlinking, inform the user:

> `~/.zshrc` is now a symlink to this folder. **Do not move or delete this folder** — your shell config lives here permanently.

## Step 14: Write .zprofile

**Precondition:** Step 13 completed.
**Goal:** Ensure `~/.zprofile` sets up PATH for Zerobrew, Homebrew, and OrbStack.

Use the **safe-merge-config** skill with:
- **Target file:** `~/.zprofile`
- **Content to ensure is present:**

```bash
# Zerobrew PATH setup (zb does NOT have a shellenv subcommand)
[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"
[[ -d "/opt/zerobrew/bin" ]] && export PATH="/opt/zerobrew/bin:$PATH"
[[ -d "/opt/zerobrew/prefix/bin" ]] && export PATH="/opt/zerobrew/prefix/bin:$PATH"

# Homebrew shell env (sets HOMEBREW_PREFIX, MANPATH, etc.)
eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null)" || eval "$(/usr/local/bin/brew shellenv 2>/dev/null)" || true

# OrbStack Docker integration (optional — only loads if installed)
source ~/.orbstack/shell/init.zsh 2>/dev/null || true
```

- **Strategy:** merge — preserve existing user content, add missing blocks
- **Detect existing:** check for `"Zerobrew PATH setup"` marker string
- **Backup pattern:** `~/.zprofile.pre-dotfiles.YYYYMMDD-HHMMSS`

## Step 15: Verify Default Shell

**Precondition:** Step 14 completed.
**Goal:** Ensure the user's login shell is zsh.

```bash
echo "$SHELL"
```

If the output does not end in `/zsh`, tell the user:

> Your default shell is not zsh. To change it, run: `chsh -s $(command -v zsh)` (requires your password).

This is informational only — do not run `chsh` automatically.

## Step 16: Validate Installation

**Precondition:** All previous steps completed.
**Goal:** Confirm all tools are available.

Check each binary:

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

If any are missing, tell the user: "X tools not found. Run `zb install <pkg>` or `brew install <pkg>` to install them manually."

Then source the new config and run the health check:

```bash
source ~/.zshrc
checkhealth
```

## Step 17: Switch to Operational Mode

**Precondition:** Step 16 passed (or user acknowledged missing tools).
**Goal:** Replace the install-phase CLAUDE.md with the operational hub version.

```bash
cp .claude/CLAUDE.hub.md CLAUDE.md
```

Tell the user: "CLAUDE.md has been switched to operational mode. Future Claude Code sessions in this folder will see the hub instructions instead of the install flow."

## Step 18: Optional Cleanup

**Precondition:** Step 17 completed.
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

After all steps, summarize what happened:

- `~/.zshrc` is a symlink to this folder — do not move or delete it
- `zb` installs CLI tools fast (homebrew-core packages). `brew` still works for casks, taps, and services
- Modern replacements are active: `ls` -> eza, `cat` -> bat, `grep` -> ripgrep, `find` -> fd, `cd` -> zoxide
- Run `checkhealth` anytime to verify the stack
- Run `regen-cache` after upgrading cached tools
- See `VIBE-GUIDE.md` for a beginner-friendly explanation of every tool

**Manual steps the user should do themselves:**

1. `atuin register` or `atuin login` — encrypted shell history sync (optional)
2. `git config --global user.name "..."` and `git config --global user.email "..."` — if not already set
3. SSH keys — copy from old machine or generate new
4. `~/.env.secrets` with `chmod 600` — for API keys
