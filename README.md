<div align="center">

# AISMOKESHOW Dotfiles Starter

**A modern shell config that just works.**

Drop Oh My Zsh. Get [Zerobrew](https://github.com/lucasgelfond/zerobrew), [Starship](https://starship.rs), [Sheldon](https://sheldon.cli.rs), and 12 modern CLI tools — configured, cached, and ready to go.

<p>
  <img src="https://img.shields.io/github/license/aismokeshow/dotfiles-starter?style=flat-square&labelColor=000&color=ff9500" alt="MIT License">
  &nbsp;
  <img src="https://img.shields.io/badge/macOS-only-000?style=flat-square&logo=apple&logoColor=fff" alt="macOS only">
  &nbsp;
  <img src="https://img.shields.io/badge/zsh-2026_stack-000?style=flat-square&logo=gnubash&logoColor=ff9500" alt="zsh 2026 stack">
  &nbsp;
  <img src="https://img.shields.io/github/last-commit/aismokeshow/dotfiles-starter?style=flat-square&labelColor=000&color=555" alt="Last commit">
</p>

516-line monolithic .zshrc → modular config across 7 files. Sub-50ms startup. Every tool is best-in-class 2026.

</div>

---

<p align="center">
  <a href="#install">Install</a> ·
  <a href="#why-this-exists">Why This Exists</a> ·
  <a href="#what-you-get">What You Get</a> ·
  <a href="#works-with">Works With</a> ·
  <a href="#faq">FAQ</a>
</p>

## Install

Open [Claude Code](https://github.com/anthropics/claude-code) and paste:

```
Install this on my Mac → https://github.com/aismokeshow/dotfiles-starter
```

That's it. Claude handles [Zerobrew](https://github.com/lucasgelfond/zerobrew), 12 CLI tools, plugin configuration, cached init scripts, and symlinks your config. [Homebrew](https://brew.sh) is installed as a fallback if any tool fails via Zerobrew. The only manual step is running `source ~/.zshrc` when it's done.

> [!TIP]
> **Already cloned the repo?** Open Claude Code in the repo folder and type `/install`.

<details>
<summary><strong>Manual install</strong></summary>

```bash
mkdir -p ~/.aismokeshow
git clone https://github.com/aismokeshow/dotfiles-starter.git ~/.aismokeshow/dotfiles-starter
cd ~/.aismokeshow/dotfiles-starter
claude
# then say "install this"
```

</details>

**Three slash commands** — everything you need after install:

| Command | What it does |
|---|---|
| `/install` | Full setup — Zerobrew + Homebrew, 12 tools, config, symlinks |
| `/customize` | Change aliases, paths, prompt, plugins, or exports |
| `/uninstall` | Unlink config and restore previous .zshrc |

> [!WARNING]
> This project tells Claude Code to run shell commands on your Mac. Only clone from the [official repo](https://github.com/aismokeshow/dotfiles-starter) — forks can modify the instructions Claude follows. Review the `CLAUDE.md` and `.claude/` directory before running `/install` if you're using a fork.

## Why This Exists

Oh My Zsh was great in 2020. It's 2026 now and we have better tools.

The typical Oh My Zsh setup loads ~100 files on every shell start. It uses `eval` for every integration. It ships a framework you don't need just to get some aliases and a prompt theme. The result: 200-400ms startup, a pile of files you'll never touch, and no way to know what's actually running.

This config replaces all of that with purpose-built Rust tools: [Starship](https://starship.rs) for the prompt (~10ms render), [Sheldon](https://sheldon.cli.rs) for plugins (4 plugins, 3 deferred via [zsh-defer](https://github.com/romkatv/zsh-defer)), and cached init scripts that skip `eval` entirely. The result is ~440 lines across 7 modular files, sub-50ms startup (after initial cache generation), and every tool is the current best-in-class.

## What You Get

### 12 Modern CLI Tools

| Role | Old | New |
|------|-----|-----|
| File listing | `ls` | [eza](https://github.com/eza-community/eza) — icons, git status, tree view |
| File viewing | `cat` | [bat](https://github.com/sharkdp/bat) — syntax highlighting, auto-paging |
| Search | `grep` | [ripgrep](https://github.com/BurntSushi/ripgrep) — 10-100x faster, .gitignore-aware |
| Find files | `find` | [fd](https://github.com/sharkdp/fd) — simpler syntax, faster |
| Shell history | `Ctrl+R` | [Atuin](https://github.com/atuinsh/atuin) — SQLite, encrypted sync, context-aware |
| Directory jumping | `cd` | [zoxide](https://github.com/ajeetdsouza/zoxide) — frecency-based, learns your habits |
| Prompt | robbyrussell | [Starship](https://starship.rs) — Rust, <10ms, git/language/duration info |
| Plugins | Oh My Zsh | [Sheldon](https://sheldon.cli.rs) — Rust, TOML config, deferred loading |
| Runtimes | nvm/pyenv | [mise](https://github.com/jdx/mise) — one tool for Python, Node, and more |
| Python packages | pip | [uv](https://github.com/astral-sh/uv) — 10-100x faster, automatic venvs |
| Git diffs | default | [delta](https://github.com/dandavison/delta) — syntax highlighting, side-by-side |
| Fuzzy finder | — | [fzf](https://github.com/junegunn/fzf) — powers `pp`, `fe`, `Ctrl+T`, and more |

### Modular Config

7 files instead of one 500-line monolith:

```
zsh/
├── .zshrc          # Entry point — 77 lines
├── exports.zsh     # Environment variables
├── paths.zsh       # PATH ordering (Zerobrew + mise + Homebrew)
├── aliases.zsh     # Modern CLI replacements + utilities
├── functions.zsh   # checkhealth, regen-cache, killport, etc.
├── starship.toml   # Prompt config
└── sheldon/
    └── plugins.toml # 4 plugins, 3 deferred
```

### Cached Init Scripts

[Starship](https://starship.rs), [zoxide](https://github.com/ajeetdsouza/zoxide), [fzf](https://github.com/junegunn/fzf), [Atuin](https://github.com/atuinsh/atuin), and [mise](https://github.com/jdx/mise) all generate shell init code. Instead of running `eval "$(starship init zsh)"` on every shell start, this config caches the output in `~/.cache/zsh/` and sources the file. Run `regen-cache` after upgrading any of these tools.

### Zerobrew + Homebrew

[Zerobrew](https://github.com/lucasgelfond/zerobrew) installs CLI tools from homebrew-core 2-20x faster than Homebrew. All 12 tools install through `zb` first, falling back to `brew` if needed. Both coexist: `zb` for speed on CLI tools, `brew` for casks (macOS apps), taps, and services.

<a id="works-with"></a>
## Works With Other Starters

This config is designed to pair with two other aismokeshow starters:

| Starter | What it adds | Interaction |
|---|---|---|
| [aerospace-starter](https://github.com/aismokeshow/aerospace-starter) | Tiling window manager — F1 toggles workspaces | Adds one `boom` alias to your `.zshrc` |
| [statusline-starter](https://github.com/aismokeshow/statusline-starter) | Claude Code statusline with context tracking | Zero interaction — runs via `~/.claude/settings.json` |

**Install order doesn't matter.** Each project detects the others and adapts. If you install dotfiles-starter after aerospace-starter, just re-run `/install` in the aerospace folder to restore the `boom` alias. Together they give you: a modern shell, tiled windows, and live Claude Code context tracking — all opinionated, all working out of the box.

<details>
<summary><strong>What does /install change on my Mac?</strong></summary>

The install process makes these changes (Claude asks before each one):

- **Installs [Zerobrew](https://github.com/lucasgelfond/zerobrew)** — fast installer for homebrew-core CLI tools
- **Installs [Homebrew](https://brew.sh)** if needed — fallback when a tool fails via Zerobrew, or if you provide a Brewfile
- **Installs 12 CLI tools** — Starship, Sheldon, fzf, zoxide, eza, bat, ripgrep, fd, Atuin, mise, delta, uv
- **Configures [Sheldon](https://sheldon.cli.rs)** with 4 plugins — zsh-defer, autosuggestions, history-substring-search, syntax-highlighting
- **Symlinks `~/.zshrc`** to the modular config in this folder (backs up existing .zshrc)
- **Writes `~/.zprofile`** with Zerobrew + Homebrew PATH setup (backs up existing)
- **Caches init scripts** in `~/.cache/zsh/` for fast startup
- **Sets up [mise](https://github.com/jdx/mise)** with Python 3.11 + Node LTS

`/uninstall` reverses the symlinks and restores your previous config.

</details>

<a id="faq"></a>
## FAQ

**Do I need to know terminal stuff?**
No. The install is fully automated. After install, read `VIBE-GUIDE.md` — it explains every tool in plain English with examples.

**What if I already have a .zshrc?**
It gets backed up to `~/.zshrc.pre-dotfiles.<timestamp>`. You can restore it anytime with `/uninstall`.

**Can I bring my own Brewfile?**
Yes. Drop a `Brewfile` in the repo root before running `/install`. The install agent will detect it and install everything via `brew bundle`.

**How fast is the shell startup?**
Target is sub-50ms after caches are generated (run `regen-cache`). First launch after install will be slower (~200-400ms) while init scripts are cached. After that, cached init scripts skip ~200ms of `eval` time, and [zsh-defer](https://github.com/romkatv/zsh-defer) loads aliases and functions after the first prompt renders.

**Can I run `/install` multiple times?**
Yes, it's idempotent. It skips tools that are already installed and only backs up config files on first run.

**Can I still use Homebrew?**
Yes. Both `brew` and `zb` work side by side. Zerobrew handles homebrew-core CLI tools faster; Homebrew handles casks (macOS apps), taps, `brew bundle`, and `brew services`.

## License

[MIT](LICENSE)

---

<p align="center"><sub>built by <a href="https://www.aismokeshow.com/">aismokeshow</a> · where there's shell, there's smoke</sub></p>
