#!/usr/bin/env zsh
# ~/.zshrc — Modular Zsh Configuration (2026 stack)
# Sheldon + Starship + zsh-defer. No Oh My Zsh.

# === Early Init ===
# Claude Code requires high fd limit — use macOS max
ulimit -n unlimited 2>/dev/null || ulimit -n 10240
unsetopt CORRECT
unsetopt CORRECT_ALL

DOTFILES_ZSH="${0:A:h}"  # Directory of this file (follows symlinks)

# === Load Modules (pre-plugin) ===
source "$DOTFILES_ZSH/paths.zsh"
source "$DOTFILES_ZSH/exports.zsh"

# === Sheldon Plugin Manager ===
if command -v sheldon &>/dev/null; then eval "$(sheldon source)"; fi

# === Completions ===
# fpath MUST be set before compinit
fpath=("$HOME/.config/zsh/completions" $fpath)

autoload -Uz compinit && compinit -C

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# === Shell Integrations (cached where possible) ===

# Starship prompt (cached init)
source ~/.cache/zsh/starship.zsh 2>/dev/null || eval "$(starship init zsh)"

# Zoxide (cached init)
source ~/.cache/zsh/zoxide.zsh 2>/dev/null || eval "$(zoxide init zsh)"

# FZF (cached init)
source ~/.cache/zsh/fzf.zsh 2>/dev/null || eval "$(fzf --zsh)"

# Atuin shell history (cached init)
source ~/.cache/zsh/atuin.zsh 2>/dev/null || eval "$(atuin init zsh)"

# mise runtime manager (cached init)
source ~/.cache/zsh/mise.zsh 2>/dev/null || eval "$(mise activate zsh)"

# Bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Ghostty shell integration
if [[ -n $GHOSTTY_RESOURCES_DIR ]]; then
    export GHOSTTY_SHELL_INTEGRATION_NO_SUDO=1
    unalias _ 2>/dev/null || true
    unalias sudo 2>/dev/null || true
    source "$GHOSTTY_RESOURCES_DIR/shell-integration/zsh/ghostty-integration"
fi

# === Deferred Loading (loads after first prompt) ===
# If zsh-defer is available (via Sheldon), defer alias/function loading for faster startup.
# If not (e.g., sheldon failed to install), source immediately so the shell still works.
if (( $+functions[zsh-defer] )); then
    zsh-defer source "$DOTFILES_ZSH/aliases.zsh"
    zsh-defer source "$DOTFILES_ZSH/functions.zsh"
    zsh-defer source ~/.orbstack/shell/init.zsh 2>/dev/null  # OrbStack (optional)
else
    source "$DOTFILES_ZSH/aliases.zsh"
    source "$DOTFILES_ZSH/functions.zsh"
    source ~/.orbstack/shell/init.zsh 2>/dev/null  # OrbStack (optional)
fi

# === Window Title ===
autoload -Uz add-zsh-hook
_set_window_title() { printf '\033]2;%s\007' "${PWD##*/}"; }
add-zsh-hook precmd _set_window_title
