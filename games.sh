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
  for name in number_guess.sh hangman.sh tictactoe.sh dino.sh snake.sh rps.sh memory.sh wordle.sh minesweeper.sh blackjack.sh; do
    curl -sSL "$CLI_GAMES_REPO/games/$name" -o "$SCRIPT_DIR/games/$name"
  done
  chmod +x "$SCRIPT_DIR/games.sh" "$SCRIPT_DIR/install.sh" "$SCRIPT_DIR/games/"*.sh
  echo "Update complete. Run: games"
  exit 0
fi

# Colors
RED='\033[0;31m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BOLD='\033[1m'
NC='\033[0m'

show_menu() {
  echo -e "${CYAN}╔════════════════════════════════════╗${NC}"
  echo -e "${CYAN}║${NC}     ${BOLD}🎮 CLI GAMES COLLECTION 🎮${NC}    ${CYAN}║${NC}"
  echo -e "${CYAN}╚════════════════════════════════════╝${NC}"
  echo -e "${GREEN}Play offline • No dependencies • Pure Bash${NC}"
  echo ""
  echo -e "${YELLOW}${BOLD}Choose a game:${NC}"
  echo -e "  ${BOLD} 1${NC} - 🔢 Number Guess (1-100)"
  echo -e "  ${BOLD} 2${NC} - 🎯 Hangman"
  echo -e "  ${BOLD} 3${NC} - ❌ Tic-Tac-Toe"
  echo -e "  ${BOLD} 4${NC} - 🦖 Infinity Dino"
  echo -e "  ${BOLD} 5${NC} - 🐍 Snake"
  echo -e "  ${BOLD} 6${NC} - 🪨 Rock Paper Scissors"
  echo -e "  ${BOLD} 7${NC} - 🧠 Memory Game"
  echo -e "  ${BOLD} 8${NC} - 📝 Wordle"
  echo -e "  ${BOLD} 9${NC} - 💣 Minesweeper"
  echo -e "  ${BOLD}10${NC} - 🎴 Blackjack"
  echo -e "  ${BOLD} 0${NC} - 👋 Quit"
  echo ""
  echo -n -e "${YELLOW}➤${NC} Choose 0-10: "
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
    5) source "$SCRIPT_DIR/games/snake.sh" ;;
    6) source "$SCRIPT_DIR/games/rps.sh" ;;
    7) source "$SCRIPT_DIR/games/memory.sh" ;;
    8) source "$SCRIPT_DIR/games/wordle.sh" ;;
    9) source "$SCRIPT_DIR/games/minesweeper.sh" ;;
    10) source "$SCRIPT_DIR/games/blackjack.sh" ;;
    0) clear; echo -e "${GREEN}Thanks for playing! 👋${NC}"; exit 0 ;;
    *) echo -e "${RED}Invalid choice. Pick 0-10.${NC}"; sleep 1.5 ;;
  esac
  echo ""
  echo -n -e "${YELLOW}Press Enter to return to menu...${NC}"
  read -r
done
