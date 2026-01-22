#!/bin/bash
# Compound Product Installer
# Usage: ./install.sh [target_project_path]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${1:-.}"

# Resolve to absolute path
TARGET_DIR="$(cd "$TARGET_DIR" 2>/dev/null && pwd)" || {
  echo "Error: Target directory does not exist: $1"
  exit 1
}

echo "Installing Compound Product to: $TARGET_DIR"

# Create directories
mkdir -p "$TARGET_DIR/scripts/compound"
mkdir -p "$TARGET_DIR/reports"

# Copy scripts
echo "Copying scripts..."
cp "$SCRIPT_DIR/scripts/"* "$TARGET_DIR/scripts/compound/"
chmod +x "$TARGET_DIR/scripts/compound/"*.sh

# Copy config if it doesn't exist
if [ ! -f "$TARGET_DIR/compound.config.json" ]; then
  echo "Creating config file..."
  cp "$SCRIPT_DIR/config.example.json" "$TARGET_DIR/compound.config.json"
else
  echo "Config file already exists, skipping..."
fi

# Detect tool and install skills
install_skills() {
  local tool="$1"
  local skills_dir=""
  
  if [ "$tool" = "amp" ]; then
    skills_dir="$HOME/.config/amp/skills"
  elif [ "$tool" = "claude" ]; then
    skills_dir="$HOME/.claude/skills"
  else
    return
  fi
  
  if [ -d "$skills_dir" ] || mkdir -p "$skills_dir"; then
    echo "Installing skills for $tool..."
    cp -r "$SCRIPT_DIR/skills/prd" "$skills_dir/"
    cp -r "$SCRIPT_DIR/skills/tasks" "$skills_dir/"
    echo "Skills installed to: $skills_dir"
  fi
}

# Try to install for both tools
if command -v amp >/dev/null 2>&1; then
  install_skills "amp"
fi

if command -v claude >/dev/null 2>&1; then
  install_skills "claude"
fi

# If neither found, ask
if ! command -v amp >/dev/null 2>&1 && ! command -v claude >/dev/null 2>&1; then
  echo ""
  echo "Neither 'amp' nor 'claude' CLI found."
  echo "Skills will need to be installed manually:"
  echo "  For Amp:    cp -r skills/* ~/.config/amp/skills/"
  echo "  For Claude: cp -r skills/* ~/.claude/skills/"
fi

echo ""
echo "✅ Installation complete!"
echo ""
echo "Next steps:"
echo "1. Edit compound.config.json to configure for your project"
echo "2. Add a report to ./reports/ (any markdown file)"
echo "3. Set ANTHROPIC_API_KEY environment variable"
echo "4. Run: ./scripts/compound/auto-compound.sh --dry-run"
echo ""
echo "See README.md for full documentation."
