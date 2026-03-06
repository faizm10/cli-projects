#!/usr/bin/env bash
# Wordle: Guess the 5-letter word in 6 tries

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
GRAY='\033[0;90m'
BOLD='\033[1m'
BG_GREEN='\033[42m'
BG_YELLOW='\033[43m'
BG_GRAY='\033[100m'
NC='\033[0m' # No Color

# 5-letter word list
words=(ABOUT ABOVE ACUTE ADMIT ADOPT ADULT AFTER AGENT AGREE AHEAD ALARM ALBUM ALERT ALIGN ALIKE ALIVE ALLOW ALONE ALONG ALTER AMBER AMEND AMONG AMPLE ANGEL ANGER ANGLE ANGRY APART APPLE APPLY ARENA ARGUE ARISE ARRAY ASIDE ASSET AVOID AWAKE AWARE BADLY BAKER BASES BASIC BEACH BEGAN BEGIN BEING BELOW BENCH BILLY BIRTH BLACK BLAME BLANK BLAST BLIND BLOCK BLOOD BLOWN BLUES BOARD BOOST BOOTH BOUND BRAIN BRAND BRAVE BREAD BREAK BREED BRIEF BRING BROAD BROKE BROWN BUILD BUILT BUYER CABLE CALIF CARRY CATCH CAUSE CHAIN CHAIR CHAOS CHARM CHART CHASE CHEAP CHEST CHIEF CHILD CHINA CHOSE CIVIL CLAIM CLASS CLEAN CLEAR CLIMB CLOCK CLOSE COACH COAST COULD COUNT COURT COVER CRAFT CRASH CRAZY CREAM CRIME CROSS CROWD CROWN CURVE CYCLE DAILY DANCE DEALT DEATH DEPTH DOING DOUBT DOZEN DRAFT DRAMA DRANK DRAWN DREAM DRESS DRILL DRINK DRIVE DROVE DYING EAGER EARLY EARTH EIGHT ELITE EMPTY ENEMY ENJOY ENTER ENTRY EQUAL ERROR EVENT EVERY EXACT EXIST EXTRA FAITH FALSE FAULT FIBER FIELD FIFTH FIFTY FIGHT FINAL FIRST FIXED FLASH FLEET FLOOR FLUID FOCUS FORCE FORTH FORTY FORUM FOUND FRAME FRANK FRAUD FRESH FRONT FRUIT FULLY FUNNY GIANT GIVEN GLASS GLOBE GOING GRACE GRADE GRAIN GRAND GRANT GRASS GREAT GREEN GROSS GROUP GROWN GUARD GUESS GUEST GUIDE HAPPY HARRY HEART HEAVY HENCE HENRY HORSE HOTEL HOUSE HUMAN IDEAL IMAGE IMPLY INDEX INNER INPUT ISSUE JAPAN JIMMY JOINT JONES JUDGE KNOWN LABEL LARGE LASER LATER LAUGH LAYER LEARN LEASE LEAST LEAVE LEGAL LEVEL LEWIS LIGHT LIMIT LINKS LIVES LOCAL LOGIC LOOSE LOWER LUCKY LUNCH LYING MAGIC MAJOR MAKER MARCH MARIA MATCH MAYBE MAYOR MEANT MEDIA METAL MIGHT MINOR MINUS MIXED MODEL MONEY MONTH MORAL MOTOR MOUNT MOUSE MOUTH MOVED MUSIC NEEDS NEVER NEWLY NIGHT NOISE NORTH NOTED NOVEL NURSE OCCUR OCEAN OFFER OFTEN ORDER OTHER OUGHT OUTER OWNED OWNER PAINT PANEL PAPER PARTY PEACE PETER PHASE PHONE PHOTO PIECE PILOT PITCH PLACE PLAIN PLANE PLANT PLATE POINT POUND POWER PRESS PRICE PRIDE PRIME PRINT PRIOR PRIZE PROOF PROUD PROVE QUEEN QUICK QUIET QUITE RADIO RAISE RANGE RAPID RATIO REACH READY REFER RIGHT RIVAL RIVER ROBIN ROGER ROMAN ROUGH ROUND ROUTE ROYAL RURAL SCALE SCENE SCOPE SCORE SENSE SERVE SEVEN SHALL SHAPE SHARE SHARP SHEET SHELF SHELL SHIFT SHINE SHORT SHOWN SIGHT SILLY SINCE SIXTH SIZED SKILL SLEEP SLIDE SMALL SMART SMILE SMITH SMOKE SOLID SOLVE SORRY SOUND SOUTH SPACE SPARE SPEAK SPEED SPEND SPENT SPLIT SPOKE SPORT SQUAD STAFF STAGE STAKE STAND START STATE STEAM STEEL STICK STILL STOCK STONE STOOD STORE STORM STORY STRIP STUCK STUDY STUFF STYLE SUGAR SUITE SUPER SWEET TABLE TAKEN TASTE TAXES TEACH TENDS TERRY TEXAS THANK THEFT THEIR THEME THERE THESE THICK THING THINK THIRD THOSE THREE THREW THROW TIGHT TIMES TITLE TODAY TOMMY TOUCH TOUGH TOWER TRACK TRADE TRAIN TREAT TREND TRIAL TRIED TRIES TRUCK TRULY TRUST TRUTH TWICE UNDER UNDUE UNION UNITY UNTIL UPPER URBAN USAGE USUAL VALID VALUE VIDEO VIRUS VISIT VITAL VOICE WASTE WATCH WATER WHEEL WHERE WHICH WHILE WHITE WHOLE WHOSE WOMAN WOMEN WORLD WORRY WORSE WORST WORTH WOULD WOUND WRITE WRONG WROTE YIELD YOUNG YOURS YOUTH)
word="${words[RANDOM % ${#words[@]}]}"
max_tries=6
tries=0
guesses=()

