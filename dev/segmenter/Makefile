LANG1=kaz
BASENAME=apertium-$(LANG1)


all: kaz.segmenter.hfst

#../../.deps/$(LANG1).LR.lexc: ../../$(BASENAME).$(LANG1).lexc
#	cat $< | grep -v -e 'Dir/RL' > $@
#
#../../.deps/$(LANG1).LR.lexc.hfst: ../../.deps/$(LANG1).LR.lexc
#	hfst-lexc --Werror $< -o $@ -v
#
#../../.deps/$(LANG1).EL.lexc: ../../$(BASENAME).$(LANG1).lexc
#	cat $< | grep -v -e 'Err/Orth' > $@
#
#../../.deps/$(LANG1).EL.lexc.hfst: ../../.deps/$(LANG1).EL.lexc
#	hfst-lexc --Werror $< -o $@ -v
#
#.deps/$(LANG1).twol.hfst: $(BASENAME).$(LANG1).twol .deps/.d
#	hfst-twolc $< -o $@
#
#../../.deps/$(LANG1).LR.hfst: ../../.deps/$(LANG1).LR.lexc.hfst ../../.deps/$(LANG1).EL.lexc.hfst ../../.deps/$(LANG1).twol.hfst
#	hfst-compose-intersect -1 .deps/$(LANG1).EL.lexc.hfst -2 .deps/$(LANG1).twol.hfst | hfst-minimise -o $@
#
## error model
#../../.deps/$(LANG1).LR.err.hfst: ../../.deps/$(LANG1).LR.lexc.hfst ../../.deps/$(LANG1).err.hfst .deps/$(LANG1).LR.hfst
## lexc + error model twol
#	hfst-compose-intersect -1 ../../.deps/$(LANG1).LR.lexc.hfst -2 ../../.deps/$(LANG1).err.hfst | hfst-minimise -o ../../.deps/$(LANG1).LR.err.hfst.tmp
## extract valid surface forms
#	hfst-project -p output .deps/kaz.LR.hfst | hfst-minimise -o ../../.deps/$(LANG1).LR.corr.hfst.tmp
## get the valid surface forms that are in the error model
#	hfst-invert .deps/$(LANG1).LR.err.hfst.tmp | hfst-compose -1 ../../.deps/$(LANG1).LR.corr.hfst.tmp -2 - | hfst-invert -o ../../.deps/$(LANG1).LR.err.hfst.tmp2
## subtract the valid surface forms from the error model
#	hfst-subtract -1 ../../.deps/$(LANG1).LR.err.hfst.tmp -2 ../../.deps/$(LANG1).LR.err.hfst.tmp2 -o ../../.deps/$(LANG1).LR.err.hfst.tmp3
## append the error tag to the error model strings
#	echo "<err_orth>:0" | hfst-strings2fst -e 0 -S | hfst-concatenate -1 ../../.deps/$(LANG1).LR.err.hfst.tmp3 -2 - -o $@
#
## normative analyser
#../../$(LANG1).automorf.hfst: ../../.deps/$(LANG1).LR.hfst ../../.deps/$(LANG1).LR.err.hfst
#	hfst-union -1 ../../.deps/$(LANG1).LR.hfst -2 ../../.deps/$(LANG1).LR.err.hfst | hfst-invert | hfst-fst2fst -w -o $@

#$(LANG1).automorf.hfst: .deps/$(LANG1).LR.hfst .deps/$(LANG1).LR.err.hfst

$(LANG1)-seg.twol.hfst: apertium-kaz.kaz-seg.twol
	hfst-twolc $< -o $@

$(LANG1)-seg.hfst: ../../.deps/$(LANG1).LR.lexc.hfst $(LANG1)-seg.twol.hfst
	hfst-compose-intersect -1 ../../.deps/$(LANG1).LR.lexc.hfst -2 $(LANG1)-seg.twol.hfst | hfst-minimise -o $@

$(LANG1).segmenter.hfst: ../../$(LANG1).automorf.hfst $(LANG1)-seg.hfst
	hfst-union -1 ../../.deps/$(LANG1).LR.hfst -2 ../../.deps/$(LANG1).LR.err.hfst | hfst-invert | hfst-minimise -o $(LANG1).tmp.hfst
	hfst-compose-intersect -1 $(LANG1).tmp.hfst -2 $(LANG1)-seg.hfst | hfst-fst2fst -w -o $@
