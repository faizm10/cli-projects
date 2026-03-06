#!/usr/bin/env bash
# Number Guess: guess a number between 1 and 100.

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

n=$((RANDOM % 100 + 1))
tries=0
min=1
max=100

clear
echo -e "${CYAN}╔════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}   ${BOLD}NUMBER GUESSING GAME${NC}        ${CYAN}║${NC}"
echo -e "${CYAN}╚════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}📋 How to play:${NC}"
echo -e "  • I'm thinking of a number between ${BOLD}1${NC} and ${BOLD}100${NC}"
echo -e "  • Try to guess it in as few attempts as possible"
echo -e "  • I'll tell you if you need to go higher or lower"
echo -e "  • Type ${BOLD}quit${NC} or ${BOLD}q${NC} to exit anytime"
echo ""

while true; do
  echo -e "${CYAN}Range: ${BOLD}$min - $max${NC}  |  Tries: ${BOLD}$tries${NC}"
  echo -n -e "${YELLOW}➤${NC} Your guess: "
  read -r guess

  # Allow quitting
  if [[ "$guess" =~ ^(quit|q|exit)$ ]]; then
    echo -e "${YELLOW}👋 Game abandoned. The number was ${BOLD}$n${NC}${YELLOW}.${NC}"
    return 0
  fi

  tries=$((tries + 1))

  if ! [[ "$guess" =~ ^[0-9]+$ ]]; then
    echo -e "${RED}❌ Invalid input. Please enter a number between 1-100.${NC}"
    echo ""
    continue
  fi

  if [ "$guess" -lt 1 ] || [ "$guess" -gt 100 ]; then
    echo -e "${RED}❌ Number must be between 1 and 100!${NC}"
    echo ""
    continue
  fi

  if [ "$guess" -lt "$n" ]; then
    echo -e "${BLUE}⬆️  Too low! Try higher.${NC}"
    [ "$guess" -gt "$min" ] && min=$guess
  elif [ "$guess" -gt "$n" ]; then
    echo -e "${BLUE}⬇️  Too high! Try lower.${NC}"
    [ "$guess" -lt "$max" ] && max=$guess
  else
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║${NC}  ${BOLD}🎉 CORRECT! YOU WIN! 🎉${NC}       ${GREEN}║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════╝${NC}"
    echo -e "${GREEN}✅ You guessed ${BOLD}$n${NC}${GREEN} in ${BOLD}$tries${NC}${GREEN} tries!${NC}"

    if [ "$tries" -eq 1 ]; then
      echo -e "${YELLOW}🏆 INCREDIBLE! First try! Are you psychic?${NC}"
    elif [ "$tries" -le 5 ]; then
      echo -e "${YELLOW}🏆 EXCELLENT! Very impressive!${NC}"
    elif [ "$tries" -le 7 ]; then
      echo -e "${YELLOW}⭐ GREAT! Well done!${NC}"
    elif [ "$tries" -le 10 ]; then
      echo -e "${YELLOW}👍 GOOD! Nice work!${NC}"
    fi
    echo ""
    return 0
  fi
  echo ""
done
