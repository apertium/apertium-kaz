#!/bin/bash

# Absolute path to this script, e.g. /home/user/bin/foo.sh
SCRIPT=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/bin
SCRIPTPATH=$(dirname "$SCRIPT")

while read line
do
	dayeksheline=`echo "ء$line" | sed 's/ / ء/g' | sed 's/-/-ء/g'`
	outline=`echo "$dayeksheline" | hfst-strings2fst  | hfst-compose-intersect -2 $SCRIPTPATH/cyr-ara.hfst  | hfst-fst2strings`
	echo $outline | sed -r 's/(.*):(.*)/\2/'
done < "${1:-/dev/stdin}"
