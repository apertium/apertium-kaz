#!/bin/bash

# Takes the basename of the test scrpt in /test-scripts as an argument,
# an addtional argument if the test requires it, and runs the test.
#
# Usage: ./qa.sh (will default to './qa.sh kaz')

if [ $# -eq 0 ]
then
    testToRun=kaz.test
else
    testToRun=$1.test
fi

bash "test-scripts/$testToRun" "$2"
