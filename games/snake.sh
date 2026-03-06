#!/usr/bin/env bash
# Snake: Classic snake game. Eat food to grow. Don't hit walls or yourself!

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

WIDTH=30
HEIGHT=15
FRAME_SEC=0.15

# Snake represented as array of positions "x,y"
snake=("15,7")
direction="RIGHT"
next_direction="RIGHT"
food_x=0
food_y=0
score=0
game_over=0

# Restore terminal on exit
cleanup() {
  stty echo 2>/dev/null
  stty sane 2>/dev/null
  echo -e "${NC}"
  tput cnorm 2>/dev/null  # Show cursor
}
trap cleanup EXIT INT TERM
stty -echo 2>/dev/null
tput civis 2>/dev/null  # Hide cursor

spawn_food() {
  while true; do
    food_x=$((RANDOM % (WIDTH - 2) + 1))
    food_y=$((RANDOM % (HEIGHT - 2) + 1))
    # Check if food is not on snake
    local on_snake=0
    for segment in "${snake[@]}"; do
      local sx="${segment%,*}"
      local sy="${segment#*,}"
      if [ "$sx" -eq "$food_x" ] && [ "$sy" -eq "$food_y" ]; then
        on_snake=1
        break
      fi
    done
    [ "$on_snake" -eq 0 ] && break
  done
}

draw_game() {
  clear
  echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${GREEN}║${NC}                 ${BOLD}🐍 SNAKE GAME 🍎${NC}                         ${GREEN}║${NC}"
  echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
  echo -e "${CYAN}Score: ${BOLD}$score${NC}   ${YELLOW}Length: ${BOLD}${#snake[@]}${NC}"
  echo ""

  # Draw board
  for ((y=0; y<HEIGHT; y++)); do
    for ((x=0; x<WIDTH; x++)); do
      # Check borders
      if [ "$y" -eq 0 ] || [ "$y" -eq $((HEIGHT-1)) ] || [ "$x" -eq 0 ] || [ "$x" -eq $((WIDTH-1)) ]; then
        echo -n -e "${BLUE}█${NC}"
      # Check food
      elif [ "$x" -eq "$food_x" ] && [ "$y" -eq "$food_y" ]; then
        echo -n -e "${RED}${BOLD}●${NC}"
      else
        # Check snake
        local is_snake=0
        local is_head=0
        for i in "${!snake[@]}"; do
          local segment="${snake[$i]}"
          local sx="${segment%,*}"
          local sy="${segment#*,}"
          if [ "$sx" -eq "$x" ] && [ "$sy" -eq "$y" ]; then
            is_snake=1
            [ "$i" -eq 0 ] && is_head=1
            break
          fi
        done

        if [ "$is_head" -eq 1 ]; then
          echo -n -e "${GREEN}${BOLD}◉${NC}"
        elif [ "$is_snake" -eq 1 ]; then
          echo -n -e "${YELLOW}▪${NC}"
        else
          echo -n " "
        fi
      fi
    done
    echo ""
  done

  echo ""
  echo -e "${CYAN}Controls:${NC} ${BOLD}WASD${NC} or ${BOLD}Arrow Keys${NC} = Move  |  ${BOLD}q${NC} = Quit"
}

clear
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║${NC}                 ${BOLD}🐍 SNAKE GAME 🍎${NC}                         ${GREEN}║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}📋 How to play:${NC}"
echo -e "  • Use ${BOLD}WASD${NC} or ${BOLD}Arrow Keys${NC} to control the snake"
echo -e "  • Eat the ${RED}${BOLD}●${NC} food to grow and score points"
echo -e "  • Don't hit the walls or yourself!"
echo -e "  • Press ${BOLD}q${NC} to quit anytime"
echo ""
echo -e "${YELLOW}Press any key to start...${NC}"
read -n 1 -r

spawn_food

while [ "$game_over" -eq 0 ]; do
  draw_game

  # Read input (non-blocking)
  key=""
  read -t "$FRAME_SEC" -n 1 -s key 2>/dev/null || true

  # Handle arrow keys (they send escape sequences)
  if [ "$key" = $'\x1b' ]; then
    read -t 0.01 -n 2 -s key 2>/dev/null || true
  fi

  case "$key" in
    w|W|"[A") [ "$direction" != "DOWN" ] && next_direction="UP" ;;
    s|S|"[B") [ "$direction" != "UP" ] && next_direction="DOWN" ;;
    a|A|"[D") [ "$direction" != "RIGHT" ] && next_direction="LEFT" ;;
    d|D|"[C") [ "$direction" != "LEFT" ] && next_direction="RIGHT" ;;
    q|Q) game_over=1; continue ;;
  esac

  direction="$next_direction"

  # Get head position
  head="${snake[0]}"
  head_x="${head%,*}"
  head_y="${head#*,}"

  # Calculate new head position
  case "$direction" in
    UP)    new_head_x=$head_x; new_head_y=$((head_y - 1)) ;;
    DOWN)  new_head_x=$head_x; new_head_y=$((head_y + 1)) ;;
    LEFT)  new_head_x=$((head_x - 1)); new_head_y=$head_y ;;
    RIGHT) new_head_x=$((head_x + 1)); new_head_y=$head_y ;;
  esac

  # Check wall collision
  if [ "$new_head_x" -le 0 ] || [ "$new_head_x" -ge $((WIDTH-1)) ] || \
     [ "$new_head_y" -le 0 ] || [ "$new_head_y" -ge $((HEIGHT-1)) ]; then
    game_over=1
    continue
  fi

  # Check self collision
  for segment in "${snake[@]}"; do
    sx="${segment%,*}"
    sy="${segment#*,}"
    if [ "$sx" -eq "$new_head_x" ] && [ "$sy" -eq "$new_head_y" ]; then
      game_over=1
      break
    fi
  done

  [ "$game_over" -eq 1 ] && continue

  # Add new head
  snake=("$new_head_x,$new_head_y" "${snake[@]}")

  # Check if ate food
  if [ "$new_head_x" -eq "$food_x" ] && [ "$new_head_y" -eq "$food_y" ]; then
    score=$((score + 10))
    spawn_food
  else
    # Remove tail (didn't eat food, so don't grow)
    unset 'snake[-1]'
  fi
done

cleanup
clear
echo -e "${RED}╔════════════════════════════════════╗${NC}"
echo -e "${RED}║${NC}     ${BOLD}💀 GAME OVER! 💀${NC}           ${RED}║${NC}"
echo -e "${RED}╚════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Final Score: ${BOLD}$score${NC}"
echo -e "${CYAN}Snake Length: ${BOLD}${#snake[@]}${NC}"
echo ""
return 0
