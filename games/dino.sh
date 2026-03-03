#!/usr/bin/env bash
# Infinity Dino: run and jump over cacti. Press SPACE to jump.

WIDTH=50
DINO_COL=8
# Pace like Chrome offline dino: ~7 fps, comfortable jump timing
FRAME_SEC=0.14
JUMP_FRAMES=8
OBSTACLE_START=48

score=0
obstacle_pos=$OBSTACLE_START
jump_state=0

# Restore terminal on exit
cleanup() { stty echo 2>/dev/null; stty sane 2>/dev/null; }
trap cleanup EXIT INT TERM
stty -echo 2>/dev/null

echo "Infinity Dino — press SPACE to jump over cacti. Run forever!"
echo "Press any key to start..."
read -n 1 -r

while true; do
  # Draw
  clear
  echo "Score: $score"
  echo ""

  # Row above ground (dino when jumping)
  if [ "$jump_state" -gt 0 ]; then
    line1=""
    for ((i=0; i<WIDTH; i++)); do
      if [ "$i" -eq "$DINO_COL" ]; then line1="${line1}D"; else line1="${line1} "; fi
    done
    echo "$line1"
  else
    line1=""
    for ((i=0; i<WIDTH; i++)); do line1="${line1} "; done
    echo "$line1"
  fi

  # Ground row: = with D at DINO_COL (if on ground) and C at obstacle_pos
  line2=""
  for ((i=0; i<WIDTH; i++)); do
    if [ "$i" -eq "$DINO_COL" ] && [ "$jump_state" -eq 0 ]; then
      line2="${line2}D"
    elif [ "$i" -eq "$obstacle_pos" ]; then
      line2="${line2}C"
    else
      line2="${line2}="
    fi
  done
  echo "$line2"
  echo ""
  echo "SPACE = jump"

  # Read key; frame rate sets game speed (lower = slower, like real dino)
  key=""
  read -t "$FRAME_SEC" -n 1 -r key 2>/dev/null || true
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
    echo "Game Over! Score: $score"
    echo ""
    return 0
  fi

  # Respawn obstacle and add score when we pass one
  if [ "$obstacle_pos" -lt 0 ]; then
    score=$((score + 1))
    obstacle_pos=$OBSTACLE_START
  fi
done
