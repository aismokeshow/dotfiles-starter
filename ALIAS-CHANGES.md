# What Changed from a Standard Oh My Zsh Setup

This config replaces Oh My Zsh entirely. Here's what's different.

## Replaced with Modern Tools

| Alias | Old Command | New Command | Why |
|-------|-------------|-------------|-----|
| `ls` | `ls` | `eza --icons --group-directories-first` | Git integration, icons, better defaults |
| `ll` | `ls -la` | `eza -la --icons --group-directories-first --git` | Shows git status per file |
| `la` | `ls -A` | `eza -a --icons --group-directories-first` | Consistent with new `ls` |
| `l` | `ls -CF` | `eza --icons --group-directories-first` | Consistent with new `ls` |
| `cat` | (system cat) | `bat --plain` | Syntax highlighting; `--plain` keeps it clean for piping |
| `grep` | (system grep) | `rg` (ripgrep) | 10-100x faster, respects .gitignore |

## Changed (non-alias)

| What | Old | New | Why |
|------|-----|-----|-----|
| Framework | Oh My Zsh | Sheldon + zsh-defer | Faster startup, no framework overhead |
| Prompt | robbyrussell theme | Starship | Rust-powered, <10ms render, cross-shell |
| Plugin loading | Eager (all at once) | Deferred (after first prompt) | Faster perceived startup |
| Init scripts | `eval` on every startup | Cached in `~/.cache/zsh/` | Eliminates 100-200ms of eval time |
| Runtimes | Hardcoded Python/Node paths | mise (single tool) | No more nvm/pyenv/asdf juggling |
| Python packages | pip + virtualenv | uv | 10-100x faster, automatic venv management |
| Git diffs | default | delta | Syntax highlighting, side-by-side |
| Package manager | Homebrew only | Homebrew | Same tool, just pre-configured PATH |

## New Aliases

| Alias | Command | Purpose |
|-------|---------|---------|
| `tree` | `eza --tree --icons` | Tree view with icons |
| `c` | `${EDITOR:-nano} .` | Open current directory in editor |
| `zc` | `${EDITOR:-nano} ~/.zshrc` | Edit zsh config |
| `zr` | `source ~/.zshrc` | Reload zsh config |
| `pwr` | `openssl rand -base64 32` | Generate raw base64 password (32 bytes) |
| `ji` | `zi` | Interactive zoxide (fuzzy directory picker) |
| `mcp-ls` | `claude mcp list` | List MCP servers |

## New Functions

| Function | Purpose |
|----------|---------|
| `regen-cache` | Regenerates cached init scripts for starship/zoxide/fzf/atuin/mise |
| `checkhealth` | Verifies all 12 tools and init caches |
| `killport` | Graceful then forceful port killing |
| `checkport` | Check what's running on a port (default: 3000) |
| `smoke` | Run Claude Code with `--dangerously-skip-permissions` (skips all prompts) |
| `fcd` | Fuzzy cd to any directory from home |
| `fcdd` | Fuzzy cd to any directory from current dir |
| `fif` | Fuzzy find-in-files (ripgrep + fzf) |
| `fzfp` | fzf with bat preview |
| `zclean` | Remove dead directories from zoxide database |
| `yazi` | Shell cd-on-exit wrapper (cd to last dir when you quit yazi) |
| `mcp-info` | Show details of an MCP server |
| `mcp-rm` | Remove an MCP server from project scope |

## Unchanged

Safety aliases (`rm -i`, `cp -i`, `mv -i`), password generation (`pw`, `pw16`, `pwx`), navigation (`..`, `...`, `....`), zoxide shortcuts (`j`, `jj`, `zi`), FZF navigation (`pp`, `fe`, `fo`), port management (`ports`).
