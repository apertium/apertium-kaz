all:
	hfst-twolc kaz-ara.twol | hfst-fst2fst -O -o kaz-ara.ohfst
	hfst-twolc ara-kaz.twol -o ara-kaz.hfst
	hfst-twolc lat-kaz.twol -o lat-kaz.hfst
	hfst-twolc ara-kaz.twol | hfst-fst2fst -O -o ara-kaz.ohfst
	hfst-twolc lat-kaz.twol | hfst-fst2fst -O -o lat-kaz.ohfst

clean:
	rm -rf *.ohfst