check_guess() {
  local guess="$1"
  local result=""

  # Create a copy of the word to mark used letters
  local word_copy="$word"

  # First pass: mark correct positions (green)
  for ((i=0; i<5; i++)); do
    if [ "${guess:$i:1}" = "${word:$i:1}" ]; then
      result="${result}G"
      # Mark this letter as used
      word_copy="${word_copy:0:$i}_${word_copy:$((i+1))}"
    else
      result="${result}?"
    fi
  done

  # Second pass: mark wrong positions (yellow) and wrong letters (gray)
  local final_result=""
  for ((i=0; i<5; i++)); do
    if [ "${result:$i:1}" = "G" ]; then
      final_result="${final_result}G"
    else
      local letter="${guess:$i:1}"
      if echo "$word_copy" | grep -q "$letter"; then
        final_result="${final_result}Y"
        # Mark this letter as used (replace first occurrence with _)
        word_copy=$(echo "$word_copy" | sed "s/$letter/_/")
      else
        final_result="${final_result}X"
      fi
    fi
  done

  echo "$final_result"
}

display_guess() {
  local guess="$1"
  local result="$2"

  echo -n "     "
  for ((i=0; i<5; i++)); do
    local letter="${guess:$i:1}"
    local status="${result:$i:1}"

    case "$status" in
      G) echo -n -e "${BG_GREEN}${BOLD} $letter ${NC} " ;;
      Y) echo -n -e "${BG_YELLOW}${BOLD} $letter ${NC} " ;;
      X) echo -n -e "${BG_GRAY}${BOLD} $letter ${NC} " ;;
    esac
  done
  echo ""
}

