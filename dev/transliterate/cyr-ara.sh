#!/bin/bash

while read line
do
	dayeksheline=`echo "ء$line" | sed 's/ / ء/g' | sed 's/-/-ء/g'`
	outline=`echo "$dayeksheline" | hfst-strings2fst  | hfst-compose-intersect -2 cyr-ara.hfst  | hfst-fst2strings`
	echo $outline | sed -r 's/(.*):(.*)/\2/'
done < "${1:-/dev/stdin}"
