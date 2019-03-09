#lang scribble/manual

@title{@tt{APERTIUM-KAZ}: A MORPHOLOGICAL TRANSDUCER AND DISAMBIGUATOR FOR
 KAZAKH}

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
