#!/usr/bin/env bash
# CLI Games — menu and launcher. Run from anywhere after install.

# Resolve symlinks so we find the games/ folder when run as ~/.local/bin/games
SCRIPT_PATH="${BASH_SOURCE[0]}"
while [ -L "$SCRIPT_PATH" ]; do
  SCRIPT_DIR="$(cd "$(dirname "$SCRIPT_PATH")" && pwd)"
  target="$(readlink "$SCRIPT_PATH")"
  case "$target" in
    /*) SCRIPT_PATH="$target" ;;
    *)  SCRIPT_PATH="$SCRIPT_DIR/$target" ;;
  esac
done
SCRIPT_DIR="$(cd "$(dirname "$SCRIPT_PATH")" && pwd)"

# Update command: re-download whole project from repo
if [ "${1:-}" = "update" ]; then
  CLI_GAMES_REPO="${CLI_GAMES_REPO:-https://raw.githubusercontent.com/faizm10/cli-projects/main}"
  if ! command -v curl >/dev/null 2>&1; then
    echo "Need curl to update. Install curl and try again."
    exit 1
  fi
  echo "Updating CLI games (full project)..."
  curl -sSL "$CLI_GAMES_REPO/install.sh" -o "$SCRIPT_DIR/install.sh"
  curl -sSL "$CLI_GAMES_REPO/games.sh" -o "$SCRIPT_DIR/games.sh"
  curl -sSL "$CLI_GAMES_REPO/README.md" -o "$SCRIPT_DIR/README.md"
  for name in number_guess.sh hangman.sh tictactoe.sh dino.sh; do
    curl -sSL "$CLI_GAMES_REPO/games/$name" -o "$SCRIPT_DIR/games/$name"
  done
  chmod +x "$SCRIPT_DIR/games.sh" "$SCRIPT_DIR/install.sh" "$SCRIPT_DIR/games/"*.sh
  echo "Update complete. Run: games"
  exit 0
fi

show_menu() {
  echo "================================"
  echo "       CLI GAMES (offline)"
  echo "================================"
  echo "  1) Number Guess (1–100)"
  echo "  2) Hangman"
  echo "  3) Tic-Tac-Toe (2 players)"
  echo "  4) Infinity Dino"
  echo "  5) Quit"
  echo "================================"
  echo -n "Choose 1–5: "
}

while true; do
  clear
  show_menu
  read -r choice
  case "$choice" in
    1) source "$SCRIPT_DIR/games/number_guess.sh" ;;
    2) source "$SCRIPT_DIR/games/hangman.sh" ;;
    3) source "$SCRIPT_DIR/games/tictactoe.sh" ;;
    4) source "$SCRIPT_DIR/games/dino.sh" ;;
    5) echo "Bye!"; exit 0 ;;
    *) echo "Invalid. Pick 1–5."; sleep 1 ;;
  esac
  echo ""
  echo -n "Press Enter to return to menu..."
  read -r
done
