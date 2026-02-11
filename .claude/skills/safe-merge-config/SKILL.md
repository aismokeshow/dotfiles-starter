---
name: safe-merge-config
description: Safely modify config files without destructive overwrites. Supports symlink replacement, line injection, and write-if-missing patterns.
disable-model-invocation: true
---

<objective>
Modify a user's config file using one of three modes. The cardinal rule: NEVER silently discard content. If existing content will be lost, enumerate every line and ask before proceeding.
</objective>

<process>
Determine which mode to use based on the caller's intent, then follow that mode's procedure exactly.

## Mode 1: SYMLINK

Replace a file with a symlink to a repo-managed version.

1. **Check current state.** If the target is already a symlink pointing to the intended source, report "already configured" and stop.
2. **If the target exists (file, not correct symlink):**
   a. Read the entire file.
   b. Read the intended symlink source file.
   c. Diff them. Identify every line in the existing file that is NOT in the source — these are **user customizations** (aliases, exports, source lines, functions, comments).
   d. Scan for **sibling project artifacts** — lines added by other aismokeshow starters (e.g., `alias boom=`, aerospace PATH entries, statusline hooks). List them by project name.
   e. Report to the user:
      - "These lines exist in your current file but NOT in the new config:"
      - List every such line, grouped: user customizations vs. sibling project lines.
      - "These will be lost when I replace the file with a symlink."
   f. **Ask**: "Should I proceed? You can also say 'merge first' and I'll append your custom lines to the source file before symlinking."
   g. **Wait for explicit confirmation.** Do not proceed without it.
3. **Create timestamped backup:**
   ```
   cp <target> <target>.pre-dotfiles.YYYYMMDD-HHMMSS
   ```
4. **Replace with symlink:**
   ```
   ln -sfn <source> <target>
   ```
5. **Report:** State what was backed up, what the symlink points to, and remind the user where the backup is.

## Mode 2: ENSURE-LINES

Ensure specific lines exist in a file without replacing it. Used for PATH entries, source lines, or env vars (e.g., .zprofile).

1. **If the file does not exist:** Create it with the required lines. Report what was written. Done.
2. **Read the existing file.**
3. **For each required line:** Check if it already exists (exact match or semantic match — e.g., same export with different value counts as a match worth flagging).
4. **If all lines already present:** Report "already configured" and stop.
5. **Create timestamped backup** (same format as SYMLINK mode).
6. **Append only the missing lines** to the end of the file. Never remove or reorder existing content.
7. **Report:** List exactly which lines were appended and which were already present.

## Mode 3: WRITE-IF-MISSING

Write a file only if it does not exist. Used for initial configs (e.g., mise config.toml).

1. **If the file does not exist:** Write it with the provided content. Report what was written. Done.
2. **If the file exists:**
   a. Read and display its current contents.
   b. Compare with the intended content. Highlight differences.
   c. **Ask the user:** "This file already exists with different content. Options: (a) skip — keep yours, (b) merge — I'll combine both, (c) replace — overwrite with the new version (backup created first)."
   d. **Wait for explicit response.** Do not default to any option.
   e. If replace: create timestamped backup first, then write.
   f. If merge: create timestamped backup, then produce merged content and show it to user for approval before writing.
</process>

<modes>
| Mode | Use When | Example |
|------|----------|---------|
| SYMLINK | A repo file should be the canonical version | .zshrc → repo/zsh/.zshrc |
| ENSURE-LINES | Specific lines must exist but file stays user-owned | PATH entries in .zprofile |
| WRITE-IF-MISSING | Initial config that user may have customized | ~/.config/mise/config.toml |
</modes>

<rules>
1. **Never silently discard content.** If ANY existing content will be lost or overwritten, enumerate it line-by-line and ask the user before proceeding.
2. **Always back up before modifying.** Format: `.<filename>.pre-dotfiles.YYYYMMDD-HHMMSS` in the same directory as the target. Use the actual current timestamp.
3. **Symlinks use `ln -sfn`** — the `-n` flag prevents nested symlinks when the target is an existing symlink to a directory.
4. **Report every action.** After each modification, state: what was backed up, what changed, and what the user should check.
5. **Never guess the mode.** The caller (install procedure or agent) must specify which mode to use. If ambiguous, ask.
6. **Idempotent.** Running the same operation twice should detect "already configured" and skip, not create duplicates or redundant backups.
</rules>
