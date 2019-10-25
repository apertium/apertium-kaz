all: kaz-ARA.automorf.hfst

cyr-ara: cyr-ara.ohfst

cyr-ara.hfst: cyr-ara.twol.hfst cyr-ara.lexc.hfst
	hfst-compose-intersect -1 cyr-ara.lexc.hfst -2 cyr-ara.twol.hfst -o cyr-ara.hfst

cyr-ara.ohfst: cyr-ara.hfst
	hfst-fst2fst -w -i $< -o $@

kaz-ARA.automorf.hfst: cyr-ara.hfst
	hfst-compose-intersect -1 ../../.deps/kaz.RL.hfst -2 $< -o temp.hfst
	hfst-fst2fst -w -i temp.hfst -o $@

cyr-ara.lexc.hfst: cyr-ara.lexc
	#hfst-lexc $< | hfst-fst2fst -O -o $@.ohfst
	hfst-lexc $< -o $@

cyr-ara.twol.hfst: cyr-ara.twol
	#hfst-twolc $< | hfst-fst2fst -O -o $@.ohfst
	hfst-twolc $< -o $@

clean:
	rm -rf *.ohfst *.hfst
