all:
	hfst-lexc -f foma numerals.lexc -o numerals.lexc.hfst
	hfst-twolc numerals.twol -o numerals.twol.hfst
	hfst-compose-intersect -1 numerals.lexc.hfst -2 numerals.twol.hfst -o numerals.gen.hfst
	hfst-invert -i numerals.gen.hfst | hfst-fst2fst -O -o numerals.hfst

clean:
	rm *.hfst
