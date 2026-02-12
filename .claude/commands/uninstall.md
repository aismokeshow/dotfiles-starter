---
description: Unlink config and restore previous .zshrc
---

Remove the dotfiles-starter configuration and restore the user's shell to a clean state.

Steps:

1. **Verify ~/.zshrc is a symlink before removing:**
```bash
if [[ -L "$HOME/.zshrc" ]]; then
    rm "$HOME/.zshrc"
else
    echo "WARNING: ~/.zshrc is not a symlink — it may have been modified manually."
    echo "Back it up before proceeding."
fi
```
Do NOT run `rm ~/.zshrc` unless it's confirmed to be a symlink.

2. Restore backup if one exists: `ls ~/.zshrc.pre-dotfiles.* 2>/dev/null` — if found, offer to restore the most recent one with `mv`.

3. If no backup exists, create a working default .zshrc:
```bash
cat > ~/.zshrc << 'EOF'
# Minimal zsh configuration (restored after dotfiles-starter uninstall)

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null)" || eval "$(/usr/local/bin/brew shellenv 2>/dev/null)" || true

# User binaries
export PATH="$HOME/.local/bin:$PATH"

# Basic aliases
alias ls='ls -G'
alias ll='ls -la'
alias grep='grep --color=auto'
EOF
```

4. Remove config symlinks (verify they're symlinks first):
```bash
[[ -L ~/.config/starship.toml ]] && rm ~/.config/starship.toml
[[ -L ~/.config/sheldon/plugins.toml ]] && rm ~/.config/sheldon/plugins.toml
```

5. Restore or remove ~/.zprofile:
```bash
if [[ -f ~/.zprofile ]] && grep -q "CLI tools PATH setup" ~/.zprofile 2>/dev/null; then
    # Check for backup
    if ls ~/.zprofile.pre-dotfiles.* 2>/dev/null; then
        echo "Found .zprofile backup(s). Restore with: mv ~/.zprofile.pre-dotfiles.TIMESTAMP ~/.zprofile"
    else
        rm ~/.zprofile
        echo "Removed dotfiles-starter .zprofile (no backup found)"
    fi
fi
```

6. Clean up cached init scripts:
```bash
rm -rf ~/.cache/zsh/
echo "Removed cached shell init scripts"
```

7. **Cross-project check — aerospace-starter boom alias:**
If `~/.config/aerospace` exists and is a symlink (aerospace-starter is installed), check whether the restored/default .zshrc contains `alias boom=`. If not, tell the user: "Your aerospace-starter `boom` alias was in the dotfiles-managed .zshrc and is now gone. Run `/install` in your aerospace-starter folder to re-add it, or add this line to your .zshrc: `alias boom='~/.config/aerospace/boom.sh'`"

8. Tell the user: "Dotfiles-starter has been unlinked. Your shell will use the restored/default .zshrc on next launch. The tools (eza, bat, ripgrep, etc.) are still installed — this only removes the config. Run `source ~/.zshrc` or restart your terminal."

Do NOT uninstall the tools themselves (eza, bat, starship, etc.) unless the user explicitly asks.
Do NOT delete the dotfiles-starter folder — the user may want to reinstall later.
