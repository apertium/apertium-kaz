#!/bin/bash

TESTTYPE="$1_tests"
SRCLANG="$2"
TRGLANG="3"
mode="$SRCLANG-tagger"
HTML="dev/$TESTTYPE.html"

if [ "$#" -lt 3 ]; then echo "Usage: wiki-tests.sh {Regression,Pending} SRCLANG [update]"; exit 1; fi

printf "Running $1-tests with mode \"$mode\""
if [ "$4" == "update" ]; then
    printf " with updated tests..."
    TMPHTML=`mktemp -t tmp.$SRCLANG-html.XXXXXXXXXX`;
    wget -O $TMPHTML -q https://wiki.apertium.org/wiki/Apertium-kaz/$TESTTYPE
    if [[ -s $TMPHTML ]]; then mv $TMPHTML $HTML;
    else rm $TMPHTML; echo "Couldn't fetch https://wiki.apertium.org/wiki/Kazakh_and_Tatar/$TESTTYPE"; fi
fi
echo "..."

if [[ ! -s $HTML ]]; then echo "$HTML does not exist or is empty (use 'update' option)"; exit 1; fi


# Mac mktemp has no default template, this works on both
SRCLIST=`mktemp -t tmp.$SRCLANG-src.XXXXXXXXXX`;
TRGLIST=`mktemp -t tmp.$SRCLANG-trg.XXXXXXXXXX`;
TSTLIST=`mktemp -t tmp.$SRCLANG-tst.XXXXXXXXXX`;

ECHOE="echo -e"
SED=sed
if test x$(uname -s) = xDarwin; then 
	ECHOE="builtin echo"
	SED=gsed
fi


cleansrc () {
    grep "<li> ($SRCLANG)" | $SED 's/<.*li>//g' | $SED 's/ /_/g' | cut -f2 -d')' | $SED 's/<i>//g' | $SED 's/<\/i>//g' | cut -f2 -d'*' | $SED 's/→/!/g' | cut -f1 -d'!' | $SED 's/(note:/!/g' | $SED 's/_/ /g' | $SED 's/^ *//g' | $SED 's/ *$//g' | $SED 's/\([^,.?!:;]\)$/\1./g' |\
    if [ "$TRGLANG" == "nob-old" ]; then
        # split into one lexical unit per line
	$SED 's/[.]*$/. /' | $SED 's/\([,?.]\) / \1 /g'  | sed 's/?/ ?/g' | $SED 's/$/\n¶/g' | $SED 's/ /\n/g' | grep -v '^ *$'
    else
	cat
    fi
}
cleantrg () {
    grep "<li> ($SRCLANG)" | $SED 's/<.*li>//g' | $SED 's/ /_/g' | $SED 's/(\w\w)//g' | $SED 's/<i>//g' | cut -f2 -d'*' | $SED 's/<\/i>_→/!/g' | cut -f2 -d'!' | $SED 's/_/ /g' | $SED 's/^ *//g' | $SED 's/ *$//g' | $SED 's/\([^,.?!:;]\)$/\1/g' | $SED 's/&lt;/</g' | $SED 's/&gt;/>/g'
}
cat $HTML | cleansrc > $SRCLIST;
cat $HTML | cleantrg > $TRGLIST;


# Translate
apertium -d . $mode < $SRCLIST > $TSTLIST;

if [ "$TRGLANG" == "nob-old" ]; then
    # put back on one line
    cat $SRCLIST | $SED 's/\.$//g' | $SED 's/$/ /g' | $SED ':a;N;$!ba;s/\n//g' | $SED 's/¶/\n/g' | $SED 's/^ *//g'  | $SED 's/ \([,?.]\) /\1 /g' | grep -v '^ *$' > $SRCLIST.n; mv $SRCLIST.n $SRCLIST;
    cat $TRGLIST | $SED 's/\.$//g' > $TRGLIST.n; mv $TRGLIST.n $TRGLIST;
    cat $TSTLIST | $SED 's/\.$//g' | $SED 's/\t/ /g'  | $SED 's/$/ /g' | $SED ':a;N;$!ba;s/\n//g' | $SED 's/\\@¶/\n/g' | $SED 's/^ *//g'  | grep -v '^$' | $SED 's/ \([,?.]\) /\1 /g' > $TSTLIST.n; mv $TSTLIST.n $TSTLIST;
fi

mode=`echo $mode | sed 's/-debug//g'`;

# Output the MT vs ref translations:
TOTAL=0
CORRECT=0
for LINE in `paste $SRCLIST $TRGLIST $TSTLIST | $SED 's/ /%_%/g' | $SED 's/\t/!/g'`; do
	SRC=`echo $LINE | $SED 's/%_%/ /g' | cut -f1 -d'!' | $SED 's/^ *//g' | $SED 's/ *$//g' | $SED 's/   */ /g'`;
	TRG=`echo $LINE | $SED 's/%_%/ /g' | cut -f2 -d'!' | $SED 's/^ *//g' | $SED 's/ *$//g' | $SED 's/   */ /g' | sed 's/::/%/g' | cut -f1 -d'%'`;
	TST=`echo $LINE | $SED 's/%_%/ /g' | cut -f3 -d'!' | $SED 's/^ *//g' | $SED 's/ *$//g' | $SED 's/   */ /g'`;

	if [ "$LINE" = "!!" ]; then
		continue;
	fi
	echo $TRG | grep "^${TST}$" > /dev/null;
	if [ $? -eq 1 ]; then
		$ECHOE $mode"\t  ${SRC}\n\t- ${TRG}\n\t+ ${TST}\n\n";
	else
		$ECHOE $mode"\t  ${SRC}\nWORKS\t  ${TST}\n\n";
		CORRECT=`expr $CORRECT + 1`;
	fi
	TOTAL=`expr $TOTAL + 1`;
done


# Output the sums:
CALC=
WORKING=
if [ -x /usr/bin/calc ]; then
    CALC="/usr/bin/calc"
elif [ -x /opt/local/bin/calc ]; then
    CALC="/opt/local/bin/calc"
fi
if [ -n $CALC ]; then
	WORKING=`$CALC $CORRECT" / "$TOTAL" * 100" | head -c 7`;
	WORKING=", "$WORKING"%";
fi
echo $CORRECT" / "$TOTAL$WORKING;

#rm $SRCLIST $TRGLIST $TSTLIST;
#echo $SRCLIST $TRGLIST $TSTLIST;
