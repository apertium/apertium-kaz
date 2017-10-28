all: cyr-ara ara-cyrl lat-kaz cyr-lat1710.hfst

cyr-ara: cyr-ara.twol
	hfst-twolc $< | hfst-fst2fst -O -o $@.ohfst
	hfst-twolc $< -o $@.hfst

ara-cyrl: ara-cyrl.twol
	hfst-twolc $< | hfst-fst2fst -O -o $@.ohfst
	hfst-twolc $< -o $@.hfst

lat-kaz: lat-kaz.twol
	hfst-twolc $< | hfst-fst2fst -O -o $@.ohfst
	hfst-twolc $< -o $@.hfst

#lat1710-cyr.hfst: lat1710-cyr.twol lat1710-cyr.lexc
#	hfst-twolc -i lat1710-cyr.twol -o lat1710-cyr.twol.hfst
#	hfst-lexc lat1710-cyr.lexc -o lat1710-cyr.lexc.hfst
#	hfst-compose-intersect -1 lat1710-cyr.lexc.hfst -2 lat1710-cyr.twol.hfst -o lat1710-cyr.hfst
#	hfst-fst2fst -w -i lat1710-cyr.hfst -o lat1710-cyr.hfstol

cyr-lat1710.hfst: cyr-lat1710.twol cyr-lat1710.lexc
	hfst-twolc -i cyr-lat1710.twol -o cyr-lat1710.twol.hfst
	hfst-lexc cyr-lat1710.lexc -o cyr-lat1710.lexc.hfst
	hfst-compose-intersect -1 cyr-lat1710.lexc.hfst -2 cyr-lat1710.twol.hfst -o cyr-lat1710.hfst
	hfst-fst2fst -w -i cyr-lat1710.hfst -o cyr-lat1710.hfstol


clean:
	rm -rf *.ohfst *.hfst
