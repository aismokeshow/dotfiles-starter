---
name: ensure-tool-installed
description: Install a single CLI tool using zerobrew-first, homebrew-fallback strategy
disable-model-invocation: true
---

<objective>
Install the requested CLI tool if it is not already present. The tool name is provided as context by the calling agent (e.g. "use ensure-tool-installed for starship").

Strategy: check if installed, try Zerobrew, fall back to Homebrew, verify.
</objective>

<process>
1. **Resolve the binary name.** Some packages install a binary with a different name:
   - `git-delta` → binary is `delta`
   - `ripgrep` → binary is `rg`
   - All others → binary name matches package name

2. **Check if already installed.**
   ```bash
   command -v <binary> &>/dev/null
   ```
   If found, report "already installed" and stop. No further action needed.

3. **Try Zerobrew first.**
   Check if `zb` is available — look in these locations:
   - `command -v zb`
   - `/opt/zerobrew/bin/zb`
   - `~/.local/bin/zb`

   If found, run:
   ```bash
   zb install <package>
   ```
   After install, check PATH directories for the new binary:
   - `/opt/zerobrew/bin/`
   - `/opt/zerobrew/prefix/bin/`
   - `~/.local/bin/`

   If the binary is now reachable, report success and stop.

4. **Fall back to Homebrew.**
   Determine the brew path for this architecture:
   - Apple Silicon (`uname -m` = `arm64`): `/opt/homebrew/bin/brew`
   - Intel (`uname -m` = `x86_64`): `/usr/local/bin/brew`

   If brew is not found at that path, install it:
   ```bash
   NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```
   Then eval shellenv so brew is in PATH:
   ```bash
   eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null)" || eval "$(/usr/local/bin/brew shellenv 2>/dev/null)"
   ```

   Install the tool:
   ```bash
   brew install <package>
   ```

5. **Verify installation.**
   ```bash
   command -v <binary> &>/dev/null
   ```
   If found, report success with which installer was used (zerobrew or homebrew).
   If not found, report failure — the calling agent decides what to do next.
</process>

<rules>
- Never install without checking first — skip if the binary already exists.
- Always try Zerobrew before Homebrew. Zerobrew is faster and lighter.
- Use `NONINTERACTIVE=1` when installing Homebrew — Claude Code runs non-interactively.
- Use absolute paths for brew (`/opt/homebrew/bin/brew` or `/usr/local/bin/brew`) — it may not be in PATH after a fresh install.
- Do not modify shell config files. PATH setup is handled by the calling agent.
- One tool per invocation. The calling agent loops over tools, this skill handles one.
</rules>
