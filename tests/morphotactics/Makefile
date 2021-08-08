# A makefile which trims the transducer to prefixes in /prefixes
# and expands trimmed transducers into text files in the current
# directory.

LANGUAGE=kaz
TRANSDUCER=../../.deps/$(LANGUAGE).LR.clear.hfst

# excluded: NUM-ROMAN.txt.gz NUM-ITG.txt.gz
all: N1.txt.gz N1-RUS.txt.gz N-COMPOUND-PX.txt.gz \
	A1.txt.gz \
	ADV.txt.gz ADV-ITG.txt.gz \
	NUM.txt.gz POST.txt.gz CNJ.txt.gz \
	PRN.txt.gz \
	DET.txt.gz
.deps/.d:
	test -d .deps || mkdir .deps
	touch $@

.PRECIOUS: .deps/.d



.deps/%.prefix.bin: prefixes/%.prefix.dix .deps/.d
	lt-comp lr $< $@

.deps/%.prefix.att: .deps/%.prefix.bin
	lt-print $< | sed 's/ /@_SPACE_@/g' > $@

.deps/%.prefix.hfst: .deps/%.prefix.att
	hfst-txt2fst -e ε < $< > $@

.deps/%.prefix.upper: .deps/%.prefix.hfst
	hfst-project -p upper $< > $@

.deps/any-symbol.hfst:
	echo " ?* " | hfst-regexp2fst > $@

.deps/%.prefixes: .deps/%.prefix.upper .deps/any-symbol.hfst
	hfst-concatenate -1 $< -2 .deps/any-symbol.hfst -o $@

.deps/$(LANGUAGE).automorf.hfst: $(TRANSDUCER)
	if test -z "$$TRIMDIX"; then hfst-invert $< -o $@; else hfst-invert $< | hfst-compose-intersect -1 - -2 "$$TRIMDIX" -o $@ ; fi;
	#hfst-invert $< -o $@
	#zcat $< | hfst-txt2fst > $@

.deps/%.hfst: .deps/%.prefixes .deps/$(LANGUAGE).automorf.hfst 
	hfst-compose-intersect -1 .deps/$(LANGUAGE).automorf.hfst -2 $< -o $@

%.txt.gz: .deps/%.hfst
	hfst-fst2strings -c 1 $< | gzip -c > $@

%.txt.zstd: .deps/%.hfst
	hfst-fst2strings -c 1 $< | zstd -o $@
