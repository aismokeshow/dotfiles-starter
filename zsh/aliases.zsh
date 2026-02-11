#!/usr/bin/env zsh
# aliases.zsh — All aliases
# See ALIAS-CHANGES.md for what changed from a typical Oh My Zsh setup

# === Package Managers ===
# Both available: `zb` for fast CLI tool installs, `brew` for casks, taps, and services.

# === Zsh Config ===
alias zc='${EDITOR:-nano} ~/.zshrc'
alias zr="source ~/.zshrc && echo 'Zsh config reloaded'"

# === Modern CLI Replacements ===
alias ls='eza --icons --group-directories-first'
alias ll='eza -la --icons --group-directories-first --git'
alias la='eza -a --icons --group-directories-first'
alias l='eza --icons --group-directories-first'
alias tree='eza --tree --icons'
alias cat='bat --plain'
alias grep='rg'

# === Navigation ===
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# === Safety ===
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# === Ports ===
alias ports='lsof -i -P -n | command grep LISTEN'
alias whatsup='lsof -i -P -n | command grep LISTEN'
alias k3='for p in {3000..3009}; do lsof -ti:$p &>/dev/null && killport $p; done'
alias k3000='killport 3000'
alias k3001='killport 3001'
alias k3002='killport 3002'
alias k3003='killport 3003'
alias k3k='killport 3000'
alias killnodes='pkill -f "node_modules/.bin|next-server|next dev|next start|ts-node|tsx" && echo "Force killed Node processes"'

# === Next.js ===
alias knx="pgrep -f 'next dev|next start|next-server' | xargs kill -9 2>/dev/null; rm -rf .next node_modules/.cache && echo 'Next.js processes killed and cache cleared'"

# === Editors ===
alias c='${EDITOR:-nano} .'

# === Yazi (shell cd-on-exit wrapper) ===
function yazi() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    command yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

# === Password Generation ===
alias pw='openssl rand -base64 32 | tr -d "=+/" | cut -c1-32'
alias pw16='openssl rand -base64 16 | tr -d "=+/" | cut -c1-16'
alias pwr='openssl rand -base64 32'
alias pwx='LC_ALL=C tr -dc "A-Za-z0-9!@#$%^&*" < /dev/urandom | head -c 32; echo'

# === FZF Navigation ===
alias pp='cd "$(fd --type d --max-depth 2 . ~/dev | fzf --prompt="Pick Project> ")"'
alias fe='${EDITOR:-nano} "$(fzf --prompt="Edit File> " --preview "bat --style=numbers --color=always --line-range=:50 {}")"'
alias fo='open "$(fzf --prompt="Open File> ")"'

# === Zoxide Shortcuts ===
alias j='z'
alias ji='zi'
alias jj='zi'
alias zq='zoxide query'
alias zl='zoxide query -l'
alias zs='zoxide query -ls'
alias zrm='zoxide remove'

# === MCP Server Management ===
alias mcp-ls='claude mcp list'
