#!/usr/bin/env bash
# Hangman: guess the word letter by letter. 6 wrong guesses and you lose.

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m' # No Color

words=(BASH SCRIPT TERMINAL HANGMAN GAMES OFFLINE SHELL LINUX APPLE WORDS GUESS LETTER CURSOR KEYBOARD PROMPT COMMAND OUTPUT INPUT FOLDER FILE PATH MENU CHOICE BINARY CODE DEBUG ERROR FUNCTION VARIABLE ARRAY LOOP CONDITION SYNTAX)
word="${words[RANDOM % ${#words[@]}]}"
max_wrong=6
wrong=0
guessed=""
len=${#word}
# Build display: one underscore per letter
display=""
for ((i=0; i<len; i++)); do display="${display}_ "; done

show_hangman() {
  local stage=$1
  echo -e "${CYAN}╔════════════════╗${NC}"
  case $stage in
    0)
      echo -e "${CYAN}║${NC}      ${YELLOW}┌─────┐${NC}   ${CYAN}║${NC}"
      echo -e "${CYAN}║${NC}      ${YELLOW}│${NC}         ${CYAN}║${NC}"
      echo -e "${CYAN}║${NC}      ${YELLOW}│${NC}         ${CYAN}║${NC}"
      echo -e "${CYAN}║${NC}      ${YELLOW}│${NC}         ${CYAN}║${NC}"
      echo -e "${CYAN}║${NC}      ${YELLOW}│${NC}         ${CYAN}║${NC}"
      echo -e "${CYAN}║${NC}    ${YELLOW}──┴──${NC}       ${CYAN}║${NC}"
      ;;
    1)
      echo -e "${CYAN}║${NC}      ${YELLOW}┌─────┐${NC}   ${CYAN}║${NC}"
      echo -e "${CYAN}║${NC}      ${YELLOW}│${NC}     ${RED}O${NC}   ${CYAN}║${NC}"
      echo -e "${CYAN}║${NC}      ${YELLOW}│${NC}         ${CYAN}║${NC}"
      echo -e "${CYAN}║${NC}      ${YELLOW}│${NC}         ${CYAN}║${NC}"
      echo -e "${CYAN}║${NC}      ${YELLOW}│${NC}         ${CYAN}║${NC}"
      echo -e "${CYAN}║${NC}    ${YELLOW}──┴──${NC}       ${CYAN}║${NC}"
      ;;
    2)
      echo -e "${CYAN}║${NC}      ${YELLOW}┌─────┐${NC}   ${CYAN}║${NC}"
      echo -e "${CYAN}║${NC}      ${YELLOW}│${NC}     ${RED}O${NC}   ${CYAN}║${NC}"
      echo -e "${CYAN}║${NC}      ${YELLOW}│${NC}     ${RED}|${NC}   ${CYAN}║${NC}"
      echo -e "${CYAN}║${NC}      ${YELLOW}│${NC}         ${CYAN}║${NC}"
      echo -e "${CYAN}║${NC}      ${YELLOW}│${NC}         ${CYAN}║${NC}"
      echo -e "${CYAN}║${NC}    ${YELLOW}──┴──${NC}       ${CYAN}║${NC}"
      ;;
    3)
      echo -e "${CYAN}║${NC}      ${YELLOW}┌─────┐${NC}   ${CYAN}║${NC}"
      echo -e "${CYAN}║${NC}      ${YELLOW}│${NC}     ${RED}O${NC}   ${CYAN}║${NC}"
      echo -e "${CYAN}║${NC}      ${YELLOW}│${NC}    ${RED}/|${NC}   ${CYAN}║${NC}"
      echo -e "${CYAN}║${NC}      ${YELLOW}│${NC}         ${CYAN}║${NC}"
      echo -e "${CYAN}║${NC}      ${YELLOW}│${NC}         ${CYAN}║${NC}"
      echo -e "${CYAN}║${NC}    ${YELLOW}──┴──${NC}       ${CYAN}║${NC}"
      ;;
    4)
      echo -e "${CYAN}║${NC}      ${YELLOW}┌─────┐${NC}   ${CYAN}║${NC}"
      echo -e "${CYAN}║${NC}      ${YELLOW}│${NC}     ${RED}O${NC}   ${CYAN}║${NC}"
      echo -e "${CYAN}║${NC}      ${YELLOW}│${NC}    ${RED}/|\\${NC}  ${CYAN}║${NC}"
      echo -e "${CYAN}║${NC}      ${YELLOW}│${NC}         ${CYAN}║${NC}"
      echo -e "${CYAN}║${NC}      ${YELLOW}│${NC}         ${CYAN}║${NC}"
      echo -e "${CYAN}║${NC}    ${YELLOW}──┴──${NC}       ${CYAN}║${NC}"
      ;;
    5)
      echo -e "${CYAN}║${NC}      ${YELLOW}┌─────┐${NC}   ${CYAN}║${NC}"
      echo -e "${CYAN}║${NC}      ${YELLOW}│${NC}     ${RED}O${NC}   ${CYAN}║${NC}"
      echo -e "${CYAN}║${NC}      ${YELLOW}│${NC}    ${RED}/|\\${NC}  ${CYAN}║${NC}"
      echo -e "${CYAN}║${NC}      ${YELLOW}│${NC}    ${RED}/${NC}    ${CYAN}║${NC}"
      echo -e "${CYAN}║${NC}      ${YELLOW}│${NC}         ${CYAN}║${NC}"
      echo -e "${CYAN}║${NC}    ${YELLOW}──┴──${NC}       ${CYAN}║${NC}"
      ;;
    6)
      echo -e "${CYAN}║${NC}      ${YELLOW}┌─────┐${NC}   ${CYAN}║${NC}"
      echo -e "${CYAN}║${NC}      ${YELLOW}│${NC}     ${RED}O${NC}   ${CYAN}║${NC}"
      echo -e "${CYAN}║${NC}      ${YELLOW}│${NC}    ${RED}/|\\${NC}  ${CYAN}║${NC}"
      echo -e "${CYAN}║${NC}      ${YELLOW}│${NC}    ${RED}/ \\${NC}  ${CYAN}║${NC}"
      echo -e "${CYAN}║${NC}      ${YELLOW}│${NC}         ${CYAN}║${NC}"
      echo -e "${CYAN}║${NC}    ${YELLOW}──┴──${NC}       ${CYAN}║${NC}"
      ;;
  esac
  echo -e "${CYAN}╚════════════════╝${NC}"
}

