#!/usr/bin/env bash
# Install CLI games to ~/.local so you can run `games` from anywhere.
# Run from repo: ./install.sh
# Or one-liner: curl -sSL https://raw.githubusercontent.com/faizm10/cli-projects/main/install.sh | bash

set -e

# Full project lives here (same layout as repo). Change when you fork.
INSTALL_ROOT="${INSTALL_ROOT:-$HOME/.local/share/cli-projects}"
BIN_DIR="${BIN_DIR:-$HOME/.local/bin}"
CLI_GAMES_REPO="${CLI_GAMES_REPO:-https://raw.githubusercontent.com/faizm10/cli-projects/main}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd)" || true

mkdir -p "$INSTALL_ROOT"
mkdir -p "$INSTALL_ROOT/games"
mkdir -p "$BIN_DIR"

if [ -f "${SCRIPT_DIR}/games.sh" ] && [ -d "${SCRIPT_DIR}/games" ]; then
  # Running from a local clone — copy whole project into install directory
  cp "$SCRIPT_DIR/games.sh" "$INSTALL_ROOT/games.sh"
  [ -f "${SCRIPT_DIR}/install.sh" ] && cp "$SCRIPT_DIR/install.sh" "$INSTALL_ROOT/install.sh"
  [ -f "${SCRIPT_DIR}/README.md" ] && cp "$SCRIPT_DIR/README.md" "$INSTALL_ROOT/README.md"
  for f in "$SCRIPT_DIR/games/"*.sh; do
    [ -f "$f" ] && cp "$f" "$INSTALL_ROOT/games/"
  done
else
  # Running via curl|bash — download whole project into install directory
  if ! command -v curl >/dev/null 2>&1; then
    echo "Need curl to download. Install curl or run this script from a clone of the repo."
    exit 1
  fi
  echo "Downloading CLI games (full project)..."
  curl -sSL "$CLI_GAMES_REPO/install.sh" -o "$INSTALL_ROOT/install.sh"
  curl -sSL "$CLI_GAMES_REPO/games.sh" -o "$INSTALL_ROOT/games.sh"
  curl -sSL "$CLI_GAMES_REPO/README.md" -o "$INSTALL_ROOT/README.md"
  for name in number_guess.sh hangman.sh tictactoe.sh dino.sh snake.sh rps.sh memory.sh wordle.sh minesweeper.sh blackjack.sh; do
    curl -sSL "$CLI_GAMES_REPO/games/$name" -o "$INSTALL_ROOT/games/$name"
  done
fi

chmod +x "$INSTALL_ROOT/games.sh"
chmod +x "$INSTALL_ROOT/install.sh"
chmod +x "$INSTALL_ROOT/games/"*.sh

ln -sf "$INSTALL_ROOT/games.sh" "$BIN_DIR/games"

echo "Installed. Run:  games"
if ! echo ":$PATH:" | grep -q ":$BIN_DIR:"; then
  echo "Add to PATH:  export PATH=\"\$HOME/.local/bin:\$PATH\""
  echo "(Add the line above to your shell rc, e.g. .bashrc or .zshrc)"
fi
