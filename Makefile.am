###############################################################################
## Makefile for apertium-kaz
###############################################################################

RELEASE=0.1
VERSION=0.1.0
LANG1=kaz
BASENAME=apertium-$(LANG1)

TARGETS_COMMON = $(LANG1).automorf.hfst $(LANG1).autogen.hfst \
	$(LANG1).automorf.bin $(LANG1).autogen.bin $(LANG1).autopgen.bin \
	$(LANG1).automorf.att.gz $(LANG1).autogen.att.gz \
        $(LANG1).rlx.bin $(LANG1).prob

# This include defines goals for install-modes, .deps/.d and .mode files:
@ap_include@

###############################################################################
## Kazakh transducer
###############################################################################

.deps/$(LANG1).twol.hfst: $(BASENAME).$(LANG1).twol .deps/.d
	hfst-twolc $< -o $@

.deps/$(LANG1).RL.lexc: $(BASENAME).$(LANG1).lexc .deps/.d
	cat $< | grep -v 'Dir/LR' > $@

.deps/$(LANG1).LR.lexc: $(BASENAME).$(LANG1).lexc .deps/.d
	cat $< | grep -v 'Dir/RL' > $@

.deps/$(LANG1).RL.lexc.hfst: .deps/$(LANG1).RL.lexc
	hfst-lexc -W -v $< -o $@

.deps/$(LANG1).LR.lexc.hfst: .deps/$(LANG1).LR.lexc
	hfst-lexc -W -v $< -o $@

.deps/$(LANG1).RL.hfst: .deps/$(LANG1).RL.lexc.hfst .deps/$(LANG1).twol.hfst
	hfst-compose-intersect -1 .deps/$(LANG1).RL.lexc.hfst -2 .deps/$(LANG1).twol.hfst -o $@

.deps/$(LANG1).LR.hfst: .deps/$(LANG1).LR.lexc.hfst .deps/$(LANG1).twol.hfst
	hfst-compose-intersect -1 .deps/$(LANG1).LR.lexc.hfst -2 .deps/$(LANG1).twol.hfst -o $@

$(LANG1).autogen.hfst: .deps/$(LANG1).RL.hfst
	hfst-fst2fst -O $< -o $@

$(LANG1).automorf.hfst: .deps/$(LANG1).LR.hfst
	hfst-invert $< | hfst-fst2fst -O -o $@

$(LANG1).autogen.att.gz: $(LANG1).autogen.hfst
	hfst-fst2txt $< | gzip -9 -c -n > $@

$(LANG1).automorf.att.gz: $(LANG1).automorf.hfst
	hfst-fst2txt $< | gzip -9 -c -n > $@

$(LANG1).autogen.bin: $(LANG1).autogen.att.gz .deps/.d
	zcat < $< > .deps/$(LANG1).autogen.att
	lt-comp lr .deps/$(LANG1).autogen.att $@

$(LANG1).automorf.bin: $(LANG1).automorf.att.gz .deps/.d
	zcat < $< > .deps/$(LANG1).automorf.att
	lt-comp lr .deps/$(LANG1).automorf.att $@

$(LANG1).autopgen.bin: $(BASENAME).post-$(LANG1).dix
	lt-comp lr $< $@




###############################################################################
## Debugging transducers (for testvoc)
###############################################################################

debug: .deps/$(LANG1).LR-debug.hfst .deps/$(LANG1).lexc.hfst

.deps/$(LANG1).LR-debug.hfst: $(BASENAME).$(LANG1).lexc .deps/.d
	cat $< | grep -v 'Dir/RL' | grep -v 'Use/Circ' > .deps/$(LANG1).LR-debug.lexc
	hfst-lexc -W -v .deps/$(LANG1).LR-debug.lexc -o .deps/$(LANG1).LR-debug.lexc.hfst
	hfst-compose-intersect -1 .deps/$(LANG1).LR-debug.lexc.hfst -2 .deps/$(LANG1).twol.hfst -o $@

.deps/$(LANG1).lexc.hfst: .deps/$(LANG1).RL.lexc.hfst
	hfst-fst2fst -O -i $< -o $@

