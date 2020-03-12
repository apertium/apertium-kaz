#lang scribble/manual

@title[#:version "0.1.0"]{@tt{APERTIUM-KAZ}: A MORPHOLOGICAL TRANSDUCER AND
 DISAMBIGUATOR FOR KAZAKH}

@margin-note{WARNING: this is an early draft.}

What follows is the documentation for @tt{apertium-kaz} -- a morphological
transducer and disambiguator for Kazakh. First draft of this documentation was
written, or, rather, assembled from various writings on
@hyperlink["https://wiki.apertium.org"]{Apertium's wiki} and then extended with
more details by @hyperlink["http://github.com/IlnarSelimcan"]{selimcan} on
September-October 2018 for members of the `Deep Learning for Sequential Models
in Natural Language Processing with Applications to Kazakh'
(@italic{dlsmnlpak}) research group at Nazarbayev University and
elsewhere. That being said, I hope that it will be useful for anyone who uses
@code{apertium-kaz} and maybe wants or needs to extend it with more stems or
other features. Most of the things said in this guide should be applicable to
Apertium's transducers for other Turkic languages as well.

@tt{Apertium-kaz} is a morphological transducer and disambiguator for Kazakh,
currently under development. It is intended to be compatible with transducers
for other Turkic languages so that they can be translated between. It's used in
the following translators (at various stages of development):

@itemize[

@item{@hyperlink["https://github.com/apertium/apertium-kaz-tat"]{Kazakh and Tatar}}

@item{@hyperlink["https://github.com/apertium/apertium-eng-kaz"]{English and
  Kazakh}}

@item{@hyperlink["https://github.com/apertium/apertium-kaz-rus"]{Kazakh and
  Russian}}

@item{@hyperlink["https://github.com/apertium/apertium-kaz-kir"]{Kazakh and Kyrgyz}}

@item{@hyperlink["https://github.com/apertium/apertium-kaz-kaa"]{Kazakh and
  Karakalpak}}

@item{@hyperlink["https://github.com/apertium/apertium-khk-kaz"]{Khalkha and
  Kazakh}}

@item{@hyperlink["https://github.com/apertium/apertium-kaz-kum"]{Kazakh and
Kumyk}}

@item{@hyperlink["https://github.com/apertium/apertium-kaz-tur"]{Kazakh and
Turkish}}

@item{@hyperlink["https://github.com/apertium/apertium-kaz-tyv"]{Kazakh and
Tuvan}}

@item{@hyperlink["https://github.com/apertium/apertium-nog-kaz"]{Nogai and Kazakh}}

@item{@hyperlink["https://github.com/apertium/apertium-kaz-sah"]{Kazakh and
Sakha}}

@item{@hyperlink["https://github.com/apertium/apertium-fin-kaz"]{Finnish and
  Kazakh}}

@item{@hyperlink["https://github.com/apertium/apertium-kaz-uig"]{Kazakh and
Uyghur}}

]

Its source code is available on
@hyperlink["https://github.com/apertium/apertium-kaz/"]{Github}. The code is
available under GNU General Public License version 3. Some of the annotated
data such as the Universal Dependencies treebank is available under Creative
Commons Attribution-Share Alike License.

@section{Extending @tt{apertium-kaz}}

First of all, note that there is an ongoing effort described
@hyperlink["https://taruen.com/apertiumpp/apertiumpp-kaz/"]{here} to extend
@tt{apertium-kaz} with stems from the 15-volume Explanatory Dictionary of
Kazakh and to proof-read the resulting lexicion (and maybe expand with
additional markup). After proof-reading is done, it's likely that the resulting
stem-list will replace the lexicon currently available in
@tt{apertium-kaz/apertium-kaz.kaz.lexc} (since the former is a superset of the
latter). If you want to help out with proof-reading the lexicon agaist the
aforementioned paper dictionary, contact Ilnar Salimzianov.

@subsection{Stems and categories}

To extend apertium-kaz with new words, we need to know their lemmas and their
categories. Below we list the possible categories of words (we ignore the
so-called closed-class words here, as their likelihood to appear among
unrecognized words at this stage is negligible, and simplify some of the
categories of open-class words intentionally).

@tabular[#:style 'boxed
         #:column-properties '(left left)
(list (list @bold{Category} @bold{Comment} @bold{Examples (from @tt{apertium-kaz.kaz.lexc} file)})
      (list @bold{Nouns} "" "")
      (list "N1" "common nouns" "алма:алма N1 ; ! “apple”")
      (list "" "" "жылқы:жылқы N1 ; ! “horse”")
      (list "N5" "nouns which are loanwords from Russian (and therefore potentially with exceptions in phonology)" "артист:артист N5 ; ! \"\"")
      (list "" "" "баррель:баррель N5 ; ! \"\"")
      (list "N6" "Linking nouns like акт, субъект, эффект to N6 forces apertium-kaz to analyse both акт and акті as noun, nominative; both актты and актіні as noun, accusative etc. The latter forms are the default — that is, акті and актіні are  generated for акт<n><nom> and акт<n><acc>, respectively, if @tt{apertium-kaz} is used as a morphological generator." "")
      (list "N1-ABBR" "Abbreviated nouns" "ДНҚ:ДНҚ%{а%} N1-ABBR ; ! \"DNA\"")
      (list "" "" "млн:млн%{а%}%{з%} N1-ABBR ; ! \"million\"")
      (list "" "" "млрд:млрд%{а%}%{с%} N1-ABBR ; ! \"billion\"")
      (list "" "" "км:км%{э%}%{з%} N1-ABBR ; ! \"km\"")
      (list @bold{Verbs} "" "")
      (list "V-TV" "transitive verbs" "")
      (list "V-IV" "intransitve verbs" "")
      (list "" "If the verb can take a direct object with -НЫ, then it's not IV; otherwise it is TV" "")
      (list @bold{Proper nouns} "" "")
      (list "NP-ANT-F" "feminine anthroponyms" @italic{Сәмиға})
      (list "NP-ANT-M" "masculine anthroponyms" @italic{Чыңғыз})
      (list "NP-COG-OB" "family names ending with -ов or -ев" @italic{Мусаев})
      (list "NP-COG-IN" "family names ending with -ин" @italic{Нуруллин})
      (list "NP-COG-M" "family names not ending with -ов, -ев or -in; masculine" @italic{Галицкий})
      (list "NP-COG-F" "family names not ending with -ов, -ев or -in; feminine" @italic{Толстая})
      (list "NP-COG-MF" "family names not ending with -ов, -ев or -in which can be both masculine and feminine" @italic{Гайдар})
      (list "NP-PAT-VICH" "patronymes ending with -вич (and thus which can also take the -вна ending)" @italic{Васильевич:Василье NP-PAT-VICH ; ! \"\"})
      (list "NP-TOP" "toponyms (river names should go here too)" @italic{Берлин})
      (list "NP-ORG" "organization names" @italic{Қазпошта})
      (list "NP-ORG-LAT" "organization names written in Latin characters" @italic{Microsoft})
      (list "NP-AL" "proper names not belonging to one of the above NP-* classes" @italic{Протон-М})
      (list "A1" "adjectives which can modify both nouns (жақсы адам) and verbs (жақсы оқиды)" "")
      (list "A2" "all other adjectives" @italic{көктемгі})
      (list "ADV" "adverbs" @italic{әбден})
      (list "" "If you want to add an adverb, first think whether the word is really an adjective that can be used like an adverb. If this is the case, then add it as an A1 adjective." ""))]

Figuring the lemma of an unrecognized word should be straightforward. Except
for verbs, where the lemmas in @tt{apertium-kaz} are 2nd person singular
imperative forms such as @tt{бар}, @tt{кел}, @tt{ал} etc (i.e. not @tt{бару},
@tt{келу}, @tt{алу} as in some of the print dictionaries), the lemmas are what
you would expect to see in print dictionaries of Kazakh.

Still, there are some things to keep in mind (we use the word ``stem'' and
``lemma'' interchangeably below):

@itemize[

@item{Many stems exhibit a voicing alternation like п/б, к/г, қ/ғ. This is
processed automatically by @tt{apertium-kaz.kaz.twol}, and such stems must be
added with the voiceless consonant (п, к, қ) to @tt{apertium-kaz.kaz.lexc}, e.g
@tt{тақ:тақ V-TV ;}}

@item{Stems from Russian that end with one of the voiced consonants (б, г),
such as геолог should be entered as spelled, but should be put in the right
category for foreign words (e.g., if a noun, then N5).}

@item{Words that have an inserted ‹ы› or ‹і› in some forms should get %{y%} in
that spot on the right side, e.g. орын:ор%{y%}н N1 ;}

@item{There should be no infinitival final -у or -ю. It is best to take the
part of the verb before -GAн or -DI in those forms.}

@item{Infinitives ending in -ю should end in ‹й› instead, e.g ‹сүю› should be
entered as сүй}

@item{Some verbs have a "hidden" ‹ы› or ‹і› under the ‹у›, for example ері,
аршы, аңды, etc. These verb stems should be added with the ‹ы› or ‹і›.}

@item{Of course, verbs with ‹у› in the stem should keep the ‹у›, like жу, қу,
жау, etc.}

@item{Do not add passive or cooperative forms of verb stems (e.g., ‹тартыл› is
passive of ‹тарт›, and ‹тартыс› is cooperative).}]

@subsection{Lexicons}

At the end of @code{apertium-kaz.kaz.lexc}, there are five lexicons:

@itemize[

@item{Common}
@item{Hardcoded}
@item{Abbreviations}
@item{Punctuation}
@item{Proper}]

In each lexicon, entries are sorted alphabetically with the
@code{LC_ALL=kk_KZ.utf8 sort} command.

These five lexicons are where you have to put new words, after you have figured
out their stems and categories following the guidelines above.

@code{Abbreviations} and @code{Punctuation} lexicons should be self-explanatory.

Any stem linked to lexicon starting with NP should be placed into @code{LEXICON
Proper}.

Any (temporary) entry which involves tags, e.g.

@verbatim{қыл%<v%>%<tv%>%<gna_perf%>:ғып # ; ! "same as қып"}

belongs to the @code{Hardcoded} section.

The rest of stems goes to @code{LEXICON Common}.

@section{A Constraint Grammar-based Universal Dependencies parser for Kazakh}

@subsection{How can I convert @tt{apertium-kaz}'s output into the CoNLL-U
format of the @hyperlink["https://universaldependencies.org/"]{Universal
Dependencies} project?}

While you are in the directory @tt{apertium-kaz}, run the following command:

@verbatim{

echo "Біздің елде сізге ерекше құрметпен қарайды." | apertium-destxt -n | \
apertium -f none -d . kaz-tagger | cg-conv -la | apertium-retxt | \
vislcg3 -g apertium-kaz.kaz.rlx | \
python3 ../ud-scripts/vislcg3-to-conllu.py "" 2> /dev/null | \
python3 ../ud-scripts/conllu-feats.py apertium-kaz.kaz.udx 2> /dev/null

}

where @tt{vislcg3-to-conllu.py} and @tt{conllu-feats.py} are scripts you can
find @hyperlink["https://github.com/taruen/ud-scripts"]{here}.

And this is the output you should expect for the above command:

@verbatim{
# sent_id = :1:0
# text = Біздің елде сізге ерекше құрметпен қарайды.
1       Біздің  біз     PRON    prn     Case=Gen|Number=Plur|Person=1|PronType=Prs      2       nmod:poss       _       _
2       елде    ел      NOUN    n       Case=Loc        6       obl     _       _
3       сізге   сіз     PRON    prn     Case=Dat|Number=Sing|Person=2|Polite=Form|PronType=Prs  6       obl     _       _
4       ерекше  ерекше  ADJ     adj     _       5       amod    _       _
5       құрметпен       құрмет  NOUN    n       Case=Ins        6       obl     _       _
6       қарайды қара    VERB    v       Mood=Ind|Number=Plur|Person=3|Tense=Aor|VerbForm=Fin    0       root    _       _
7       .       .       PUNCT   sent    _       6       punct   _       _
}

Now that we have a way of converting @tt{apertium-kaz}'s output into CoNLL-U
format, we can take sentences from the UD Kazakh treebank, i.e. the gold
standard, pass them through @tt{apertium-kaz}, convert them and compare
@tt{apertium-kaz}'s output against the gold standard. The mismatches we see
will serve us as a guide for Constrait Grammar rules in
@tt{apertium-kaz.kaz.rlx}.

For evaluating the output of the CG-based dependency parser you can use
@hyperlink["https://gist.github.com/IlnarSelimcan/aacde626a02efa243b819d56957576a8"]{this}
script. It is a relaxed version of the original CoNLL 2018
@hyperlink["https://universaldependencies.org/conll18/evaluation.html"]{evaluation
script} -- relaxed in the sense that for the time being we commented out
otherwise useful checks for cycles in dependency trees and tokenization
mismatches (Constraint Grammar-based parser we're currently working on, being
incomplete, makes such errors sometimes).

No guarantees are given at this point as regards the scores obtained in such a
way, the only thing we can tell is that if we take only the first handful
sentences from the treebank and evaluate CG parser's output on them, we get
100% LAS score, as we should, since we know that they were covered by CG rules
and are perfectly parsed (with the caveat that temporarily we use
@tt{Makefile.am} and @tt{apertium-kaz.kaz.lexc} taken from
@hyperlink["https://taruen.com/apertiumpp/apertiumpp-kaz/"]{apertium@bold{pp}-kaz}).

Also see the @tt{test.rkt} file.

Parsing the first 2 sentences (lines 0-24 in the @tt{puupankki.kaz.conllu}
file) with CG parser and evaluating its output:

@verbatim{
apertium-kaz$ python3 ~/conll18_ud_eval_lax.py --verbose \
<(head -n 24 texts/puupankki/puupankki.kaz.conllu) \
<(head -n 24 texts/puupankki/puupankki.kaz.conllu | grep "# text = " | \
sed 's/# text = //g' | apertium-destxt -n | apertium -f none -d . kaz-tagger | \
cg-conv -la | apertium-retxt | vislcg3 -g apertium-kaz.kaz.rlx | \
python3 ../ud-scripts/vislcg3-to-conllu.py "" 2> /dev/null | \
python3 ../ud-scripts/conllu-feats.py apertium-kaz.kaz.udx 2> /dev/null)

Metric     | Precision |    Recall |  F1 Score | AligndAcc
-----------+-----------+-----------+-----------+-----------
Tokens     |    100.00 |    100.00 |    100.00 |
Sentences  |     66.67 |    100.00 |     80.00 |
Words      |    100.00 |    100.00 |    100.00 |
UPOS       |    100.00 |    100.00 |    100.00 |    100.00
XPOS       |    100.00 |    100.00 |    100.00 |    100.00
UFeats     |     94.44 |     94.44 |     94.44 |     94.44
AllTags    |     94.44 |     94.44 |     94.44 |     94.44
Lemmas     |     94.44 |     94.44 |     94.44 |     94.44
UAS        |    100.00 |    100.00 |    100.00 |    100.00
LAS        |    100.00 |    100.00 |    100.00 |    100.00
CLAS       |    100.00 |    100.00 |    100.00 |    100.00
MLAS       |     92.31 |     92.31 |     92.31 |     92.31
BLEX       |     92.31 |     92.31 |     92.31 |     92.31
}

Parsing the first 5 sentences (lines 0-55 in the @tt{puupankki.kaz.conllu}
file) with CG parser and evaluating its output:

@verbatim{
apertium-kaz$ python3 ~/conll18_ud_eval_lax.py --verbose \
<(head -n 55 texts/puupankki/puupankki.kaz.conllu) \
<(head -n 55 texts/puupankki/puupankki.kaz.conllu | grep "# text = " | \
sed 's/# text = //g' | apertium-destxt -n | apertium -f none -d . kaz-tagger | \
cg-conv -la | apertium-retxt | vislcg3 -g apertium-kaz.kaz.rlx | \
python3 ../ud-scripts/vislcg3-to-conllu.py "" 2> /dev/null | \
python3 ../ud-scripts/conllu-feats.py apertium-kaz.kaz.udx 2> /dev/null)

Metric     | Precision |    Recall |  F1 Score | AligndAcc
-----------+-----------+-----------+-----------+-----------
Tokens     |    100.00 |    100.00 |    100.00 |
Sentences  |     83.33 |    100.00 |     90.91 |
Words      |    100.00 |    100.00 |    100.00 |
UPOS       |    100.00 |    100.00 |    100.00 |    100.00
XPOS       |    100.00 |    100.00 |    100.00 |    100.00
UFeats     |     97.50 |     97.50 |     97.50 |     97.50
AllTags    |     97.50 |     97.50 |     97.50 |     97.50
Lemmas     |     97.50 |     97.50 |     97.50 |     97.50
UAS        |     77.50 |     77.50 |     77.50 |     77.50
LAS        |     77.50 |     77.50 |     77.50 |     77.50
CLAS       |     76.67 |     76.67 |     76.67 |     76.67
MLAS       |     73.33 |     73.33 |     73.33 |     73.33
BLEX       |     73.33 |     73.33 |     73.33 |     73.33
}