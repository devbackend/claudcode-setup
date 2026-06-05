#!/usr/bin/env bash

# Claude Code Setup - Installation Script
# This script creates symlinks from this repository to ~/.claude directory
# Run this script after git clone or git pull on a new machine

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "🔧 Claude Code Setup Installer"
echo "Repository: $REPO_DIR"
echo "Target: $CLAUDE_DIR"
echo ""

# Create ~/.claude directory if it doesn't exist
mkdir -p "$CLAUDE_DIR"

# Function to create or update symlink
create_symlink() {
    local source="$1"
    local target="$2"
    local name="$3"

    # Check if target exists and is a symlink
    if [ -L "$target" ]; then
        echo "  ✓ Symlink already exists: $name"
        # Update symlink to point to current repo location
        ln -snf "$source" "$target"
    # Check if target exists but is not a symlink (real directory/file)
    elif [ -e "$target" ]; then
        echo "  ⚠️  Warning: $target already exists and is not a symlink"
        read -p "  Do you want to backup and replace it? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            mv "$target" "${target}.backup.$(date +%Y%m%d_%H%M%S)"
            echo "  📦 Backed up to ${target}.backup.*"
            ln -s "$source" "$target"
            echo "  ✅ Created symlink: $name"
        else
            echo "  ⏭️  Skipped: $name"
        fi
    else
        ln -s "$source" "$target"
        echo "  ✅ Created symlink: $name"
    fi
}

# Symlink iterm-focus.sh
if [ -f "$REPO_DIR/iterm-focus.sh" ]; then
    echo "🔗 Linking iterm-focus.sh..."
    chmod +x "$REPO_DIR/iterm-focus.sh"
    create_symlink "$REPO_DIR/iterm-focus.sh" "$CLAUDE_DIR/iterm-focus.sh" "iterm-focus.sh"
fi

# Symlink devbackend.md and ensure CLAUDE.md includes it
if [ -f "$REPO_DIR/devbackend.md" ]; then
    echo "📄 Linking devbackend.md..."
    create_symlink "$REPO_DIR/devbackend.md" "$CLAUDE_DIR/devbackend.md" "devbackend.md"
    if [ ! -f "$CLAUDE_DIR/CLAUDE.md" ]; then
        echo "@devbackend.md" > "$CLAUDE_DIR/CLAUDE.md"
        echo "  ✅ Created CLAUDE.md with @devbackend.md"
    elif ! grep -q "@devbackend.md" "$CLAUDE_DIR/CLAUDE.md"; then
        echo "@devbackend.md" >> "$CLAUDE_DIR/CLAUDE.md"
        echo "  ✅ Added @devbackend.md to existing CLAUDE.md"
    else
        echo "  ✓ CLAUDE.md already includes @devbackend.md"
    fi
fi

# Symlink individual agents (preserves agents from other sources)
if [ -d "$REPO_DIR/agents" ]; then
    echo "📁 Linking agents..."
    mkdir -p "$CLAUDE_DIR/agents"
    for agent_dir in "$REPO_DIR/agents"/*/; do
        agent_name="$(basename "$agent_dir")"
        create_symlink "$agent_dir" "$CLAUDE_DIR/agents/$agent_name" "agents/$agent_name"
    done
fi

# Symlink individual skills (preserves skills from other sources)
if [ -d "$REPO_DIR/skills" ]; then
    echo "📁 Linking skills..."
    mkdir -p "$CLAUDE_DIR/skills"
    for skill_dir in "$REPO_DIR/skills"/*/; do
        skill_name="$(basename "$skill_dir")"
        create_symlink "$skill_dir" "$CLAUDE_DIR/skills/$skill_name" "skills/$skill_name"
    done
fi

