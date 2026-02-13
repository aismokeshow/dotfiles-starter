#!/usr/bin/env zsh
# functions.zsh — Shell functions

# --- Init Cache Regeneration ---
# Run after installing/upgrading starship, zoxide, fzf, atuin, or mise

regen-cache() {
    mkdir -p ~/.cache/zsh
    echo "Regenerating shell init caches..."
    command -v starship &>/dev/null && starship init zsh > ~/.cache/zsh/starship.zsh
    command -v zoxide &>/dev/null   && zoxide init zsh   > ~/.cache/zsh/zoxide.zsh
    command -v fzf &>/dev/null      && fzf --zsh         > ~/.cache/zsh/fzf.zsh
    command -v atuin &>/dev/null    && atuin init zsh    > ~/.cache/zsh/atuin.zsh
    command -v mise &>/dev/null     && mise activate zsh > ~/.cache/zsh/mise.zsh
    echo "Done. Restart shell or: source ~/.zshrc"
}

# --- Claude Code Convenience ---

smoke() {
    claude --dangerously-skip-permissions "$@"
}

# --- Port Management ---

killport() {
    if [[ -z "$1" ]]; then
        echo "Usage: killport <port>" >&2
        return 1
    fi
    local port="$1"
    local -a pids=("${(@f)$(lsof -ti:"$port" 2>/dev/null)}")
    pids=(${pids:#})
    if (( ${#pids} == 0 )); then
        echo "Port $port already free"
        return 0
    fi
    echo "Stopping process on port $port (PID: ${pids[*]})..."
    kill "${pids[@]}" 2>/dev/null
    sleep 2
    if lsof -ti:"$port" &>/dev/null; then
        echo "Force killing..."
        kill -9 ${(@f)$(lsof -ti:"$port")} 2>/dev/null
        sleep 0.5
    fi
    if lsof -ti:"$port" &>/dev/null; then
        echo "Failed to clear port $port"
        return 1
    else
        echo "Port $port cleared"
        return 0
    fi
}

checkport() {
    local port=${1:-3000}
    lsof -i :"$port" 2>/dev/null || echo "Port $port is free"
}
# --- FZF Navigation ---

fif() {
    rg "$1" . 2>/dev/null | fzf --preview 'echo {}' --preview-window=down:3
}

fcd() {
    local dir
    dir=$(fd --type d . ${1:-$HOME} 2>/dev/null | fzf --prompt="Jump to Dir> ") && cd "$dir"
}

fcdd() {
    local dir
    dir=$(fd --type d . ${1:-.} 2>/dev/null | fzf --prompt="Jump from here> ") && cd "$dir"
}

fzfp() {
    fzf --preview 'bat --style=numbers --color=always {}' --preview-window=right:60%
}

# --- Zoxide Helpers ---

zclean() {
    local removed=0
    local dirs=("${(@f)$(zoxide query -l)}")
    for dir in "${dirs[@]}"; do
        if [[ ! -d "$dir" ]]; then
            zoxide remove "$dir" 2>/dev/null
            ((removed++))
        fi
    done
    echo "Zoxide database cleaned: $removed entries removed"
}

# --- System Health ---

checkhealth() {
    echo "System Health Check:"
    echo "-------------------"
    command -v starship &>/dev/null  && echo "OK Starship"      || echo "MISSING Starship"
    command -v sheldon &>/dev/null   && echo "OK Sheldon"       || echo "MISSING Sheldon"
    command -v fzf &>/dev/null       && echo "OK FZF"           || echo "MISSING FZF"
    command -v zoxide &>/dev/null    && echo "OK Zoxide"        || echo "MISSING Zoxide"
    command -v atuin &>/dev/null     && echo "OK Atuin"         || echo "MISSING Atuin"
    command -v mise &>/dev/null      && echo "OK mise"          || echo "MISSING mise"
    command -v eza &>/dev/null       && echo "OK eza"           || echo "MISSING eza"
    command -v bat &>/dev/null       && echo "OK bat"           || echo "MISSING bat"
    command -v rg &>/dev/null        && echo "OK ripgrep"       || echo "MISSING ripgrep"
    command -v fd &>/dev/null        && echo "OK fd"            || echo "MISSING fd"
    if command -v delta &>/dev/null; then
        echo "OK delta"
        [[ "$(git config --global core.pager 2>/dev/null)" == "delta" ]] && echo "OK delta (git pager)" || echo "HINT run: git config --global core.pager delta"
    else
        echo "MISSING delta"
    fi
    command -v uv &>/dev/null        && echo "OK uv"            || echo "MISSING uv"
    echo "\nInit Caches:"
    for f in starship zoxide fzf atuin mise; do
        [[ -f ~/.cache/zsh/$f.zsh ]] && echo "OK $f cached" || echo "STALE $f (run: regen-cache)"
    done
}

# --- Yazi (shell cd-on-exit wrapper) ---
# Install: brew install yazi
if command -v yazi &>/dev/null; then
    yazi() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
        command yazi "$@" --cwd-file="$tmp"
        if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
            builtin cd -- "$cwd"
        fi
        rm -f -- "$tmp"
    }
fi

# --- MCP Server Management ---

mcp-info() { claude mcp get "$1"; }
mcp-rm()   { claude mcp remove -s project "$1"; }
