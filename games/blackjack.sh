#!/usr/bin/env bash
# Blackjack (21): Classic card game against the dealer

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Card deck
suits=("♠" "♥" "♦" "♣")
ranks=("A" "2" "3" "4" "5" "6" "7" "8" "9" "10" "J" "Q" "K")
deck=()
player_hand=()
dealer_hand=()
player_balance=1000
bet=0

init_deck() {
  deck=()
  for suit in "${suits[@]}"; do
    for rank in "${ranks[@]}"; do
      deck+=("$rank$suit")
    done
  done
}

shuffle_deck() {
  local i tmp size=${#deck[@]}
  for ((i=size-1; i>0; i--)); do
    local j=$((RANDOM % (i+1)))
    tmp="${deck[i]}"
    deck[i]="${deck[j]}"
    deck[j]="$tmp"
  done
}

draw_card() {
  local card="${deck[0]}"
  deck=("${deck[@]:1}")
  echo "$card"
}

get_card_value() {
  local card="$1"
  local rank="${card:0:-1}"

  case "$rank" in
    A) echo 11 ;;
    J|Q|K) echo 10 ;;
    *) echo "$rank" ;;
  esac
}

calculate_hand_value() {
  local -n hand=$1
  local total=0
  local aces=0

  for card in "${hand[@]}"; do
    local value=$(get_card_value "$card")
    total=$((total + value))
    [ "${card:0:1}" = "A" ] && aces=$((aces + 1))
  done

  # Adjust for aces
  while [ $total -gt 21 ] && [ $aces -gt 0 ]; do
    total=$((total - 10))
    aces=$((aces - 1))
  done

  echo $total
}

display_card() {
  local card="$1"
  local suit="${card: -1}"

  case "$suit" in
    "♥"|"♦") echo -e "${RED}${BOLD}[$card]${NC}" ;;
    *) echo -e "${BOLD}[$card]${NC}" ;;
  esac
}

show_hands() {
  local hide_dealer=$1

  echo -e "${CYAN}╔════════════════════════════════════╗${NC}"
  echo -e "${CYAN}║${NC}        ${BOLD}🎴 BLACKJACK 🎲${NC}           ${CYAN}║${NC}"
  echo -e "${CYAN}╚════════════════════════════════════╝${NC}"
  echo -e "${GREEN}Balance: ${BOLD}\$$player_balance${NC}   ${YELLOW}Bet: ${BOLD}\$$bet${NC}"
  echo ""

  echo -e "${YELLOW}${BOLD}Dealer's Hand:${NC}"
  echo -n "  "
  if [ "$hide_dealer" = "true" ]; then
    display_card "${dealer_hand[0]}"
    echo -n " ${GRAY}${BOLD}[??]${NC}"
  else
    for card in "${dealer_hand[@]}"; do
      display_card "$card"
      echo -n " "
    done
    echo -n -e "${CYAN}(Total: ${BOLD}$(calculate_hand_value dealer_hand)${NC}${CYAN})${NC}"
  fi
  echo ""
  echo ""

  echo -e "${GREEN}${BOLD}Your Hand:${NC}"
  echo -n "  "
  for card in "${player_hand[@]}"; do
    display_card "$card"
    echo -n " "
  done
  local player_total=$(calculate_hand_value player_hand)
  echo -e "${GREEN}(Total: ${BOLD}$player_total${NC}${GREEN})${NC}"
  echo ""
}