draw_board() {
  clear
  echo -e "${GREEN}╔════════════════════════════════════╗${NC}"
  echo -e "${GREEN}║${NC}        ${BOLD}🎯 WORDLE GAME 📝${NC}         ${GREEN}║${NC}"
  echo -e "${GREEN}╚════════════════════════════════════╝${NC}"
  echo -e "${CYAN}Tries: ${BOLD}$tries${NC}${CYAN}/$max_tries${NC}"
  echo ""

  # Display previous guesses
  for ((i=0; i<${#guesses[@]}; i+=2)); do
    display_guess "${guesses[$i]}" "${guesses[$i+1]}"
  done

  # Display empty rows
  for ((i=${#guesses[@]}/2; i<max_tries; i++)); do
    echo "     _ _ _ _ _"
  done
  echo ""
}

clear
echo -e "${GREEN}╔════════════════════════════════════╗${NC}"
echo -e "${GREEN}║${NC}        ${BOLD}🎯 WORDLE GAME 📝${NC}         ${GREEN}║${NC}"
echo -e "${GREEN}╚════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}📋 How to play:${NC}"
echo -e "  • Guess the 5-letter word in 6 tries"
echo -e "  • After each guess, colors show how close you are:"
echo -e "    ${BG_GREEN}${BOLD} X ${NC} = Letter is correct and in the right spot"
echo -e "    ${BG_YELLOW}${BOLD} X ${NC} = Letter is in the word but wrong spot"
echo -e "    ${BG_GRAY}${BOLD} X ${NC} = Letter is not in the word"
echo -e "  • Type ${BOLD}quit${NC} to exit anytime"
echo ""
echo -e "${YELLOW}Press Enter to start...${NC}"
read -r

while [ $tries -lt $max_tries ]; do
  draw_board

  echo -n -e "${YELLOW}➤${NC} Enter your guess (5 letters): "
  read -r guess

  # Check for quit
  if [[ "$guess" =~ ^(quit|q|exit)$ ]]; then
    echo -e "${YELLOW}👋 Game abandoned. The word was ${BOLD}$word${NC}${YELLOW}.${NC}"
    return 0
  fi

  # Convert to uppercase
  guess=$(echo "$guess" | tr '[:lower:]' '[:upper:]')

  # Validate input
  if [ ${#guess} -ne 5 ]; then
    echo -e "${RED}❌ Please enter exactly 5 letters.${NC}"
    sleep 1.5
    continue
  fi

  if ! [[ "$guess" =~ ^[A-Z]+$ ]]; then
    echo -e "${RED}❌ Please enter only letters.${NC}"
    sleep 1.5
    continue
  fi

  tries=$((tries + 1))

  # Check the guess
  result=$(check_guess "$guess")
  guesses+=("$guess" "$result")

  # Check if won
  if [ "$guess" = "$word" ]; then
    draw_board
    echo -e "${GREEN}╔════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║${NC}    ${BOLD}🎉 YOU WIN! 🎉${NC}              ${GREEN}║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════╝${NC}"
    echo -e "${YELLOW}You guessed the word ${BOLD}$word${NC}${YELLOW} in ${BOLD}$tries${NC}${YELLOW} tries!${NC}"

    if [ $tries -eq 1 ]; then
      echo -e "${CYAN}${BOLD}🏆 INCREDIBLE! First try!${NC}"
    elif [ $tries -le 3 ]; then
      echo -e "${CYAN}${BOLD}🏆 EXCELLENT! Amazing!${NC}"
    elif [ $tries -le 5 ]; then
      echo -e "${CYAN}${BOLD}⭐ GREAT! Well done!${NC}"
    else
      echo -e "${CYAN}${BOLD}👍 GOOD! Nice work!${NC}"
    fi
    echo ""
    return 0
  fi
done

# Out of tries
draw_board
echo -e "${RED}╔════════════════════════════════════╗${NC}"
echo -e "${RED}║${NC}     ${BOLD}💀 GAME OVER! 💀${NC}           ${RED}║${NC}"
echo -e "${RED}╚════════════════════════════════════╝${NC}"
echo -e "${YELLOW}The word was: ${BOLD}${GREEN}$word${NC}"
echo ""
return 0
