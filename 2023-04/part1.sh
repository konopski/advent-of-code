#!/bin/bash


#readonly INPUT=other.txt
readonly INPUT=input
#readonly INPUT=test_data.txt

readonly LAST_LINE_NUMBER=$(cat $INPUT | wc -l)


function process_line {
 
  LINE=$(head -$1 $INPUT | tail -1)
  echo $LINE | sed "s/^Card [0-9]*://" | awk -F "|" "NF { print \$1 }" | sed "s/[^0-9]/\n/g" |  awk "NF { print \"^\"\$0\"$\"}"  > expr_$1

  echo $LINE | sed "s/^Card [0-9]*://" | awk -F "|" "NF { print \$2 }" | sed "s/[^0-9]/\n/g" |  awk "NF { print \$0}"| grep -f expr_$1 | echo $(($(wc -l) - 1))  | awk " { if(0<=\$0) { print 2**\$0 } else { print 0} }"
  
}


for ((curr_line=1; curr_line<=$LAST_LINE_NUMBER; curr_line++))
do
  process_line $curr_line
done


