Sync the Claude Code setup repository to `~/.claude`.

## Find the repository root

Run:
```bash
readlink ~/.claude/devbackend.md
```

The result is the `devbackend.md` path inside the repo. Strip the trailing `/devbackend.md` component to get `REPO_DIR`.

## Run the installer

```bash
bash "$REPO_DIR/install.sh"
```

## Report

After the installer finishes, list what was synced:
- `~/.claude/CLAUDE.md` — global instructions
- `~/.claude/agents/` — agents
- `~/.claude/skills/` — skills
- `~/.claude/commands/` — commands

If the installer prompted about a conflict, surface it to the user.
