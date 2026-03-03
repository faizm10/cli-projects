#!/usr/bin/env bash
# CLI Games — menu and launcher. Run from anywhere after install.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

show_menu() {
  echo "================================"
  echo "       CLI GAMES (offline)"
  echo "================================"
  echo "  1) Number Guess (1–100)"
  echo "  2) Hangman"
  echo "  3) Tic-Tac-Toe (2 players)"
  echo "  4) Quit"
  echo "================================"
  echo -n "Choose 1–4: "
}

while true; do
  clear
  show_menu
  read -r choice
  case "$choice" in
    1) source "$SCRIPT_DIR/games/number_guess.sh" ;;
    2) source "$SCRIPT_DIR/games/hangman.sh" ;;
    3) source "$SCRIPT_DIR/games/tictactoe.sh" ;;
    4) echo "Bye!"; exit 0 ;;
    *) echo "Invalid. Pick 1–4."; sleep 1 ;;
  esac
  echo ""
  echo -n "Press Enter to return to menu..."
  read -r
done
