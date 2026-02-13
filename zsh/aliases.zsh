#!/usr/bin/env zsh
# aliases.zsh — All aliases
# See ALIAS-CHANGES.md for what changed from a typical Oh My Zsh setup

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

# === Editors ===
alias c='${EDITOR:-nano} .'

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

# === MCP Server Management ===
alias mcp-ls='claude mcp list'
