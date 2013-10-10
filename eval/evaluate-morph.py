#!/usr/bin/python3
# coding=utf-8
# -*- encoding: utf-8 -*-

import sys;

# Input is two files, one LU per line:
#
# ^айрымаланып/айрымала<v><tv><pass><gna_perf>/айрымала<v><tv><pass><prc_real>$
# ^өнүгүшүн/өнүк<v><tv><ger_pres><px3pl><acc>/өнүк<v><tv><ger_pres><px3sg><acc>$
# ^убакка/убак<n><dat>$
# ^Бордюжа/*Бордюжа$
# ^кытайлыктар/*кытайлыктар$
# ^акысынын/акы<n><px3pl><gen>/акы<n><px3sg><gen>$
# ^атышат/ат<v><tv><aor><p3><pl>/ат<v><tv><coop><aor><p3><pl>/ат<v><tv><coop><aor><p3><sg>/ат<v><tv><coop><prc_irre>/атыш<v><iv><aor><p3><pl>/атыш<v><iv><aor><p3><sg>/атыш<v><iv><prc_irre>/жат<vaux><aor><p3><pl>/жат<vaux><coop><aor><p3><pl>/жат<vaux><coop><aor><p3><sg>/жат<vaux><coop><prc_irre>$
# ^Армения/Армения<np><top><nom>$
# 
# The first file is the TEST file, the second is the REF file

# The program calculates precision, recall and F-score.
# The program also calculates for each line, the analysis diff.

# precision = number of correct analyses / (number of correct analyses + number of incorrect analyses)
# recall = number of correct analyses / (number of correct analyses + number of missing analyses)
# F-score = (precision * recall) / (precision + recall)

tst = open(sys.argv[1]);
ref = open(sys.argv[2]);
reading = True;

def parse_line(s): #{
	entry = ('', []); # e.g. ('акысынын', ['акы<n><px3pl><gen>', 'акы<n><px3sg><gen>'])

	line = ''.join(s[1:-1]); # strip ^ and $
	row = line.split('/');
	entry = (row[0], row[1:]);
	
	return entry;
#}

missing_analyses = 0.0;
incorr_analyses = 0.0;
corr_analyses = 0.0;
unknown_words = 0.0;

missing = {};
incorrect = {};


while reading: #{
	tst_line = tst.readline().strip();
	ref_line = ref.readline().strip();

	if tst_line == '' and ref_line == '': #{
		reading = False;
	#}

	tst_entry = parse_line(tst_line);
	ref_entry = parse_line(ref_line);

	for a in tst_entry[1]: #{
		# If an entry is in the test, _and_ in the reference, it is correct
		if a in ref_entry[1]: #{
			corr_analyses += 1.0;
		elif a[0] == '*': #{
			unknown_words += 1.0;		
		# If an entry is in the test, but not in the reference, it is incorrect
		else: #{
			incorr_analyses += 1.0;
			if tst_entry[0] not in incorrect: #{
				incorrect[tst_entry[0]] = [];
			#}
			incorrect[tst_entry[0]].append(a);
		#}
	#}

	for a in ref_entry[1]: #{
		# If an entry is in the reference, but not in the test, it is missing
		if a not in tst_entry[1]: #{
			missing_analyses += 1.0;
			if ref_entry[0] not in missing: #{
				missing[ref_entry[0]] = [];
			#}
			missing[ref_entry[0]].append(a);
		#}
	#}

#	print(tst_entry);
#	print(ref_entry);
#}

# precision = number of correct analyses / (number of correct analyses + number of incorrect analyses)
# recall = number of correct analyses / (number of correct analyses + number of missing analyses)
# F-score = (precision * recall) / (precision + recall)

print('Missing analyses:\n');

for w in missing: #{
	sys.stdout.write('^' + w + '/');
	for a in missing[w]: #{
		sys.stdout.write(a);
		if a != missing[w][-1]: #{
			sys.stdout.write('/');
		#}
	#}
	sys.stdout.write('$\n');
#}

print('\nIncorrect analyses:\n');

for w in incorrect: #{
	sys.stdout.write('^' + w + '/');
	for a in incorrect[w]: #{
		sys.stdout.write(a);
		if a != incorrect[w][-1]: #{
			sys.stdout.write('/');
		#}
	#}
	sys.stdout.write('$\n');
#}

print('\nRendiment:\n');

precision = (corr_analyses / (corr_analyses + incorr_analyses)) * 100.0;
recall = (corr_analyses / (corr_analyses + missing_analyses)) * 100.0;
fscore = 2 * ((precision * recall) / (precision + recall));

print('Precision: ' + str(precision));
print('Recall: ' + str(recall));
print('F-score: ' + str(fscore));
print(str(precision) + '\t' + str(recall) + '\t' + str(fscore), file=sys.stderr);
