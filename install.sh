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

echo ""
echo "✨ Installation complete!"
echo ""
echo "📝 Note: The following are now symlinked to your repository:"
[ -f "$REPO_DIR/devbackend.md" ] && echo "  - ~/.claude/devbackend.md -> $REPO_DIR/devbackend.md"
[ -f "$REPO_DIR/devbackend.md" ] && echo "  - ~/.claude/CLAUDE.md includes @devbackend.md"
echo "  - ~/.claude/agents/<name> -> $REPO_DIR/agents/<name> (per agent)"
[ -d "$REPO_DIR/skills" ] && echo "  - ~/.claude/skills/<name> -> $REPO_DIR/skills/<name> (per skill)"
[ -d "$REPO_DIR/commands" ] && echo "  - ~/.claude/commands/<name>.md -> $REPO_DIR/commands/<name>.md (per command)"
