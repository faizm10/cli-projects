#!/usr/bin/env bash
# Post-install script for npm package - makes scripts executable

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Make all scripts executable
chmod +x "$SCRIPT_DIR/games.sh" 2>/dev/null || true
chmod +x "$SCRIPT_DIR/install.sh" 2>/dev/null || true
chmod +x "$SCRIPT_DIR/npm-bin.sh" 2>/dev/null || true
chmod +x "$SCRIPT_DIR/games/"*.sh 2>/dev/null || true

echo "✅ CLI Games installed successfully!"
echo "   Run: npx cli-games"
echo "   Or install globally: npm install -g @faizm10/cli-games"
