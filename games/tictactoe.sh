#!/usr/bin/env bash
# Tic-Tac-Toe: two players, X and O. Enter position 1–9.

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Board: positions 1–9 as array indices 0–8
# 1 2 3
# 4 5 6
# 7 8 9
board=(. . . . . . . . .)
current="X"
moves=0

colorize_cell() {
  local cell="$1"
  if [ "$cell" = "X" ]; then
    echo -e "${CYAN}${BOLD}X${NC}"
  elif [ "$cell" = "O" ]; then
    echo -e "${MAGENTA}${BOLD}O${NC}"
  else
    echo -e "${YELLOW}·${NC}"
  fi
}

show_board() {
  echo ""
  echo -e "     ${CYAN}┌───┬───┬───┐${NC}"
  echo -e "     ${CYAN}│${NC} $(colorize_cell "${board[0]}") ${CYAN}│${NC} $(colorize_cell "${board[1]}") ${CYAN}│${NC} $(colorize_cell "${board[2]}") ${CYAN}│${NC}"
  echo -e "     ${CYAN}├───┼───┼───┤${NC}"
  echo -e "     ${CYAN}│${NC} $(colorize_cell "${board[3]}") ${CYAN}│${NC} $(colorize_cell "${board[4]}") ${CYAN}│${NC} $(colorize_cell "${board[5]}") ${CYAN}│${NC}"
  echo -e "     ${CYAN}├───┼───┼───┤${NC}"
  echo -e "     ${CYAN}│${NC} $(colorize_cell "${board[6]}") ${CYAN}│${NC} $(colorize_cell "${board[7]}") ${CYAN}│${NC} $(colorize_cell "${board[8]}") ${CYAN}│${NC}"
  echo -e "     ${CYAN}└───┴───┴───┘${NC}"
  echo ""
  echo -e "     ${YELLOW}1   2   3${NC}"
  echo -e "     ${YELLOW}4   5   6${NC}"
  echo -e "     ${YELLOW}7   8   9${NC}"
  echo ""
}

check_win() {
  local symbol="$1"
  # rows
  [ "${board[0]}" = "$symbol" ] && [ "${board[1]}" = "$symbol" ] && [ "${board[2]}" = "$symbol" ] && return 0
  [ "${board[3]}" = "$symbol" ] && [ "${board[4]}" = "$symbol" ] && [ "${board[5]}" = "$symbol" ] && return 0
  [ "${board[6]}" = "$symbol" ] && [ "${board[7]}" = "$symbol" ] && [ "${board[8]}" = "$symbol" ] && return 0
  # cols
  [ "${board[0]}" = "$symbol" ] && [ "${board[3]}" = "$symbol" ] && [ "${board[6]}" = "$symbol" ] && return 0
  [ "${board[1]}" = "$symbol" ] && [ "${board[4]}" = "$symbol" ] && [ "${board[7]}" = "$symbol" ] && return 0
  [ "${board[2]}" = "$symbol" ] && [ "${board[5]}" = "$symbol" ] && [ "${board[8]}" = "$symbol" ] && return 0
  # diagonals
  [ "${board[0]}" = "$symbol" ] && [ "${board[4]}" = "$symbol" ] && [ "${board[8]}" = "$symbol" ] && return 0
  [ "${board[2]}" = "$symbol" ] && [ "${board[4]}" = "$symbol" ] && [ "${board[6]}" = "$symbol" ] && return 0
  return 1
}

has_empty() {
  for cell in "${board[@]}"; do
    [ "$cell" = "." ] && return 0
  done
  return 1
}

clear
echo -e "${BLUE}╔════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${NC}     ${BOLD}❌ TIC-TAC-TOE ⭕${NC}          ${BLUE}║${NC}"
echo -e "${BLUE}╚════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}📋 How to play:${NC}"
echo -e "  • Two players: ${CYAN}${BOLD}X${NC} and ${MAGENTA}${BOLD}O${NC}"
echo -e "  • ${CYAN}${BOLD}X${NC} goes first"
echo -e "  • Enter a number ${BOLD}1-9${NC} to place your mark"
echo -e "  • Get 3 in a row to win (horizontal, vertical, or diagonal)"
echo -e "  • Type ${BOLD}quit${NC} or ${BOLD}q${NC} to exit anytime"
echo ""
echo -e "${YELLOW}Press Enter to start...${NC}"
read -r

while true; do
  clear
  echo -e "${BLUE}╔════════════════════════════════════╗${NC}"
  echo -e "${BLUE}║${NC}     ${BOLD}❌ TIC-TAC-TOE ⭕${NC}          ${BLUE}║${NC}"
  echo -e "${BLUE}╚════════════════════════════════════╝${NC}"

  show_board

  if [ "$current" = "X" ]; then
    echo -e "${CYAN}Current player: ${BOLD}X${NC}"
  else
    echo -e "${MAGENTA}Current player: ${BOLD}O${NC}"
  fi
  echo -n -e "${YELLOW}➤${NC} Enter position 1-9: "
  read -r pos

  # Allow quitting
  if [[ "$pos" =~ ^(quit|q|exit)$ ]]; then
    echo -e "${YELLOW}👋 Game abandoned.${NC}"
    return 0
  fi

  if ! [[ "$pos" =~ ^[1-9]$ ]]; then
    echo -e "${RED}❌ Invalid input. Enter a number from 1 to 9.${NC}"
    sleep 1.5
    continue
  fi

  idx=$((pos - 1))
  if [ "${board[$idx]}" != "." ]; then
    echo -e "${RED}❌ That spot is already taken! Choose another.${NC}"
    sleep 1.5
    continue
  fi

  board[$idx]="$current"
  moves=$((moves + 1))

  if check_win "$current"; then
    clear
    echo -e "${BLUE}╔════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}     ${BOLD}❌ TIC-TAC-TOE ⭕${NC}          ${BLUE}║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════╝${NC}"
    show_board

    if [ "$current" = "X" ]; then
      echo -e "${GREEN}╔════════════════════════════════════╗${NC}"
      echo -e "${GREEN}║${NC}  ${BOLD}🎉 PLAYER X WINS! 🎉${NC}        ${GREEN}║${NC}"
      echo -e "${GREEN}╚════════════════════════════════════╝${NC}"
    else
      echo -e "${GREEN}╔════════════════════════════════════╗${NC}"
      echo -e "${GREEN}║${NC}  ${BOLD}🎉 PLAYER O WINS! 🎉${NC}        ${GREEN}║${NC}"
      echo -e "${GREEN}╚════════════════════════════════════╝${NC}"
    fi
    echo ""
    return 0
  fi

  if ! has_empty; then
    clear
    echo -e "${BLUE}╔════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}     ${BOLD}❌ TIC-TAC-TOE ⭕${NC}          ${BLUE}║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════╝${NC}"
    show_board
    echo -e "${YELLOW}╔════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║${NC}      ${BOLD}🤝 IT'S A DRAW! 🤝${NC}        ${YELLOW}║${NC}"
    echo -e "${YELLOW}╚════════════════════════════════════╝${NC}"
    echo ""
    return 0
  fi

  if [ "$current" = "X" ]; then
    current="O"
  else
    current="X"
  fi
done
