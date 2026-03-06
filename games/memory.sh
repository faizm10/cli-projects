#!/usr/bin/env bash
# Memory Game (Simon Says): Repeat the color sequence!

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m' # No Color

sequence=()
level=1
high_score=0

colors=("RED" "GREEN" "YELLOW" "BLUE")
color_codes=("${RED}" "${GREEN}" "${YELLOW}" "${BLUE}")
color_emojis=("🔴" "🟢" "🟡" "🔵")

get_color_display() {
  case "$1" in
    RED) echo -e "${RED}${BOLD}RED 🔴${NC}" ;;
    GREEN) echo -e "${GREEN}${BOLD}GREEN 🟢${NC}" ;;
    YELLOW) echo -e "${YELLOW}${BOLD}YELLOW 🟡${NC}" ;;
    BLUE) echo -e "${BLUE}${BOLD}BLUE 🔵${NC}" ;;
  esac
}

flash_color() {
  local color="$1"
  case "$color" in
    RED) echo -e "\n\n        ${RED}${BOLD}███████████████${NC}\n        ${RED}${BOLD}███████████████${NC}\n        ${RED}${BOLD}███████████████${NC}\n        ${RED}${BOLD}███  RED  🔴 ███${NC}\n        ${RED}${BOLD}███████████████${NC}\n        ${RED}${BOLD}███████████████${NC}\n        ${RED}${BOLD}███████████████${NC}\n" ;;
    GREEN) echo -e "\n\n        ${GREEN}${BOLD}███████████████${NC}\n        ${GREEN}${BOLD}███████████████${NC}\n        ${GREEN}${BOLD}███████████████${NC}\n        ${GREEN}${BOLD}██ GREEN 🟢 ███${NC}\n        ${GREEN}${BOLD}███████████████${NC}\n        ${GREEN}${BOLD}███████████████${NC}\n        ${GREEN}${BOLD}███████████████${NC}\n" ;;
    YELLOW) echo -e "\n\n        ${YELLOW}${BOLD}███████████████${NC}\n        ${YELLOW}${BOLD}███████████████${NC}\n        ${YELLOW}${BOLD}███████████████${NC}\n        ${YELLOW}${BOLD}██ YELLOW 🟡 ██${NC}\n        ${YELLOW}${BOLD}███████████████${NC}\n        ${YELLOW}${BOLD}███████████████${NC}\n        ${YELLOW}${BOLD}███████████████${NC}\n" ;;
    BLUE) echo -e "\n\n        ${BLUE}${BOLD}███████████████${NC}\n        ${BLUE}${BOLD}███████████████${NC}\n        ${BLUE}${BOLD}███████████████${NC}\n        ${BLUE}${BOLD}██ BLUE 🔵 ████${NC}\n        ${BLUE}${BOLD}███████████████${NC}\n        ${BLUE}${BOLD}███████████████${NC}\n        ${BLUE}${BOLD}███████████████${NC}\n" ;;
  esac
}

show_sequence() {
  for color in "${sequence[@]}"; do
    clear
    echo -e "${MAGENTA}╔════════════════════════════════════╗${NC}"
    echo -e "${MAGENTA}║${NC}      ${BOLD}🧠 MEMORY GAME 🎨${NC}          ${MAGENTA}║${NC}"
    echo -e "${MAGENTA}╚════════════════════════════════════╝${NC}"
    echo -e "${CYAN}Level: ${BOLD}$level${NC}   ${YELLOW}Sequence Length: ${BOLD}${#sequence[@]}${NC}"

    flash_color "$color"

    sleep 0.6
  done

  clear
  echo -e "${MAGENTA}╔════════════════════════════════════╗${NC}"
  echo -e "${MAGENTA}║${NC}      ${BOLD}🧠 MEMORY GAME 🎨${NC}          ${MAGENTA}║${NC}"
  echo -e "${MAGENTA}╚════════════════════════════════════╝${NC}"
  echo -e "${CYAN}Level: ${BOLD}$level${NC}   ${YELLOW}Sequence Length: ${BOLD}${#sequence[@]}${NC}"
  echo ""
  echo -e "${GREEN}${BOLD}Your turn! Repeat the sequence.${NC}"
  echo ""
}

