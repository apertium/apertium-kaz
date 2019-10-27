all: kaz-ARA.autogen.hfst kaz-MULTI.automorf.hfst

cyr-ara: cyr-ara.ohfst

# create full transcription transducer from lexc and twol transducers
cyr-ara.hfst: cyr-ara.twol.hfst cyr-ara.lexc.hfst
	hfst-compose-intersect -1 cyr-ara.lexc.hfst -2 cyr-ara.twol.hfst -o cyr-ara.hfst

# create transcription transducer optimised-lookup format
cyr-ara.ohfst: cyr-ara.hfst
	hfst-fst2fst -w -i $< -o $@

kaz-ARA.spellrelax.hfst: kaz-ARA.spellrelax.twol
	hfst-twolc $< -o $@

# create a transducer that generates Arabic script from 
# - Cyrillic-to-Arabic transcription transducer
# - Kazakh Cyrillic generation transducer
# оазис<n><px2sg><frm><gen>:ءوازيسىڭىزدىڭ
kaz-ARA.autogen.hfst: cyr-ara.hfst ../../.deps/kaz.RL.hfst
	hfst-compose -1 ../../.deps/kaz.RL.hfst -2 $< -o $@

# Буддизм<n><dat>+шы<emph>:بۋدديزمگەشى
kaz-ARA.REVautomorf.hfst: cyr-ara.hfst ../../.deps/kaz.LR.hfst
	hfst-compose -1 ../../.deps/kaz.LR.hfst -2 $< -o kaz-ARA.REVautomorf.hfst

# بۋدديزمگەشى:Буддизм<n><dat>+шы<emph>
kaz-ARA.automorf.hfst: kaz-ARA.REVautomorf.hfst
	| hfst-invert -o $@

# оазис<n><px2sg><frm><gen>:ءوازيسىڭىزدىڭ
#kaz-ARA.autogen.hfstol: kaz-ARA.autogen.hfst
#	hfst-fst2fst -w -i $< -o $@

# create a transducer that analyses Cyrillic and Arabic scipts from
# - Kazakh analysis transducer + error model
#    лукума<n><attr>:лукума
# - Kazakh Arabic reversed analyser
#    оазис<n><px2sg><frm><gen>:ءوازيسىڭىزدىڭ
kaz-MULTI.automorf.hfst: kaz-ARA.REVautomorf.hfst ../../.deps/kaz.LR.hfst ../../.deps/kaz.LR.err.hfst kaz-ARA.spellrelax.hfst
	hfst-union -1 ../../.deps/kaz.LR.hfst -2 ../../.deps/kaz.LR.err.hfst | hfst-union -1 - -2 kaz-ARA.REVautomorf.hfst | hfst-compose-intersect -1 - -2 kaz-ARA.spellrelax.hfst | hfst-invert | hfst-fst2fst -w -o $@

kaz-MULTI.automorf.hfstol: kaz-MULTI.automorf.hfst
	hfst-fst2fst -w -o $< $@

cyr-ara.lexc.hfst: cyr-ara.lexc
	#hfst-lexc $< | hfst-fst2fst -O -o $@.ohfst
	hfst-lexc $< -o $@

cyr-ara.twol.hfst: cyr-ara.twol
	#hfst-twolc $< | hfst-fst2fst -O -o $@.ohfst
	hfst-twolc $< -o $@

clean:
	rm -rf *.ohfst *.hfst
