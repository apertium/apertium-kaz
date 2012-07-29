all:
	hfst-lexc numerals.lexc -o numerals.lexc.hfst
	hfst-twolc numerals.twol -o numerals.twol.hfst
	hfst-compose-intersect -1 numerals.lexc.hfst -2 numerals.twol.hfst -o numerals.hfst

clean:
	rm *.hfst
