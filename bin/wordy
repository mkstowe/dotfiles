#! /bin/bash
#     ╭───╮╭───╮╭───╮╭───╮╭───╮
#     │ W ││ O ││ R ││ D ││ Y │
#     ╰───╯╰───╯╰───╯╰───╯╰───╯
#A bash script written by Christos Angelopoulos, September 2023, under GPL v2
Y="\033[1;33m"
G="\033[1;32m"
C="\033[1;36m"
M="\033[1;35m"
R="\033[1;31m"
B="\x1b[38;5;242m"
W="\033[1;37m"
bold=`tput bold`
norm=`tput sgr0`
#LINE 17 contains the address of the word list. .
#Each user is free to modify this line in order to play the game using the word list of their liking.
WORD_LIST="/usr/share/dict/words"
TOTAL_SOLUTIONS="$(grep -v "'" "$WORD_LIST"|grep -v -E [ê,è,é,ë,â,à,ô,ó,ò,ú,ù,û,ü,î,ì,ï,í,ç,ö,á,ñ]|grep -v '[^[:lower:]]'|grep -E ^.....$)"

function show_letters ()
{
 echo -e "     ${Y}╭───╮╭───╮╭───╮╭───╮╭───╮╭───╮╭───╮     \n     │ L ││ E ││ T ││ T ││ E ││ R ││ S │     \n     ╰───╯╰───╯╰───╯╰───╯╰───╯╰───╯╰───╯ ${norm}    \n\n"
 echo -e "          ${G}╭───╮╭───╮╭───╮╭───╮╭───╮     \n  WORD:   │ ${SHOW_WORD[0]^^} ││ ${SHOW_WORD[1]^^} ││ ${SHOW_WORD[2]^^} ││ ${SHOW_WORD[3]^^} ││ ${SHOW_WORD[4]^^} │     \n          ╰───╯╰───╯╰───╯╰───╯╰───╯ ${norm}    \n"
 RED_LETTERS="$(echo $(echo $RED_LETTERS|sed 's/ / \n/g'|sort -h))"" "
 YELLOW_LETTERS="$(echo $(echo $YELLOW_LETTERS|sed 's/ / \n/g'|sort -h))"" "
 echo -e "  ${Y}MISPLACED LETTERS : $YELLOW_LETTERS\n  ${R}ABSENT LETTERS    : $RED_LETTERS\n  ${C}UNUSED LETTERS    : $CYAN_LETTERS${norm}\n\nPress any key to return"
 read -sN 1 v;clear;

}

function quit_puzzle ()
{
 echo -e "     ${G}╭───╮${R}╭───╮╭───╮╭───╮╭───╮     \n     ${G}│ U │${R}│ Q ││ U ││ I ││ T │     \n     ${G}╰───╯${R}╰───╯╰───╯╰───╯╰───╯ ${norm}    \n\n"
 A=${SOLUTION^^}
 echo -e "${Y}${bold}The word you were looking for was:"
 echo -e "     ${G}╭───╮╭───╮╭───╮╭───╮╭───╮     \n     │ ${A:0:1} ││ ${A:1:1} ││ ${A:2:1} ││ ${A:3:1} ││ ${A:4:1} │     \n     ╰───╯╰───╯╰───╯╰───╯╰───╯ ${norm}    "
 echo -e "\nPress any key to return"
 read -sN 1 v;clear;
 #db2="M"
 }

function show_statistics () {
 echo -e "     ${Y}╭───╮╭───╮╭───╮╭───╮╭───╮     \n     │ S ││ T ││ A ││ T ││ S │     \n     ╰───╯╰───╯╰───╯╰───╯╰───╯ ${norm}    \n\n"
PLAYED="$(cat $HOME/.cache/wordy/statistics.txt|wc -l)"
WON="$(grep 'win' $HOME/.cache/wordy/statistics.txt|wc -l)"
SUC_RATIO="$(echo "scale=2; $WON *100/ $PLAYED" | bc)"
RECORD="$(sort $HOME/.cache/wordy/statistics.txt|head -1|awk '{print $1}')"
MAX_ROW="$(uniq -c -s 1 $HOME/.cache/wordy/statistics.txt|sort -rh|head -1|awk '{print $1}')"
if [[ "$(tail -1 $HOME/.cache/wordy/statistics.txt)" == "lose" ]]
then
CURRENT_ROW="0"
else
CURRENT_ROW="$(uniq -c -s 1 ~/.cache/wordy/statistics.txt |tail -1|awk '{print $1}')"
fi
echo -e "\tGames Played   : $PLAYED\n\tGames Won      : $WON\n\tGames Lost     : $(($PLAYED-$WON))\n\tSuccess ratio  : $SUC_RATIO%\n\tRecord Guesses : $RECORD\n\tRecord streak  : $MAX_ROW wins\n\tCurrent streak : $CURRENT_ROW wins"|lolcat -p 3000 -a -s 40 -F 0.3 -S 18
}

