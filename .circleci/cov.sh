#!/bin/bash

CORPUS=$1

aq-covtest /tmp/${CORPUS}.kaz.txt kaz.automorf.bin | tee /tmp/covtestlog
cat /tmp/covtestlog | grep 'Coverage: ' | sed 's/Coverage: \(.*\)%/\1/g' > /tmp/res/cov.${CORPUS}.txt
echo "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"81\" height=\"20\"><linearGradient id=\"a\" x2=\"0\" y2=\"100%\"><stop offset=\"0\" stop-color=\"#bbb\" stop-opacity=\".1\"/><stop offset=\"1\" stop-opacity=\".1\"/></linearGradient><rect rx=\"3\" width=\"81\" height=\"20\" fill=\"#555\"/><rect rx=\"3\" x=\"37\" width=\"44\" height=\"20\" fill=\"#e05d44\"/><path fill=\"#e05d44\" d=\"M37 0h4v20h-4z\"/><rect rx=\"3\" width=\"81\" height=\"20\" fill=\"url(#a)\"/><g fill=\"#fff\" text-anchor=\"middle\" font-family=\"DejaVu Sans,Verdana,Geneva,sans-serif\" font-size=\"11\"><text x=\"19.5\" y=\"15\" fill=\"#010101\" fill-opacity=\".3\">jam</text><text x=\"19.5\" y=\"14\">jam</text><text x=\"58\" y=\"15\" fill=\"#010101\" fill-opacity=\".3\">$(cat /tmp/res/cov.${CORPUS}.txt)%</text><text x=\"58\" y=\"14\">$(cat /tmp/res/cov.${CORPUS}.txt)%</text></g></svg>" > /tmp/res/cov.${CORPUS}.svg