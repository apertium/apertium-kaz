#!/bin/bash

diff expected.txt <(cat input.txt | tr '\n' '|' |\
                    apertium -d ../../ kaz-morph |\
                    tr '|' '\n' |\
                    cg-conv -l)
