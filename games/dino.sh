#!/usr/bin/env bash
# Infinity Dino: run and jump over cacti. Press SPACE to jump.

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

WIDTH=60
DINO_COL=10
# Pace like Chrome offline dino: ~7 fps, comfortable jump timing
FRAME_SEC=0.14
JUMP_FRAMES=8
OBSTACLE_START=58

score=0
obstacle_pos=$OBSTACLE_START
jump_state=0
high_score=0

# Restore terminal on exit
cleanup() { stty echo 2>/dev/null; stty sane 2>/dev/null; echo -e "${NC}"; }
trap cleanup EXIT INT TERM
stty -echo 2>/dev/null

clear
echo -e "${YELLOW}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${YELLOW}║${NC}                ${BOLD}🦖 INFINITY DINO 🌵${NC}                      ${YELLOW}║${NC}"
echo -e "${YELLOW}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}📋 How to play:${NC}"
echo -e "  • Press ${BOLD}SPACE${NC} to jump over cacti"
echo -e "  • Avoid obstacles to survive"
echo -e "  • Score increases for each obstacle passed"
echo -e "  • The game runs forever - how long can you last?"
echo -e "  • Press ${BOLD}q${NC} during game to quit"
echo ""
echo -e "${YELLOW}Press SPACE to start...${NC}"
read -n 1 -r

while true; do
  # Draw
  clear
  echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${CYAN}║${NC}  ${YELLOW}Score: ${BOLD}$score${NC}                    ${YELLOW}High Score: ${BOLD}$high_score${NC}         ${CYAN}║${NC}"
  echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
  echo ""

  # Sky/jump row
  if [ "$jump_state" -gt 0 ]; then
    line1=""
    for ((i=0; i<WIDTH; i++)); do
      if [ "$i" -eq "$DINO_COL" ]; then
        line1="${line1}${GREEN}${BOLD}🦖${NC}"
      else
        line1="${line1} "
      fi
    done
    echo -e "$line1"
  else
    line1=""
    for ((i=0; i<WIDTH; i++)); do
      line1="${line1} "
    done
    echo -e "$line1"
  fi

  # Ground row: with dino and obstacles
  line2=""
  for ((i=0; i<WIDTH; i++)); do
    if [ "$i" -eq "$DINO_COL" ] && [ "$jump_state" -eq 0 ]; then
      line2="${line2}${GREEN}${BOLD}🦖${NC}"
    elif [ "$i" -eq "$obstacle_pos" ]; then
      line2="${line2}${RED}${BOLD}🌵${NC}"
    else
      line2="${line2}${YELLOW}─${NC}"
    fi
  done
  echo -e "$line2"

  # Ground base
  line3=""
  for ((i=0; i<WIDTH; i++)); do
    line3="${line3}${YELLOW}═${NC}"
  done
  echo -e "$line3"
  echo ""
  echo -e "${CYAN}Controls:${NC} ${BOLD}SPACE${NC} = Jump  |  ${BOLD}q${NC} = Quit"

  # Read key; frame rate sets game speed
  key=""
  read -t "$FRAME_SEC" -n 1 -r key 2>/dev/null || true

  if [ "$key" = "q" ]; then
    cleanup
    clear
    echo -e "${YELLOW}╔════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║${NC}     ${BOLD}👋 GAME QUIT${NC}               ${YELLOW}║${NC}"
    echo -e "${YELLOW}╚════════════════════════════════════╝${NC}"
    echo -e "${CYAN}Final Score: ${BOLD}$score${NC}"
    [ "$score" -gt "$high_score" ] && echo -e "${GREEN}New High Score! 🎉${NC}"
    echo ""
    return 0
  fi

  if [ "$key" = " " ] && [ "$jump_state" -eq 0 ]; then
    jump_state=1
  fi

  # Update jump
  if [ "$jump_state" -gt 0 ]; then
    jump_state=$((jump_state + 1))
    if [ "$jump_state" -gt "$JUMP_FRAMES" ]; then
      jump_state=0
    fi
  fi

  # Move obstacle
  obstacle_pos=$((obstacle_pos - 1))

  # Collision: obstacle at dino position while on ground
  if [ "$obstacle_pos" -eq "$DINO_COL" ] && [ "$jump_state" -eq 0 ]; then
    cleanup
    clear
    echo -e "${RED}╔════════════════════════════════════╗${NC}"
    echo -e "${RED}║${NC}     ${BOLD}💀 GAME OVER! 💀${NC}           ${RED}║${NC}"
    echo -e "${RED}╚════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}Final Score: ${BOLD}$score${NC}"

    if [ "$score" -gt "$high_score" ]; then
      high_score=$score
      echo -e "${GREEN}${BOLD}🎉 NEW HIGH SCORE! 🎉${NC}"
    else
      echo -e "${CYAN}High Score: ${BOLD}$high_score${NC}"
    fi
    echo ""
    return 0
  fi

  # Respawn obstacle and add score when we pass one
  if [ "$obstacle_pos" -lt 0 ]; then
    score=$((score + 1))
    obstacle_pos=$OBSTACLE_START
  fi
done
