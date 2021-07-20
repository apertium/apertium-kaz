#!/bin/bash

# Outputs stats about performance of the CG grammar on a manually disambiguated
# (VISL format with <Correct!> marks) CORPUS. In particular:
#   * number of remaining incorrect readings ("false negatives")
#       - no ';', no '<Correct!>' mark on line
#   * number of false positives
#       - ';' at the beginning of the line, '<Correct!>' mark at the end
# In other words,
#   false negatives = readings which CG should've discarded, but did not,
#   false positives = readings which CG discarded, but really shouldn't have.
#
# Assumes that lines containing readings start with a tab, and that the main
# reading has only one leading tab, while subreadings have two or more.
#
# USAGE: ./qa.sh cg

CG="vislcg3 -t -g apertium-kaz.kaz.rlx"
CORPUS="test/corpus.kaz.disambiguated.txt"
CGOUT="/tmp/cgOut.txt"

cat $CORPUS | $CG > $CGOUT

falseNegatives=$(cat $CGOUT | grep -v '^;' |  grep $'^\t[^\t]' | grep -v -c '<Correct!>')
falsePositives=$(grep -c '^;.*<Correct!>' $CGOUT)

echo "False negatives: $falseNegatives; False positives: $falsePositives"
