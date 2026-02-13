#!/usr/bin/env zsh
# exports.zsh — Environment variables

# Default editor (override in your shell if you prefer something else)
export EDITOR='nano'
export VISUAL='nano'

# Zoxide
export _ZO_DATA_DIR="${HOME}/Library/Application Support/zoxide"
export _ZO_ECHO=1
export _ZO_RESOLVE_SYMLINKS=1
export _ZO_FZF_OPTS="--height 60% --reverse --inline-info --preview 'eza -la {}'"
export _ZO_MAXAGE=10000
export _ZO_EXCLUDE_DIRS="/tmp:/var/folders:**/.git:**/node_modules:**/.cache"

# FZF
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --preview-window=right:60%"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always --line-range=:100 {}'"

# DYLD_FALLBACK_LIBRARY_PATH intentionally NOT set globally.
# Setting it affects all dynamically-linked binaries and can break system tools.
# If a specific tool needs it, set it per-command: DYLD_FALLBACK_LIBRARY_PATH=/opt/homebrew/lib command

