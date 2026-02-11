---
description: Change aliases, paths, prompt, plugins, or exports
---

The user wants to customize their shell configuration. The config files are in the `zsh/` directory:

- `zsh/aliases.zsh` — add, remove, or change aliases
- `zsh/functions.zsh` — add or modify shell functions
- `zsh/exports.zsh` — environment variables
- `zsh/paths.zsh` — PATH ordering
- `zsh/starship.toml` — prompt appearance (Starship config)
- `zsh/sheldon/plugins.toml` — zsh plugins (Sheldon config)

Ask the user what they want to change. Read the relevant file(s) first, then make the edit. After editing:
- Aliases/functions/exports/paths: tell the user to run `source ~/.zshrc` or restart their shell
- Starship: changes apply on the next prompt automatically
- Sheldon plugins: run `sheldon lock` then restart shell

Keep the modular structure. Don't collapse files or move things between modules without good reason.