function win_game ()
{
 clear
 ((TRY++))
 echo "$TRY win">>$HOME/.cache/wordy/statistics.txt
 PLACEHOLDER_STR=$SOLUTION
 F[TRY]="GGGGG"
 print_box
 echo -e "${B}╰───────────────────────────────────╯${norm}"
 A=${PLACEHOLDER_STR^^}
 echo -e "${Y}${bold}Congratulations!\nYou found the word:"
 echo -e "     ${G}╭───╮╭───╮╭───╮╭───╮╭───╮     \n     │ ${A:0:1} ││ ${A:1:1} ││ ${A:2:1} ││ ${A:3:1} ││ ${A:4:1} │     \n     ╰───╯╰───╯╰───╯╰───╯╰───╯ ${norm}    "
 echo -e "${Y}${bold}after ${R}$TRY ${Y}tries!${norm}\n"
 echo -e "\nPress any key to return"
 read -sN 1 v;clear;
 db2="Q"
}

function lose_game ()
{
 clear
 echo "lose">>$HOME/.cache/wordy/statistics.txt
 PLACEHOLDER_STR=$SOLUTION
 F[TRY]="GGGGG"
 print_box
 echo "╰───────────────────────────────────╯"
 echo -e "${Y}${bold}You lost!\nAfter ${R}6${Y} tries,\n it was not possible to find the word\n"
 A=${PLACEHOLDER_STR^^}
echo -e "     ${G}╭───╮╭───╮╭───╮╭───╮╭───╮     \n     │ ${A:0:1} ││ ${A:1:1} ││ ${A:2:1} ││ ${A:3:1} ││ ${A:4:1} │     \n     ╰───╯╰───╯╰───╯╰───╯╰───╯ ${norm}    "
 echo -e "\nPress any key to return";read -sN 1 v;clear;
 db2="Q"
}

function check_guess ()
{
 F0=('R' 'R' 'R' 'R' 'R')
 for q in {0..4}
 do
  if [[ "$SOLUTION" == *"${WORD_STR:q:1}"* ]]&&[[ $(echo ${WORD_STR:q:1}) != ${SOLUTION:q:1} ]]
  then F0[q]="Y"
  fi
  if [[ "$SOLUTION" == *"${WORD_STR:q:1}"* ]]&&[[ $(echo ${WORD_STR:q:1}) == ${SOLUTION:q:1} ]]&&[[ $(echo $WORD_STR|grep -o ${WORD_STR:q:1}|wc -l) -gt 1 ]]
  then F0[q]="Y"
  fi
  if [[ $(echo ${WORD_STR:q:1}) == ${SOLUTION:q:1} ]]
  then
   F0[q]="G"
  fi
  F[TRY]=$(echo ${F0[@]}|sed 's/ //g')
  #show_letters conditionals
  g="${WORD_STR:q:1}"" "
  if [[ ${F0[q]} == "R" ]]
  then
   if [[ "$RED_LETTERS" != *"$g"* ]];then RED_LETTERS="$RED_LETTERS""$g";fi
   CYAN_LETTERS="${CYAN_LETTERS/$g/}"
  fi
  if [[ ${F0[q]} == "Y" ]]
  then
   if [[ "$YELLOW_LETTERS" != *"$g"* ]];then YELLOW_LETTERS="$YELLOW_LETTERS""$g";fi
   CYAN_LETTERS="${CYAN_LETTERS/$g/}"
  fi
  if [[ ${F0[q]} == "G" ]]
  then
   SHOW_WORD[q]=${WORD_STR:q:1}
   CYAN_LETTERS="${CYAN_LETTERS/$g/}"
   YELLOW_LETTERS="${YELLOW_LETTERS/$g/}"
  fi
 done
 COMMENT=" Enter a 5-letter word"
}

