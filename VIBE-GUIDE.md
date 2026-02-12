# Vibe Coder's Guide to Your New Terminal

You just installed a bunch of tools you've never heard of. That's fine. This is the only page you need.

Everything below replaces something old and slow with something new and fast. You don't need to configure anything — it's already done. Just learn the commands.

---

## Your New `ls` is `eza`

Shows files with icons, colors, and git status baked in.

```bash
ls              # list files (with icons)
ll              # detailed list with git status per file
la              # show hidden files too
tree            # folder tree view (no more installing tree separately)
```

You'll never think about this. It just looks better.

> **Seeing `?` boxes instead of icons?** The installer configures your terminal font automatically. If icons still show as boxes, set your terminal font to **"JetBrainsMono Nerd Font"** manually, then restart your terminal.

---

## Your New `cat` is `bat`

Shows file contents with syntax highlighting and line numbers.

```bash
bat server.js           # syntax-highlighted output
bat -l json data.txt    # force a language for highlighting
cat server.js           # same thing (aliased)
```

When piping to other commands, it automatically turns off the fancy stuff.

---

## Your New `grep` is `ripgrep`

Searches file contents. Massively faster. Ignores `.git` and `node_modules` automatically.

```bash
rg "useState"                   # find "useState" in all files
rg "TODO" --type js             # only in .js files
rg "password" -i                # case-insensitive
grep "whatever"                 # same thing (aliased to rg)
```

---

## Your New `find` is `fd`

Finds files by name. Simpler syntax than `find`.

```bash
fd server                       # find files matching "server"
fd ".env"                       # find all .env files
fd --type d components          # find directories named "components"
fd --extension tsx               # find all .tsx files
```

Compare: `find . -name "*.tsx" -type f` vs `fd --extension tsx`. That's the whole pitch.

---

## Your New `Ctrl+R` is Atuin

Press `Ctrl+R` and you get a searchable history that knows:
- What directory you ran the command in
- Whether it succeeded or failed
- How long it took
- When you ran it

It syncs across machines. If you ran it on your laptop, you can find it on your desktop.

```bash
atuin register          # first time: create account for sync
atuin login             # on another machine: log in to sync
```

After that, just use `Ctrl+R` like you always did. It's better now.

---

## Your New `cd` is Zoxide

Learns which directories you visit. Jump anywhere by typing a fragment.

```bash
z project               # jumps to ~/dev/my-project (or wherever you go most)
zi                      # interactive: fuzzy-pick from all known dirs
j project               # same as z (alias for muscle memory)
jj                      # same as zi
```

It gets smarter the more you use it. Just `cd` around normally for a day and then start using `z`.

---

## Your Prompt is Starship

That thing on the left of your cursor. It now shows:
- Current directory (truncated so it's not a mile long)
- Git branch and status (dirty files, ahead/behind)
- Language versions (only when relevant — Python version in a Python project, etc.)
- How long the last command took (if over 2 seconds)

You don't configure this. It just works. If you want to tweak it later, edit `zsh/starship.toml`.

---

## Your Runtime Manager is mise

Manages Python, Node, and other language versions. One tool replaces nvm, pyenv, and asdf.

```bash
mise use python@3.12        # switch python version (installs if needed)
mise use node@20            # switch node version
mise list                   # see what's installed
mise install                # install everything in config file
```

Per-project versions: drop a `.mise.toml` in any project folder.

```toml
[tools]
node = "20"
python = "3.11"
```

Walk into that directory and you're on those versions. Walk out and you're back to defaults.

---

## Your New `pip` is uv

Installs Python packages and manages virtual environments. Absurdly fast.

```bash
uv init                     # start a new Python project
uv add requests             # add a dependency (creates venv automatically)
uv run python3 script.py    # run a script in the project's venv
uv pip install flask        # classic pip-style install (but 10-100x faster)
```

You never manually create venvs. `uv` handles it. You never `pip freeze > requirements.txt`. `uv` tracks deps in `pyproject.toml` automatically.

---

## Fuzzy Finding with fzf

`fzf` powers the interactive pickers behind many commands. Standalone:

```bash
pp              # pick a project from ~/dev and jump to it
fe              # find a file and open it in your editor
fo              # find a file and open it with default app
fcd             # fuzzy cd to any directory
Ctrl+T          # paste a file path into your current command
Ctrl+R          # search history (now powered by Atuin)
```

In any fzf picker: type to filter, arrow keys to navigate, enter to select.

---

## Password Generation

```bash
pw              # 32 character clean password
pw16            # 16 character clean password
pwr             # 32 bytes raw base64 (includes =+/ chars)
pwx             # 32 chars with special characters
```

Copy from terminal, paste wherever.

---

## Quick Reference Card

| I want to... | Type this |
|---|---|
| List files | `ls` or `ll` |
| Read a file | `cat filename` or `bat filename` |
| Search in files | `rg "search term"` |
| Find a file | `fd filename` |
| Jump to a project | `z projectname` or `pp` |
| Pick a directory | `jj` |
| Search command history | `Ctrl+R` |
| Switch Node version | `mise use node@20` |
| Switch Python version | `mise use python@3.12` |
| Check what's on a port | `whatsup` |
| Kill port 3000 | `k3k` |
| Generate a password | `pw` |
| Check everything works | `checkhealth` |
| Refresh tool caches | `regen-cache` |

---

## Something Broken?

Run `checkhealth`. It tells you exactly what's missing or misconfigured.

Run `regen-cache` if tools were recently upgraded and the shell feels stale.

Beyond that — these tools have been vetted. Trust them. Use them for a week and you won't go back.