clear
echo -e "${MAGENTA}╔════════════════════════════════════╗${NC}"
echo -e "${MAGENTA}║${NC}      ${BOLD}🎯 HANGMAN GAME${NC}           ${MAGENTA}║${NC}"
echo -e "${MAGENTA}╚════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}📋 How to play:${NC}"
echo -e "  • Guess the hidden word letter by letter"
echo -e "  • You have ${BOLD}6${NC} wrong guesses before you lose"
echo -e "  • The word is ${BOLD}${len}${NC} letters long"
echo -e "  • Type ${BOLD}quit${NC} or ${BOLD}q${NC} to exit anytime"
echo ""
echo -e "${YELLOW}Press Enter to start...${NC}"
read -r

while true; do
  clear
  echo -e "${MAGENTA}╔════════════════════════════════════╗${NC}"
  echo -e "${MAGENTA}║${NC}      ${BOLD}🎯 HANGMAN GAME${NC}           ${MAGENTA}║${NC}"
  echo -e "${MAGENTA}╚════════════════════════════════════╝${NC}"
  echo ""

  show_hangman "$wrong"

  echo ""
  echo -e "${BOLD}${GREEN}Word:${NC} ${BOLD}$display${NC}"
  echo ""
  echo -e "${YELLOW}Lives left: ${BOLD}$((max_wrong - wrong))${NC}${YELLOW}/6${NC}"
  echo -e "${CYAN}Guessed letters:${NC} ${guessed:-${BOLD}none${NC}}"
  echo ""

  if [ "$wrong" -ge "$max_wrong" ]; then
    echo -e "${RED}╔════════════════════════════════════╗${NC}"
    echo -e "${RED}║${NC}     ${BOLD}💀 GAME OVER! 💀${NC}           ${RED}║${NC}"
    echo -e "${RED}╚════════════════════════════════════╝${NC}"
    echo -e "${YELLOW}The word was: ${BOLD}${GREEN}$word${NC}"
    echo ""
    return 0
  fi

  # Check win: no underscores left
  if ! echo "$display" | grep -q '_'; then
    echo -e "${GREEN}╔════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║${NC}    ${BOLD}🎉 YOU WIN! 🎉${NC}             ${GREEN}║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════╝${NC}"
    echo -e "${GREEN}The word was: ${BOLD}$word${NC}"
    echo -e "${YELLOW}Wrong guesses: ${BOLD}$wrong${NC}${YELLOW}/6${NC}"
    echo ""
    return 0
  fi

  echo -n -e "${YELLOW}➤${NC} Guess a letter: "
  read -r letter

  # Allow quitting
  if [[ "$letter" =~ ^(quit|q|exit)$ ]]; then
    echo -e "${YELLOW}👋 Game abandoned. The word was ${BOLD}$word${NC}${YELLOW}.${NC}"
    return 0
  fi

  letter=$(echo "$letter" | tr '[:lower:]' '[:upper:]')
  letter="${letter:0:1}"

  if [ -z "$letter" ] || [ ${#letter} -ne 1 ] || ! [[ "$letter" =~ ^[A-Z]$ ]]; then
    echo -e "${RED}❌ Please enter a single letter (A-Z).${NC}"
    sleep 1.5
    continue
  fi

  if echo "$guessed" | grep -q "$letter"; then
    echo -e "${YELLOW}⚠️  You already guessed '$letter'. Try another!${NC}"
    sleep 1.5
    continue
  fi

  guessed="${guessed}${letter} "

  if echo "$word" | grep -q "$letter"; then
    # Reveal all occurrences
    new_display=""
    for ((i=0; i<len; i++)); do
      c="${word:i:1}"
      if [ "$c" = "$letter" ]; then
        new_display="${new_display}${letter} "
      else
        new_display="${new_display}${display:i*2:2}"
      fi
    done
    display="$new_display"
    echo -e "${GREEN}✅ Good guess! '$letter' is in the word!${NC}"
    sleep 1
  else
    wrong=$((wrong + 1))
    echo -e "${RED}❌ Wrong! '$letter' is not in the word.${NC}"
    sleep 1
  fi
done
