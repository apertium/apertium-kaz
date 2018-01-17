###############################################################################
## Makefile for apertium-kaz guesser
###############################################################################

LANG1=kaz
BASENAME=apertium-$(LANG1)

all: guesser.lexc.hfst guesser.twol.hfst transducer.hfst guesser.hfst

guesser.lexc.hfst: guesser.lexc
	hfst-lexc $< -o $@
	
guesser.twol.hfst: guesser.twol
	hfst-twolc $< -o $@

transducer.hfst: guesser.lexc.hfst guesser.twol.hfst
	hfst-compose-intersect -1 guesser.lexc.hfst -2 guesser.twol.hfst -o $@

guesser.hfst: guesser.lexc.hfst
	hfst-invert $< | hfst-minimize | hfst-fst2fst -f olw -o $@
