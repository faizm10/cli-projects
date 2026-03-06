#!/usr/bin/env bash
# Rock Paper Scissors: Classic game against the computer

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m' # No Color

player_score=0
computer_score=0
ties=0
rounds=0

get_choice_emoji() {
  case "$1" in
    rock|r|1) echo "🪨" ;;
    paper|p|2) echo "📄" ;;
    scissors|s|3) echo "✂️" ;;
  esac
}

get_choice_name() {
  case "$1" in
    rock|r|1) echo "Rock" ;;
    paper|p|2) echo "Paper" ;;
    scissors|s|3) echo "Scissors" ;;
  esac
}

normalize_choice() {
  case "$1" in
    rock|r|1) echo "rock" ;;
    paper|p|2) echo "paper" ;;
    scissors|s|3) echo "scissors" ;;
    *) echo "invalid" ;;
  esac
}

play_round() {
  local player="$1"

  # Computer makes random choice
  local choices=(rock paper scissors)
  local computer="${choices[RANDOM % 3]}"

  echo ""
  echo -e "${YELLOW}You chose:${NC} $(get_choice_emoji "$player") ${BOLD}$(get_choice_name "$player")${NC}"
  sleep 0.5
  echo -e "${CYAN}Computer chose:${NC} $(get_choice_emoji "$computer") ${BOLD}$(get_choice_name "$computer")${NC}"
  sleep 0.5
  echo ""

  # Determine winner
  if [ "$player" = "$computer" ]; then
    echo -e "${YELLOW}╔════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║${NC}        ${BOLD}🤝 IT'S A TIE! 🤝${NC}        ${YELLOW}║${NC}"
    echo -e "${YELLOW}╚════════════════════════════════════╝${NC}"
    ties=$((ties + 1))
  elif { [ "$player" = "rock" ] && [ "$computer" = "scissors" ]; } || \
       { [ "$player" = "paper" ] && [ "$computer" = "rock" ]; } || \
       { [ "$player" = "scissors" ] && [ "$computer" = "paper" ]; }; then
    echo -e "${GREEN}╔════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║${NC}       ${BOLD}🎉 YOU WIN! 🎉${NC}          ${GREEN}║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════╝${NC}"
    player_score=$((player_score + 1))
  else
    echo -e "${RED}╔════════════════════════════════════╗${NC}"
    echo -e "${RED}║${NC}      ${BOLD}😔 YOU LOSE! 😔${NC}          ${RED}║${NC}"
    echo -e "${RED}╚════════════════════════════════════╝${NC}"
    computer_score=$((computer_score + 1))
  fi

  rounds=$((rounds + 1))
}

show_stats() {
  echo ""
  echo -e "${CYAN}╔════════════════════════════════════╗${NC}"
  echo -e "${CYAN}║${NC}          ${BOLD}📊 SCOREBOARD${NC}            ${CYAN}║${NC}"
  echo -e "${CYAN}╠════════════════════════════════════╣${NC}"
  echo -e "${CYAN}║${NC}  ${GREEN}Your Score:${NC}      ${BOLD}$player_score${NC}            ${CYAN}║${NC}"
  echo -e "${CYAN}║${NC}  ${RED}Computer Score:${NC}  ${BOLD}$computer_score${NC}            ${CYAN}║${NC}"
  echo -e "${CYAN}║${NC}  ${YELLOW}Ties:${NC}            ${BOLD}$ties${NC}            ${CYAN}║${NC}"
  echo -e "${CYAN}║${NC}  ${BLUE}Rounds Played:${NC}   ${BOLD}$rounds${NC}            ${CYAN}║${NC}"
  echo -e "${CYAN}╚════════════════════════════════════╝${NC}"
  echo ""
}

clear
echo -e "${MAGENTA}╔════════════════════════════════════╗${NC}"
echo -e "${MAGENTA}║${NC}   ${BOLD}🪨 ROCK PAPER SCISSORS ✂️${NC}    ${MAGENTA}║${NC}"
echo -e "${MAGENTA}╚════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}📋 How to play:${NC}"
echo -e "  • Choose ${BOLD}Rock${NC}, ${BOLD}Paper${NC}, or ${BOLD}Scissors${NC}"
echo -e "  • 🪨 Rock beats ✂️ Scissors"
echo -e "  • 📄 Paper beats 🪨 Rock"
echo -e "  • ✂️ Scissors beats 📄 Paper"
echo -e "  • Type ${BOLD}quit${NC} or ${BOLD}q${NC} to exit anytime"
echo ""
echo -e "${YELLOW}Press Enter to start...${NC}"
read -r

while true; do
  clear
  echo -e "${MAGENTA}╔════════════════════════════════════╗${NC}"
  echo -e "${MAGENTA}║${NC}   ${BOLD}🪨 ROCK PAPER SCISSORS ✂️${NC}    ${MAGENTA}║${NC}"
  echo -e "${MAGENTA}╚════════════════════════════════════╝${NC}"

  [ "$rounds" -gt 0 ] && show_stats

  echo -e "${CYAN}Make your choice:${NC}"
  echo -e "  ${BOLD}1${NC} - 🪨 Rock"
  echo -e "  ${BOLD}2${NC} - 📄 Paper"
  echo -e "  ${BOLD}3${NC} - ✂️ Scissors"
  echo -e "  ${BOLD}q${NC} - Quit"
  echo ""
  echo -n -e "${YELLOW}➤${NC} Your choice: "
  read -r choice

  # Check for quit
  if [[ "$choice" =~ ^(quit|q|exit)$ ]]; then
    clear
    echo -e "${YELLOW}╔════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║${NC}        ${BOLD}👋 THANKS FOR PLAYING!${NC}   ${YELLOW}║${NC}"
    echo -e "${YELLOW}╚════════════════════════════════════╝${NC}"
    [ "$rounds" -gt 0 ] && show_stats

    if [ "$player_score" -gt "$computer_score" ]; then
      echo -e "${GREEN}${BOLD}🏆 You won overall! Great job!${NC}"
    elif [ "$computer_score" -gt "$player_score" ]; then
      echo -e "${RED}The computer won overall. Better luck next time!${NC}"
    else
      echo -e "${YELLOW}Overall it's a tie! Well matched!${NC}"
    fi
    echo ""
    return 0
  fi

  normalized=$(normalize_choice "$choice")

  if [ "$normalized" = "invalid" ]; then
    echo -e "${RED}❌ Invalid choice. Please enter 1, 2, 3, or the name.${NC}"
    sleep 2
    continue
  fi

  play_round "$normalized"

  echo ""
  echo -e "${YELLOW}Press Enter to continue...${NC}"
  read -r
done
