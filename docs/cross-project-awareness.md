# Cross-Project Awareness

Read this before modifying any shell configuration files.

Other aismokeshow starter packs may have written config into the user's environment. Before the install agent edits shell rc files or Claude Code settings, it must check for these artifacts and preserve them.

Only act on projects that are detected as installed. If a project is not detected, skip it entirely.

---

## 1. aerospace-starter

AeroSpace tiling window manager for macOS.

**Detection:**
- `~/.config/aerospace` exists and is a symlink
- `~/.config/aerospace/boom.sh` exists

**Artifacts to preserve:**
- `alias boom='~/.config/aerospace/boom.sh'` in `~/.zshrc` (or equivalent in `~/.bashrc` / `~/.config/fish/config.fish`)
- The comment `# AeroSpace config reload` on the line above the alias

**Action if detected:**
- When replacing or regenerating the user's shell rc file, scan the backed-up original for lines matching `alias boom=` and copy them into the new file.
- If the alias was lost (present in backup but not in new config), inform the user: "Your `boom` alias from aerospace-starter was preserved."
- If the alias is missing from both old and new config, inform the user they can restore it by running `/install` inside their aerospace-starter folder.

---

## 2. statusline-starter

SMOKE two-line statusline for Claude Code.

**Detection:**
- `~/.claude/statusline-smoke.py` exists

**Artifacts to preserve:**
- The `statusLine` key in `~/.claude/settings.json`:
  ```json
  "statusLine": {
    "type": "command",
    "command": "python3 ~/.claude/statusline-smoke.py",
    "padding": 1
  }
  ```

**Action if detected:**
- Do not modify or remove the `statusLine` field in `settings.json`.
- Inform the user: "Your SMOKE statusline is still active. It works independently of the shell config."

---

## 3. curator-starter

Project curator agent for sourcing Claude Code tips and content.

**Detection:**
- `~/.claude/agents/project-curator.md` exists (may be a symlink)

**Artifacts to preserve:**
- The symlink or file at `~/.claude/agents/project-curator.md`
- The symlink or file at `~/.claude/commands/curate.md`

**Action if detected:**
- Do not delete or overwrite anything in `~/.claude/agents/` or `~/.claude/commands/`.
- No shell config artifacts to worry about — curator does not modify rc files.

---

## 4. extreme-ownership

Extreme Ownership skill for Claude Code — breaks hedging and looping patterns.

**Detection:**
- `~/.claude/skills/extreme-ownership/SKILL.md` exists

**Artifacts to preserve:**
- The entire `~/.claude/skills/extreme-ownership/` directory

**Action if detected:**
- Do not delete or overwrite anything in `~/.claude/skills/`.
- No shell config artifacts to worry about — extreme-ownership does not modify rc files.
