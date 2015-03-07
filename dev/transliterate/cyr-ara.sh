#!/bin/bash

while read line
do
	dayeksheline=`echo "ء$line" | sed 's/ / ء/g'`
	echo "$dayeksheline" | hfst-strings2fst  | hfst-compose-intersect -2 cyr-ara.hfst  | hfst-fst2strings 
done < "${1:-/dev/stdin}"
