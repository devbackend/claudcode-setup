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

# Symlink agents directory
if [ -d "$REPO_DIR/agents" ]; then
    echo "📁 Linking agents..."
    create_symlink "$REPO_DIR/agents" "$CLAUDE_DIR/agents" "agents"
fi

# Symlink skills directory (if exists)
if [ -d "$REPO_DIR/skills" ]; then
    echo "📁 Linking skills..."
    create_symlink "$REPO_DIR/skills" "$CLAUDE_DIR/skills" "skills"
fi

echo ""
echo "✨ Installation complete!"
echo ""
echo "📝 Note: The following are now symlinked to your repository:"
echo "  - ~/.claude/agents -> $REPO_DIR/agents"
[ -d "$REPO_DIR/skills" ] && echo "  - ~/.claude/skills -> $REPO_DIR/skills"