###############################################################################
## Disambiguation rules
###############################################################################

$(LANG1).rlx.bin: $(BASENAME).$(LANG1).rlx $(CGCOMP)
	$(CGCOMP) $< $@

###############################################################################
## Unigram tagger 
###############################################################################

$(LANG1).prob: corpus/$(LANG1).tagged
	apertium-tagger -s 0 -u 2 $@ $<

###############################################################################
## Spell checker
###############################################################################

$(LANG1).zhfst: .deps/acceptor.default.hfst .deps/errmodel.default.hfst
	rm -f $@
	zip -Z store -j $@ .deps/acceptor.default.hfst .deps/errmodel.default.hfst speller/index.xml

.deps/editdist.default.hfst: speller/editdist.default.txt .deps/acceptor.default.hfst
	python dev/editdist.py -v -s -d 1 -e '@0@' -i $< -a .deps/acceptor.default.hfst >$@.txt
	hfst-txt2fst -i $@.txt -e '@0@' -o $@
	rm -f $@.txt

.deps/editstrings.default.hfst: .deps/strings.default.hfst .deps/editdist.default.hfst
	hfst-disjunct $^ | hfst-minimise | hfst-repeat -f 1 -t 2 -o $@

.deps/errmodel.default.hfst: .deps/words.default.hfst .deps/editstrings.default.hfst
	hfst-disjunct $^ | hfst-fst2fst -f olw -o $@

.deps/words.default.hfst: speller/words.default.txt
	grep -v -e "^#" -e "^$$" $< | hfst-strings2fst  -j -o $@

.deps/strings.default.hfst: speller/strings.default.txt .deps/anystar.hfst
	grep -v -e "^#" -e "^$$" $< | hfst-strings2fst  -j | hfst-concatenate .deps/anystar.hfst - \
	  | hfst-concatenate - .deps/anystar.hfst -o $@

.deps/anystar.hfst:
	echo "?*;" | hfst-regexp2fst -S -o $@

.deps/acceptor.default.hfst: $(LANG1).autogen.hfst .deps/.d
	cat $< | hfst-fst2fst -t | hfst-project  --project=lower | hfst-minimise |hfst-fst2fst  -f olw -o $@


###############################################################################
## Distribution
###############################################################################
EXTRA_DIST=$(BASENAME).$(LANG1).lexc \
	   $(BASENAME).$(LANG1).twol \
	   $(BASENAME).$(LANG1).rlx  \
	   modes.xml

###############################################################################
## Installation stuff
###############################################################################
#
#   apertium_kaz_dir: This is where the compiled binaries go
#   apertium_kaz_srcdir: This is where the source files go

apertium_kazdir=$(prefix)/share/apertium/$(BASENAME)/
apertium_kaz_srcdir=$(prefix)/share/apertium/$(BASENAME)/

EXTRA_TARGETS=

if HAVE_HFSTOSPELL
EXTRA_TARGETS += $(LANG1).zhfst
endif # HAVE_HFSTOSPELL

apertium_kaz_DATA=$(TARGETS_COMMON) $(EXTRA_TARGETS)

pkgconfigdir = $(prefix)/share/pkgconfig
pkgconfig_DATA = $(BASENAME).pc

noinst_DATA=modes/$(LANG1)-morph.mode

install-data-local: install-modes
	test -d $(DESTDIR)$(apertium_kaz_srcdir) || mkdir -p $(DESTDIR)$(apertium_kaz_srcdir)
	$(INSTALL_DATA) $(BASENAME).$(LANG1).lexc $(DESTDIR)$(apertium_kaz_srcdir)
	$(INSTALL_DATA) $(BASENAME).$(LANG1).twol $(DESTDIR)$(apertium_kaz_srcdir)
	$(INSTALL_DATA) $(BASENAME).$(LANG1).rlx $(DESTDIR)$(apertium_kaz_srcdir)

###############################################################################
## Cleanup
###############################################################################


CLEANFILES = $(TARGETS_COMMON)
clean-local:
	-rm -rf .deps modes
