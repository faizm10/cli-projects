#!/usr/bin/env bash
# Minesweeper: Classic mine-sweeping game

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
GRAY='\033[0;90m'
BOLD='\033[1m'
NC='\033[0m' # No Color

WIDTH=10
HEIGHT=10
MINES=15

# Boards
declare -a board       # Actual mine positions (M=mine, 0-8=number)
declare -a visible     # What player sees (H=hidden, F=flagged, R=revealed)
declare -a mine_pos    # List of mine positions

game_over=0
won=0
revealed_count=0
flags_placed=0

init_board() {
  # Initialize boards
  for ((y=0; y<HEIGHT; y++)); do
    for ((x=0; x<WIDTH; x++)); do
      board[$((y*WIDTH + x))]="0"
      visible[$((y*WIDTH + x))]="H"
    done
  done

  # Place mines randomly
  local placed=0
  while [ $placed -lt $MINES ]; do
    local pos=$((RANDOM % (WIDTH * HEIGHT)))
    if [ "${board[$pos]}" != "M" ]; then
      board[$pos]="M"
      mine_pos+=($pos)
      placed=$((placed + 1))
    fi
  done

  # Calculate numbers
  for ((y=0; y<HEIGHT; y++)); do
    for ((x=0; x<WIDTH; x++)); do
      local idx=$((y*WIDTH + x))
      if [ "${board[$idx]}" != "M" ]; then
        local count=0
        for ((dy=-1; dy<=1; dy++)); do
          for ((dx=-1; dx<=1; dx++)); do
            [ $dx -eq 0 ] && [ $dy -eq 0 ] && continue
            local ny=$((y + dy))
            local nx=$((x + dx))
            if [ $ny -ge 0 ] && [ $ny -lt $HEIGHT ] && [ $nx -ge 0 ] && [ $nx -lt $WIDTH ]; then
              local nidx=$((ny*WIDTH + nx))
              [ "${board[$nidx]}" = "M" ] && count=$((count + 1))
            fi
          done
        done
        board[$idx]="$count"
      fi
    done
  done
}

draw_board() {
  clear
  echo -e "${CYAN}╔════════════════════════════════════╗${NC}"
  echo -e "${CYAN}║${NC}      ${BOLD}💣 MINESWEEPER 🚩${NC}          ${CYAN}║${NC}"
  echo -e "${CYAN}╚════════════════════════════════════╝${NC}"
  echo -e "${YELLOW}Mines: ${BOLD}$MINES${NC}   ${RED}Flags: ${BOLD}$flags_placed${NC}   ${GREEN}Safe: ${BOLD}$revealed_count${NC}${GREEN}/$((WIDTH*HEIGHT-MINES))${NC}"
  echo ""

  # Column numbers
  echo -n "    "
  for ((x=0; x<WIDTH; x++)); do
    printf "${CYAN}%2d${NC} " $x
  done
  echo ""

  # Top border
  echo -n "   ${BLUE}┌"
  for ((x=0; x<WIDTH; x++)); do
    echo -n "──"
    [ $x -lt $((WIDTH-1)) ] && echo -n "─"
  done
  echo -e "┐${NC}"

  # Board
  for ((y=0; y<HEIGHT; y++)); do
    printf "${CYAN}%2d${NC} ${BLUE}│${NC}" $y
    for ((x=0; x<WIDTH; x++)); do
      local idx=$((y*WIDTH + x))
      local vis="${visible[$idx]}"
      local val="${board[$idx]}"

      case "$vis" in
        H) echo -n -e " ${GRAY}▪${NC} " ;;
        F) echo -n -e " ${RED}${BOLD}⚑${NC} " ;;
        R)
          if [ "$val" = "M" ]; then
            echo -n -e " ${RED}${BOLD}💣${NC}"
          elif [ "$val" = "0" ]; then
            echo -n "   "
          else
            case "$val" in
              1) echo -n -e " ${BLUE}${BOLD}$val${NC} " ;;
              2) echo -n -e " ${GREEN}${BOLD}$val${NC} " ;;
              3) echo -n -e " ${RED}${BOLD}$val${NC} " ;;
              4) echo -n -e " ${MAGENTA}${BOLD}$val${NC} " ;;
              *) echo -n -e " ${YELLOW}${BOLD}$val${NC} " ;;
            esac
          fi
          ;;
      esac
    done
    echo -e "${BLUE}│${NC}"
  done

  # Bottom border
  echo -n "   ${BLUE}└"
  for ((x=0; x<WIDTH; x++)); do
    echo -n "──"
    [ $x -lt $((WIDTH-1)) ] && echo -n "─"
  done
  echo -e "┘${NC}"
  echo ""
}