# Symlink individual commands (preserves commands from other sources)
if [ -d "$REPO_DIR/commands" ]; then
    echo "📁 Linking commands..."
    mkdir -p "$CLAUDE_DIR/commands"
    for cmd_file in "$REPO_DIR/commands"/*.md; do
        [ -e "$cmd_file" ] || continue
        cmd_name="$(basename "$cmd_file")"
        create_symlink "$cmd_file" "$CLAUDE_DIR/commands/$cmd_name" "commands/$cmd_name"
    done
fi

# Symlink individual examples (preserves examples from other sources)
if [ -d "$REPO_DIR/examples" ]; then
    echo "📁 Linking examples..."
    mkdir -p "$CLAUDE_DIR/examples"
    for example_file in "$REPO_DIR/examples"/*; do
        [ -e "$example_file" ] || continue
        example_name="$(basename "$example_file")"
        create_symlink "$example_file" "$CLAUDE_DIR/examples/$example_name" "examples/$example_name"
    done
fi

# Merge settings.json
if [ -f "$REPO_DIR/settings.json" ]; then
    echo "⚙️  Merging settings.json..."
    python3 - "$REPO_DIR/settings.json" "$CLAUDE_DIR/settings.json" <<'PYEOF'
import json, sys, os

repo_path = sys.argv[1]
global_path = sys.argv[2]

with open(repo_path) as f:
    repo = json.load(f)

if os.path.exists(global_path):
    with open(global_path) as f:
        glob = json.load(f)
else:
    glob = {}

# --- Scalar fields ---
SCALAR_KEYS = [k for k in repo if k != 'hooks']
for key in SCALAR_KEYS:
    repo_val = repo[key]
    if key not in glob:
        glob[key] = repo_val
        print(f'  ✅ Added {key}: {repo_val}')
    elif glob[key] == repo_val:
        print(f'  ✓ {key} already set: {glob[key]}')
    else:
        print(f'  ⚠️  Conflict: {key} = {glob[key]!r} (global) vs {repo_val!r} (repo)')
        answer = input(f'  Overwrite with {repo_val!r}? (y/N): ').strip().lower()
        if answer == 'y':
            glob[key] = repo_val
            print(f'  ✅ Updated {key}: {repo_val}')
        else:
            print(f'  ⏭️  Kept existing {key}: {glob[key]}')

# --- Hooks (deep merge, dedup by exact command string) ---
repo_hooks = repo.get('hooks', {})
if repo_hooks:
    glob_hooks = glob.setdefault('hooks', {})
    for event, repo_matchers in repo_hooks.items():
        glob_matchers = glob_hooks.setdefault(event, [])
        # Collect all existing commands for this event
        existing_commands = {
            h.get('command')
            for gm in glob_matchers
            for h in gm.get('hooks', [])
        }
        for repo_matcher in repo_matchers:
            for hook in repo_matcher.get('hooks', []):
                cmd = hook.get('command', '')
                if cmd in existing_commands:
                    print(f'  ✓ Hook already exists [{event}]: {cmd[:60]}...' if len(cmd) > 60 else f'  ✓ Hook already exists [{event}]')
                else:
                    if glob_matchers:
                        glob_matchers[0].setdefault('hooks', []).append(hook)
                    else:
                        glob_matchers.append({'hooks': [hook]})
                    existing_commands.add(cmd)
                    print(f'  ✅ Added hook [{event}]: {cmd[:60]}...' if len(cmd) > 60 else f'  ✅ Added hook [{event}]')

with open(global_path, 'w') as f:
    json.dump(glob, f, indent=2)
    f.write('\n')
PYEOF
fi

echo ""
echo "✨ Installation complete!"
echo ""
echo "📝 Note: The following are now symlinked to your repository:"
[ -f "$REPO_DIR/devbackend.md" ] && echo "  - ~/.claude/devbackend.md -> $REPO_DIR/devbackend.md"
[ -f "$REPO_DIR/devbackend.md" ] && echo "  - ~/.claude/CLAUDE.md includes @devbackend.md"
echo "  - ~/.claude/agents/<name> -> $REPO_DIR/agents/<name> (per agent)"
[ -d "$REPO_DIR/skills" ] && echo "  - ~/.claude/skills/<name> -> $REPO_DIR/skills/<name> (per skill)"
[ -d "$REPO_DIR/commands" ] && echo "  - ~/.claude/commands/<name>.md -> $REPO_DIR/commands/<name>.md (per command)"
[ -d "$REPO_DIR/examples" ] && echo "  - ~/.claude/examples/<name> -> $REPO_DIR/examples/<name> (per example)"
[ -f "$REPO_DIR/settings.json" ] && echo "  - ~/.claude/settings.json merged from $REPO_DIR/settings.json"
