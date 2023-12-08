#!/bin/bash


#readonly INPUT=other.txt
readonly INPUT=input

#readonly INPUT=test_data.txt

readonly LAST_LINE_NUMBER=$(cat $INPUT | wc -l)


function process_line {
  
  LINE=$(head -$1 $INPUT | tail -1)
  echo $LINE | sed "s/[^0-9]/\n/g" |sed "s/[^0-9]//g" |  awk "NF { print \$1}"  > numz_in_line_$1

  if [[ "$1" == '1' ]]
  then
    BEFORE=$(echo $LINE | sed "s/././g")
  else
    preced=$(($1 - 1))
    BEFORE=$(head -$preced $INPUT | tail -1)
  fi
  if [[ "$1" == "$LAST_LINE_NUMBER" ]]
  then
    AFTER=$(echo $LINE | sed "s/././g")
  else
    succ=$(($1 + 1))
    AFTER=$(head -$succ $INPUT | tail -1)
  fi

  num_of_numz_in_line=$(cat numz_in_line_$1 | wc -l)
  for ((i=1; i<=$num_of_numz_in_line; i++))
  do
    the_num=$( cat numz_in_line_$1 |  head -$i | tail -1)
    num_len=${#the_num}
    num_idx=$(echo $LINE | awk " { print index(\$0, \"$the_num\") }")

    offs=$((num_idx-1))
    if [[ "$num_idx" == "1" ]]
    then 
        lim=$((num_len+1))
    else
        lim=$((num_len+2))
    fi
 
    if [[ "$the_num" == "717dsafaewfew" ]]
    then 
    echo "========== $the_num" 
    echo $BEFORE | awk "{ print substr(\"$BEFORE\", $offs, $lim ) }"
    echo $LINE | awk "{ print substr(\"$LINE\", $offs, $lim ) }"
    echo $AFTER | awk "{ print substr(\"$AFTER\", $offs, $lim ) }"

    fi

    B=$(echo $BEFORE | awk "{ print substr(\"$BEFORE\", $offs, $lim ) }" | sed -e "s/\.//g" -e "s/[0-9]//g")
    L=$(echo $LINE | awk "{ print substr(\"$LINE\", $offs, $lim ) }" | sed -e "s/\.//g" -e "s/[0-9]//g")
    A=$(echo $AFTER | awk "{ print substr(\"$AFTER\", $offs, $lim ) }" | sed -e "s/\.//g" -e "s/[0-9]//g")
    if [[ "$B$L$A" != "" ]]
    then
      echo $the_num
    fi

    LINE=$(echo $LINE | awk "{ print substr(\"$LINE\", $((offs+lim-1)))} ")
    BEFORE=$(echo $BEFORE | awk "{ print substr(\"$BEFORE\", $((offs+lim-1)))} ")
    AFTER=$(echo $AFTER | awk "{ print substr(\"$AFTER\", $((offs+lim-1)))} ")
  done
  
  
}


for ((curr_line=1; curr_line<=$LAST_LINE_NUMBER; curr_line++))
do
  process_line $curr_line
done


