#!/bin/bash

#readonly INPUT=test_data.txt
readonly INPUT=input

readonly MAX_GAME=$(cat $INPUT | awk -F ":" "{ print \$1 } " | sed "s/[^0-9]*//g" | sort -n | tail -1)

cat $INPUT \
| awk "{ print  \" {\" \$0 \"] ] }}\" } " \
| sed "s/\:/\:[/" \
| sed "s/\;/\],[/g" \
| awk -F ":" "{ print \$1 \": [\" \$2  } " \
| awk -F ";" "{ for (i=1;i<=NF;i++) print \$i \" ,\"} " \
| sed -e "1i [" -e " \$a {} ]" \
| sed -E "s/([0-9]*)\sblue/{ \"blue\"\: \1 }/g " \
| sed -E "s/([0-9]*)\sred/{ \"red\"\: \1 }/g " \
| sed -E "s/([0-9]*)\sgreen/{ \"green\"\: \1 }/g " \
| sed -E "s/Game\s([0-9]*)\:/\"game\"\: { \"num\": \1, \"sets\"\: / " \
| jq '.[] | select(.game != null ) ' \
| jq ' [ .game | {  set: [ .sets[][] ] , game_num: .num  } ] ' \
| jq ' [ .[] | {s: .set[], game_num: .game_num  } | { red: .s.red, green: .s.green, blue: .s.blue,  game_num}  ]  ' > jazon

cat jazon | grep -v null  | jq '[ .[] ] | sort_by(.red) | max_by(.red)' > fiku
cat jazon | grep -v null  | jq '[ .[] ] | sort_by(.green) | max_by(.green)' >> fiku
cat jazon | grep -v null  | jq '[ .[] ] | sort_by(.blue) | max_by(.blue)' >> fiku

cat fiku | jq  --slurp ' . | sort_by(.game_num) | group_by(.game_num) ' > miku 


echo "" > powers
for((i = 1; i <= $MAX_GAME; i++))
do
  #echo "Game $i:"
  RED=$(cat miku | jq ".[][] | select( .game_num == $i) | .red" | grep -v null)
  #echo "RED=$RED"
  GREEN=$(cat miku | jq ".[][] | select( .game_num == $i) | .green" | grep -v null)
  #echo "GREEN=$GREEN"
  BLUE=$(cat miku | jq ".[][] | select( .game_num == $i) | .blue" | grep -v null)
  #echo "BLUE=$BLUE"
   
  echo "Game $i: " $((RED * GREEN * BLUE)) >> powers
done 

cat powers | awk -F ":" "NF{  s = s + \$2} END { print s }" 

exit 0
