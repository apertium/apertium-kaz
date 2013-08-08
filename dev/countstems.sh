#!/bin/bash

LEXC=../apertium-kaz.kaz.lexc

allcounts=`hfst-lexc --format foma $LEXC -o /dev/null 2>&1 | grep Root | sed 's/,/\n/g'`

for line in $allcounts; do
	thing=`echo $line | sed -r 's/(.*)\.\.\.([0-9]*),?/\1/'`;
	numbr=`echo $line | sed -r 's/(.*)\.\.\.([0-9]*),?/\2/'`;
	if [[ "$thing" == "Root" ]]; then
		rootsize=$numbr;
		root=`grep -A$rootsize Root $LEXC | grep -v Root`;
	fi;
done;

root=`echo $root | sed -r 's/\s*;/\n/g'`;

string=""
for line in $allcounts; do
	thing=`echo $line | sed -r 's/(.*)\.\.\.([0-9]*),?/\1/'`;
	numbr=`echo $line | sed -r 's/(.*)\.\.\.([0-9]*),?/\2/'`;
	for thingname in $root; do
		if [ "$thing" = "$thingname" ]; then
			string="$string + $numbr";
		fi;
	done;
done;

echo `calc $string`;