play_round() {
  # Get bet
  while true; do
    echo -e "${CYAN}Your balance: ${BOLD}\$$player_balance${NC}"
    echo -n -e "${YELLOW}➤${NC} Enter your bet (or ${BOLD}quit${NC}): "
    read -r bet_input

    if [[ "$bet_input" =~ ^(quit|q|exit)$ ]]; then
      return 1
    fi

    if ! [[ "$bet_input" =~ ^[0-9]+$ ]]; then
      echo -e "${RED}❌ Please enter a valid number.${NC}"
      continue
    fi

    bet=$bet_input

    if [ $bet -le 0 ]; then
      echo -e "${RED}❌ Bet must be greater than 0.${NC}"
      continue
    fi

    if [ $bet -gt $player_balance ]; then
      echo -e "${RED}❌ You don't have enough money!${NC}"
      continue
    fi

    break
  done

  # Initialize and shuffle
  init_deck
  shuffle_deck
  player_hand=()
  dealer_hand=()

  # Deal initial cards
  player_hand+=($(draw_card))
  dealer_hand+=($(draw_card))
  player_hand+=($(draw_card))
  dealer_hand+=($(draw_card))

  clear
  show_hands true

  # Check for blackjack
  local player_total=$(calculate_hand_value player_hand)
  if [ $player_total -eq 21 ]; then
    show_hands false
    echo -e "${GREEN}╔════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║${NC}    ${BOLD}🎉 BLACKJACK! 🎉${NC}           ${GREEN}║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════╝${NC}"
    player_balance=$((player_balance + bet * 3 / 2))
    echo -e "${GREEN}You win ${BOLD}\$$((bet * 3 / 2))${NC}${GREEN}!${NC}"
    return 0
  fi

  # Player's turn
  while true; do
    show_hands true
    player_total=$(calculate_hand_value player_hand)

    if [ $player_total -gt 21 ]; then
      echo -e "${RED}╔════════════════════════════════════╗${NC}"
      echo -e "${RED}║${NC}      ${BOLD}💥 BUST! 💥${NC}               ${RED}║${NC}"
      echo -e "${RED}╚════════════════════════════════════╝${NC}"
      player_balance=$((player_balance - bet))
      echo -e "${RED}You lose ${BOLD}\$$bet${NC}${RED}!${NC}"
      return 0
    fi

    echo -e "${CYAN}Choose: ${BOLD}h${NC} (hit) | ${BOLD}s${NC} (stand)"
    echo -n -e "${YELLOW}➤${NC} Your choice: "
    read -r choice

    case "$choice" in
      h|H|hit)
        player_hand+=($(draw_card))
        clear
        ;;
      s|S|stand)
        break
        ;;
      *)
        echo -e "${RED}❌ Invalid choice.${NC}"
        sleep 1
        clear
        ;;
    esac
  done

  # Dealer's turn
  clear
  show_hands false
  echo -e "${YELLOW}Dealer's turn...${NC}"
  sleep 1.5

  while true; do
    local dealer_total=$(calculate_hand_value dealer_hand)

    if [ $dealer_total -ge 17 ]; then
      break
    fi

    dealer_hand+=($(draw_card))
    clear
    show_hands false
    echo -e "${YELLOW}Dealer draws a card...${NC}"
    sleep 1.5
  done

  # Determine winner
  clear
  show_hands false

  dealer_total=$(calculate_hand_value dealer_hand)
  player_total=$(calculate_hand_value player_hand)

  if [ $dealer_total -gt 21 ]; then
    echo -e "${GREEN}╔════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║${NC}   ${BOLD}🎉 DEALER BUSTS! YOU WIN! 🎉${NC}  ${GREEN}║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════╝${NC}"
    player_balance=$((player_balance + bet))
    echo -e "${GREEN}You win ${BOLD}\$$bet${NC}${GREEN}!${NC}"
  elif [ $player_total -gt $dealer_total ]; then
    echo -e "${GREEN}╔════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║${NC}      ${BOLD}🎉 YOU WIN! 🎉${NC}            ${GREEN}║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════╝${NC}"
    player_balance=$((player_balance + bet))
    echo -e "${GREEN}You win ${BOLD}\$$bet${NC}${GREEN}!${NC}"
  elif [ $dealer_total -gt $player_total ]; then
    echo -e "${RED}╔════════════════════════════════════╗${NC}"
    echo -e "${RED}║${NC}     ${BOLD}😔 DEALER WINS! 😔${NC}        ${RED}║${NC}"
    echo -e "${RED}╚════════════════════════════════════╝${NC}"
    player_balance=$((player_balance - bet))
    echo -e "${RED}You lose ${BOLD}\$$bet${NC}${RED}!${NC}"
  else
    echo -e "${YELLOW}╔════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║${NC}        ${BOLD}🤝 PUSH! 🤝${NC}             ${YELLOW}║${NC}"
    echo -e "${YELLOW}╚════════════════════════════════════╝${NC}"
    echo -e "${YELLOW}It's a tie! Bet returned.${NC}"
  fi

  return 0
}

clear
echo -e "${MAGENTA}╔════════════════════════════════════╗${NC}"
echo -e "${MAGENTA}║${NC}        ${BOLD}🎴 BLACKJACK 🎲${NC}           ${MAGENTA}║${NC}"
echo -e "${MAGENTA}╚════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}📋 How to play:${NC}"
echo -e "  • Try to get as close to 21 as possible"
echo -e "  • Cards 2-10 are worth face value"
echo -e "  • J, Q, K are worth 10"
echo -e "  • Aces are worth 11 or 1 (whichever is better)"
echo -e "  • ${BOLD}Hit${NC} to draw another card, ${BOLD}Stand${NC} to stop"
echo -e "  • Beat the dealer without going over 21!"
echo -e "  • Starting balance: ${GREEN}${BOLD}\$1000${NC}"
echo ""
echo -e "${YELLOW}Press Enter to start...${NC}"
read -r

while [ $player_balance -gt 0 ]; do
  clear
  play_round
  result=$?

  [ $result -eq 1 ] && break  # User quit

  if [ $player_balance -le 0 ]; then
    echo ""
    echo -e "${RED}╔════════════════════════════════════╗${NC}"
    echo -e "${RED}║${NC}   ${BOLD}💸 YOU'RE OUT OF MONEY! 💸${NC}   ${RED}║${NC}"
    echo -e "${RED}╚════════════════════════════════════╝${NC}"
    echo -e "${YELLOW}Game Over! Better luck next time.${NC}"
    echo ""
    return 0
  fi

  echo ""
  echo -n -e "${CYAN}Play another round? (${BOLD}y${NC}${CYAN}/n):${NC} "
  read -r again

  if [[ ! "$again" =~ ^[Yy]$ ]]; then
    break
  fi
done

clear
echo -e "${CYAN}╔════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}     ${BOLD}👋 THANKS FOR PLAYING!${NC}     ${CYAN}║${NC}"
echo -e "${CYAN}╚════════════════════════════════════╝${NC}"
echo -e "${GREEN}Final Balance: ${BOLD}\$$player_balance${NC}"

if [ $player_balance -gt 1000 ]; then
  local profit=$((player_balance - 1000))
  echo -e "${GREEN}${BOLD}🎉 You made \$$profit! Great job!${NC}"
elif [ $player_balance -lt 1000 ]; then
  local loss=$((1000 - player_balance))
  echo -e "${YELLOW}You lost \$$loss. Better luck next time!${NC}"
else
  echo -e "${YELLOW}You broke even!${NC}"
fi
echo ""
return 0
