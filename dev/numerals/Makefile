all:
	cat numerals.lexc | grep -v 'Dir/LR' > numerals.RL.lexc
	cat numerals.lexc | grep -v 'Dir/RL' > numerals.LR.lexc
	hfst-lexc -f foma numerals.LR.lexc -o numerals.LR.lexc.hfst
	hfst-lexc -f foma numerals.RL.lexc -o numerals.RL.lexc.hfst
	hfst-twolc -f foma numerals.twol -o numerals.twol.hfst
	hfst-compose-intersect -1 numerals.LR.lexc.hfst -2 numerals.twol.hfst -o numerals.LR.gen.hfst
	hfst-compose-intersect -1 numerals.RL.lexc.hfst -2 numerals.twol.hfst -o numerals.RL.gen.hfst
	hfst-invert -i numerals.LR.gen.hfst | hfst-fst2fst -O -o numerals.LR.hfst
	hfst-fst2fst -O -i numerals.RL.gen.hfst -o numerals.RL.hfst

clean:
	rm *.hfst