get_input() {
  echo -e "${CYAN}Enter your sequence:${NC}"
  echo -e "  ${BOLD}1${NC} - $(get_color_display RED)"
  echo -e "  ${BOLD}2${NC} - $(get_color_display GREEN)"
  echo -e "  ${BOLD}3${NC} - $(get_color_display YELLOW)"
  echo -e "  ${BOLD}4${NC} - $(get_color_display BLUE)"
  echo ""

  local user_sequence=()
  for ((i=0; i<${#sequence[@]}; i++)); do
    echo -n -e "${YELLOW}Color $((i+1))/${#sequence[@]}:${NC} "
    read -r choice

    case "$choice" in
      1|r|R|red|RED) user_sequence+=("RED") ;;
      2|g|G|green|GREEN) user_sequence+=("GREEN") ;;
      3|y|Y|yellow|YELLOW) user_sequence+=("YELLOW") ;;
      4|b|B|blue|BLUE) user_sequence+=("BLUE") ;;
      q|Q|quit|exit)
        echo -e "${YELLOW}Game abandoned.${NC}"
        return 2
        ;;
      *)
        echo -e "${RED}❌ Invalid input!${NC}"
        return 1
        ;;
    esac
  done

  # Check if sequence matches
  for ((i=0; i<${#sequence[@]}; i++)); do
    if [ "${sequence[$i]}" != "${user_sequence[$i]}" ]; then
      return 1
    fi
  done

  return 0
}

clear
echo -e "${MAGENTA}╔════════════════════════════════════╗${NC}"
echo -e "${MAGENTA}║${NC}      ${BOLD}🧠 MEMORY GAME 🎨${NC}          ${MAGENTA}║${NC}"
echo -e "${MAGENTA}╚════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}📋 How to play:${NC}"
echo -e "  • Watch the color sequence carefully"
echo -e "  • Repeat the sequence in the correct order"
echo -e "  • Each level adds one more color"
echo -e "  • How far can you go?"
echo -e "  • Enter ${BOLD}1-4${NC} for colors or type ${BOLD}quit${NC} to exit"
echo ""
echo -e "${YELLOW}Press Enter to start...${NC}"
read -r

while true; do
  # Add new color to sequence
  new_color="${colors[RANDOM % 4]}"
  sequence+=("$new_color")

  clear
  echo -e "${MAGENTA}╔════════════════════════════════════╗${NC}"
  echo -e "${MAGENTA}║${NC}      ${BOLD}🧠 MEMORY GAME 🎨${NC}          ${MAGENTA}║${NC}"
  echo -e "${MAGENTA}╚════════════════════════════════════╝${NC}"
  echo -e "${CYAN}Level: ${BOLD}$level${NC}   ${YELLOW}High Score: ${BOLD}$high_score${NC}"
  echo ""
  echo -e "${GREEN}${BOLD}Watch the sequence...${NC}"
  sleep 1.5

  # Show sequence
  show_sequence

  # Get user input
  get_input
  result=$?

  if [ $result -eq 2 ]; then
    # User quit
    clear
    echo -e "${YELLOW}╔════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║${NC}     ${BOLD}👋 GAME QUIT${NC}               ${YELLOW}║${NC}"
    echo -e "${YELLOW}╚════════════════════════════════════╝${NC}"
    echo -e "${CYAN}Level Reached: ${BOLD}$level${NC}"
    echo -e "${GREEN}High Score: ${BOLD}$high_score${NC}"
    echo ""
    return 0
  elif [ $result -eq 1 ]; then
    # Wrong sequence
    clear
    echo -e "${RED}╔════════════════════════════════════╗${NC}"
    echo -e "${RED}║${NC}     ${BOLD}💀 GAME OVER! 💀${NC}           ${RED}║${NC}"
    echo -e "${RED}╚════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}You reached level ${BOLD}$level${NC}"

    if [ $level -gt $high_score ]; then
      high_score=$level
      echo -e "${GREEN}${BOLD}🎉 NEW HIGH SCORE! 🎉${NC}"
    else
      echo -e "${CYAN}High Score: ${BOLD}$high_score${NC}"
    fi

    echo ""
    echo -e "${BLUE}The sequence was:${NC}"
    for color in "${sequence[@]}"; do
      echo -n "$(get_color_display "$color") "
    done
    echo ""
    echo ""
    return 0
  else
    # Correct!
    clear
    echo -e "${GREEN}╔════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║${NC}     ${BOLD}✅ CORRECT! ✅${NC}             ${GREEN}║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════╝${NC}"
    echo -e "${CYAN}Level $level complete!${NC}"
    level=$((level + 1))
    sleep 1.5
  fi
done