reveal() {
  local x=$1
  local y=$2

  [ $x -lt 0 ] || [ $x -ge $WIDTH ] || [ $y -lt 0 ] || [ $y -ge $HEIGHT ] && return

  local idx=$((y*WIDTH + x))
  local vis="${visible[$idx]}"
  local val="${board[$idx]}"

  [ "$vis" != "H" ] && return

  visible[$idx]="R"

  if [ "$val" = "M" ]; then
    game_over=1
    # Reveal all mines
    for pos in "${mine_pos[@]}"; do
      visible[$pos]="R"
    done
    return
  fi

  revealed_count=$((revealed_count + 1))

  # Auto-reveal adjacent cells if this is a 0
  if [ "$val" = "0" ]; then
    for ((dy=-1; dy<=1; dy++)); do
      for ((dx=-1; dx<=1; dx++)); do
        [ $dx -eq 0 ] && [ $dy -eq 0 ] && continue
        reveal $((x + dx)) $((y + dy))
      done
    done
  fi

  # Check win condition
  if [ $revealed_count -eq $((WIDTH*HEIGHT - MINES)) ]; then
    won=1
    game_over=1
  fi
}

toggle_flag() {
  local x=$1
  local y=$2
  local idx=$((y*WIDTH + x))
  local vis="${visible[$idx]}"

  if [ "$vis" = "H" ]; then
    visible[$idx]="F"
    flags_placed=$((flags_placed + 1))
  elif [ "$vis" = "F" ]; then
    visible[$idx]="H"
    flags_placed=$((flags_placed - 1))
  fi
}

clear
echo -e "${CYAN}╔════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}      ${BOLD}💣 MINESWEEPER 🚩${NC}          ${CYAN}║${NC}"
echo -e "${CYAN}╚════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}📋 How to play:${NC}"
echo -e "  • Reveal all safe cells without hitting a mine"
echo -e "  • Numbers show how many mines are adjacent"
echo -e "  • Use flags (${RED}${BOLD}⚑${NC}) to mark suspected mines"
echo -e "  • Commands:"
echo -e "    ${BOLD}r x y${NC} - Reveal cell at position (x, y)"
echo -e "    ${BOLD}f x y${NC} - Flag/unflag cell at position (x, y)"
echo -e "    ${BOLD}quit${NC} - Exit game"
echo ""
echo -e "${YELLOW}Press Enter to start...${NC}"
read -r

init_board

while [ $game_over -eq 0 ]; do
  draw_board

  echo -e "${CYAN}Commands: ${BOLD}r x y${NC} (reveal) | ${BOLD}f x y${NC} (flag) | ${BOLD}quit${NC}"
  echo -n -e "${YELLOW}➤${NC} Your move: "
  read -r cmd x y

  if [[ "$cmd" =~ ^(quit|q|exit)$ ]]; then
    echo -e "${YELLOW}👋 Game abandoned.${NC}"
    return 0
  fi

  if ! [[ "$x" =~ ^[0-9]+$ ]] || ! [[ "$y" =~ ^[0-9]+$ ]]; then
    echo -e "${RED}❌ Invalid input. Use: r/f x y${NC}"
    sleep 1.5
    continue
  fi

  if [ "$x" -lt 0 ] || [ "$x" -ge $WIDTH ] || [ "$y" -lt 0 ] || [ "$y" -ge $HEIGHT ]; then
    echo -e "${RED}❌ Position out of bounds!${NC}"
    sleep 1.5
    continue
  fi

  case "$cmd" in
    r|R|reveal)
      reveal $x $y
      ;;
    f|F|flag)
      toggle_flag $x $y
      ;;
    *)
      echo -e "${RED}❌ Invalid command. Use 'r' to reveal or 'f' to flag.${NC}"
      sleep 1.5
      ;;
  esac
done

draw_board

if [ $won -eq 1 ]; then
  echo -e "${GREEN}╔════════════════════════════════════╗${NC}"
  echo -e "${GREEN}║${NC}    ${BOLD}🎉 YOU WIN! 🎉${NC}              ${GREEN}║${NC}"
  echo -e "${GREEN}╚════════════════════════════════════╝${NC}"
  echo -e "${YELLOW}You cleared all safe cells!${NC}"
else
  echo -e "${RED}╔════════════════════════════════════╗${NC}"
  echo -e "${RED}║${NC}     ${BOLD}💥 BOOM! 💥${NC}                ${RED}║${NC}"
  echo -e "${RED}╚════════════════════════════════════╝${NC}"
  echo -e "${YELLOW}You hit a mine! Better luck next time.${NC}"
fi
echo ""
return 0