function enter_word () {
 if [[ ${#WORD_STR} -lt 5 ]]
 then COMMENT=" Word is too small!"
 elif [[ ${#WORD_STR} -gt 5 ]]
 then COMMENT=" Word too big!"
 elif [[ -z "$(echo $TOTAL_SOLUTIONS|sed 's/ /\n/g'|grep  -E ^"$WORD_STR"$)" ]]
 then COMMENT=" Invalid word, not in solutions"
 else
  COMMENT=" Last word: $WORD_STR"
  GUESS[$TRY]=$WORD_STR
  check_guess
  if [[ "${F[TRY]}" == "GGGGG" ]]
  then win_game
  main_menu_reset
  else
   ((TRY++))
   if [[ $TRY -ge 6 ]]
    then lose_game
    main_menu_reset
   fi
  fi
 fi
 WORD_STR="";PLACEHOLDER_STR="$WORD_STR""$PAD"
 COMMENT_STR="$COMMENT""$PAD"
}

function main_menu_reset () {
for i in {0..5}
do
 F[i]=""
done
}

function print_box () {
 echo -e "${B}╭───────────────────────────────────╮"
t=0
while [[ $t -lt $TRY ]]
do
 A="${GUESS[$t]^^}"
 K0="${F[$t]}"
 for a in {0..4}
 do
  if [[ ${K0:a:1} == "Y" ]];then K[a]="${Y}";
  elif [[ ${K0:a:1} == "G" ]];then K[a]="${G}";
  elif [[ ${K0:a:1} == "R" ]];then K[a]="${R}";fi
 done
echo -e "${B}│     ${K[0]}╭───╮${K[1]}╭───╮${K[2]}╭───╮${K[3]}╭───╮${K[4]}╭───╮${B}     │\n│     ${K[0]}│ ${A:0:1} │${K[1]}│ ${A:1:1} │${K[2]}│ ${A:2:1} │${K[3]}│ ${A:3:1} │${K[4]}│ ${A:4:1} │     ${B}│\n│     ${K[0]}╰───╯${K[1]}╰───╯${K[2]}╰───╯${K[3]}╰───╯${K[4]}╰───╯     ${B}│"
 ((t++))
done
if [[ ${F[TRY]} != "GGGGG" ]]
then
A=${PLACEHOLDER_STR^^}
echo -e "${B}│     ╭───╮╭───╮╭───╮╭───╮╭───╮     │\n│     │${norm} ${A:0:1} ${B}││${norm} ${A:1:1} ${B}││${norm} ${A:2:1} ${B}││${norm} ${A:3:1} ${B}││${norm} ${A:4:1} ${B}│     │\n│     ╰───╯╰───╯╰───╯╰───╯╰───╯     │"
  echo  -e "${B}├───────────────────────────────────┤"
fi
}

function rules() {
 echo -e "You have 6 guesses to find out the secret 5-letter word.

${G}╭───╮
${G}│ F │
${G}╰───╯${norm}
If a letter appears ${R}${bold}green${norm},that means that this letter
${G}${bold}exists in the secret word, and is in the right position${norm}.

\t${Y}╭───╮
\t${Y}│ F │
\t${Y}╰───╯${norm}
If a letter appears ${Y}${bold}yellow${norm},that means that this letter
${Y}${bold}exists in the secret word, but is in NOT the right position${norm}.

\t\t${R}╭───╮
\t\t${R}│ F │
\t\t${R}╰───╯${norm}
If a letter appears ${R}${bold}red${norm},that means that this letter
${R}${bold}does NOT appear in the secret word AT ALL${norm}.
As mentioned above, there are ${Y}${bold}6 guesses${norm} to find the secret word.
${Y}${bold}GOOD LUCK!${norm}
\n\nPress any key to return"
read -sN 1 v
clear
}

function new_game()
{
 PAD="                                      "
 COMMENT=" Enter 5 letter word"
 COMMENT_STR="$COMMENT"${PAD}
 PLACEHOLDER_STR="$WORD_STR${PAD}"
 SOLUTION="$(grep -v "'" "$WORD_LIST"|grep -v -E [ê,è,é,ë,â,à,ô,ó,ò,ú,ù,û,ü,î,ì,ï,í,ç,ö,á,ñ]|grep -v '[^[:lower:]]'|grep -E ^.....$|shuf|head -1)"
 TRY=0
 CYAN_LETTERS="a b c d e f g h i j k l m n o p q r s t u v w x y z "
 RED_LETTERS=""
 YELLOW_LETTERS=""
 SHOW_WORD=("_" "_" "_" "_" "_")
}

function play_menu () {
 db2="";
#detect BACKSPACE, solution found https://stackoverflow.com/questions/4196161/bash-read-backspace-button-behavior-problem
backspace=$(cat << eof
0000000 005177
0000002
eof
)
 while [[ $db2 != "Q" ]]
 do
  print_box
  echo -en "│   ${Y}${bold}<enter>${norm}    to ${G}${bold}ACCEPT word${norm}       ${B}│\n│  ${Y}${bold}<delete>${norm}    to ${R}${bold}ABORT word        ${B}│\n│ ${Y}${bold}<backspace>${norm}  to ${R}${bold}DELETE letter${B}     │\n├───────────────────────────────────┤\n│      ${Y}${bold}L${norm}       to show ${C}${bold}LETTERS${B}      │\n│      ${Y}${bold}W${norm}       to show ${C}${bold}WORD LIST${B}    │\n├───────────────────────────────────┤\n│      ${Y}${bold}Q${norm}       to ${R}${bold}QUIT GAME${B}         │\n├───────────────────────────────────┤\n│${norm}${COMMENT_STR:0:35}${B}│\n╰───────────────────────────────────╯\n${norm}"

  read -sn 1 db2;
  if [[ $(echo "$db2" | od) = "$backspace" ]]&&[[ ${#WORD_STR} -gt 0 ]];then  WORD_STR="${WORD_STR::-1}";PLACEHOLDER_STR="$WORD_STR""$PAD";fi;
  case $db2 in
    "Q") clear;quit_puzzle;db="";main_menu_reset;
    ;;
    [a-z]) clear;if [[ ${#WORD_STR} -le 5 ]];then WORD_STR="$WORD_STR""$db2";PLACEHOLDER_STR="$WORD_STR""$PAD";fi;
    ;;
    "") clear;enter_word;
    ;;
    "3") clear; WORD_STR="";PLACEHOLDER_STR="$WORD_STR""$PAD";
    ;;
    "W") clear; echo -e "     ${Y}╭───╮╭───╮╭───╮╭───╮  ╭───╮╭───╮╭───╮╭───╮\n     │ W ││ O ││ R ││ D │  │ L ││ I ││ S ││ T │\n     ╰───╯╰───╯╰───╯╰───╯  ╰───╯╰───╯╰───╯╰───╯ ${norm}\n\n"
    grep -v "'" "$WORD_LIST"|grep -v -E [ê,è,é,ë,â,à,ô,ó,ò,ú,ù,û,ü,î,ì,ï,í,ç,ö,á,ñ]|grep -v '[^[:lower:]]'|grep -E ^.....$|column -x -c 80;
    echo -e "${Y}${bold}Press any key to return${norm}";read -sN 1 v;clear;
    ;;
    "L") clear;show_letters;
    ;;
    *)clear;
  esac
 done
}
#===============================================================================
clear
db=""
main_menu_reset
while [ "$db" != "4" ]
do
 echo -e "${B}╭───────────────────────────────────╮"
 echo -e "${B}│     ${G}╭───╮${G}╭───╮${G}╭───╮${G}╭───╮${R}╭───╮     ${B}│\n│     ${G}│ W │${G}│ O │${G}│ R │${G}│ D │${R}│ Y │     ${B}│\n│     ${G}╰───╯${G}╰───╯${G}╰───╯${G}╰───╯${R}╰───╯     ${B}│\n├───────────────────────────────────┤\n│   ${C}${bold}Find the hidden 5 letter word${norm}   ${B}│"
 echo -en "├───────────────────────────────────┤\n│${norm}Enter:                             ${B}│\n│ ${Y}${bold}1${norm} to ${G}${bold}Play New Game.${B}               │\n│ ${Y}${bold}2${norm} to ${C}${bold}Read the Rules.${B}              │\n│ ${Y}${bold}3${norm} to ${C}${bold}Show Statistics.${B}             │\n│ ${Y}${bold}4${norm} to ${R}${bold}Exit${B}.                        │\n"
 echo  -e "╰───────────────────────────────────╯${norm}\n"
 read -sN 1  db
 case $db in
  1) clear;new_game; play_menu;clear;
  ;;
  2) clear;rules;
  ;;
  3) clear;show_statistics;echo -e "\nPress any key to return";read -sN 1 v;clear;
  ;;
  4) clear;notify-send -t 5000 -i $HOME/.cache/wordy/wordy.png "🅴🆇🅸🆃🅴🅳
🆆🅾🆁🅳🆈";
  ;;
  *)clear;echo -e "\n😕 ${Y}${bold}$db${norm} is an invalid key, please try again.\n"   ;
 esac
done
