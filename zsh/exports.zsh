#!/usr/bin/env zsh
# exports.zsh — Environment variables

# Editors — Sublime Text preferred, nano as universal fallback
if command -v subl &>/dev/null; then
    export EDITOR='subl -w'
    export VISUAL='subl -w'
else
    export EDITOR='nano'
    export VISUAL='nano'
fi

# Zoxide
export _ZO_DATA_DIR="${HOME}/Library/Application Support/zoxide"
export _ZO_ECHO=1
export _ZO_RESOLVE_SYMLINKS=1
export _ZO_FZF_OPTS="--height 60% --reverse --inline-info --preview 'eza -la {}'"
export _ZO_MAXAGE=10000
export _ZO_EXCLUDE_DIRS="/tmp:/var/folders:/private/tmp:**/.git:**/node_modules:**/dist:**/build:**/out:**/.next:**/.cache:**/__pycache__:**/.venv:**/venv:**/target:**/.mypy_cache:**/.turbo:**/.vercel:**/coverage:**/.pytest_cache:**/.tox:**/.eggs"

# FZF
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --preview-window=right:60%"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always --line-range=:100 {}'"

# Bun
export BUN_INSTALL="$HOME/.bun"

# DYLD_FALLBACK_LIBRARY_PATH intentionally NOT set globally.
# Setting it affects all dynamically-linked binaries and can break system tools.
# If a specific tool needs it, set it per-command: DYLD_FALLBACK_LIBRARY_PATH=/opt/zerobrew/lib command

# Load environment files (separated by security level)
[[ -f ~/.env.public ]] && source ~/.env.public
if [[ -f ~/.env.secrets ]]; then
    if [[ "$(stat -f %A ~/.env.secrets 2>/dev/null)" == "600" ]]; then
        source ~/.env.secrets
    else
        echo "WARN: ~/.env.secrets is not chmod 600 — refusing to source. Run: chmod 600 ~/.env.secrets"
    fi
fi
