#!/bin/bash

#readonly INPUT=test_data.txt
readonly INPUT=input

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
| jq ' .game | {set: .sets[][]  , num: .num } ' \
| jq '. | select(.set.red>12 or .set.green>13 or .set.blue>14) ' \
| jq '.num' | awk "{ print \"Game \" \$0 \":\"}" > banned

cat $INPUT \
| grep -f banned -v \
| awk "{ s=s+\$2 } END { print s }"


exit 0
