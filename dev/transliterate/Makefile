all:
	hfst-twolc kaz-ara.twol | hfst-fst2fst -O -o kaz-ara.ohfst
	hfst-twolc ara-kaz.twol | hfst-fst2fst -O -o ara-kaz.ohfst

clean:
	rm -rf *.ohfst
