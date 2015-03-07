all: cyr-ara ara-kaz lat-kaz

cyr-ara: cyr-ara.twol
	hfst-twolc $< | hfst-fst2fst -O -o $@.ohfst
	hfst-twolc $< -o $@.hfst

ara-kaz: ara-kaz.twol
	hfst-twolc $< | hfst-fst2fst -O -o $@.ohfst
	hfst-twolc $< -o $@.hfst

lat-kaz: lat-kaz.twol
	hfst-twolc $< | hfst-fst2fst -O -o $@.ohfst
	hfst-twolc $< -o $@.hfst

clean:
	rm -rf *.ohfst *.hfst
