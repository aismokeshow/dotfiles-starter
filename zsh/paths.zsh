#!/usr/bin/env zsh
# paths.zsh — PATH configuration (order matters: most specific first)
# Python/Node versions managed by mise — no hardcoded framework paths needed.

typeset -U path  # Ensure unique entries

path=(
    $HOME/.local/bin                    # Claude Code / local binaries (highest priority)
    $HOME/.local/share/mise/shims       # mise-managed runtimes
    $HOME/bin                           # User binaries
    $HOME/scripts                       # Personal scripts
    /usr/local/bin                      # System tools
    $HOME/.bun/bin                      # Bun
    /opt/zerobrew/prefix/bin            # Optional: Zerobrew-installed binaries
    /opt/zerobrew/bin                   # Optional: Zerobrew itself
    /opt/homebrew/bin                   # Homebrew on Apple Silicon (casks, taps, services)
    /opt/homebrew/sbin                  # Homebrew system binaries
    $path                               # Existing system PATH
)

export PATH
