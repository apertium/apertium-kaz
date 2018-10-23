## A script for converting kaz-tagger mode's output into a tab-separated,
## easy-to-annotate format.
##
## INPUT: apertium-kaz$ echo "бақшада ма, қайда?" | apertium -d . kaz-tagger
## ^бақшада ма/бақша<n><loc>+ма<qst>$^,/,<cm>$ ^қайда/қайда<adv><itg>+е<cop><aor><p3><sg>$^?/?<sent>$^./.<sent>$
##
## OUTPUT: apertium-kaz$ echo "бақшада ма, қайда?" | apertium -d . kaz-tagger | python3 corpus/format.py 
## бақшада ма      бақша   n loc +ма qst
## ,       ,       cm
## қайда   қайда   adv itg +е cop aor p3 sg
## ?       ?       sent
##.       .       sent

import sys, streamparser

for lu in streamparser.parse_file(sys.stdin):
    print(lu.wordform, end="\t")
    for r in lu.readings:
        print(r[0].baseform, end="\t")
        print(" ".join(r[0].tags), end="")
        if len(r) > 1:
            for s in r[1:]:
                print(" +" + s.baseform, " ".join(s.tags), end="")
    print("\t\t\t")
