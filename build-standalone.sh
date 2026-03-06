#!/usr/bin/env bash
# Build a standalone single-file version with all games embedded

set -e

OUTPUT="cli-games-standalone.sh"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Building standalone CLI games..."

cat > "$OUTPUT" << 'HEADER'
#!/usr/bin/env bash
# CLI Games - Standalone Version
# All 10 games in a single file - no installation needed!
# Just run: bash cli-games-standalone.sh

# Colors
RED='\033[0;31m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BOLD='\033[1m'
NC='\033[0m'

# Function definitions for all games
HEADER

# Add each game as a function
for game in number_guess hangman tictactoe dino snake rps memory wordle minesweeper blackjack; do
  echo "Adding $game..."
  echo "" >> "$OUTPUT"
  echo "# ============================================" >> "$OUTPUT"
  echo "# Game: ${game}" >> "$OUTPUT"
  echo "# ============================================" >> "$OUTPUT"
  echo "play_${game}() {" >> "$OUTPUT"
  # Remove the shebang and first comment line, then add the rest
  tail -n +3 "$SCRIPT_DIR/games/${game}.sh" >> "$OUTPUT"
  echo "}" >> "$OUTPUT"
done

# Add menu and main loop
cat >> "$OUTPUT" << 'FOOTER'

# ============================================
# Main Menu
# ============================================

show_menu() {
  echo -e "${CYAN}╔════════════════════════════════════╗${NC}"
  echo -e "${CYAN}║${NC}     ${BOLD}🎮 CLI GAMES COLLECTION 🎮${NC}    ${CYAN}║${NC}"
  echo -e "${CYAN}╚════════════════════════════════════╝${NC}"
  echo -e "${GREEN}Play offline • Standalone file • Pure Bash${NC}"
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
    1) play_number_guess ;;
    2) play_hangman ;;
    3) play_tictactoe ;;
    4) play_dino ;;
    5) play_snake ;;
    6) play_rps ;;
    7) play_memory ;;
    8) play_wordle ;;
    9) play_minesweeper ;;
    10) play_blackjack ;;
    0) clear; echo -e "${GREEN}Thanks for playing! 👋${NC}"; exit 0 ;;
    *) echo -e "${RED}Invalid choice. Pick 0-10.${NC}"; sleep 1.5 ;;
  esac
  echo ""
  echo -n -e "${YELLOW}Press Enter to return to menu...${NC}"
  read -r
done
FOOTER

chmod +x "$OUTPUT"

echo ""
echo "✅ Standalone version created: $OUTPUT"
echo ""
echo "Usage:"
echo "  ./$OUTPUT"
echo ""
echo "Share this single file with anyone - no installation needed!"
