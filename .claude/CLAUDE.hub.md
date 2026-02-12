# Dotfiles Starter — Operational Hub

This is your shell configuration command center. The zsh config files in `zsh/` are symlinked to your home directory. Open Claude Code here and ask for what you want — add aliases, change tools, troubleshoot, or tweak your shell. You never need to edit config files manually.

**Slash commands:** `/customize`, `/install`, `/uninstall`

The instructions below tell Claude Code how to manage everything. You can read along if you're curious, but you don't have to.

## Project Architecture

```
dotfiles-starter/
├── CLAUDE.md                              ← Install-phase instructions (you're reading the hub replacement)
├── zsh/                                   ← Shell config files (symlinked to ~/)
│   ├── .zshrc, exports.zsh, paths.zsh, aliases.zsh, functions.zsh
│   ├── starship.toml                      ← Prompt config (symlinked to ~/.config/)
│   └── sheldon/plugins.toml               ← Plugin manager config (symlinked to ~/.config/sheldon/)
├── docs/
│   └── install-procedure.md               ← 18-step atomic install manifest
├── .claude/
│   ├── CLAUDE.hub.md                      ← THIS FILE — operational reference
│   ├── agents/
│   │   └── install-dotfiles.md            ← Install agent (orchestrates full setup)
│   ├── skills/
│   │   └── safe-merge-config/SKILL.md     ← Non-destructive config file modifier
│   └── commands/                          ← Slash command dispatchers
├── VIBE-GUIDE.md                          ← Beginner-friendly tool explainer
└── ALIAS-CHANGES.md                       ← Migration changelog
```

**Agents:** The `install-dotfiles` agent reads `docs/install-procedure.md` at runtime and uses the safe-merge-config skill to execute the install. It does not contain inlined procedures — it orchestrates.

**Skills:**
- `safe-merge-config` — three modes: SYMLINK (replace file with symlink), ENSURE-LINES (append missing lines), WRITE-IF-MISSING (create only if absent). Always backs up, never silently discards content.

## Symlink Architecture

```
~/.zshrc              → zsh/.zshrc (entry point)
~/.config/starship.toml → zsh/starship.toml
~/.config/sheldon/plugins.toml → zsh/sheldon/plugins.toml
```

Modules loaded by `.zshrc`:
- `zsh/exports.zsh` — environment variables
- `zsh/paths.zsh` — PATH ordering
- `zsh/aliases.zsh` — all aliases (deferred via zsh-defer)
- `zsh/functions.zsh` — all functions (deferred via zsh-defer)

## Key Commands

| Command | What it does |
|---------|-------------|
| `checkhealth` | Verify all tools + caches are working |
| `regen-cache` | Refresh cached init scripts after tool upgrades |
| `smoke` | Run Claude Code with `--dangerously-skip-permissions` (skips all confirmation prompts) |
| `zb` | Optional: fast CLI tool installer (homebrew-core). `brew` works normally for casks/taps |

## Rules for Editing zsh/ Files

- Edits to `zsh/` files take effect on next shell start (or `source ~/.zshrc`)
- Never move or delete this folder — `~/.zshrc` symlinks here
- After editing starship.toml: changes apply immediately (Starship re-reads on each prompt)
- After editing sheldon/plugins.toml: run `sheldon lock` then restart shell
- After adding aliases or functions: restart shell or `source ~/.zshrc`
- Do not install Oh My Zsh — this config intentionally replaces it

---

## First-Time Setup

Triggered by: `/install`

If `.installed` exists in this directory, or `~/.zshrc` is already a symlink to this repo and tools are installed, tell the user everything is configured and offer to run `checkhealth`.

Otherwise, the `install-dotfiles` agent handles the full setup. It reads `docs/install-procedure.md` and executes all steps, using the `safe-merge-config` skill for config file changes.

## Uninstall

Triggered by: `/uninstall`

1. Remove symlinks: `~/.zshrc`, `~/.config/starship.toml`, `~/.config/sheldon/plugins.toml`
2. Restore backup if it exists: `~/.zshrc.pre-dotfiles.*`
3. If no backup, create a minimal `~/.zshrc` so the user has a working shell
4. Remove cached init scripts: `rm -rf ~/.cache/zsh/`
5. Tools installed via `zb` or `brew` are left in place — the user can remove them manually
